(*$I TYP_COMP.PAS*)
unit buschsuc; (* 19991115 *)

interface

uses
  typ_type;

procedure busch_suche(const busch;const puffer);

implementation

uses
  typ_ausg,
  typ_var;

(*$IFDEF DOS_ODER_DPMI*)
(*$S-*)
procedure busch_suche_ds(const busch:word;const puffer:word;const ds_:word);assembler;
  (* Žndert "alles" auáer DS/ES *)
  asm
    mov si,busch
    mov dx,si
    mov di,puffer

    mov al,[si]
    mov ah,es:[di]

    cmp al,0
    jne @nicht_block_typ_0

    (* Blocktyp 0 : Tabelle *)

    inc di

    cmp ah,'?'
    je @nicht_2mal_fragezeichen

    shr ax,8
    shl ax,1
    inc ax
    add si,ax
    mov ax,[si]
    or ax,ax
    jz @versuche_fragezeichen

    pusha
      add ax,dx
      push ax
        push di
          push ds_
            call busch_suche_ds
    popa

  @nicht_2mal_fragezeichen:
  @versuche_fragezeichen:

    mov si,dx
    add si,1+'?'*2
    mov ax,[si]
    or ax,ax
    jz @ret

    add ax,dx
    push ax
      push di
        push ds_
          call busch_suche_ds

    jmp @ret


  @nicht_block_typ_0:

    (* Blocktyp 1 *)

    cmp al,1
    jne @nicht_block_typ_1

    (* cx:=Anzahl Eintr„ge *)
    mov cx,[si+1]

    (* 1 Byte Typ, 2 Byte Anzahl Eintr„ge *)
    add si,3

  @schleife:
    (* bx:=Position der n„chsten Suchfolge : si+Length(sig)+1+SizeOf(offs) *)
    sub bx,bx
    mov bl,[si]
    lea bx,[si+1+bx+2]

    mov al,[si+1]
    mov ah,es:[di]
    cmp al,ah
    je @vergleich

    cmp al,'?'
    jne @naechster

  @vergleich:

    pusha
      push ds

        push es
          push di

            push ds
              push si

                push ds_
                pop ds

                call typ_var.bytesuche_far

        or al,al

      pop ds
    popa

    jz @naechster

    (* Suchfolge gefunden -> Zweig weiterverfolgen *)
    pusha
      (* Position in puffer weiterrcken *)
      sub ax,ax
      mov al,[si]
      add di,ax

      mov si,bx

      (* mit neuem Block anfangen *)
      mov ax,[si-2]
      add ax,dx
      push ax
        push di
          push ds_
            call busch_suche_ds
    popa

  @naechster:

    mov si,bx
    loop @schleife

    jmp @ret

  @nicht_block_typ_1:

    cmp al,2
    jne @nicht_block_typ_2

    (* ausschrift(zk,attr) *)
    inc si
    push ds                             (* verbogenes ds sichern *)

      push ds                           (* Zeichenkette *)
        push si

          sub ax,ax                     (* Attribut *)
          mov al,[si]
          inc ax
          add si,ax
          push word ptr [si]

            push ds_                    (* TP DSEG *)
            pop ds

            call ausschrift_far

    pop ds

    jmp @ret

  @nicht_block_typ_2:

    cmp al,3
    jne @nicht_block_typ_3

    (* cx:=Anzahl Eintr„ge *)
    sub cx,cx
    mov cl,[si+1]

    (* 1 Byte Typ, 1 Byte Anzahl Eintr„ge *)
    add si,2

  @schleife_t3:
    (* bx:=Position des Namens *)
    sub bx,bx
    mov bl,[si]
    lea bx,[si+1+bx]

    mov al,[si+1]
    mov ah,es:[di]
    cmp al,ah
    je @vergleich_t3

    cmp al,'?'
    jne @naechster_t3

  @vergleich_t3:

    pusha
      push ds

        push es
          push di

            push ds
              push si

                push ds_
                pop ds

                call typ_var.bytesuche_far

        or al,al

      pop ds
    popa

    jz @naechster_t3

    (* Suchfolge gefunden -> Ausschrift *)
    pusha
      (* si:=Ofs(Programmname) *)
      mov si,bx

      push ds                           (* verbogenes ds sichern *)

        push ds                         (* Zeichenkette *)
          push si

            sub ax,ax                   (* Attribut *)
            mov al,[si]
            inc ax
            add si,ax
            push word ptr [si]

              push ds_                  (* TP DSEG *)
              pop ds

              call ausschrift_far

      pop ds

    popa

  @naechster_t3:

    mov si,bx
    sub ax,ax
    mov al,[si]                         (* Titell„nge *)
    inc ax                              (* L„ngenbyte *)
    inc ax                              (* Attribut   *)
    add si,ax
    loop @schleife_t3

    jmp @ret


  @nicht_block_typ_3:
    int 3
    jmp @nicht_block_typ_3

  @ret:

  end;
