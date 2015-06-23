(*$IfDef DPMIX*)
function bytesuche_codepuffer_0(const s:string):boolean;
  begin
    bytesuche_codepuffer_0:=bytesuche(codepuffer.d[0],s);
  end;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
function bytesuche_codepuffer_0(const s:string):boolean;assembler;
  asm
    push seg codepuffer
      mov ax,offset codepuffer
      inc ax
      inc ax
      push ax

        les di,s
        push es
          push di

            call typ_var.bytesuche_far

  end;
(*$EndIf*)

(*$IfDef VirtualPascal*)
function bytesuche_codepuffer_0(const s:string):boolean;assembler;
  (*$Frame-*)(*$Uses NONE*)
  asm
    push offset codepuffer.d
      push s+4
        call bytesuche
  end;
(*$EndIf*)

(*$IfDef DUMM*)
function bytesuche_codepuffer_0(const s:string):boolean;
  begin
    bytesuche_codepuffer_0:=bytesuche(codepuffer.d[0],s);
  end;
(*$EndIf*)
