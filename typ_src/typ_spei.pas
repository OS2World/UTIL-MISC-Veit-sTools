(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_spei;
(* allgemein gemeinsam genutzter Speicher:
   umd Mehrfachanforderungen zu vermeiden
   und zum Sparen von Stapelspeicher *)

(* genutzt:
   * typ_poem (Dos)
   * typ_xexe (LX Entpacker) 2*4096
   * typ_xexe (NE Entpacker) bis zu 64KB


                                                *)

interface

procedure einrichten_typ_spei(const anfang:boolean);

const
  {$IfDef VirtualPascal}
  groesse_allgemeiner_zwischenspeicher=80*1024;
  {$Else}
  {groesse_allgemeiner_zwischenspeicher=35*512;}
  groesse_allgemeiner_zwischenspeicher=31*512;
  {$EndIf}

type
  allgemeiner_zwischenspeicher_typ=
    packed array[0..groesse_allgemeiner_zwischenspeicher-1] of byte;

var
  allgemeiner_zwischenspeicher:^allgemeiner_zwischenspeicher_typ;

implementation

var
  aaa:allgemeiner_zwischenspeicher_typ;


procedure einrichten_typ_spei(const anfang:boolean);
  begin
    if anfang then
      begin
        (*New(allgemeiner_zwischenspeicher);*)
        allgemeiner_zwischenspeicher:=Addr(aaa);
      end;
  end;

begin
  einrichten_typ_spei(true);
end.

