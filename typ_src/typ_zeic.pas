 (*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_zeic; (* Zeichensatzumwandlung *)
(* 2001.06.29 V.K. *)

(*&Use32+*)

interface

uses
  utf8,
  typ_type,
  unidef,
  zst,
  zst_obj,
  ztab,
  ntab;

var
  konverter_iso_8859_1:zeichensatzumformung_8_8;

procedure einrichten_typ_zeic(const anfang:boolean);
function uc16_puffer_zu_zk_e(const p;const e:string;maxl:integer_norm):string;
procedure erzeuge_8_8_tabelle(const zeichensatzname:string;var t:zeichensatzumformung_8_8);
function utf8_zu_zk(const source:string):string;
function cp1004_zu_zk(const source:string):string;

implementation


var
  uc16_8                :zeichensatzumformung_16_8;

procedure einrichten_typ_zeic(const anfang:boolean);
  begin
    if anfang then
      begin
        zst_obj_init;
        berechne_umrechnungstabelle_16_8(0,uc16_8);
        erzeuge_8_8_tabelle('ISO-8859-1',konverter_iso_8859_1);
      end;
  end;

(*
function uc16_puffer_zu_zk_e(const p;const e:string;maxl:integer_norm):string;
  var
    p1                  :array[0..512] of byte absolute p;
    p0                  :array[0..512] of byte;
    zaehler             :word_norm;
  begin
    if maxl>255 then
      maxl:=255;

    for zaehler:=0 to maxl do
      p0[zaehler]:=p1[zaehler*2];

    uc16_puffer_zu_zk_e:=puffer_zu_zk_e(p0,e,maxl);
  end;*)

function uc16_puffer_zu_zk_e(const p;const e:string;maxl:integer_norm):string;
  {$IfNDef VirtualPascal}
  var
    result:string;
  {$EndIf}
  begin
    if maxl>255 then
      maxl:=255;

    umformung_16l_8(UniCharArray(p),Result,uc16_8,maxl);
    {$IfNDef VirtualPascal}
    uc16_puffer_zu_zk_e:=result;
    {$EndIf}
  end;

procedure erzeuge_8_8_tabelle(const zeichensatzname:string;var t:zeichensatzumformung_8_8);
  var
    n:word_norm;
  begin
    berechne_zs_nummer(zeichensatzname,n);
    berechne_umrechnungstabelle_8_8(n,0,t);
  end;

function utf8_zu_zk(const source:string):string;
  var
    temp                :pUniCharArray;
    {$IfNDef VirtualPascal}
    result              :string;
    {$EndIf}
  begin
    (* read 8->16 *)
    read_utf8(source,temp);

    (* convert 16->8 *)
    umformung_16_8(temp^,Result,{cp_converter}uc16_8);

    (* free buffer *)
    FreeUniCharArray(temp^);

    {$IfNDef VirtualPascal}
    utf8_zu_zk:=result;
    {$EndIf}
  end;

function cp1004_zu_zk(const source:string):string;
  {$IfNDef VirtualPascal}
  var
    result:string;
  {$EndIf}
  begin
    umformung_8_8(source,Result,konverter_iso_8859_1);
    {$IfNDef VirtualPascal}
    cp1004_zu_zk:=result;
    {$EndIf}
  end;


(* $IfDef VirtualPascal* )
initialization
  einrichten_typ_zeic(true);
finalization
  einrichten_typ_zeic(false);
( *$EndIf VirtualPascal*)
end.

