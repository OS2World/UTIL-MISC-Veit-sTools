Title   execute statements from menu.txt

;***************************************************************************
; Anweisungen ausfÅhren
;***************************************************************************

aktueller_zustand       db anweisung_normal

a_proc                  berechne_abhaengigkeiten
                        pusha
                        push es

                          push cs
                          pop es

                          mov si,[formel_zeiger]

  berechne_abhaengigkeiten_schleife:
                          cmp [si].zustand_anwendbar,anweisung_normal
                          je anweisung_anwendbar

                          mov al,[aktueller_zustand]
                          cmp [si].zustand_anwendbar,al
                          jne naechste_formel

  anweisung_anwendbar:
                          mov ax,[si].var_if_2
                          call hole_variablen_wert
                          mov dx,ax

                          mov ax,[si].var_if_1
                          call hole_variablen_wert
                          ; VAR1/VAR2=ax/dx

                          movzx bx,[si].if_teil
                          add bx,bx
                          jmp word ptr if_teil_tabelle[bx]

  if_teil_tabelle:
                          dw berechne_abhaengigkeiten_ende      ; A0
                          dw ?                                  ; A1
                          dw ?                                  ; A2
                          dw ?                                  ; A3
                          dw if_teil_A4                         ; A4
                          dw if_teil_A5                         ; A5
                          dw if_teil_A6                         ; A6
                          dw if_teil_A7                         ; A7
                          dw ?                                  ; A8
                          dw if_teil_A9                         ; A9
                          dw ?                                  ; AA
                          dw if_teil_AB                         ; AB

                          dw if_str_gleich                      ; AC
                          dw if_str_ungleich                    ; AD

  if_teil_A4:             ; VAR1 AND VAR2
                          and ax,dx
                          jnz anweisung_ausfueren
                          jmp naechste_formel

  if_teil_A5:             ; VAR1 OR VAR2
                          or ax,dx
                          jnz anweisung_ausfueren
                          jmp naechste_formel

  if_teil_A6:             ; VAR1=VAR2
                          cmp ax,dx
                          je anweisung_ausfueren
                          jmp naechste_formel

  if_teil_A7:             ; VAR1<VAR2
                          cmp ax,dx
                          jb anweisung_ausfueren
                          jmp naechste_formel

  if_teil_A9:             ; VAR1<=VAR2
                          cmp ax,dx
                          jbe anweisung_ausfueren
                          jmp naechste_formel

  if_teil_AB:             ; VAR1<>VAR2
                          cmp ax,dx
                          jne anweisung_ausfueren
                          jmp naechste_formel

  if_str_gleich:          ; STR1=STR2
                          pusha
                            mov ax,[si].var_if_1
                            call hole_zeichenkettenvariable
                            mov dx,di
                            mov ax,[si].var_if_2
                            call hole_zeichenkettenvariable
                            call strcomp_dx_di
                            cmp al,1
                          popa
                          je anweisung_ausfueren
                          jmp naechste_formel

  if_str_ungleich:        ; STR1<>STR2
                          pusha
                            mov ax,[si].var_if_1
                            call hole_zeichenkettenvariable
                            mov dx,di
                            mov ax,[si].var_if_2
                            call hole_zeichenkettenvariable
                            call strcomp_dx_di
                            cmp al,1
                          popa
                          jne anweisung_ausfueren
                          ;-jmp naechste_formel

  naechste_formel:
                          add si,Size formel
                          jmp berechne_abhaengigkeiten_schleife

                          ;*****************************
  anweisung_ausfueren:
                          mov ax,[si].var_verkn_3
                          call hole_variablen_wert
                          mov dx,ax

                          mov ax,[si].var_verkn_2
                          call hole_variablen_wert
                          ; var_verkn_2/var_verkn_3=ax/dx

                          movzx bx,[si].verkuepfung

                          ; Obergrenze kann eigenlich nicht Åberschritten werden
                          cmp bl,groesste_verknuepfungsfunktion
                          ja naechste_formel

                          add bx,bx
                          jmp word ptr verkuepfung_tabelle[bx]

  verkuepfung_tabelle:
                          dw ?                                          ; B0
                          dw ?                                          ; B1
                          dw verkuepfung_B2                             ; B2
                          dw verkuepfung_B3                             ; B3
                          dw verkuepfung_B4                             ; B4
                          dw verkuepfung_B5                             ; B5
                          dw verkuepfung_B6                             ; B6
                          dw verkuepfung_B7                             ; B7
                          dw verkuepfung_B8                             ; B8
                          dw ?                                          ; B9
                          dw verkuepfung_BA                             ; BA
                          dw ?                                          ; BB
                          dw verkuepfung_BC                             ; BC

                          dw verknuepfung_STR_APPEND                    ; 00d
                          dw verknuepfung_STR_COMP                      ; 00e
                          dw verknuepfung_STR_DELETE                    ; 00f
                          dw verknuepfung_STR_INSERT                    ; 010
                          dw verknuepfung_STR_LENGTH                    ; 011
                          dw verknuepfung_STR_CONCAT                    ; 012
                          dw verknuepfung_STR_TRIM                      ; 013
                          dw verknuepfung_STR_COPY                      ; 014
                          dw verknuepfung_STR_UPCASE                    ; 015
                          dw verknuepfung_STR_VAL                       ; 016

                          dw verknuepfung_STR_DISPLAY                   ; 017

                          dw verknuepfung_SEARCH_PCI_DEVICEID           ; 018
                          dw verknuepfung_SEARCH_PCI_DEVICECLASS        ; 019
                          dw verknuepfung_SEARCH_PNP_DEVICEID           ; 01a
                          dw verknuepfung_SEARCH_PNP_DEVICECLASS        ; 01b
                          dw verknuepfung_COUNT_PCI_DEVICEID            ; 01c
                          dw verknuepfung_COUNT_PCI_DEVICECLASS         ; 01d
                          dw verknuepfung_COUNT_PNP_DEVICEID            ; 01e
                          dw verknuepfung_COUNT_PNP_DEVICECLASS         ; 01f

                          dw verknuepfung_QUERY_BOOTDRIVE_LETTER        ; 020
                          dw verknuepfung_SET_BOOTDRIVE_LETTER          ; 021

                          dw verknuepfung_SET_ALTF2ON_FILE              ; 022h


  verkuepfung_B2:         ; var_verkn_1:=var_verkn_2 AND var_verkn_3
                          and ax,dx
                          jmp zuweisung

  verkuepfung_B3:         ; var_verkn_1:=var_verkn_2 OR var_verkn_3
                          or ax,dx
                          jmp zuweisung

  verkuepfung_B4:         ; var_verkn_1:=var_verkn_2 XOR var_verkn_3
                          xor ax,dx
                          jmp zuweisung

  verkuepfung_B5:         ; var_verkn_1:=var_verkn_2+var_verkn_3
                          add ax,dx
                          jmp zuweisung

  verkuepfung_B6:         ; var_verkn_1:=var_verkn_2-var_verkn_3
                          sub ax,dx
                          jmp zuweisung

  verkuepfung_B7:         ; var_verkn_1:=(var_verkn_2=var_verkn_3)
                          cmp ax,dx
                          mov ah,0
                          sete al
                          jmp zuweisung

  verkuepfung_B8:         ; var_verkn_1:=(var_verkn_2<var_verkn_3)
                          cmp ax,dx
                          mov ah,0
                          setb al
                          jmp zuweisung

  verkuepfung_BA:         ; var_verkn_1:=(var_verkn_2<=var_verkn_3)
                          cmp ax,dx
                          mov ah,0
                          setbe al
                          jmp zuweisung

  verkuepfung_BC:         ; var_verkn_1:=(var_verkn_2<>var_verkn_3)
                          cmp ax,dx
                          mov ah,0
                          setne al
                          ;jmp zuweisung

                          ;*****************************
  zuweisung:
                          mov dx,ax
                          mov ax,[si].var_verkn_1
                          call schreibe_variablen_wert

                          jmp naechste_formel

  ;------------------------------------------------------------------
  ; STR_APPEND(VAR STR1;CONST STR2)
  ; ist sicher weil vor dem AnhÑngen die LÑnge von STR1 nicht geÑndert wird
  verknuepfung_STR_APPEND:
                          push si
                            mov ax,[si].var_verkn_1
                            call hole_zeichenkettenvariable

                            push di ; @Zeichenkette[0]

                              ; di:=Ende,cx:=freier Platz
                              movzx ax,byte ptr [di]
                              inc di
                              add di,ax
                              sub cx,ax

                              push2 di,cx
                                mov ax,[si].var_verkn_2
                                call hole_zeichenkettenvariable
                                mov si,di
                              pop2 cx,di

                              ; LÑnge STR2 bestimmen
                              null ax
                              cld
                              lodsb

                              ; Minimum von Platz in STR1 und LÑnge von STR2
                              cmp cx,ax
                              if_a <mov cx,ax>

                              rep movsb

                              mov ax,di
                            pop di  ; @Zeichenkette[0]

                            ; LÑnge := Ofs([Ende+1])-Ofs([1])
                            sub ax,di
                            dec ax
                            stosb

                          pop si

                          ; Nachbehandlung
                          mov ax,[si].var_verkn_1
                          call zeichenkettenpflege

                          jmp naechste_formel

  ;------------------------------------------------------------------
  ; STR_COMP(CONST STR1,STR2;VAR BOOLEAN3)
  verknuepfung_STR_COMP:
                          mov ax,[si].var_verkn_1
                          call hole_zeichenkettenvariable
                          mov dx,di
                          mov ax,[si].var_verkn_2
                          call hole_zeichenkettenvariable
                          call strcomp_dx_di
                          mov dx,ax
                          mov ax,[si].var_verkn_3
                          call schreibe_variablen_wert
                          jmp naechste_formel

  ;------------------------------------------------------------------
  ; STR_DELETE(VAR STR1;CONST INT2,INT3)
  verknuepfung_STR_DELETE:
                          mov ax,[si].var_verkn_1
                          call hole_zeichenkettenvariable

                          mov ax,[si].var_verkn_2
                          call hole_variablen_wert
                          mov bh,al

                          mov ax,[si].var_verkn_3
                          call hole_variablen_wert
                          mov bl,al

                          push2 di,si

                            movzx cx,byte ptr [di]

                            inc di
                            mov si,di

  str_delete_schleife:
                            jcxz str_delete_ende

                            dec bh                              ; die Lîschposition kommnt nÑher

                            cmp bh,0                            ; an der Lîschposition ?
                            jne str_delete_zeichen_kopieren

                            cmp bl,0                            ; genug Zeichen gelîscht
                            je str_delete_zeichen_kopieren

                            inc si                              ; Zeichen Åbergehen
                            dec bl                              ; 1 Zeichen gelîscht
                            dec cx                              ; 1 Zeichen weniger vorhanden
                            inc bh                              ; weiter an der Lîschposition bleiben
                            jmp str_delete_schleife

  str_delete_zeichen_kopieren:
                            movsb                               ; 1 Zeichen kopieren
                            dec cx                              ; 1 Zeichen weniger vorhanden
                            jmp str_delete_schleife

  str_delete_ende:
                            mov ax,di

                          pop2 si,di

                          sub ax,di                             ; ax:=LÑnge
                          dec ax

                          mov byte ptr [di],al

                          ; Nachbehandlung
                          mov ax,[si].var_verkn_1
                          call zeichenkettenpflege

                          jmp naechste_formel

  ;------------------------------------------------------------------
  ; STR_INSERT(CONST STR1;VAR STR2;CONST INT3)
  verknuepfung_STR_INSERT:
                          pusha
                            mov bx,si

                            mov ax,[bx].var_verkn_2
                            call hole_zeichenkettenvariable

                            mov ax,[bx].var_verkn_3
                            call hole_variablen_wert
                            mov dl,al

                            mov si,di
                            mov di,Offset zeichenketten_zwischenspeicher+1

                            cld
                            lodsb                         ; LÑnge von STR2
                            mov dh,al

  str_insert_schleife:
                            dec dl                        ; die EinfÅgestelle rÅckt nÑher
                            cmp dl,0
                            jne str_insert_nicht_einfuegestelle

                            ; STR1 kopieren
                            push si
                              push di
                                mov ax,[bx].var_verkn_1
                                call hole_zeichenkettenvariable
                                mov si,di
                              pop di

                              lodsb                       ; Inhalt kopieren
                              movzx cx,al
                              rep movsb

                            pop si
                            jmp str_insert_schleife       ; mit STR2 weitermachen

  str_insert_nicht_einfuegestelle:
                            cmp dh,0                      ; STR2 abgearbeitet ?
                            je str_insert_ende

                            dec dh                        ; 1 Zeichen weniger von STR2
                            movsb                         ; 1 Zeichen kopieren
                            jmp str_insert_schleife
  str_insert_ende:

                            ; TEMP->STR2
                            mov dx,di                     ; LÑnge berechnen
                            sub dx,(Offset zeichenketten_zwischenspeicher+1)
                            mov cx,[bx].var_verkn_2
                            mov si,Offset zeichenketten_zwischenspeicher
                            mov Byte Ptr [si],dl
                            call store_string_to_anything_varnum

                          popa
                          jmp naechste_formel

  ;------------------------------------------------------------------
  ; STR_LENGTH(CONST STR1;VAR INT2)
  verknuepfung_STR_LENGTH:
                          mov ax,[si].var_verkn_1
                          call hole_zeichenkettenvariable
                          movzx dx,byte ptr [di]
                          mov ax,[si].var_verkn_2
                          call schreibe_variablen_wert
                          jmp naechste_formel

  ;------------------------------------------------------------------
  ; STR_CONCAT(CONST STR1,STR2;VAR STR3)
  verknuepfung_STR_CONCAT:

                          pusha
                            mov bx,si

                            mov di,Offset zeichenketten_zwischenspeicher+1

                            ; STR1 holen
                            push di
                              mov ax,[bx+var_verkn_1]
                              call hole_zeichenkettenvariable
                              mov si,di
                            pop di

                            ; STR1 kopieren
                            cld
                            lodsb
                            movzx cx,al
                            rep movsb

                            ; STR2 holen
                            push di
                              mov ax,[bx].var_verkn_2
                              call hole_zeichenkettenvariable
                              mov si,di
                            pop di

                            ; STR2 kopieren
                            lodsb
                            movzx cx,al
                            cld
                            rep movsb

                            mov dx,di
                            sub dx,(Offset zeichenketten_zwischenspeicher+1)

                            ; als STR3 speichern
                            mov cx,[bx].var_verkn_3
                            mov si,Offset zeichenketten_zwischenspeicher
                            mov Byte Ptr [si],dl
                            call store_string_to_anything_varnum

                          popa
                          jmp naechste_formel

  ;------------------------------------------------------------------
  ; STR_TRIM(CONST STR1;VAR STR2)
  ; ist sicher, weil immer erst gelesen wird bevor geschrieben wird
  verknuepfung_STR_TRIM:
                          push si
                            mov ax,[si].var_verkn_1
                            call hole_zeichenkettenvariable
                            mov dx,di
                            mov ax,[si].var_verkn_2
                            call hole_zeichenkettenvariable

                            mov bx,cx   ; Platz (str2)

                            mov si,dx
                            mov dx,di
                            inc dx      ; dx:=@var_verkn_2[1]
                            ; ds:si->es:di

                            cld
                            lodsb
                            movzx cx,al ; cx:=LÑnge(str1)

                            inc di    ; di=var_verkn_2@[1]

  trim_anfang_schleife:
                            or bx,bx                      ; kein Platz mehr
                            jz trim_anfang_abgearbeitet
                            jcxz trim_anfang_abgearbeitet ; Quelle abgearbeitet

                            lodsb
                            dec cx
                            cmp al,' '
                            je trim_anfang_schleife

                            dec si                        ; nicht-Leerzeichen gefunden
                            inc cx

  trim_anfang_abgearbeitet:

  trim_mitte_schleife:
                            or bx,bx                      ; kein Platz mehr
                            jz trim_mitte_abgearbeitet
                            jcxz trim_mitte_abgearbeitet  ; Quelle abgearbeitet

                            movsb                         ; 1 Zeichen kopieren
                            dec cx                        ; 1 Zeichen abgearbeitet
                            dec bx                        ; 1 Zeichen weniger Platz

                            jmp trim_mitte_schleife

  trim_mitte_abgearbeitet:

  trim_ende_schleife:
                            cmp di,dx                      ; str2=''
                            je trim_ende_abgearbeitet

                            cmp byte ptr [di-1],' '
                            jne trim_ende_abgearbeitet     ; str2[Length(str2)]<>' '

                            dec di                         ; 1 Zeichen lîschen
                            inc bx                         ; 1 Zeichen mehr Platz
                            jmp trim_ende_schleife

  trim_ende_abgearbeitet:
                            mov ax,di                      ; LÑngenberechnung
                            sub ax,dx

                            mov di,dx                      ; str2[1-1]:=LÑnge
                            mov byte ptr [di-1],al

                          pop si

                          mov ax,[si].var_verkn_2
                          call zeichenkettenpflege

                          jmp naechste_formel

  ;------------------------------------------------------------------
  ; (* STR_COPY(CONST STR1;CONST INT2,INT3;VAR STR4) *)
  verknuepfung_STR_COPY:
                          mov bx,si

                          mov ax,[bx].var_verkn_1               ; STR1:si
                          call hole_zeichenkettenvariable
                          mov si,di

                          lodsb                                 ; QuellÑnge
                          movzx cx,al

                          mov ax,[bx].var_verkn_2               ; Anfangsposition
                          call hole_variablen_wert
                          cmp ax,0                              ; 1->0
                          if_ne <dec ax>
                          add si,ax                             ; auf Anfangsposition gesetzt

                          sub cx,ax                             ; Zahl der verbleibenden Zeichen
                          test cx,cx
                          if_ng <null cx>                       ; bei negativer LÑnge nichts kopieren

                          mov ax,[bx].var_verkn_3               ; zu kopierende Anzahl
                          call hole_variablen_wert
                          cmp ax,cx                             ; Minimum von Wunsch und Åbrig
                          if_a <mov ax,cx>

                          mov dx,ax                             ; merken..

                          mov ax,[bx].var_verkn_4               ; Zielspeicher
                          call hole_zeichenkettenvariable

                          cmp cx,dx                             ; Minimum der LÑnge und des Zielplatzes
                          if_a <mov cx,dx>

                          mov al,cl                             ; LÑngenbyte
                          stosb

                          rep movsb                             ; Zeichen kopieren


                          mov si,bx

                          mov ax,[si].var_verkn_4
                          call zeichenkettenpflege

                          jmp naechste_formel

  ;------------------------------------------------------------------
  ; (* STR_UPCASE(CONST STR1;VAR STR2) *)
  verknuepfung_STR_UPCASE:
                          mov bx,si
                          mov ax,[bx].var_verkn_1
                          call hole_zeichenkettenvariable
                          mov si,di
                          mov ax,[bx].var_verkn_2
                          call hole_zeichenkettenvariable

                          null ax                       ; LÑnge von STR1
                          cld
                          lodsb

                          cmp ax,cx                     ; <= Platz
                          if_a <mov ax,cx>

                          stosb                         ; neue LÑnge

                          mov cx,ax
                          jcxz verknuepfung_STR_UPCASE_ende

  verknuepfung_STR_UPCASE_schleife:                     ; Zeichen Åbertragen
                          lodsb
                          call grossbuchstabe
                          stosb
                          loop verknuepfung_STR_UPCASE_schleife

  verknuepfung_STR_UPCASE_ende:

                          mov si,bx

                          mov ax,[si].var_verkn_2
                          call zeichenkettenpflege

                          jmp naechste_formel
  ;------------------------------------------------------------------
  ; (* STR_VAL(CONST STR1;VAR INT2) *)
  verknuepfung_STR_VAL:
                          pusha
                            mov ax,[si].var_verkn_1
                            mov cx,[si].var_verkn_2
                            call liefere_variablen_adresse
                            ; -> si

                            ;mov ax,ax
                            call hole_zeichenkettenvariable
                            ; -> di

                            xchg si,di
                            call convert_string_to_numeric_variable

                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------
  ; STR_DISPLAY(CONST INTX,INTY,INTP;CONST STR);
  verknuepfung_STR_DISPLAY:
                          push es
                          pusha

                            ; STR
                            mov ax,[si].var_verkn_4
                            call hole_zeichenkettenvariable
                            mov bx,di

                            ; Seite -> Zeile
                            mov ax,[si].var_verkn_3
                            call hole_variablen_wert
                            cmp ax,0
                            je fehler_STR_DISPLAY
                            ;cmp ax,[Anzahl der Seiten ?]
                            cmp ax,10
                            ja fehler_STR_DISPLAY
                            dec ax
                            mov ah,[menu_bildschirm_beschreibung].bildschirm_zeilen_belegt
                            mul ah
                            mov dx,ax
                            ; Zeile+
                            mov ax,[si].var_verkn_2
                            call hole_variablen_wert
                            cmp ax,0
                            je fehler_STR_DISPLAY
                            cmp al,[menu_bildschirm_beschreibung].bildschirm_zeilen_belegt
                            ja fehler_STR_DISPLAY
                            cmp ah,0
                            jne fehler_STR_DISPLAY
                            dec ax
                            add ax,dx

                            ; Zeile->Zeichen
                            mov dx,80
                            mul dx
                            mov dx,ax

                            ; + Spalte
                            mov ax,[si].var_verkn_1
                            call hole_variablen_wert
                            cmp ax,0
                            je fehler_STR_DISPLAY
                            cmp ax,80
                            ja fehler_STR_DISPLAY
                            dec ax
                            add ax,dx

                            ; 2 Byte je Zeichen
                            add ax,ax

                            ; zum Speicher
                            les di,[menu_bildschirm_beschreibung].bildschirm_puffer_zeiger
                            add di,ax

                            ; STR
                            mov si,bx

                            ; LÑnge von STR
                            cld
                            lodsb
                            movzx cx,al
                            jcxz verknuepfung_STR_DISPLAY_ende
  verknuepfung_STR_DISPLAY_schleife:
                            lodsb
                            xchg al,es:[di]
                            inc di
                            inc di
                            cmp al,[si-1]
                            if_ne <mov [vollstaendigneuzeichnen],1>
                            loop verknuepfung_STR_DISPLAY_schleife
  verknuepfung_STR_DISPLAY_ende:
  fehler_STR_DISPLAY:
                          popa
                          pop es
                          jmp naechste_formel
  ;------------------------------------------------------------------
  verknuepfung_SEARCH_PCI_DEVICEID:
                          pusha
                            mov ax,[si].var_verkn_1
                            call Val_Hex4_oder_16bit_Zahl
                            mov dx,ax
                            mov ax,[si].var_verkn_2
                            call Val_Hex4_oder_16bit_Zahl
                            call Search_PCI_DeviceID
                            mov ax,[si].var_verkn_3
                            call schreibe_variablen_wert
                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------
  verknuepfung_SEARCH_PCI_DEVICECLASS:
                          pusha
                            mov ax,[si].var_verkn_1
                            call Val_Hex4_oder_16bit_Zahl
                            mov dx,ax
                            mov ax,[si].var_verkn_2
                            call Val_Hex4_oder_16bit_Zahl
                            call Search_PCI_DeviceClass
                            mov ax,[si].var_verkn_3
                            call schreibe_variablen_wert
                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------
  verknuepfung_SEARCH_PNP_DEVICEID:
                          pusha
                            mov ax,[si].var_verkn_1
                            call hole_zeichenkettenvariable
                            call Search_PNP_DeviceID
                            mov ax,[si].var_verkn_2
                            call schreibe_variablen_wert
                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------
  verknuepfung_SEARCH_PNP_DEVICECLASS:
                          pusha
                            mov ax,[si].var_verkn_1
                            call Val_Hex4_oder_16bit_Zahl ; "0701"
                            mov dx,ax
                            mov ax,[si].var_verkn_2
                            call Val_Hex4_oder_16bit_Zahl ; "FF"
                            call Search_PNP_DeviceClass
                            mov ax,[si].var_verkn_3
                            call schreibe_variablen_wert
                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------
  verknuepfung_COUNT_PCI_DEVICEID:
                          pusha
                            mov ax,[si].var_verkn_1
                            call Val_Hex4_oder_16bit_Zahl
                            mov dx,ax
                            mov ax,[si].var_verkn_2
                            call Val_Hex4_oder_16bit_Zahl
                            call Count_PCI_DeviceID
                            mov ax,[si].var_verkn_3
                            call schreibe_variablen_wert
                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------
  verknuepfung_COUNT_PCI_DEVICECLASS:
                          pusha
                            mov ax,[si].var_verkn_1
                            call Val_Hex4_oder_16bit_Zahl
                            mov dx,ax
                            mov ax,[si].var_verkn_2
                            call Val_Hex4_oder_16bit_Zahl
                            call Count_PCI_DeviceClass
                            mov ax,[si].var_verkn_3
                            call schreibe_variablen_wert
                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------
  verknuepfung_COUNT_PNP_DEVICEID:
                         pusha
                            mov ax,[si].var_verkn_1
                            call hole_zeichenkettenvariable
                            call Count_PNP_DeviceID
                            mov ax,[si].var_verkn_2
                            call schreibe_variablen_wert
                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------
  verknuepfung_COUNT_PNP_DEVICECLASS:
                          pusha
                            mov ax,[si].var_verkn_1
                            call Val_Hex4_oder_16bit_Zahl ; "0701"
                            mov dx,ax
                            mov ax,[si].var_verkn_2
                            call Val_Hex4_oder_16bit_Zahl ; "FF"
                            call Count_PNP_DeviceClass
                            mov ax,[si].var_verkn_3
                            call schreibe_variablen_wert
                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------
  verknuepfung_QUERY_BOOTDRIVE_LETTER:
                          pusha
                            ; Length: 1
                            mov Byte Ptr [zeichenketten_zwischenspeicher],1
