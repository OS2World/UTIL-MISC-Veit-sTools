(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

(*  $Define HOLEN_COM*)
unit typ_bios;

interface

uses
  typ_type;

procedure ermittle_bios_hersteller(
            const titel                 :string;
                  bestimme_bios_kennwort,
                  hole_cmos_aus_datei,
                  quelle_ist_datei      :boolean;
                  ende_off,
                  max_rueckwaerts       :longint);

implementation

uses
  (*$IfDef HOLEN_COM*)
  Dos,
  (*$EndIf*)
  typ_var,
  typ_eiau,
  typ_ausg,
  typ_varx,
  typ_dien,
  typ_spra,
  typ_entp,
  typ_for3,
  typ_for4;

procedure ermittle_bios_hersteller(
            const titel                 :string;
                  bestimme_bios_kennwort,
                  hole_cmos_aus_datei,
                  quelle_ist_datei      :boolean;
                  ende_off,
                  max_rueckwaerts       :longint);

  type
    bios_hersteller_typ=(verdeckt,unbekannt,award,ami_alt,ami_neu,quadtel,chips,
                         phoenix,microid_research,linux,ibm,acer,compaq,ibm_ps2,
                         olivetti,icl,bochs,systemsoft,systemsoft_boot,systemsoft_alt,
                         toshiba,tinybios,
                         award_gepackt);

  const
    grossbuchstaben     :string[27]='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    kleinbuchstaben     :string[27]='abcdefghijklmnopqrstuvwxyz';
    ziffern             :string[10]='0123456789';
    rest                :string[33]=' !"#$%&''()*+,-./' + ':;<=>?@' + '[\]^_`'+#123+'|'+#125+'~';
    pos_bios_datum_jahr =1;
    pos_bios_datum_monat=pos_bios_datum_jahr +Length('1999.');
    pos_bios_datum_tag  =pos_bios_datum_monat+Length('12.'  );

  var
    bios_datum          :string[10];
    ec60                :word;
    zulaessig           :string;
    bios_hersteller     :bios_hersteller_typ;

    cmos_puffer         :puffertyp;

    ami_admin_pw_index,
    ami_user_pw_index   :smallword;

    l1                  :longint;
    f1                  :dateigroessetyp;
    anfang_min          :longint;

(**************************************************************************)
(*  Hilfsprozeduren                                                       *)
(**************************************************************************)

  function pruefe_amiboot_rom(b:puffertyp):boolean;
    begin
      pruefe_amiboot_rom:=
           bytesuche(b.d[0],'AMIBOOT ROM')
        or bytesuche(b.d[4],'AMIBOOT ROM')
        or bytesuche(b.d[0],'AMIBOOT BIO')
        or bytesuche(b.d[4],'AMIBOOT BIO');
    end;


  procedure lies(var b:puffertyp;const stelle:longint;const wieviel:word);
    begin
      {if quelle_ist_datei then}
        datei_lesen(b,ende_off-$100000+stelle,wieviel)
      {else
        speicher_lesen(stelle div 16,stelle mod 16,b,wieviel)};
    end;

  function cmos(const index_:byte):byte;
    var
      wert:byte;
    begin
      if not hole_cmos_aus_datei then
        begin
          (*$IfDef DOS*)
          asm cli end;
          (*$EndIf*)
          Port[$70]:=$0A;
          while (Port[$71]>=$80) do ;
          Port[$70]:=index_ or $80;
          wert:=Port[$71];
          (*$IfDef DOS*)
          asm sti end;
          (*$EndIf*)
        end
      else
        begin
          wert:=cmos_puffer.d[index_];
        end;

      cmos:=wert;
      if signaturen then
        ausschrift('CMOS ['+str_(index_,2)+'] = '+str_(wert,3),signatur);
    end;

  function us_tastatur(const zk1:string):string;
    var
      z                 :byte;
      zktmp             :string;
    begin
      zktmp:=zk1;
      for z:=1 to Length(zktmp) do
        case zktmp[z] of
          (* Y/Z *)
          'Z':zktmp[z]:='Y';
          'z':zktmp[z]:='y';
          'Y':zktmp[z]:='Z';
          'y':zktmp[z]:='z';
          (* ö*ôé#,.- *)
          #123:zktmp[z]:='ö';
          '[':zktmp[z]:='Å';
          ']':zktmp[z]:='+';
          #125:zktmp[z]:='*';
          ':':zktmp[z]:='ô';
          ';':zktmp[z]:='î';
          '"':zktmp[z]:='é';
          '''':zktmp[z]:='Ñ';
          '\':zktmp[z]:='#';
          '|':zktmp[z]:='''';
          ',':zktmp[z]:=',';
          '<':zktmp[z]:=';';
          '.':zktmp[z]:='.';
          '>':zktmp[z]:=':';
          '/':zktmp[z]:='-';
          '?':zktmp[z]:='_';

          (* ^!"$%&/()=?` *)
          '`':zktmp[z]:='^';
          '~':zktmp[z]:='¯';
          '!':zktmp[z]:='!';
          '@':zktmp[z]:='"';
          '#':zktmp[z]:='';
          '$':zktmp[z]:='$';
          '%':zktmp[z]:='%';
          '^':zktmp[z]:='&';
          '&':zktmp[z]:='/';
          '*':zktmp[z]:='(';
          '(':zktmp[z]:=')';
          ')':zktmp[z]:='=';
          '-':zktmp[z]:='·';
          '_':zktmp[z]:='?';
          '=':zktmp[z]:='''';
          '+':zktmp[z]:='`';
        end;
      us_tastatur:=zktmp;
    end;

  function kw_auch_us_tastatur(const s:string):string;
    var
      u                 :string;
      {$IfNDef VirtualPascal}
      result            :string;
      {$EndIf}
    begin
      Result:=in_doppelten_anfuerungszeichen(s);
      u:=us_tastatur(s);
      if u<>s then
        Result:=Result+' ('+in_doppelten_anfuerungszeichen(u)+')';
      {$IfNDef VirtualPascal}
      kw_auch_us_tastatur:=result;
      {$EndIf}
    end;

  function scancode_zu_ascii(const b:byte):string;
    const
      normtast:array[1..$35] of char='?'                          (* $01 *)
                                   +'1234567890·'+'??'            (* $02-$0e *)
                                   +'?'+'qwertzuiopÅ+'+'?'        (* $0f-$1c *)
                                   +'?'
                                   +'asdfghjklîÑ'+'??'+'#'        (* $1e-$28 .. $2b *)
                                   +(* < *) 'yxcvbnm,.-';         (* $2c-$35 *)
      var
        z:string[30];
    begin
      z:='?';
      if b in [low(normtast)..high(normtast)] then
        z:=normtast[b];

      if z='?' then
        case b of
          $01:z:='[Esc]';
          $0d:z:='?';
          $0e:z:='`';
          $0f:z:='[Tab]';
          $39:z:=' ';
          $3b..$44:z:='[F'+str0(b-$3b+1)+']';
          $56:z:='<';
        else
              z:=textz_Taste_mit_Scancode^+str0(b)+']';
        end;
      scancode_zu_ascii:=z;
    end;


(**************************************************************************)
(*      Einzelprozeduren fÅr verschiedene Hersteller                      *)
(**************************************************************************)

(* AMI-BIOS von VPC 5, mit ADMIN/USER *)
function ami_pw2(const cmos_index:word_norm):string;
  var
    cpuffer             :array[0..6+1] of byte;
    entschluesselungs_wert:byte;
    entschluesselt      :string[6];
    bl_                 :byte;
    zaehler             :word_norm;
  begin

    for zaehler:=Low(cpuffer) to High(cpuffer) do
      cpuffer[zaehler]:=cmos(cmos_index+zaehler);

    entschluesselt:='';

    bl_:=$80;

    asm
      (*$IfDef VirtualPascal*)
      lea esi,cpuffer
      lea edi,entschluesselt+1
      (*$Else*)
      lea si,cpuffer
      lea di,entschluesselt+1
      (*$EndIf*)

    @zeichenschleife:
      mov entschluesselungs_wert,0
      (*$IfDef VirtualPascal*)
      cmp byte ptr ss:[esi],0
      (*$Else*)
      cmp byte ptr ss:[si],0
      (*$EndIf*)
      je @fertig

    @versuchs_schleife:
      mov bl,bl_
      mov al,entschluesselungs_wert

      (*******************************************)

    @label_ungleich:
      test bl,$c3
      jp @label_jp

      stc

    @label_jp:

      rcr bl,1
      dec al
      jnz @label_ungleich

      (*******************************************)

      (*$IfDef VirtualPascal*)
      cmp bl,ss:[esi]
      (*$Else*)
      cmp bl,ss:[si]
      (*$EndIf*)
      jz @erfolg

      inc entschluesselungs_wert
      jmp @versuchs_schleife

    @erfolg:
      mov bl_,bl
      inc cx
      inc byte ptr entschluesselt (* LÑnge *)
      mov al,entschluesselungs_wert
      (*$IfDef VirtualPascal*)
      mov ss:[edi],al
      inc esi
      inc edi
      (*$Else*)
      mov ss:[di],al
      inc si
      inc di
      (*$EndIf*)

      cmp byte ptr entschluesselt,6
      jbe @zeichenschleife

    @fertig:

    end;

    ami_pw2:=entschluesselt;
  end;

(* AMI-BIOS mit nur einem Kennwort: Stobernack,Jost *)
(* gute Suchfolge: d0 db (rcr bl,1)

seg000:F12B                 mov     si, offset aEnterCurrentPa
seg000:F12E                 call    ausschrift
seg000:F131                 call    lies_cmos_passw
seg000:F134                 mov     bh, 0B8h ; '∏'
seg000:F136                 mov     al, 0B7h ; '∑'
seg000:F138                 call    cal_lies_cmos
seg000:F13B                 and     al, 0F0h
seg000:F13D                 mov     bl, al
seg000:F13F loc_0_F13F:
seg000:F13F                 call    pw_zeichen_eingabe
seg000:F142                 jz      loc_0_F163
seg000:F144                 jb      loc_0_F161
seg000:F146                 call    pw_verschluesselung
seg000:F149                 mov     al, bh
seg000:F14B                 inc     bh
seg000:F14D                 call    cal_lies_cmos
seg000:F150                 cmp     al, bl
seg000:F152                 jnz     loc_0_F158


seg000:F315 pw_verschluesselung proc near
seg000:F315                 test    bl, 0C3h
seg000:F318                 jp      loc_0_F31B
seg000:F31A                 stc
seg000:F31B loc_0_F31B:
seg000:F31B                 rcr     bl, 1
seg000:F31D                 dec     al
seg000:F31F                 jnz     pw_verschluesselung
seg000:F321                 retn
seg000:F321 pw_verschluesselung endp                            *)

function ami_pw1(const cmos_index:word_norm):string;
  var
    cpuffer     :array[0..6+1] of byte;
    zaehler:word;
    entschluesselungs_wert:byte;
    entschluesselt:string[6];
    entschluesselt_ascii:string;
    bl_:byte;

  begin

    for zaehler:=Low(cpuffer) to High(cpuffer) do
      cpuffer[zaehler]:=cmos(cmos_index+zaehler);

    entschluesselt:='';

    cpuffer[0]:=cpuffer[0] and $f0; (* $37 *)

    bl_:=$80;
    entschluesselt:='';

    asm
      mov entschluesselungs_wert,0
      (*$IfDef VirtualPascal*)
      mov ecx,1
      lea esi,cpuffer
      lea edi,entschluesselt+1
      (*$Else*)
      mov cx,1
      lea si,cpuffer
      lea di,entschluesselt+1
      (*$EndIf*)

    @zeichen_schleife:
      mov entschluesselungs_wert,0
      (*$IfDef VirtualPascal*)
      cmp ecx,6
      (*$Else*)
      cmp cx,6
      (*$EndIf*)
      ja @fertig

      (*$IfDef VirtualPascal*)
      cmp byte ptr ss:[esi+1],0
      (*$Else*)
      cmp byte ptr ss:[si+1],0
      (*$EndIf*)
      jz @fertig

    @versuchs_schleife:

      mov al,entschluesselungs_wert
      (*$IfDef VirtualPascal*)
      mov bl,ss:[esi]
      (*$Else*)
      mov bl,ss:[si]
      (*$EndIf*)

      (*******************************************)

    @label_ungleich:
      test bl,$c3
      jp @label_jp

      stc

    @label_jp:

      rcr bl,1
      dec al
      jnz @label_ungleich

      (*******************************************)

      (*$IfDef VirtualPascal*)
      cmp bl,ss:[esi+1]
      (*$Else*)
      cmp bl,ss:[si+1]
      (*$EndIf*)
      jz @erfolg

      inc entschluesselungs_wert
      jmp @versuchs_schleife

    @erfolg:

      inc byte ptr entschluesselt
      mov al,entschluesselungs_wert
      (*$IfDef VirtualPascal*)
      mov ss:[edi],al
      inc ecx
      inc esi
      inc edi
      (*$Else*)
      mov ss:[di],al
      inc cx
      inc si
      inc di
      (*$EndIf*)
      jmp @zeichen_schleife

    @fertig:
    end;


    ami_pw1:=entschluesselt;
  end;


procedure ami_pw(const scancode_umwandlung:boolean);

  procedure anzeige(const pw,bewerkung:string);
    var
      s                 :string;
      zaehler           :word_norm;
    begin
      if scancode_umwandlung then
        begin
          s:='';
          for zaehler:=1 to Length(pw) do
            s:=s+scancode_zu_ascii(Ord(pw[zaehler]));
        end
      else
        s:=pw;

      ausschrift(bewerkung+in_doppelten_anfuerungszeichen(s),signatur);
    end;

  begin
    if (ami_admin_pw_index<>0) and (ami_user_pw_index<>0) then
      begin
        if ami_admin_pw_index<>0 then anzeige(ami_pw2(ami_admin_pw_index),'ADMIN : ');
        if ami_user_pw_index <>0 then anzeige(ami_pw2(ami_user_pw_index ),'USER  : ');
      end
    else
      begin
        (* Stobernack-BIOS *)
        anzeige(ami_pw1($37),'');
      end;
  end;


  procedure award_pw;
    var
      wert:word;
      zk:string;
      w1,w2:word;

    function wurzelsuche(const hib,lob:byte):word;
      var
        wt:word_norm;
        ergebnis:word;
      begin
        ergebnis:=0;
        wurzelsuche:=0;
        for wt:=0 to $ffff do
          begin
            asm
              (*$IfDef VirtualPascal*)
              mov eax,wt
              (*$Else*)
              mov ax,wt
              (*$EndIf*)
              mul ax
              cmp ah,lob
              jnz @nicht_wurzel
              cmp dl,hib
              jnz @nicht_wurzel
              (*$IfDef VirtualPascal*)
              mov eax,wt
              (*$Else*)
              mov ax,wt
              (*$EndIf*)
              mov ergebnis,ax
              @nicht_wurzel:
            end;
            if ergebnis<>0 then
              begin
                ausschrift(textz_gefunden_fuer^+str0(lob)+','+str0(hib)+':'+str0(ergebnis),signatur);
                wurzelsuche:=ergebnis;
                exit;
              end;
          end;
      end;

    procedure versuch_awp_alt(var zk:string);
      var
        laenge:byte;
        summe:word;
        zaehler:longint;
      begin
        (* "TEST"  [1D]=$51 [1C]=$af -> $4296*$4296=$1151AFE4 *)

        zulaessig:=grossbuchstaben+ziffern;
        for zaehler:=1 to 300000 do
          begin
            if zaehler=60000 then
              zulaessig:=zulaessig+rest;

            zk[0]:=chr(random(9-4)+4); (* KennwortlÑnge 4..8 *)
            for laenge:=1 to length(zk) do
              zk[laenge]:=zulaessig[random(length(zulaessig))+1];

            summe:=0;
            for laenge:=length(zk)+1 to 10 do
              zk[laenge]:=#0;

            (* alte AWARD-VerschlÅsselung *)
            asm
              cld
              (*$IfDef DOS*)
              push ds
              (*$EndIf*)
                (*$IfDef VirtualPascal*)
                mov esi,zk
                inc esi
                (*$Else*)
                lds si,zk
                inc si
                (*$EndIf*)
                xor ax,ax
                mov cx,1

                @schleife:
                (*$IfDef VirtualPascal*)
                mov bx,[esi]
                (*$Else*)
                mov bx,[si]
                (*$EndIf*)
                rol bx,8
                rol bh,cl
                inc cx
                ror bl,cl
                add ax,bx
                (*$IfDef VirtualPascal*)
                add esi,2
                (*$Else*)
                add si,2
                (*$EndIf*)
                inc cx
                cmp cx,8

                jc @schleife
              (*$IfDef DOS*)
              pop ds
              (*$EndIf*)
              mov summe,ax
            end;

            if summe=wert then break;
          end;

        if summe=wert then
          ausschrift('z.B. :'+kw_auch_us_tastatur(zk),signatur)
        else
          ausschrift(textz_konnte_nicht_in_angemessener_Zeit_ermittelt_werden^,signatur);
      end;


    function suche_awp_neu_suche(const arbeit:string;const diff:smallword;const suchmenge:string;var ergebnis:string):boolean;
      var
        zaehler         :word_norm;
      begin
        suche_awp_neu_suche:=false;
        for zaehler:=1 to Length(suchmenge) do
          begin
            if diff=Ord(suchmenge[zaehler]) then
              begin
                (* Treffer *)
                ergebnis:=suchmenge[zaehler]+arbeit;
                suche_awp_neu_suche:=true;
                exit;
              end
            else
              if  ((diff and $3)=(Ord(suchmenge[zaehler]) and $3))
              and (diff>Ord(suchmenge[zaehler]))
               then
                (* mit mehr Zeichen versuchen *)
                if suche_awp_neu_suche(suchmenge[zaehler]+arbeit,
                     (diff-Ord(suchmenge[zaehler])) shr 2,suchmenge,ergebnis) then
                  begin
                    suche_awp_neu_suche:=true;
                    Exit;
                  end;
          end;
      end;

    procedure suche_awp_neu(const wert:smallword);
      var
        award_neu_kennwort:string;
      begin
        award_neu_kennwort:='';
        if wert=0 then
          begin
          end
        else
        if wert=$1eaa then
          begin
            award_neu_kennwort:='AWARD_SW';
          end
        else

          (*$IfNDef ENDVERSION*)
          if not suche_awp_neu_suche('',wert,'ehm',award_neu_kennwort) then
          if not suche_awp_neu_suche('',wert,'veit',award_neu_kennwort) then
          if not suche_awp_neu_suche('',wert,'test',award_neu_kennwort) then
          if not suche_awp_neu_suche('',wert,'123',award_neu_kennwort) then
          if not suche_awp_neu_suche('',wert,'234',award_neu_kennwort) then
          (*if not suche_awp_neu_suche('',wert,'AWRD_S',award_neu_kennwort) then*)
          (*$EndIf*)
          if not suche_awp_neu_suche('',wert,ziffern,award_neu_kennwort) then
            if not suche_awp_neu_suche('',wert,kleinbuchstaben,award_neu_kennwort) then
(* zeit sparen ... if not suche_awp_neu_suche('',wert,ziffern+kleinbuchstaben,award_neu_kennwort) then *)
                if not suche_awp_neu_suche('',wert,ziffern+kleinbuchstaben+rest,award_neu_kennwort) then
                  begin
                    ausschrift('?????????????',signatur);
                    Exit;
                  end;

        ausschrift_x(textz_z_punkt_b_punkt_doppelpunkt_^+kw_auch_us_tastatur(award_neu_kennwort),signatur,absatz)
      end;


    var
      bios_Fec60        :puffertyp;

    begin
      if Copy(bios_datum,pos_bios_datum_jahr,4)<='1992' then
        begin
          wert:=wurzelsuche(cmos($1d),cmos($1c));
          if bestimme_bios_kennwort then
            versuch_awp_alt(zk);
        end
      else
        begin (* neuer als 1992 *)

          if bestimme_bios_kennwort then
            begin
              (* Veit 486/66 *)
              (* Ehm 486/100: Supervisor *)
              wert:=cmos($1d)*256+cmos($1c);

              if (cmos($11) and 1)=1 then
                ausschrift('System+Setup',signatur)
              else
                ausschrift('Setup',signatur);

              if  (Copy(bios_datum,pos_bios_datum_jahr,4)>='1995')
              or ((Copy(bios_datum,pos_bios_datum_jahr,4) ='1994') and (Copy(bios_datum,pos_bios_datum_monat,2)>='11')) then
                begin
                  ausschrift('SUPERVISOR: [CMOS $1c/$1d]',normal);
                  suche_awp_neu(wert);

                  (* Ehm 486/100: user *)
                  wert:=cmos($5d+1)*256+cmos($5d);

                  ausschrift(textz_bios__BENUTZER^+' [CMOS $5d/$5e]',normal);
                  suche_awp_neu(wert);
                  if (copy(bios_datum,pos_bios_datum_jahr,4)>='1996') then
                    begin
                      (* jost p5/"133": Supervisor 07.08.1996 *)
                      wert:=cmos($60+1)*256+cmos($60);
                      ausschrift('SUPERVISOR: (ASUS/1996.08.07)  [CMOS $60/$61]',normal);
                      suche_awp_neu(wert);
                    end;

                  (* EHM: 1999.10.01 AMD K7*)
                  ausschrift(textz_bios__BENUTZER^+' (Soyo AMDK7) [CMOS $4d/$4e]',normal);
                  wert:=cmos($4d+1)*256+cmos($4d);
                  suche_awp_neu(wert);

                end
              else
                suche_awp_neu(wert);


            end; (* bestimme_bios_kennwort *)




          (* AWARD_SW bei SIS471
          3DF9 E81300         CALL   3E0F
          3DFC 2E3B0660EC     CMP    AX,CS:[EC60]
          3E01 7405           JZ     3E08
          3E03 3B461C         CMP    AX,[BP+1C]
          3E06 75E6           JNZ    3DEE
          3E08 5B             POP    BX
          3E09 889E8000       MOV    [0080+BP],BL
          3E0D 5B             POP    BX
          3E0E C3             RET                       *)


          lies(bios_Fec60,$f0000+$ec60,8);
          (* hash: 1996 (UMC)       *)
          (* str8: 2001 (ALI Magik) *)
          (* garnicht? phoenix (Intel845) *)
          if  (bytesuche(bios_Fec60.d[3],'are I')) (* alte Version *)
          or  (bytesuche(bios_Fec60.d[2],#0#0#0#0#0#0))
           then
            begin
              ausschrift('BIOS ROM:',normal);
              (*ausschrift(kw_auch_us_tastatur('AWARD_SW'),signatur);
              if word_z(@bios_Fec60.d[0])^<>$1eaa then*)
                suche_awp_neu(word_z(@bios_Fec60.d[0])^);
            end
          else (* str8 *)
            begin
              asm (* Kode ist bei Exxx in original.tmp *)
                (*$IfDef VirtualPascal*)
                lea esi,bios_Fec60.d
                mov ecx,8
                (*$Else*)
                lea si,bios_Fec60.d
                mov cx,8
                (*$EndIf*)
  @awa_310_8:
                (*$IfDef VirtualPascal*)
                mov al,[esi]
                (*$Else*)
                mov al,ss:[si]
                (*$EndIf*)
                mov ah,al
                ror al,3
                rol ax,3
                rol al,3
                shr ah,3
                shr ax,3
                (*$IfDef VirtualPascal*)
                mov [esi],al
                inc esi
                (*$Else*)
                mov ss:[si],al
                inc si
                (*$EndIf*)
                loop @awa_310_8
              end;
              exezk:=puffer_zu_zk_e(bios_Fec60.d[0],#0,8);
              if exezk<>'' then
                begin
                  ausschrift('BIOS ROM:',normal);
                  ausschrift(textz_universell^+': '+kw_auch_us_tastatur(exezk),normal);
                end;
            end; (* str8 *)

        end; (* neuer als 1992 *)

    end; (* AWARD *)


  procedure quadtel_pw;
    function berechne(kennwort_unverschluesselt:string):smallword;
      var
        _ax,_bx,_cx,_dx :smallword;
        _zf             :boolean;
        _di             :byte;
        zeichen         :char;
      label
        durchgearbeitet,einlesen;
      begin
        kennwort_unverschluesselt[length(kennwort_unverschluesselt)+1]:=#0;
        _ax:=$0800;
        _bx:=$0800;
        _cx:=    6;
        _dx:=    0;
        _di:=    1;

        einlesen:

        zeichen:=kennwort_unverschluesselt[_di];
        if zeichen=#0 then goto durchgearbeitet;
        inc(_di);
        if zeichen in ['a'..'z'] then
          dec(zeichen,$20);

        asm
          mov ax,_ax
          mov al,zeichen
          mov bx,_bx
          mov cx,_cx
          mov dx,_dx

          mov bl,al
          ror al,cl
          and al,ah
          or dl,al
          and bl,$7d
          mov al,bl
          shr al,1
          and bl,1
          or al,bl
          add dh,al
          ror ah,1
          inc cl

          mov _ax,ax
          mov _bx,bx
          mov _cx,cx
          mov _dx,dx
        end;

        if hi(_bx)<>0 then goto einlesen;

        durchgearbeitet:

        berechne:=_dx and $3fff;
      end;

    var
      cmos_29_2a:word;
      durchlauf:longint;
      pw:string[9];
      z1:byte;

    begin
      zulaessig:=grossbuchstaben;
      cmos_29_2a:=(cmos($29)+cmos($2A)*256) and $3fff;
      durchlauf:=100000;
      while (durchlauf>0) do
        begin
          dec(durchlauf);
          pw[0]:=chr(random(9)); (* 0..8 *)
          if durchlauf=500000 then
            zulaessig:=zulaessig+ziffern+rest+#127;
          for z1:=1 to ord(pw[0]) do
            pw[z1]:=zulaessig[random(length(zulaessig))+1];

          for z1:=ord(pw[0])+1 to 9 do
            pw[z1]:=#0;
          if berechne(pw)=cmos_29_2a then
            break;
        end;
      if durchlauf=0 then
        ausschrift(textz_konnte_nicht_in_angemessener_Zeit_ermittelt_werden^,dat_fehler)
      else
        ausschrift('z.B. :'+in_doppelten_anfuerungszeichen(pw)
          +' ('+in_doppelten_anfuerungszeichen(us_tastatur(pw))+')',signatur);
    end;

  procedure chips_pw;
    begin
      ausschrift(textz_noch_keins_mit_Kennwort_gefunden^,signatur);
    end;

  procedure phoenix_pw;
    var
      zaehler,b:byte;
    begin
      if Copy(bios_datum,pos_bios_datum_jahr,4)<='1994' then
        begin
          (* Blue Lightening... 11.11.1993 *)
          zaehler:=0;
          exezk:='';
          repeat
            b:=cmos($38+zaehler);
            if b=0 then break;
            exezk_anhaengen(scancode_zu_ascii(b));
            inc(zaehler);
          until false;
          ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);
        end;

      if copy(bios_datum,pos_bios_datum_jahr,4)>='1994' then
        begin
          (* Bauing-Pool LG 2 03.04.1995*)
          zaehler:=0;
          exezk:='';
          repeat
            b:=cmos($71+zaehler);
            if b=0 then break;
            exezk_anhaengen(scancode_zu_ascii(b));
            inc(zaehler);
          until zaehler>7;
          ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);
        end;

    end;

  procedure microid_research_pw;
    begin
      ausschrift(textz_noch_nicht_entschluesselt^,signatur);
    end;

  (* Keller LehrgebÑude 2 *)
  procedure ami_bios_neu_pw;

    function berechne(const w_vorgabe:longint;const ziel:word):boolean;
      var
        _bx:word;
        _ax:word;
        r:word;
        diff:word;
        w:longint;

      const
        ascii_pw4:array[0..3] of char=('4','7','8','9');

      function zahl_zu_kennwort(z:longint):string;
        var
          temp:string;

        begin
          temp:='';
          while z>0 do
            begin
              temp:=temp+ascii_pw4[z mod 4];
              z:=z div 4;
            end;
          zahl_zu_kennwort:=temp;
        end;

      begin
        berechne:=false;
        w:=w_vorgabe;
        _bx:=0;
        while w>0 do
          begin
            case w and $3 of
              0:_ax:=5*5;
              1:_ax:=8*8;
              2:_ax:=9*9;
              3:_ax:=10*10;
            end;

            w:=w div 4;
            asm
              mov ax,_ax
              mov bx,_bx
              rol bx,2
              adc al,0
              add bx,ax
              xchg bh,bl
              mov _ax,ax
              mov _bx,bx
            end;
          end;

        if ziel=_bx then
          begin
            berechne:=true;
            ausschrift(in_doppelten_anfuerungszeichen(zahl_zu_kennwort(w_vorgabe)),signatur);
            exit;
          end;

        asm
          mov cx,ziel
          xchg ch,cl

          mov bx,_bx
          rol bx,2
          mov _bx,bx

          sub cx,bx
          mov diff,cx
        end;

        for r:=2 to 11 do
          if (r*r+(_bx and 1)=diff) then
            begin
              berechne:=true;
              ausschrift(in_doppelten_anfuerungszeichen(zahl_zu_kennwort(w_vorgabe)+chr(r-1+ord('0'))),signatur);
              Exit;
            end;

      end;

    const
      grenze=$200000;
    var
      kombi:longint;
      ziel:word;
    begin
      ziel:=cmos($3b)*256+cmos($3a);

      kombi:=0;
      while (not berechne(kombi,ziel)) and (kombi<grenze) do
        inc(kombi);

      if not(kombi<grenze) then
        ausschrift(textz_konnte_nicht_in_angemessener_Zeit_ermittelt_werden^,dat_fehler);

    end;
  (* Ende AMI neu *)

  (*****************************************************************)

(*
                push    bp
                mov     bp, sp
                push    si
                mov     si, [bp+arg_0]
                cld
                xor     bx, bx
                mov     cx, 1
loc_0_1F11:
                xor     ax, ax
                lodsb
                mul     cx
                add     bx, ax
                inc     cx
                cmp     cx, 9
                jbe     loc_0_1F11
                mov     ax, bx
                pop     si
                leave
                retn    2 *)

  type
    string8=string[8];

  function suche_syso_suche(const arbeit:string8;const diff:smallword;const suchmenge:string;var ergebnis:string8):boolean;
    var
      zaehler           :word_norm;
      faktor            :word;
      moeglich          :boolean;
    begin

      if arbeit='' then (* Kann das Ziel erreicht werden? *)
        begin
          moeglich:=false;
          for zaehler:=1 to Length(suchmenge) do
            if (1+2+3+4+5+6+7+8)*Ord(suchmenge[zaehler])>=diff then
              begin
                moeglich:=true;
                Break;
              end;

          if not moeglich then
            begin
              suche_syso_suche:=false;
              Exit;
            end;
        end;

      suche_syso_suche:=false;
      faktor:=Length(arbeit)+1;
      for zaehler:=1 to Length(suchmenge) do
        begin
          if diff=Ord(suchmenge[zaehler])*faktor then
            begin
              (* Treffer *)
              ergebnis:=arbeit+suchmenge[zaehler];
              suche_syso_suche:=true;
              exit;
            end
          else
            if  (diff>Ord(suchmenge[zaehler])*faktor)
            and (Length(arbeit)<8)
             then
              (* mit mehr Zeichen versuchen *)
              if suche_syso_suche(arbeit+suchmenge[zaehler],
                   diff-Ord(suchmenge[zaehler])*faktor,suchmenge,ergebnis) then
                begin
                  suche_syso_suche:=true;
                  Exit;
                end;
        end;
    end;

  (* 8 Zeichen -> mit '99999999' kann Ord('9')*$ff  =$38C7 erreicht werden
                      '9999999Y' kann Ord(#255)*$ff =$FE01
    also bevorzugt Ziffern und sonst alle Zeichen *)
  procedure suche_syso(const wert:smallword;const kennworttyp:string);
    var
      syso_kennwort:string8;
    begin

      syso_kennwort:='';

      if not (wert=0) then
        (*$IfNDef ENDVERSION*)
        if not suche_syso_suche('',wert,'ehm' ,syso_kennwort) then
        if not suche_syso_suche('',wert,'veit',syso_kennwort) then
        if not suche_syso_suche('',wert,'test',syso_kennwort) then
        if not suche_syso_suche('',wert,'123' ,syso_kennwort) then
        if not suche_syso_suche('',wert,'234' ,syso_kennwort) then
        (*$EndIf*)
        if not suche_syso_suche('',wert,ziffern,syso_kennwort) then
          if not suche_syso_suche('',wert,ziffern+kleinbuchstaben,syso_kennwort) then
            if not suche_syso_suche('',wert,ziffern+kleinbuchstaben+rest,syso_kennwort) then
              begin
                ausschrift(kennworttyp+'?',signatur);
                exit;
              end;

      ausschrift(kennworttyp+textz_z_punkt_b_punkt_doppelpunkt_^+kw_auch_us_tastatur(syso_kennwort),signatur)
    end;



(**************************************************************************)
(*  Verteiler                                                             *)
(**************************************************************************)

  var
    bios_rom,bios_rom_arbeit    :puffertyp;
    o                           :longint;
    test_rueckwaerts            :longint;
    ncr_bios,
    hersteller_und_version      :string;
    fp                          :word;
    gefunden                    :boolean;
(*$IfDef HOLEN_COM*)
    holen_com_datei             :file;
(*$EndIf*)

    flash_suchposition          :longint;
    textrel                     :longint;

(*$IfDef HOLEN_COM*)
  const
    holen_com
    (*$I HOLEN.INC*)
(*$EndIf*)

  function bios_datum_zu_normal_datum(const b:string8):string10;
    begin
      if (b[3]='/') and (b[6]='/') then
        begin
          if not (b[7] in ['8','9','0']) then (* Phoenix *)
            begin
              if b[1] in ['8','9'] then
                bios_datum_zu_normal_datum:='19'+b[1]+b[2]+'.'+b[4]+b[5]+'.'+b[7]+b[8]
              else
                bios_datum_zu_normal_datum:='20'+b[1]+b[2]+'.'+b[4]+b[5]+'.'+b[7]+b[8];
            end
          else
            begin
              if b[7] in ['8','9'] then
                bios_datum_zu_normal_datum:='19'+b[7]+b[8]+'.'+b[1]+b[2]+'.'+b[4]+b[5]
              else
                bios_datum_zu_normal_datum:='20'+b[7]+b[8]+'.'+b[1]+b[2]+'.'+b[4]+b[5];
            end;
        end
      else
        bios_datum_zu_normal_datum:='0000.00.00';

    end;

  function versuche_ami_chipsatz(o:longint):boolean;
    begin
      if o<anfang_min then Exit;
      lies(bios_rom,o,512);
      exezk:=puffer_zu_zk_e(bios_rom.d[$78],#0,255);
      if ist_ohne_steuerzeichen(exezk)
      and (Length(exezk)>=10)
      and (Pos('-',exezk)>1) then
        begin
          if bytesuche(bios_rom.d[0],'AMIBIOS 0') then
            if bios_rom.d[9]>=Ord('8') then (* Virtual PC 5: F000:F400 *)
              begin
                lies(bios_rom,o+512,512);
                ami_admin_pw_index:=word_z(@bios_rom.d[0])^;
                ami_user_pw_index :=word_z(@bios_rom.d[2])^;
                if (ami_admin_pw_index<30) or (ami_admin_pw_index>128-6) then ami_admin_pw_index:=0;
                if (ami_user_pw_index <30) or (ami_user_pw_index >128-6) then ami_user_pw_index :=0;
              end;

          ausschrift(textz_Chipsatz^+exezk,signatur);
          versuche_ami_chipsatz:=true;
        end
      else
        versuche_ami_chipsatz:=false;

    end;

  procedure anzeige_bios_meldung_systemsoft;

    procedure zeichenkettenanzeige(zeichenfolge,optwort:word;testbit:word);
      var
        r2:puffertyp;
      begin
        if testbit<>0 then
          begin
            lies(r2,$f0000+optwort,2);
            if (word_z(@r2.d[0])^ and testbit)=0 then
              Exit;
          end;
        lies(r2,$f0000+zeichenfolge,256);
        ausschrift_x(leer_filter(puffer_zu_zk_e(r2.d[0],#0,255)),{beschreibung}farblos,vorne);
      end; (* zeichenkettenanzeige *)

    var
      p,p_min           :longint;
      f1                :word_norm;

    begin
      p:=$100000-512;
      p_min:=$100000-Min(max_rueckwaerts,$10000);
      while p>p_min do
        begin
          lies(bios_rom,p,512);

          (* tinybios - post.8 *)
          f1:=puffer_pos_suche(bios_rom,#$be'??'#$e8'??'#$66#$33#$c0#$a1#$13#$04#$e8'??'#$be,400);
          if f1<>nicht_gefunden then
            begin
              zeichenkettenanzeige(word_z(@bios_rom.d[f1+1])^,0,0);
              Exit;
            end;

          (* QUADTEL\peacock\peackock.bio *)
          f1:=puffer_pos_suche(bios_rom,#$2e#$f6#$06'??'#$01#$74#$06#$be'??'#$e8'??'#$2e#$f6#$06,400);
          if f1<>nicht_gefunden then
            begin
              zeichenkettenanzeige(word_z(@bios_rom.d[f1+0*14+9])^,word_z(@bios_rom.d[f1+0*14+3])^,bios_rom.d[f1+0*14+5]);
              zeichenkettenanzeige(word_z(@bios_rom.d[f1+1*14+9])^,word_z(@bios_rom.d[f1+1*14+3])^,bios_rom.d[f1+1*14+5]);
              zeichenkettenanzeige(word_z(@bios_rom.d[f1+2*14+9])^,word_z(@bios_rom.d[f1+2*14+3])^,bios_rom.d[f1+2*14+5]);
              Exit;
            end;

          (* Kapok: quarz *)
          f1:=puffer_pos_suche(bios_rom,#$68'??'#$e8'??'#$68'??'#$e8'??'#$b9#$50#$00,400);
          if f1<>nicht_gefunden then
            begin
              zeichenkettenanzeige(word_z(@bios_rom.d[f1+1  ])^,0,0);
              zeichenkettenanzeige(word_z(@bios_rom.d[f1+1+6])^,0,0);
              Exit;
            end;

          (* TS30MLMQ.ROM (epson) *)
          f1:=puffer_pos_suche(bios_rom,#$0e6#$80#$0e#$68'??'#$e8'??'#$83#$c4#$04#$0e#$68'??'
                +#$e8'??'#$83#$c4#$04#$bf'??'#$2e,400);
          if f1<>nicht_gefunden then
            begin
              zeichenkettenanzeige(word_z(@bios_rom.d[f1+4   ])^,0,0);
              zeichenkettenanzeige(word_z(@bios_rom.d[f1+4+10])^,0,0);
              Exit;
            end;

          (* b.rom (epson) *)
          f1:=puffer_pos_suche(bios_rom,#$0e#$68'??'#$e8'??'#$83#$c4#$04#$0e#$68'??'#$e8'??'#$83#$c4#$04#$51#$33#$c9#$51#$0e
                +#$68'??'#$e8'??'#$83#$c4#$04,400);
          if f1<>nicht_gefunden then
            begin
              zeichenkettenanzeige(word_z(@bios_rom.d[f1+2   ])^,0,0);
              zeichenkettenanzeige(word_z(@bios_rom.d[f1+2+10])^,0,0);
              Exit;
            end;

          Dec(p,300);
        end;

    end; (* anzeige_bios_meldung_systemsoft *)


  var
    pos_amibiosc        :dateigroessetyp;
    w1                  :word_norm;
    bcpsys_bcpost       :word_norm;
  begin (* ermittle_bios_hersteller *)
    anfang_min:=$100000-Min(max_rueckwaerts,$10000);

    if not quelle_ist_datei then
      begin
        ausschrift_v(textz_bios__eckauf_BIOS_Hersteller_Chipsatz_und_Kennwort_eckzu^);

        (*$IfDef Linux*)
        ausschrift(textz_funktion_nicht_implementiert^,dat_fehler);
        Exit;
        (*$EndIf Linux*)

        (*$IfDef Win32*)
        ausschrift(textz_funktion_nicht_implementiert^,dat_fehler);
        Exit;
        (*$EndIf Win32*)

        (*$IfDef DOS*)
        (* Test auf Flash - Bios *)
        asm
          mov ax,$e000
          int $16
          xor ah,ah
          mov fehler,ax
        end;

        if fehler=$fa then
          ausschrift('Flash-Bios [AMI]',signatur);
        (*$EndIf*)
      end;


    bios_hersteller:=unbekannt;
    ncr_bios:='';
    ami_admin_pw_index:=0;
    ami_user_pw_index :=0;

    if bestimme_bios_kennwort and hole_cmos_aus_datei then
      lies(cmos_puffer,$100000,$80);

    lies(bios_rom,$0fffe4,3);
    if bios_rom.d[0]=$e9 then
      begin (* IBM Thinlpad 390E *)
        lies(bios_rom,$0f0000+($ffe4+x_word(bios_rom.d[1])+3) and $ffff,5);
        if bytesuche(bios_rom.d[0],#$b8#$ff#$ff#$f9#$cb) then
          bios_hersteller:=phoenix;
      end;


    lies(bios_rom,$0FFFF0,16);

    if bytesuche(bios_rom.d[5],'*MRB*') then
      begin
        test_rueckwaerts:=max_rueckwaerts and (-$2000);
        if test_rueckwaerts>$100000 then
          test_rueckwaerts:=$100000;
        while (test_rueckwaerts>$2000) do
          begin
            lies(bios_rom_arbeit,$100000-test_rueckwaerts,16);
            if bytesuche(bios_rom_arbeit.d[2],'-lh?-') then
              begin
                ausschrift(textz_bios__Fuell_byte2^,signatur);
                (* siehe auch typ_dat.pas: dat_00 *)
                DecDGT(einzel_laenge,test_rueckwaerts);
                Exit;
              end;
            Dec(test_rueckwaerts,$2000);
          end;
      end;

    if titel<>'' then
      ausschrift(titel,signatur);

    if bytesuche(bios_rom.d[0],#$b8#$ff#$ff#$cd#$e6'??/??/??') then
      bios_hersteller:=linux;

    if bytesuche(bios_rom.d[0],#$e9#$68#$e0#$00#$00'??/??/') then
      bios_hersteller:=bochs;

    bios_datum:=bios_datum_zu_normal_datum(puffer_zu_zk_l(bios_rom.d[5],8));
    if (bios_rom.d[7]<>ord('/')) or (bios_rom.d[10]<>ord('/')) then
      begin
        bios_hersteller:=verdeckt;
        gefunden:=false;
      end;

    (* AWARD (gepackt) *)
    if bytesuche(bios_rom.d[0],#$ea#$5b#$e0#$00#$f0) then
      begin
        if anfang_min<=$fb000 then
          begin
            lies(bios_rom,$fb000,120);
            if bytesuche(bios_rom.d[0],'= Aw') then
              begin
                ausschrift_x(puffer_zu_zk_e(bios_rom.d[0],#0,120),beschreibung,absatz);
                bios_hersteller:=award_gepackt;
              end;
          end;
        if anfang_min<=$fc000 then
          begin
            lies(bios_rom,$fc000,120);
            if bytesuche(bios_rom.d[0],'= Aw') then
              begin
                ausschrift_x(puffer_zu_zk_e(bios_rom.d[0],#0,120),beschreibung,absatz);
                bios_hersteller:=award_gepackt;
              end;
          end;
        if anfang_min<=$fe000 then
          begin
            lies(bios_rom,$fe000,120);
            if bytesuche(bios_rom.d[0],'Award Boot') then
              begin
                if puffer_pos_suche(bios_rom,'*BBSS*',$80)<>nicht_gefunden then
                  ausschrift_x(puffer_zu_zk_e(bios_rom.d[0],'*BBSS*',$80),beschreibung,absatz)
                else
                  ausschrift_x(puffer_zu_zk_e(bios_rom.d[0],#0      ,$80),beschreibung,absatz);
                (* ausschrift('Award-Boot-Block-BIOS',signatur); *)
                bios_hersteller:=award_gepackt;
              end;
          end;
      end;

    if bios_hersteller=award_gepackt then Exit;


    if bios_hersteller=verdeckt then
      begin (* Fortsetzung *)
        lies(bios_rom,$fff50,120);
        if pruefe_amiboot_rom(bios_rom) then
          begin
            ausschrift('AMI-Boot-Block-BIOS ($F000:$FF50)',signatur);

            pos_amibiosc:=datei_pos_suche(ende_off-max_rueckwaerts,ende_off,'AMIBIOSC0');
            if pos_amibiosc<>nicht_gefunden then
              begin
                datei_lesen(bios_rom,pos_amibiosc,$20);
                exezk:=puffer_zu_zk_l(bios_rom.d[0],Length('AMIBIOSC0800'));
                l1:=word_z(@bios_rom.d[$12])^+word_z(@bios_rom.d[$14])^ shl 4;
                amibios_archiv(l1,ende_off-$100000,exezk);
              end;

            Exit;
          end;


        lies(bios_rom,$fff40,120);
        if pruefe_amiboot_rom(bios_rom) then
          begin
            ausschrift('AMI-Boot-Block-BIOS ($F000:$FF40)',signatur);

            pos_amibiosc:=datei_pos_suche(ende_off-max_rueckwaerts,ende_off,'AMIBIOSC0');
            if pos_amibiosc<>nicht_gefunden then
              begin
                datei_lesen(bios_rom,pos_amibiosc,$20);
                exezk:=puffer_zu_zk_l(bios_rom.d[0],Length('AMIBIOSC0800'));
                l1:=word_z(@bios_rom.d[$12])^+word_z(@bios_rom.d[$14])^ shl 4;
                amibios_archiv(l1,ende_off-$100000,exezk);
              end;

            Exit;
          end;



        if gefunden then Exit;

        (* Phoenix (gepackt) *)
        flash_suchposition:=$f0000;
        if max_rueckwaerts<$100000 then
          flash_suchposition:=$100000-max_rueckwaerts;
        bcpsys_bcpost:=0;
        textrel:=$f0000;
        repeat
          lies(bios_rom,flash_suchposition,512);

          if flash_suchposition<$f0000 then
            begin
              (* BCPOST: $6F633
                 $6c86e-$32ce=$695A0
                 $6c88f-$32ef=$695A0 *)

              w1:=puffer_pos_suche(bios_rom,'PhoenixBIOS ?.? ',512-$80);
              if w1<>nicht_gefunden then
                textrel:=flash_suchposition+w1;
            end;

          w1:=puffer_pos_suche(bios_rom,'BCPOST',512-$80);
          if w1<>nicht_gefunden then
            begin
              if word_z(@bios_rom.d[w1+$1b+2])^=$0050 then
                begin
                  if textrel<>$f0000 then
                    textrel:=textrel-word_z(@bios_rom.d[w1+$1b+0])^;
                  lies(bios_rom_arbeit,textrel+word_z(@bios_rom.d[w1+$1b+0])^,512);
                  ausschrift(puffer_zu_zk_e(bios_rom_arbeit.d[0],#0,255),signatur);
                end;
              if word_z(@bios_rom.d[w1+$38+2])^=$0050 then
                begin
                  lies(bios_rom_arbeit,textrel+word_z(@bios_rom.d[w1+$38+0])^,512);
                  ausschrift(puffer_zu_zk_e(bios_rom_arbeit.d[0],#0,255),signatur);
                end;
              bcpsys_bcpost:=bcpsys_bcpost or 2;
            end;

          w1:=puffer_pos_suche(bios_rom,'BCPSYS',512-$80);
          if w1<>nicht_gefunden then
            begin
              phoenix_bios_archiv_m025(flash_suchposition+w1+$77,ende_off-$100000);
              bcpsys_bcpost:=bcpsys_bcpost or 1;
            end;

          if bcpsys_bcpost=1+2 then Break;

          Inc(flash_suchposition,512-$80-10);
        until flash_suchposition>=$100000;

        {//if gefunden then Exit;}
        Exit;
      end;

    if anfang_min<=$fe000 then
      begin

        lies(bios_rom,$fe000,120);
        if pruefe_amiboot_rom(bios_rom) then
          begin
            ausschrift('AMI-Boot-Block-BIOS ($F000:$E000)',signatur);

            pos_amibiosc:=datei_pos_suche(ende_off-max_rueckwaerts,ende_off,'AMIBIOSC0');
            if pos_amibiosc<>nicht_gefunden then
              begin
                datei_lesen(bios_rom,pos_amibiosc,$20);
                exezk:=puffer_zu_zk_l(bios_rom.d[0],Length('AMIBIOSC0800'));
                l1:=word_z(@bios_rom.d[$12])^+word_z(@bios_rom.d[$14])^ shl 4;
                amibios_archiv(l1,ende_off-$100000,exezk);
              end;

            Exit;
          end;

        lies(bios_rom,$fff50,120);
        if pruefe_amiboot_rom(bios_rom) then
          begin
            ausschrift('AMI-Boot-Block-BIOS ($F000:$FF50)',signatur);

            pos_amibiosc:=datei_pos_suche(ende_off-max_rueckwaerts,ende_off,'AMIBIOSC0');
            if pos_amibiosc<>nicht_gefunden then
              begin
                datei_lesen(bios_rom,pos_amibiosc,$20);
                exezk:=puffer_zu_zk_l(bios_rom.d[0],Length('AMIBIOSC0800'));
                l1:=word_z(@bios_rom.d[$12])^+word_z(@bios_rom.d[$14])^ shl 4;
                amibios_archiv(l1,ende_off-$100000,exezk);
              end;

            Exit;
          end;

        lies(bios_rom,$fff40,120);
        if pruefe_amiboot_rom(bios_rom) then
          begin
            ausschrift('AMI-Boot-Block-BIOS ($F000:$FF40)',signatur);

            pos_amibiosc:=datei_pos_suche(ende_off-max_rueckwaerts,ende_off,'AMIBIOSC0');
            if pos_amibiosc<>nicht_gefunden then
              begin
                datei_lesen(bios_rom,pos_amibiosc,$20);
                exezk:=puffer_zu_zk_l(bios_rom.d[0],Length('AMIBIOSC0800'));
                l1:=word_z(@bios_rom.d[$12])^+word_z(@bios_rom.d[$14])^ shl 4;
                amibios_archiv(l1,ende_off-$100000,exezk);
              end;

            Exit;
          end;


      end;

    if anfang_min<=$fe000 then
      begin
        (* F000:E000 *)
        lies(bios_rom,$fe000,120);
        if bytesuche(bios_rom.d[$10],'SystemSoft BIOS')
        or bytesuche(bios_rom.d[$12],'Insyde Software BIOS')
         then
          bios_hersteller:=systemsoft;

        (* in Ñlteren Versionen: TS20MLSC.ROM (EPSON:650FLBIO.EXE) *)
        if bytesuche(bios_rom.d[$00],'<<ORGS>>'#$00#$00#$00#$00#$00#$00'IBM')
        or bytesuche(bios_rom.d[$00],'<<ORGS>>'#$00#$00#$00#$00#$00#$00'   ') then
          bios_hersteller:=systemsoft_alt;


        if (bytesuche(bios_rom.d[$00],'Award ') or bytesuche(bios_rom.d[$00],'Phoeni'))
        and bytesuche(bios_rom.d[$0e],'IBM COMPATIBLE') then
          bios_hersteller:=award;


        if bytesuche(bios_rom.d[$10],'TOSHIBA ') then
          bios_hersteller:=toshiba;

        (* F000:FF60 Systemsoft 31BR218.BIN *)
        lies(bios_rom,$fff60,$40);
        if bytesuche(bios_rom.d[0],'Boot Loader. Co') then
          begin
            ausschrift(puffer_zu_zk_e(bios_rom.d[0],#0,$40),signatur);
            bios_hersteller:=systemsoft_boot;
          end;
        (* F000:FF80 Insyde Software 290160a.rom *)
        lies(bios_rom,$fff80,$40);
        if bytesuche(bios_rom.d[0],'Boot Block. Co') then
          begin
            ausschrift(puffer_zu_zk_e(bios_rom.d[0],#0,$40),signatur);
            bios_hersteller:=systemsoft_boot;
          end;
      end;


    o:=Max(anfang_min,$e0000);

    if (o mod $1000)<>0 then
      o:=(o div $1000)*$1000+$1000;

    while (o<$100000) and (bios_hersteller=unbekannt) do
      begin
        lies(bios_rom,o,512);

        (* die eigentliche Untersuchung ... *)
        if puffer_gefunden(bios_rom,'tinyBIOS V1') then
          bios_hersteller:=tinybios;

        if puffer_pos_suche(bios_rom,'T IBM CORPO',200)<>nicht_gefunden then
          bios_hersteller:=ibm;

        if puffer_pos_suche(bios_rom,'COP'{'R. IBM 198'},200)<>nicht_gefunden then
          bios_hersteller:=ibm_ps2;

        if puffer_pos_suche(bios_rom,'Award Software Inc',200)<>nicht_gefunden then
          bios_hersteller:=award;

        if puffer_pos_suche(bios_rom,'American Megatrends Inc',500)<>nicht_gefunden then
          bios_hersteller:=ami_alt;

        if puffer_pos_suche(bios_rom,'AMIBIOSC',200)<>nicht_gefunden then
          bios_hersteller:=ami_neu;

        if puffer_pos_suche(bios_rom,'0123AAAM',200)<>nicht_gefunden then
          bios_hersteller:=ami_neu;

        if puffer_pos_suche(bios_rom,'Quadtel Corp',200)<>nicht_gefunden then
          bios_hersteller:=quadtel;

        if puffer_pos_suche(bios_rom,'CChhiippss  &&  TT',200)<>nicht_gefunden then
          bios_hersteller:=chips;

        if puffer_pos_suche(bios_rom,'Phoenix',200)<>nicht_gefunden then
          begin
            if puffer_gefunden(bios_rom,'Award BIOS') then
              bios_hersteller:=award
            else
              bios_hersteller:=phoenix;
          end;

        if puffer_pos_suche(bios_rom,'MR BIOS',200)<>nicht_gefunden then
          bios_hersteller:=microid_research;

        if puffer_pos_suche(bios_rom,'ACER',200)<>nicht_gefunden then
          bios_hersteller:=acer;

        if (puffer_pos_suche(bios_rom,'Compaq Compu',200)<>nicht_gefunden)
        or (puffer_pos_suche(bios_rom,'COMPAQ Compu',200)<>nicht_gefunden)
         then
          bios_hersteller:=compaq;

        if puffer_pos_suche(bios_rom,'OLIVETTI',200)<>nicht_gefunden then
          bios_hersteller:=olivetti;

        if puffer_pos_suche(bios_rom,'COMEXEBATASMLIBMAP',200)<>nicht_gefunden then
          bios_hersteller:=icl;

        fp:=puffer_pos_suche(bios_rom,'NCR Corp',200);
        if fp<>nicht_gefunden then
          ncr_bios:=puffer_zu_zk_e(bios_rom.d[fp-$2b+$116],#0,80)+
          ', '+puffer_zu_zk_e(bios_rom.d[fp-$2b+$168],#0,80);

        Inc(o,$1000);
      end;

    if bios_hersteller=unbekannt then
      begin
        if datei_pos_suche(ende_off-max_rueckwaerts,ende_off,'PhoenixBIOS ?.?')<>nicht_gefunden then
          bios_hersteller:=phoenix;
      end;

    (* Intel hat keine vernÅnftige Kennung *)
    if bios_hersteller=unbekannt then
      begin
        f1:=datei_pos_suche(ende_off-max_rueckwaerts,ende_off,'AMIBIOSC');
        if f1<>nicht_gefunden then
          begin

            ausschrift('AMI '+bios_datum+exezk,signatur);

            (* "P4P800SEROM" *)
            lies(bios_rom,$fffb6,$32);
            exezk:=puffer_zu_zk_e(bios_rom.d[0],#0,$16);
            if ist_ohne_steuerzeichen(exezk) and (exezk<>'') then
              ausschrift(in_doppelten_anfuerungszeichen(exezk)
                        +' '
                        +in_doppelten_anfuerungszeichen(puffer_zu_zk_e(bios_rom.d[$2a],#0,$8)),
                        beschreibung);

            (* Hauptarchiv *)
            datei_lesen(bios_rom,f1,$16);
            exezk:=puffer_zu_zk_l(bios_rom.d[0],Length('AMIBIOSC0800'));
            l1:=word_z(@bios_rom.d[$12])^+word_z(@bios_rom.d[$14])^ shl 4;
            amibios_archiv(l1,ende_off-$100000,exezk);

            (* 1005vm.rom: flash-modul im BIOS *)
            f1:=datei_pos_suche(ende_off-MinDGT(max_rueckwaerts,$10000),ende_off,
              #$66#$33#$f6#$be'??'#$66#$03#$c6#$66#$2e#$a3'??'#$c3#$00#$00#$00#$00#$66#$60#$e8);
            if f1<>nicht_gefunden then
              begin
                l1:=x_word__datei_lesen(f1+4);
                lies(bios_rom,$f0000+l1,4+4);
                amibios_einzelblock_alt(bios_rom,'recovery');
                if quelle.sorte=q_datei then
                  befehl_schnitt(ende_off-$10000+l1,longint_z(@bios_rom.d[0])^,'recovery.ami')
              end;

            Exit;
          end;
      end;

    if bios_hersteller=unbekannt then
      begin
        (* bei F000:F400 *)
        (* AMIBIOS 080010   04/05/04(C)2003 American Megatrends, Inc *)
        f1:=datei_pos_suche(ende_off-max_rueckwaerts,ende_off,'AMIBIOS ??????'#$00#$00'??/??/');
          bios_hersteller:=ami_neu;
      end;

    case bios_hersteller of
      unbekannt:
        begin
          ausschrift(textz_bios__unbekannter_Hersteller^+bios_datum,signatur);
          if quelle_ist_datei then
            begin
              ausschrift(textz_Bitte_schicken_Sie_mir_diese_Datei^,beschreibung);
            end
          (*$IfDef HOLEN_COM*)
          else
            begin
              ausschrift(textz_Bitte_starten_Sie^+getenv('TMP')+'\HOLEN.COM '+textz_und_leerzeichen^,beschreibung);
              ausschrift(textz_schicken_Sie_mir_die_erzeuget_Datei_BIOSCMOS_DAT^,beschreibung);
              assign(holen_com_datei,getenv('TMP')+'\HOLEN.COM');
              (*$I-*)
              reset(holen_com_datei);
              (*$I+*)
              if <<ioresult<>0 then
                begin
                  rewrite(holen_com_datei,1);
                  blockwrite(holen_com_datei,holen_com,sizeof(holen_com));
                end;
              close(holen_com_datei);
            end;
          (*$Else*)
            (* bitte holen .com... *)
          (*$EndIf*);

          (* nicht richtig erkennbar.. *)
          anzeige_bios_meldung_systemsoft;

        end; (* unbekannt *)

      verdeckt :
        ausschrift(textz_ungueltig_durch_Speicherverwaltung_verdeckt^,dat_fehler);

      award    :
        begin
          exezk:='';
          if bios_datum='1992.06.25' then exezk:=' (TU-Rechner)';
          if bios_datum='1994.04.27' then exezk:=' (Veit:486)';
          if bios_datum='1995.10.14' then exezk:=' (Ehm:486)';
          if bios_datum='1996.07.03' then exezk:=' (Ehm:486(2))';
          if bios_datum='1994.10.11' then exezk:=' (Targa TUC/LG2/410:486)';
          if bios_datum='1995.11.16' then exezk:=' (Jost:586)';


          lies(bios_rom,$Fe05b+6,80);
          hersteller_und_version:=puffer_zu_zk_e(bios_rom.d[0],#0,40);
          hersteller_und_version:=leer_filter(hersteller_und_version);
          if pos('Awa',hersteller_und_version)=0 then
            hersteller_und_version:='Award Software '+hersteller_und_version;
          ausschrift(hersteller_und_version+'  '+bios_datum+exezk,beschreibung);

          if copy(bios_datum,pos_bios_datum_jahr,4)>'1992' then
            begin
              lies(bios_rom,$Fec60,80);
              ec60:=word_z(@bios_rom.d[0])^;
              ausschrift(textz_Chipsatz^+puffer_zu_zk_l(bios_rom.d[$10+1+8+1],bios_rom.d[$10+0]-1-8-1),signatur);
            end;

          (* Fassung *)
          lies(bios_rom,$Fe0bf-$2e,$50+$2e);
          if bytesuche(bios_rom.d[0+$2e],'aN')
          or Bytesuche(bios_rom.d[0    ],'Copyri')
           then
            ausschrift(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(bios_rom.d[2+$2e],#0,$50)),beschreibung);

          flash_suchposition:=$0000;
          repeat
            lies(bios_rom,$f0000+flash_suchposition,512);
            w1:=puffer_pos_suche(bios_rom,'FLASH',500);
            if w1<>nicht_gefunden then
              begin
                if (w1>=3) and bytesuche(bios_rom.d[w1-3],'AWDFLASH') then
                  begin
                    ausschrift(textz_Markierung^+' "AWDFLASH" '+textz_bios__bei^+' $F000:'
                      +hex_word(flash_suchposition+w1-3),signatur);
                    Break;
                  end;
                if (w1>=5) and bytesuche(bios_rom.d[w1-5],'ASUS_FLASH') then
                  begin
                    ausschrift(textz_Markierung^+' "ASUS_FLASH" '+textz_bios__bei^+' $F000:'
                      +hex_word(flash_suchposition+w1-5),signatur);
                    Break;
                  end;
                if (w1>=2) and bytesuche(bios_rom.d[w1-2],'KAFLASH') then
                  begin
                    ausschrift(textz_Markierung^+' "KAFLASH" '+textz_bios__bei^+' $F000:'
                      +hex_word(flash_suchposition+w1-2),signatur);
                    (* kein Break, awadflash folgt noch *)
                  end;
                Inc(flash_suchposition,w1+3);
              end
            else
              inc(flash_suchposition,480);
          until flash_suchposition>$10000;

          if bios_pw_anzeigen then
            if bestimme_bios_kennwort then
              award_pw;

        end; (* award *)

      ami_alt,ami_neu:
        begin

          exezk:='';

          if bios_datum='1990.06.13' then exezk:=' (Martin:286)';
          if bios_datum='1992.11.11' then exezk:=' (Jost:486)';
          if bios_datum='1994.08.31' then exezk:=' (LG2 310,Gateway 2000)';

          ausschrift('AMI '+bios_datum+exezk,signatur);

          if not versuche_ami_chipsatz($F8000) then
            if not versuche_ami_chipsatz($F0000) then
              if not versuche_ami_chipsatz($Ff400) then
                ;

          flash_suchposition:=$fff00;
          repeat
            lies(bios_rom,flash_suchposition,$120);

            if puffer_pos_suche(bios_rom,#$f6#$e0#$c1#$c3#$02#$14#$00#$03#$d8,$120)<>nicht_gefunden then
              begin
                bios_hersteller:=ami_neu;
                break;
              end;

            if puffer_pos_suche(bios_rom,#$f6#$c3#$c3#$7a#$01#$f9#$d0#$db#$fe,$120)<>nicht_gefunden then
              begin
                bios_hersteller:=ami_alt;
                break;
              end;

            dec(flash_suchposition,$100);
          until flash_suchposition=$f0000;

          if bestimme_bios_kennwort then
            begin
              lies(bios_rom,$F0000,16);
              if bios_hersteller=ami_alt then
                (* ALTUS/Peakock        ASCII     1992.11.11 0123AAAAMMMM     *)
                (* Jost                 ASCII     1992.11.11 0123AAAAMMMM     *)
                (* Stobernack           ASCII     1993.04.04 0123AAAAMMMM     *)
                (* AMI-Winbios: WH4     SCAN-CODE 1994.07.25 AMIBIOSC07/25/94 *) (* WH4206B.BIO *)
                (* VPC5                 SCAN-CODE 2002.07.17 AMIBIOSC0800     *)
                ami_pw((Copy(bios_datum,pos_bios_datum_jahr,4)>'1992') and (not bytesuche(bios_rom.d[0],'0123AAAA')))
              else
                (* Keller im LG 2 *)
                ami_bios_neu_pw;
            end;
        end; (* ami_* *)

      quadtel:
        begin
          exezk:='';
          if bios_datum='1991.10.08' then exezk:=' (LG2 / Sobirey)';
          ausschrift('Quadtel '+bios_datum+exezk,signatur);
          anzeige_bios_meldung_systemsoft;
          (*systemsoft-Ñhnlich
          lies(bios_rom,$F710c,180);
          exezk:=puffer_zu_zk_e(bios_rom.d[0],#0,255);
          ausschrift(textz_Chipsatz^+exezk,signatur);*)
          if bestimme_bios_kennwort then
            quadtel_pw;
        end; (* quadtel *)

      chips:
        begin
          exezk:='';
          if bios_datum='1991.03.19' then exezk:=' (LG2 / Frau Altus; LG2 Pool)';
          ausschrift('Chips+Technologies '+bios_datum+exezk,signatur);
          lies(bios_rom,$fe9da,180);
          exezk:=puffer_zu_zk_e(bios_rom.d[0],#0,255);
          ausschrift(textz_Chipsatz^+exezk,signatur);
          if bestimme_bios_kennwort then
            chips_pw;
        end; (* chips *)

      phoenix:
        begin
          exezk:='';
          if bios_datum='1995.04.03' then exezk:=' (LG2 / Bauing-Pool)';
          ausschrift('PHOENIX '+bios_datum+exezk,signatur);
          lies(bios_rom,$fec30,$29);
          if bytesuche(bios_rom.d[0],'$OEMID'#$00) then
            ausschrift(puffer_zu_zk_e(bios_rom.d[7],#0,$21),beschreibung);
          if bestimme_bios_kennwort then
            phoenix_pw;
        end; (* phoenix *)

      microid_research:
        begin
          exezk:='';
          ausschrift('Microid Research '+bios_datum+exezk,signatur);
          (*lies(bios_rom,$F965c,80);
          exezk:=puffer_zu_zk_l(bios_rom.d[1],bios_rom.d[0]);
          ausschrift(textz_Chipsatz^+exezk,signatur); *)

          lies(bios_rom,$FFFA4,$50);
          exezk:=puffer_zu_zk_l(bios_rom.d[0],$4c);
          zeichenfilter(exezk);
          ausschrift(exezk,signatur);
          if bestimme_bios_kennwort then
            microid_research_pw;
        end; (* microid research *)

      linux:
        begin
          ausschrift(textz_verdeckt_durch^+'Linux dosemu "BIOS" '+bios_datum,signatur);
          if bestimme_bios_kennwort then
            ausschrift(textz_Kennwortbestimmung_nicht_moeglich^,signatur);
        end; (* linux *)

      ibm,
      ibm_ps2:
        begin
          ausschrift('IBM '+bios_datum,signatur);
          if bestimme_bios_kennwort then
            ausschrift(textz_Suche_noch_Rechner_fuer_Chipsatz_und_Kennwort^,signatur);
        end; (* ibm* *)

      acer:
        begin
          ausschrift('ACER '+bios_datum,signatur);
          if bestimme_bios_kennwort then
            ausschrift(textz_Suche_noch_Rechner_fuer_Chipsatz_und_Kennwort^,signatur);
        end; (* acer *)

      compaq:
        begin
          ausschrift('COMPAQ '+bios_datum,signatur);

          lies(bios_rom,$f4ff4,2);
          lies(bios_rom,$f0000+word_z(@bios_rom.d[0])^,40);
          if puffer_zu_zk_l(bios_rom.d[40],4)='PCMP' then
            ausschrift(textz_Chipsatz^+puffer_zu_zk_e(bios_rom.d[4+4],#0,20),signatur);

          if bestimme_bios_kennwort then
            ausschrift(textz_noch_nicht_entschluesselt^,signatur);
        end; (* compaq *)

      olivetti:
        begin
          ausschrift('OLIVETTI '+bios_datum,signatur);
          lies(bios_rom,$fe02b,512);
          exezk:=puffer_zu_zk_e(bios_rom.d[0],#$ff,255);
          if length(exezk) in [10..80] then
            ausschrift(exezk,beschreibung);

          {if bestimme_bios_kennwort then
            ausschrift(textz_noch_nicht_entschluesselt^,signatur);}
        end; (* olivetti *)

      icl:
        begin
          ausschrift('Internation Computers Limited '+bios_datum,signatur);
          {Chipsatz?}
          {Kennwort?}
        end; (* icl *)

      bochs:
        begin
          ausschrift('BOCHS x86 Emulator / Kevin Lawton '+bios_datum,signatur);
        end; (* bochs *)

      systemsoft_alt,
      systemsoft:
        begin
          ausschrift('SystemSoft '+bios_datum,signatur);
          (* enthÑlt Chipsatz (nicht bei alter Version) *)
          if bios_hersteller<>systemsoft_alt then
            begin
              lies(bios_rom,$fe010-2,$4b+2);
              if bytesuche(bios_rom.d[0],'IBM') then
                ausschrift(puffer_zu_zk_e(bios_rom.d[4],#0,$4b),beschreibung)
              else
                ausschrift(puffer_zu_zk_e(bios_rom.d[2],#0,$4b),beschreibung);
            end;

          (* Modellnummer *)
          lies(bios_rom,$fff40,$10);
          if bios_rom.d[0]<>0 then
            ausschrift(puffer_zu_zk_e(bios_rom.d[0],#0,14),beschreibung);

          (* BIOS Versionsummer *)

          (*lies(bios_rom,$f0000+word_z(@bios_rom.d[14])^,512);
          ausschrift(puffer_zu_zk_e(bios_rom.d[0],#0,255),beschreibung);*)

          anzeige_bios_meldung_systemsoft;


          (* Kennwîrter *)
          if bestimme_bios_kennwort then
            begin
              (* Alg. benutzt F7 E1 *)
              suche_syso(cmos($52)+cmos($52+1) shl 8,'BOOT : ');
              suche_syso(cmos($46)+cmos($46+1) shl 8,'SCU  : ');
              ausschrift('oder "KAPOK", "SYSFinside" ...',normal); (* "BIOS SCU" 2b42/2c42 *)
            end;

        end; (* systemsoft *)

      systemsoft_boot:
        begin
          flash_suchposition:=$100000-max_rueckwaerts;
          lies(bios_rom,flash_suchposition,2);
          if bytesuche(bios_rom.d[0],#$ee#$88) then
            systemsoft_bios_archiv(flash_suchposition);

          ausschrift(bios_datum,signatur);
        end; (* systemsoft_boot *)

      toshiba:
        begin
          ausschrift('Toshiba '+bios_datum,signatur);
          lies(bios_rom,$fe000,$10);
          ausschrift(puffer_zu_zk_e(bios_rom.d[0],#0,$10),beschreibung);
        end; (* toshiba *)

      tinybios:
        begin
          ausschrift('tinyBIOS '+bios_datum,signatur);
          anzeige_bios_meldung_systemsoft; (* Chipsatz/twoOStwo *)
          (* kein Kennwort *)
        end; (* twoOStwo *)


    (*$IfNDef ENDVERSION*)
    else
      runerror(0);
    (*$EndIf*)
    end;

    if ncr_bios<>'' then
      ausschrift(ncr_bios,signatur);

  end;

end.

