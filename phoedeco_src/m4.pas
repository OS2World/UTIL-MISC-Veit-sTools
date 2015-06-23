(* LZHUF *)
{&Use32+}
unit m4; (* 20010405 *)

interface

function entpacke_m4(const quelle,ziel;const laenge_eingepackt,laenge_ausgepackt:longint):boolean;

implementation

var
  daten                 :packed array[0..$ffff] of byte;

procedure e5;assembler;
  (*$Frame-*)(*$Uses EAX,ESI*)
  asm

@loc_0_72E0:
                inc     daten[edi+1A27h].smallword
                or      edi, edi
                jz      @loc_0_7351
                mov     ax, daten[edi+1A27h].smallword
                cmp     ax, daten[edi+1A25h].smallword
                jbe     @loc_0_734B
                mov     esi, edi

@loc_0_72F4:
                sub     si, 2
                cmp     ax, daten[esi+1A25h].smallword
                ja      @loc_0_72F4
                test    daten[edi+1F1Dh].smallword, 1
                jz      @loc_0_7311
                movzx   ebx, daten[edi+1531h].smallword
                mov     daten[ebx+103Bh].smallword, si
                mov     daten[ebx+1039h].smallword, si

@loc_0_7311:
                test    daten[esi+1F1Dh].smallword, 1
                jz      @loc_0_7325
                movzx   ebx, daten[esi+1531h].smallword
                mov     daten[ebx+103Bh].smallword, di
                mov     daten[ebx+1039h].smallword, di

@loc_0_7325:
                mov     ax, daten[esi+1531h].smallword
                xchg    ax, daten[edi+1531h].smallword
                mov     daten[esi+1531h].smallword, ax
                mov     ax, daten[esi+1A27h].smallword
                xchg    ax, daten[edi+1A27h].smallword
                mov     daten[esi+1A27h].smallword, ax
                mov     ax, daten[esi+1F1Dh].smallword
                xchg    ax, daten[edi+1F1Dh].smallword
                mov     daten[esi+1F1Dh].smallword, ax
                mov     edi, esi

@loc_0_734B:
                movzx   edi, daten[edi+103Bh].smallword
                jmp     @loc_0_72E0

@loc_0_7351:
  end;


procedure hole_bit;assembler;
  (*$Frame-*)(*$Uses None*)
  asm
                //and     ecx,$0000ffff {?}
@hole_bit00:
                shr     dh, 1
                or      dh, dh
                jnz     @loc_0_7362
                mov     dl, [esi]
                mov     dh, 80h
                inc     esi

@loc_0_7362:
                shl     ax, 1
                test    dl, dh
                jz      @loc_0_736A
                or      al, 1

@loc_0_736A:
                loop    @hole_bit00
  end;


procedure e4;assembler;
  (*$Frame-*)(*$Uses EAX,ESI*)
  asm
                movzx   esi, daten[2413h].smallword
                mov     daten[esi+103Fh].smallword, si
                mov     daten[esi+1535h].smallword, ax
                mov     daten[esi+1A2Bh].smallword, 0
                mov     daten[esi+1F21h].smallword, 0
                mov     daten[esi+103Dh].smallword, si
                mov     bx, daten[esi+1531h].smallword
                mov     daten[esi+1533h].smallword, bx
                mov     ax, daten[esi+1A27h].smallword
                mov     daten[esi+1A29h].smallword, ax
                mov     ax, daten[esi+1F1Dh].smallword
                mov     daten[esi+1F1Fh].smallword, ax
                mov     bx, 4
                add     bx, si
                mov     daten[esi+1531h].smallword, bx
                or      daten[esi+1F1Dh].smallword, 1
                add     daten[2413h].smallword, 4
  end;


procedure e3;assembler;
  (*$Frame-*)(*$Uses EBX,EDI*)
  asm
                xor     edi, edi

@loc_0_73BD:
                shr     dh, 1
                or      dh, dh
                jnz     @loc_0_73CB
                mov     dl, [esi]
                mov     dh, 80h
                inc     esi

@loc_0_73CB:
                movzx   edi, daten[edi+1531h].smallword
                test    dh, dl
                jz      @loc_0_73D6
                sub     di, 2

@loc_0_73D6:
                test    daten[edi+1F1Dh].smallword, 1
                jnz     @loc_0_73BD
                mov     ax, daten[edi+1531h].smallword
                cmp     ax, 176h
                jnb     @loc_0_7416
                cmp     ax, 0FFh
                jbe     @loc_0_7416
                mov     ecx, 8
                cmp     ax, 100h
                jz      @loc_0_73FC
                mov     ecx, 6
                cmp     ax, 101h
                jnz     @loc_0_7416

@loc_0_73FC:
                push    cx
                xor     ax, ax
                call    hole_bit
                pop     cx
                cmp     cl, 6
                jnz     @loc_0_740B
                add     ax, 102h

@loc_0_740B:
                movzx   edi, ax
                shl     di, 1
                call    e4
                movzx   edi, daten[2413h].smallword

