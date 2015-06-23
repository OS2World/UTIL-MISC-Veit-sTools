(*$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q-,R+,S+,T-,V+,X+*)
(*$IFNDEF DEBUG*)
(*$D-,L-,R-,S-*)
(*$ENDIF*)

(*$IFDEF VIRTUALPASCAL*)
  (*$D VPART INSTALL PROGRAM * Veit Kannegieser *)
  (*$M 100000*)
  (*$USE32+*)
  (*$Alignrec-*)
(*$ELSE*)
  (*$M 60000,0,0*)
  (*$M 60000,200000,200000*)
(*$ENDIF*)

(* xx.yy.199z ....                                                      *)
(* 11.03.1998 crt,spra_aus neu                                          *)
(* 04.04.1998 pcx-Import                                                *)
(* 24.06.1998 ˛ Tausch von Eintrag 10                                   *)
(*            ˛ Tausch nicht angezeigt bei Pa·worteingabe               *)
(*            ˛ Benutzung von Log-Datei zur Neuinstallation             *)
(*              wenn schon installiert                                  *)
(*            ˛ LÑngenbeschrÑnkung Titeleingabe                         *)
(*            ˛ furchtbare Rechtschreibfehler (eng)                     *)
(* 03.08.1998 Palette Ehm geÑndert                                      *)
(* 04.09.1998 Tauschen von EintrÑgen funktioniert wieder                *)
(*            kein R-Error 100 wenn Partition ohne ico_namen: pcx('')   *)
(* 12.09.1998 Anzeige der Grî·e nicht nur bei FAT,formatiert            *)
(*            gemischte Anzeige KB/MB                                   *)
(*            mehr Partitionstypen                                      *)
(* 1999.01.16 2 Sektoren mehr, Erweiterung "VPART.EXT"                  *)
(* 1999.02.03 IBM Bootmanager Name                                      *)
(* 1999.03.18 Gigabyte: $04b5 / Asus: $04e5                             *)
(*            OS/2 Installationsprogramm                                *)
(* 1999.06.21 $82 ist auch Solaris 7 -> bootbar                         *)
(* 2000.05.20 Bootsektor fÅr NTLDR hinzugefÅgt                          *)
(*            TastendrÅcke in den Tastaturpuffer schreiben              *)
(*            >1024 Zylinder                                            *)
(*            jfs,nextstep                                              *)
(*            Installationsprogramm menÅgesteuert                       *)
(*            CMOS,CDROM,SETBOOT,Tastatur,Maus,..                       *)
(* 2000,2001  APM-Batterieanzeige, "I13X" fÅr OS/2, FAT:VPART.CFG,      *)
(*            Netzwerkkarten-ROM, LVM-Laufwerksbuchstaben und           *)
(*            Partitionsnamen                                           *)


(*$IFNDEF VirtualPascal*)
  (*$DEFINE DOS*)
(*$ENDIF*)

(*$IFDEF DOS   *) (*$DEFINE DOS_DPMI32*) (*$ENDIF*)
(*$IFDEF DPMI32*) (*$DEFINE DOS_DPMI32*) (*$ENDIF*)



program vpartein;

uses
  int_13,
  int_2526,
  mb1,
  VioWin,
  (*$IFDEF VirtualPascal*)
  (*$IFDEF DPMI32*)
  DPMI32,
  DPMI32df,
  (*$IFDEF DEBUG*)
  deb_link,
  (*$ENDIF DEBUG*)
  (*$ENDIF DPMI32*)
  (*$IFDEF OS2*)
  OS2Base,
  OS2Def,
  (*$ENDIF OS2*)
  VpSysLow,
  VpUtils,
  (*$ELSE VirtualPascal*)
  TpSysLow,
  TpUtils,
  (*$ENDIF VirtualPascal*)
  Dos,
  Crt,
  vpe_obji,
  vpe_objd,
  vpe_obje,
  vpe_spr,
  vpe_eing;

(*$I ..\IMPPCX\IMPPCXI.PAS *)

