Title   String input field

;***************************************************************************
; Eingabe
;   CS=DS
;   DI=Zeichenkettenvariable
; Ausgabe
;   Wert der Variable mîglicherweise verÑndert
;
a_proc                          zeichenketteneingabe
                                push es
                                pusha

                                  push cs
                                  pop es

                                  mov al,[farbe]
                                  push ax

                                    call liefere_cursorform
                                    push ax

                                      ; mit neuer Zeile anfangen wenn nîtig
                                      pusha
                                        mov ah,003h
                                        mov bh,0
                                        int 010h
                                        mov al,10
                                        cmp dl,0 ; Spalte 1 ?
                                        if_ne <call ausschrift_zeichen>
                                      popa

                                      ; maximale LÑnge der Zeichenkette (bx)
                                      mov bx,[di].anzahl_einstellungen

                                      ; die Zeichenkette selbst (si)
                                      call mov_ax_di_zeichenketteninhalt
                                      mov si,ax

                                      ; aktuelle LÑnge (dx)
                                      movzx dx,[si]
                                      inc si

                                      ; Cursor (bp)
                                      mov bp,dx
                                      call frage_ob_ueberschreibmodus
                                      if_z <null bp>

                                      ; LÑnge1->Pos1
                                      cmp dx,1
                                      if_e <null bp>

    zeichenketteneingabe_schleife:

                                      ; Anzeige ---------------------
                                      ; '['
                                      mov [farbe],00fh
                                      mov al,13
                                      call ausschrift_zeichen
                                      mov al,'['
                                      call ausschrift_zeichen


                                      mov [farbe],007h
                                      push cx
                                        mov cx,bx
                                        call ausschrift_l_cx
                                      pop cx

                                      ; ']'
                                      mov [farbe],00fh
                                      mov al,']'
                                      call ausschrift_zeichen

                                      ; Cursor setzten
                                      pusha
                                        push bp
                                          mov ah,003h; WhereX/Y
                                          mov bh,000h; Seite 0
                                          int 010h
                                        pop ax
                                        mov ah,002h  ; GotoXY
                                        mov dl,al    ; X
                                        inc dl
                                        int 010h

                                      popa

                                      call setze_einfuege_ueberschreibcursor
                                      ;------------------------------

                                      call taste

                                      ;------------------------------
                                      cmp al,00dh
                                      je zeichenketteneingabe_ende
                                      ;------------------------------

                                      ;------------------------------
                                      cmp al,008h
                                      jne nicht_zke_rueckloeschen
                                      test bp,bp ; cursor=0 ?
                                      jz zeichenketteneingabe_schleife

    zke_loeschen_entfernen_gemeinsam:
                                      push si
                                        add si,bp       ; si=cursor
                                        mov di,si       ; di=cursor-1
                                        dec di
                                        mov cx,bx       ; Max-aktuell
                                        sub cx,bp
                                        cld
                                        rep movsb
                                        mov byte ptr [di],' '
                                        dec bp          ; Dec(cursor)
                                        dec dx          ; Dec(LÑnge)
                                      pop si
                                      jmp zeichenketteneingabe_schleife
    nicht_zke_rueckloeschen:
                                      ;------------------------------


                                      ;------------------------------
                                      cmp ax,04b00h
                                      jne nicht_zke_links

                                      test bp,bp
                                      if_ne <dec bp>
                                      jmp zeichenketteneingabe_schleife
    nicht_zke_links:
                                      ;------------------------------


                                      ;------------------------------
                                      cmp ax,04d00h
                                      jne nicht_zke_rechts

                                      cmp dx,bp ; Cursor<>LÑnge ?
                                      if_ne <inc bp>

                                      jmp zeichenketteneingabe_schleife

    nicht_zke_rechts:
                                      ;------------------------------


                                      ;------------------------------
                                      cmp ax,05300h
                                      jne nicht_entfernen

                                      cmp dx,bp ; Cursor<>LÑnge
                                      je zeichenketteneingabe_schleife1
                                      inc bp
                                      jmp zke_loeschen_entfernen_gemeinsam
    nicht_entfernen:
                                      ;------------------------------


                                      ;------------------------------
                                      cmp ax,04700h
                                      jne nicht_zke_pos1

                                      null bp
                                      jmp zeichenketteneingabe_schleife
    nicht_zke_pos1:
                                      ;------------------------------


                                      ;------------------------------
                                      cmp ax,04f00h
                                      jne nicht_zke_ende

                                      mov bp,dx
                                      jmp zeichenketteneingabe_schleife
    nicht_zke_ende:
                                      ;------------------------------



                                      ;------------------------------
                                      ; keine Steuerzeichen (Esc,..)
                                      cmp al,' '
                                      jb zeichenketteneingabe_schleife1

                                      ; am Ende ist werder im öberschreibmodus
                                      ; noch im EinfÅgemodus ein Zeichen eingebbar
                                      cmp bp,bx ; cursor=max_platz ?
                                      je zeichenketteneingabe_schleife1

                                      call frage_ob_ueberschreibmodus
                                      jz zeichenketteneingabe_ueberschreibmodus

                                      ; Platz vorhanden oder machbar ?
                                      cmp dx,bx
                                      if_e <call zeichenketteneingabe_loesche_zeichenkettenende>
                                      cmp dx,bx
                                      je zeichenketteneingabe_schleife1

                                      mov di,si
                                      add di,bp
                                      mov cx,bx
                                      sub cx,bp
    zke_zeichen_sl:
                                      xchg byte ptr [di],al
                                      inc di
                                      loop zke_zeichen_sl
                                      inc bp
                                      inc dx
    zeichenketteneingabe_schleife1:
                                      jmp zeichenketteneingabe_schleife
                                      ;------------------------------

                                      ;------------------------------
    zeichenketteneingabe_ueberschreibmodus:
                                      mov ds:[si+bp],al   ; zk[Cursor]:=c
                                      inc bp              ; Inc(Cursor)
                                      cmp bp,dx           ; LÑnge:=Max(Cursor,LÑnge)
                                      if_a <mov dx,bp>
                                      jmp zeichenketteneingabe_schleife
                                      ;------------------------------

    zeichenketteneingabe_ende:

                                      ; LÑnge speichern
                                      mov [si-1],dl

                                    pop ax
                                    call setze_cursor_form

                                  pop ax
                                  mov [farbe],al

                                  mov al,13
                                  call ausschrift_zeichen
                                  mov al,10
                                  call ausschrift_zeichen

                                popa
                                pop es
                                ret
a_endp                          zeichenketteneingabe

;***************************************************************************

a_proc                          zeichenketteneingabe_loesche_zeichenkettenende
                                cmp bx,0        ; Maxmiale_LÑnge 0 ?
                                je exit_zeichenketteneingabe_loesche_zeichenkettenende

                                cmp bp,dx       ; Cursor=aktuelle LÑnge ?
                                je exit_zeichenketteneingabe_loesche_zeichenkettenende

                                dec dx          ; Dec(LÑnge)
                                push si
                                  add si,dx
                                  mov byte ptr [si],' '
                                pop si

  exit_zeichenketteneingabe_loesche_zeichenkettenende:
                                ret
a_endp                          zeichenketteneingabe_loesche_zeichenkettenende

;***************************************************************************
; CS:DI=Variable
; Farbe ist vorher zugewiesen

a_proc                          ausschrift_variablenname
                                push si
                                  lea si,[di].namen_laenge
                                  call ausschrift_p8
                                pop si
                                ret
a_endp                          ausschrift_variablenname

;***************************************************************************

