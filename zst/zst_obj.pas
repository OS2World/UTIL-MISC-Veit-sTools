{$O-}
unit zst_obj;

interface

procedure zst_obj_init;

implementation

uses
  ntab,
  ztab;

{&OrgName+}
procedure ntab_obj;external;
procedure ztab_obj;external;
  {$IfDef VirtualPascal}
  {$L ntab32.obj}
  {$L ztab32.obj}
  {$Else}
  {$L ntab16.obj}
  {$L ztab16.obj}
  {$EndIf}

{&OrgName-}

procedure zst_obj_init;
  begin
    lade_speicher__cp_ntab(Addr(ntab_obj));
    lade_pakete_aus_dem_speicher(Addr(ztab_obj));
  end;

begin
  zst_obj_init;
end.