@loc_0_7416:
                call    e5
  end;


procedure e6;assembler;
  (*$Frame-*)(*$Uses EAX,EDI*)
  asm
                xor     eax, eax
                mov     ecx, 8
                call    hole_bit
                movzx   edi, ax
                movzx   ebp, daten[edi+2415h].byte
                shl     bp, 6
                movzx   ecx, daten[edi+2515h].byte
                or      ecx, ecx
                jz      @loc_0_743C
                call    hole_bit

@loc_0_743C:
                and     eax, 3Fh
                or      ax, bp
                mov     bp, bx
                sub     bp, ax
  end;


procedure erzeuge_huff;
  (*$Frame+*)(*$Uses ALL*)
  const
    kennung     =Ord('H')+Ord('U') shl 8+Ord('F') shl 16+Ord('F') shl 24;
    word_0_7448 :packed array[1..9] of packed record b:byte;anzahl:word end=
                ((b:5;anzahl: 8),
                 (b:3;anzahl: 8),
                 (b:2;anzahl:16),
                 (b:5;anzahl:32),
                 (b:0;anzahl:64),
                 (b:4;anzahl:16),
                 (b:2;anzahl:16),
                 (b:3;anzahl:32),
                 (b:5;anzahl:64));

    byte_0_745A:packed array[1..10] of packed record von,bis,anzahl:byte end=
                ((von:$3E;bis:$40;anzahl:  2),
                 (von:$3C;bis:$3E;anzahl:  2),
                 (von:  3;bis:  4;anzahl:  8),
                 (von:  1;bis:  2;anzahl:$10),
                 (von:$0C;bis:$1C;anzahl:  2),
                 (von:  0;bis:  1;anzahl:$40),
                 (von:  8;bis:$0C;anzahl:  4),
                 (von:  2;bis:  3;anzahl:$10),
                 (von:  4;bis:  8;anzahl:  8),
                 (von:$1C;bis:$3C;anzahl:  2));

  var
    zaehler,ziel        :longint;
    zeichen             :byte;

  begin
    if MemL[Ofs(daten)+$2615]=kennung then Exit;

    ziel:=Ofs(daten[$2515]);
    for zaehler:=Low(word_0_7448) to High(word_0_7448) do
      with word_0_7448[zaehler] do
        begin
          FillChar(Mem[ziel],anzahl,b);
          Inc(ziel,anzahl);
        end;


    ziel:=Ofs(daten[$2415]);
    for zaehler:=Low(byte_0_745A) to High(byte_0_745A) do
      with byte_0_745A[zaehler] do
        begin
          zeichen:=von;
          while zeichen<bis do
            begin
              FillChar(Mem[ziel],anzahl,zeichen);
              Inc(zeichen);
              Inc(ziel,anzahl);
            end;
        end;

    MemL[Ofs(daten)+$2615]:=kennung;

  end;


procedure e1;
  (*$Frame-*)(*$Uses ALL*)
  const
    word_0_74BE:array[1..4] of array[1..5] of smallword=
      (($FFFF,0,   0,   2,   2),
       (    4,8,$100,$101,$102),
       (    3,2,   1,   1,   1),
       (    1,1,   0,   0,   0));
  begin
    Move(word_0_74BE[1],daten[$103B],10);
    Move(word_0_74BE[2],daten[$1531],10);
    Move(word_0_74BE[3],daten[$1A27],10);
    Move(word_0_74BE[4],daten[$1F1D],10);
    MemW[Ofs(daten)+$2413]:=8;
  end;

procedure entpacker;assembler;
  (*$FRAME-*)(*$Uses ALL*)
  asm
    cld
                xor     edx, edx

                push    edi
                push    esi
                mov     eax, 0
                mov     edi, offset daten
                mov     ecx, $3F1
                repe stosd
                pushad
                call    e1
                call    erzeuge_huff
                popad
                pop     esi
                pop     edi

                mov     ebx, 4036

@loc_0_7545:
                call    e3
                or      ah, ah
                jnz     @loc_0_7559
                stosb
                mov     daten[ebx+0].byte, al
                inc     bx
                and     bx, 0FFFh
                jmp     @loc_0_7545

@loc_0_7559:
                cmp     ax, 102h
                jz      @loc_0_7585
                call    e6
                dec     bp
                sub     ax, 100h
                xor     ecx, ecx

@loc_0_7567:
                cmp     cx, ax
                jnb     @loc_0_7545
                push    ax
                and     ebp, 0FFFh
                mov     al, daten[ebp+0].byte
                stosb
                mov     daten[ebx+0].byte, al
                inc     bp
                inc     cx
                inc     bx
                and     ebx, 0FFFh
                pop     ax
                jmp     @loc_0_7567

@loc_0_7585:
  end;

function entpacke_m4(const quelle,ziel;const laenge_eingepackt,laenge_ausgepackt:longint):boolean;
  begin
    asm (*$Alters ESI,EDI*)
      mov esi,quelle
      mov edi,ziel
      call entpacker
    end;
    entpacke_m4:=true;
  end;

end.