ifdef memdisk
                            mov al,[icmd].memdisk_drive_letter
else  ; -memdisk
                            ; not implemented
                            jmp error_QUERY_BOOTDRIVE_LETTER
endif ; -memdisk
                            ; char->string
                            mov Byte Ptr [zeichenketten_zwischenspeicher+1],al

                            mov cx,[si].var_verkn_1
                            mov si,Offset zeichenketten_zwischenspeicher
                            call store_string_to_anything_varnum

  error_QUERY_BOOTDRIVE_LETTER:

                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------
  verknuepfung_SET_BOOTDRIVE_LETTER:
                          pusha
                            mov ax,[si].var_verkn_1
                            call hole_zeichenkettenvariable

                            ; letter<>'' ?
                            cmp Byte Ptr [di],0
                            je skip_verknuepfung_SET_BOOTDRIVE_LETTER

                            mov al,Byte Ptr [di+1]
                            call grossbuchstabe
ifdef memdisk
                            mov [icmd].memdisk_drive_letter,al
else ; -memdisk
                            ; not implemented
endif ; -memdisk


  skip_verknuepfung_SET_BOOTDRIVE_LETTER:
                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------
  verknuepfung_SET_ALTF2ON_FILE:
                          pusha
                            mov ax,[si].var_verkn_1
                            call hole_variablen_wert
