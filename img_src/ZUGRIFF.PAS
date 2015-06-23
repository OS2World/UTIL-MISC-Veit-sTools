(*$I IMG_COMP.PAS*)

unit zugriff; (* Zugriff, Zeit, Fehler *)

interface

type
  word_ptr=^word;
  longint_ptr=^longint;
  string_ptr=^string;

  datei_oder_laufwerk_info_typ=
    record
      geoeffnet:boolean;
      position:longint;
      groesse:longint;

      case datei_oder_laufwerk:char of
        'D':(dateihandhabe:file;
             );
        'L':(
             (*$IFDEF OS2*)
             laufwerkshandhabe:longint;
             laufwerksbuchstabe:char;
             (*$ELSE*)
             laufwerksnummer:byte;
             (*$ENDIF*)
             );

    end;
  zeitblock_typ=
    record
      stunde,minute,sekunde,hunderstel:
        (*$IFDEF OS2*)
        longint;
        (*$ELSE*)
        word;
        (*$ENDIF*)
    end;


  (*$IFNDEF OS2*)
  int2526_block_typ=
    record
      sektornummer:longint;
      blockzahl:word;
      puffer_zeiger:pointer;
    end;

  (*$ENDIF*)

  (*$IFDEF OS2*)
  lesegroesse=longint;
  (*$ELSE*)
  lesegroesse=word;
  (*$ENDIF*)

var
  reaktion_auf_fehler:(fragen,immer_ignorieren,immer_wiederholen);
  startzeit:zeitblock_typ;
  anzahl_anzuzeigender_ziffern_ist_gross:boolean;
  gesichertes_ende_sauber_beenden:pointer;
  hand:array[1..2] of datei_oder_laufwerk_info_typ;
  para:array[1..2] of string;
  schliess_fehler_egal:boolean;

procedure abbruch(t:string);
procedure writeln_clreol(t:string);
procedure esc_test;
function zeitanzeige:string;
function strf(w:word):string;
function tausenderpunkt(l:longint):string;
procedure strich;
procedure initialisiere_hand(var handhabe:datei_oder_laufwerk_info_typ);
procedure oeffne(name:string;var handhabe:datei_oder_laufwerk_info_typ;nur_zum_lesen:boolean);
procedure lies(var handhabe:datei_oder_laufwerk_info_typ;var puffer;anzahl_forderung:longint);
procedure schreibe(var handhabe:datei_oder_laufwerk_info_typ;var puffer;anzahl_forderung:longint);
procedure springe_physikalisch(var handhabe:datei_oder_laufwerk_info_typ;posi:longint);
procedure schliesse(var handhabe:datei_oder_laufwerk_info_typ);
procedure sauber_beenden_hand;
procedure test_groessenproblem(logische_groesse:longint);


implementation

uses img_spra,popup,strnull,crt,dos(*$IFDEF OS2*),os2base,os2def(*$ENDIF*);

var
  pop_sich:popup_sicherung_typ;

