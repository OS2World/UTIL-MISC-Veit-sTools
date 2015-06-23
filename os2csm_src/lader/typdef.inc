Title   types and constants
;***************************************************************************

textspeicher_unbenutzt_segment  equ 0b800h+00100h ; ab 4KB im Textspeicher

anweisung_normal                equ 0   ; immer
anweisung_anfang                equ 1   ; nur am Anfang
anweisung_ende                  equ 2   ; nur am Ende


variablentyp_zahl               equ 001 ; boolean oder byte
variablentyp_zeichenkette       equ 002
variablentyp_drehfeld           equ 003

variable_bleibt_unveraendert    equ 0
variable_packen_zu_zahl         equ 1
variable_packen_zu_zeichenkette equ 2
variable_loeschen               equ 3

variable struc
  blocklaenge           dw ?
  variablentyp          db ?
  loeschtyp             db ?
  x_position            db ?
  y_position            db ?
  seitennummer          db ?    ; 1..
  anzahl_einstellungen  dw ?    ; 0..1=boolean, (0)1..=zahl
                                ; Zeichenkettengrenze
                                ; Anzahl Drehzust„nde
  aktuelle_einstellung  dw ?    ; Wert bei Zahl
                                ; -
                                ; Drehindex 1..anzahl_einstellungen
  zeichenketteninhalt   dw ?    ; -
                                ; Abstand zu Zeichenkette
                                ; Abstand zum Drehfl„cheninhalt (..7fff)
                                ;   oder 8000+variablennummer bei Fremddefinition
  sprungtaste           db ?
  namen_laenge          db ?
  namen_zeichen         db 128 dup (?)

  ; Zeichenkette:
  ;  db L„nge
  ;  db Zeichen...

  ; Drehfeld
  ;  db gr”áte L„nge
  ;  db L„nge1
  ;  db Zeichen1..
  ;  db L„nge2
  ;  db Zeichen2..
  ;  ...
variable EndS

formel struc
  zustand_anwendbar     db ?
  if_teil               db ?
  var_if_1              dw ?
  var_if_2              dw ?
  verkuepfung           db ?
  var_verkn_1           dw ?
  var_verkn_2           dw ?
  var_verkn_3           dw ?
  var_verkn_4           dw ?
formel EndS

formel_laenge            equ <Size formel>


;STR_APPEND              00dh
;STR_COMP                00eh
;STR_DELETE              00fh
;STR_INSERT              010h
;STR_LENGTH              011h
;STR_CONCAT              012h
;STR_TRIM                013h
;STR_COPY                014h
;STR_UPCASE              015h
;STR_VAL                 016h
;STR_DISPLAY             017h
;SEARCH_PCI_DEVICEID     018h
;SEARCH_PCI_DEVICECLASS  019h
;SEARCH_PNP_DEVICEID     01ah
;SEARCH_PNP_DEVICECLASS  01bh
;COUNT_PCI_DEVICEID      01ch
;COUNT_PCI_DEVICECLASS   01dh
;COUNT_PNP_DEVICEID      01eh
;COUNT_PNP_DEVICECLASS   01fh
;QUERY_BOOTDRIVE_LETTER  020h
;SET_BOOTDRIVE_LETTER    021h
;SET_ALTF2ON_FILE        022h


groesste_verknuepfungsfunktion equ 022h

bildschirm_sicherung struc
  bildschirm_zeilen_belegt      db ?    ; 25/28/50
  cursor                        dw ?    ; 2000=unsichtbar
  cursor_pos                    dw ?    ; 0=X1:Y1
  blinken                       db ?    ; 1=blinken
  bildschirm_puffer_zeiger      dd ?
bildschirm_sicherung EndS

bildschirm_sicherung_laenge     equ <Size bildschirm_sicherung>

ergebnis_e820_typ struc
  ergebnis_e820_a               dq ? ; Adresse
  ergebnis_e820_l               dq ? ; L„nge
  ergebnis_e820_t               dd ? ; Speichertyp
ergebnis_e820_typ EndS

ergebnis_e820_laenge            equ <Size ergebnis_e820_typ>

tabelle_i15_c7_typ struc        ; interr: Tabelle 00526
  i15c7_tabellenlaenge          dw ? ; length of table (excluding this word)
                                dd ? ; local memory between 1M and 16M, in 1K blocks
                                dd ? ; local memory between 16M and 4G, in 1K blocks
  i15c7_1M_16M                  dd ? ; system memory between 1M and 16M, in 1K blocks
  i15c7_16M_4G                  dd ? ; system memory between 16M and 4G, in 1K blocks
                                dd ? ; cacheable memory between 1M and 16M, in 1K blocks
                                dd ? ; cacheable memory between 16M and 4G, in 1K blocks
                                dd ? ; 1K blocks before start of non-system memory between 1M and 16M
                                dd ? ; 1K blocks before start of non-system memory between 16M and 4G
                                dw ? ; start segment of largest free block from C0000h-DFFFFh
                                dw ? ; size of largest free block
                                dd ? ; reserved
tabelle_i15_c7_typ EndS

tabelle_i15_c7_laenge           equ <Size tabelle_i15_c7_typ>

;***************************************************************************
; pnp.inc
; inter 61 farcall.lst

Plug_and_Play_System_Device_Node struc
 size_of_device_node_in_bytes    dw ?
 device_node_number_handle       db ?
 EISA_product_identifier         dd ?
 device_type_code                db ?,?,?
 attribute_flags                 dw ?
 ; variable Teile...
Plug_and_Play_System_Device_Node EndS

;***************************************************************************