ifdef memdisk
                            mov [icmd].altf2on_change,al
else  ; -memdisk
                            ; not implemented
endif ; -memdisk
                          popa
                          jmp naechste_formel
  ;------------------------------------------------------------------



berechne_abhaengigkeiten_ende:

                        pop es
                        popa
                        ret
a_endp                  berechne_abhaengigkeiten

;***************************************************************************
; Eingabe ax=Variablennummer
;    oder ax=$8000+Wert
;
; Ausgabe ax=Wert
a_proc                  hole_variablen_wert
                        test ah,080h
                        jz hole_variablen_wert_variable

                        and ah,07fh
                        ret

hole_variablen_wert_variable:

                        push2 cx,si
                          mov cx,ax
                          call liefere_variablen_adresse
                          mov ax,[si].aktuelle_einstellung
                        pop2 si,cx
                        ret
a_endp                  hole_variablen_wert

;***************************************************************************
; Eingabe:
;   ax=Variablennummer
; Ausgabe:
;   di=Ofs(Zeichenkette[0])
;   cx=grî·te LÑnge (undefiniert fÅr Drehfeld)

a_proc                  hole_zeichenkettenvariable
                        push si
                          mov cx,ax
                          call liefere_variablen_adresse
                          mov di,si
                          call liefere_aktuellezeichenkette_der_variable
                          mov di,si
                        pop si
                        ret
