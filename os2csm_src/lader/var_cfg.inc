Title   Load/Save menu values to os2csm.set (memdisk only)

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

a_proc          load_var_cfg
                push fs
                pushad

                  cmp [icmd].os2csm_set_memory,0
                  je exit_load_var_cfg

                  mov dx,[icmd].os2csm_set_size
                  lfs si,[icmd].os2csm_set_memory
                  add dx,si ; dx=end of file

  loop_load_var_cfg:
                  cmp si,dx
                  jae eof_load_var_cfg

                  ; begin of line - search identifier
                  call bestimme_variablen_laenge
                  call suche_variable_fs_si
                  test di,di
                  jz unknown_variable_load_var_cfg

                  add si,cx
                  inc si ; '='

                  cmp Byte Ptr fs:[si],'"'
                  je load_var_cfg_string

                  ; assign numeric value - check if valid type
                  cmp [di].variablentyp,variablentyp_zeichenkette
                  je unknown_variable_load_var_cfg

                  ; read integer
                  push ds
                    push fs
                    pop ds
                    call lies_dezimalzahl
                  pop ds
                  mov [di].aktuelle_einstellung,ax
                  jmp skip_linebreak_load_var_cfg


  load_var_cfg_string:
                  ; read string to string or spinbutton
                  ; first copy to pstring
                  inc si ; skip first '"'
                  mov bx,Offset zeichenketten_zwischenspeicher+1
  loop_stringend_varcfg_string:
                  mov al,fs:[si]
                  inc si
                  cmp al,'"'
                  je found_stringend_varcfg_string

                  mov Byte Ptr cs:[bx],al
                  inc bx
                  jmp loop_stringend_varcfg_string

  found_stringend_varcfg_string:
                  ; set length byte
                  sub bx,Offset zeichenketten_zwischenspeicher+1
                  mov Byte Ptr cs:[zeichenketten_zwischenspeicher],bl

                  pusha
                    mov si,Offset zeichenketten_zwischenspeicher
                   ;mov di,di
                    call store_string_to_anything
                  popa
                 ;jmp skip_linebreak_load_var_cfg

  unknown_variable_load_var_cfg:
  skip_linebreak_load_var_cfg:
                  cmp si,dx
                  jae eof_load_var_cfg
                  inc si
                  cmp Byte Ptr fs:[si],10 ; find #13,#10 line end
                  jne skip_linebreak_load_var_cfg
                  inc si
                  jmp loop_load_var_cfg

  eof_load_var_cfg:
                  ; done,deallocate it
                  mov si,Offset icmd.os2csm_set_memory
                  call freemem
                  mov [icmd].os2csm_set_size,0

  exit_load_var_cfg:

                popad
                pop fs
                ret
a_endp          load_var_cfg

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

a_proc          save_var_cfg
                push es
                pushad

                  ; Zeichenkette oder Drehfeld->Zeichenkette 'VAR="123"'^m^j
                  ; Ziffer->Zeichenkette 'VAR=123'^m^j

                  ; 1. Durchlauf: Speicherbedarf berechnen
                  null dx
                  mov di,[variablen_bereich]
                  mov cx,[anzahl_variablen]

  save_var_cfg_berechne_speicherlaenge:
                  cmp [di].seitennummer,0
                  je zaehle_nur_aenderbare_variablen1

                  movzx ax,[di].namen_laenge
                  test ax,ax
                  jz zaehle_nur_aenderbare_variablen1

                  add dx,ax
                  add dx,3 ; '=' ^m^j
                  cmp [di].variablentyp,variablentyp_zahl
                  if_ne <add dx,2> ; '""'
                  push cx
                    call liefere_aktuellezeichenkette_der_variable
                    movzx ax,Byte Ptr [si]
                  pop cx
                  add dx,ax                     ; '123'

  zaehle_nur_aenderbare_variablen1:
                  add di,[di].blocklaenge
                  loop save_var_cfg_berechne_speicherlaenge

                  movzx eax,dx
                  mov icmd.os2csm_set_size,ax
                  mov si,Offset icmd.os2csm_set_memory
                  push eax
                    add eax,512 ; no sector wraps
                    call getmem
                  pop eax

                  ; 2. Durchlauf: Speicher f걄len
                  les di,icmd.os2csm_set_memory

                  mov si,[variablen_bereich]
                  mov cx,[anzahl_variablen]

  save_var_cfg_2:
                  push cx
                  push si

                    cmp [si].seitennummer,0
                    je zaehle_nur_aenderbare_variablen2

                    movzx ax,[si].namen_laenge
                    test ax,ax
                    jz zaehle_nur_aenderbare_variablen2

                    cmp [si].variablentyp,variablentyp_zahl
                    setne dl ; '"'

                    push si
                      movzx cx,[si].namen_laenge
                      lea si,[si].namen_zeichen
                      cld
                      rep movsb
                    pop si
                    mov al,'='
                    stosb

                    cmp dl,1
                    mov al,'"'
                    if_e <stosb>

                    push di
                      mov di,si
                      call liefere_aktuellezeichenkette_der_variable
                    pop di
                    cld
                    lodsb
                    movzx cx,al
                    rep movsb

                    cmp dl,1
                    mov al,'"'
                    if_e <stosb>

                    mov al,13
                    stosb
                    mov al,10
                    stosb


  zaehle_nur_aenderbare_variablen2:

                  pop si
                  pop cx
                  add si,[si].blocklaenge
                  loop save_var_cfg_2


                popad
                pop es
                ret
a_endp          save_var_cfg

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
