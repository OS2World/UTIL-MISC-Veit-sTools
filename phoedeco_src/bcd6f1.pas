(*$S-*)
unit bcd6f1;

interface

procedure entpacke_bcd6f1(var quelle,ziel;const laenge:longint);

implementation

var
  temp                  :array[0..$fee-1] of byte;

procedure entpacke;assembler;(*$Frame-*)(*$Uses All*)
  asm
    cld
    add ecx,esi
    sub edx,edx
    mov ebx,$fee

@F000D85E:

    shr edx,1
    test dx,$100
    jnz @F000D876

    cmp esi,ecx
    je @ende

    lodsb
    mov dl,al
    mov dh,$ff

@F000D876:

    test dl,1
    jz @F000D893

    cmp esi,ecx
    je @ende

    lodsb
    stosb

    mov byte ptr temp[ebx],al
    inc ebx
    and ebx,$0fff
    jmp @F000D85e

@F000D893:

     mov ebp,ebx
     cmp esi,ecx
     je @ende

     lodsb
     movzx ebx,al

     cmp esi,ecx
     je @ende

     lodsb
     push ecx
       mov ecx,eax
       and ecx,$0f
       add ecx,3
       and eax,$00f0
       shl eax,4
       or ebx,eax

@F000D8C0:
       mov al,byte ptr temp[ebx]
       inc ebx
       and ebx,$0fff
       stosb
       mov byte ptr temp[ebp],al
       inc ebp
       and ebp,$0fff
       loop @F000D8C0

       mov ebx,ebp
     pop ecx
     jmp @F000D85E

    @ende:
  end;

procedure entpacke_bcd6f1(var quelle,ziel;const laenge:longint);
  begin
    FillChar(temp,SizeOf(temp),' ');
    (*$Alters ESI,EDI,ECX*)
    asm
      mov esi,[quelle]
      mov edi,[ziel]
      mov ecx,[laenge]
      call entpacke
    end;
  end;

end.

