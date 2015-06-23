(* V.K. 04.10.1996 *)
(* 23.10.1996 Kennung *)
(* 11.03.1998 SET COUNTRY=0?? *)
(* 03.11.1998 DPMI32 *)
(* 09.12.1998 WIN32: country=1; *)

(*&USE32-*)

(*$IFDEF DPMI32*)
(*$UNDEF OS2*)
(*$UNDEF WIN32*)
(*$ENDIF*)

unit spra_aus;

interface

var
  country_nummer:word;

procedure setze_sprachzeiger(datenobjekt,zeiger_adresse:pointer);

implementation


uses
  (*$IFDEF VIRTUALPASCAL*)
  (*$IFDEF OS2*)
  Os2Base,Os2Def,
  (*$ENDIF*)
  (*$IFDEF DPMI32*)
  dpmi32,dpmi32df,
  (*$ENDIF*)
  (*$ENDIF*)
  dos;

(* use environment istead of system result:
   SET COUNTRY=049                                      *)
function suche_country_code_aus_umgebung:boolean;
  var
    country_str:string;
    erfolg:(*$IFDEF VIRTUALPASCAL*)longint(*$ELSE*)word(*$ENDIF*);
  begin
    suche_country_code_aus_umgebung:=false;
    country_str:=getenv('COUNTRY');
    if length(country_str)>0 then
      begin
        val(country_str,country_nummer,erfolg);
        if erfolg=0 then
          suche_country_code_aus_umgebung:=true;
      end;
  end;

(*$I SPRA_DAT*)




(*$IFDEF VIRTUALPASCAL*)

(*$IFDEF DPMI32*)
procedure bestimme_country_code;assembler;(*$FRAME-*)(*$USES EAX,ESI*)
  var
    reg:real_mode_call_structure_typ;
  asm
    lea esi,reg
    mov [esi+real_mode_call_structure_typ.ax_],$3800 // get Country-specific info
    mov ax,segdossyslow16
    mov [esi+real_mode_call_structure_typ.ds_],ax    // DS:DX
    mov [esi+real_mode_call_structure_typ.dx_],0
    mov [esi+real_mode_call_structure_typ.bx_],0
    push esi
    push $21
    call intr_realmode
    mov ax,[esi+real_mode_call_structure_typ.bx_]
    mov country_nummer,ax
  end;

(*$ENDIF*)

(*$IFDEF OS2*)
procedure bestimme_country_code;
  var
    Country   : COUNTRYCODE; (* Country code info (0 = current country) *)
    CtryInfo  : COUNTRYINFO; (* Buffer for country-specIfic information *)
    ulInfoLen : ULONG;
    rc        : APIRET;      (* Return code                             *)
  begin
    if suche_country_code_aus_umgebung then exit;
    ulInfoLen := 0;
    rc        := NO_ERROR;

    FillChar(Country,SizeOf(Country),0);
    FillChar(CtryInfo,SizeOf(CtryInfo),0);

    rc := DosQueryCtryInfo(sizeof(CtryInfo), Country,
                           CtryInfo, ulInfoLen);
    if (rc=0) and (CtryInfo.country<=$ffff) then
      country_nummer:=CtryInfo.country+0
    else
      country_nummer:=49;

  end;
(*$ENDIF*)

(*$IFDEF WIN32*)
procedure bestimme_country_code;
  begin
    country_nummer:=1; (* do not know -> use SET COUNTRY=... *)
  end;  
(*$ENDIF*)

(*$ELSE*)
procedure bestimme_country_code;
  var
    country_puffer:array[1..40] of byte;
  begin
    if suche_country_code_aus_umgebung then exit;
    asm
      push ds
        mov ax,$3800
        mov dx,offset country_puffer
        push ss
        pop ds
        int $21
      pop ds
      mov country_nummer,bx
    end;
  end;
(*$ENDIF*)


procedure setze_sprachzeiger(datenobjekt,zeiger_adresse:pointer);
  type
    quelle_typ=
      record
        vorhanden:sprachen_vorhanden_typ;
        anzahl_elemente:word;
        anfang:string;
      end;

  var
    datenobjekt_longint:longint
    absolute datenobjekt;

    ziel:longint
    absolute zeiger_adresse;

    auswahl:byte;

    lese_zeiger:str_z;
    lese_zeiger_longint:longint
    absolute lese_zeiger;

    schreib_zeiger:^str_z;
    schreib_zeiger_longint:longint
    absolute schreib_zeiger;

    z1:word;
    laenge:byte;

  begin
    bestimme_country_code;

    while str_z(datenobjekt)^<>spra_kennung do
      inc(datenobjekt_longint,1);

    inc(datenobjekt_longint,length(spra_kennung)+1);

    auswahl:=ord(sprache_englisch);

    if quelle_typ(datenobjekt^).vorhanden[sprache_deutsch] then
      if country_nummer in [049 (* BRD *)
                           ,041 (* Schweiz,fr+de *)
                           ,043 (* ™sterreich *)
                           ] then
        auswahl:=ord(sprache_deutsch);

    if quelle_typ(datenobjekt^).vorhanden[sprache_franzoesisch] then
      if country_nummer in [033 (* Frankreich *)
                           ,002 (* Kanada fr. *)
                           ] then
        auswahl:=ord(sprache_franzoesisch);

    if quelle_typ(datenobjekt^).vorhanden[sprache_russisch] then
        if country_nummer in [7  (* Russland *)
                             ] then
          auswahl:=ord(sprache_russisch);

    z1:=1;
    lese_zeiger:=addr(quelle_typ(datenobjekt^).anfang);
    schreib_zeiger:=zeiger_adresse;
    inc(schreib_zeiger_longint,sizeof(schreib_zeiger_longint));

    while z1<=quelle_typ(datenobjekt^).anzahl_elemente*(sizeof(sprachen_vorhanden_typ)-1) do
      begin
        if (z1 mod 4)=auswahl then
          begin
            schreib_zeiger^:=lese_zeiger;
            inc(schreib_zeiger_longint,sizeof(schreib_zeiger_longint));
          end;

        laenge:=length(lese_zeiger^)+1;
        inc(lese_zeiger_longint,laenge);
        inc(z1);
      end;

  end;

end.

