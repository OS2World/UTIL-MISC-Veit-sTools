{&Use32+}
(* LZSS *)
unit m3; (* P14-0095.BI6, 2002.07.30 *)

interface

procedure entpacke_m3(const quelle,ziel;const laenge:longint);

const
  fuellbyte:byte        =$20;

implementation

var
  fs_                   :array[0..$fff] of byte;

procedure entpacke_m3(const quelle,ziel;const laenge:longint);assembler;
  {&Frame-}{&Uses All}
  asm
    cld
    mov edi,Offset fs_
    mov ecx,Type fs_
    mov al,fuellbyte
    rep stosb

    mov esi,quelle
    mov edi,ziel
    mov ecx,laenge
    add ecx,esi
    xor edx,edx
    mov ebx,$FEE
    cld

@sl1:
    shr edx,1
    test edx,$100
    jnz @lf1
    cmp esi,ecx
    je @exit

    lodsb
    mov dl,al
    mov dh,$FF

@lf1:
    test dl,$01
    jz @lf2
    cmp esi,ecx
    je @exit
    lodsb
    stosb
    mov fs_[ebx].byte,al
    inc ebx
    and ebx,$0FFF
    jmp @sl1


@lf2:
    mov ebp,ebx
    cmp esi,ecx
    je @exit
    lodsb
    movzx ebx,al
    cmp esi,ecx
    je @exit
    lodsb
    push ecx
      mov cl,al
      and cl,$0F
      add cl,3
      movzx ecx,cl
      and eax,$F0
      shl ax,4                  // bug ?
      or ebx,eax

@sl2:
      mov al,fs_[ebx].byte
      inc ebx
      and ebx,$0FFF
      xchg ebx,ebp
      stosb
      mov fs_[ebx].byte,al
      inc ebx
      and ebx,$0FFF
      xchg ebx,ebp
      loop @sl2

      mov ebx,ebp
    pop ecx
    jmp @sl1

@exit:

  end;
end.
