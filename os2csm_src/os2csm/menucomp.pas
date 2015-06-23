{&Use32+}{&G5+}{&H-}
unit menucomp{iler};

{$I+,X+,Delphi+}

(* Veit Kannegieser * 1999.01.25 *)
(*                    1999.01.28 COPY /B INSTALLD.BIN+MENU.OSC+MENU.BIN+OS2LDR.ORG \OS2LDR *)
(*                    1999.04.24 SchnellmenÅtasten *)
(*                    1999.06.21 Zeigrenze 0 Sekunden -> 12 Stunden *)
(*                    1999.06.22 Zeigrenze 0 Sekunden -> 12 Stunden auch wenn nicht angegeben *)
(*                    1999.07.08 keine Probleme mit System/Nur Lesen (OS2LDR.ORG) *)
(*                    1999.11.16 boolean,32->64 Variablen,versteckte Variablen, Zuweisungen,Sprache 2 *)
(*                    1999.11.22 spanisches OS2CSM.S wird geladen *)
(*                    ****.**.** os2csm.deu/.eng *)

(*********************************************************)

interface

var
  basisverzeichnis      :string;
  os2csm_memdisk        :boolean=false;

procedure fehler_ende(const e:longint);
procedure runerror_99;
procedure lade_os2csm_bin(const standardverzeichnis:string);
procedure lade_menu_txt(const standardverzeichnis:string);
procedure lade_os2ldr(const config_sys_verzeichnis:string);
procedure lade_menuhlp_txt(const standardverzeichnis:string);
procedure menu_ausfueren;
procedure schreibe_os2ldr_neu(const config_sys_verzeichnis:string;const mit_os2csm:boolean);
function  liefere_standardwert_zahl(const variablenname:string):word;
function  liefere_standardwert_zeichenkette(const variablenname:string):string;

implementation

uses
  Dos,
  {$IfDef Os2}
  Os2Base,
  {$EndIf Os2}
  os2csm_s,
  Objects,
  Strings,
  VpSysLow,
  VpUtils;

const
  menu_hlp_txt_name                     :string='menu_hlp.txt';
  os2csm_hlp_name                       ='os2csm.hlp';

  os2csm_bin_version                    =4;     (* lader.a86 *)
  variablen_platz_dauerhaft_vorhanden   = 5000; (* lader.a86 *)
  variablen_platz_vorhanden             =35000; (* lader.a86 *)

  anweisung_normal                      =0;
  anweisung_anfang                      =1;
  anweisung_ende                        =2;

  variablentyp_zahl                     =1; (* boolean oder word *)
  variablentyp_zeichenkette             =2;
  variablentyp_drehfeld                 =3;

  (* nach Ende des MenÅs: *)
  variable_bleibt_unveraendert          =0;
  variable_packen_zu_zahl               =1;
  variable_packen_zu_zeichenkette       =2;
  variable_loeschen                     =3;

  STR_APPEND                            =$0d;
  STR_COMP                              =$0e;
  STR_DELETE                            =$0f;
  STR_INSERT                            =$10;
  STR_LENGTH                            =$11;
  STR_CONCAT                            =$12;
  STR_TRIM                              =$13;
  STR_COPY                              =$14;
  STR_UPCASE                            =$15;
  STR_VAL                               =$16;
  STR_DISPLAY                           =$17;
  SEARCH_PCI_DEVICEID                   =$18;
  SEARCH_PCI_DEVICECLASS                =$19;
  SEARCH_PNP_DEVICEID                   =$1a;
  SEARCH_PNP_DEVICECLASS                =$1b;
  COUNT_PCI_DEVICEID                    =$1c;
  COUNT_PCI_DEVICECLASS                 =$1d;
  COUNT_PNP_DEVICEID                    =$1e;
  COUNT_PNP_DEVICECLASS                 =$1f;
  QUERY_BOOTDRIVE_LETTER                =$20;
  SET_BOOTDRIVE_LETTER                  =$21;
  SET_ALTF2ON_FILE                      =$22;


  mehrfach_zeichen                      =$fe;

type
  string_z                              =^ShortString;

  variable                              =smallword;

  drehfeld_speicher_typ                 =
    packed record
      weite                             :shortint;
      elemente                          :array[1..$ffff*256] of byte;
    end;

  variablen_block                       =
    packed record (* -> ..\LADER\TYPDEF.A86 *)
      blocklaenge                       :smallword;
      variablentyp                      :byte;
      loeschtyp                         :byte;
      x_position                        :byte;
      y_position                        :byte;
      seitennummer                      :byte;
      anzahl_einstellungen              :smallword;
      aktuelle_einstellung              :variable;
      zeichenketteninhalt               :smallword;
      sprung_taste                      :char;
      variablen_name                    :string[255]; (* LÑnge <128 *)

      platz_fuer_zeichenkette           :string;

      drehfeld_speicher                 :^drehfeld_speicher_typ;
      drehfeld_speicher_laenge          :word;

    end;

  anweisung                             =
    packed record
      zustand_anwendbar                 :byte;
                                                                // IF a=9
      if_teil                           :byte;                  // '='
      var_if_1                          :smallword;             // 'A'
      var_if_2                          :smallword;             // '9'

                                                                // THEN B=2+3
      verknuepfung                      :byte;                  // '+'
      var_verkn_1                       :smallword;             // 'B'
      var_verkn_2                       :smallword;             // '2'
      var_verkn_3                       :smallword;             // '3'
      var_verkn_4                       :smallword;
    end;

  (* Zeiger im Kopf von OS2CSM.D/E/S *)
  org_kopf_z                            =^org_kopf;
  org_kopf                              =
    packed record
      sig1                              :byte;
      sig2                              :byte;
      version                           :smallword;
      dauervariablen                    :smallword;
      anfangsvariablen                  :smallword;
    end;

  dauervariablen_typ                    =
    packed record
      anzahl_variablen_                 :smallword;
      variablen_bereich_                :smallword;
      variablen_bereich_soll            :array[0..variablen_platz_dauerhaft_vorhanden-1] of byte;
    end;

  vga_palette_typ                       =
    packed array[0..15] of
      packed record
        r,g,b                           :byte;
      end;


  bildschirm_beschreibung_typ           = (* typdef.a86 *)
    packed record
      bildschirm_zeilen_belegt          :byte;          (* 25/28/50         *)
      cursor                            :smallword;     (* $2000=unsichtbar *)
      cursor_pos                        :smallword;     (* 0=X1:Y1          *)
      blinken                           :boolean;       (* 1=blinken        *)
      bildschirm_puffer_zeiger          :longint;
    end;

  anfangsvariablen_typ                  =
    packed record
      variablen_zeiger_tabelle          :smallword;
      schnelltastenzeiger               :array[1..10] of smallword;
      formel_zeiger                     :smallword;
      zeitgrenze_                       :longint;
      eingabetaste_sc_                  :smallword;
      cancel_sc_                        :smallword;
      reset_sc_                         :smallword;
      altf5_sc_                         :smallword;
      help_sc_                          :smallword;
      ofs_internal_helpfile             :smallword;
      anzahl_bildschirmseiten_          :byte;
      menu_bildschirm_beschreibung      :bildschirm_beschreibung_typ;
      menu_continue_beschreibung        :bildschirm_beschreibung_typ;
      menu_continue_yes_sc              :smallword;
      menu_continue_no_sc               :smallword;
      menu_cancel_beschreibung          :bildschirm_beschreibung_typ;
      menu_cancel_yes_sc                :smallword;
      menu_cancel_no_sc                 :smallword;
      menu_reset_beschreibung           :bildschirm_beschreibung_typ;
      menu_reset_yes_sc                 :smallword;
      menu_reset_no_sc                  :smallword;
      pnp_puffer_laenge                 :smallword;
      pnp_puffer_zeiger                 :smallword;
      menu_palette_benutzen_            :boolean;
      menu_palette_                     :vga_palette_typ;
      platz_fuer_die_daten              :array[0..$ffff] of byte;
    end;

  (* die letzten 128 Byte lasse ich lieber als Reserve,
     fÅr die DOS-Version wird hier etwas Stapelspeicher benîtigt *)
  os2ldr_puffer_typ                     =array[0..65535-$80] of byte;

const

  zeitgrenze_12_Stunden                 =(12*60*60*19663) div 1080; (* 1/18,2 *)
  maximale_seitengroesse                =80*50*2;

  max_variablen                         =1000; (* 16 bit *)
  max_formeln                           =1000; (* willkÅrlich < 64KB *)

  variablen_zaehler     :word           =0;
  formel_zaehler        :word           =0;

  (* Variable 1 mu· nachgesehen werden aber $8003 ist 3 *)
  konstanten_bit                        =$8000;

  seiten_anzahl         :word           =0;
  seiten_zeilenzahl     :word           =0; (* 25/28/50 *)

  pnp_funktion_benutzt  :boolean        =false;
  dmi_variablen_benutzt :boolean        =false;

  eingabetaste_sc       :smallword      =$1c0d; (* Eingabetaste *)
  cancel_sc             :smallword      =$011b; (* Esc          *)
  reset_sc              :smallword      =$8500; (* F11          *)
  altf5_sc              :smallword      =$6200; (* Strg+F5      *)
  help_sc               :smallword      =$3b00; (* F1           *)

  menu_palette_benutzen :boolean        =false;
  menu_palette          :vga_palette_typ=
    ((r:$00;g:$00;b:$00),
     (r:$00;g:$00;b:$aa),
     (r:$00;g:$aa;b:$00),
     (r:$00;g:$aa;b:$aa),

     (r:$aa;g:$00;b:$00),
     (r:$aa;g:$00;b:$aa),
     (r:$aa;g:$55;b:$00),
     (r:$aa;g:$aa;b:$aa),

     (r:$55;g:$55;b:$55),
     (r:$55;g:$55;b:$ff),
     (r:$55;g:$ff;b:$55),
     (r:$55;g:$ff;b:$ff),

     (r:$ff;g:$55;b:$55),
     (r:$ff;g:$55;b:$ff),
     (r:$ff;g:$ff;b:$55),
     (r:$ff;g:$ff;b:$ff));


type
  seitenspeicher_typ                    =array[0..maximale_seitengroesse-1] of byte;

var
  dauervariablen_o      :word;
  anfangsvariablen_o    :word;

  os2ldr_laenge         :longint;
  os2ldr_puffer         :os2ldr_puffer_typ;
  org_os2ldr_laenge     :longint;
  org_os2ldr_puffer     :os2ldr_puffer_typ;
  os2ldr_bin_laenge     :longint;
  os2ldr_bin_puffer     :os2ldr_puffer_typ;
  org_os2ldr_bin_laenge :longint;
  org_os2ldr_bin_puffer :os2ldr_puffer_typ;

  os2csm_bin_puffer     :os2ldr_puffer_typ;
  os2csm_bin_laenge     :longint;

  os2csm_hlp_puffer     :os2ldr_puffer_typ;
  os2csm_hlp_laenge     :word=0;

  os2ldr_datumzeit,
  os2ldr_bin_datumzeit  :longint;

  zeile,
  anfang,
  org_zeile             :ansistring;
  zahl                  :longint;

  anfang_ist_zeichenkette:boolean;

  (* Tasten '0'..'9' als Schnelltasten fÅr bis zu 64 Menuvariablen *)
  schnell_menu          :array[1..10] of array [1..max_variablen] of smallword;
  schnell_menu_benutzt  :array[1..10] of array [1..max_variablen] of boolean;


  menu_nummer           :longint; (* 1..10 *)

  zeitgrenze            :longint;

  variablen_tabelle,
  variablen_kopie       :array[1..max_variablen] of variablen_block;
  formel_tabelle        :array[1..max_formeln] of anweisung;

  seiten_hintergruende  :array[1..10] of seitenspeicher_typ;

  weiter_seite          :seitenspeicher_typ;
  weiter_seite_benutzt  :boolean=false;
  weiter_seite_ja_sc    :smallword=$1c0d; (* <-/ *)
  weiter_seite_nein_sc  :smallword=$011b; (* Esc *)

  abbruch_seite         :seitenspeicher_typ;
  abbruch_seite_benutzt :boolean=false;
  abbruch_seite_ja_sc   :smallword=$1c0d; (* <-/ *)
  abbruch_seite_nein_sc :smallword=$011b; (* Esc *)

  reset_seite           :seitenspeicher_typ;
  reset_seite_benutzt   :boolean=false;
  reset_seite_ja_sc     :smallword=$1c0d; (* <-/ *)
  reset_seite_nein_sc   :smallword=$011b; (* Esc *)

  brane_tabelle         :array[1..10000] of string_z;
  brane_tabelle_belegt  :word;

(*******************************************************************)

procedure fehler_ende(const e:longint);
  begin
    Write(textz__weiter_mit_der_Eingabetaste_^);
    if DebugHook then asm int 3 end;
    ReadLn;
    Halt(e);
  end;

procedure fehler_ende_99;
  begin
    fehler_ende(99);
  end;

procedure runerror_99;
  begin
    WriteLn(textz_runerror991^);
    WriteLn(textz_runerror992^);
    WriteLn(textz_runerror993^);
    fehler_ende_99;
  end;

procedure schreibe_org_zeile;
  begin
    WriteLn(textz_Arbeitsposition_^);
    if DebugHook then asm int 3 end;
    if anfang_ist_zeichenkette then
      WriteLn('  "',anfang,'"')
    else
      WriteLn('  ',anfang);
    WriteLn(textz_Restzeile_^);
    WriteLn('  ',zeile);
    WriteLn(textz_Zeile_^);
    WriteLn('  ',org_zeile);
  end;

(*******************************************************************)