a_endp                  hole_zeichenkettenvariable

;***************************************************************************
; Eingabe:
;   ax=Variablennummer
a_proc                  zeichenkettenpflege
                        pusha
                          mov cx,ax
                          call liefere_variablen_adresse
                          mov di,si
                          call zeichenkettenpflege_rec
                        popa
                        ret
a_endp                  zeichenkettenpflege

;***************************************************************************
; Eingabe:
;   di=Variablenblock
a_proc                  zeichenkettenpflege_rec
                        pusha

                          call liefere_aktuellezeichenkette_der_variable
                          mov di,si

                          movzx ax,byte ptr [di]
                          inc di

                          sub cx,ax             ; cx:=Grî·e des unbenutzten Platzes
                          add di,ax             ; di:=Zeichenkettenende

                          mov al,' '
                          cld
                          rep stosb

                        popa
                        ret
a_endp                  zeichenkettenpflege_rec

;***************************************************************************


; Eingabe ax=Variablennummer
;         dx=Wert

a_proc                  schreibe_variablen_wert
                        push2 cx,si
                          mov cx,ax
                          call liefere_variablen_adresse
                          mov [si].aktuelle_einstellung,dx
                        pop2 si,cx
                        ret
a_endp                  schreibe_variablen_wert

;***************************************************************************
; Eingabe
;   DS:DX,DS:DI
; Ausgabe
;   ax=Gleichheit(boolean)

