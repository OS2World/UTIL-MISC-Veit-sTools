(* LZARI *)
{$S-}{&Use32+}
unit m2;

interface

procedure entpacke_m2(var quelle,ziel;const laenge:longint);

const
  fuellbyte             :byte=$20;

implementation

var
  d_0                   :longint;
  d_4                   :longint;
  d_8                   :longint;
  d_c                   :longint;
  tw_10                 :array[0..$13a-1] of longint;
  tw_284                :array[0..$13b-1] of longint;
  tw_4fa                :array[0..$13b-1] of longint;
  tw_770                :array[0..$13a-1] of longint;
  w_9e4                 :longint;
  tw_9e6                :array[0..$fff] of longint;
  w_29e6                :longint;
  tb_29e8               :array[0..$fc4-1+10000] of byte;

  gs_                   :smallword;


procedure getbit_ax;assembler;(*$Frame-*)(*$Uses EBX*)
  asm
    mov     bx, gs_
    shr     bl, 1
    jnz     @noch_was_uebrig

    lodsb
    mov     bh, al
    mov     bl, $80

@noch_was_uebrig:
    mov     gs_, bx
    test    bl, bh
    setnz   al
    and     eax,1
  end;

procedure auspacken_3;assembler;(*$Frame-*)(*$Uses EAX,EBX,EDX,ESI*)
  asm
    xor     ebx, ebx
    mov     esi, ebx
    xor     eax, eax
    mov     w_9e4, eax
    mov     esi, $13A

@loc_0_6820:
    mov     ebx, esi
    dec     ebx
    mov     dword ptr tw_10[ebx*4], esi
    mov     dword ptr tw_284[esi*4], ebx
    mov     dword ptr tw_4fa[esi*4], 1
    mov     eax,dword ptr tw_770[esi*4]
    inc     eax
      and   eax, $ffff
    dec     esi
    mov     dword ptr tw_770[esi*4], eax
    cmp     esi, 1
    jnb     @loc_0_6820
    xor     eax, eax
    mov     dword ptr tw_4fa[0*4], eax
    xor     eax, eax
    mov     w_29e6, eax
    mov     esi, $1000

@loc_0_6861:
    mov     eax, 10000
    mov     ebx, esi
    add     ebx, 200
    xor     edx, edx
    div     ebx
    add     eax, dword ptr tw_9e6[esi*4]
      and   eax, $ffff
    dec     esi
    mov     dword ptr tw_9e6[esi*4], eax
    cmp     esi, 1
    jnb     @loc_0_6861

  end;

procedure auspacken_6;assembler;(*$Frame-*)(*$Uses EAX,EBX,ECX,EDX,ESI,EDI,EBP*)
  asm
    xor     ebx, ebx
    mov     esi, ebx
    mov     ecx, eax
    cmp     dword ptr tw_770[0*4], $7FFF
    jb      @loc_0_68CD

    xor     ebp, ebp
    mov     esi, $13A

@loc_0_68A9:
    mov     dword ptr tw_770[esi*4], ebp
    mov     eax, dword ptr tw_4fa[esi*4]
    inc     eax
      and   eax, $ffff
    shr     eax, 1
    mov     dword ptr tw_4fa[esi*4], eax
    add     ebp, eax
      and   ebp, $ffff
    dec     esi
    jnz     @loc_0_68A9
    mov     dword ptr tw_770[0*4], ebp

@loc_0_68CD:
    mov     esi, ecx

@loc_0_68CF:
    dec     esi{}
      and   esi, $ffff
    mov     eax, dword ptr tw_4fa[esi*4]
    inc     esi
      and   esi, $ffff
    cmp     dword ptr tw_4fa[esi*4], eax
    jnz     @loc_0_68E6
    dec     esi
      and   esi, $ffff
    jmp     @loc_0_68CF

@loc_0_68E6:
    cmp     esi, ecx
    jnb     @loc_0_6920
    mov     edx, dword ptr tw_284[esi*4]
    mov     ebx, ecx
    mov     edi, dword ptr tw_284[ebx*4]
    mov     dword ptr tw_284[esi*4], edi
    mov     dword ptr tw_284[ebx*4], edx
    mov     ebx, edx
    mov     dword ptr tw_10[ebx*4], ecx
    mov     ebx, edi
    mov     dword ptr tw_10[ebx*4], esi

@loc_0_6920:
    inc     dword ptr tw_4fa[esi*4]
      and   dword ptr tw_4fa[esi*4], $ffff