const
  vpartein_datum                ='..'+ (*+12.09.1998';*)
                                (*$I ..\DATUM.PAS*);
  lvm_sekoren_bedarf            =1; (* Ein LVM-Sektor zu jeder Partitionstabelle *)

  vpart2sektoren                =39;
  vpart2start           :byte   =10+1;
  festplattenzahl       :byte   =0;
  fat_vpart_name                ='VPART.FAT';
  sektoren_je_kb                =2;
  sektoren_je_mb                =sektoren_je_kb*1024;
  zeilenzahl                    =10;
  betriebssystem_titel_laenge   =20;
  tasten_tab            :array[1..zeilenzahl] of string[3]=
    ('F1 ',
     'F2 ',
     'F3 ',
     'F4 ',
     'F5 ',
     'F6 ',
     'F7 ',
     'F8 ',
     'F9 ',
     'F10');

  plugin_dateiname              ='VPART.EXT';
  ziel                  :ziel_typ=unbekannt;
  ziel_moeglich         :array[ziel_typ] of boolean=(true,true,true,false);

  (* siehe auch CMOS.A86 *)
  biostyp_unbekannt             =0;
  biostyp_Award                 =1;
  biostyp_AMI_Hi_Flex           =2;
  biostyp_AMI_WinBIOS           =3;
  biostyp_SystemSoft            =4;

  biostyp_FAT_cfg               =$ff;

  biostyp_namen_tabelle         :array[biostyp_unbekannt..biostyp_SystemSoft] of string[15]=
    ('N',
     'AWARD',
     'AMI_HIFLEX',
     'AMI_WINBIOS',
     'SYSTEMSOFT');


  wiederholrate:array[0..31] of string [4]=
    ('30,0','26,7','24,0','21,8',
     '20,0','18,5','17,1','16,0',
     '15,0','13,3','12,0','10,9',
     '10,0',' 9,2',' 8,5',' 8,0',
     ' 7,5',' 6,7',' 6,0',' 5,5',
     ' 5,0',' 4,6',' 4,3',' 4,0',
     ' 3,7',' 3,3',' 3,0',' 2,7',
     ' 2,5',' 2,3',' 2,1',' 2,0');

  anzahl_partitionen_versteckbar=8;

  exename=
    (*$IFDEF VirtualPascal*)
      (*$IFDEF OS2*)
        'VPARTOS2';
      (*$ENDIF OS2*)
      (*$IFDEF DPMI32*)
        'VPARTD32';
      (*$ENDIF DPMI32*)
    (*$ELSE  VirtualPascal*)
       'VPARTDOS';
    (*$ENDIF VirtualPascal*)

type
  word_norm=
    (*$IFDEF VIRTUALPASCAL*)
                        longint;
    (*$ELSE*)
                        word;
    (*$ENDIF*)

  smallword_z           =^smallword;

  zeile=
    packed record
      taste                     :string[3];
      ico                       :symb_typ;
      name_                     :string[betriebssystem_titel_laenge];
      cx_reg                    :smallword;
      dx_reg                    :smallword;
      boot_hidden_sekt          :longint;
      boot_undok_lw             :byte;
      system_trick              :byte;
      tastendruecke_anzahl      :byte;
      tastendruecke             :array[1..8] of smallword;
      laufwerke_verstecken      :array[1..anzahl_partitionen_versteckbar] of byte;
      (* Bit76   : énderung Partitionstyp
         Bit5    : énderung Buchstabe
         Bit43210: Buchstabe-Ord('A')        *)
    end;

  partitions_eintrag=
    packed record
      boot_indicator    :byte;
      start_dh          :byte;
      start_cx          :smallword;
      system_indicator  :byte;
      ende_dh           :byte;
      ende_cx           :smallword;
      sektoren_davor    :longint;
      anzahl_sektoren   :longint;
    end;

  partitionstabellentyp=
    packed record
      case integer of
       1:(sprung_                               :packed array[0..2] of byte;
          name_vpart                            :packed array[3..10] of char;
          vpart2sektoren                        :byte;
          vpart2_cx                             :smallword;
          vpart2_dx                             :smallword;
          versteckt                             :char;);

       2:(sprung                                :packed array[0..2] of byte;
          name_boot                             :packed array[3..10] of char;
          byte_je_sektor                        :smallword;
          sektoren_je_kluster                   :byte;
          anzahl_reservierte_sektoren           :smallword;
          anzahl_fat                            :byte;
          anzahl_hauptverzeichnis_eintraege     :smallword;
          anz_sektoren                          :smallword;
          medienbeschreibungsbyte               :byte;
          sektoren_je_fat                       :smallword;
          sektoren_pro_spur                     :smallword;
          koepfe                                :smallword;
          versteckte_sektoren                   :smallword;
          x_1e_1f                               :packed array[$1e..$1f] of byte;
          anz_sektoren_neu                      :longint;
          physikalische_laufwerksnummer         :byte;
          reserviert_25                         :byte; (* Laufwerksnummer,chkdsk *)
          signaturbyte                          :byte;
          datentraeger_seriennummer             :longint;
          datentraegername                      :packed array[$2b..$35] of char;
          dateisystem                           :packed array[1..8] of char;
          code                                  :packed array[$3e..$189] of byte;
          byte_01                               :byte;
          bootmanager_name                      :packed array[0..8] of char;
          bootmanager_zusatz                    :packed array[0..8] of char;
          unbekannt                             :packed array[$19d..$1bd] of byte;
          partidaten                            :packed array[1..4] of partitions_eintrag;
          ibm_signatur                          :smallword;);

       3:(f32_1                                 :packed array[$00..$40] of byte; (* $00..$41 *)
          reserviert_log_laufnummer_fat32       :byte;
          signaturbyte_fat32                    :byte;                           (* $42      *)
          f_43_46                               :packed array[$43..$46] of byte; (* $43..$46 *)
          datentraegername_fat32                :packed array[1..11] of char;    (* $47..$51 *)
          fat32_sig                             :packed array[1..8] of char;);   (* $52 *)

    end;

  palette_typ                   =packed array[$00..$1c] of byte;

  vpart2_kopf_typ=
    packed record
      int20                     :smallword;
      sprung                    :packed array[$02..$03] of byte;
      datum                     :packed array[$04..$0e] of char;
      plugin_ofs                :smallword;
      plugin_laenge             :smallword;
      rest                      :packed array[$13..$1ff] of byte;
    end;

  diskettentyp_typ=(diskettentyp_fehler,diskettentyp_13cm,diskettentyp_09cm,diskettentyp_sonst,diskettentyp_festplatte);

  zu_versteckende_partitionen_typ=
    packed array[1..8] of
      packed record
        cx_reg,dx_reg           :smallword; (* $0001,$0080 *)
        lba                     :longint;   (* -1          *)
        partitionstyp_sichtbar  :byte;      (* $06         *)
        partitionstyp_unsichtbar:byte;      (* $16         *)
        lvm_informationssektor  :byte;      (* +62         *)
        eintrag                 :byte;      (* 2           *)
        startsektorzylinder     :smallword;
      end;


const
  pal_blau:palette_typ=(0,1,2,3,4,5,6,7,8,9,$a,$b,$c,$d,$e,$f, $9,$f,$f,$0,$1,$e,$c,$e,$e,$1,$0,$8,$f);
  pal_ehm :palette_typ=(0,1,2,3,4,5,6,7,8,9,$a,$b,$c,$d,$e,$f, $2,$2,$4,$0,$a,$8,$e,$8,$a,$0,$0,$8,$f);

var
  ziel_laufwerk                 :char;
  antwort                       :string;
  fehler                        :word_norm;
  zae                           :byte;
  dateiname                     :string;
  para                          :string;
  boot_sektor_fat               :packed array[1..512] of byte;
  backup                        :packed array[1..512] of byte;
  vpart1                        :packed array[1..512] of byte;
  vpart2                        :packed array[1..vpart2sektoren] of packed array[1..512] of byte;
  vpart3                        :packed array[1..512] of byte;
  partitionstabellen_kopie      :packed array[1..512] of byte;
  fuell                         :packed array[1..512] of byte;

  ergebnis:
    packed record
      anfang                    :packed array[0..$4F] of byte;
      passwort                  :string[20];
      anzahl_lw,
      standard_lw,
      biostyp                   :smallword;
      tastenverzoegerung        :byte;
      tastenwiederholrate       :byte;
      tabelle                   :packed array[1..zeilenzahl] of zeile;
      endzeit                   :longint;
      bios_speicher             :smallword;
      schlafzeit                :packed array[1..4] of byte;
      text_oder_grafikmodus     :char;
      vpart_versteckt           :char;
      maus_parameter            :smallword;
      palette                   :palette_typ;
      blenden                   :char; (* '1' '2' '3' *)
      benutze_apm               :boolean;
      fat_konfiguration_position_dl      :byte;
      fat_konfiguration_position_log     :longint;
      fat_konfiguration_sektoren_je_spur :smallword;
      fat_konfiguration_anzahl_koepfe    :smallword;
      a20_abschalten            :boolean;
      zu_versteckende_partitionen:zu_versteckende_partitionen_typ;

    end absolute vpart2;




  datei                         :file;
  w                             :word_norm;
  eintrag_1,
  eintrag_2                     :byte;
  swap_eintrag                  :zeile;
  val_fehler                    :word_norm;
  palette_datei                 :file;
  gelesen                       :word_norm;
  award_tauscher_variable       :smallword;
  kontrolle                     :integer;

  fp80,fp81:
    record
      cylinders,
      num_heads,
      sectors                   :longint;
      floppy_type               :byte;
    end;

  kurztaste                     :string;

  setbootc_cfg                  :text;



function realstring_mal12_zu_byte(const zk:string;var ergebnis:byte):boolean;
  var
    vorkomma,
    nachkomma           :string;
    vorkomma_val,
    nachkomma_val       :longint;
    kontrolle           :word_norm;
  begin
    realstring_mal12_zu_byte:=false;
    if Pos(',',zk)>0 then
      begin
        vorkomma:=Copy(zk,1,pos(',',zk)-1);
        nachkomma:=Copy(zk,pos(',',zk)+1,2);
      end
    else
      if Pos('.',zk)>0 then
        begin
          vorkomma:=Copy(zk,1,pos('.',zk)-1);
          nachkomma:=Copy(zk,pos('.',zk)+1,2);
        end
      else
        begin
          vorkomma:=zk;
          nachkomma:='';
        end;

    nachkomma:=nachkomma+'00';
    nachkomma[0]:=#2; (* nur /100 *)
    Val(vorkomma,vorkomma_val,kontrolle);
    if kontrolle<>0 then exit;
    Val(nachkomma,nachkomma_val,kontrolle);
    if kontrolle<>0 then exit;

    if vorkomma_val>=20 then
      ergebnis:=$ff
    else
      ergebnis:=byte((vorkomma_val*100+nachkomma_val)*12 div 100);
    realstring_mal12_zu_byte:=true;
  end;

function ohne_steuerzeichen(const zk:string):boolean;
  var
    zaehler:word_norm;
  begin
    ohne_steuerzeichen:=true;
    for zaehler:=1 to Length(zk) do
      if zk[zaehler]<' ' then
        begin
          ohne_steuerzeichen:=false;
          break;
        end;
  end;

procedure bestimmer_award_tauscher_variable;
  var
    z0,z1,o             :word_norm;
    gleich              :boolean;
    (*$IFDEF VIRTUALPASCAL*)
    bios_f000           :array[0..$fff0-1] of byte;
    (*$ENDIF*)
  const
    zk1:string[11]=#$c6#$46#$fa#$00
                  +#$8a#$ca
                  +#$d0#$e1
                  +#$26#$8a#$16;
    zk2:string[18]=#$00
                  +#$d2#$ea
                  +#$80#$e2#$03
                  +#$88#$56#$ff
                  +#$80#$fa#$02
                  +#$72#$04
                  +#$c6#$46#$fa#$80;
  begin
    (* 40:e5 asus
       40:b5 gigabyte

       C6 46 FA 00             mov byte ptr [bp-6],000
       8A CA                   mov cl,dl
       D0 E1                   shl cl,1
       26 8A 16 XX 00          mov dl,es:[00XX]
       D2 EA                   shr dl,cl
       80 E2 03                and dl,3
       88 56 FF                mov [bp-1],dl
       80 FA 02                cmp dl,2
       72 04                   jnc +4
       C6 46 FA 80             mov byte ptr [bp-6],080   *)
    award_tauscher_variable:=0;
    (*$IFDEF VIRTUALPASCAL*)
    bios_speicher_lesen(bios_f000);
    (*$ENDIF*)

    for z0:=0 to $fff0-20 do
      (*$IFDEF VIRTUALPASCAL*)
      if bios_f000[z0]=$c6 then
      (*$ELSE*)
      if Mem[$f000:z0]=$c6 then
      (*$ENDIF*)
        begin
          gleich:=true;

          for z1:=1 to Length(zk1) do
            (*$IFDEF VIRTUALPASCAL*)
            gleich:=gleich and (bios_f000[z0+z1-1]=Ord(zk1[z1]));
            (*$ELSE*)
            gleich:=gleich and (Mem[$f000:z0+z1-1]=Ord(zk1[z1]));
            (*$ENDIF*)

          for z1:=1 to Length(zk2) do
            (*$IFDEF VIRTUALPASCAL*)
            gleich:=gleich and (bios_f000[z0+Length(zk1)+1+z1-1]=Ord(zk2[z1]));
            (*$ELSE*)
            gleich:=gleich and (Mem[$f000:z0+Length(zk1)+1+z1-1]=Ord(zk2[z1]));
            (*$ENDIF*)

          if gleich then
            begin
              (*$IFDEF VIRTUALPASCAL*)
              award_tauscher_variable:=$0400+bios_f000[z0+Length(zk1)];
              (*$ELSE*)
              award_tauscher_variable:=$0400+Mem[$f000:z0+Length(zk1)];
              (*$ENDIF*)
              exit;
            end;
        end;
  end;

(*$IFDEF DPMI32*)
function os2_aktiv:boolean;
  begin
    os2_aktiv:=os2;
  end;
(*$ENDIF DPMI32*)

(*$IFNDEF VirtualPascal*)
function os2_aktiv:boolean;assembler;
  asm
    mov ax,$4010
    int $2f
    cmp ax,$4010
    mov al,false
    je @os2_aktiv_ende
    mov al,true
  @os2_aktiv_ende:
  end;
(*$ENDIF DPMI32*)


procedure fehlerbehandlung;
  begin
    fehler:=IOResult;
    case fehler of
       0:;
       2:Write(textz_dos_fehler_002^);
       3:Write(textz_dos_fehler_003^);
       4:Write(textz_dos_fehler_004^);
       5:Write(textz_dos_fehler_005^);
      15:Write(textz_dos_fehler_015^);
     100:Write(textz_dos_fehler_100^);
     101:Write(textz_dos_fehler_101^);
     102:Write(textz_dos_fehler_102^);
     103:Write(textz_dos_fehler_103^);
     104:Write(textz_dos_fehler_104^);
     105:Write(textz_dos_fehler_105^);
     106:Write(textz_dos_fehler_106^);
     150:Write(textz_dos_fehler_150^);
     151:Write(textz_dos_fehler_151^);
     152:Write(textz_dos_fehler_152^);
     154:Write(textz_dos_fehler_154^);
     156:Write(textz_dos_fehler_156^);
     157:Write(textz_dos_fehler_157^);
     158:Write(textz_dos_fehler_158^);
     159:Write(textz_dos_fehler_159^);
     160:Write(textz_dos_fehler_160^);
     161:Write(textz_dos_fehler_161^);
     162:Write(textz_dos_fehler_162^);
     200:Write(textz_dos_fehler_200^);
    else
         Write(textz_Fehler^,' #',fehler);
    end;
    WriteLn;
  end;



function dos_lesen(var s;const lauf:char):word_norm;
  begin
    dos_lesen:=read_logical_sector(Ord(UpCase(lauf))-Ord('A'),s,0);
  end;


function dos_schreiben(var s;lauf:char):byte;
  var
    l                   :byte;
    h                   :word_norm;
    f                   :longint;
    xo,yo,ao            :byte;
    meldung,hilfe       :string;
    liste_menu          :auswahl_tabelle_typ;
  begin
    l:=Ord(UpCase(lauf))-Ord('A');

    repeat
      f:=lock_logical_drive(l,h);


      if f=0 then
        begin
          f:=write_logical_sector(l,s,0);
          unlock_logical_drive(l,h);
        end;

      if f<>0 then
        begin
          meldung:=textz_Schreibfehler^;
          hilfe  :=textz_Antivirenprogramm_entfernen_Schreibschutzschieber_bewegen^;

          if (f and lock_error_taskmgr)=lock_error_taskmgr then
            begin
              meldung:=textz_im_Taskmgr_sind_noch_mehrere_Prozesse_geladen^;
              hilfe  :=textz_alle_anderen_Prozesse_beenden^;
            end;

          if (f and lock_error_os2    )=lock_error_os2     then
            begin
              meldung:=textz_kein_ausschliesslicher_Zugriff_auf_das_Laufwerk_moeglich^;
              hilfe  :=textz_alle_offenen_Dateien_schliessen^;
            end;

          repeat

            auswahlliste_neu(liste_menu,false);
            auswahlliste_eintrag(liste_menu,textz_Wiederholen^ ,textz_Wiederholen_taste^ [1],'W',hilfe);
            auswahlliste_eintrag(liste_menu,textz_Abbruch^     ,textz_Abbruch_taste^     [1],'A',hilfe);
            auswahlliste_eintrag(liste_menu,textz_komandozeile^,textz_komandozeile_taste^[1],'K',hilfe);

            antwort:=auswahlliste_anzeigen(liste_menu,'W',meldung,'');

            if antwort[1]='K' then
              Befehlszeile;

          until antwort[1]<>'K';

          if antwort[1]='A' then (* Abbruch *)
            Break;

        end;

    until f=0;

    dos_schreiben:=f;
  end;

(*$I VPE_SUCH.PAS*)


(*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)
(*€€                                                                    €€*)
(*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)

var
  plugin                        :file;
  plugin_datei_laenge           :word_norm;
  award_bios_variable_patch1,
  award_bios_variable_patch2    :word_norm;
  liste_menu                    :auswahl_tabelle_typ;
  tmpzk                         :string;
  fragezk                       :string;
  bios_speicher_jetzt           :smallword;
  gleich                        :boolean;

begin
  {
  TextMode(Co80+Font8x8);
  VioWin.XMax := Lo(WindMax)+1;
  VioWin.YMax := Hi(WindMax)+1;}

  FileMode:=0;
  CheckBreak:=true;
  (*$IFNDEF VIRTUALPASCAL*)
  SetCBreak(true);
  (*$ENDIF*)

  (* Bildschirm aufbereiten *)
  spalten:=VioWin.XMax;
  zeilen :=VioWin.YMax;
  if (spalten<80) or (zeilen<25) then
    begin
      TextMode(Co80);
      VioWin.XMax := Lo(WindMax)+1;
      VioWin.YMax := Hi(WindMax)+1;
    end;
  spalten:=VioWin.XMax;
  zeilen :=VioWin.YMax;
  org_cursor:=GetCursorSize;
  cursor_unsichtbar;

  FillScreen(1,1                          ,spalten,zeilen-anzahl_hilfezeilen,log_farbe,' ');
  FillScreen(1,zeilen-anzahl_hilfezeilen+1,spalten,zeilen,hilfe_farbe,' ');
  Window(1,1,spalten,zeilen-anzahl_hilfezeilen);
  TextAttr:=log_farbe;

  WriteLn;
  WriteLn('  ',exename,' * ',textz_Einrichtungsprogramm_fuer_Betriebssystemauswahl^,' VPART');
  WriteLn('  Veit Kannegieser '+vpartein_datum);
  WriteLn;

  para:=ParamStr(1)+' ';
  while (para<>'') and (para[1] in ['-','/']) do Delete(para,1,1);

  programmverwendung:=programmverwendung_unbekannt;
  while programmverwendung=programmverwendung_unbekannt do
    case UpCase(para[1]) of
      'I':programmverwendung:=installation;
      'T':programmverwendung:=testprogramm;
      'U':programmverwendung:=entfernen;
      'P':programmverwendung:=passwort_setzen;
      'A':programmverwendung:=schnellkonfigurtaion;
      '?':programmverwendung:=hilfe_bildschirm;
    else
      auswahlliste_neu(liste_menu,false);

      auswahlliste_eintrag(liste_menu,textz_I_Installation^        ,'I','I',textz_I_Installation_hilfe^);
      auswahlliste_eintrag(liste_menu,textz_T_Testprogramm^        ,'T','T',textz_T_Testprogramm_hilfe^);
      auswahlliste_eintrag(liste_menu,textz_U_VPart_entfernen^     ,'U','U',textz_U_VPart_entfernen_hilfe^);
      auswahlliste_eintrag(liste_menu,textz_P_Passwort^            ,'P','P',textz_P_Passwort_hilfe^);
      auswahlliste_eintrag(liste_menu,textz_A_Schnellkonfiguration^,'A','A',textz_A_Schnellkonfiguration_hilfe^);
      auswahlliste_eintrag(liste_menu,textz_f_Komandozeilenhilfe^  ,'?','?',textz_f_Komandozeilenhilfe_hilfe^);

      para:=auswahlliste_anzeigen(liste_menu,'I',textz_Was_wuenschen_Sie^,'');
    end;

  if (programmverwendung=hilfe_bildschirm)
  or (ParamCount>3)
   then
    begin
      WriteLn('  ',exename,'.EXE <',textz_Befehl^,'> [<',textz_Eingabedatei^,'> [<',textz_Protokolldatei^,'>]]');
      WriteLn;
      WriteLn('  ',textz_Befehle^,' :');
      WriteLn('    I ... ',textz_Installation_Betriebssystemsuche^,' + P + A');
      WriteLn('    P ... ',textz_Passworteingabe^);
      WriteLn('    A ... ',textz_Standard_System_Hauptspeicher_und_Wartezeit^);
      WriteLn('    U ... ',textz_Programm_entfernen^);
      WriteLn('    T ... ',textz_TEST_COM_erzeugen_sonst_wie_I^);
      WriteLn;
      WriteLn('  ',textz_Beispiel_^,exename,' i con vpart.log');
      WriteLn;
      hilfestatus(textz_weiter_mit_Tastendruck^);
      SysReadKey;
      abbruch('');
    end;

  oeffne_quelle(ParamStr(2));
  oeffne_log   (ParamStr(3));

  schreibe_log_kommentar(kommentarbalken);
  schreibe_log_kommentar(exename+' * '+vpartein_datum);
  schreibe_log_kommentar(kommentarbalken);
  schreibe_log_kommentar('');


  (** Virensicherheit **********************************************)
  Write(textz_Ist_dieses_System_virenfrei^+' ? ');
  antwort:=ja_nein_frage(
    textz_Ist_dieses_System_virenfrei^+' ?',
    ' ',
    'VIR',
    '');

  antwort_ausschrift(ja_nein_str(antwort[1]));

  if antwort='N' then
    Abbruch_durch_den_Benutzer;


  (** Festplattenparameter ermitteln, Anzahl Sektoren je Spur gro· genug ? *)
  with fp80 do
    begin
      FillChar(fp80,SizeOf(fp80),0);
      get_phys_drive_parameters($80,cylinders,num_heads,sectors,floppy_type);
    end;
  with fp81 do
    begin
      FillChar(fp81,SizeOf(fp81),0);
      get_phys_drive_parameters($81,cylinders,num_heads,sectors,floppy_type);
    end;


  if read_phys_sector($80,
                      0,0,1,
                      fp80.num_heads,fp80.sectors,
                      sector_typ(vpart1))<>0 then
    begin
      WriteLn(#7,textz_keine_Fesplatte_vorhanden^);
      WriteLn(textz_Installation_in_Spur_0_deshalb_nicht_moeglich^);
      ziel_moeglich[spur0]:=false;
    end
  else
    if partitionstabellentyp(vpart1).ibm_signatur<>$AA55 then
      begin
        WriteLn(textz_keine_gueltige_Partitionstabelle_erst_Fdisk^);
        WriteLn(textz_Installation_in_Spur_0_deshalb_nicht_moeglich^);
        ziel_moeglich[spur0]:=false;
      end;

  if read_phys_sector($81,
                      0,0,1,
                      fp81.num_heads,fp81.sectors,
                      sector_typ(vpart3))<>0 then
    ziel_moeglich[spur0_mit_awardbios]:=false
  else
    if partitionstabellentyp(vpart3).ibm_signatur<>$AA55 then
      ziel_moeglich[spur0_mit_awardbios]:=false;


  with partitionstabellentyp(vpart1) do
    begin

      if  (sprung[0]=$eb)
      and (sprung[1]=$41)
      and (sprung[2]=$43) then
        begin
          WriteLn(textz_Absicherung_von_Novell_Dos_7_installiert^);
          WriteLn(textz_Installation_in_Spur_0_deshalb_nicht_moeglich^);
          ziel_moeglich[spur0]:=false;
        end;

      if  (sprung[0]=$e9)
      and (sprung[1]=$fd)
      and (sprung[2]=$00) then
        begin
          WriteLn(textz_IDE_Enhancer_ist_aktiv^);
          WriteLn(textz_Installation_in_Spur_0_deshalb_nicht_moeglich^);
          WriteLn;
          ziel_moeglich[spur0]:=false;
        end;

    end; (* with *)

  WriteLn(textz_Festplatte^,' 1 ($80) ',textz_mit^,' ',fp80.sectors,' ',textz_Sektoren_je_Spur_gefunden^);

  if fp80.sectors<vpart2start+vpart2sektoren-1+lvm_sekoren_bedarf then
    vpart2start:=2;

  if fp80.sectors<vpart2start+vpart2sektoren-1+lvm_sekoren_bedarf then
    begin
      WriteLn(#7+textz_fuer_Installation_in_Spur_0_sind_mindestens_noetig^+' : '
        +Int2Str(vpart2start+vpart2sektoren-1+lvm_sekoren_bedarf)+' !');
      WriteLn(textz_Installation_in_Spur_0_deshalb_nicht_moeglich^);
      ziel_moeglich[spur0]:=false;
    end;

  (*$IFNDEF OS2*)
  if os2_aktiv then
    begin
      WriteLn;
      WriteLn(textz_sie_muessen_2_waehlen_os2^);
      if not (programmverwendung in [testprogramm]) then
        ziel_moeglich[spur0]:=false;
    end;
  (*$ENDIF*)

  if not ziel_moeglich[spur0] then
    ziel_moeglich[spur0_mit_awardbios]:=false;

  (* Bestimmung des Zieles *)
  case programmverwendung of
    installation:
      tmpzk:=textz_Auswahl_des_Installationsziels^;
    testprogramm:
      tmpzk:=textz_Ziel_der_endgueltigen_Installation_von_VPART^;
    passwort_setzen:
      tmpzk:=textz_Auswahl_des_Konfigurationsziels^;
    schnellkonfigurtaion:
      tmpzk:=textz_Auswahl_des_Konfigurationsziels^;
    entfernen:
      tmpzk:=textz_Wo_soll_VPART_deinstalliert_werden^;
  end;

  (*
  if not ziel_moeglich[spur0] then
    begin
      WriteLn(textz_Die_1_ist_in_der_derzeitigen_Rechnerkonfiguration_nicht_zulaessig^);
      WriteLn;
    end;*)

  Write(tmpzk,' ');
  auswahlliste_neu(liste_menu,false);

  if ziel_moeglich[spur0] then
    auswahlliste_eintrag(liste_menu,
                         '1) '+textz_in_Spur_0_der_1_Festplatte_und_im_Code_der_Partitionstabelle^,
                         '1',
                         '1',
                         '    + '+textz_schnell^+^m^j
                        +'    + '+textz_keine_FAT_Partion_erforderlich^+^m^j
                        +'    - '+textz_nicht_auf_Diskette^+^m^j
                        +'    - '+textz_Konflikte_mit_IDE_Enhancer_moeglich^);

  if ziel_moeglich[fat] then
    auswahlliste_eintrag(liste_menu,
                         '2) '+textz_in_einem_Bootsektor_einer_FAT_Partition_Diskette_oder_Festplatte^,
                         '2',
                         '2',
                         '    + '+textz_kompatibel_mit_IDE_Enhancern^+^m^j
                        +'    + '+textz_auch_von_Diskette^+^m^j
                        +'    - '+textz_braucht_ein_paar_Hunderstelsekunden_mehr^+^m^j
                        +'    - '+textz_FAT_formatierte_Diskette_oder_Fesplatte_erforderlich^+^m^j
                         (*$IFDEF VIRTUALPASCAL*)
                        +'    - '+textz_warnung_offene_dateien^
                         (*$ENDIF*));

  if ziel_moeglich[spur0_mit_awardbios] then
    auswahlliste_eintrag(liste_menu,
                         '3) '+textz_award_swap^,
                         '3',
                         '3',
                         textz_award_swap_hilfe_lesen^);

  antwort:=auswahlliste_anzeigen(liste_menu,' ',tmpzk,'->FAT');

  case antwort[1] of
    '1':ziel:=spur0;
    '2':ziel:=fat;
    '3':ziel:=spur0_mit_awardbios;
  end;

  antwort_ausschrift(antwort[1]);

  case ziel of
    spur0:
      uebergehe_quelle('C:\VPART.FAT');

    spur0_mit_awardbios:
      begin
        uebergehe_quelle('C:\VPART.FAT');
        bestimmer_award_tauscher_variable;

        if award_tauscher_variable=0 then
          tmpzk:=''
        else
          tmpzk:='$'+Int2Hex(award_tauscher_variable,4);

        Write(textz_award_tauscher_variable^+' ['+tmpzk+'] ');
        repeat
          antwort:=eingabe(
            textz_award_tauscher_variable^,
            tmpzk,
            5,
            'AWARD_VARIABLE',
            textz_award_tauscher_variable_hilfe^);
          Val(antwort,award_tauscher_variable,fehler);
        until (fehler=0) and (award_tauscher_variable>=$0400) and (award_tauscher_variable<$0500);
        antwort_ausschrift(antwort);

      end;

    fat:
      begin (* FAT - aber welches Laufwerk ? *)
        uebergehe_quelle('AWARD_VARIABLE');
        Write  (textz_Welches_Laufwerk_wuenschen_Sie^,' ');
        repeat
          antwort:=eingabe(textz_Welches_Laufwerk_wuenschen_Sie^,
                         'c:',
                         2,
                         'C:\VPART.FAT',
                         textz_erforderlich_FAT_formatiert_nicht_komprimiert^);
          antwort[1]:=UpCase(antwort[1]);
        until antwort[1] in ['A'..Chr(Ord('A')+31)];
        ziel_laufwerk:=antwort[1];
        antwort_ausschrift(ziel_laufwerk+':');
      end;
  end; (* case ziel *)
  uebergehe_quelle('AWARD_VARIABLE');
  uebergehe_quelle('C:\VPART.FAT');

  (******************************************************)

  (* initialisieren obwohl sinnlos ? *)
  FillChar(boot_sektor_fat,SizeOf(boot_sektor_fat),$90);
  FillChar(vpart1         ,SizeOf(vpart1)         ,$90);
  FillChar(vpart2         ,SizeOf(vpart2)         ,$90);

  if ziel in [spur0,spur0_mit_awardbios] then
    begin
      if read_phys_sector($80,0,0,1,fp80.num_heads,fp80.sectors,sector_typ(vpart1))<>0 then
        abbruch(#7+textz_keine_Fesplatte_vorhanden^);

      for zae:=1 to vpart2sektoren do
        if read_phys_sector($80,0,0,vpart2start+zae-1,fp80.num_heads,fp80.sectors,sector_typ(vpart2[zae]))<>0 then
          abbruch(#7+textz_Lesefehler_Spur_0^);

      if ziel=spur0_mit_awardbios then
        if read_phys_sector($81,0,0,1,fp81.num_heads,fp81.sectors,sector_typ(vpart3))<>0 then
          abbruch(#7+textz_keine_Fesplatte_vorhanden^+' (81)');
    end;

  if ziel=fat then
    begin
      if dos_lesen(boot_sektor_fat,ziel_laufwerk)<>0 then
        abbruch(#7+textz_Startsektor_nicht_lesbar_nicht_formatiert^);

      with partitionstabellentyp(boot_sektor_fat) do
        begin
          if (ibm_signatur<>$aa55)
          or (byte_je_sektor<>512)
          or (anzahl_fat<1) (* HPFS: 0 *)
          or (anzahl_fat>100)
          or (Pos('HPFS',dateisystem)<>0)
          or (Pos('FAT32',fat32_sig)<>0)
           then
            abbruch(#7+textz_ungueltiger_bootsektor_auf_laufwerk_^+ziel_laufwerk+':');

        end;

      Assign(datei,ziel_laufwerk+':\'+fat_vpart_name);
      FileMode:=$40;
      (*$I-*)
      Reset(datei,1);
      (*$I+*)
      if IOResult=0 then
        begin
          if  (FileSize(datei)<>(vpart2sektoren+1)*512)
          and (programmverwendung in [passwort_setzen,schnellkonfigurtaion])
           then
            abbruch(#7+textz_Unbekannte_Beschaedigte_Datei^+' '+ziel_laufwerk+':\'+fat_vpart_name+' !')
          else
            begin
              BlockRead(datei,vpart1,512,fehler);
              BlockRead(datei,vpart2,512*vpart2sektoren,fehler);
              Close(datei);
            end;
        end
      else
        if programmverwendung in [passwort_setzen,schnellkonfigurtaion] then
          abbruch(#7+textz_Datei^+' '+ziel_laufwerk+':\'+fat_vpart_name+' '+textz__nicht_vorhanden^)
    end;

  (* Test ob schon installiert ... *)
  if  (partitionstabellentyp(vpart1).name_vpart<>'VPART***')
  and (programmverwendung in [passwort_setzen,schnellkonfigurtaion])
   then
    abbruch(#7+textz_VPART_ist_noch_nicht_nicht_mehr_installiert^);

  if programmverwendung=entfernen then
    begin
      if partitionstabellentyp(vpart1).name_vpart<>'VPART***' then
        WriteLn(textz_VPART_ist_noch_nicht_nicht_mehr_installiert^);

      if ziel=fat then
        begin
          (* Datei lîschen *)
          Write  (ziel_laufwerk+':\'+fat_vpart_name,' ');
          Assign(datei,ziel_laufwerk+':\'+fat_vpart_name);
          FileMode:=$02;
          (*$I-*)
          SetFAttr(datei,0);
          Erase(datei);
          (*$I+*)
          if IOResult=0 then
            WriteLn(textz_geloescht_^)
          else
            WriteLn(textz_nicht_geloescht_^);

          (* Bootsektor aus Datei lesen *)
          repeat
            Write(textz_Dateiname_des_gesicherten_Bootsektors^,' ');
            dateiname:=eingabe(textz_Dateiname_des_gesicherten_Bootsektors^,
                               'A:\orgboot.'+ziel_laufwerk,
                               20,
                               'A:\orgboot.X',
                               '');
            Assign(datei,dateiname);
            FileMode:=$40;
            (*$I-*)
            Reset(datei,1);
            (*$I+*)
            fehlerbehandlung;
          until fehler=0;
          BlockRead(datei,boot_sektor_fat,512);
          Close(datei);
          antwort_ausschrift(dateiname);
        end;

      if ziel in [spur0,spur0_mit_awardbios] then
        begin
          (* Bootsektor aus Datei lesen *)
          repeat
            Write(textz_Dateiname_der_gesicherten_Partitionstabelle^,' ');
            dateiname:=eingabe(textz_Dateiname_der_gesicherten_Partitionstabelle^,
                               'A:\orgpart',
                               20,
                               'A:\orgpart',
                               '');
            Assign(datei,dateiname);
            FileMode:=$40;
            (*$I-*)
            Reset(datei,1);
            (*$I+*)
            fehlerbehandlung;
          until fehler=0;
          antwort_ausschrift(dateiname);

          BlockRead(datei,partitionstabellen_kopie,512);
          antwort:='N';
          for w:=$1be+1 to $1be+4*16+2 do
            if vpart1[w]<>partitionstabellen_kopie[w] then
              antwort:='!';

          if antwort='!' then
            begin
              Write(textz_Sollen_auch_die_alten_Partionsdaten_zurueckgespielt_werden^+' ? ');
              antwort:=ja_nein_frage(textz_Sie_haben_neu_partitionert^+' ?'
                                    +textz_Sollen_auch_die_alten_Partionsdaten_zurueckgespielt_werden^+' ?',
                                     ' ',
                                     '!PART!',
                                     '');
              antwort_ausschrift(ja_nein_str(antwort[1]));
            end;

          (* Tabelle kopieren wenn gewÅnscht *)
          if antwort[1] in ['J','Y'] then
            Move(partitionstabellen_kopie[$1be+1],
                 vpart1                  [$1be+1],
                 4*16+2);

          (* Code in jedem Fall kopieren *)
          Move(partitionstabellen_kopie,
               vpart1,
               $1be);

          BlockRead(datei,vpart2,vpart2sektoren*512);

          (* gesicherte Partitionstabelle 81 *)
          if ziel=spur0_mit_awardbios then
            begin
              BlockRead(datei,partitionstabellen_kopie,512);
              antwort:='N';
              for w:=Low(vpart3)+$1be to Low(vpart3)+$1be+(4*16)+2-1 do
                if vpart3[w]<>partitionstabellen_kopie[w] then
                  antwort:='!';

              if antwort='!' then
                begin
                  Write(textz_Sollen_auch_die_alten_Partionsdaten_zurueckgespielt_werden^+' (81) ? ');
                  antwort:=ja_nein_frage(textz_Sie_haben_neu_partitionert^+' (81) ?'
                                        +textz_Sollen_auch_die_alten_Partionsdaten_zurueckgespielt_werden^+' ?',
                                         ' ',
                                         '!PART!',
                                         '');
                  antwort_ausschrift(ja_nein_str(antwort[1]));
                end;

              (* Tabelle kopieren wenn gewÅnscht *)
              if antwort[1] in ['J','Y'] then
                Move(partitionstabellen_kopie[Low(vpart3)+$1be],
                     vpart3                  [Low(vpart3)+$1be],
                     4*16+2);

              (* Code in jedem Fall kopieren *)
              Move(partitionstabellen_kopie,
                   vpart3,
                   $1be);
            end;

          Close(datei);
        end;

    end; (* 'U' *)

  (* I T *)
  if programmverwendung in [installation,testprogramm] then
    begin

      repeat

        case ziel of
          spur0,
          spur0_mit_awardbios:
            begin
              uebergehe_quelle('A:\orgboot.X');
              Write(textz_Name_fuer_die_Sicherung_von_Partitionstabelle_Spur0^,' ');
              dateiname:=eingabe(textz_Name_fuer_die_Sicherung_von_Partitionstabelle_Spur0^,
                                 'A:\orgpart',
                                  20,
                                 'A:\orgpart',
                                 '');
            end;
          fat:
            begin
              uebergehe_quelle('A:\orgpart');
              Write(textz_Name_fuer_die_Sicherung_des_Startsektors^,' ');
              dateiname:=eingabe(textz_Name_fuer_die_Sicherung_des_Startsektors^,
                                 'A:\orgboot.'+ziel_laufwerk,
                                  20,
                                 'A:\orgboot.X',
                                 '');
            end;
        end;
        uebergehe_quelle('A:\orgboot.X');
        uebergehe_quelle('A:\orgpart');

        if partitionstabellentyp(vpart1).name_vpart='VPART***' then
          begin
            antwort_ausschrift(textz_nicht_notwendig^);
            Break;
          end;

        Assign(datei,dateiname);
        FileMode:=$02;
        (*$I-*)
        Rewrite(datei,1);
        (*$I+*)
        fehlerbehandlung;

        antwort_ausschrift_gz(dateiname);

        if fehler=0 then
          Break;

        WriteLn;

      until false;


      if partitionstabellentyp(vpart1).name_vpart<>'VPART***' then
        begin
          case ziel of
            spur0,
            spur0_mit_awardbios:
              begin
                BlockWrite(datei,vpart1,512);
                BlockWrite(datei,vpart2,512*vpart2sektoren);
                if ziel=spur0_mit_awardbios then
                  BlockWrite(datei,vpart3,512);
              end;
            fat  :
              BlockWrite(datei,boot_sektor_fat,512);
          end;

          Close(datei);
          WriteLn(textz__gesichert^);

        end;



      (* VPART CODE holen *)
      case ziel of
        spur0:
          begin
            (* PTAB bleibt erhalten !!! *)
            if textz_sprachwahl^='deutsch' then
              Move(Addr(vpart1_spur0_bin_d)^,vpart1,$1be)
            else
              Move(Addr(vpart1_spur0_bin_e)^,vpart1,$1be);
            partitionstabellentyp(vpart1).vpart2sektoren:=vpart2sektoren;
            partitionstabellentyp(vpart1).vpart2_cx:=vpart2start;
            partitionstabellentyp(vpart1).vpart2_dx:=$0080;
          end;
        spur0_mit_awardbios:
          begin
            (* PTAB bleibt erhalten !!! *)
            if textz_sprachwahl^='deutsch' then
              begin
                Move(Addr(vpart1_spur0_bin_d          )^,vpart1,$1be);
                Move(Addr(vpart1_spur0_awardswap_bin_d)^,vpart3,$1be);
                award_bios_variable_patch1:=MemW[(*$IFNDEF VIRTUALPASCAL*)Seg(vpart1_spur0_awardswap_bin_d):(*$ENDIF*)
                                                 Ofs(vpart1_spur0_awardswap_bin_d)+$200];
                award_bios_variable_patch2:=MemW[(*$IFNDEF VIRTUALPASCAL*)Seg(vpart1_spur0_awardswap_bin_d):(*$ENDIF*)
                                                 Ofs(vpart1_spur0_awardswap_bin_d)+$202];
              end
            else
              begin
                Move(Addr(vpart1_spur0_bin_e          )^,vpart1,$1be);
                Move(Addr(vpart1_spur0_awardswap_bin_e)^,vpart3,$1be);
                award_bios_variable_patch1:=MemW[(*$IFNDEF VIRTUALPASCAL*)Seg(vpart1_spur0_awardswap_bin_e):(*$ENDIF*)
                                                 Ofs(vpart1_spur0_awardswap_bin_e)+$200];
                award_bios_variable_patch2:=MemW[(*$IFNDEF VIRTUALPASCAL*)Seg(vpart1_spur0_awardswap_bin_e):(*$ENDIF*)
                                                 Ofs(vpart1_spur0_awardswap_bin_e)+$202];
              end;


            smallword_z(@vpart3[Low(vpart3)+award_bios_variable_patch1])^:=award_tauscher_variable;
            smallword_z(@vpart3[Low(vpart3)+award_bios_variable_patch2])^:=award_tauscher_variable;

            partitionstabellentyp(vpart1).vpart2sektoren:=vpart2sektoren;
            partitionstabellentyp(vpart1).vpart2_cx:=vpart2start;
            partitionstabellentyp(vpart1).vpart2_dx:=$0080;
            partitionstabellentyp(vpart3).vpart2sektoren:=vpart2sektoren;
            partitionstabellentyp(vpart3).vpart2_cx:=vpart2start;
            partitionstabellentyp(vpart3).vpart2_dx:=$0080;
          end;
        fat:
          begin
            if textz_sprachwahl^='deutsch' then
              Move(Addr(vpart1_fat_bin_d)^,vpart1,512)
            else
              Move(Addr(vpart1_fat_bin_e)^,vpart1,512);
            partitionstabellentyp(vpart1).vpart2sektoren:=vpart2sektoren;

            if textz_sprachwahl^='deutsch' then
              Move(Addr(fatboot_bin_d)^,backup,512)
            else
              Move(Addr(fatboot_bin_e)^,backup,512);
            Move(backup[$00+1],boot_sektor_fat[$00+1],3 (* +4 *));
            (* alt: halber Name sonst Probleme mit IDEE+OS/2 *)
            Move(backup[$3E+1],boot_sektor_fat[$3E+1],$200-$3E);
          end;
      end;


      if textz_sprachwahl^='deutsch' then
        Move(Addr(vpart2_bin_d)^,vpart2,512*vpart2sektoren)
      else
        Move(Addr(vpart2_bin_e)^,vpart2,512*vpart2sektoren);

      with vpart2_kopf_typ(vpart2[1]) do
        begin
          int20:=$9090;

          FillChar(Mem[(*$IFNDEF VIRTUALPASCAL*)Seg(vpart2):(*$ENDIF*)Ofs(vpart2)+plugin_ofs-$100],plugin_laenge,$c3);

          Assign(plugin,plugin_dateiname);
          FileMode:=$40;
          (*$I-*)
          Reset(plugin,1);
          (*$I+*)
          if IOResult=0 then
            begin
              plugin_datei_laenge:=FileSize(plugin);
              if plugin_datei_laenge>plugin_laenge then
                plugin_datei_laenge:=plugin_laenge;
              BlockRead(plugin,Mem[(*$IFNDEF VIRTUALPASCAL*)Seg(vpart2):(*$ENDIF*)
                                   Ofs(vpart2)+plugin_ofs-$100],plugin_datei_laenge);
              Close(plugin);
            end;
        end;


      if ziel=fat then
        begin
          WriteLn;
          fehler:=TextAttr;
          TextAttr:=$1c;
          write  (textz_Hinweis^);
          TextAttr:=fehler;
          WriteLn(         ' ',textz_Um_eine_Endlosschleife_zu_vermeiden_sollten_Sie_fuer^);
          WriteLn(textz_das_Laufwerk^,' '+ziel_laufwerk+': ',textz_das_erweiterte_Menue_mit_der_Taste_anfordern^);
          WriteLn;
        end;

      (** Suche nach Betriebssystemen ******************************)

      laufwerke_absuchen;
      frage_partitionen_verstecken;
      partitionen_auswaehlen;


      (** Festplattenschlafzeit ************************************)

      for zae:=1 to 4 do
        ergebnis.schlafzeit[zae]:=$FF;

      for zae:=1 to festplattenzahl do
        begin
          Write(textz_Schlafzeit_fuer_Festplatte^,' ',zae,' ',textz_in_Minuten^,' ? ');
          repeat
            antwort:=eingabe(textz_Schlafzeit_fuer_Festplatte^+' '+Int2Str(zae)+' '+textz_in_Minuten^+' ?',
                             '22',
                             Length('22'),
                             'IDE-SLEEP',
                             ' 0.0 .. 20.0'^m^j' >20 '+textz_fuer_inaktiv^);
          until realstring_mal12_zu_byte(antwort,ergebnis.schlafzeit[zae]);
          if ergebnis.schlafzeit[zae]=$ff then
            antwort_ausschrift('-')
          else
            antwort_ausschrift(antwort);
        end;

      for zae:=1 to 4 do
        uebergehe_quelle('IDE-SLEEP');


    end; (* 'I','T' *)

  if programmverwendung in [schnellkonfigurtaion] then
    laufwerke_absuchen; (* wird fÅr VPART.CFG benîtigt *)


  (** Pa·worteingabe ***********************************************)
  (* I T P *)
  if programmverwendung in [installation,testprogramm,passwort_setzen] then
    begin
      Write(textz_Wie_soll_das_Passwort_sein^,' ');
      ergebnis.passwort:=eingabe(textz_Wie_soll_das_Passwort_sein^,
                                 '',
                                 High(ergebnis.passwort),
                                 'PASS',
                                 textz_fuer_keins_Vorsicht_mit_Umlauten^);
      antwort_ausschrift(ergebnis.passwort);
      for zae:=1 to Length(ergebnis.passwort) do
        ergebnis.passwort[zae]:=Chr(Ord(ergebnis.passwort[zae]) xor Ord('„'));
      for zae:=Length(ergebnis.passwort)+1 to SizeOf(ergebnis.passwort)-1 do
        ergebnis.passwort[zae]:=#0;
    end; (* I T P *)



  (* I T A *)
  if programmverwendung in [installation,testprogramm,schnellkonfigurtaion] then
    begin

      (** Standardeintrag wÑhlen ***********************************)

      Write(textz_Auswahl_des_Standardsystems^,' ');
      tmpzk:='01';
      auswahlliste_neu(liste_menu,false);

      for zae:=1 to ergebnis.anzahl_lw do
        begin
          kurztaste:=Int2Hex(zae mod 10,1);
          auswahlliste_eintrag(liste_menu,ergebnis.tabelle[zae].name_,kurztaste[1],Int2Hex(zae,2),'');

          (* erste Fesplattenpartition im MenÅ *)
          if (tmpzk='01') and (Lo(ergebnis.tabelle[zae].dx_reg)>=$80) then
            tmpzk:=Int2Hex(zae,2);
        end;

      if programmverwendung=schnellkonfigurtaion then
        tmpzk:=Int2Hex(ergebnis.standard_lw,2);

      antwort:=auswahlliste_anzeigen(liste_menu,
                                     tmpzk,
                                     textz_Auswahl_des_Standardsystems^,
                                     'DEFAULT');
      Val(antwort,ergebnis.standard_lw,fehler);
      antwort_ausschrift(ergebnis.tabelle[ergebnis.standard_lw].name_);
      schreibe_log_kommentar(antwort+'="'+ergebnis.tabelle[ergebnis.standard_lw].name_+'"');



      (** Wartezeit ************************************************)

      Write(textz_Wie_viele_Sekunden_soll_VPart_auf_die_Systemauswahl_warten^,' ? ');

      tmpzk:='10';

      if programmverwendung=schnellkonfigurtaion then
        if ergebnis.endzeit=$7fffffff then
          tmpzk:='0'
        else
          tmpzk:=Int2Str((ergebnis.endzeit*$10+146) div $123);

      repeat
        antwort:=eingabe(textz_Wie_viele_Sekunden_soll_VPart_auf_die_Systemauswahl_warten^+' ?',
                         tmpzk,
                         Length('99999999'),
                         'AUTO',
                         '');
        Val(antwort,ergebnis.endzeit,fehler);
      until (fehler=0) and (ergebnis.endzeit>=0);
      antwort_ausschrift(antwort);

      if ergebnis.endzeit=0 then
        ergebnis.endzeit:=$7fffffff
      else
        ergebnis.endzeit:=(ergebnis.endzeit*$123+8) div $10;
        (* mit real in system.tpu:
           ergebnis.endzeit:=round(ergebnis.endzeit*(1193180/65636));
           1193180/65636 = $1234DC/$10000 ˜ $123/$10               *)

      (** Standardwert im CMOS ablegen *****************************)
      Write(textz_Abspeichern_der_Auswahl___^);
      auswahlliste_neu(liste_menu,false);

      auswahlliste_eintrag(liste_menu,textz_gewaehltes_Betriebssystem_nicht_merken^  ,'N',
        biostyp_namen_tabelle[biostyp_unbekannt  ],'');
      auswahlliste_eintrag(liste_menu,textz_im_CMOS_speichern^+' - Award BIOS'       ,'A',
        biostyp_namen_tabelle[biostyp_Award      ],'');
      auswahlliste_eintrag(liste_menu,textz_im_CMOS_speichern^+' - AMI Hi-Flex BIOS' ,'H',
        biostyp_namen_tabelle[biostyp_AMI_Hi_Flex],'');
      auswahlliste_eintrag(liste_menu,textz_im_CMOS_speichern^+' - AMI WinBIOS'      ,'W',
        biostyp_namen_tabelle[biostyp_AMI_WinBIOS],'');
      auswahlliste_eintrag(liste_menu,textz_im_CMOS_speichern^+' - SystemSoft'       ,'S',
        biostyp_namen_tabelle[biostyp_SystemSoft ],'');

      vpart_cfg_fat_laufwerke_hinzufuegen(liste_menu);

      if programmverwendung<>schnellkonfigurtaion then
        ergebnis.biostyp:=biostyp_unbekannt;

      if ergebnis.biostyp=biostyp_FAT_cfg then
        suche_ergebnis_fat_cfg(tmpzk)
      else
        tmpzk:=biostyp_namen_tabelle[ergebnis.biostyp];
      antwort:=auswahlliste_anzeigen(liste_menu,tmpzk,textz_im_CMOS_speichern_frage^,'CMOS');

      if Pos('L=$',antwort)=1 then
        merke_ergebnis_fat_cfg(antwort)
      else
        with ergebnis do
          begin
            biostyp:=biostyp_unbekannt;
            while biostyp_namen_tabelle[biostyp]<>antwort do
              Inc(biostyp);
          end;

      antwort_ausschrift(antwort);

      (** Tastenverzîgerung und Wiederholrate **********************)
      Write(textz_Tastaturprogrammierung^);

      auswahlliste_neu(liste_menu,false);
      auswahlliste_eintrag(liste_menu,textz_nicht_programmieren^,'4','4','');
      auswahlliste_eintrag(liste_menu, '250 ms','2','0','');
      auswahlliste_eintrag(liste_menu, '500 ms','5','1','');
      auswahlliste_eintrag(liste_menu, '750 ms','7','2','');
      auswahlliste_eintrag(liste_menu,'1000 ms','1','3','');
      if programmverwendung<>schnellkonfigurtaion then
        ergebnis.tastenverzoegerung:=0;
      tmpzk:=Int2Str(ergebnis.tastenverzoegerung);
      antwort:=auswahlliste_anzeigen(liste_menu,tmpzk,textz_Tastenverzoegerung__^,'KBD1');
      Val(antwort,ergebnis.tastenverzoegerung,kontrolle);

      if ergebnis.tastenverzoegerung=4 then
        begin
          antwort_ausschrift('-');
          ergebnis.tastenwiederholrate:=0;
          uebergehe_quelle('KBD2')
        end
      else
        begin
          antwort_ausschrift_gz(Int2Str((ergebnis.tastenwiederholrate+1)*250)+' ms / ');
          auswahlliste_neu(liste_menu,false);
          for zae:=0 to 31 do
            begin
              tmpzk:=wiederholrate[zae]+textz__Zeichen_je_Sekunde^;
              if textz_sprachwahl^[1]='e' then
                tmpzk[3]:='.'; (* ',' durch '.' ersetzen *)
              auswahlliste_eintrag(liste_menu,tmpzk,' ',Int2Str(zae),'');
            end;
          if programmverwendung<>schnellkonfigurtaion then
            ergebnis.tastenwiederholrate:=0;
          tmpzk:=Int2Str(ergebnis.tastenwiederholrate);
          antwort:=auswahlliste_anzeigen(liste_menu,tmpzk,textz_Tastenwiederholrate__^,'KBD2');
          Val(antwort,ergebnis.tastenwiederholrate,kontrolle);

          tmpzk:=wiederholrate[ergebnis.tastenwiederholrate]+textz__Zeichen_je_Sekunde^;
          if textz_sprachwahl^[1]='e' then
            tmpzk[3]:='.'; (* ',' durch '.' ersetzen *)
          antwort_ausschrift(tmpzk);
        end;


      (** Hauptspeichergrî·e ***************************************)

      Write(textz_Groesse_des_Hauptspeichers^+' ');
      repeat
        bios_speicher_jetzt:=word_speicher_lesen($0040,$0013);
        if programmverwendung<>schnellkonfigurtaion then
          ergebnis.bios_speicher:=bios_speicher_jetzt;

        auswahlliste_neu(liste_menu,false);

        if bios_speicher_jetzt<639 then
          auswahlliste_eintrag(liste_menu,Int2Str(bios_speicher_jetzt)+' KB',' ',Int2Str(bios_speicher_jetzt),
            textz_jetztiger_Wert^);
        auswahlliste_eintrag(liste_menu,'639 KB'           ,'1','639',textz_Speicherhilfe_639^);
        auswahlliste_eintrag(liste_menu,'640 KB'           ,'0','640',textz_Speicherhilfe_640^);
        auswahlliste_eintrag(liste_menu,textz_ignorieren^  ,'I','999',textz_Speicherhilfe_999^);
        auswahlliste_eintrag(liste_menu,textz_anderer_Wert^,'A','%%%',textz_Speicherhilfe_AAA^);

        tmpzk:=Int2Str(ergebnis.bios_speicher);
        if  (ergebnis.bios_speicher<>639)
        and (ergebnis.bios_speicher<>640)
        and (ergebnis.bios_speicher<>999)
        and (ergebnis.bios_speicher<>bios_speicher_jetzt)
         then
           tmpzk:='%%%';

        antwort:=auswahlliste_anzeigen(liste_menu,tmpzk,textz_Groesse_des_Hauptspeichers^,'640A');
        if antwort='%%%' then
          begin
            tmpzk:=Int2Str(ergebnis.bios_speicher);
            antwort:=eingabe(textz_Groesse_des_Hauptspeichers^,tmpzk,Length('640'),'640B','')
          end
        else
          uebergehe_quelle('640B');
        Val(antwort,ergebnis.bios_speicher,fehler);
      until (fehler=0) and (ergebnis.bios_speicher>0);
      antwort_ausschrift(Int2Str(ergebnis.bios_speicher));

      (** Maustreiber **********************************************)
      Write(textz_frage_maustreiber^,' ');

      tmpzk:='J';
      if (programmverwendung=schnellkonfigurtaion) and (ergebnis.maus_parameter=0) then
        tmpzk:='N';

      antwort:=ja_nein_frage(
        textz_frage_maustreiber^,
        tmpzk[1],
        'MAUS',
        textz_hilfe_maustreiber^);

      antwort_ausschrift(ja_nein_str(antwort[1]));

      if antwort='N' then
        ergebnis.maus_parameter:=0
      else
        ergebnis.maus_parameter:=3;


      (** A20 ******************************************************)
      Write(textz_frage_a20_abschalten^,' ');

      tmpzk:='N';
      if (programmverwendung=schnellkonfigurtaion) and (not ergebnis.a20_abschalten) then
        tmpzk:=UpCase(textz_j_zeichen^[1]);

      antwort:=ja_nein_frage(
        textz_frage_a20_abschalten^,
        tmpzk[1],
        'A20',
        textz_hilfe_a20_abschalten^);

      antwort_ausschrift(ja_nein_str(antwort[1]));
      ergebnis.a20_abschalten:=(antwort<>'N');

      (** Text/Grafikmodus *****************************************)

      Write(textz_text_oder_grafikmodus^,' ? ');
      auswahlliste_neu(liste_menu,false);
      auswahlliste_eintrag(liste_menu,textz_textmodus^  ,'T','T','80*25 CGA/EGA/VGA');
      auswahlliste_eintrag(liste_menu,textz_grafikmodus^,'G','G','640*480*16 VGA');

      tmpzk:='G';
      if (programmverwendung=schnellkonfigurtaion) then
        tmpzk:=ergebnis.text_oder_grafikmodus;

      antwort:=auswahlliste_anzeigen(liste_menu,tmpzk,textz_text_oder_grafikmodus^+' ? ','TEXT_GRAFIK');
      ergebnis.text_oder_grafikmodus:=antwort[1];
      antwort_ausschrift(ergebnis.text_oder_grafikmodus);


      (** Farbpalette wÑhlen ***************************************)

      Write(textz_name_der_palette_frage1^,' ? ');
      repeat

        tmpzk:='STANDARD';

        if programmverwendung=schnellkonfigurtaion then
          begin
            tmpzk:='DEF';

            gleich:=true;
            for zae:=Low(pal_blau) to High(pal_blau) do
              gleich:=gleich and (ergebnis.palette[zae]=pal_blau[zae]);
            if gleich then
              tmpzk:='STANDARD';

            gleich:=true;
            for zae:=Low(pal_ehm) to High(pal_ehm) do
              gleich:=gleich and (ergebnis.palette[zae]=pal_ehm[zae]);
            if gleich then
              tmpzk:='EHM';

          end;

        auswahlliste_neu(liste_menu,false);
        auswahlliste_eintrag(liste_menu,textz_name_der_palette1^     ,'S','STANDARD',textz_name_der_palette1_hilfe^);
        auswahlliste_eintrag(liste_menu,'Ehm'                        ,'E','EHM'     ,textz_name_der_palette2_hilfe^);
        auswahlliste_eintrag(liste_menu,textz_selbsdefiniertepalette^,' ','DEF'     ,'');

        antwort:=auswahlliste_anzeigen(liste_menu,tmpzk,textz_name_der_palette_frage1^,'PALETTE1');

        if (antwort='STANDARD') then
          begin
            ergebnis.palette:=pal_blau;
            antwort_ausschrift(textz_name_der_palette1^);
            Break;
          end;

        if (antwort='EHM') then
          begin
            ergebnis.palette:=pal_ehm;
            antwort_ausschrift('Ehm');
            Break;
          end;

        tmpzk:='';
        if programmverwendung=schnellkonfigurtaion then
          begin
            tmpzk[0]:=Chr(SizeOf(ergebnis.palette)-16);
            for zae:=16 to High(ergebnis.palette) do
              case ergebnis.palette[zae] of
                 0.. 9:tmpzk[zae-16+1]:=Chr(ergebnis.palette[zae]+Ord('0')   );
                10..15:tmpzk[zae-16+1]:=Chr(ergebnis.palette[zae]+Ord('A')-10);
              end;
          end;
        antwort:=eingabe(textz_name_der_palette_frage2^,
                         tmpzk,
                         20,
                         'PALETTE2',
                         textz_name_der_palette_frage2_hilfe^);

        if antwort='' then continue; (* repeat *)

         (* Dateiname ? *)
         if Pos('.',antwort)>1 then
           begin
             Assign(palette_datei,antwort);
             FileMode:=$40;
             antwort:='';
             (*$I-*)
             Reset(palette_datei,1);
             (*$I+*)
             if IOResult=0 then
              begin
                (*$I-*)
                BlockRead(palette_datei,antwort[1],SizeOf(ergebnis.palette)-16,gelesen);
                (*$I+*)
                if (IOResult=0) and (gelesen=SizeOf(ergebnis.palette)-16) then
                  antwort[0]:=Chr(gelesen);
                (*$I-*)
                Close(palette_datei);
                (*$I+*)
                if IOResult=0 then ;
              end;
           end; (* Datei *)


        if Length(antwort)=SizeOf(ergebnis.palette)-16 then (* ohne Standardfarben *)
          begin
            ergebnis.palette:=pal_blau;
            for zae:=16 to High(ergebnis.palette) do
              begin
                Val('$'+antwort[zae-16+1],ergebnis.palette[zae],val_fehler);
                if val_fehler>0 then
                  continue;
              end;

            antwort_ausschrift(antwort);
            Break;
          end;

      until false;
      uebergehe_quelle('PALETTE2');

      (** Blenden **************************************************)
      Write(textz_frage_blenden_kurz^,' ');
      auswahlliste_neu(liste_menu,false);
      auswahlliste_eintrag(liste_menu,textz_blenden1^,'1','1',textz_hilfe_blenden1^);
      auswahlliste_eintrag(liste_menu,textz_blenden2^,'2','2',textz_hilfe_blenden2^);
      auswahlliste_eintrag(liste_menu,textz_blenden3^,'3','3',textz_hilfe_blenden3^);

      if (programmverwendung=schnellkonfigurtaion) then
        tmpzk:=ergebnis.blenden
      else
        tmpzk:='2';

      antwort:=auswahlliste_anzeigen(liste_menu,tmpzk,textz_frage_blenden^,'BLENDEN');
      ergebnis.blenden:=antwort[1];
      case ergebnis.blenden of
        '1':antwort_ausschrift(textz_blenden1^);
        '2':antwort_ausschrift(textz_blenden2^);
        '3':antwort_ausschrift(textz_blenden3^);
      end;

      (** APM ******************************************************)

      Write(textz_frage_apm^,' ');

      tmpzk:='J';
      if (programmverwendung=schnellkonfigurtaion) and (not ergebnis.benutze_apm) then
        tmpzk:='N';

      antwort:=ja_nein_frage(
        textz_frage_apm^,
        tmpzk[1],
        'APM',
        textz_hilfe_apm^);

      antwort_ausschrift(ja_nein_str(antwort[1]));

      ergebnis.benutze_apm:=(antwort<>'N');

    end; (* I T A *)

  (* I T *)
  if programmverwendung in [installation,testprogramm] then
    begin

      (** Verstecken ja/nein ***************************************)

      Write(textz_versteckt^,' ');
      antwort:=ja_nein_frage(textz_versteckt^,
                             'N',
                             'VERSTECKT',
                             textz_versteckt_hilfe^);
      antwort_ausschrift(ja_nein_str(antwort[1]));
      if antwort[1] in ['J','Y'] then
        ergebnis.vpart_versteckt:='1'
      else
        ergebnis.vpart_versteckt:='0';

      partitionstabellentyp(vpart1).versteckt:=ergebnis.vpart_versteckt;
      partitionstabellentyp(vpart3).versteckt:=ergebnis.vpart_versteckt;

    end; (* I T *)


  (** letzte Frage: Schreibzugriff erlauben ? **********************)

  if programmverwendung=testprogramm then
    fragezk:=textz_Darf_ich_jetzt^+'Test.COM'+textz_erzeugen^
  else
    case ziel of
      spur0:
        fragezk:=textz_Darf_ich_jetzt_1_Sektor_in_Sektor_1_und^
                +Int2Str(vpart2sektoren)
                +' '+textz_in_Sektoren^+Int2Str(vpart2start)
                +' '+textz_bis^+Int2Str(vpart2start+vpart2sektoren-1)
                +textz__eintragen^;

      spur0_mit_awardbios:
        fragezk:=textz_Darf_ich_jetzt_1_Sektor_in_Sektor_1_und_fp2_und^
                +Int2Str(vpart2sektoren)
                +' '+textz_in_Sektoren^+Int2Str(vpart2start)
                +' '+textz_bis^+Int2Str(vpart2start+vpart2sektoren-1)
                +textz__eintragen^;

      fat:
        case programmverwendung of
          entfernen: (* U *)
            fragezk:=textz_Darf_ich_jetzt_den_Bootsektor_von_Laufwerk^+ziel_laufwerk+':'+textz_veraendern^+' ?';

          installation: (* 'I' *)
            fragezk:=textz_Darf_ich_jetzt_den_Bootsektor_von_Laufwerk^+ziel_laufwerk+':'+textz_veraendern^+^m^j
                    +textz_und_die_Datei^+ziel_laufwerk+':\'+fat_vpart_name+textz_schreiben^;

          passwort_setzen,
          schnellkonfigurtaion: (* 'P','A' *)
            fragezk:=textz_Darf_ich_jetz_die_Datei^+ziel_laufwerk+':\'+fat_vpart_name+textz_veraendern^+' ?';
        end;
    end; (* case ziel *)

    Write(fragezk,' ');
    repeat
      auswahlliste_neu(liste_menu,true);
      auswahlliste_eintrag(liste_menu,textz_ja_normal^   ,UpCase(textz_j_zeichen^[1]),UpCase(textz_j_zeichen^[1]),'');
      auswahlliste_eintrag(liste_menu,textz_nein_normal^ ,'N'                        ,'N','');
      auswahlliste_eintrag(liste_menu,textz_komandozeile^,'C'                        ,'C','');

      antwort:=auswahlliste_anzeigen(liste_menu,UpCase(textz_j_zeichen^[1]),fragezk,'SCHREIBEN');

      case antwort[1] of
        'J','Y':
          begin
            antwort_ausschrift(ja_nein_str(antwort[1]));
            Break;
          end;

        'N':
          begin
            antwort_ausschrift(ja_nein_str(antwort[1]));
            Abbruch_durch_den_Benutzer;
          end;

        'C':
          Befehlszeile;

      end;

  until false;

  (* keine Dialoge mehr, mîglichst keine offenen Dateien mehr *)
  schreibe_log_kommentar('');
  schreibe_log_kommentar(kommentarbalken);
  schliesse_quelle;
  schliesse_log;

  (** SETBOOT.CFG **************************************************)
  if  (programmverwendung in [installation,testprogramm,schnellkonfigurtaion])
  and (ergebnis.biostyp<>biostyp_unbekannt)
   then
    begin

      if ergebnis.biostyp=biostyp_FAT_cfg then
        begin
          Write(textz_Schreibe_SETBOOTF_CFG____^);
          Assign(setbootc_cfg,'SETBOOTF.CFG');
        end
      else
        begin
          Write(textz_Schreibe_SETBOOTC_CFG____^);
          Assign(setbootc_cfg,'SETBOOTC.CFG');
        end;

      (*$I-*)
      Rewrite(setbootc_cfg);
      (*$I+*)
      if IOResult=0 then
        begin
          for zae:=1 to ergebnis.anzahl_lw do
            WriteLn(setbootc_cfg,ergebnis.tabelle[zae].name_);
          Close(setbootc_cfg);
          WriteLn(textz_gelungen_^);
        end
      else
        WriteLn(textz_fehlgeschlagen_^);
    end;


  (** VPART1/2 schreiben *******************************************)
  if programmverwendung=testprogramm then
    begin
      (*$I-*)
      Assign(datei,'TEST.COM');
      FileMode:=$42;
      Rewrite(datei,1);
      BlockWrite(datei,vpart2,vpart2sektoren*512);
      FillChar(fuell,512,'€');
      while 60000-FileSize(datei)>512 do
        BlockWrite(datei,fuell,512);
      if 60000-FileSize(datei)>0 then
        BlockWrite(datei,fuell,60000-FileSize(datei));
      Close(datei);
      (*$I-*)
      fehler:=IOResult;

      WriteLn;
      if fehler<>0 then
        abbruch(textz_Fehler_beim_Schreiben_von^+'TEST.COM !')
      else
        abbruch(textz_Programm_beendet^+' .. Test.COM '+textz_ausprobieren^);

    end
  else
    begin
      case ziel of
        spur0,
        spur0_mit_awardbios:
          begin
            if write_phys_sector($80,0,0,1,fp80.num_heads,fp80.sectors,sector_typ(vpart1))<>0 then
              abbruch(#7+textz_Partitionstabelle_nicht_beschreibbar^+' !'+#13+#10+'( '+textz_Schutzprogramm^+' ? )');

            for zae:=1 to vpart2sektoren do
              if write_phys_sector($80,0,0,vpart2start+zae-1,fp80.num_heads,fp80.sectors,sector_typ(vpart2[zae]))<>0 then
                abbruch(#7+textz_Spur_0_nicht_beschreibbar^+' !'+#13+#10+'( '+textz_Schutzprogramm^+' ? )');

            if ziel=spur0_mit_awardbios then
              if write_phys_sector($81,0,0,1,fp81.num_heads,fp81.sectors,sector_typ(vpart3))<>0 then
                abbruch(#7+textz_Partitionstabelle_nicht_beschreibbar^+'($81) !'+#13+#10+'( '+textz_Schutzprogramm^+' ? )');

            if programmverwendung=entfernen then
              abbruch('VPART '+textz_entfernt^+'.');
          end;

        fat:
          begin
            if programmverwendung in [entfernen,installation] then (* U I *)
              begin
                if dos_schreiben(boot_sektor_fat,ziel_laufwerk)<>0 then
                  abbruch(textz_Bootsektor_nicht_beschreibbar^);
              end;

            if programmverwendung=entfernen then
              abbruch('VPART '+textz_entfernt^+'.');

            Assign(datei,ziel_laufwerk+':\'+fat_vpart_name);
            FileMode:=$42;
            (*$I-*)
            SetFAttr(datei,0);
            Rewrite(datei,1);
            (*$I+*)
            fehlerbehandlung;
            if fehler<>0 then
              abbruch(#7);
            BlockWrite(datei,vpart1,512);
            BlockWrite(datei,vpart2,512*vpart2sektoren);
            Close(datei);
          end; (* FAT *)

      end; (* CASE *)


      if ergebnis.biostyp=biostyp_FAT_cfg then
        begin
          WriteLn;
          WriteLn(textz_zum_erzugen_von_vpart_cfg_setbootf_benutzen^);
        end;

      WriteLn;
      if ziel=spur0_mit_awardbios then
        abbruch(textz_Programm_erfolgreich_beendet_bios_swap^)
      else
        abbruch(textz_Programm_erfolgreich_beendet^);




    end;
end.