procedure suche_datei(var ergebnis:string;const zielpfad,dateiname:string;const dateisuche_zulaessig:boolean);
  var
    sr          :SearchRec;
    umgebungswert:string;
    dateiname2  :string;
    w1,w2       :word;
  begin
    (* %x% durch Wert der Umgebungsvariable x ersetzen *)
    dateiname2:=dateiname;
    repeat
      w1:=Pos('%',dateiname2);
      if w1=0 then Break;
      w2:=w1+1;
      while (w2<Length(dateiname2)) and (dateiname2[w2]<>'%') do
        Inc(w2);
      umgebungswert:=Copy(dateiname2,w1+1,w2-(w1+1));
      if umgebungswert='' then
        begin
          WriteLn(textz_ungueltige_Umgebungsvariable_^,' ""!');
          fehler_ende_99;
        end;
      Delete(dateiname2,w1,w2-(w1+1)+2);
      Insert(GetEnv(umgebungswert),dateiname2,w1);
    until false;

    ergebnis:='';
    if zielpfad<>'' then
      begin
        ergebnis:=zielpfad;
        if not (ergebnis[Length(ergebnis)] in ['\','/']) then
          ergebnis:=ergebnis+'\';
        ergebnis:=ergebnis+dateiname2;
        FindFirst(ergebnis,AnyFile,sr);
        if Dos.DosError<>0 then
          begin
            ergebnis:='';
            FindClose(sr);
            FindFirst(dateiname2,AnyFile,sr);
            if Dos.DosError=0 then
              ergebnis:=dateiname2;
          end;
        FindClose(sr);
      end;

    if not dateisuche_zulaessig then Exit;

    if ergebnis='' then
      ergebnis:=FSearch(dateiname2,'.');
    if ergebnis='' then
      ergebnis:=FSearch(dateiname2,basisverzeichnis);
    if ergebnis='' then
      ergebnis:=FSearch(dateiname2,basisverzeichnis+'..\bin');
    if ergebnis='' then
      ergebnis:=FSearch(dateiname2,basisverzeichnis+'..\example');
    if ergebnis='' then
      ergebnis:=FSearch(dateiname2,SysGetBootDrive+':\');
    if ergebnis='' then
      ergebnis:=FSearch(dateiname2,GetEnv('PATH'));
  end;

procedure lade_os2csm_bin(const standardverzeichnis:string);
  var
    d                   :file;
    fehler              :word;
    i                   :word;
    OS2CSM_ERW          :string[2+1+8+1+3];
    os2csm_bin          :string;
  begin

    if os2csm_memdisk then
      OS2CSM_ERW:=textz_OS2CSM_ERW_MEMDISK^
    else
      OS2CSM_ERW:=textz_OS2CSM_ERW^;

    suche_datei(os2csm_bin,standardverzeichnis,OS2CSM_ERW,true);

    if os2csm_bin='' then
      os2csm_bin:=OS2CSM_ERW;

    Write(textz_plus_Lade_^,os2csm_bin,' ');

    FileMode:=open_access_ReadOnly+open_share_DenyNone;
    Assign(d,os2csm_bin);
    {$I-}
    Reset(d,1);
    {$I+}
    fehler:=IOResult;
    if fehler<>0 then
      begin
        WriteLn(textz_Fehler__^,fehler,'!');
        fehler_ende(fehler);
      end;

    os2csm_bin_laenge:=FileSize(d);
    BlockRead(d,os2csm_bin_puffer,os2csm_bin_laenge);
    Close(d);

    i:=20;
    repeat
      Inc(i);

      if i=100 then
        begin
          WriteLn(textz_fehlerhafte_Datei__Kennung_nicht_gefunden___^);
          fehler_ende_99;
        end;

      with org_kopf_z(@os2csm_bin_puffer[i])^ do
        if (sig1=0) and (sig2=26) and (version=os2csm_bin_version) and (dauervariablen<anfangsvariablen) then
          begin
            dauervariablen_o:=dauervariablen;
            anfangsvariablen_o:=anfangsvariablen;
            Break;
          end;

    until false;

    WriteLn;
  end;

(*******************************************************************)

function groesste_drehfeld_laenge(const dfs:drehfeld_speicher_typ;const drehfeld_speicher_laenge:word):word;
  var
    i                   :word;
  begin
    Result:=0;
    i:=Low(dfs.elemente);
    with dfs do
      while i<drehfeld_speicher_laenge do
        begin
          Result:=Max(Result,elemente[i]);
          Inc(i,1+elemente[i]);
        end;
  end;


function ueberschreibmodus:boolean;
  begin
    Result:=(SysTVGetShiftState and $80)=0
  end;

procedure leerzeichen_und_tab_umwandeln(var zk:ansistring);
  var
    z           :word;
  begin
    for z:=1 to Length(zk) do
      if zk[z]=#9 then
        zk[z]:=' ';

    while (zk<>'') and (zk[Length(zk)]=' ') do
      SetLength(zk,Length(zk)-1);

  end;

procedure leerzeichen_an_ende_und_anfang_entfernen(var zk:string);
  begin
    while (zk<>'') and (zk[1         ]=' ') do Delete(zk,1         ,1);
    while (zk<>'') and (zk[Length(zk)]=' ') do Delete(zk,Length(zk),1);
  end;

procedure zeilenanfang_abtrennen_mit_trenzeichen(const t:char);
  var
    suchz       :char;
  begin
    while (zeile<>'') and (zeile[1]=' ') do
      Delete(zeile,1,1);

    if (zeile<>'') and (zeile[1] in ['"','''']) then
      begin
        suchz:=zeile[1];
        Delete(zeile,1,1);
        anfang_ist_zeichenkette:=true;
      end
    else
      begin
        suchz:=t;
        anfang_ist_zeichenkette:=false;
      end;

    if Pos(suchz,zeile)=0 then
      begin
        anfang:=zeile;
        zeile:='';
      end
    else
      begin
        anfang:=Copy(zeile,1,Pos(suchz,zeile)-1);
        Delete(zeile,1,1+Length(anfang));
        while (zeile<>'') and (zeile[1]=' ') do
          Delete(zeile,1,1);
      end;

  end;

procedure zeilenanfang_abtrennen;
  begin
    zeilenanfang_abtrennen_mit_trenzeichen(' ');
  end;

procedure zahl_umformung_anfang(const min,max:longint;const erwartet:string);
  var
    {$IfDef VirtualPascal}
    k           :longint;
    {$Else}
    k           :integer;
    {$Endif}
  begin
    Val(anfang,zahl,k);
    if (k<>0) or (anfang='') then
      begin
        WriteLn(textz_error_evaluting^,anfang,'"!');
        WriteLn(textz_erwartet_doppelpunkt^,erwartet);
        schreibe_org_zeile;
        fehler_ende_99;
      end;
    if zahl<min then
      begin
        WriteLn(textz_untere_grenze^,min,' (',zahl,')!');
        WriteLn(textz_erwartet_doppelpunkt^,erwartet);
        schreibe_org_zeile;
        fehler_ende_99;
      end;
    if zahl>max then
      begin
        WriteLn(textz_obere_grenze^,max,' (',zahl,')!');
        WriteLn(textz_erwartet_doppelpunkt^,erwartet);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

  end;

function gross(const zk:string):string;
  (* schîn und gut - aber wie soll MOD.A86 das machen ?
  var
    p:array[0..255] of char;
  begin
    StrPCopy(@p,zk);
    SysUpperCase(@p);
    gross:=StrPas(@p);
  end;*)
  var
    z           :word;
  begin
    Result:=zk;
    for z:=1 to Length(Result) do
      Result[z]:=UpCase(Result[z]); (* 'a'..'z' -> 'A'..'Z' *)
  end;

function uebereinstimmung_anfang(const zk1,zk2:string):boolean;
  var
    anfang_gross        :string;
  begin
    anfang_gross:=gross(anfang);
    uebereinstimmung_anfang:=(zk1=anfang_gross) or (zk2=anfang_gross);
  end;


procedure zahl_oder_boolean__umformung_anfang(const min,max:longint;const erwartet:string);
  var
    {$ifDef VirtualPascal}
    k:longint;
    {$Else}
    k:integer;
    {$EndIf}
  begin
    if uebereinstimmung_anfang('TRUE','WAHR') then
      begin
        zahl:=Ord(true);
        Exit;
      end;

    if uebereinstimmung_anfang('FALSE','FALSCH') then
      begin
        zahl:=Ord(false);
        Exit;
      end;

    zahl_umformung_anfang(min,max,erwartet);
  end;

procedure pruefe_das_gueltige_variable(va:variable);
  begin
    if (va=0) or (va>variablen_zaehler) then
      RunError_99;
  end;

function ist_variable(const va:variable):boolean;
  begin
    if (va and konstanten_bit)=0 then
      begin
        pruefe_das_gueltige_variable(va);
        ist_variable:=true;
      end
    else
      ist_variable:=false;
  end;

function ist_konstante(const va:variable):boolean;
  begin
    ist_konstante:=not ist_variable(va);
  end;

procedure zahl_oder_drehfeldelement__umformung_anfang(const va:variable);
  var
    z,i:word;
  begin
    pruefe_das_gueltige_variable(va);

    with variablen_tabelle[va] do

      if anfang_ist_zeichenkette then
        begin
          zahl:=0;
          i:=1;

          (* alle Werte ausprobieren *)
          for z:=1 to anzahl_einstellungen do
            if string_z(@drehfeld_speicher^.elemente[i])^=anfang then
              begin
                zahl:=z;
                Break;
              end
            else
              Inc(i,1+drehfeld_speicher^.elemente[i]);

          if zahl=0 then
            begin
              WriteLn(textz_Die_Zuweisung_von__^,anfang,textz___passt_nicht_zu_der_Definition_von_^,variablen_name,'!');
              schreibe_org_zeile;
              fehler_ende_99;
            end;

        end
      else (* es wurde die Feldnummer angegeben *)
        begin
          zahl_umformung_anfang(0,$ffff{1,anzahl_einstellungen},textz_Elementnummer_oder_Zeichenkettenkonstante^);
        end;

  end;


function suche_variable(const gesuchter_name:string):integer;
  var
    z                   :integer;
    gesuchter_name_gross:string;
  begin
    gesuchter_name_gross:=gross(gesuchter_name);

    for z:=1 to variablen_zaehler do
      if variablen_tabelle[z].variablen_name=gesuchter_name_gross then
        begin
          suche_variable:=z;
          exit;
        end;
    suche_variable:=-1;
  end;

procedure speicher_string_variable(const va:variable;const zk:string);
  begin
    pruefe_das_gueltige_variable(va);

    with variablen_tabelle[va] do
      begin
        if variablentyp<>variablentyp_zeichenkette then
          RunError_99;

        (* soviel wie reinpa·t kopieren *)
        platz_fuer_zeichenkette:=Copy(zk,1,anzahl_einstellungen);
      end;
  end;

function liefere_zeichenkette_vn(const variablen_nummer:variable):string;
  var
    z,i:word;
  begin
    pruefe_das_gueltige_variable(variablen_nummer);

    with variablen_tabelle[variablen_nummer] do

      case variablentyp of

        variablentyp_zahl:
          Result:=Int2Str(variablen_tabelle[variablen_nummer].aktuelle_einstellung);

        variablentyp_drehfeld:
          begin
            if (aktuelle_einstellung<1) or (aktuelle_einstellung>anzahl_einstellungen) then
              begin
                WriteLn(textz_ausserhalb_des_gueltigen_bereiches^);
                WriteLn(variablen_name,' ',aktuelle_einstellung,' (1..',anzahl_einstellungen,')');
                fehler_ende_99;
              end;

            i:=1;
            with drehfeld_speicher^ do
              begin
                for z:=2 to aktuelle_einstellung do
                  Inc(i,1+elemente[i]);

                Result:=string_z(@elemente[i])^;
              end;
          end;

        variablentyp_zeichenkette:
          Result:=platz_fuer_zeichenkette;

      else
        RunError_99;
      end;
  end;

function liefere_zeichenkette(const va:variable):string;
  begin
    if ist_konstante(va) then
      Result:=Int2Str(va-konstanten_bit)
    else
      Result:=liefere_zeichenkette_vn(va);
  end;

function liefere_wert_aus_zahlenvariable_oder_wert(const va:variable):word;
  begin
    if ist_konstante(va) then
      liefere_wert_aus_zahlenvariable_oder_wert:=va-konstanten_bit
    else
      begin
        pruefe_das_gueltige_variable(va);
        case variablen_tabelle[va].variablentyp of
          variablentyp_zahl,
          variablentyp_drehfeld:
            liefere_wert_aus_zahlenvariable_oder_wert:=variablen_tabelle[va].aktuelle_einstellung;

          variablentyp_zeichenkette:
            RunError_99;
        else
            RunError_99;
        end;
      end;
  end;

procedure lies_zahlenvariable_oder_drehfeldvariable_oder_zeichenkettenvariable(var va:variable);
  var
    z                   :integer;
  begin
    if anfang_ist_zeichenkette then
      begin
        WriteLn(textz_Zahlenvariable_erwartet_^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    z:=suche_variable(anfang);
    if z=-1 then
      begin
        WriteLn(textz_Die_Variable_wurde_noch_nicht_definiert1^,
                anfang,
                textz_Die_Variable_wurde_noch_nicht_definiert2^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    va:=z;
    zeilenanfang_abtrennen;
  end;

procedure lies_drehfeldvariable(var va:variable);
  var
    z                   :integer;
  begin
    if anfang_ist_zeichenkette then
      begin
        WriteLn(textz_Drehfeldvariable_erwartet_^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    z:=suche_variable(anfang);
    if z=-1 then
      begin
        WriteLn(textz_Die_Variable_wurde_noch_nicht_definiert1^,
                anfang,
                textz_Die_Variable_wurde_noch_nicht_definiert2^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    if variablen_tabelle[z].variablentyp<>variablentyp_drehfeld then
      begin
        WriteLn(textz_Drehfeldvariable_erwartet_^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    va:=z;
    zeilenanfang_abtrennen;
  end;

procedure lies_zahlenvariable_oder_drehfeldvariable(var va:variable;const drehfeld_zulaessig:boolean);
  var
    z                   :integer;
  begin
    if anfang_ist_zeichenkette then
      begin
        WriteLn(textz_Zahlenvariable_erwartet_^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    z:=suche_variable(anfang);
    if z=-1 then
      begin
        WriteLn(textz_Die_Variable_wurde_noch_nicht_definiert1^,
                anfang,
                textz_Die_Variable_wurde_noch_nicht_definiert2^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    if (variablen_tabelle[z].variablentyp=variablentyp_zeichenkette)
    or ((variablen_tabelle[z].variablentyp=variablentyp_drehfeld) and (not drehfeld_zulaessig))
     then
      begin
        WriteLn(textz_zeichenkettenvariablen_sind_hier_nicht_erlaubt^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    va:=z;

    zeilenanfang_abtrennen;
  end;

procedure lies_zahlenvariable(var va:variable);
  begin
    lies_zahlenvariable_oder_drehfeldvariable(va,false);
  end;

procedure neue_variable(const name_klein:string);
  var
    z,i                 :integer;
  begin
    Inc(variablen_zaehler);

    if variablen_zaehler>max_variablen then
      begin
        WriteLn(textz_zu_viele_variablen_255^);
        fehler_ende_99;
      end;

    with variablen_tabelle[variablen_zaehler] do
      begin
        variablen_name:=gross(name_klein);
        if variablen_name='' then Exit;

        if Pos('OS2CSM_SYSINFO_', variablen_name) = 1 then
          dmi_variablen_benutzt := True;

        if Length(variablen_name)>=128 then
          begin
            WriteLn(textz_Variablenname_ist_zu_lang^,variablen_name,')!');
            schreibe_org_zeile;
            fehler_ende_99;
          end;


        for z:=1 to Length(variablen_name) do
          if (variablen_name[z] in [#0..#31,' '..'/',':'..'@','['..'^','`',#$7b..#$7f])
          or ((z=1) and (variablen_name[z] in ['0'..'9']))
           then
            begin
              WriteLn(textz_Unzulaessiges_Zeichen_im_Variablennamen_^,variablen_name,')!');
              schreibe_org_zeile;
              fehler_ende_99;
            end;

        i:=suche_variable(variablen_name);
        if i<>variablen_zaehler then
          begin
            WriteLn(textz_Die_Variable_wurde_schon_definiert_1^,
                    variablen_name,
                    textz_Die_Variable_wurde_schon_definiert_2^);
            schreibe_org_zeile;
            fehler_ende_99;
          end;

      end;

  end;

function erzeuge_zeichenkettenkonstante(const wert:string):variable;
  var
    z:integer;
  begin

    (* Sparsamer mit Konstanten umgehen *)
    for z:=1 to variablen_zaehler do
      with variablen_tabelle[z] do
        if  (variablentyp=variablentyp_zeichenkette)
        and (x_position=0)
        and (y_position=0)
        and (seitennummer=0)
        and (sprung_taste=#0)
        and (anzahl_einstellungen=Length(wert))
        and (platz_fuer_zeichenkette=wert)
        and (variablen_name='') then
         begin
           erzeuge_zeichenkettenkonstante:=z;
           Exit;
         end;

    neue_variable('');

    with variablen_tabelle[variablen_zaehler] do
      begin
        variablentyp:=variablentyp_zeichenkette;
        loeschtyp:=variable_loeschen;
        x_position:=0;
        y_position:=0;
        seitennummer:=0;
        sprung_taste:=#0;
        anzahl_einstellungen:=Length(wert);
        platz_fuer_zeichenkette:=wert;

      end; (* with *)


    erzeuge_zeichenkettenkonstante:=variablen_zaehler;
  end;

function erzeuge_zahlenkonstante(const wert:smallword):variable;
  var
    z:integer;
  begin

    (* Sparsamer mit Konstanten umgehen *)
    for z:=1 to variablen_zaehler do
      with variablen_tabelle[z] do
        if  (variablentyp=variablentyp_zahl)
        and (x_position=0)
        and (y_position=0)
        and (seitennummer=0)
        and (sprung_taste=#0)
        and (anzahl_einstellungen=wert)
        and (aktuelle_einstellung=wert)
        and (platz_fuer_zeichenkette='')
        and (variablen_name='') then
         begin
           erzeuge_zahlenkonstante:=z;
           Exit;
         end;

    neue_variable('');

    with variablen_tabelle[variablen_zaehler] do
      begin
        variablentyp:=variablentyp_zahl;
        loeschtyp:=variable_loeschen;
        x_position:=0;
        y_position:=0;
        seitennummer:=0;
        sprung_taste:=#0;
        anzahl_einstellungen:=wert;
        aktuelle_einstellung:=wert;
        platz_fuer_zeichenkette:='';

      end; (* with *)


    erzeuge_zahlenkonstante:=variablen_zaehler;
  end;


function wert_zu_konstante_oder_unbenannter_initialisierter_variable(const zahl:word):variable;
  begin
    if (zahl and konstanten_bit)=0 then
      wert_zu_konstante_oder_unbenannter_initialisierter_variable:=zahl or konstanten_bit
    else
      wert_zu_konstante_oder_unbenannter_initialisierter_variable:=erzeuge_zahlenkonstante(zahl);
  end;

(* wert_min/wert_max wird nur fÅr einen Fall geprÅft *)
procedure lies_wert_oder_zahlenvariable(var va:variable;const wert_min,wert_max:word;const erwartet:string);
  var
    z                   :integer;
  begin

    if anfang_ist_zeichenkette then
      begin
        WriteLn(textz_Zahlenvariable_oder_Zahlenkonstante_erwartet_^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    if uebereinstimmung_anfang('TRUE','WAHR') then
      begin
        va:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(Ord(true));
        zeilenanfang_abtrennen;
        Exit;
      end;

    if uebereinstimmung_anfang('FALSE','FALSCH') then
      begin
        va:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(Ord(false));
        zeilenanfang_abtrennen;
        Exit;
      end;

    if anfang[1] in ['+','-','$','0'..'9'] then
      begin
        zahl_umformung_anfang(wert_min,wert_max,erwartet);
        va:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(zahl);
        zeilenanfang_abtrennen;
        Exit;
      end;

    //lies_zahlenvariable(va);
    lies_zahlenvariable_oder_drehfeldvariable(va,true);
  end;

procedure lies_wert_oder_drehfeldelement(var va:variable;const wert_min,wert_max:word;const erwartet:string;const drehfeldvariable:word);
  begin
    zahl_oder_drehfeldelement__umformung_anfang(drehfeldvariable);
    va:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(zahl);
    zeilenanfang_abtrennen;
  end;

procedure lies_passende_variable_oder_wert_oder_drehfeldelement(var va:variable;const wert_min,wert_max:word;const erwartet:string;const drehfeldvariable:word);
  var
    z                   :integer;
  begin
    (* erstmal versuchen ob anfang eine Variable ist *)
    if not anfang_ist_zeichenkette then
      begin
        z:=suche_variable(anfang);
        if z<>-1 then
          begin
            va:=z;
            // variablentyp braucht hier nicht geprÅft werdem
            // weiter unten wird bei Bedarf ein Zeichenkettenvergleich
            // statt numerischem Vergleich durhcgefÅhrt.
            zeilenanfang_abtrennen;
            Exit;
          end
      end;
    (* sonst Zahlenkonstante(2) oder Drehfeldelment("HPFS") *)
    lies_wert_oder_drehfeldelement(va,wert_min,wert_max,erwartet,drehfeldvariable);
  end;

procedure lies_zeichenkettenvariable(var va:variable;const drehfeld_zulaessig:boolean);
  var
    z                   :integer;
  begin
    if anfang_ist_zeichenkette then
      begin
        WriteLn(textz_Zeichenkettenvariable_erwartet_^,anfang,')');
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    z:=suche_variable(anfang);
    if z<=0 then
      begin
        WriteLn(textz_Zeichenkettenvariable__wurde_noch_nicht_definiert_1^,
                anfang,
                textz_Zeichenkettenvariable__wurde_noch_nicht_definiert_2^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    if variablen_tabelle[z].variablentyp<>variablentyp_zeichenkette then
      if (not drehfeld_zulaessig)
      or (variablen_tabelle[z].variablentyp<>variablentyp_drehfeld) then
        begin
          if drehfeld_zulaessig then
            WriteLn(textz_Zeichenkette_oder_Drehfeld_Variable_erwartet_^)
          else
            WriteLn(textz_Zeichenketten_Variable_erwartet_^);
          schreibe_org_zeile;
          fehler_ende_99;
        end;

    va:=z;

    zeilenanfang_abtrennen;
  end;

procedure lies_zeichenkettenvariable_oder_konstante(var va:variable);
  begin

    if anfang_ist_zeichenkette then
      begin
        va:=erzeuge_zeichenkettenkonstante(anfang);
        zeilenanfang_abtrennen;
      end
    else
      lies_zeichenkettenvariable(va,true);

  end;


(* alle Typen zulÑssig *)
procedure lies_zeichenketten_oder_zahlenvariable(var va:variable);
  var
    z                   :integer;
  begin

    if anfang_ist_zeichenkette then
      begin
        WriteLn(textz_Variable_erwartet_^,anfang,')');
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    z:=suche_variable(anfang);
    if z<=0 then
      begin
        WriteLn(textz_Variable__wurde_noch_nicht_definiert1^,
                anfang,
                textz_Variable__wurde_noch_nicht_definiert2^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    va:=z;

    zeilenanfang_abtrennen;
  end;


procedure lies_variable_oder_konstante(var va:variable;const wert_min,wert_max:word;const erwartet:string);
  begin
    if anfang_ist_zeichenkette then
      begin
        lies_zeichenkettenvariable_oder_konstante(va);
        Exit;
      end;

    if uebereinstimmung_anfang('TRUE','WAHR') then
      begin
        va:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(Ord(true));
        zeilenanfang_abtrennen;
        Exit;
      end;

    if uebereinstimmung_anfang('FALSE','FALSCH') then
      begin
        va:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(Ord(false));
        zeilenanfang_abtrennen;
        Exit;
      end;

    if anfang[1] in ['+','-','$','0'..'9'] then
      begin
        zahl_umformung_anfang(wert_min,wert_max,erwartet);
        va:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(zahl);
        zeilenanfang_abtrennen;
        Exit;
      end;

    lies_zeichenketten_oder_zahlenvariable(va);
  end;

procedure lies_zeichenkettenvariable_oder_konstante_oder_zahlenvariable_oder_konstante(var va:variable);
  begin
    lies_variable_oder_konstante(va,0,$ffff,'String');
  end;


procedure ueberlies(const zf1,zf2:string);
  var
    anfang_gross        :string;
  begin
    anfang_gross:=gross(anfang);

    if anfang_ist_zeichenkette or ((anfang_gross<>zf1) and (anfang_gross<>zf2)) then
      begin
        WriteLn(textz_Syntaxfehler___erwartet_1^,
                zf1,
                textz_Syntaxfehler___erwartet_2^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    zeilenanfang_abtrennen;
  end;

procedure schnellmenu_eintrag(const menu_taste:longint);
  var
    z1                  :variable;
    wert_zahl           :longint;
    min                 :longint;

  type
    string_z            =^string;

  label
    wert_zahl_bestimmt;

  begin
    lies_zahlenvariable_oder_drehfeldvariable_oder_zeichenkettenvariable(z1);

    with variablen_tabelle[z1] do
      case variablentyp of
        variablentyp_zahl:
          if anzahl_einstellungen=1 then
            zahl_oder_boolean__umformung_anfang(0,1,textz_wert_boolean_oder_0_1_^)
          else
          if (*versteckt:*) (x_position=0) and (y_position=0) then
            zahl_umformung_anfang(0,anzahl_einstellungen,textz_wert^)
          else
            zahl_umformung_anfang(1,anzahl_einstellungen,textz_wert^);

        variablentyp_zeichenkette:
          zahl:=erzeuge_zeichenkettenkonstante(anfang);

        variablentyp_drehfeld:
          zahl_oder_drehfeldelement__umformung_anfang(z1);

      else
        RunError_99;
      end;

    if   schnell_menu_benutzt[menu_taste][z1]
    and (schnell_menu[menu_taste][z1]<>zahl) then
      begin
        Writeln(textz_Mehrfache_wiederspruechliche_Variablenzuweisung^,
          variablen_tabelle[z1].variablen_name,')');
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    schnell_menu_benutzt[menu_taste][z1]:=true;
    schnell_menu[menu_taste][z1]:=zahl;
  end;

procedure erwarte_zeilenende;
  begin
    if anfang<>'' then
      begin
        WriteLn('"',anfang,'" ???');
        schreibe_org_zeile;
        fehler_ende_99;
      end;
  end;

procedure entschluessele_anweisung(const zustand_anwendbar0:byte);
  var
    va                  :longint;
    gross_anfang        :string;
    temp                :variable;
    i,z,wert            :word;
    typgebende_variable :word;

  label
    erwarte_var2,
    erwarte_then,
    nach_then,
    erwarte_var_verkn_3,
    erwarte_zeilenende_;

  begin
    (* [ "IF" <[VAR]/VAL> <"="/"<"/">"/"<="/">="/"<>"> <[VAR]/VAL> "THEN" ]

        <[VAR]/VAL> ":=" <[VAR]/VAL> <"XOR"/"+"/"-"/"ODER"/"UND"> <[VAR]/VAL>
        <[VAR]/VAL> ":="              ["NOT"]                     <[VAR]/VAL>

  * A0) Ende der Formeln
    A1) *                     {IF TRUE  = TRUE THEN}   (ohne if .. ) -> A6
    A2) IF          VAR2 THEN {IF TRUE  = VAR2 THEN}   (boolean)     -> A6
    A3) IF      NOT VAR2 THEN {IF FALSE = VAR2 THEN}   (boolean)     -> A6
  * A4) IF VAR1 AND VAR2 THEN
  * A5) IF VAR1 OR  VAR2 THEN
  * A6) IF VAR1 =   VAR2 THEN
  * A7) IF VAR1 <   VAR2 THEN
    A8) IF VAR1 >   VAR2 THEN {IF VAR2 <  VAR1 THEN}                 -> A7
  * A9) IF VAR1 <=  VAR2 THEN
    AA) IF VAR1 >=  VAR2 THEN {IF VAR2 <= VAR1 THEN}                 -> A9
  * AB) IF VAR1 <>  VAR2 THEN

  * AC) IF STR1 =   STR2 THEN
  * AD) IF STR1 <>  STR2 THEN


    B0) VAR3 :=          VAR5 (boolean) {FALSE XOR VAR5} -> B4
    B1) VAR3 :=      not VAR5 (boolean) {TRUE  XOR VAR5} -> B4
  * B2) VAR3 := VAR4 and VAR5 (boolean)
  * B3) VAR3 := VAR4 or  VAR5 (boolean)
  * B4) VAR3 := VAR4 xor VAR5 (boolean)
  * B5) VAR3 := VAR4 +   VAR5 (byte,modulo anzahl)
  * B6) VAR3 := VAR4 -   VAR5 (byte,modulo anzahl)
  * B7) VAR3 := VAR4 =   VAR5
  * B8) VAR3 := VAR4 <   VAR5
    B9) VAR3 := VAR4 >   VAR5 {VAR3 := VAR5 < VAR4}      -> B8
  * BA) VAR3 := VAR4 <=  VAR5
    BB) VAR3 := VAR4 >=  VAR5 {VAR3 := VAR5 < VAR4}      -> BA
  * BC) VAR3 := VAR4 <>  VAR5

    STR_APPEND
    STR_COMP
    STR_DELETE
    STR_INSERT
    STR_LENGTH
    STR_CONCAT
    STR_TRIM
    STR_COPY
    STR_UPCASE
    STR_VAL
    STR_DISPLAY
    SEARCH_PCI_DEVICEID
    SEARCH_PCI_DEVICECLASS
    SEARCH_PNP_DEVICEID
    SEARCH_PNP_DEVICECLASS
    COUNT_PCI_DEVICEID
    COUNT_PCI_DEVICECLASS
    COUNT_PNP_DEVICEID
    COUNT_PNP_DEVICECLASS
    QUERY_BOOTDRIVE_LETTER
    SET_BOOTDRIVE_LETTER
    SET_ALTF2_ON_FILE
                                                                        *)

    Inc(formel_zaehler);
    with formel_tabelle[formel_zaehler] do
      begin
        zustand_anwendbar:=zustand_anwendbar0;

        if not uebereinstimmung_anfang('IF','WENN') then
          begin
            if_teil:=6; (* A1 -> A6*)
            var_if_1:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(Ord(true));
            var_if_2:=var_if_1;
            goto nach_then;
          end;

        zeilenanfang_abtrennen; (* IF/WENN *)

        if uebereinstimmung_anfang('NOT','NICHT') then
          begin (* A3 -> A6 *)
            if_teil:=6;
            var_if_1:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(Ord(false));
            zeilenanfang_abtrennen; (* NOT/NICHT *)

            lies_wert_oder_zahlenvariable(var_if_2,0,$ffff,textz_Zahl_fuer_den_Ausdruck^);
            goto erwarte_then;
          end;

        (* VAR1 oder VAR2(A2) lesen *)
        lies_variable_oder_konstante(var_if_1,0,$ffff,textz_Zahl_fuer_den_Ausdruck^);

        if uebereinstimmung_anfang('THEN','DANN') then
          begin (* A2 -> A6 *)
            if_teil:=6;
            var_if_2:=var_if_1;
            var_if_1:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(Ord(true));
            goto erwarte_then;
          end;

        if uebereinstimmung_anfang('AND','UND') then
          begin (* A4 *)
            if_teil:=4;
            goto erwarte_var2
          end;

        if uebereinstimmung_anfang('OR','ODER') then
          begin (* A5 *)
            if_teil:=5;
            goto erwarte_var2
          end;

        if uebereinstimmung_anfang('=','=') then
          begin (* A6 *)
            if_teil:=6;
            goto erwarte_var2
          end;

        if uebereinstimmung_anfang('<','<') then
          begin (* A7 *)
            if_teil:=7;
            goto erwarte_var2
          end;

        if uebereinstimmung_anfang('>','>') then
          begin (* A8 *)
            if_teil:=8;
            goto erwarte_var2
          end;

        if uebereinstimmung_anfang('<=','<=') then
          begin (* A9 *)
            if_teil:=9;
            goto erwarte_var2
          end;

        if uebereinstimmung_anfang('>=','>=') then
          begin (* AA *)
            if_teil:=$A;
            goto erwarte_var2
          end;

        if uebereinstimmung_anfang('<>','<>') then
          begin (* AB *)
            if_teil:=$B;
            goto erwarte_var2
          end;

        WriteLn(textz_unbekannte_verknuepfung^,anfang);
        schreibe_org_zeile;
        fehler_ende_99;

  erwarte_var2:
        zeilenanfang_abtrennen;


        if ist_variable(var_if_1) then
          case variablen_tabelle[var_if_1].variablentyp of
            variablentyp_zahl:
              lies_wert_oder_zahlenvariable(var_if_2,0,$ffff,
                textz_Zahl_fuer_den_Ausdruck^);

            variablentyp_zeichenkette:
              lies_zeichenkettenvariable_oder_konstante_oder_zahlenvariable_oder_konstante(var_if_2);

            variablentyp_drehfeld:
              begin
                lies_passende_variable_oder_wert_oder_drehfeldelement(
                  var_if_2,
                  1,variablen_tabelle[var_if_1].anzahl_einstellungen,
                  textz_Zahl_fuer_den_Ausdruck^,
                  var_if_1);
              end;
          else
            RunError(99);
          end
        else (* IF 2=xxxx *)
          lies_variable_oder_konstante  (var_if_2,0,$ffff,textz_Zahl_fuer_den_Ausdruck^);


        case if_teil of
          $8: (* A8 -> A7 *)
            begin
              if_teil:=7;
              temp:=var_if_1;
              var_if_1:=var_if_2;
              var_if_2:=temp;
            end;
          $A: (* AA -> A9 *)
            begin
              if_teil:=9;
              temp:=var_if_1;
              var_if_1:=var_if_2;
              var_if_2:=temp;
            end;
        end;



  erwarte_then:
        ueberlies('THEN','DANN');


  nach_then:

        (* zulÑssige Vergleiche:
           VAR1                  VAR2                       Vergleich
           Konstante/Zahl        Konstante/Zahl             Zahl
           Konstante/Zahl        Drehfeld                   Zahl
           Drehfeld              Konstante/Zahl             Zahl
           Drehfeld/Zeichenkette Drehfeld/Zeichenkette      Zeichenkette fÅr '<>' und '='
                                                            Zahl sonst (wenn mîglich)

           sonst                                            Fehler        *)

        if ist_variable(var_if_1) and ist_konstante(var_if_2) then
          with variablen_tabelle[var_if_1] do
            if variablentyp=variablentyp_zeichenkette then
              begin
                WriteLn(textz_Zahlenvariable_erwartet__^,variablen_name,')');
                schreibe_org_zeile;
                fehler_ende_99;
              end;

        if ist_konstante(var_if_1) and ist_variable(var_if_2) then
          with variablen_tabelle[var_if_2] do
            if variablentyp=variablentyp_zeichenkette then
              begin
                WriteLn(textz_Zahlenvariable_erwartet__^,variablen_name,')');
                schreibe_org_zeile;
                fehler_ende_99;
              end;


        if ist_variable(var_if_1) and ist_variable(var_if_2) then
          if  (variablen_tabelle[var_if_1].variablentyp in [variablentyp_zeichenkette,variablentyp_drehfeld])
          and (variablen_tabelle[var_if_2].variablentyp in [variablentyp_zeichenkette,variablentyp_drehfeld]) then
            begin
              (* Zeichenkettenvergleich *)
              case if_teil of
                $6: (* =  *)
                  if_teil:=$c;  //??
                $b: (* <> *)
                  if_teil:=$d; //??
              else

                if  (variablen_tabelle[var_if_1].variablentyp=variablentyp_zeichenkette)
                and (variablen_tabelle[var_if_2].variablentyp=variablentyp_zeichenkette) then
                  begin
                    WriteLn(textz_Nur_gleich_und_ungleich_sind_fuer_Zeichenkettenvergleiche_zulaessig_^);
                    schreibe_org_zeile;
                    fehler_ende_99;
                  end;

              end;
            end;


        (***********************************************************)
        if uebereinstimmung_anfang('STR_APPEND(','ZK_ANHéNGEN(') then
          begin
            (* STR_APPEND(VAR STR1;CONST STR2) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable(var_verkn_1,false);
            lies_zeichenkettenvariable_oder_konstante_oder_zahlenvariable_oder_konstante(var_verkn_2);
            ueberlies(')',')');
            verknuepfung:=str_append;
          end

        else if uebereinstimmung_anfang('STR_COMP(','ZK_VERGLEICH(') then
          begin
            (* STR_COMP(CONST STR1,STR2;VAR BOOLEAN3) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable_oder_konstante(var_verkn_1);
            lies_zeichenkettenvariable_oder_konstante(var_verkn_2);
            lies_zahlenvariable(var_verkn_3);
            ueberlies(')',')');
            verknuepfung:=str_comp;
          end

        else if uebereinstimmung_anfang('STR_DELETE(','ZK_LôSCHEN(') then
          begin
            (* STR_DELETE(VAR STR1;CONST INT2,INT3) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable(var_verkn_1,false);
            lies_wert_oder_zahlenvariable(var_verkn_2,1,
              variablen_tabelle[var_verkn_1].anzahl_einstellungen,textz_Anfangsposition^);
            lies_wert_oder_zahlenvariable(var_verkn_3,0,255,textz_Anzahl_zu_loeschender_Zeichen^);
            ueberlies(')',')');
            verknuepfung:=str_delete;
          end

        else if uebereinstimmung_anfang('STR_INSERT(','ZK_EINFöGEN(') then
          begin
            (* STR_INSERT(CONST STR1;VAR STR2;CONST INT3) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable_oder_konstante_oder_zahlenvariable_oder_konstante(var_verkn_1);
            lies_zeichenkettenvariable(var_verkn_2,false);
            lies_wert_oder_zahlenvariable(var_verkn_3,1,
              variablen_tabelle[var_verkn_2].anzahl_einstellungen,textz_Einfuegestelle^);
            ueberlies(')',')');
            verknuepfung:=str_insert;
          end

        else if uebereinstimmung_anfang('STR_LENGTH(','ZK_LéNGE(') then
          begin
            (* STR_LENGTH(CONST STR1;VAR INT2) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable_oder_konstante_oder_zahlenvariable_oder_konstante(var_verkn_1);
            lies_zahlenvariable(var_verkn_2);
            ueberlies(')',')');
            verknuepfung:=str_length;
          end

        else if uebereinstimmung_anfang('STR_TRIM(','ZK_LEERFILTER(') then
          begin
            (* STR_TRIM(CONST STR1;VAR STR2) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable_oder_konstante(var_verkn_1);
            lies_zeichenkettenvariable(var_verkn_2,false);
            ueberlies(')',')');
            verknuepfung:=str_trim;
          end

        else if uebereinstimmung_anfang('STR_COPY(','ZK_KOPIERER(') then
          begin
            (* STR_COPY(CONST STR1;CONST INT2,INT3;VAR STR4) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable_oder_konstante_oder_zahlenvariable_oder_konstante(var_verkn_1);
            lies_wert_oder_zahlenvariable(var_verkn_2,1,
              variablen_tabelle[var_verkn_1].anzahl_einstellungen,textz_Anfangsposition^);
            lies_wert_oder_zahlenvariable(var_verkn_3,0,255,textz_Laenge^);
            lies_zeichenkettenvariable(var_verkn_4,false);
            ueberlies(')',')');
            verknuepfung:=str_copy;
          end

        else if uebereinstimmung_anfang('STR_UPCASE(','ZK_GROSS(') then
          begin
            (* STR_UPCASE(CONST STR1;VAR STR2) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable_oder_konstante(var_verkn_1);
            lies_zeichenkettenvariable(var_verkn_2,false);
            ueberlies(')',')');
            verknuepfung:=str_upcase;
          end

        else if uebereinstimmung_anfang('STR_VAL(','ZK_WERTUNG(') then
          begin
            (* STR_VAL(CONST STR1;VAR INT2) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable_oder_konstante(var_verkn_1);
            lies_zahlenvariable_oder_drehfeldvariable(var_verkn_2,true);
            ueberlies(')',')');
            verknuepfung:=str_val;
          end

        else if uebereinstimmung_anfang('STR_DISPLAY(','ZK_ANZEIGE(') then
          begin
            (* STR_DISPLAY(CONST X,Y,P;CONST STR) *)
            zeilenanfang_abtrennen;
            lies_wert_oder_zahlenvariable(var_verkn_1,1,80,textz_Zeilennummer^);
            lies_wert_oder_zahlenvariable(var_verkn_2,1,seiten_zeilenzahl,textz_Zeilennummer^);
            lies_wert_oder_zahlenvariable(var_verkn_3,0,High(seiten_hintergruende),textz_Seitennummer^);
            if ist_konstante(var_verkn_3) then
              if liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3)=0 then
                var_verkn_3:=seiten_anzahl or konstanten_bit; (* seiten_anzahl ist sicher < $8000 *)
            lies_zeichenkettenvariable_oder_konstante_oder_zahlenvariable_oder_konstante(var_verkn_4);
            ueberlies(')',')');
            verknuepfung:=str_display;
          end

        else if uebereinstimmung_anfang('SEARCH_PCI_DEVICEID(','SUCHE_PCI_GERéTEKENNUNG(') then
          begin
            (* SEARCH_PCI_DEVICEID(CONST VENDOR,DEVICE:STR;VAR FOUND:BOOLEAN) *)
            zeilenanfang_abtrennen;
            (* "10EC" und $10EC sind zulÑssig, als Variablen und Konstanten *)
            lies_variable_oder_konstante(var_verkn_1,0,$ffff,textz_Hersteller_Kennung^);
            lies_variable_oder_konstante(var_verkn_2,0,$ffff,textz_Geraetenummer^);
            lies_zahlenvariable(var_verkn_3);
            ueberlies(')',')');
            verknuepfung:=search_pci_deviceid;
          end

        else if uebereinstimmung_anfang('SEARCH_PCI_DEVICECLASS(','SUCHE_PCI_GERéTEKLASSE(') then
          begin
            (* SEARCH_PCI_DEVICECLASS(CONST DEVICECLASS,PROGRAMMINGINTERFACE:STR;VAR FOUND:BOOLEAN) *)
            zeilenanfang_abtrennen;
            lies_variable_oder_konstante(var_verkn_1,0,$ffff,textz_Geraeteklasse^);
            lies_variable_oder_konstante(var_verkn_2,0,$ffff,textz_Zugriffsart^);
            lies_zahlenvariable(var_verkn_3);
            ueberlies(')',')');
            verknuepfung:=search_pci_deviceclass;
          end

        else if uebereinstimmung_anfang('SEARCH_PNP_DEVICEID(','SUCHE_PNP_GERéTEKENNUNG(') then
          begin
            (* SEARCH_PNP_DEVICEID(CONST PNPID:STR;VAR FOUND:BOOLEAN) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable_oder_konstante(var_verkn_1);
            lies_zahlenvariable(var_verkn_2);
            ueberlies(')',')');
            verknuepfung:=search_pnp_deviceid;
            pnp_funktion_benutzt:=true;
          end

        else if uebereinstimmung_anfang('SEARCH_PNP_DEVICECLASS(','SUCHE_PNP_GERéTEKLASSE(') then
          begin
            (* SEARCH_PNP_DEVICECLASS(CONST DEVICECLASS,PROGRAMMINGINTERFACE:STR;VAR FOUND:BOOLEAN) *)
            zeilenanfang_abtrennen;
            lies_variable_oder_konstante(var_verkn_1,0,$ffff,textz_Geraeteklasse^);
            lies_variable_oder_konstante(var_verkn_2,0,$ffff,textz_Zugriffsart^);
            lies_zahlenvariable(var_verkn_3);
            ueberlies(')',')');
            verknuepfung:=search_pnp_deviceclass;
            pnp_funktion_benutzt:=true;
          end

        else if uebereinstimmung_anfang('COUNT_PCI_DEVICEID(','ZéHLE_PCI_GERéTEKENNUNG(') then
          begin
            (* COUNT_PCI_DEVICEID(CONST VENDOR,DEVICE:STR;VAR FOUND:INTEGER) *)
            zeilenanfang_abtrennen;
            (* "10EC" und $10EC sind zulÑssig, als Variablen und Konstanten *)
            lies_variable_oder_konstante(var_verkn_1,0,$ffff,textz_Hersteller_Kennung^);
            lies_variable_oder_konstante(var_verkn_2,0,$ffff,textz_Geraetenummer^);
            lies_zahlenvariable(var_verkn_3);
            ueberlies(')',')');
            verknuepfung:=count_pci_deviceid;
          end

        else if uebereinstimmung_anfang('COUNT_PCI_DEVICECLASS(','ZéHLE_PCI_GERéTEKLASSE(') then
          begin
            (* COUNT_PCI_DEVICECLASS(CONST DEVICECLASS,PROGRAMMINGINTERFACE:STR;VAR FOUND:INTEGER) *)
            zeilenanfang_abtrennen;
            lies_variable_oder_konstante(var_verkn_1,0,$ffff,textz_Geraeteklasse^);
            lies_variable_oder_konstante(var_verkn_2,0,$ffff,textz_Zugriffsart^);
            lies_zahlenvariable(var_verkn_3);
            ueberlies(')',')');
            verknuepfung:=count_pci_deviceclass;
          end

        else if uebereinstimmung_anfang('COUNT_PNP_DEVICEID(','ZéHLE_PNP_GERéTEKENNUNG(') then
          begin
            (* COUNT_PNP_DEVICEID(CONST PNPID:STR;VAR FOUND:INTEGER) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable_oder_konstante(var_verkn_1);
            lies_zahlenvariable(var_verkn_2);
            ueberlies(')',')');
            verknuepfung:=count_pnp_deviceid;
            pnp_funktion_benutzt:=true;
          end

        else if uebereinstimmung_anfang('COUNT_PNP_DEVICECLASS(','ZéHLE_PNP_GERéTEKLASSE(') then
          begin
            (* COUNT_PNP_DEVICECLASS(CONST DEVICECLASS,PROGRAMMINGINTERFACE:STR;VAR FOUND:INTEGER) *)
            zeilenanfang_abtrennen;
            lies_variable_oder_konstante(var_verkn_1,0,$ffff,textz_Geraeteklasse^);
            lies_variable_oder_konstante(var_verkn_2,0,$ffff,textz_Zugriffsart^);
            lies_zahlenvariable(var_verkn_3);
            ueberlies(')',')');
            verknuepfung:=count_pnp_deviceclass;
            pnp_funktion_benutzt:=true;
          end

        else if uebereinstimmung_anfang('QUERY_BOOTDRIVE_LETTER(','ERMITTLE_START_LAUFWERKSBUCHSTABE(') then
          begin
            (* QUERY_BOOTDRIVE_LETTER(VAR DRIVELETTER:STRING) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable(var_verkn_1,true);
            verknuepfung:=QUERY_BOOTDRIVE_LETTER;
            ueberlies(')',')');
          end

        else if uebereinstimmung_anfang('SET_BOOTDRIVE_LETTER(','SETZE_START_LAUFWERKSBUCHSTABE(') then
          begin
            (* SET_BOOTDRIVE_LETTER(CONST DRIVELETTER:STRING) *)
            zeilenanfang_abtrennen;
            lies_zeichenkettenvariable_oder_konstante(var_verkn_1);
            verknuepfung:=SET_BOOTDRIVE_LETTER;
            ueberlies(')',')');
          end

        else if uebereinstimmung_anfang('SET_ALTF2ON_FILE(','SETZE_ALTF2ON_DATEI(') then
          begin
            (* SET_ALTF2ON_FILE(CONST ALTF2ON:INTEGER) *)
            zeilenanfang_abtrennen;
            lies_wert_oder_zahlenvariable(var_verkn_1,0,2,'ALTF2ON.$$$');
            verknuepfung:=SET_ALTF2ON_FILE;
            ueberlies(')',')');
          end

        else (* Zuweisung *)
          begin
            (* INT1:=INT2 x INT3 *)

            (* VAR3 *)
            lies_zeichenketten_oder_zahlenvariable(var_verkn_1);

            (* := *)
            ueberlies(':=',':=');

            case variablen_tabelle[var_verkn_1].variablentyp of
              variablentyp_zahl,
              variablentyp_drehfeld:
                begin

                  (* VAR4 oder "NOT" oder VAR5(B0) *)

                  if uebereinstimmung_anfang('NOT','NICHT') then
                    begin (* B1 -> B4 *)
                      verknuepfung:=4; (* xor 1 *)
                      zeilenanfang_abtrennen;
                      var_verkn_2:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(Ord(true));
                      goto erwarte_var_verkn_3
                    end;

                  (* VAR4 oder VAR5(B0) *)
                  with variablen_tabelle[var_verkn_1] do
                    case variablentyp of
                      variablentyp_zahl:
                        lies_wert_oder_zahlenvariable(var_verkn_2,0,$ffff,textz_Zuweisungsausdruck^);

                      variablentyp_drehfeld:
                        if anfang_ist_zeichenkette then
                          lies_wert_oder_drehfeldelement(var_verkn_2,0,$ffff,textz_Zuweisungsausdruck^,var_verkn_1)
                        else (* es wurde die Feldnummer angegeben *)
                          lies_wert_oder_zahlenvariable(var_verkn_2,0,$ffff{1,anzahl_einstellungen},textz_Elementnummer_oder_Zeichenkettenkonstante^);

                    else
                      RunError_99;
                    end;


                  if anfang='' then
                    begin (* B0 -> B4 *)
                      verknuepfung:=4;
                      var_verkn_3:=var_verkn_2;
                      var_verkn_2:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(Ord(false));
                      goto erwarte_zeilenende_
                    end;

                  if uebereinstimmung_anfang('AND','UND') then
                    begin (* B2 *)
                      verknuepfung:=2;
                      zeilenanfang_abtrennen;
                      goto erwarte_var_verkn_3
                    end;

                  if uebereinstimmung_anfang('OR','ODER') then
                    begin (* B3 *)
                      verknuepfung:=3;
                      zeilenanfang_abtrennen;
                      goto erwarte_var_verkn_3
                    end;

                  if uebereinstimmung_anfang('XOR','EODER') then
                    begin (* B4 *)
                      verknuepfung:=4;
                      zeilenanfang_abtrennen;
                      goto erwarte_var_verkn_3
                    end;

                  if uebereinstimmung_anfang('+','+') then
                    begin (* B5 *)
                      verknuepfung:=5;
                      zeilenanfang_abtrennen;
                      goto erwarte_var_verkn_3
                    end;

                  if uebereinstimmung_anfang('-','-') then
                    begin (* B6 *)
                      verknuepfung:=6;
                      zeilenanfang_abtrennen;
                      goto erwarte_var_verkn_3
                    end;

                  if uebereinstimmung_anfang('=','=') then
                    begin (* B7 *)
                      verknuepfung:=7;
                      zeilenanfang_abtrennen;
                      goto erwarte_var_verkn_3
                    end;

                  if uebereinstimmung_anfang('<','<') then
                    begin (* B8 *)
                      verknuepfung:=8;
                      zeilenanfang_abtrennen;
                      goto erwarte_var_verkn_3
                    end;

                  if uebereinstimmung_anfang('>','>') then
                    begin (* B9 *)
                      verknuepfung:=9;
                      zeilenanfang_abtrennen;
                      goto erwarte_var_verkn_3
                    end;

                  if uebereinstimmung_anfang('<=','<=') then
                    begin (* BA *)
                      verknuepfung:=$a;
                      zeilenanfang_abtrennen;
                      goto erwarte_var_verkn_3
                    end;

                  if uebereinstimmung_anfang('>=','>=') then
                    begin (* BB *)
                      verknuepfung:=$b;
                      zeilenanfang_abtrennen;
                      goto erwarte_var_verkn_3
                    end;

                  if uebereinstimmung_anfang('<>','<>') then
                    begin (* BC *)
                      verknuepfung:=$c;
                      zeilenanfang_abtrennen;
                      goto erwarte_var_verkn_3
                    end;


                  WriteLn(textz_unbekannte_verknuepfung^,anfang);
                  schreibe_org_zeile;
                  fehler_ende_99;

        erwarte_var_verkn_3:
                  (* var_verkn_3 *)
                  (* Drehfeld := Wert + 1
                     Boolean := Drehfeld = Drehfeldelement *)
                  typgebende_variable:=var_verkn_1;
                  if ist_variable(var_verkn_2) then
                    if variablen_tabelle[var_verkn_2].variablentyp=variablentyp_drehfeld then
                      typgebende_variable:=var_verkn_2;

                  with variablen_tabelle[typgebende_variable] do
                    case variablentyp of
                      variablentyp_zahl:
                        lies_wert_oder_zahlenvariable(var_verkn_3,0,$ffff,textz_Zuweisungsausdruck^+' (2)');

                      variablentyp_drehfeld:
                        if anfang_ist_zeichenkette then
                          begin
                            wert:=0;
                            i:=1;

                            with drehfeld_speicher^ do
                              (* alle Werte ausprobieren *)
                              for z:=1 to anzahl_einstellungen do
                                if string_z(@elemente[i])^=anfang then
                                  begin
                                    wert:=z;
                                    Break;
                                  end
                                else
                                  Inc(i,1+elemente[i]);


                            if wert=0 then
                              begin
                                WriteLn(textz_Die_Zuweisung_von__^,anfang,textz___passt_nicht_zu_der_Definition_von_^,variablen_name,'!');
                                schreibe_org_zeile;
                                fehler_ende_99;
                              end;

                            var_verkn_3:=wert_zu_konstante_oder_unbenannter_initialisierter_variable(wert);
                            zeilenanfang_abtrennen;
                          end
                        else (* es wurde die Feldnummer angegeben *)
                          lies_wert_oder_zahlenvariable(var_verkn_3,0,$ffff{1,anzahl_einstellungen},textz_Elementnummer_oder_Zeichenkettenkonstante^);

                    else
                      RunError_99;
                    end;



                  case verknuepfung of
                    $9: (* B9 -> B8 *)
                      begin
                        temp:=var_verkn_2;
                        var_verkn_2:=var_verkn_3;
                        var_verkn_3:=temp;
                        verknuepfung:=8;
                      end;
                    $b: (* BB -> BA *)
                      begin
                        temp:=var_verkn_2;
                        var_verkn_2:=var_verkn_3;
                        var_verkn_3:=temp;
                        verknuepfung:=$a;
                      end;
                  end;

                end; (* variablentyp_zahl/variablentyp_drehfeld *)

              variablentyp_zeichenkette:
                begin
                  (* STR_CONCAT(CONST STR1,STR2;VAR STR3) *)
                  var_verkn_3:=var_verkn_1;
                  lies_zeichenkettenvariable_oder_konstante_oder_zahlenvariable_oder_konstante(var_verkn_1);

                  if uebereinstimmung_anfang('+','+') then
                    begin
                      zeilenanfang_abtrennen;
                      lies_zeichenkettenvariable_oder_konstante(var_verkn_2);
                    end
                  else
                    begin
                      var_verkn_2:=erzeuge_zeichenkettenkonstante('');
                    end;

                  verknuepfung:=str_concat;
                end;

            else
              RunError_99;
            end; (* variablentyp *)

  erwarte_zeilenende_:

          end; (* ... Zuweisung *)


       (* keine weiteren Angaben erwartet/zulÑssig *)
       erwarte_zeilenende;

      end; (* with *)
  end;

procedure lies_variable(const var_typ:byte;versteckt:boolean;const typ_gefordert:string);
  var
    z1                  :longint;
    dazu,i              :word;
    zk                  :string;
    seite_angegeben     :boolean;
    like                :variable;
  begin

    neue_variable(anfang);

    with variablen_tabelle[variablen_zaehler] do
      begin
        zeilenanfang_abtrennen;

        variablentyp:=var_typ;
        loeschtyp:=0;

        if versteckt then
          begin
            x_position:=0;
            y_position:=0;
            seitennummer:=0;
          end
        else
          begin
            (* X *)
            zahl_umformung_anfang(0,80,textz_Spaltenposition^);
            x_position:=zahl;
            zeilenanfang_abtrennen;

            (* Y *)
            if x_position=0 then
              begin (* unsichtbar *)
                zahl_umformung_anfang(0,0,'0');
                versteckt:=true;
              end
            else
              zahl_umformung_anfang(1,seiten_zeilenzahl,textz_Zeilennummer^);
            y_position:=zahl;
            zeilenanfang_abtrennen;

            if seiten_anzahl=0 then
              begin
                WriteLn(textz_Zuerst_mit_MENU_BIN_eine_Seite_definieren^);
                schreibe_org_zeile;
                fehler_ende_99;
              end;

            seite_angegeben:=false;
            seitennummer:=seiten_anzahl;
            if Pos('SEITE',gross(anfang))=1 then
              begin
                Delete(anfang,1,Length('SEITE'));
                seite_angegeben:=true;
              end;
            if Pos('PAGE',gross(anfang))=1 then
              begin
                Delete(anfang,1,Length('PAGE'));
                seite_angegeben:=true;
              end;

            if seite_angegeben then
              begin
                (* 'SEITE1'  -> '1' -> '1' *)
                (* 'SEITE 1' -> ''  -> '1' *)
                if anfang='' then
                  zeilenanfang_abtrennen;

                zahl_umformung_anfang(1,seiten_zeilenzahl,textz_Seitennummer^);
                seitennummer:=zahl;

                zeilenanfang_abtrennen;
              end;

          end;


        (* Bereich *)
        case variablentyp of
          variablentyp_zahl:
            begin

              if typ_gefordert='B' then
                anzahl_einstellungen:=1

              else if uebereinstimmung_anfang('BOOLEAN','BOOL') then
                begin
                  anzahl_einstellungen:=1;
                  zeilenanfang_abtrennen;
                end

              else
                begin
                  if versteckt then
                    zahl_umformung_anfang(0,$ffff,textz_Anzahl_der_Zustaende^)
                  else
                    zahl_umformung_anfang(1,60,textz_Anzahl_der_Zustaende^);
                    (* Zeilenzahl 60 ist auch nicht erreichbar *)
                  anzahl_einstellungen:=zahl;
                  zeilenanfang_abtrennen;
                end;


            end; (* variablentyp_zahl *)

          variablentyp_zeichenkette:
            begin

              if versteckt then
                zahl_umformung_anfang(1,255,textz_Platzbedarf_fuer_die_Zeichenkette^)
              else (* 0 ist gut um eine Seite ohne "Ñnderbare" Variablen zu haben *)
                zahl_umformung_anfang(0,80-x_position,textz_Platzbedarf_fuer_die_Zeichenkette^);

              anzahl_einstellungen:=zahl;
              zeilenanfang_abtrennen;

            end; (* variablentyp_zeichenkette *)

          variablentyp_drehfeld:
            begin (* "Wert 1"+"Wert 2"+"Wert 3" "Wert 2" *)
                  (* oder LIKE Andere_Drefeld_Variable *)

              anzahl_einstellungen:=0;

              GetMem(drehfeld_speicher,1);
              drehfeld_speicher^.weite:=0; (* grî·te LÑnge ist noch unbekannt *)

              if (not anfang_ist_zeichenkette) and (anfang<>'') then
                begin
                  if (Pos(gross(anfang),'LIKE')=1)
                  or (Pos(gross(anfang),'WIE' )=1) then
                    begin
                      (* Variable suchen *)
                      zeilenanfang_abtrennen;
                      lies_drehfeldvariable(like);
                      (* Definition kopieren *)
                      drehfeld_speicher_laenge:=variablen_tabelle[like].drehfeld_speicher_laenge;
                      GetMem(drehfeld_speicher,drehfeld_speicher_laenge);
                      Move(variablen_tabelle[like].drehfeld_speicher^,drehfeld_speicher^,drehfeld_speicher_laenge);
                      anzahl_einstellungen:=variablen_tabelle[like].anzahl_einstellungen;
                    end
                  else
                  if UpCase(anfang[1])='L' then
                    begin
                      Delete(anfang,1,1);
                      zahl_umformung_anfang(1,80-x_position,textz_Platzbedarf_fuer_die_Zeichenkette^);
                      drehfeld_speicher^.weite:=-zahl;
                      zeilenanfang_abtrennen;
                    end
                  else
                  if UpCase(anfang[1])='R' then
                    begin
                      Delete(anfang,1,1);
                      zahl_umformung_anfang(1,80-x_position,textz_Platzbedarf_fuer_die_Zeichenkette^);
                      drehfeld_speicher^.weite:=+zahl;
                      zeilenanfang_abtrennen;
                    end;
                end;



              if anzahl_einstellungen=0 then
                begin

                  Inc(drehfeld_speicher_laenge);

                  repeat

                    with drehfeld_speicher^ do
                      if Abs(weite)<Length(anfang) then
                        begin
                          if weite<0 then
                            weite:=-Length(anfang)
                          else
                            weite:=+Length(anfang);
                        end;

                    dazu:=1+Length(anfang);
                    ReallocMem(drehfeld_speicher,drehfeld_speicher_laenge+dazu);

                    with drehfeld_speicher^ do
                      begin
                        elemente[drehfeld_speicher_laenge]:=Length(anfang);
                        Inc(drehfeld_speicher_laenge);
                        Move(anfang[1],elemente[drehfeld_speicher_laenge],dazu-1);
                        Inc(drehfeld_speicher_laenge,dazu-1);
                      end;

                    Inc(anzahl_einstellungen);

                    if Pos('+',zeile)<>1 then
                      begin
                        zeilenanfang_abtrennen;
                        Break
                      end;

                    Delete(zeile,1,Length('+'));
                    zeilenanfang_abtrennen;

                  until false;
                end;

            end; (* variablentyp_drehfeld *)


        else
          RunError_99;
        end;


        (* Standardwert ********************************************)

        case variablentyp of
          variablentyp_zahl: (* zahl / boolean *)

            if (anfang='') and (versteckt) then
              begin
                aktuelle_einstellung:=1;
              end
            else
              begin
                if anzahl_einstellungen=1 then
                  zahl_oder_boolean__umformung_anfang(0,1,textz_Standardwert_boolean_oder_0_1_^)
                else
                if versteckt then
                  zahl_umformung_anfang(0,anzahl_einstellungen,textz_Standardwert^)
                else
                  zahl_umformung_anfang(1,anzahl_einstellungen,textz_Standardwert^);
                aktuelle_einstellung:=zahl;
                zeilenanfang_abtrennen;
              end;

          variablentyp_zeichenkette:
            begin
              if (anfang='') and (versteckt) then
                platz_fuer_zeichenkette:=''
              else
                begin
                  platz_fuer_zeichenkette:=anfang;
                  zeilenanfang_abtrennen;
                end;
            end;

          variablentyp_drehfeld:
            begin
              aktuelle_einstellung:=0;
              i:=1;
              with drehfeld_speicher^ do
                for z1:=1 to anzahl_einstellungen do
                  if string_z(@elemente[i])^=anfang then
                    begin
                      aktuelle_einstellung:=z1;
                      Break;
                    end
                  else
                    Inc(i,1+elemente[i]);

              (* keine Zeichenkette hat gestimmt -> Versuche es als Zahlenwerte *)
              if aktuelle_einstellung=0 then
                begin
                  zahl_umformung_anfang(1,anzahl_einstellungen,textz_Standardwert__Elementnummer_oder_Elementkonstante^);
                  aktuelle_einstellung:=zahl;
                end;

              zeilenanfang_abtrennen;

              if x_position+Abs(drehfeld_speicher^.weite)+2>80+1 then
                begin
                  WriteLn(textz_geht_ueber_eine_Bildschirmzeile_hinaus^);
                  schreibe_org_zeile;
                  fehler_ende_99;
                end;

            end;

        else
          RunError_99;
        end;

        (* Sprungtaste *)
        if (Length(anfang)=1) and (not versteckt) then
          begin
            sprung_taste:=anfang[1];
            zeilenanfang_abtrennen;

            if sprung_taste in ['+','-','0'..'9'] then
              begin
                WriteLn(textz_sprungtaste_ist_reserviert^,sprung_taste);
                schreibe_org_zeile;
                fehler_ende_99;
              end;

            for z1:=1 to variablen_zaehler-1 do
              if sprung_taste=variablen_tabelle[z1].sprung_taste then
                begin
                  WriteLn(textz_doppelte_benutzung_der_sprungtaste^,sprung_taste);
                  Writeln(variablen_name,' ',variablen_tabelle[z1].variablen_name);
                  fehler_ende_99;
                end;

          end
        else
          sprung_taste:=#0;

        (* Lîschtyp *)
        if (anfang<>'') then
          begin

            if (variablentyp=variablentyp_drehfeld) and uebereinstimmung_anfang('COMPRESS_TO_STRING','PACKE_ZU_ZEICHENKETTE') then
              begin
                zeilenanfang_abtrennen;
                loeschtyp:=variable_packen_zu_zeichenkette;
              end

            else
            if (variablentyp=variablentyp_drehfeld) and uebereinstimmung_anfang('COMPRESS_TO_INTEGER','PACKE_ZU_ZAHL') then
              begin
                zeilenanfang_abtrennen;
                loeschtyp:=variable_packen_zu_zahl;
              end

            else
            if uebereinstimmung_anfang('DELETE_AT_MENU_EXIT','LôSCHEN_NACH_DEM_MENö') then
              begin
                zeilenanfang_abtrennen;
                loeschtyp:=variable_loeschen;
              end

          end;


        if anfang<>'' then
          begin
            WriteLn(textz_kein_schluesselwort^);
            schreibe_org_zeile;
            fehler_ende_99;
          end;

      end; (* with *)
  end;

(***************************************************************************)

procedure lade_brane(const brane_dateiname:string);
  var
    b                   :text;
    s1,s2               :ShortString;
    w1                  :word;
    fehler              :word;
    p                   :^ShortString;
    steuerzeichen       :boolean;
  begin
    Write(textz_plus_Lade_^,brane_dateiname,' ');

    {FileMode}TextModeRead:=open_access_ReadOnly+open_share_DenyNone;
    Assign(b,brane_dateiname);
    {$I-}
    Reset(b);
    {$I+}
    fehler:=IOResult;
    if fehler<>0 then
      begin
        WriteLn(textz_Fehler__^,fehler,'!');
        fehler_ende(fehler);
      end;

    while not Eof(b) do
      begin
        ReadLn(b,zeile);
        org_zeile:=zeile;

        leerzeichen_und_tab_umwandeln(zeile);

        if zeile='' then Continue;
        if zeile[1] in [';','#'] then Continue;

        s1:='';
        s2:='';

        repeat

          zeilenanfang_abtrennen;
          if (not anfang_ist_zeichenkette) and uebereinstimmung_anfang('=','=') then
            Break;

          if anfang_ist_zeichenkette then
            s1:=s1+anfang (* \t,\n,.. igorieren, da alles Steuerzeichen *)
          else
            begin
              if Pos('x',anfang)=1 then anfang[1]:='$';
              zahl_umformung_anfang(0,255,textz_char_code_number^);
              s1:=s1+Chr(zahl);
            end;
        until false;

        if s1='' then
          begin
            WriteLn(textz_Zeichenkette_erwartet^);
            schreibe_org_zeile;
            fehler_ende_99;
          end;

        steuerzeichen:=false;
        for w1:=1 to Length(s1) do
          if s1[w1]<' ' then
            begin
              steuerzeichen:=true;
              Break;
            end;
        if steuerzeichen then
          begin
            WriteLn(textz_zeile_mit_steuerzeichen_ignoriert_^);
            schreibe_org_zeile;
            Continue;
          end;

        ueberlies('=','=');

        while anfang<>'' do
          begin
            if anfang_ist_zeichenkette then
              s2:=s2+anfang
            else
              begin
                if Pos('x',anfang)=1 then anfang[1]:='$';
                zahl_umformung_anfang(0,255,textz_char_code_number^);
                s2:=s2+Chr(zahl);
              end;
            zeilenanfang_abtrennen;
          end;

        steuerzeichen:=false;
        for w1:=1 to Length(s2) do
          if s2[w1]<' ' then
            begin
              steuerzeichen:=true;
              Break;
            end;
        if steuerzeichen then
          begin
            WriteLn(textz_zeile_mit_steuerzeichen_ignoriert_^);
            schreibe_org_zeile;
            Continue;
          end;


        Inc(brane_tabelle_belegt);
        if brane_tabelle_belegt>High(brane_tabelle) then
          begin
            WriteLn(textz_Brane_tabelle_voll^);
            schreibe_org_zeile;
            fehler_ende_99;
          end;

        GetMem(brane_tabelle[brane_tabelle_belegt],1+Length(s1)+1+Length(s2));
        brane_tabelle[brane_tabelle_belegt]^:=s1;
        p:=@brane_tabelle[brane_tabelle_belegt]^[Length(s1)+1];
        p^:=s2;
      end;

    Close(b);
    WriteLn;
  end;

procedure lade_menu_bin(const menu_bin0:string;const zeilen:word;const standardverzeichnis:string);
  var
    d                   :file;
    fehler              :word;
    laenge_menu_bin     :longint;
    menu_bin            :string;
  begin

    suche_datei(menu_bin,standardverzeichnis,menu_bin0,true);
    if menu_bin='' then
      begin
        Write(textz_plus_Lade_^,menu_bin0,' ');
        WriteLn(textz_Kann_Datei_x_nicht_finden_1^,menu_bin0,textz_Kann_Datei_x_nicht_finden_2^);
        fehler_ende_99;
      end
    else
      Write(textz_plus_Lade_^,menu_bin,' ');

    FileMode:=open_access_ReadOnly+open_share_DenyNone;
    Assign(d,menu_bin);
    {$I-}
    Reset(d,1);
    {$I+}
    fehler:=IOResult;
    if fehler<>0 then
      begin
        WriteLn(textz_Fehler__^,fehler,'!');
        fehler_ende(fehler);
      end;

    laenge_menu_bin:=FileSize(d);

    if seiten_zeilenzahl=0 then (* wird nur beim ersten mal beachtet *)
      begin
        if zeilen=0 then (* nicht angegeben, aus der DateilÑnge erraten *)
          case laenge_menu_bin of
            25*80*2:seiten_zeilenzahl:=25;
            28*80*2:seiten_zeilenzahl:=28;
            50*80*2:seiten_zeilenzahl:=50;
          else
                    seiten_zeilenzahl:=99;
          end
        else (* Zeilen angegeben *)
          seiten_zeilenzahl:=zeilen;
      end;

    if not (seiten_zeilenzahl in [25,28,50]) then
      begin
        WriteLn(anfang,textz__sollte_25_28_oder_50_Zeilen_gross_sein__^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    laenge_menu_bin:=80*seiten_zeilenzahl*2;
    FillChar(seiten_hintergruende[seiten_anzahl],SizeOf(seiten_hintergruende[seiten_anzahl]),0);
    BlockRead(d,seiten_hintergruende[seiten_anzahl],laenge_menu_bin);
    Close(d);

    WriteLn;
  end;

procedure lade_extra_bin(const menu_bin0:string;const zeilen:word;const standardverzeichnis:string;var p);
  var
    d                   :file;
    fehler              :word;
    laenge_menu_bin     :longint;
    menu_bin            :string;
  begin

    suche_datei(menu_bin,standardverzeichnis,menu_bin0,true);
    if menu_bin='' then
      begin
        Write(textz_plus_Lade_^,menu_bin0,' ');
        WriteLn(textz_Kann_Datei_x_nicht_finden_1^,menu_bin0,textz_Kann_Datei_x_nicht_finden_2^);
        fehler_ende_99;
      end
    else
      Write(textz_plus_Lade_^,menu_bin,' ');

    FileMode:=open_access_ReadOnly+open_share_DenyNone;
    Assign(d,menu_bin);
    {$I-}
    Reset(d,1);
    {$I+}
    fehler:=IOResult;
    if fehler<>0 then
      begin
        WriteLn(textz_Fehler__^,fehler,'!');
        fehler_ende(fehler);
      end;

    laenge_menu_bin:=FileSize(d);

    if not (seiten_zeilenzahl in [25,28,50]) then
      begin
        WriteLn(anfang,textz__sollte_25_28_oder_50_Zeilen_gross_sein__^);
        schreibe_org_zeile;
        fehler_ende_99;
      end;

    laenge_menu_bin:=80*seiten_zeilenzahl*2;
    FillChar(p,SizeOf(seiten_hintergruende[seiten_anzahl]),0);
    BlockRead(d,p,laenge_menu_bin);
    Close(d);

    WriteLn;
  end;

(*******************************************************************)

procedure lade_menu_txt(const standardverzeichnis:string);
  const
    max_include         =10;
  var
    d                   :array[0..max_include] of text;
    fehler              :word;
    z                   :word;
    anzahl_sichbar      :word;
    menu_bin_dateiname  :string;
    nachfolgezeile,
    org_nachfolgezeile  :ansistring;
    menu_txt            :array[0..max_include] of string;
    include_tiefe       :word;
    brane_dateiname     :string;
    {$IfDef Debug}
    log                 :text;
    {$EndIf Debug}

  procedure lade_menu_txt_status;
    begin
      Write(textz_plus_Lade_^,menu_txt[include_tiefe],' (',seiten_anzahl,')... ');
    end;

  procedure brane(var z:ansistring);
    var
      i                 :word;
      f1                :word;
    begin
      for i:=1 to brane_tabelle_belegt do
        begin
          f1:=Pos(brane_tabelle[i]^,z);
          if f1<>0 then
            begin
              Delete(z,f1,Length(brane_tabelle[i]^));
              Insert(string_z(@brane_tabelle[i]^[Length(brane_tabelle[i]^)+1])^,z,f1);
            end;
        end;

      {$IfDef Debug}
      WriteLn(log,z);
      Flush(log);
      {$EndIf Debug}

    end;

  begin
    {$IfDef Debug}
    Assign(log,'M:\brane.log');
    ReWrite(log);
    {$EndIf Debug}
    include_tiefe:=0;
    suche_datei(menu_txt[include_tiefe],standardverzeichnis,'menu.txt',true);
    if menu_txt[include_tiefe]='' then
      menu_txt[include_tiefe]:='menu.txt';

    lade_menu_txt_status;

    {FileMode}TextModeRead:=open_access_ReadOnly+open_share_DenyNone;
    Assign(d[include_tiefe],menu_txt[include_tiefe]);
    {$I-}
    Reset(d[include_tiefe]);
    {$I+}

    fehler:=IOResult;
    if fehler<>0 then
      begin
        WriteLn(textz_Fehler__^,fehler,'!');
        fehler_ende(fehler);
      end;

    repeat

      while (include_tiefe>0) and Eof(d[include_tiefe]) do
        begin
          Close(d[include_tiefe]);
          Dec(include_tiefe);
          WriteLn;
          lade_menu_txt_status;
        end;

      if (include_tiefe=0) and Eof(d[include_tiefe]) then
        begin
          Close(d[include_tiefe]);
          Break;
        end;

      ReadLn(d[include_tiefe],zeile);
      org_zeile:=zeile;
      brane(zeile);

      leerzeichen_und_tab_umwandeln(zeile);


      if (zeile<>'') and (Pos('#',zeile)<>1) then
        begin


          while Copy(zeile,Length(zeile),1)='~' do
            begin
              ReadLn(d[include_tiefe],nachfolgezeile);
              org_nachfolgezeile:=nachfolgezeile;
              brane(nachfolgezeile);


              leerzeichen_und_tab_umwandeln(nachfolgezeile);

              if (nachfolgezeile<>'') and (Pos('#',nachfolgezeile)<>1) then
                begin
                  zeile:=Copy(zeile,1,Length(zeile)-1)+nachfolgezeile;
                  org_zeile:=org_zeile+org_nachfolgezeile;
                end;

            end;

          (* VARIABLE NAME *)
          zeilenanfang_abtrennen;

          if uebereinstimmung_anfang('INCLUDE','EINBINDEN') then
            begin
              zeilenanfang_abtrennen;
              if include_tiefe=max_include then
                begin
                  WriteLn(textz_include_Tiefe_zu_hoch^);
                  schreibe_org_zeile;
                  fehler_ende_99;
                end;

              WriteLn;
              Inc(include_tiefe);

              suche_datei(menu_txt[include_tiefe],standardverzeichnis,anfang,true);
              if menu_txt[include_tiefe]='' then
                menu_txt[include_tiefe]:=anfang;
              zeilenanfang_abtrennen;


              lade_menu_txt_status;

              {FileMode}TextModeRead:=open_access_ReadOnly+open_share_DenyNone;
              Assign(d[include_tiefe],menu_txt[include_tiefe]);
              {$I-}
              Reset(d[include_tiefe]);
              {$I+}
              fehler:=IOResult;
              if fehler<>0 then
                begin
                  WriteLn(textz_Fehler__^,fehler,'!');
                  fehler_ende(fehler);
                end;
            end
          else if uebereinstimmung_anfang('BRANE','BRANEFILE') then
            begin
              zeilenanfang_abtrennen;
              WriteLn;

              suche_datei(brane_dateiname,standardverzeichnis,anfang,true);
              if brane_dateiname='' then
                brane_dateiname:=anfang;
              zeilenanfang_abtrennen;

              lade_brane(brane_dateiname);

              lade_menu_txt_status;
            end
          else if uebereinstimmung_anfang('TIMELIMIT','ZEITGRENZE') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(0,1000,textz_Zeitgrenze^);
              zeitgrenze:=(zahl*19663) div 1080; (* 1/18,2 *)
              if zeitgrenze=0 then
                zeitgrenze:=zeitgrenze_12_Stunden;
            end
          else if uebereinstimmung_anfang('MENU_ACCEPT_SCANCODE','MENU_EINGABETASTE_TK') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,$ffff,textz_EingabetasteSC^);
              eingabetaste_sc:=zahl;
            end
          else if uebereinstimmung_anfang('MENU_CANCEL_SCANCODE','MENU_ABBRUCH_TK') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,$ffff,textz_AbbruchSC^);
              cancel_sc:=zahl;
            end
          else if uebereinstimmung_anfang('MENU_RESET_SCANCODE','MENU_ANFANGSWERTE_TK') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,$ffff,textz_ResetSC^);
              reset_sc:=zahl;
            end
          else if uebereinstimmung_anfang('MENU_VIEWBIOSSCREEN_SCANCODE','MENU_BIOSBILDSCHIRM_TK') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,$ffff,textz_AltF5SC^);
              altf5_sc:=zahl;
            end
          else if uebereinstimmung_anfang('MENU_HELP_SCANCODE','MENU_HILFE_TK') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,$ffff,textz_HelpSC^);
              altf5_sc:=zahl;
            end

          else if uebereinstimmung_anfang('MENU_HELP_SOURCEFILE','MENU_HILFE_QUELLTEXT') then
            begin
              zeilenanfang_abtrennen;
              if anfang<>'' then
                menu_hlp_txt_name:=anfang;
            end

          else if uebereinstimmung_anfang('A_CONFIG_SYS','B_CONFIG_SYS') then
            begin
              WriteLn(textz_AB_CONFIG_SYS_veraltet1^);
              WriteLn(textz_AB_CONFIG_SYS_veraltet2^);
            end
          else if uebereinstimmung_anfang('MENU_BIN','MENU_BIN') then
            begin
              zeilenanfang_abtrennen;

              Inc(seiten_anzahl);

              if seiten_anzahl>High(seiten_hintergruende) then
                begin
                  WriteLn(textz_zu_viele_Seiten_^);
                  schreibe_org_zeile;
                  fehler_ende_99;
                end;

              menu_bin_dateiname:=anfang;
              zeilenanfang_abtrennen;

              if anfang<>'' then
                begin
                  zahl_umformung_anfang(25,50,textz_Zeilenzahl^);
                  if not (zahl in [25,28,50]) then
                    begin
                      WriteLn(textz_nicht252850^);
                      schreibe_org_zeile;
                      fehler_ende_99;
                    end;
                end
              else
                zahl:=0;

              WriteLn;
              lade_menu_bin(menu_bin_dateiname,zahl,standardverzeichnis);

              lade_menu_txt_status;

            end

          else if uebereinstimmung_anfang('MENU_CONFIRM_BIN','MENU_CONFIRM_BIN') then
            begin
              if seiten_anzahl=0 then
                begin
                  WriteLn(textz_Use__MENU_BIN__first^);
                  schreibe_org_zeile;
                  fehler_ende_99;
                end;

              zeilenanfang_abtrennen;
              menu_bin_dateiname:=anfang;
              WriteLn;
              lade_extra_bin(menu_bin_dateiname,seiten_zeilenzahl,standardverzeichnis,weiter_seite);
              weiter_seite_benutzt:=true;
              lade_menu_txt_status;
            end
          else if uebereinstimmung_anfang('MENU_CANCEL_BIN','MENU_CANCEL_BIN') then
            begin
              if seiten_anzahl=0 then
                begin
                  WriteLn(textz_Use__MENU_BIN__first^);
                  schreibe_org_zeile;
                  fehler_ende_99;
                end;

              zeilenanfang_abtrennen;
              menu_bin_dateiname:=anfang;
              WriteLn;
              lade_extra_bin(menu_bin_dateiname,seiten_zeilenzahl,standardverzeichnis,abbruch_seite);
              abbruch_seite_benutzt:=true;
              lade_menu_txt_status;
            end
          else if uebereinstimmung_anfang('MENU_RESET_BIN','MENU_RESET_BIN') then
            begin
              if seiten_anzahl=0 then
                begin
                  WriteLn(textz_Use__MENU_BIN__first^);
                  schreibe_org_zeile;
                  fehler_ende_99;
                end;

              zeilenanfang_abtrennen;
              menu_bin_dateiname:=anfang;
              WriteLn;
              lade_extra_bin(menu_bin_dateiname,seiten_zeilenzahl,standardverzeichnis,reset_seite);
              reset_seite_benutzt:=true;
              lade_menu_txt_status;
            end

          else if uebereinstimmung_anfang('MENU_CONFIRM_YES_SCANCODE','MENU_CONFIRM_YES_SCANCODE') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,$ffff,textz_MENU_CONFIRM_YES_sc^);
              weiter_seite_ja_sc:=zahl;
            end
          else if uebereinstimmung_anfang('MENU_CONFIRM_NO_SCANCODE','MENU_CONFIRM_NO_SCANCODE') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,$ffff,textz_MENU_CONFIRM_NO_sc^);
              weiter_seite_nein_sc:=zahl;
            end
          else if uebereinstimmung_anfang('MENU_CANCEL_YES_SCANCODE','MENU_CANCEL_YES_SCANCODE') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,$ffff,textz_MENU_CANCEL_YES_sc^);
              abbruch_seite_ja_sc:=zahl;
            end
          else if uebereinstimmung_anfang('MENU_CANCEL_NO_SCANCODE','MENU_CANCEL_NO_SCANCODE') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,$ffff,textz_MENU_CANCEL_NO_sc^);
              abbruch_seite_nein_sc:=zahl;
            end
          else if uebereinstimmung_anfang('MENU_RESET_YES_SCANCODE','MENU_RESET_YES_SCANCODE') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,$ffff,textz_MENU_RESET_YES_sc^);
              reset_seite_ja_sc:=zahl;
            end
          else if uebereinstimmung_anfang('MENU_RESET_NO_SCANCODE','MENU_RESET_NO_SCANCODE') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,$ffff,textz_MENU_RESET_NO_sc^);
              reset_seite_nein_sc:=zahl;
            end

          else if uebereinstimmung_anfang('RGB','RGB') then
            begin
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(0,15,'0..15');
              with menu_palette[zahl] do
                begin
                  zeilenanfang_abtrennen;
                  zahl_umformung_anfang(0,255,textz_ROT^);
                  r:=zahl;
                  zeilenanfang_abtrennen;
                  zahl_umformung_anfang(0,255,textz_GRUEN^);
                  g:=zahl;
                  zeilenanfang_abtrennen;
                  zahl_umformung_anfang(0,255,textz_BLAU^);
                  b:=zahl;
                  zeilenanfang_abtrennen;
                end;
              menu_palette_benutzen:=true;
            end
          else if uebereinstimmung_anfang('QUICKKEY','SCHNELLTASTE') then
            begin
              (* 1,2,..,9,0 *)
              zeilenanfang_abtrennen;
              zahl_umformung_anfang(1,10,textz_Schnelltaste_1_bis_10^);
              menu_nummer:=zahl;

              while zeile<>'' do
                begin
                  (* "HPFS=2" *)
                  zeilenanfang_abtrennen_mit_trenzeichen('=');
                  schnellmenu_eintrag(menu_nummer);
                end;

            end
          else if uebereinstimmung_anfang('STATEMENT','ANWEISUNG') then
            begin
              zeilenanfang_abtrennen;
              entschluessele_anweisung(anweisung_normal);
            end
          else if uebereinstimmung_anfang('BEGINSTATEMENT','ANFANGSANWEISUNG') then
            begin
              zeilenanfang_abtrennen;
              entschluessele_anweisung(anweisung_anfang);
            end
          else if uebereinstimmung_anfang('ENDSTATEMENT','ENDEANWEISUNG') then
            begin
              zeilenanfang_abtrennen;
              entschluessele_anweisung(anweisung_ende);
            end

          else if uebereinstimmung_anfang('VAR','VARIABLE') then
            begin
              zeilenanfang_abtrennen;
              lies_variable(variablentyp_zahl,false,'');
            end
          else if uebereinstimmung_anfang('BOOLEAN','BOOL') then
            begin
              zeilenanfang_abtrennen;
              lies_variable(variablentyp_zahl,false,'B');
            end
          else if uebereinstimmung_anfang('HIDDEN','UNSICHTBAR') then
            begin

              zeilenanfang_abtrennen;
              if uebereinstimmung_anfang('STRING','ZEICHENKETTE') then
                begin (* hidden string *)
                  zeilenanfang_abtrennen;
                  lies_variable(variablentyp_zeichenkette,true,'');
                end
              else if uebereinstimmung_anfang('SPINBUTTON','DREHFELD') then
                begin (* hidden spinbutton *)
                  zeilenanfang_abtrennen;
                  lies_variable(variablentyp_drehfeld,true,'');
                end
              else if uebereinstimmung_anfang('VAR','VARIABLE') then
                begin (* hidden integer *)
                  zeilenanfang_abtrennen;
                  lies_variable(variablentyp_zahl,true,'');
                end
              else if uebereinstimmung_anfang('BOOLEAN','BOOL') then
                begin (* hidden boolean *)
                  zeilenanfang_abtrennen;
                  lies_variable(variablentyp_zahl,true,'B');
                end
              else (* hidden integer *)
                lies_variable(variablentyp_zahl,true,'');

            end
          else if uebereinstimmung_anfang('STRING','ZEICHENKETTE') then
            begin
              zeilenanfang_abtrennen;
              lies_variable(variablentyp_zeichenkette,false,'');
            end
          else if uebereinstimmung_anfang('SPINBUTTON','DREHFELD') then
            begin
              zeilenanfang_abtrennen;
              lies_variable(variablentyp_drehfeld,false,'');
            end
          else
            begin
              lies_variable(variablentyp_zahl,false,'');
            end;

        end;

    until false; (* Eof(f[0]) *)

    {$IfDef Debug}
    Close(log);
    {$EndIf Debug}


    if variablen_zaehler=0 then
      begin
        WriteLn(textz_keine_variablen_definiert^);
        fehler_ende_99;
      end;

    anzahl_sichbar:=0;
    for z:=1 to variablen_zaehler do
      if variablen_tabelle[z].seitennummer<>0 then
        Inc(anzahl_sichbar);

    if anzahl_sichbar=0 then
      begin
        WriteLn(textz_Keine_sichtbaren_Variablen_definiert__^);
        fehler_ende_99;
      end;


    WriteLn;

  end;

(*******************************************************************)


procedure lade_os2ldr(const config_sys_verzeichnis:string);
  var
    os2ldr_name,
    os2ldr_bin_name     :string;

    i                   :word;

  const
    kennung             ='[OS2CSM]';

  procedure lade_os2ldr1(const dateiname                :string;
                         var   voller_dateiname         :string;
                         var   dateilaenge              :longint;
                         var   p                        :os2ldr_puffer_typ;
                         var   dateizeit                :longint;
                         const dateisuche_zulaessig     :boolean);
    var
      d                 :file;
      fehler            :word;

    begin
      FillChar(p,SizeOf(p),0);
      dateilaenge:=-1;
      dateizeit:=0;

      suche_datei(voller_dateiname,config_sys_verzeichnis,dateiname,dateisuche_zulaessig);

      if voller_dateiname='' then
        begin
          WriteLn(textz_plus_Lade_^,dateiname,' - ',textz_nicht_gefunden__^);
          Exit;
        end;


      Write(textz_plus_Lade_^,voller_dateiname,' ');

      voller_dateiname:=FExpand(voller_dateiname);

      FileMode:=open_access_ReadOnly+open_share_DenyNone;
      Assign(d,voller_dateiname);
      {$I-}
      Reset(d,1);
      {$I+}
      fehler:=IOResult;
      if fehler<>0 then
        begin
          WriteLn(textz_Fehler__^,fehler,'!');
          fehler_ende(fehler);
        end;

      GetFTime(d,dateizeit);
      if Dos.DosError<>0 then
        dateizeit:=0;

      dateilaenge:=FileSize(d);
      if dateilaenge>SizeOf(p) then
        begin
          WriteLn(textz_Datei_zu_lang__^,dateilaenge,')!');
          fehler_ende(1);
        end;

      Write(dateilaenge,' ');

      BlockRead(d,p,dateilaenge);
      Close(d);
    end;


  begin

    lade_os2ldr1('os2ldr'    ,os2ldr_name    ,os2ldr_laenge    ,os2ldr_puffer    ,os2ldr_datumzeit    ,true);
    if os2ldr_laenge<=0 then
      begin
        WriteLn;
        fehler_ende_99;
      end;

    WriteLn;
    lade_os2ldr1('os2ldr.bin',os2ldr_bin_name,os2ldr_bin_laenge,os2ldr_bin_puffer,os2ldr_bin_datumzeit,false);


    (* zum spÑteren Vergleich merken *)
    if gross(os2ldr_name)=gross(FExpand(config_sys_verzeichnis+'OS2LDR')) then
      begin
        org_os2ldr_laenge:=os2ldr_laenge;
        Move(os2ldr_puffer,org_os2ldr_puffer,org_os2ldr_laenge);
      end
    else
      begin
        org_os2ldr_laenge:=-1;
        os2ldr_datumzeit:=0;
      end;

    if  (gross(os2ldr_bin_name)=gross(FExpand(config_sys_verzeichnis+'os2ldr.bin')))
    and (os2ldr_laenge>=0) then
      begin
        org_os2ldr_bin_laenge:=os2ldr_bin_laenge;
        Move(os2ldr_bin_puffer,org_os2ldr_bin_puffer,org_os2ldr_bin_laenge);
      end
    else
      begin
        org_os2ldr_bin_laenge:=-1;
        os2ldr_bin_datumzeit:=0;
      end;


    (* auf os2csm prÅfen *)
    i:=0;
    repeat
      Inc(i);
      if StrLComp(@os2ldr_puffer[i],kennung,Length(kennung))=0 then Break;
    until i>=20;


    if i<20 then (* gefunden - os2ldr.bin notwendig *)
      begin
        if os2ldr_bin_laenge<=0 then fehler_ende_99;

        os2ldr_laenge:=os2ldr_bin_laenge;
        Move(os2ldr_bin_puffer,os2ldr_puffer,os2ldr_laenge);
        os2ldr_datumzeit:=os2ldr_bin_datumzeit;
      end;
    (* sonst ist os2ldr_puffer schon gereinigt *)

    WriteLn;
  end;

(*******************************************************************)

{$I help.pas}

(*******************************************************************)

procedure menu_ausfueren;
  type
    zeichen_attr=
      record
        zeichen         :char;
        attribut        :byte;
      end;

  const
    //falsch_wahr_zeichen         :array[false..true] of char=('˘' ,'˚' );
    //falsch_wahr_zeichen_gewaehlt:array[false..true] of char=(#$07,'˚' );
    falsch_wahr_zeichen         :array[false..true] of char=(' ' ,'˚' );
    falsch_wahr_zeichen_gewaehlt:array[false..true] of char=('_' ,'˚' );
    ausgewaehlt_zeichen         :array[false..true] of char=(' ' ,#$10);
    drehfeld_zeichen1           :                      char= #$12;
    leer_feld                   :                      char= ' ' ;

  var
    spalten,
    zeilen,
    farben              :word;
    p,a                 :^zeichen_attr;
    x,y                 :word;
    cx,cy               :smallword;
    c1,c2               :integer;
    cv                  :boolean;

    z,z2                :word;
    attr                :byte;
    zeichen             :char;
    variablenposition   :word;
    taste               :word;

    gueltige_bedingung  :boolean;
    codeseite           :smallword;
    editor_position     :word;
    zeichenkette        :^string;
    dargestellte_seite  :byte;
    vollstaendig_neuzeichnen:boolean;

    tmpzk               :string;
    i                   :word;

    gefunden            :boolean;
    sicherung           :integer;
    drehfeldabstand     :word;
    drehfeldabstand_var :integer;

    os2csm_accept_menu  :boolean;

    {$IfDef Os2}
    ega_state           :VioPalState;
    rgb_state           :VioColorReg;
    pal,pal0            :packed array[0..255] of packed record rr,gg,bb:byte end;
    {$EndIf Os2}

    abbruch             :boolean;

  const
    ega:array[0..15] of byte=(0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);

  procedure suche_naechste_sichtbare_variable(richtung:word);
    begin

      repeat
        Inc(variablenposition,richtung);
        if richtung=0 then
          richtung:=1;
        if variablenposition=0 then
          variablenposition:=variablen_zaehler
        else if variablenposition>variablen_zaehler then
          variablenposition:=1;
      until variablen_tabelle[variablenposition].seitennummer<>0;

      if dargestellte_seite<>variablen_tabelle[variablenposition].seitennummer then
        begin
          vollstaendig_neuzeichnen:=true;
          dargestellte_seite:=variablen_tabelle[variablenposition].seitennummer;
        end;

      editor_position:=0;
    end;

  procedure passe_variable_an_seite_an(richtung:word);
    var
      variablenposition_sicherung,
      alt,z             :word;
    begin
      variablenposition_sicherung:=variablenposition;
      alt:=variablen_tabelle[variablenposition].seitennummer;

      for z:=1 to variablen_zaehler do
        if alt=variablen_tabelle[variablenposition].seitennummer then
          suche_naechste_sichtbare_variable(richtung)
        else
          Break;

      if alt=variablen_tabelle[variablenposition].seitennummer then
        variablenposition:=variablenposition_sicherung;
    end;

  procedure berechnungen(jetzt_zustand:byte);
    var
      z,z2              :word;
      ergebnis          :integer;
      ergebnis_zk       :string;
      kontrolle         :integer;
      sn,i              :word;
    begin
      (* Berechnungen *)
      for z:=Low(formel_tabelle) to High(formel_tabelle) do
        with formel_tabelle[z] do
          if (zustand_anwendbar=anweisung_normal) or (zustand_anwendbar=jetzt_zustand) then
            begin
              case if_teil of
                $00:Break;
                $04:gueltige_bedingung:=(    liefere_wert_aus_zahlenvariable_oder_wert(var_if_1)
                                         and liefere_wert_aus_zahlenvariable_oder_wert(var_if_2))<>0;
                $05:gueltige_bedingung:=(    liefere_wert_aus_zahlenvariable_oder_wert(var_if_1)
                                         or  liefere_wert_aus_zahlenvariable_oder_wert(var_if_2))<>0;
                $06:gueltige_bedingung:=(    liefere_wert_aus_zahlenvariable_oder_wert(var_if_1)
                                         =   liefere_wert_aus_zahlenvariable_oder_wert(var_if_2));
                $07:gueltige_bedingung:=(    liefere_wert_aus_zahlenvariable_oder_wert(var_if_1)
                                         <   liefere_wert_aus_zahlenvariable_oder_wert(var_if_2));
                $09:gueltige_bedingung:=(    liefere_wert_aus_zahlenvariable_oder_wert(var_if_1)
                                         <=  liefere_wert_aus_zahlenvariable_oder_wert(var_if_2));
                $0b:gueltige_bedingung:=(    liefere_wert_aus_zahlenvariable_oder_wert(var_if_1)
                                         <>  liefere_wert_aus_zahlenvariable_oder_wert(var_if_2));

                $0c:gueltige_bedingung:=(    liefere_zeichenkette(var_if_1)
                                         =   liefere_zeichenkette(var_if_2));
                $0d:gueltige_bedingung:=(    liefere_zeichenkette(var_if_1)
                                         <>  liefere_zeichenkette(var_if_2));
              else
                RunError_99;
              end;

              if gueltige_bedingung then
                begin
                  case verknuepfung of
                    $02:ergebnis:=(    liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2)
                                   and liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3));
                    $03:ergebnis:=(    liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2)
                                   or  liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3));
                    $04:ergebnis:=(    liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2)
                                   xor liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3));
                    $05:ergebnis:=(    liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2)
                                   +   liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3));
                    $06:ergebnis:=(    liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2)
                                   -   liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3));
                    $07:ergebnis:=Ord( liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2)
                                  =    liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3));
                    $08:ergebnis:=Ord( liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2)
                                  <    liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3));
                    $0a:ergebnis:=Ord( liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2)
                                  <=   liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3));
                    $0c:ergebnis:=Ord( liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2)
                                  <>   liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3));

                    STR_APPEND:
                      begin
                        (* STR_APPEND(VAR STR1;CONST STR2) *)
                        ergebnis_zk:=liefere_zeichenkette(var_verkn_1)+liefere_zeichenkette(var_verkn_2);
                        speicher_string_variable(var_verkn_1,ergebnis_zk);
                      end;

                    STR_COMP:
                      begin
                        (* STR_COMP(CONST STR1,STR2;VAR BOOLEAN3) *)
                        variablen_tabelle[var_verkn_3].aktuelle_einstellung:=
                          Ord(liefere_zeichenkette(var_verkn_1)=liefere_zeichenkette(var_verkn_2));
                      end;

                    STR_DELETE:
                      begin
                        (* STR_DELETE(VAR STR1;CONST INT2,INT3) *)
                        ergebnis_zk:=liefere_zeichenkette(var_verkn_1);
                        Delete(ergebnis_zk,
                               liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2),
                               liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3));
                        speicher_string_variable(var_verkn_1,ergebnis_zk);
                      end;

                    STR_INSERT:
                      begin
                        (* STR_INSERT(CONST STR1;VAR STR2;CONST INT3) *)
                        ergebnis_zk:=liefere_zeichenkette(var_verkn_2);
                        Insert(liefere_zeichenkette(var_verkn_1),
                               ergebnis_zk,
                               liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3));
                        speicher_string_variable(var_verkn_2,ergebnis_zk);
                      end;

                    STR_LENGTH:
                      begin
                        (* STR_LENGTH(CONST STR1;VAR INT2) *)
                        variablen_tabelle[var_verkn_2].aktuelle_einstellung:=
                          Length(liefere_zeichenkette(var_verkn_1));
                      end;

                    STR_CONCAT:
                      begin
                        (* STR_CONCAT(CONST STR1,STR2;VAR STR3) *)
                        ergebnis_zk:=liefere_zeichenkette(var_verkn_1)
                                    +liefere_zeichenkette(var_verkn_2);
                        speicher_string_variable(var_verkn_3,ergebnis_zk);
                      end;

                    STR_TRIM:
                      begin
                        (* STR_TRIM(CONST STR1;VAR STR2) *)
                        ergebnis_zk:=liefere_zeichenkette(var_verkn_1);

                        while (ergebnis_zk<>'') and (ergebnis_zk[1]=' ') do
                          Delete(ergebnis_zk,1,1);
                        while (ergebnis_zk<>'') and (ergebnis_zk[Length(ergebnis_zk)]=' ') do
                          Delete(ergebnis_zk,Length(ergebnis_zk),1);

                        speicher_string_variable(var_verkn_2,ergebnis_zk);
                      end;

                    STR_COPY:
                      begin
                        (* STR_COPY(CONST STR1;CONST INT2,INT3;VAR STR4) *)
                        speicher_string_variable(var_verkn_4,
                          Copy(liefere_zeichenkette(var_verkn_1),
                               liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2),
                               liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3)));
                      end;

                    STR_UPCASE:
                      begin
                        (* STR_UPCASE(CONST STR1;VAR STR2) *)
                        speicher_string_variable(var_verkn_2,
                          gross(liefere_zeichenkette(var_verkn_1)));
                      end;

                    STR_VAL:
                      begin
                        (* STR_VAL(CONST STR1;VAR INT2) *)
                        with variablen_tabelle[var_verkn_2] do
                          case variablentyp of
                            variablentyp_zahl:

                              if anzahl_einstellungen=1 then
                                begin
                                  ergebnis_zk:=gross(liefere_zeichenkette(var_verkn_1));
                                  if (ergebnis_zk='FALSE') or (ergebnis_zk='FALSCH') then aktuelle_einstellung:=0
                                  else
                                  if (ergebnis_zk='TRUE' ) or (ergebnis_zk='WAHR'  ) then aktuelle_einstellung:=1
                                  else
                                    begin
                                      Val(liefere_zeichenkette(var_verkn_1),ergebnis,kontrolle);
                                      if (kontrolle=0) and ((ergebnis=0) or (ergebnis=1)) then
                                        aktuelle_einstellung:=ergebnis;
                                    end;
                                end
                              else
                                begin
                                  Val(liefere_zeichenkette(var_verkn_1),ergebnis,kontrolle);
                                  if (kontrolle=0) and (ergebnis>=1) and (ergebnis<=anzahl_einstellungen) then
                                    aktuelle_einstellung:=ergebnis;
                                end;

                            variablentyp_zeichenkette:
                              RunError_99;

                            variablentyp_drehfeld:
                              begin
                                ergebnis_zk:=liefere_zeichenkette(var_verkn_1);
                                kontrolle:=0;
                                ergebnis:=0;
                                i:=1;
                                with drehfeld_speicher^ do
                                  for z2:=1 to anzahl_einstellungen do
                                    if string_z(@elemente[i])^=ergebnis_zk then
                                      begin
                                        ergebnis:=z2;
                                        Break;
                                      end
                                    else
                                      Inc(i,1+elemente[i]);

                                if ergebnis=0 then
                                  Val(ergebnis_zk,ergebnis,kontrolle);
                                if (kontrolle=0) and (ergebnis>=1) and (ergebnis<=anzahl_einstellungen) then
                                  aktuelle_einstellung:=ergebnis;
                              end;

                            else
                              RunError_99;
                            end;
                      end;

                    STR_DISPLAY:
                      begin
                        (* STR_DISPLAY(CONST X,Y,P;CONST STR) *)
                        tmpzk:=liefere_zeichenkette(var_verkn_4);
                        sn:=liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_3);
                        i:=liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_2)-1;
                        i:=i*80+liefere_wert_aus_zahlenvariable_oder_wert(var_verkn_1)-1;

                        for z2:=1 to Length(tmpzk) do
                          if seiten_hintergruende[sn][2*(i+z2-1)]<>Ord(tmpzk[z2]) then
                            begin
                              vollstaendig_neuzeichnen:=true;
                              seiten_hintergruende[sn][2*(i+z2-1)]:=Ord(tmpzk[z2]);
                            end;
                      end;

                    SEARCH_PCI_DEVICEID:
                      begin
                        (* SEARCH_PCI_DEVICEID(CONST VENDOR,DEVICE:STR;VAR FOUND:BOOLEAN) *)
                        (* keine Suche! *)
                        variablen_tabelle[var_verkn_3].aktuelle_einstellung:=Ord(false);
                      end;

                    SEARCH_PCI_DEVICECLASS:
                      begin
                        (* SEARCH_PCI_DEVICECLASS(CONST DEVICECLASS,PROGRAMMINGINTERFACE:STR;VAR FOUND:BOOLEAN) *)
                        (* keine Suche! *)
                        variablen_tabelle[var_verkn_3].aktuelle_einstellung:=Ord(false);
                      end;

                    SEARCH_PNP_DEVICEID:
                      begin
                        (* SEARCH_PNP_DEVICEID(CONST PNPID:STR;VAR FOUND:BOOLEAN) *)
                        (* keine Suche! *)
                        variablen_tabelle[var_verkn_2].aktuelle_einstellung:=Ord(false);
                      end;

                    SEARCH_PNP_DEVICECLASS:
                      begin
                        (* Search_PNP_DeviceClass(CONST PNPCLASS,PROGRAMMINGINTERFACE:STR;VAR FOUND:BOOLEAN) *)
                        (* keine Suche! *)
                        variablen_tabelle[var_verkn_3].aktuelle_einstellung:=Ord(false);
                      end;

                    COUNT_PCI_DEVICEID:
                      begin
                        (* COUNT_PCI_DEVICEID(CONST VENDOR,DEVICE:STR;VAR FOUND:INTEGER) *)
                        (* keine Suche! *)
                        variablen_tabelle[var_verkn_3].aktuelle_einstellung:=0;
                      end;

                    COUNT_PCI_DEVICECLASS:
                      begin
                        (* COUNT_PCI_DEVICECLASS(CONST DEVICECLASS,PROGRAMMINGINTERFACE:STR;VAR FOUND:INTEGER) *)
                        (* keine Suche! *)
                        variablen_tabelle[var_verkn_3].aktuelle_einstellung:=0;
                      end;

                    COUNT_PNP_DEVICEID:
                      begin
                        (* COUNT_PNP_DEVICEID(CONST PNPID:STR;VAR FOUND:INTEGER) *)
                        (* keine Suche! *)
                        variablen_tabelle[var_verkn_2].aktuelle_einstellung:=0;
                      end;

                    COUNT_PNP_DEVICECLASS:
                      begin
                        (*COUNT_PNP_DeviceClass(CONST PNPCLASS,PROGRAMMINGINTERFACE:STR;VAR FOUND:INTEGER) *)
                        (* keine Suche! *)
                        variablen_tabelle[var_verkn_3].aktuelle_einstellung:=0;
                      end;

                    QUERY_BOOTDRIVE_LETTER:
                      begin
                        (* QUERY_BOOTDRIVE_LETTER(VAR DRIVELETTER:STRING) *)
                        speicher_string_variable(var_verkn_1,
                          gross(SysGetBootDrive));
                      end;

                    SET_BOOTDRIVE_LETTER:
                      begin
                        (* SET_BOOTDRIVE_LETTER(CONST DRIVELETTER:STRING) *)
                        (* Wert nicht merken *)
                      end;

                    SET_ALTF2ON_FILE:
                      begin
                        (* SET_ALTF2ON_FILE(CONST ALTF2ON:INTEGER) *)
                        (* hat hier keine Auswirkung *)
                      end;


                  else
                    RunError_99;
                  end;

                  if verknuepfung in [$1..$c] then
                    variablen_tabelle[var_verkn_1].aktuelle_einstellung:=ergebnis;

                end; (* gÅltig *)
            end; (* for *)

    end; (* Berechnungen *)


  function tastendruck:smallword;
    begin
      Result:=Ord(SysReadKey);
      if Result in [$00,$e0] then
        Result:=Ord(SysReadKey) shl 8;

      if Result=$0d then Result:=$1c0d;
      if Result=$1b then Result:=$011b;
    end;

  function schnellmenue_aufruf(const taste:word):boolean;
    var
      schnell,z:word;
    begin

      schnell:=Lo(taste)-Ord('0');
      if schnell=0 then
        schnell:=10;

      Result:=false;

      for z:=1 to variablen_zaehler do
        if schnell_menu_benutzt[schnell][z] then
          begin
            with variablen_tabelle[z] do
              case variablentyp of
                variablentyp_zahl,
                variablentyp_drehfeld:
                  aktuelle_einstellung:=schnell_menu[schnell][z];

                variablentyp_zeichenkette:
                  platz_fuer_zeichenkette:=liefere_zeichenkette(schnell_menu[schnell][z]);

              else
                RunError_99;
              end;
            Result:=true;
          end;
    end; (* schnellmenue_aufruf *)

  procedure cpu_erkennung;

  var
    a,b,c,d:longint;

  function Is486:boolean;assembler;
    {&Frame-}{&Uses ebx}
    asm
      pushfd
        pushfd
        pop eax
        mov ebx,eax
        xor eax,(1 shl 18) // Alignment Check bit
        push eax
        popfd
        pushfd
        pop eax
      popfd
      xor eax,ebx
      shr eax,18
      and eax,1
    end;

  function CpuIdSupported:boolean;assembler;
    {&Frame-}{&Uses None}
    asm
      pushfd
      pop eax
      or eax,(1 shl 21) // set ID bit
      push eax
      popfd

      pushfd
      pop eax
      shr eax,21
      and eax,1
    end;


  procedure CpuId(const subfunction:longint);assembler;
    {&Frame-}{&Uses All}
    asm
      mov eax,subfunction
      sub ebx,ebx
      sub ecx,ecx
      sub edx,edx
      cpuid
      mov a,eax
      mov b,ebx
      mov c,ecx
      mov d,edx
    end;

    var
      fms:word;
      name:string[12];
      va:integer;
    begin
      if not Is486 then
        begin
          fms:=$300;
          name:='unknown';
        end
      else
      if not CpuIdSupported then
        begin
          fms:=$400;
          name:='unknown';
        end
      else
        begin
          CpuId(0);
          SetLength(name,4+4+4);
          Move(b,name[1],4);
          Move(d,name[5],4);
          Move(c,name[9],4);
          CpuId(1);
          fms:=a and $fff;
        end;

      va:=suche_variable('OS2CSM_CPU_FMS');
      if va<>-1 then
        speicher_string_variable(va,Int2Hex(fms,3));

      va:=suche_variable('OS2CSM_CPU_NAME');
      if va<>-1 then
        speicher_string_variable(va,name);
    end;

  function confirm_menu_screen(x_seite_benutzt:boolean;var x_seite:seitenspeicher_typ;x_seite_ja_sc,x_seite_nein_sc:smallword):boolean;
    var
      x,y                       :word;
      attrib_durchsichtig       :byte;
      t                         :smallword;
    begin

      vollstaendig_neuzeichnen:=true;

      if not x_seite_benutzt then
        begin
          Result:=true;
          Exit;
        end;

      a:=@x_seite;

      attrib_durchsichtig:=a^.attribut;
      for y:=0 to zeilen-1 do
        for x:=0 to spalten-1 do
          with a^do
            begin
              if attribut<>attrib_durchsichtig then
                SysWrtCharStrAtt(@zeichen,1,x,y,attribut);
              Inc(a);
            end;

      SysTVSetCurPos(0,0);
      SysTVSetCurType(0,0,false);

      repeat
        t:=tastendruck;
        if t=x_seite_ja_sc then
          begin
            Result:=true;
            Break;
          end;
        if t=x_seite_nein_sc then
          begin
            Result:=false;
            Break;
          end;
      until false;

    end; (* confirm_menu_screen *)

  begin (* menu_ausfueren *)

    Write(textz___Standardwerte_aendern^);
    SysGetCurPos(cx,cy);
    SysTVGetCurType(c1,c2,cv);
    {$IfDef Os2}
    VioGetCp(0,codeseite,0);

    if menu_palette_benutzen then
      begin

        with ega_state do
          begin
            cb:=SizeOf(ega_state);
            rType:=0;
            iFirst:=0;
          end;
        if VioGetState(ega_state,0)=0 then
          for z:=Low(ega) to High(ega) do
            ega[z]:=ega_state.Acolor[z];

        with rgb_state do
          begin
            cb:=SizeOf(rgb_state);
            rType:=3;
            FirstColorReg:=0;
            NumColorRegs:=255;
            ColorRegAddr:=@pal;
            FlatToSel(ColorRegAddr);
          end;
        VioGetState(rgb_state,0);
        pal0:=pal;

        for z:=Low(ega) to High(ega) do
          with pal[ega[z]],menu_palette[z] do
            begin
              rr:=r shr 2;
              gg:=g shr 2;
              bb:=b shr 2;
            end;
        VioSetState(rgb_state,0);
      end;
    {$EndIf Os2}

    SysGetVideoModeInfo(spalten,zeilen,farben);
    GetMem(p,spalten*zeilen*2);
    a:=p;
    for y:=0 to zeilen-1 do
      for x:=0 to spalten-1 do
        with a^ do
          begin
            zeichen:=SysReadCharAt(x,y);
            attribut:=SysReadAttributesAt(x,y);
            Inc(a);
          end;

    SysSetVideoMode(80,seiten_zeilenzahl);
    {$ifDef Os2}
    VioSetCp(0,437      ,0); (* ROM (437) *)
    if menu_palette_benutzen then
      VioSetState(rgb_state,0);
    {$EndIf OS2}

    variablenposition:=1;
    suche_naechste_sichtbare_variable(0);
    vollstaendig_neuzeichnen:=true;
    editor_position:=0;

    (* hier wÅrde OS2CSM_VPC,... initialisiert werden,
       aber ich vertraue auf vernÅnftige Standardwerte *)

    cpu_erkennung;


    berechnungen(anweisung_anfang);
    berechnungen(anweisung_normal);

    variablen_kopie:=variablen_tabelle;

    drehfeldabstand:=1;
    drehfeldabstand_var:=suche_variable('OS2CSM_SPINBUTTON_DISTANCE');
    if drehfeldabstand_var<>-1 then
      with variablen_tabelle[drehfeldabstand_var] do
        if variablentyp=variablentyp_zahl then (* boolean/integer *)
          drehfeldabstand:=aktuelle_einstellung;


    repeat (* fÅr OS2CSM_ACCEPT_MENU *)

    repeat (* normale schleife *)

      abbruch:=false;

      if vollstaendig_neuzeichnen then
        begin
          a:=@seiten_hintergruende[dargestellte_seite];
          for y:=0 to zeilen-1 do
            for x:=0 to spalten-1 do
              with a^ do
                begin
                  SysWrtCharStrAtt(@zeichen,1,x,y,attribut);
                  Inc(a);
                end;

          SysTVSetCurType(0,0,false);

          vollstaendig_neuzeichnen:=false;
        end;


      berechnungen(anweisung_normal);

      (* Aktualisierung *)
      for z:=1 to variablen_zaehler do
        with variablen_tabelle[z] do
          if (x_position<>0) and (dargestellte_seite=seitennummer) then (* nicht versteckt/unsichtbar *)

            case variablentyp of
              variablentyp_zahl:

                if anzahl_einstellungen=1 then (* boolean *)
                  begin
                    attr:=SysReadAttributesAt(x_position-1,y_position-1);
                    if z=variablenposition then
                      begin
                        attr:=attr xor $80;
                        SysWrtCharStrAtt(@falsch_wahr_zeichen_gewaehlt[boolean(aktuelle_einstellung)],1,x_position-1,y_position-1,attr);
                      end
                    else
                      begin
                        SysWrtCharStrAtt(@falsch_wahr_zeichen[boolean(aktuelle_einstellung)],1,x_position-1,y_position-1,attr);
                      end;
                  end
                else (* Zahl *)
                  for z2:=1 to anzahl_einstellungen do
                    begin
                      attr:=SysReadAttributesAt(x_position-1,y_position-1+z2-1);
                      if (z=variablenposition) and (aktuelle_einstellung=z2) then
                        attr:=attr xor $80;
                      SysWrtCharStrAtt(@ausgewaehlt_zeichen[aktuelle_einstellung=z2],1,x_position-1,y_position-1+z2-1,attr);
                    end;

              variablentyp_zeichenkette:
                for z2:=1 to anzahl_einstellungen do
                  begin
                    attr:=SysReadAttributesAt(x_position-1+z2-1,y_position-1);
                    if z2<=Length(platz_fuer_zeichenkette) then
                      SysWrtCharStrAtt(@platz_fuer_zeichenkette[z2],1,x_position-1+z2-1,y_position-1,attr)
                    else
                      SysWrtCharStrAtt(@leer_feld,1,x_position-1+z2-1,y_position-1,attr)
                  end;

              variablentyp_drehfeld:
                begin
                  tmpzk:=liefere_zeichenkette_vn(z);

                  with drehfeld_speicher^ do
                    begin
                      if weite<0 then
                        while Abs(weite)<>Length(tmpzk) do
                          tmpzk:=tmpzk+' '
                      else
                        while weite<>Length(tmpzk) do
                          Insert(' ',tmpzk,1);
                    end;

                  for z2:=1 to Length(tmpzk) do
                    begin
                      attr:=SysReadAttributesAt(x_position-1+z2-1,y_position-1);
                      SysWrtCharStrAtt(@tmpzk[z2],1,x_position-1+z2-1,y_position-1,attr)
                    end;

                  // Wunsch Oliver: Attr unverÑndert
                  // Wunsch A.F.D: Abstand verstellbar
                  attr:=SysReadAttributesAt(x_position-1+Length(tmpzk)+drehfeldabstand,y_position-1);
                  if z=variablenposition then
                    attr:=attr xor $80;
                  SysWrtCharStrAtt(@drehfeld_zeichen1,1,x_position-1+Length(tmpzk)+drehfeldabstand,y_position-1,attr);
                end;

            else
              RunError_99;
            end; (* case *)

      with variablen_tabelle[variablenposition] do
        case variablentyp of
          variablentyp_zahl,
          variablentyp_drehfeld:
            begin
              SysTVSetCurPos(0,0);
              SysTVSetCurType(0,0,false);
            end;
          variablentyp_zeichenkette:
            begin
              if editor_position=0 then
                editor_position:=Length(platz_fuer_zeichenkette)+1;
              if Length(platz_fuer_zeichenkette)=1 then
                editor_position:=1;

              SysTVSetCurPos(x_position-1+editor_position-1,y_position-1);
              if ueberschreibmodus then
                SysTVSetCurType(  -0,-100,true)
              else
                SysTVSetCurType( -50,-100,true);
            end;
        else
          RunError_99;
        end;


      (* Eingabe *)
      taste:=tastendruck;

      (* Blinken entfernen *)
      with variablen_tabelle[variablenposition] do
        case variablentyp of
          variablentyp_zahl:
            begin
              if anzahl_einstellungen=1 then
                begin
                  attr:=SysReadAttributesAt(x_position-1,y_position-1) xor $80;
                  zeichen:=SysReadCharAt(x_position-1,y_position-1);
                  SysWrtCharStrAtt(@zeichen,1,x_position-1,y_position-1,attr);
                end
              else
                begin
                  attr:=SysReadAttributesAt(x_position-1,y_position-1+aktuelle_einstellung-1) xor $80;
                  zeichen:=SysReadCharAt(x_position-1,y_position-1+aktuelle_einstellung-1);
                  SysWrtCharStrAtt(@zeichen,1,x_position-1,y_position-1+aktuelle_einstellung-1,attr);
                end;
            end;

          variablentyp_zeichenkette:
            ;

          variablentyp_drehfeld:
            with drehfeld_speicher^ do
              begin
                attr:=SysReadAttributesAt(x_position-1+Abs(weite)+drehfeldabstand,y_position-1) xor $80;
                SysWrtCharStrAtt(@drehfeld_zeichen1,1,x_position-1+Abs(weite)+drehfeldabstand,y_position-1,attr);
              end;
        else
          RunError_99;
        end;


      if taste=eingabetaste_sc then (* Eingabe *)
        begin
          abbruch:=false;
          Break;
        end;

      if taste=cancel_sc then (* Esc *)
        begin
          abbruch:=true;
          Break;
        end;

      if (taste=reset_sc) then
        if confirm_menu_screen(reset_seite_benutzt,reset_seite,reset_seite_ja_sc,reset_seite_nein_sc) then
          begin
            variablen_tabelle:=variablen_kopie;
            vollstaendig_neuzeichnen:=true;
          end;

      if (taste=help_sc) then
        begin
          hilfe_anzeigen(variablen_tabelle[variablenposition].seitennummer,variablenposition);
          vollstaendig_neuzeichnen:=true;
        end;

      case taste of
        $0f09, (* tab *)
        $0009:
          suche_naechste_sichtbare_variable(+1);

        $0f00: (* Umschalt-tab *)
          suche_naechste_sichtbare_variable(-1);

        $4900: (* Bild^ *)
          passe_variable_an_seite_an(-1);

        $5100: (* Bildv *)
          passe_variable_an_seite_an(+1);

      else (* case taste *)
        with variablen_tabelle[variablenposition] do

          case variablentyp of

            variablentyp_zahl:
              case taste of
                $4700: (* Pos1 *)
                  if anzahl_einstellungen<>1 then
                    aktuelle_einstellung:=1;

                $4f00: (* Ende *)
                  if anzahl_einstellungen<>1 then
                    aktuelle_einstellung:=anzahl_einstellungen;

                $4800: (* nach oben *)
                  if anzahl_einstellungen<>1 then
                    begin
                      if aktuelle_einstellung=1 then
                        aktuelle_einstellung:=anzahl_einstellungen
                      else
                        Dec(aktuelle_einstellung);
                    end;

                $5000: (* nach unten *)
                  if anzahl_einstellungen<>1 then
                    begin
                      if aktuelle_einstellung=anzahl_einstellungen then
                        aktuelle_einstellung:=1
                      else
                        Inc(aktuelle_einstellung);
                    end;

                $0020: (* Leertaste *)
                  if anzahl_einstellungen=1 then
                    aktuelle_einstellung:=aktuelle_einstellung xor 1;

              else (* taste *)

                gefunden:=false;

                if Lo(taste) in [Ord('0')..Ord('9')] then
                  gefunden:=schnellmenue_aufruf(taste);

                if not gefunden then
                  for z:=1 to variablen_zaehler do
                    if Ord(variablen_tabelle[z].sprung_taste)=taste then
                      begin
                        editor_position:=0;
                        variablenposition:=z;
                        suche_naechste_sichtbare_variable(0);
                        with variablen_tabelle[z] do
                          if anzahl_einstellungen=1 then
                            aktuelle_einstellung:=aktuelle_einstellung xor 1
                          else
                            if aktuelle_einstellung=anzahl_einstellungen then
                              aktuelle_einstellung:=1
                            else
                              Inc(aktuelle_einstellung);
                      end;
              end; (* variablentyp_zahl *)

            variablentyp_zeichenkette:
              begin
                zeichenkette:=@platz_fuer_zeichenkette;

                if editor_position=0 then
                  begin
                    if ueberschreibmodus then
                      editor_position:=1
                    else
                      editor_position:=Length(zeichenkette^)+1;
                    if Length(zeichenkette^)=1 then
                      editor_position:=1;
                  end;


                case taste of
                  $4b00: (* nach links  *)
                    if editor_position>1 then Dec(editor_position);
                  $4d00: (* nach rechts *)
                    if editor_position<Length(zeichenkette^)+1 then Inc(editor_position);
                  $4700: (* Pos1        *)
                    editor_position:=1;
                  $4f00: (* Ende        *)
                    editor_position:=Length(zeichenkette^)+1;
                  $5300: (* Entf        *)
                    if editor_position<=Length(zeichenkette^) then
                      begin
                        Delete(zeichenkette^,editor_position,1);
                        zeichenkette^[Length(zeichenkette^)+1]:=' ';
                      end;
                  $0008: (* <--         *)
                    if editor_position>=2 then
                      begin
                        Dec(editor_position);
                        Delete(zeichenkette^,editor_position,1);
                        zeichenkette^[Length(zeichenkette^)+1]:=' ';
                      end;
                else
                  if (Lo(taste)>=Ord(' ')) and (editor_position<=anzahl_einstellungen) then
                    begin
                      if ueberschreibmodus and (editor_position<=Length(zeichenkette^)) then
                        zeichenkette^[editor_position]:=Chr(Lo(taste))
                      else
                        Insert(Chr(Lo(taste)),zeichenkette^,editor_position);
                      if Length(zeichenkette^)>anzahl_einstellungen then
                        SetLength(zeichenkette^,anzahl_einstellungen);
                      Inc(editor_position);
                    end;
                end; (* case taste *)
              end; (* variablentyp_zeichenkette *)

            variablentyp_drehfeld:
              case taste of
                $4700: (* Pos1 *)
                  aktuelle_einstellung:=1;

                $4f00: (* Ende *)
                  aktuelle_einstellung:=anzahl_einstellungen;

                $4800: (* nach oben *)
                  if aktuelle_einstellung=1 then
                    aktuelle_einstellung:=anzahl_einstellungen
                  else
                    Dec(aktuelle_einstellung);

                $5000: (* nach unten *)
                  if aktuelle_einstellung=anzahl_einstellungen then
                    aktuelle_einstellung:=1
                  else
                    Inc(aktuelle_einstellung);

              else (* case taste *)

                gefunden:=false;

                if Lo(taste) in [Ord('0')..Ord('9')] then
                  gefunden:=schnellmenue_aufruf(taste);

                (* erst Sprungtasten *)
                if not gefunden then
                  for z:=1 to variablen_zaehler do
                    if Ord(variablen_tabelle[z].sprung_taste)=taste then
                      begin
                        editor_position:=0;
                        variablenposition:=z;
                        suche_naechste_sichtbare_variable(0);
                        with variablen_tabelle[z] do
                          if aktuelle_einstellung=anzahl_einstellungen then
                            aktuelle_einstellung:=1
                          else
                            Inc(aktuelle_einstellung);
                        gefunden:=true;
                        Break;
                      end;

                (* dann Anfangsbuchstaben des Drehfeldes *)
                if not gefunden then
                  begin
                    sicherung:=aktuelle_einstellung;

                    (* Drehfeld mit dem richtigen Anfang Suchen *)
                    for z:=1 to anzahl_einstellungen do
                      begin
                        Inc(aktuelle_einstellung);
                        if aktuelle_einstellung>anzahl_einstellungen then
                          aktuelle_einstellung:=1;

                        tmpzk:=liefere_zeichenkette(variablenposition);
                        while (tmpzk<>'') and (tmpzk[1]=' ') do
                          Delete(tmpzk,1,1);

                        if (tmpzk<>'') and (UpCase(tmpzk[1])=UpCase(Chr(Lo(taste)))) then
                          begin
                            gefunden:=true;
                            Break;
                          end;
                      end;

                    if not gefunden then
                      aktuelle_einstellung:=sicherung;

                  end;

              end (* case taste *)

        end; (* case variablentyp *)

      end;

    until false; (* normale Eingabeschleife *)

    os2csm_accept_menu:=true;
    sicherung:=suche_variable('OS2CSM_ACCEPT_MENU');
    if sicherung<>-1 then
      with variablen_tabelle[sicherung] do
        if (variablentyp=variablentyp_zahl)
        and (anzahl_einstellungen=1) (* boolean *)
        and (aktuelle_einstellung=0) then
          os2csm_accept_menu:=false;


    if os2csm_accept_menu then
      begin
        if abbruch then
          begin
            if confirm_menu_screen(abbruch_seite_benutzt,abbruch_seite,abbruch_seite_ja_sc,abbruch_seite_nein_sc) then
              Break;
          end
        else
          begin
            if confirm_menu_screen(weiter_seite_benutzt,weiter_seite,weiter_seite_ja_sc,weiter_seite_nein_sc) then
              Break;
          end;
      end;

    until os2csm_accept_menu;

    berechnungen(anweisung_ende);

    SysSetVideoMode(spalten,zeilen);
    {$IfDef Os2}
    VioSetCp(0,codeseite,0);
    if menu_palette_benutzen then
      begin
        pal:=pal0;
        VioSetState(rgb_state,0);
      end;
    {$EndIf Os2}
    a:=p;
    for y:=0 to zeilen-1 do
      for x:=0 to spalten-1 do
        with a^ do
          begin
            SysWrtCharStrAtt(@zeichen,1,x,y,attribut);
            Inc(a);
          end;
    FreeMem(p);

    SysTVSetCurType(c1,c2,cv);
    SysTVSetCurPos(cx,cy);
    WriteLn;
  end;

(*******************************************************************)

procedure schreibe_os2ldr_neu1(const dateiname:string;var puffer_alt,puffer_neu:os2ldr_puffer_typ;const laenge_alt,laenge_neu:longint;const dateizeit:longint);
  var
    d                   :file;
    tmp                 :file;
    fehler              :word;
    z                   :word;
    gleich              :boolean;
    pruefposition       :word;
    p,n,e               :string;
    tempname            :string;
  begin
    FSplit(dateiname,p,n,e);
    tempname:=p+n+'.tmp';

    (* nicht benîtigte datei lîschen ? *)
    if laenge_neu<=0 then
      begin
        (* OS2LDR.BIN lîschen, auch bei geschÅtzter Datei *)
        FileMode:=open_access_WriteOnly+open_share_DenyReadWrite;
        Assign(d,dateiname);
        SetFAttr(d,0);(* DosError ignorieren *)
        (*$I-*)
        Erase(d);
        (*$I+*)
        fehler:=IOResult;
        WriteLn;
        Exit;
      end;

    (* Schreiben von OS2LDR einsparen weil sich nichts geÑndert hat ? *)
    gleich:=(laenge_alt=laenge_neu);

    if gleich then
      for pruefposition:=0 to laenge_neu-1 do
        if puffer_alt[pruefposition]<>puffer_neu[pruefposition] then
          begin
            gleich:=false;
            Break;
          end;

    if gleich then
      begin
        WriteLn(textz_uebergangen_unveraendert^);
        Exit;
      end;

    (* OS2LDR.TMP neu erzeugen, auch bei geschÅtzter Datei *)
    FileMode:=open_access_ReadWrite+open_share_DenyReadWrite;
    Assign(d,tempname);
    SetFAttr(d,0);(* DosError ignorieren *)
    (*$I-*)
    Rewrite(d,1);
    (*$I+*)
    fehler:=IOResult;
    if fehler<>0 then
      begin
        WriteLn(textz_Fehler__^,fehler,'!');
        fehler_ende(fehler);
      end;

    BlockWrite(d,puffer_neu,laenge_neu);
    if dateizeit<>0 then
      begin
        Reset(d,1);
        SetFTime(d,dateizeit);
      end;
    Close(d);

    (* OS2LDR lîschen, auch bei geschÅtzter Datei *)
    FileMode:=open_access_WriteOnly+open_share_DenyReadWrite;
    Assign(tmp,dateiname);
    SetFAttr(tmp,0);(* DosError ignorieren *)
    (*$I-*)
    Erase(tmp);
    (*$I+*)
    fehler:=IOResult;

    (* OS2LDR.TMP in OS2LDR umbenennen *)
    (*$I-*)
    Rename(d,dateiname);
    (*$I+*)
    fehler:=IOResult;
    if fehler<>0 then
      begin
        WriteLn(textz_Fehler__^,fehler,'!');
        fehler_ende(fehler);
      end;

    WriteLn(' -> ',laenge_neu);
  end;

procedure schreibe_os2ldr_neu(const config_sys_verzeichnis:string;const mit_os2csm:boolean);
  var
    z,z2,i,
    laenge,
    variablen_pos,
    variablen_platz_lang,
    variablen_platz_kurz,
    kopf_blocklaenge,
    schnell             :longint;
    temp_variablen      :array[0..variablen_platz_vorhanden-1+10000] of byte;
    benutzt             :boolean;

  procedure Inc_variablen_pos(l:longint);
    begin
      if Longint(variablen_pos)+l>High(os2ldr_puffer_typ) then (* < 64K *)
        begin
          WriteLn(textz_zu_viele_grosse_variablen^);
          fehler_ende_99;
        end;
      Inc(variablen_pos,l);
    end;

  procedure speichere_bildschirm_gepackt(const b:seitenspeicher_typ;laenge:word);
    var
      umgeordnet        :array[0..80*50] of byte;
      z                 :word;

    procedure packe_bildschirm;
      var
        laengen_byte_stelle,
        leseposition,
        anzahl          :word;

      begin

        leseposition:=0;
        laengen_byte_stelle:=0;
        while leseposition<laenge do
          begin

            anzahl:=1;
            (* Versuch zu packen .. *)
            while (anzahl<$7f)
              and (leseposition+anzahl<laenge)
              and (umgeordnet[leseposition]=umgeordnet[leseposition+anzahl]) do
                Inc(anzahl);

            if (anzahl>=3) then
              begin
                laengen_byte_stelle:=0; (* Block kann nicht fortgesetzt werden *)
                os2ldr_puffer[variablen_pos]:=anzahl or $80;
                Inc_variablen_pos(1);
                os2ldr_puffer[variablen_pos]:=umgeordnet[leseposition];
                Inc_variablen_pos(1);
                Inc(leseposition,anzahl);
              end
            else
              begin

                (* mu· neuer Block angefangen werden ? *)
                if laengen_byte_stelle=0 then
                  begin
                    laengen_byte_stelle:=variablen_pos;
                    os2ldr_puffer[variablen_pos]:=0;
                    Inc_variablen_pos(1);
                  end;

                os2ldr_puffer[variablen_pos]:=umgeordnet[leseposition];
                Inc_variablen_pos(1);
                Inc(leseposition);

                Inc(os2ldr_puffer[laengen_byte_stelle]);
                (* maximale LÑnge erreicht->Ende des Blockes *)
                if os2ldr_puffer[laengen_byte_stelle]=$7f then
                  laengen_byte_stelle:=0;
              end;

          end;

        (* Ende-Kennung *)
        os2ldr_puffer[variablen_pos]:=0;
        Inc_variablen_pos(1);

      end;

    begin

      for z:=0 to laenge-1 do
        umgeordnet[z]:=b[z*2  ];
      packe_bildschirm;

      for z:=0 to laenge-1 do
        umgeordnet[z]:=b[z*2+1];
      packe_bildschirm;

    end;

  var
    gleiche_drehfeld_definition:word;

  function MemCmp(const m1,m2;const len:word):boolean;
    {&Uses esi,edi,ecx}{&Frame-}
    asm
      mov esi,[m1]
      mov edi,[m2]
      mov ecx,[len]
      cld
      repe cmpsb
      sete al
    end;

  function suche_gleiche_drehfeld_definition(var vn:word):word;
    var
      i,j               :word;
      gleich            :boolean;
    begin
      for i:=1 to vn-1 do
        with variablen_tabelle[i] do
          if variablentyp=variablentyp_drehfeld then
            if drehfeld_speicher_laenge=variablen_tabelle[vn].drehfeld_speicher_laenge then
              if MemCmp(drehfeld_speicher^,variablen_tabelle[vn].drehfeld_speicher^,drehfeld_speicher_laenge) then
                begin
                  suche_gleiche_drehfeld_definition:=i;
                  Exit;
                end;

      suche_gleiche_drehfeld_definition:=-1;
    end; (* suche_gleiche_drehfeld_definition *)

  begin
    if os2csm_memdisk then
      Write(textz_gleich_Schreibe_^,config_sys_verzeichnis,'os2csm.bin ')
    else
      Write(textz_gleich_Schreibe_^,config_sys_verzeichnis,'os2ldr ');

    (* OS2CSM Vorspann *)
    if mit_os2csm then
      begin

        if os2csm_memdisk then
          begin
            os2ldr_datumzeit:=0;
            os2ldr_bin_laenge:=0;
          end
        else
          begin
            (* OS2LDR wird als OS2LDR.BIN gesichert *)
            os2ldr_bin_datumzeit:=os2ldr_datumzeit;
            os2ldr_datumzeit:=0;
            os2ldr_bin_laenge:=os2ldr_laenge;
            Move(os2ldr_puffer,os2ldr_bin_puffer,os2ldr_bin_laenge);
          end;

        (* OS2LDR wird aus OS2CSM erstellt *)
        os2ldr_laenge:=os2csm_bin_laenge;
        Move(os2csm_bin_puffer,os2ldr_puffer,os2csm_bin_laenge);


        (* zu lîschende Variablen benîtigen keinen Namen *)
        (* aber ich benîtige den Namen wenn man die
           Variablenkonfiguration auf Diskette speicher/laden will
        for z:=1 to variablen_zaehler do
          if loeschtyp=variable_loeschen then
            variablen_name:='';*)

        (* Berechnen des Platzbedarfes fÅr die Variablen *)
        variablen_platz_lang:=0;
        variablen_platz_kurz:=0;

        for z:=1 to variablen_zaehler do
          with variablen_tabelle[z] do
            begin

              kopf_blocklaenge:=Ofs(variablen_name)
                               -Ofs(blocklaenge)
                               +1+Length(variablen_name);

              case variablentyp of
                variablentyp_zahl:
                  begin
                    blocklaenge:=kopf_blocklaenge;
                    Move(variablen_tabelle[z],temp_variablen[variablen_platz_lang],kopf_blocklaenge);
                    Inc(variablen_platz_lang,blocklaenge);
                    if loeschtyp=variable_bleibt_unveraendert then
                      Inc(variablen_platz_kurz,blocklaenge);
                  end;

                variablentyp_zeichenkette:
                  begin
                    zeichenketteninhalt:=kopf_blocklaenge;
                    blocklaenge:=kopf_blocklaenge+1+anzahl_einstellungen;
                    Move(variablen_tabelle[z],temp_variablen[variablen_platz_lang],kopf_blocklaenge);

                    FillChar(temp_variablen[variablen_platz_lang+zeichenketteninhalt],1+anzahl_einstellungen,' ');
                    Move(platz_fuer_zeichenkette[0],temp_variablen[variablen_platz_lang+zeichenketteninhalt],
                      1+Length(platz_fuer_zeichenkette));

                    Inc(variablen_platz_lang,blocklaenge);
                    if loeschtyp=variable_bleibt_unveraendert then
                      Inc(variablen_platz_kurz,blocklaenge);
                  end;

                variablentyp_drehfeld:
                  begin
                    zeichenketteninhalt:=kopf_blocklaenge;
                    if loeschtyp in [variable_loeschen,variable_packen_zu_zahl,variable_packen_zu_zeichenkette] then
                      gleiche_drehfeld_definition:=suche_gleiche_drehfeld_definition(z)
                    else
                      gleiche_drehfeld_definition:=-1;

                    if gleiche_drehfeld_definition<>-1 then
                      begin (* Platz sparend *)
                        blocklaenge:=kopf_blocklaenge;
                        Move(variablen_tabelle[z],temp_variablen[variablen_platz_lang],kopf_blocklaenge);
                        variablen_block(temp_variablen[variablen_platz_lang]).zeichenketteninhalt
                          :=gleiche_drehfeld_definition or $8000;

                        case loeschtyp of
                          variable_loeschen:
                            ;
                          variable_packen_zu_zahl:
                            ;
                          variable_packen_zu_zeichenkette:
                            begin
                              laenge:=groesste_drehfeld_laenge(drehfeld_speicher^,drehfeld_speicher_laenge);
                              Inc(blocklaenge,1+laenge);
                              variablen_block(temp_variablen[variablen_platz_lang]).blocklaenge:=blocklaenge;
                              FillChar(temp_variablen[variablen_platz_lang+kopf_blocklaenge],1+laenge,0);
                            end;
                        else
                          RunError_99;
                        end

                      end
                    else
                      begin (* Normalfall *)
                        blocklaenge:=kopf_blocklaenge+drehfeld_speicher_laenge;
                        Move(variablen_tabelle[z],temp_variablen[variablen_platz_lang                    ],kopf_blocklaenge        );
                        Move(drehfeld_speicher^  ,temp_variablen[variablen_platz_lang+zeichenketteninhalt],drehfeld_speicher_laenge);
                      end;

                    Inc(variablen_platz_lang,blocklaenge);
                    case loeschtyp of
                      variable_bleibt_unveraendert:
                        Inc(variablen_platz_kurz,blocklaenge);
                      variable_packen_zu_zahl:
                        Inc(variablen_platz_kurz,kopf_blocklaenge);
                      variable_packen_zu_zeichenkette:
                        Inc(variablen_platz_kurz,kopf_blocklaenge+1+groesste_drehfeld_laenge(drehfeld_speicher^,drehfeld_speicher_laenge));
                      variable_loeschen:
                          ;
                    else
                        RunError_99;
                    end;
                  end;

              else
                RunError_99;
              end; (* variablentyp *)

            if variablen_platz_lang>variablen_platz_vorhanden then
              begin
                WriteLn(textz_zu_viele_grosse_variablen^);
                WriteLn(variablen_zaehler,': "',variablen_name,'" , ',variablen_platz_lang,' / ',variablen_platz_vorhanden,' Byte');
                fehler_ende_99;
              end;

            if variablen_platz_kurz>variablen_platz_dauerhaft_vorhanden then
              begin
                WriteLn(textz_zu_viele_grosse_dauerhafte_variablen^);
                WriteLn(variablen_zaehler,': "',variablen_name,'" , ',variablen_platz_kurz,' / ',variablen_platz_dauerhaft_vorhanden,' Byte');
                WriteLn(textz_benutze_loesch_schluesselwoerter1^);
                WriteLn(textz_benutze_loesch_schluesselwoerter2^);
                fehler_ende_99;
              end;

          end; (* with *)



        (* nur am Anfang benîtigte Daten *)
        with anfangsvariablen_typ(os2ldr_puffer[anfangsvariablen_o]) do
          begin
            FillChar(schnelltastenzeiger,SizeOf(schnelltastenzeiger),0);
            formel_zeiger:=0;
            zeitgrenze_:=zeitgrenze;
            eingabetaste_sc_:=eingabetaste_sc;
            reset_sc_:=reset_sc;
            altf5_sc_:=altf5_sc;
            help_sc_:=help_sc;
            anzahl_bildschirmseiten_:=seiten_anzahl;
            FillChar(menu_bildschirm_beschreibung  ,SizeOf(menu_bildschirm_beschreibung  ),0);

            variablen_pos:=Ofs(platz_fuer_die_daten)-Ofs(os2ldr_puffer);
            for schnell:=1 to 10 do
              begin

                (* nicht leer ? *)
                benutzt:=false;
                for z:=1 to variablen_zaehler do
                  if schnell_menu_benutzt[schnell][z] then
                    begin
                      benutzt:=true;
                      Break;
                    end;

                (* wenn nicht leer: Inhalt kopieren und Zeiger weiterrÅcken *)
                if benutzt then
                  begin

                    schnelltastenzeiger[schnell]:=variablen_pos;
                    for z:=1 to variablen_zaehler do
                      if schnell_menu_benutzt[schnell][z] then
                        begin
                          (* Variablennummer *)
                          Move(z,os2ldr_puffer[variablen_pos],2);
                          Inc_variablen_pos(2);
                          (* Wert *)
                          Move(schnell_menu[schnell][z],os2ldr_puffer[variablen_pos],2);
                          Inc_variablen_pos(2);
                        end;
                    (* Abschlu· mit Variablennummer 0 *)
                    z:=0;
                    Move(z,os2ldr_puffer[variablen_pos],2);
                    Inc_variablen_pos(2);
                  end;
              end;

            (* alle Anweisungen *)
            formel_zeiger:=variablen_pos;
            laenge:=formel_zaehler*SizeOf(formel_tabelle[1]);
            Move(formel_tabelle,os2ldr_puffer[variablen_pos],laenge);
            Inc_variablen_pos(laenge);
            (* eine leere Anweisung *)
            laenge:=1*SizeOf(formel_tabelle[1]);
            FillChar(os2ldr_puffer[variablen_pos],laenge,0);
            Inc_variablen_pos(laenge);

            (* MENU.BIN .. *)
            with menu_bildschirm_beschreibung do
              begin
                bildschirm_zeilen_belegt:=seiten_zeilenzahl;
                cursor:=$2000;
                cursor_pos:=0;
                blinken:=true;
                bildschirm_puffer_zeiger:=variablen_pos;
                laenge:=bildschirm_zeilen_belegt*80*2;
                for z:=1 to seiten_anzahl do
                  begin
                    (*
                    Move(seiten_hintergruende[z],os2ldr_puffer[variablen_pos],laenge);
                    Inc_variablen_pos(laenge);*)
                    speichere_bildschirm_gepackt(seiten_hintergruende[z],80*bildschirm_zeilen_belegt);
                  end;
              end;

            (* Continue *)

            with menu_continue_beschreibung do
              if weiter_seite_benutzt then
                begin
                  bildschirm_zeilen_belegt:=seiten_zeilenzahl;
                  cursor:=$2000;
                  cursor_pos:=0;
                  blinken:=true;
                  bildschirm_puffer_zeiger:=variablen_pos;
                  laenge:=bildschirm_zeilen_belegt*80*2;
                  speichere_bildschirm_gepackt(weiter_seite,80*bildschirm_zeilen_belegt);
                end
              else
                FillChar(menu_continue_beschreibung,SizeOf(menu_continue_beschreibung),0);

            menu_continue_yes_sc:=weiter_seite_ja_sc;
            menu_continue_no_sc:=weiter_seite_nein_sc;

            (* Cancel *)

            with menu_cancel_beschreibung do
              if abbruch_seite_benutzt then
                begin
                  bildschirm_zeilen_belegt:=seiten_zeilenzahl;
                  cursor:=$2000;
                  cursor_pos:=0;
                  blinken:=true;
                  bildschirm_puffer_zeiger:=variablen_pos;
                  laenge:=bildschirm_zeilen_belegt*80*2;
                  speichere_bildschirm_gepackt(abbruch_seite,80*bildschirm_zeilen_belegt);
                end
              else
                FillChar(menu_cancel_beschreibung,SizeOf(menu_cancel_beschreibung),0);

            menu_cancel_yes_sc:=abbruch_seite_ja_sc;
            menu_cancel_no_sc:=abbruch_seite_nein_sc;

            (* Reset *)

            with menu_reset_beschreibung do
              if reset_seite_benutzt then
                begin
                  bildschirm_zeilen_belegt:=seiten_zeilenzahl;
                  cursor:=$2000;
                  cursor_pos:=0;
                  blinken:=true;
                  bildschirm_puffer_zeiger:=variablen_pos;
                  laenge:=bildschirm_zeilen_belegt*80*2;
                  speichere_bildschirm_gepackt(reset_seite,80*bildschirm_zeilen_belegt);
                end
              else
                FillChar(menu_reset_beschreibung,SizeOf(menu_reset_beschreibung),0);

            menu_reset_yes_sc:=reset_seite_ja_sc;
            menu_reset_no_sc:=reset_seite_nein_sc;

            (*   *)

            with dauervariablen_typ(os2ldr_puffer[dauervariablen_o]) do
              begin
                anzahl_variablen_:=variablen_zaehler;
                if not os2csm_memdisk then
                  FillChar(variablen_bereich_soll,SizeOf(variablen_bereich_soll),'-');
                (* Wenn genug Platz im kleinen Variablenfeld ist bleiben die
                Variablen gleich dort, sonst werden Sie hier angehÑngt *)
                if (variablen_platz_lang<variablen_platz_dauerhaft_vorhanden)
                (* oder os2csm.?_m (memdisk-Version) hat Åberhaupt keinen solchen Block *)
                and (not os2csm_memdisk)
                 then
                  begin
                    variablen_bereich_:=Ofs(variablen_bereich_soll)-Ofs(os2ldr_puffer);
                    Move(temp_variablen,variablen_bereich_soll,variablen_platz_lang);
                  end
                else
                  begin
                    variablen_bereich_:=variablen_pos;
                    Move(temp_variablen,os2ldr_puffer[variablen_pos],variablen_platz_lang);
                    Inc_variablen_pos(variablen_platz_lang);
                  end;

                (* Anzeige der Variablen...
                i:=variablen_bereich_;
                for z:=1 to anzahl_variablen_ do
                  begin
                    WriteLn(Int2Hex(i,4),' ',z:2,' ',variablen_tabelle[z].variablen_name);
                    Inc(i,os2ldr_puffer[i]+os2ldr_puffer[i+1] shl 8);
                  end;
                ......................... *)

              end;

            (* Hilfedatei in OS2LDR einbauen, bei OS2CSM.BIN (MemDisk) nicht notwendig *)
            if os2csm_memdisk then
              ofs_internal_helpfile:=High(ofs_internal_helpfile)
            else
              begin
                ofs_internal_helpfile:=variablen_pos;
                Move(os2csm_hlp_puffer,os2ldr_puffer[variablen_pos],os2csm_hlp_laenge);
                Inc_variablen_pos(os2csm_hlp_laenge);
              end;

            (* bis hierhin mÅssen die Daten abgespeichert werden *)
            os2ldr_laenge:=variablen_pos;

            variablen_zeiger_tabelle:=variablen_pos;
            Inc_variablen_pos(variablen_zaehler*2);

            (* Platz fÅr PNP-Funktionen *)
            if pnp_funktion_benutzt or dmi_variablen_benutzt then
              pnp_puffer_laenge:=1024
            else
              pnp_puffer_laenge:=0;
            pnp_puffer_zeiger:=variablen_pos;
            Inc_variablen_pos(pnp_puffer_laenge);

            menu_palette_benutzen_:=menu_palette_benutzen;
            menu_palette_:=menu_palette;
            (* 0..255-> 0..63 (BIOS) *)
            for z:=Low(menu_palette_) to High(menu_palette_) do
              with menu_palette_[z] do
                begin
                  r:=r shr 2;
                  g:=g shr 2;
                  b:=b shr 2;
                end;

          end; (* with anfangsvariablen_typ(os2ldr_puffer[anfangsvariablen_o]) *)


        (*Write('(',textz_Speicherbedarf^,': ',variablen_pos,') ');*)
      end (* mit_os2csm *)
    else
      begin
        (* OS2LDR als OS2LDR schreiben *)
        (* OS2LDR.BIN kann gelîcht werden *)
      end;

    if os2csm_memdisk then
      schreibe_os2ldr_neu1(config_sys_verzeichnis+'os2csm.bin',
                           org_os2ldr_puffer,os2ldr_puffer,
                           org_os2ldr_laenge,os2ldr_laenge,
                           os2ldr_datumzeit)
    else
      schreibe_os2ldr_neu1(config_sys_verzeichnis+'os2ldr',
                           org_os2ldr_puffer,os2ldr_puffer,
                           org_os2ldr_laenge,os2ldr_laenge,
                           os2ldr_datumzeit);

    if not os2csm_memdisk then
      begin

        if os2ldr_bin_laenge<=0 then
          Write(textz_gleich_Loesche_^ ,config_sys_verzeichnis,'os2ldr.bin ')
        else
          Write(textz_gleich_Schreibe_^,config_sys_verzeichnis,'os2ldr.bin ');


        schreibe_os2ldr_neu1(config_sys_verzeichnis+'os2ldr.bin',
                             org_os2ldr_bin_puffer,os2ldr_bin_puffer,
                             org_os2ldr_bin_laenge,os2ldr_bin_laenge,
                             os2ldr_bin_datumzeit);

      end; (* not memdisk *)

    if os2csm_memdisk then
      begin
        Write(textz_gleich_Schreibe_^,config_sys_verzeichnis,os2csm_hlp_name,' ');
        schreibe_os2ldr_neu1(config_sys_verzeichnis+os2csm_hlp_name,
                             os2csm_hlp_puffer,os2csm_hlp_puffer,
                             0                ,os2csm_hlp_laenge,
                             0);
      end;


  end;

(*******************************************************************)

function  liefere_standardwert_zahl(const variablenname:string):word;
  var
    i:word;
  begin
    i:=suche_variable(variablenname);
    if i=-1 then
      begin
        neue_variable(variablenname);

        with variablen_tabelle[variablen_zaehler] do
          begin
            Write(textz_unbekannte_Variable__^,variablenname,textz___Wert_^);
            variablentyp:=variablentyp_zahl;
            loeschtyp:=0;
            x_position:=0;
            y_position:=0;
            seitennummer:=0;
            anzahl_einstellungen:=$ffff;
            sprung_taste:=#0;
            ReadLn(aktuelle_einstellung);
            i:=variablen_zaehler;
          end;
      end;

    if not (variablen_tabelle[i].variablentyp in [variablentyp_zahl,variablentyp_drehfeld]) then
      begin
        WriteLn(textz_variable_ist_keine_zahlenvariable^);
        WriteLn(variablen_tabelle[i].variablen_name);
        fehler_ende_99;
      end;

    liefere_standardwert_zahl:=variablen_tabelle[i].aktuelle_einstellung;
  end;

(*******************************************************************)

function  liefere_standardwert_zeichenkette(const variablenname:string):string;

  var
    i,z                 :word;
    tmp                 :string;
  begin
    i:=suche_variable(variablenname);
    if i=-1 then
      begin
        neue_variable(variablenname);

        with variablen_tabelle[variablen_zaehler] do
          begin
            Write(textz_unbekannte_Variable__^,variablenname,textz___Wert_^);
            variablentyp:=variablentyp_zeichenkette;
            loeschtyp:=0;
            x_position:=0;
            y_position:=0;
            seitennummer:=0;
            anzahl_einstellungen:=0;
            sprung_taste:=#0;
            ReadLn(tmp);
            platz_fuer_zeichenkette:=tmp;
            i:=variablen_zaehler;
          end;
      end;

    with variablen_tabelle[i] do
      case variablentyp of
        variablentyp_zahl:
          liefere_standardwert_zeichenkette:=Int2Str(aktuelle_einstellung);

        variablentyp_zeichenkette:
          liefere_standardwert_zeichenkette:=platz_fuer_zeichenkette;

        variablentyp_drehfeld:
          liefere_standardwert_zeichenkette:=liefere_zeichenkette_vn(i);

      else
        RunError_99;
      end;

  end;

(*******************************************************************)

begin
  FillChar(schnell_menu,SizeOf(schnell_menu),0);
  FillChar(schnell_menu_benutzt,SizeOf(schnell_menu_benutzt),false);
  FillChar(formel_tabelle,SizeOf(formel_tabelle),0);
  zeitgrenze:=zeitgrenze_12_Stunden;

  basisverzeichnis:=ParamStr(0);
  while not (basisverzeichnis[Length(basisverzeichnis)] in ['\','/']) do
    Dec(basisverzeichnis[0]);
  {$IfDef Debug}
  basisverzeichnis:='M:\m\exe\';
  {$EndIf}

  FillChar(seiten_hintergruende,SizeOf(seiten_hintergruende),'A');
  seiten_anzahl:=0;
  FillChar(weiter_seite,SizeOf(weiter_seite),'A');

  FillChar(brane_tabelle,SizeOf(brane_tabelle),0);
  brane_tabelle_belegt:=0;
end.


