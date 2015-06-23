(*$X+*)
program rename_ea_data_sf;
(*$PMTYPE VIO*)

(* Umbenennen von \EA DATA. SF damit diese Datei l”schbar ist *)
(* 1999.06.21 Veit Kannegieser *)

uses
  OS2Base,
  OS2Def,
  VpUtils,
  VpSysLow,
  Strings,
  r_ea_spr;

const
  datum='1999.06.22';

type
  sektor_typ=
    packed record
      jmp                       :array[$00..$02] of byte;
      name_                     :array[$03..$0a] of char;
      byte_je_sektor            :smallword;
      sektoren_je_kl            :byte;
      reservierte_sektoren      :smallword;
      fat_anzahl                :byte;
      hauptverzeichnis_laenge   :smallword;
      anzahl_sektoren_16        :smallword;
      media_descriptor          :byte;
      sektoren_je_fat           :smallword;
      rest                      :array[$18..$1ff] of byte;
    end;

  verzeichnis_eintrag_typ=
    packed record
      name_                     :array[1..8] of char;
      erweiterung               :array[1..3] of char;
      attribute                 :byte;
      rest1                     :array[$0c..$19] of byte;
      startcluster              :word;
      dateigroesse              :longint;
    end;

  verzeichnis_sektor_typ        =array[1..16] of verzeichnis_eintrag_typ;

procedure abbruch(const zk:string);
  begin
    WriteLn(zk);
    Halt(1);
  end;

function fehlertext(const n:longint):string;
  var
    meldung:array[0..255] of char;
    ml:longint;
  begin
    fehlertext:=StrPas(SysGetSystemError(n,PChar(@meldung),SizeOf(meldung),ml));
  end;

function bestimme_ifs(const laufwerk:char):string;
  var
    fehler:smallword;
    laufwerk_zk:string[3];
    ifs_puffer:Array[0..sizeof(FSQBUFFER2) + (3 * CCHMAXPATH)] of char;
    ifs_puffer_groesse:longint;
    ifsname_pos:smallword;
  begin
    fillchar(ifs_puffer,sizeof(ifs_puffer),0);
    laufwerk_zk:=laufwerk+':'+#0;
    ifs_puffer_groesse:=sizeof(ifs_puffer);

    fehler:=DosQueryFSAttach(pchar(@laufwerk_zk[1]),1,FSAIL_QUERYNAME,pFsqBuffer2(@ifs_puffer),ifs_puffer_groesse);

    ifsname_pos:=8;
    while ifs_puffer[ifsname_pos]<>#0 do
      inc(ifsname_pos);

    inc(ifsname_pos);
    bestimme_ifs:=StrPas(@ifs_puffer[ifsname_pos]);
  end;

var
  laufwerk:string;
  rc:longint;
  handhabe:longint;
  ulAction:longint;
  nullbefehl_laenge:longint;
  neues_ifs_name_laenge:longint;

const
  nullbefehl:byte=0;
  neues_ifs_name:string=#0;


function lies(const sektor:longint;var p):longint;
  var
    rc:longint;
    ergebnis:longint;
  begin
    rc:=
    DosSetFilePtr(
      handhabe,
      sektor*512,
      FILE_BEGIN,
      ergebnis);
    if rc<>0 then
      lies:=rc
    else
      begin
        lies:=
        DosRead(
          handhabe,
          p,
          512,
          ergebnis);
      end;
  end;

function schreibe(const sektor:longint;var p):longint;
  var
    rc:longint;
    ergebnis:longint;
  begin
    rc:=
    DosSetFilePtr(
      handhabe,
      sektor*512,
      FILE_BEGIN,
      ergebnis);
    if rc<>0 then
      schreibe:=rc
    else
      begin
        schreibe:=
        DosWrite(
          handhabe,
          p,
          512,
          ergebnis);
      end;
  end;