a_proc                  strcomp_dx_di
                        push4 es,si,di,cx
                          push ds
                          pop es
                          mov si,dx

                          cld
                          cmpsb
                          jne strcomp_dx_di_ungleich

                          movzx cx,byte ptr [si-1]

                          rep cmpsb
  strcomp_dx_di_ungleich:
                          setz al
                          mov ah,0

                        pop4 cx,di,si,es
                        ret
a_endp                  strcomp_dx_di

;***************************************************************************
; -> ds:si
; -> es:dx
; <- zf

a_proc                  p8str_vergleich_ignoriere_grossklein
                        pusha
                          mov di,dx
                          cld
                          ; LÑngenvergleich
                          lodsb
                          cmp byte ptr [di],al ; ZF !
                          jne p8str_vergleich_ignoriere_grossklein_ende
                          inc di

                          ; Inhaltsvergleich
                          movzx cx,al

  p8str_vergleich_ignoriere_grossklein_schleife:
                          test cx,cx ; ZF !
                          jz p8str_vergleich_ignoriere_grossklein_ende

                          lodsb
                          call grossbuchstabe

                          xchg al,ah
                          mov al,byte ptr [di]
                          inc di
                          call grossbuchstabe

                          dec cx

                          cmp al,ah ; ZF !
                          je p8str_vergleich_ignoriere_grossklein_schleife

  p8str_vergleich_ignoriere_grossklein_ende:
                        popa
                        ret