procedure abbruch(t:string);
  begin
    if t='' then
      writeln(#7)
    else
      writeln(#13#10,t,#7);
    halt;
  end;

procedure writeln_clreol(t:string);
  begin
    write(t);
    clreol;
    writeln;
  end;

procedure esc_test;
  begin
    if keypressed then
      if readkey=#27 then abbruch(textz_Abbruch_durch_den_Benutzer^);
  end;

function zeitanzeige:string;
  var
    stopzeit:zeitblock_typ;
    diff:longint;
    tmpzk:string;
  begin
    gettime(stopzeit.stunde,stopzeit.minute,stopzeit.sekunde,stopzeit.hunderstel);
    diff:=(longint(stopzeit.sekunde )+longint(stopzeit.minute )*60+longint(stopzeit.stunde )*60*60)
         -(longint(startzeit.sekunde)+longint(startzeit.minute)*60+longint(startzeit.stunde)*60*60);

    while diff<0 do inc(diff,24*60*60);
    str(diff,tmpzk);
    zeitanzeige:='  ( '+tmpzk+' s )';
  end;

{!!}function strf(w:word):string;
  var
    tmp:string[5];
  begin
    str(w,tmp);
    strf:=tmp;
  end;

function tausenderpunkt(l:longint):string;
  var
    tmpzk:string;
  begin
    if anzahl_anzuzeigender_ziffern_ist_gross then
      begin
        str(l:12,tmpzk);
        tausenderpunkt:=copy(tmpzk,1,3)+'.'+copy(tmpzk,4,3)+'.'+copy(tmpzk,7,3)+'.'+copy(tmpzk,10,3);
      end
    else
      begin
        str(l:9,tmpzk);
        tausenderpunkt:=copy(tmpzk,1,3)+'.'+copy(tmpzk,4,3)+'.'+copy(tmpzk,7,3);
      end
  end;

procedure strich;
  begin
    writeln('ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');
  end;

(*$IFDEF OS2*)
function bestimme_ifs(laufwerk:char):string;
  var
    fehler:word;
    laufwerk_zk:string[3];
    ifs_puffer:Array[0..sizeof(FSQBUFFER2) + (3 * CCHMAXPATH)] of char;
    ifs_puffer_groesse:longint;
    ifsname_pos:word;
  begin
    fillchar(ifs_puffer,sizeof(ifs_puffer),0);
    laufwerk_zk:=laufwerk+':'+#0;
    ifs_puffer_groesse:=sizeof(ifs_puffer);

    fehler:=DosQueryFSAttach(pchar(@laufwerk_zk[1]),1,FSAIL_QUERYNAME,pFsqBuffer2(@ifs_puffer),ifs_puffer_groesse);

    ifsname_pos:=8;
    while ifs_puffer[ifsname_pos]<>#0 do
      inc(ifsname_pos);

    inc(ifsname_pos);
    bestimme_ifs:=str0(ifs_puffer[ifsname_pos]);
  end;
(*$ENDIF*)

procedure initialisiere_hand(var handhabe:datei_oder_laufwerk_info_typ);
  begin
    handhabe.geoeffnet   :=false;
  end;

procedure oeffne(name:string;var handhabe:datei_oder_laufwerk_info_typ;nur_zum_lesen:boolean);
(*$IFDEF OS2*)
  var
    laufwerk_zk:string[3];
    ulAction:longint;
    fehler:longint;
    openflag:longint;
    nullbefehl_laenge:longint;
    neues_ifs_name_laenge:longint;
    ifs_name:string;
  const
    nullbefehl:byte=0;
    neues_ifs_name:string=#0;

  (*$ELSE*)
  var
    lauf:byte;
    sektorgroesse:word;
    bootsektor:array[0..512-1] of byte;
    bootsektor_lesefehler:lesegroesse;
    fehler:word;
  (*$ENDIF*)

  begin
    handhabe.geoeffnet:=true;
    handhabe.position:=0;

    if (copy(name,2,1)=':') and (length(name)=2) and (upcase(name[1]) in ['A'..'`']) then
      begin
        handhabe.datei_oder_laufwerk:='L';

        write(textz_OEffne_Laufwerk_^,name[1],' ');

        handhabe.groesse:=disksize(ord(upcase(name[1]))-ord('A')+1);
        if handhabe.groesse<=0 then
          abbruch(textz_Laufwerk_nicht_bereit_^);


        (*$IFDEF OS2*)
        handhabe.laufwerksbuchstabe:=upcase(name[1]);
        laufwerk_zk[1]:=handhabe.laufwerksbuchstabe;
        laufwerk_zk[2]:=':';
        laufwerk_zk[3]:=#0;

        if nur_zum_lesen then
          openflag:=OPEN_FLAGS_DASD or OPEN_SHARE_DENYNONE or OPEN_ACCESS_READONLY
        else
          openflag:=OPEN_FLAGS_DASD or OPEN_SHARE_DENYNONE or OPEN_ACCESS_WRITEONLY;


        fehler:=DosOpen(@laufwerk_zk[1],handhabe.laufwerkshandhabe,ulAction,0,0,FILE_OPEN,openflag
                ,
                nil);
        if fehler<>0 then
          abbruch(textz_Kann_Laufwerk_nicht_OEffnen_^);

        ifs_name:=bestimme_ifs(name[1]);

        write('[',ifs_name,']');
(*      if ifs_name='CDFS' then
          begin
            if not nur_zum_lesen then
              abbruch('Schreiben auf CDFS hat keinen Sinn !');
          end; *)

        nullbefehl_laenge:=0;
        fehler:=DosDevIOCtl(handhabe.laufwerkshandhabe,IOCTL_DISK,DSK_LOCKDRIVE,
                            @nullbefehl,1,@nullbefehl_laenge,
                            nil,0,nil);
        if fehler<>0 then
          abbruch(textz_Lock_fehlgeschlagen_offene_Datein_^);


        fehler:=DosSetFilePtr(handhabe.laufwerkshandhabe,
                      0,
                      FILE_END,
                      handhabe.groesse);
        if fehler<>0 then
          abbruch(textz_kann_Laufwerksgroesse_nicht_bestimmen_^);


        if ifs_name<>'CDFS' then
          begin
            fehler:=DosDevIOCtl(handhabe.laufwerkshandhabe,IOCTL_DISK,DSK_BEGINFORMAT,
                                @neues_ifs_name[1],length(neues_ifs_name),@neues_ifs_name_laenge,
                                @nullbefehl,1,@nullbefehl_laenge);
            if fehler<>0 then
              abbruch(textz_kann_Dateisystem_nicht_entfernen_^);
          end;

        (*$ELSE*)
        handhabe.laufwerksnummer:=ord(upcase(name[1]))-ord('A')+1;
        lauf:=handhabe.laufwerksnummer;
        asm
          push ds
            mov ah,$1c
            mov dl,lauf
            int $21
            mov sektorgroesse,cx
          pop ds
        end;

        if sektorgroesse<>512 then
          abbruch(textz_Sektorgroesse_ist_nicht_512_Byte_^);

        handhabe.groesse:=512; (* es reicht fÅr den Bootsektor ... *)

        fillchar(bootsektor,sizeof(bootsektor),0);
        lies(handhabe,bootsektor,512);
        if (bootsektor[512-2]<>$55)
        or (bootsektor[512-1]<>$AA)
         then
          abbruch(textz_kann_Bootsektor_nicht_auswerten_^);

        handhabe.position:=0;
        handhabe.groesse:=word_ptr(@bootsektor[$13])^;
        if handhabe.groesse=0 then
          handhabe.groesse:=longint_ptr(@bootsektor[$20])^;

        handhabe.groesse:=handhabe.groesse*512;
        (*$ENDIF*)
      end
    else
      begin
        handhabe.datei_oder_laufwerk:='D';

        write(textz_OEffne_Datei_^,name,' ');
        assign(handhabe.dateihandhabe,name);
        (*$I-*)
        if nur_zum_lesen then
          begin
            filemode:=$40;
            reset(handhabe.dateihandhabe,1);
          end
        else
          begin
            filemode:=$42;
            rewrite(handhabe.dateihandhabe,1);
          end;
        (*$I+*)

        fehler:=ioresult;
        if fehler<>0 then
          abbruch(textz_Fehler_^+strf(fehler)+textz__beim_OEffnen^);

        (*$I-*)
        handhabe.groesse:=filesize(handhabe.dateihandhabe);
        (*$I+*)
        fehler:=ioresult;

        if fehler<>0 then
          handhabe.groesse:=0; (* FILESIZE \DEV\NUL ... *)

        fehler:=ioresult;
        if ((handhabe.groesse<=0) and nur_zum_lesen) then
          abbruch(textz_Beschaedigte_Datei_^);

      end;
    writeln;
  end;

procedure lies(var handhabe:datei_oder_laufwerk_info_typ;var puffer;anzahl_forderung:longint);
  var
    fehler:longint;
    taste:char;
    anzahl:longint;
    gelesen:lesegroesse;
  (*$IFNDEF OS2*)
    lauf:byte;
    int25_block:int2526_block_typ;
    int25fehler:word;
  (*$ENDIF*)

  begin
    repeat
      anzahl:=anzahl_forderung;
      repeat
        case handhabe.datei_oder_laufwerk of
          'D':
            begin
              (*$I-*)
              seek(handhabe.dateihandhabe,handhabe.position);
              (*$I+*)
              fehler:=ioresult;
              (*$I-*)
              blockread(handhabe.dateihandhabe,puffer,anzahl,gelesen);
              (*$I+*)
              fehler:=ioresult;
            end;
          'L':
            begin
              (*$IFDEF OS2*)
              fehler:=DosSetFilePtr(handhabe.laufwerkshandhabe,
                        handhabe.position,
                        FILE_BEGIN,
                        handhabe.position);
              fehler:=DosRead(handhabe.laufwerkshandhabe,
                        puffer,
                        anzahl,
                        gelesen);
              (*$ELSE*)
              lauf:=handhabe.laufwerksnummer-1;
              with int25_block do
                begin
                  sektornummer:=handhabe.position div 512;
                  blockzahl:=anzahl div 512;
                  puffer_zeiger:=@puffer;
                end;

              asm
                push ds
                  mov al,lauf
                  mov cx,-1
                  mov dx,ss
                  mov ds,dx
                  mov bx,offset int25_block
                  add bx,bp
                  int $25
                  jc @int_25_ende

                  sub ax,ax

  @int_25_ende:
                  popf
                pop ds

                mov int25fehler,ax

              end;

              if int25fehler=0 then
                gelesen:=anzahl
              else
                gelesen:=0;
              (*$ENDIF*)
            end;
        end;

        if (gelesen=0) then
          (* Fehlerbehandlung Lesen ... *)
          begin
            case reaktion_auf_fehler of
              fragen:
                begin
                  popup_ein(pop_sich);
                  write  (textz__Lesefehler_^); if fehler<>0 then write('('+strf(fehler)+')');writeln;
                  writeln;
                  writeln('   '+textz__a_bbrechen^);            (* A/A *)
                  writeln('   '+textz__w_iederholen^);          (* W/R *)
                  writeln('   '+textz__i_gnorieren^);           (* I/I *)
                  writeln('   '+textz__e_wig_probieren^);       (* E/E *)
                  write  ('   '+textz_i_m_mer_ignorieren___^);  (* M/L *)
                  repeat
                    taste:=upcase(readkey);
                    if taste='R' then taste:='W';
                    if taste='L' then taste:='M';
                  until taste in [#27,'A','W','I','E','M'];
                  popup_aus(pop_sich);
                end;
              immer_ignorieren:
                begin
                  esc_test;
                  taste:='M';
                end;
              immer_wiederholen:
                begin
                  esc_test;
                  taste:='E';
                end;
            end;

            if taste='E' then
              begin
                reaktion_auf_fehler:=immer_wiederholen;
                write('W');
              end;

            if taste='M' then
              begin
                reaktion_auf_fehler:=immer_ignorieren;
                write('I');
              end;

            case taste of
              #27,'A':abbruch(textz_Abbruch_durch_den_Benutzer^);
              'W','E':anzahl:=512; (* in kleineren HÑppchen *)
              'I','M':
                  begin
                    gelesen:=anzahl;
                    break;
                  end;
            end;
          end;
      until (gelesen<>0) or (handhabe.groesse=handhabe.position);
      inc(handhabe.position,anzahl);
      dec(anzahl_forderung,anzahl);
    until anzahl_forderung=0;
  end;

procedure schreibe(var handhabe:datei_oder_laufwerk_info_typ;var puffer;anzahl_forderung:longint);
  var
    fehler:longint;
    geschrieben:lesegroesse;
    taste:char;
    anzahl:longint;
  (*$IFNDEF OS2*)
    lauf:byte;
    int26_block:int2526_block_typ;
    int26fehler:word;
  (*$ENDIF*)

  begin
    repeat
      anzahl:=anzahl_forderung;
      repeat
        case handhabe.datei_oder_laufwerk of
          'D':
            begin
              (*$I-*)
              seek(handhabe.dateihandhabe,handhabe.position);
              (*$I+*)
              fehler:=ioresult;

              (*$I-*)
              blockwrite(handhabe.dateihandhabe,puffer,anzahl,geschrieben);
              (*$I+*)
              fehler:=ioresult;
            end;
          'L':
            begin
              (*$IFDEF OS2*)
              fehler:=DosSetFilePtr(handhabe.laufwerkshandhabe,
                        handhabe.position,
                        FILE_BEGIN,
                        handhabe.position);
              fehler:=DosWrite(handhabe.laufwerkshandhabe,
                        puffer,
                        anzahl,
                        geschrieben);
              (*$ELSE*)
              lauf:=handhabe.laufwerksnummer-1;
              with int26_block do
                begin
                  sektornummer:=handhabe.position div 512;
                  blockzahl:=anzahl div 512;
                  puffer_zeiger:=@puffer;
                end;

              asm
                push ds
                  mov al,lauf
                  mov cx,-1
                  mov dx,ss
                  mov ds,dx
                  mov bx,offset int26_block
                  add bx,bp
                  int 3
                  int $26
                  jc @int_26_ende

                  sub ax,ax

  @int_26_ende:
                  popf
                pop ds

                mov int26fehler,ax

              end;

              if int26fehler=0 then
                geschrieben:=anzahl
              else
                geschrieben:=0;
              (*$ENDIF*)
            end;
        end;

        if geschrieben=0 then
          (* Fehlerbehandlung Schreiben ... *)
          begin
            case reaktion_auf_fehler of
              fragen:
                begin
                  popup_ein(pop_sich);
                  write  (textz__Schreibfehler_^); if fehler<>0 then write('('+strf(fehler)+')');writeln;
                  writeln('   '+textz__a_bbrechen^);            (* A/A *)
                  writeln('   '+textz__w_iederholen^);          (* W/R *)
                  writeln('   '+textz__i_gnorieren^);           (* I/I *)
                  writeln('   '+textz__e_wig_probieren^);       (* E/E *)
                  write  ('   '+textz_i_m_mer_ignorieren___^);  (* M/L *)
                  repeat
                    taste:=upcase(readkey);
                    if taste='R' then taste:='W';
                    if taste='L' then taste:='M';
                  until taste in [#27,'A','W','I','E','M'];
                  popup_aus(pop_sich);
                end;
              immer_ignorieren:
                begin
                  esc_test;
                  taste:='M';
                end;
              immer_wiederholen:
                begin
                  esc_test;
                  taste:='E';
                end;
            end;

            if taste='E' then
              begin
                reaktion_auf_fehler:=immer_wiederholen;
                write('W');
              end;

            if taste='M' then
              begin
                reaktion_auf_fehler:=immer_ignorieren;
                write('I');
              end;

            case taste of
              #27,'A':abbruch(textz_Abbruch_durch_den_Benutzer^);
              'W','E':;
              'I','M':
                  begin
                    geschrieben:=anzahl;
                    break;
                  end;
            end;
          end;
      until geschrieben<>0;
      inc(handhabe.position,geschrieben);
      dec(anzahl_forderung,geschrieben);
    until anzahl_forderung=0;
  end;

procedure springe_physikalisch(var handhabe:datei_oder_laufwerk_info_typ;posi:longint);
  begin
    handhabe.position:=posi;
  end;

procedure schliesse(var handhabe:datei_oder_laufwerk_info_typ);
  (*$IFDEF OS2*)
  var
    fehler:longint;
    nullbefehl_laenge:longint;
    ifs_name:string;
  const
    nullbefehl:byte=0;

  (*$ENDIF*)
  (*$IFDEF DOS*)
  var
    fehler:word;
  (*$ENDIF*)
  begin
    case handhabe.datei_oder_laufwerk of
      'D':
          begin
            (*$I-*)
            writeln('Schlie·e Datei');
            close(handhabe.dateihandhabe);
            (*$I+*)
            fehler:=ioresult;
          end;
      'L':
          begin
            (*$IFDEF OS2*)
            write(textz_Schliesse_Laufwerk_Neubestimmumg_Dateisystem^);
            fehler:=DosDevIOCtl(handhabe.laufwerkshandhabe,IOCTL_DISK,DSK_REDETERMINEMEDIA,
                                @nullbefehl,1,@nullbefehl_laenge,
                                nil,0,nil);
            if fehler<>0 then
              writeln(textz_Fehler_^+'(',fehler,')');

            nullbefehl_laenge:=0;
            fehler:=DosDevIOCtl(handhabe.laufwerkshandhabe,IOCTL_DISK,DSK_UNLOCKDRIVE,
                                @nullbefehl,1,@nullbefehl_laenge,
                                nil,0,nil);
            if fehler<>0 then
              writeln('UNLock-'+textz_Fehler_^+'(',fehler,')');

            fehler:=DosClose(handhabe.laufwerkshandhabe);
            if fehler<>0 then
              writeln('DosClose-'+textz_Fehler_^+' (',fehler,')');

            ifs_name:=bestimme_ifs(handhabe.laufwerksbuchstabe);
            writeln('[',ifs_name,']');
            (*$ELSE*)
            (* nichts *)
            (*$ENDIF*)
          end;

    end;
    handhabe.geoeffnet:=false;
  end;

(*$F+*)
procedure sauber_beenden_hand;
  begin
    exitproc:=gesichertes_ende_sauber_beenden;

    schliess_fehler_egal:=true;

    if hand[1].geoeffnet then
      schliesse(hand[1]);

    if hand[2].geoeffnet then
      schliesse(hand[2]);

    strich;
  end;
(*$F-*)

procedure test_groessenproblem(logische_groesse:longint);
  begin
    if hand[2].datei_oder_laufwerk='L' then
      begin
        if hand[2].groesse<logische_groesse then
          begin
            writeln;
            writeln(textz_Das_Ziellaufwerk_ist_zu_klein_um_alle_Daten_zu_schreiben^);
            writeln(textz_mindestens_notwendig_sind^,logische_groesse div 1024,' KB !');
            abbruch('');
          end;
        if hand[2].groesse>logische_groesse then
          begin
            writeln(textz_WARNUNG_Ziel_ist_groesser_als_die_Quelle^);
            write  (textz_fortfahren^);
            if not (upcase(readkey) in ['Y','J']) then
              abbruch('');
            writeln;
          end;
      end;
  end;

begin
  reaktion_auf_fehler:=fragen;
  gettime(startzeit.stunde,startzeit.minute,startzeit.sekunde,startzeit.hunderstel);
end.

