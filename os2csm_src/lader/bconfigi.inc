Title   determine sector number for a:config.sys replacement

ifndef memdisk

;***************************************************************************
; Bestimmen der Sektornummern von B:\CONFIG.SYS bei CD-Emulation
; 2000.09.12
;***************************************************************************

p8str name_A_CONFIG_SYS 'A_CONFIG_SYS'
p8str name_B_CONFIG_SYS 'B_CONFIG_SYS'

;***************************************************************************

a_proc                  versuche_ab_config_sys
                        pusha
                          push es

                            push cs
                            pop es


                            mov si,Offset name_A_CONFIG_SYS
                            call suche_variable_p8

                            test di,di
                            jz nicht_a_config_sys
                            cmp [di].aktuelle_einstellung,1
                            jne nicht_a_config_sys

                            mov [ab_config_laufwerk],000
                            call berechne_AB_CONFIG_SYS
                            cmp word ptr sektor_tabelle[0],0
                            jne umleitung_eingeschaltet
  nicht_a_config_sys:
                            mov si,Offset name_B_CONFIG_SYS
                            call suche_variable_p8

                            test di,di
                            jz nicht_b_config_sys
                            cmp [di].aktuelle_einstellung,1
                            jne nicht_b_config_sys

                            mov [ab_config_laufwerk],001
                            call berechne_AB_CONFIG_SYS
                            cmp word ptr sektor_tabelle[0],0
                            ;jne umleitung_eingeschaltet
  nicht_b_config_sys:
  umleitung_eingeschaltet:
                          pop es
                        popa
                        ret
a_endp                  versuche_ab_config_sys

;***************************************************************************

a_proc                  berechne_AB_CONFIG_SYS
                        push es
                        pushad

                          push 0000
                          pop es

                          push dword ptr es:[013h*4]
                          pop dword ptr [int13_org]



                          mov eax,2*512
                          mov si,Offset temp_sektor_ptr
                          call getmem


                          ; Startsektor von A:/B: laden
                          mov ax,0                      ; Sektor 0
                          les bx,[temp_sektor_ptr]      ; Ziel
                          call lies_sektor_b
                          jc exit_berechne_AB_CONFIG_SYS

                          ; Startsektor auswerten
                          cmp word ptr es:[bx+512-2],0aa55h
                          jne exit_berechne_AB_CONFIG_SYS ; ungÅltig

                          mov al,es:[bx+018h]
                          mov [sektoren_je_spur],al
                          mov al,es:[bx+01ah]
                          mov [anzahl_koepfe],al

                          movzx ax,byte ptr es:[bx+00dh]
                          mov [sektoren_je_cluster],ax

                          mov cx,es:[bx+00eh]           ; reservierte Setoren
                          mov [fat_anfang],cx
                          mov al,es:[bx+010h]           ; Anzahl FAT
                          mul byte ptr es:[bx+016h]     ; Sektoren je FAT
                          add cx,ax
                          mov [hauptverzeichnisanfang],cx

                          mov ax,es:[bx+011h]            ; Hauptverzeichnissektoren
                          shr ax,4                       ; 512/16=32 byte je Eintrag
                          add ax,cx
                          mov [daten_anfang],ax

                          mov cx,es:[bx+011h]           ; Hauptverzeichnissektoren

                          ;--------------------------------------------

suche_im_hauptverzeichnis:
                          mov ax,[hauptverzeichnisanfang]
                          inc [hauptverzeichnisanfang]
                          les bx,[temp_sektor_ptr]      ; Ziel
                          call lies_sektor_b
                          jc exit_berechne_AB_CONFIG_SYS

                          mov di,bx                     ; Anfang des Sektors
                          lea bp,[di+512]               ; Ende des Sektors
suche_nach_der_datei_schleife:
                          cmp byte ptr [si],0           ; Ende des Hauptverzeichnisses
                          je exit_berechne_AB_CONFIG_SYS

                          mov si,Offset gesuchter_dateiname
                          cld
                          push2 di,cx
                            mov cx,8+3
                            rep cmpsb
                          pop2 cx,di
                          je datei_gefunden

                          add di,020h                   ; LÑnge eines Eintrages
                          cmp di,bp
                          jne suche_nach_der_datei_schleife

                          loop suche_im_hauptverzeichnis

                          jmp exit_berechne_AB_CONFIG_SYS

                          ;--------------------------------------------

  datei_gefunden:
                          mov si,di
                          mov ax,es:[di+01ah]           ; Startcluster
                          mov di,Offset sektor_tabelle
  cluster_verwerten:
                          cmp di,Offset sektor_tabelle_ende
                          je datei_ende
                          and ax,00fffh                 ; 12 bit
                          cmp ax,00ff1h
                          jae datei_ende

                          mov cx,[sektoren_je_cluster]
                          ; cluster -> Sektornummer
                          mov bx,ax
                          dec ax
                          dec ax
                          mul cx
                          add ax,[daten_anfang]
                          push cs
                          pop es
                          cld
  merke_sektornummer_schleife:
                          stosw
                          inc ax
                          loop merke_sektornummer_schleife

                          ; Cluster -> Folgecluster ermitteln

                          ; 12 bit=3/2 Byte
                          mov ax,bx                     ; *3
                          add ax,bx
                          add ax,bx
                          mov cl,al
                          and cl,1                      ; mod 2
                          shl cl,2                      ; (1/2 byte)=(4 bit)=(1 shl 2)
                          shr ax,1                      ; div 2
                          mov si,ax
                          shr ax,9                      ; div 512
                          and si,511                    ; mod 512
                          add ax,[fat_anfang]
                          cmp [fat_cache],ax
                          je fat_schon_gelesen

                          mov [fat_cache],ax

                          les bx,[temp_sektor_ptr]      ; Ziel
                          call lies_sektor_b
                          jc exit_berechne_AB_CONFIG_SYS

                          inc ax

                          add bx,512                    ; Ziel
                          call lies_sektor_b
                          jc exit_berechne_AB_CONFIG_SYS

  fat_schon_gelesen:
                          les bx,[temp_sektor_ptr]
                          mov ax,es:[bx+si]
                          shr ax,cl                       ; 0 oder 4 bit
                          jmp cluster_verwerten
  datei_ende:
                          cmp word ptr sektor_tabelle[0],0
                          je exit_berechne_AB_CONFIG_SYS

                          mov al,[ab_config_laufwerk]
                          add byte ptr [text_a_config_sys+1],al
                          mov si,Offset text_a_config_sys
                          call ausschrift_p8_abschaltbar

  exit_berechne_AB_CONFIG_SYS:

                          mov si,Offset temp_sektor_ptr
                          call freemem

                        popad
                        pop es
                        ret
a_endp                  berechne_AB_CONFIG_SYS

;***************************************************************************
fat_cache               dw -1

fat_anfang              dw  ?
hauptverzeichnisanfang  dw  ?
daten_anfang            dw  ?
sektoren_je_cluster     dw  ?

gesuchter_dateiname:    db 'CONFIG  ','SYS'

p8str text_a_config_sys <'A:\CONFIG.SYS ...',13,10>

temp_sektor_ptr       ptr1616 <?,?> ; Platz fÅr 2*512

;***************************************************************************

endif ; -memdisk