a_endp                  p8str_vergleich_ignoriere_grossklein

;***************************************************************************
; -> ds:si=p8str
; <- ax
; <- cf

a_proc                  val_p8str_zu_word
                        push3 cx,dx,si

                          null dx               ; Ergebnis

                          cld
                          lodsb
                          movzx cx,al
                          jcxz val_p8str_zu_word_fehler

val_p8str_zu_word_schleife:
                          ; alte Zahl*10
                          ; 10=2*5=2*(1+4)
                          mov ax,dx             ;  1/1
                          shl dx,2              ;  4/1
                          add dx,ax             ;  5/1
                          add dx,dx             ; 10/1

                          lodsb
                          cmp al,'0'
                          jb val_p8str_zu_word_fehler
                          cmp al,'9'
                          ja val_p8str_zu_word_fehler

                          sub al,'0'
                          mov ah,0
                          add dx,ax
                          loop val_p8str_zu_word_schleife

                          clc
                          jmp val_p8str_zu_word_Ende
val_p8str_zu_word_fehler:
                          stc
val_p8str_zu_word_Ende:
                          mov ax,dx
                        pop3 si,dx,cx
                        ret
a_endp                  val_p8str_zu_word

;***************************************************************************
zeichenketten_zwischenspeicher: db 256*2 dup (0)
;***************************************************************************
; DS:DI:string[4] -> AX