procedure busch_suche(const busch;const puffer);assembler;
  asm
    mov ax,ds
    push ax

      mov ds,word ptr busch+2
      mov es,word ptr puffer+2

      push word ptr busch
        push word ptr puffer
          push ax
            call busch_suche_ds
    pop ds
  end;
(*$ENDIF*)

(*$IFDEF VIRTUALPASCAL*)
procedure busch_suche(const busch;const puffer);assembler;
  (*$FRAME+*)(*$USES ALL*)
  asm
    mov esi,busch
    mov edx,esi
    mov edi,puffer

    mov al,[esi]
    mov ah,[edi]

    cmp al,0
    jne @nicht_block_typ_0

    (* Blocktyp 0 : Tabelle *)

    inc edi

    cmp ah,'?'
    je @nicht_2mal_fragezeichen

    movzx eax,ah
    lea esi,[esi+1+eax*2]
    movzx eax,word [esi]
    or eax,eax
    jz @versuche_fragezeichen

    add eax,edx
    push eax
      push edi
        call busch_suche

  @nicht_2mal_fragezeichen:
  @versuche_fragezeichen:

    mov esi,edx
    add esi,1+'?'*2
    movzx eax,word [esi]
    or eax,eax
    jz @ret

    add eax,edx
    push eax
      push edi
        call busch_suche

    jmp @ret


  @nicht_block_typ_0:

    (* Blocktyp 1 *)

    cmp al,1
    jne @nicht_block_typ_1

    (* cx:=Anzahl Eintr„ge *)
    movzx ecx,word [esi+1]

    (* 1 Byte Typ, 2 Byte Anzahl Eintr„ge *)
    add esi,3

  @schleife:
    (* bx:=Position der n„chsten Suchfolge : si+Length(sig)+1+SizeOf(offs) *)
    movzx ebx,byte [esi]
    lea ebx,[esi+1+ebx+2]

    mov al,[esi+1]
    mov ah,[edi]
    cmp al,ah
    je @vergleich

    cmp al,'?'
    jne @naechster

  @vergleich:

    pushad

      push edi
        push esi
          call typ_var.bytesuche

      or al,al

    popad

    jz @naechster

    (* Suchfolge gefunden -> Zweig weiterverfolgen *)
    pushad
      (* Position in puffer weiterrcken *)
      movzx eax,byte [esi]
      add edi,eax

      mov esi,ebx

      (* mit neuem Block anfangen *)
      movzx eax,word [esi-2]
      add eax,edx
      push eax
        push edi
          call busch_suche
    popad

  @naechster:

    mov esi,ebx
    loop @schleife

    jmp @ret

  @nicht_block_typ_1:

    cmp al,2
    jne @nicht_block_typ_2

    (* ausschrift(zk,attr) *)
    inc esi

      push esi                          (* Zeichenkette *)

        movzx eax,byte [esi]            (* Attribut *)
        lea esi,[esi+1+eax]
          push dword [esi]

            call ausschrift


    jmp @ret


  @nicht_block_typ_2:

    cmp al,3
    jne @nicht_block_typ_3

    (* cx:=Anzahl Eintr„ge *)
    sub ecx,ecx
    mov cl,[esi+1]

    (* 1 Byte Typ, 1 Byte Anzahl Eintr„ge *)
    inc esi
    inc esi

  @schleife_t3:
    (* ebx:=Position des Namens *)
    sub ebx,ebx
    mov bl,[esi]
    lea ebx,[esi+1+ebx]

    mov al,[esi+1]
    mov ah,[edi]
    cmp al,ah
    je @vergleich_t3

    cmp al,'?'
    jne @naechster_t3

  @vergleich_t3:

    pushad

      push edi
        push esi
          call typ_var.bytesuche

      or al,al

    popad

    jz @naechster_t3

    (* Suchfolge gefunden -> Ausschrift *)
    pushad
      (* si:=Ofs(Programmname) *)
      mov esi,ebx

      push esi                          (* Zeichenkette *)

        sub eax,eax                     (* Attribut *)
        mov al,[esi]
        inc eax
        add esi,eax
        push dword ptr [esi]

          call ausschrift


    popad

  @naechster_t3:

    mov esi,ebx
    sub eax,eax
    mov al,[esi]                        (* Titell„nge *)
    lea esi,[esi+1+eax+1]               (* L„ngenbyte + Attribut *)
    loop @schleife_t3

    jmp @ret


  @nicht_block_typ_3:
    int 3
    jmp @nicht_block_typ_3


  @ret:
  end;

(*$ENDIF*)


end.