@loc_0_6928:
    {sub     esi, 1}
    sub     si, 1
    jb      @loc_0_6937
    inc     dword ptr tw_770[esi*4]
      and   dword ptr tw_770[esi*4], $ffff
    jmp     @loc_0_6928

@loc_0_6937:
  end;



procedure auspacken_5;assembler;(*$Frame-*)(*$Uses EBX,ECX,EDX,ESI*)
  asm
    xor     ebx, ebx
    mov     ecx, eax
    mov     esi, 1
    mov     edx, $13A

@loc_0_6951:
    cmp     esi, edx
    jnb     @loc_0_696E
    mov     ebx, esi
    add     ebx, edx
      and   ebx, $ffff
    shr     ebx, 1
    cmp     dword ptr tw_770[ebx*4], ecx
    jbe     @loc_0_696A
    mov     esi, ebx
    inc     esi
      and   esi, $ffff
    jmp     @loc_0_696C

@loc_0_696A:
    mov     edx, ebx

@loc_0_696C:
    jmp     @loc_0_6951

@loc_0_696E:
    mov     eax, esi
  end;

procedure auspacken_8;assembler;(*$Frame-*)(*$Uses EBX,ECX,EDX,ESI*)
  asm
    xor     ebx, ebx
    mov     ecx, eax
    mov     esi, 1
    mov     dx, $1000

@loc_0_6986:
    cmp     esi, edx
    jnb     @loc_0_69A3
    mov     ebx, esi
    add     ebx, edx
      and   ebx, $ffff
    shr     ebx, 1
    cmp     dword ptr tw_9e6[ebx*4], ecx
    jbe     @loc_0_699F
    mov     esi, ebx
    inc     esi
      and   esi, $ffff
    jmp     @loc_0_69A1

@loc_0_699F:
    mov     edx, ebx

@loc_0_69A1:
    jmp     @loc_0_6986


@loc_0_69A3:
    mov     eax, esi
    dec     eax
      and   eax, $ffff
  end;

procedure bits_17;assembler;(*$Frame-*)(*$Uses EAX,ECX*)
  asm
    mov     ecx, 17
@sl1:
    shl     d_c, 1
    xor     eax, eax
    call    getbit_ax
    add     d_c, eax
    loop    @sl1
  end;

procedure auspacken_4;assembler;(*$Frame-*)(*$Uses EBX,ECX,EDX,EDI,EBP*)
  asm
    xor     ebx, ebx
    mov     edi, d_8
    sub     edi, d_4
    mov     eax, d_c
    sub     eax, d_4
    inc     eax
    mov     ecx, dword ptr tw_770[0*4]
    mul     ecx
    dec     eax
    xor     edx, edx
    div     edi
    call    auspacken_5
    mov     ebx, eax
    dec     ebx
      and   ebx, $ffff
    mov     eax, dword ptr tw_770[ebx*4]
    inc     ebx
      and   ebx, $ffff
    mul     edi
    mov     ebp, ecx
    xor     edx, edx
    div     ebp
    add     eax, d_4
    mov     d_8, eax
    mov     eax, dword ptr tw_770[ebx*4]
    mul     edi
    mov     ebp, ecx
    xor     edx, edx
    div     ebp
    add     d_4, eax

@loc_0_6A3C:
    cmp     d_4, $10000
    jb      @kleiner_64k
    sub     d_c, $10000
    sub     d_4, $10000
    sub     d_8, $10000
    jmp     @loc_0_6AA4

@kleiner_64k:
    cmp     d_4, $8000
    jb      @loc_0_6A97
    cmp     d_8, $18000
    ja      @loc_0_6A97

@loc_0_6A7A:
    sub     d_c, $8000
    sub     d_4, $8000
    sub     d_8, $8000
    jmp     @loc_0_6AA4

@loc_0_6A97:
    cmp     d_8, $10000
    jbe     @loc_0_6AA4
    jmp     @loc_0_6AC1

@loc_0_6AA4:
    shl     d_4, 1
    shl     d_8, 1
    shl     d_c, 1
    xor     eax, eax
    call    getbit_ax
    add     d_c, eax
    jmp     @loc_0_6A3C

@loc_0_6AC1:
    mov     ecx, dword ptr tw_284[ebx*4]
    mov     eax, ebx
    call    auspacken_6
    mov     eax, ecx
  end;

