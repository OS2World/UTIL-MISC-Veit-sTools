Title   Config.sys ECHO command

;***************************************************************************
; Eingabe
;   es:di=Schreibposition
;   schreibzeiger_zeilenanfang=Zeilenanfang
; Ausgabe
;   Bildschirmausgabe des Textes nach 'ECHO ' wenn OS2CSM_MENU=3
;   Umformung zu 'REM  '
;

;
a_proc                          bearbeite_echo_befehl
                                push es
                                push ds
                                pusha

                                  push es
                                  pop ds
                                  push cs
                                  pop es

                                  mov si,es:[schreibzeiger_zeilenanfang]
                                  mov ax,di
                                  sub ax,si

                                  ; ds:si=Zeilenanfang (@'echo bla')
                                  ; ax=Length('echo bla')

                                  mov di,Offset echo_befehl
                                  movzx cx,byte ptr es:[di] ; LÑnge der Suchfolge

                                  ; schon geschrieben ?
                                  cmp cx,ax
                                  ja  bearbeite_echo_befehl_ende

                                  ; ist es wirklich echo ?
                                  call vergleiche_zeichenfolge_p8_grossklein
                                  jne bearbeite_echo_befehl_ende

                                  ; 'REM  '
                                  mov dword ptr ds:[si],' MER'
                                  add si,2+2+1

                                  cmp cs:[OS2CSM_MENU],3
                                  jne bearbeite_echo_befehl_ende

                                  ; im ausfÅhrlichen Modus ..
                                  ; in leerer Zeile,Spalte 1 anfangen
                                  call spalte1_in_leerer_zeile

                                  mov bl,00fh
                                  xchg [farbe],bl
  bearbeite_echo_befehl_schleife:
                                  cld
                                  lodsb
                                  call ausschrift_zeichen
                                  ; Zeilenende ?
                                  cmp al,10
                                  jne bearbeite_echo_befehl_schleife

                                  mov [farbe],bl
  bearbeite_echo_befehl_ende:
                                popa
                                pop ds
                                pop es
                                ret
a_endp                          bearbeite_echo_befehl

;***************************************************************************
p8str echo_befehl               'echo '
;***************************************************************************

a_proc                          spalte1_in_leerer_zeile
                                pusha
                                  mov ah,008h ; Zeichen an Cursorposition ?
                                  null bx
                                  int 010h
                                  cmp al,' '
                                  je sp1_pruefe_spalte
                                  cmp al,0
                                  jne sp1_neue_zeile
 sp1_pruefe_spalte:
                                  mov ah,003h ; Spalte=1 ?
                                  ;null bx
                                  int 010h
                                  cmp dl,0
                                  je sp1_spalte1
  sp1_neue_zeile:
                                  mov al,13
                                  call ausschrift_zeichen
                                  mov al,10
                                  call ausschrift_zeichen
  sp1_spalte1:

                                popa
                                ret
a_endp                          spalte1_in_leerer_zeile

;***************************************************************************