procedure arbeit;
  type
    sektoren_block      =array[0..2048] of sektor_typ;
  var
    startsektor         :sektor_typ;
    verz_sektor         :verzeichnis_sektor_typ;
    hauptverzeichnis    :^sektoren_block;
    zaehler             :longint;
    sektor_nummer       :longint;
    name_neu            :string[8];
  begin
    if lies(0,startsektor)<>0 then
      WriteLn(textz_Lesefehler^)
    else
      begin
        if startsektor.byte_je_sektor<>512 then
          begin
            Writeln(startsektor.byte_je_sektor,textz_Byte_je_Sektor_^);
            exit;
          end;

        zaehler:=1;
        repeat
          if (zaehler mod high(verzeichnis_sektor_typ))=1 then
            begin
              sektor_nummer:=startsektor.sektoren_je_fat*startsektor.fat_anzahl
                            +startsektor.reservierte_sektoren
                            +(zaehler-1) div high(verzeichnis_sektor_typ);
              if lies(sektor_nummer,verz_sektor)<>0 then break;
            end;

          with verz_sektor[zaehler mod high(verzeichnis_sektor_typ)] do
            begin
              if  (name_='EA DATA ')
              and (erweiterung=' SF')
              and ((attribute and $10)=0)
               then
                begin
                  name_neu:='EA_D'+Int2Hex(startcluster,4);
                  Move(name_neu[1],name_,SizeOf(name_));
                  erweiterung:='_SF';
                  attribute:=0;
                  Write('EA DATA. SF -> ',name_neu,'._SF');
                  schreibe(sektor_nummer,verz_sektor);
                  WriteLn;
                  break;
                end;
            end;
          inc(zaehler);
        until zaehler>startsektor.hauptverzeichnis_laenge;
      end;
  end;

begin
  WriteLn('R_EADATA * Veit Kannegieser * ',datum);
  Writeln(textz_zweck^);

  if ParamCount<>1 then
    abbruch(textz_hilfe^);

  laufwerk:=ParamStr(1);
  laufwerk[1]:=UpCase(laufwerk[1]);
  if Length(laufwerk)=Length('X') then
    laufwerk:=laufwerk+':';

  if (Length(laufwerk)<>Length('X:'))
  or (not (laufwerk[1] in ['A'..'Z','[','\',']','^','_','`']))
  or (laufwerk[2]<>':')
   then
    abbruch(textz_hilfe^);

  if bestimme_ifs(laufwerk[1])<>'FAT' then
    abbruch(textz_kein_fat^);

  laufwerk:=laufwerk+#0;

  rc:=
  DosOpen(
    @laufwerk[1],
    handhabe,
    ulAction,
    0,
    0,
    FILE_OPEN,
    OPEN_FLAGS_DASD or OPEN_SHARE_DENYNONE or OPEN_ACCESS_READWRITE,
    nil);

  if rc<>0 then
    abbruch(textz_kann_nicht_oeffnen^+^m^j
      +fehlertext(rc));

  nullbefehl_laenge:=0;
  rc:=
  DosDevIOCtl(
    handhabe,
    IOCTL_DISK,DSK_LOCKDRIVE,
    @nullbefehl,1,@nullbefehl_laenge,
    nil,0,nil);

  if rc<>0 then
    begin
      WriteLn(textz_kann_nicht_sperren^+^m^j
        +fehlertext(rc));
    end
  else
    begin
      rc:=
      DosDevIOCtl(
        handhabe,
        IOCTL_DISK,DSK_BEGINFORMAT,
        @neues_ifs_name[1],length(neues_ifs_name),@neues_ifs_name_laenge,
        @nullbefehl,1,@nullbefehl_laenge);
      if rc<>0 then
        begin
          WriteLn(textz_kann_dateisystem_nicht_abmelden^+^m^j
            +fehlertext(rc));
        end
      else
        begin
          arbeit;

          DosDevIOCtl(
            handhabe,
            IOCTL_DISK,DSK_REDETERMINEMEDIA,
            @nullbefehl,1,@nullbefehl_laenge,
            nil,0,nil);
        end;

      DosDevIOCtl(
        handhabe,
        IOCTL_DISK,DSK_UNLOCKDRIVE,
        @nullbefehl,1,@nullbefehl_laenge,
        nil,0,nil);
    end;

  DosClose(
    handhabe);

end.

