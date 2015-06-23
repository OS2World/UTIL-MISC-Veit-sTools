unit vpe_obji;
(* Veit Kannegieser 27.06.1996 *)

interface

type
  (*$IFNDEF VirtualPascal*)
  smallword             =word;
  (*$ENDIF*)

  icons_typ=
    record
      anzahl            :smallword;
      ico_tab           :array[1..100] of
        packed record
          titel         :string[8];
          daten         :packed array[1..512] of byte;
        end;
    end;

  ziel_typ=(spur0,fat,spur0_mit_awardbios,unbekannt);

(*&ORGNAME+*)
procedure ico512_bin                    ;
(*&ORGNAME-*)

const
  icons:^icons_typ=addr(ico512_bin);


implementation

(*$IFDEF VIRTUALPASCAL*)
(*&ORGNAME+*)
procedure ico512_bin                    ;external;(*$L ..\OBJ32\ICO512.OBJ  *)
(*$ORGNAME-*)
(*$ELSE*)
procedure ico512_bin                    ;external;(*$L ..\OBJ16\ICO512.OBJ  *)
(*$ENDIF*)

end.