a_proc                  Val_Hex4
                        push3 cx,dx,di
                          null dx
                          movzx cx,byte ptr [di]
                          inc di
                          jcxz Val_Hex4_Fehler
  Val_Hex4_Schleife:
                          mov al,[di]
                          inc di
                          sub al,'0'
                          if_b <mov al,0>
                          cmp al,9
                          jbe Val_Hex4_Addieren
                          add al,'0'
                          and al,(not 020h)
                          sub al,'A'-10
                          cmp al,15
                          if_a <mov al,0>
  Val_Hex4_Addieren:
                          shl dx,4
                          mov ah,0
                          add dx,ax
                          loop Val_Hex4_Schleife
  Val_Hex4_Fehler:
                          mov ax,dx
                        pop3 di,dx,cx
                        ret
a_endp                  Val_Hex4

;***************************************************************************
; Eingabe ax=Variable
; Ausgabe ax=Wert

a_proc                  Val_Hex4_oder_16bit_Zahl
                        test ah,080h
                        jz Val_Hex4_oder_16bit_Zahl__variable

                        ; Zahl 0..$7fff in Konstantenform
                        and ah,07fh
                        ret

  Val_Hex4_oder_16bit_Zahl__variable:
                        push3 cx,si,di

                          mov cx,ax
                          call liefere_variablen_adresse

                          ; Wert fÅr Typ Zahl
                          mov ax,[si].aktuelle_einstellung

                          cmp [si].variablentyp,variablentyp_zahl
                          je Val_Hex4_oder_16bit_Zahl__variable_weiter

                          ; Wert fÅr Typ Drehfeld oder Zeichenkette
                          mov di,si
                          call liefere_aktuellezeichenkette_der_variable

                          mov di,si
                          call Val_Hex4

  Val_Hex4_oder_16bit_Zahl__variable_weiter:

                        pop3 di,si,cx
                        ret
a_endp                  Val_Hex4_oder_16bit_Zahl

;***************************************************************************

                        ; <- ds:si=@String[0]
                        ; <- ds:di=@integer-Variable

                        ; -> carry set if assignment to spinbutton failed