procedure auspacken_7;assembler;(*$Frame-*)(*$Uses EBX,ECX,EDX,EDI,EBP*)
  asm
    xor     ebx, ebx
    mov     edi, d_8
    sub     edi, d_4
    mov     eax, d_c
    sub     eax, d_4
    inc     eax
    mov     ecx, dword ptr tw_9e6[0*4]
    mul     ecx
    dec     eax
    xor     edx, edx
    div     edi
    call    auspacken_8
    mov     ebx, eax
    mov     eax, dword ptr tw_9e6[ebx*4]
    mul     edi
    mov     ebp, ecx
    xor     edx, edx
    div     ebp
    add     eax, d_4
    mov     d_8, eax
    inc     ebx{}
      and   ebx, $ffff
    mov     eax, dword ptr tw_9e6[ebx*4]
    dec     ebx
      and   ebx, $ffff
    mul     edi
    mov     ebp, ecx
    xor     edx, edx
    div     ebp
    add     d_4, eax

@loc_0_6B4F:
    cmp     d_4, $10000
    jb      @loc_0_6B77
    sub     d_c, $10000
    sub     d_4, $10000
    sub     d_8, $10000
    jmp     @loc_0_6BB7

@loc_0_6B77:
    cmp     d_4, $8000
    jb      @loc_0_6BAA
    cmp     d_8, $18000
    ja      @loc_0_6BAA
    sub     d_c, $8000
    sub     d_4, $8000
    sub     d_8, 8000h
    jmp     @loc_0_6BB7

@loc_0_6BAA:
    cmp     d_8, $10000{}
    jbe     @loc_0_6BB7
    jmp     @loc_0_6BD4

@loc_0_6BB7:
    shl     d_4, 1
    shl     d_8, 1
    shl     d_c, 1
    xor     eax, eax
    call    getbit_ax
    add     d_c, eax
    jmp     @loc_0_6B4F

@loc_0_6BD4:
    mov     eax, ebx
      and   eax, $ffff
  end;

procedure auspacken_2;assembler;(*$Frame+*)(*$Uses ALL,EFL*)
  var
    index               :longint;
    var_6               :longint;
    var_4               :longint;
    var_2               :longint;
  asm
    cld
    xor     eax, eax
    mov     d_0, eax
    mov     d_4, eax
    mov     d_8, $20000
    mov     d_c, eax
    mov     [gs_], ax

    lodsd
    mov     d_0, eax
    or      eax, eax
    jz      @auspacken_fertig

    call    bits_17
    call    auspacken_3
    mov     [index], $0FC4
    xor     ecx, ecx

@weiter_auspacken:
    call    auspacken_4
    mov     edx, eax
    cmp     edx, $100
    jnb     @loc_0_6C60
    mov     al, dl
    stosb
    mov     ebx, [index]
    mov     byte ptr tb_29e8[ebx], dl
    inc     [index]
    and     [index], $0FFF
    inc     ecx
    jmp     @pruefe_laenge

@loc_0_6C60:
    call    auspacken_7
    mov     ebx, [index]
    sub     ebx, eax
    dec     ebx
    and     ebx, $0FFF
    mov     [var_2], ebx
    mov     eax, edx
    add     eax, 2
    sub     eax, $0FF
    mov     [var_4], eax
    mov     [var_6], 0

@loc_0_6C80:
    mov     eax, [var_6]
    cmp     eax, [var_4]
    jnb     @pruefe_laenge
    mov     ebx, [var_2]
    add     ebx, [var_6]
    and     ebx, $0FFF
    mov     dl, byte ptr tb_29e8[ebx]
    mov     al, dl
    stosb
    mov     ebx, [index]
    mov     byte ptr tb_29e8[ebx], dl
    inc     [index]
    and     [index], $0FFF
    inc     ecx
    inc     [var_6]
    jmp     @loc_0_6C80

@pruefe_laenge:
    cmp     ecx, d_0
    jb      @weiter_auspacken

@auspacken_fertig:
  end;


procedure entpacke_m2(var quelle,ziel;const laenge:longint);
  begin
    FillChar(tw_10  ,SizeOf(tw_10  ),0);
    FillChar(tw_284 ,SizeOf(tw_284 ),0);
    FillChar(tw_4fa ,SizeOf(tw_4fa ),0);
    FillChar(tw_770 ,SizeOf(tw_770 ),0);
    w_9e4:=0;
    FillChar(tw_9e6 ,SizeOf(tw_9e6 ),0);
    w_29e6:=0;
    FillChar(tb_29e8,SizeOf(tb_29e8),fuellbyte);

    asm(*$Alters ESI,EDI,ECX*)
      mov esi,quelle
      mov edi,ziel
      mov ecx,laenge
      call auspacken_2
    end;

  end;

end.