a_proc                  convert_string_to_numeric_variable
                        pusha

                          cmp [di].variablentyp,variablentyp_zahl
                          je verknuepfung_STR_VAL_zahl

                          ; variablentyp_drehfeld
                          ; 1..Anzahl versuchen...
                          mov cx,[di].anzahl_einstellungen
                          mov bx,1
                          push di
                            call mov_ax_di_zeichenketteninhalt
                            mov dx,ax
                            inc dx   ; maximale ElementlÑnge Åbergehen
  verknuepfung_STR_VAL_DREHFELD_schleife:
                            call p8str_vergleich_ignoriere_grossklein
                            jnz verknuepfung_STR_VAL_DREHFELD_ungleich

                            ; Gleichheit gefunden
                            mov ax,bx ; Ergebnis=Nummer des Drehfeldelementes
                          pop di
                          jmp verknuepfung_STR_VAL_Zuweisung_Ende

  verknuepfung_STR_VAL_DREHFELD_ungleich:
                            inc bx ; eine Einstellung weiter
                            dec cx ; eine Mîglichkeit weniger
                            jcxz verknuepfung_STR_VAL_DREHFELD_nichtgefunden
                            ; nÑchste Einstellung versuchen
                            xchg di,dx
                              movzx ax,byte ptr [di] ; ZeichenkettenlÑnge
                              inc ax
                            xchg di,dx
                            add dx,ax
                            jmp verknuepfung_STR_VAL_DREHFELD_schleife
  verknuepfung_STR_VAL_DREHFELD_nichtgefunden:
                          pop di
                          ; assignment failed so far,
                          ; but we give a second chance by numeric evalution

                          ; vielleich 'zahl' ?
                          jmp verknuepfung_STR_VAL_zahl_nicht_boolean

  verknuepfung_STR_VAL_zahl:
                          cmp [di].anzahl_einstellungen,1
                          jne verknuepfung_STR_VAL_zahl_nicht_boolean

                          ; false/falsch ->0
                          ; true/wahr    ->1
                          mov ax,0
                          mov dx,Offset p8str_false
                          call p8str_vergleich_ignoriere_grossklein
                          jz verknuepfung_STR_VAL_Zuweisung_Ende
                          mov dx,Offset p8str_falsch
                          call p8str_vergleich_ignoriere_grossklein
                          jz verknuepfung_STR_VAL_Zuweisung_Ende

                          inc ax

                          mov dx,Offset p8str_true
                          call p8str_vergleich_ignoriere_grossklein
                          jz verknuepfung_STR_VAL_Zuweisung_Ende
                          mov dx,Offset p8str_wahr
                          call p8str_vergleich_ignoriere_grossklein
                          jz verknuepfung_STR_VAL_Zuweisung_Ende

                          call val_p8str_zu_word
                          jc verknuepfung_STR_VAL_Ende ; pass carry
                          test ax,0fffeh ; boolean: 0 oder 1
                          stc                           ; fail when invaild
                          jnz verknuepfung_STR_VAL_Ende
                          jmp verknuepfung_STR_VAL_Zuweisung_Ende

  verknuepfung_STR_VAL_zahl_nicht_boolean:
                          call val_p8str_zu_word
                          jc verknuepfung_STR_VAL_Ende ; pass carry

                         ;Zuweisung von Werten erfolgt beachtet die Schranken nicht.
                         ;cmp ax,1
                         ;jb verknuepfung_STR_VAL_Ende
                         ;cmp ax,[di].anzahl_einstellungen
                         ;ja verknuepfung_STR_VAL_Ende

  verknuepfung_STR_VAL_Zuweisung_Ende:
                          mov [di].aktuelle_einstellung,ax

                          clc                           ; success

  verknuepfung_STR_VAL_Ende:

                        popa
                        ret
a_endp                  convert_string_to_numeric_variable

;***************************************************************************

                        ; <- ds:si=@String[0]
                        ; <- ds:di=@Variable

                        ; -> carry set if assignment to spinbutton failed

a_proc                  store_string_to_anything
                        pusha
                          cmp [di].variablentyp,variablentyp_zeichenkette
                          je store_string_to_string

                          call convert_string_to_numeric_variable
                          ; pass carry flag
                          jmp exit_store_string_to_anything
  store_string_to_string:
                          ; copy string to string variable, maximum possible length
                          push es
                            movzx ax,Byte Ptr [si] ; source length
                            mov cx,[di].anzahl_einstellungen ; target space
                            mov dx,cx
                            cmp cx,ax
                            if_a <mov cx,ax>
                            call mov_ax_di_zeichenketteninhalt
                            mov di,ax
                            push cs
                            pop es
                            sub dx,cx ; dx:=target space untouched
                            cld
                            mov al,cl
                            inc si ; ignore length
                            stosb  ; store length
                            rep movsb
                            ; clean remaining room
                            mov cx,dx
                            mov al,' '
                            rep stosb
                          pop es

                          clc ; success (even when cut a bit..)

  exit_store_string_to_anything:
                        popa
                        ret
a_endp                  store_string_to_anything

;***************************************************************************

;***************************************************************************

                        ; ds:si=@String[0]
                        ; cx=Variable number

a_proc                  store_string_to_anything_varnum
                        pusha

                          mov di,si
                          call liefere_variablen_adresse ; cx
                          xchg di,si
                          ; ds:si=@String[0]
                          ; ds:di=@Variable
                          call store_string_to_anything

                         ; no longer needed, done by store_string_to_anything
                         ;cmp [di].variablentyp,variablentyp_zeichenkette
                         ;if_e <call zeichenkettenpflege_rec>

                        popa
                        ret
a_endp                  store_string_to_anything_varnum

;***************************************************************************
; si=string
; bx=variable name (p8)
a_proc                  store_string_to_anything_varname
                        pusha

                          xchg si,bx
                            ; si->di
                            call suche_variable_p8
                          xchg si,bx

                          test di,di ; variable may not exist..
                          jz exit_store_string_to_anything_varname

                          ; ds:si->ds:di
                          call store_string_to_anything

                         ; no longer needed, done by store_string_to_anything
                         ;cmp [di].variablentyp,variablentyp_zeichenkette
                         ;if_e <call zeichenkettenpflege_rec>

  exit_store_string_to_anything_varname:
                        popa
                        ret
a_endp                  store_string_to_anything_varname
;***************************************************************************
