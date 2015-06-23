Title   Check for 2OS2, SVISTA

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

is_2os2                         db 0

p8str name_os2csm_2os2          'OS2CSM_2OS2'
p8str searchstring_twoos2two    'twoOStwo(R) v'
p8str searchstring_svista       'SViSta(R) v' ; +'SVISTA(R) v'
p8str searchstring_svista200410 'SVISTA(R) 2'
p8str searchstring_parallels    'Parallels(R) 2'

; 0000B000 74 77 6F 4F ³ 53 74 77 6F ³ 28 52 29 20 ³ 76 32 2E 32  twoOStwo(R) v2.2
; 0000B010 30 20 28 43 ³ 29 32 30 30 ³ 30 2D 32 30 ³ 30 33 20 4E  0 (C)2000-2003 N
; 0000B020 65 74 53 79 ³ 73 20 47 6D ³ 62 48 2E 0D ³ 0A 74 69 6E  etSys GmbH...tin
; 0000B030 79 42 49 4F ³ 53 20 56 31 ³ 2E 33 61 20 ³ 28 43 29 31  yBIOS V1.3a (C)1
; 0000B040 39 39 37 2D ³ 32 30 30 31 ³ 20 50 43 20 ³ 45 6E 67 69  997-2001 PC Engi
; 0000B050 6E 65 73 0D ³ 0A 0A 00 50 ³ 61 72 69 74 ³ 79 20 45 72  nes....Parity Er
; 0000B060 72 6F 72 20 ³ 21 0D 0A 00 ³ 49 2F 4F 20 ³ 63 68 61 6E  ror !...I/O chan

; beta5-2004.08.03
; 0000B000:  53 56 69 53-74 61 28 52-29 20 76 31-2E 30 20 28  SViSta(R) v1.0 (
; 0000B010:  43 29 20 32-30 30 34 20-53 65 72 65-6E 69 74 79  C) 2004 Serenity
; 0000B020:  20 53 79 73-74 65 6D 73-20 49 6E 74-65 72 6E 61   Systems Interna
; 0000B030:  74 69 6F 6E-61 6C 2E 0D-0A 41 6C 6C-20 52 69 67  tional.  All Rig
; 0000B040:  68 74 73 20-52 65 73 65-72 76 65 64-0D 0A 0D 0A  hts Reserved
; 0000B050:  00 74 69 6E-79 42 49 4F-53 20 56 31-2E 33 61 20   tinyBIOS V1.3a
; 0000B060:  28 43 29 31-39 39 37 2D-32 30 30 31-20 50 43 20  (C)1997-2001 PC
; 0000B070:  45 6E 67 69-6E 65 73 0D-0A 0A 00 50-61 72 69 74  Engines    Parit
; 0000B080:  79 20 45 72-72 6F 72 20-21 0D 0A 00-49 2F 4F 20  y Error !   I/O

; release 2004.10.08
; 0000B000:  53 56 49 53-54 41 28 52-29 20 32 30-30 34 20 62  SVISTA(R) 2004 b
; 0000B010:  75 69 6C 64-20 31 30 35-35 20 28 43-29 20 32 30  uild 1055 (C) 20
; 0000B020:  30 34 20 53-65 72 65 6E-69 74 79 20-53 79 73 74  04 Serenity Syst
; 0000B030:  65 6D 73 20-49 6E 74 65-72 6E 61 74-69 6F 6E 61  ems Internationa
; 0000B040:  6C 2E 0D 0A-41 6C 6C 20-52 69 67 68-74 73 20 52  l.  All Rights R
; 0000B050:  65 73 65 72-76 65 64 0D-0A 0D 0A 00-74 69 6E 79  eserved     tiny

; 2005.08.10:
; "Parallels(R) 2.0 build 1400 (C) 2005 Parallels Software International Inc."


a_proc          check_2os2_svista
                pusha
                push es

                  push 0f000h
                  pop es
                  cld

                  mov si,Offset searchstring_twoos2two
                  call search_bios_ic
                  jz found_2os2_or_svista

                  mov si,Offset searchstring_svista
                  call search_bios_ic
                  jz found_2os2_or_svista

                  mov si,Offset searchstring_svista200410
                  call search_bios_ic
                  jz found_2os2_or_svista

                  mov si,Offset searchstring_parallels
                  call search_bios_ic

  found_2os2_or_svista:

                  setz dl
                  mov dh,0
                  mov [is_2os2],dl

                pop es
                mov si,Offset name_os2csm_2os2
                call suche_variable_p8
                test di,di
                if_nz <mov [di].aktuelle_einstellung,dx>
                popa
                ret
a_endp          check_2os2_svista

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
a_proc          search_bios_ic
                pusha
                  sub di,di
                  mov cx,0fff0h
                  lodsb
                  movzx dx,al
                  lodsb
                  dec dx
  loop_search_bios_ic:
                  repne scasb
                  jne exit_search_bios_ic

                  pusha
                    mov cx,dx
                    test cx,cx
                    jz compare_done_search_bios_ic

  compare_loop_search_bios_ic:
                    lodsb
                    call grossbuchstabe
                    mov ah,al
                    mov al,Byte Ptr es:[di]
                    inc di
                    call grossbuchstabe
                    cmp ah,al
                    jne compare_done_search_bios_ic
                    loop compare_loop_search_bios_ic
                    test cx,cx

  compare_done_search_bios_ic:
                  popa
                  jne loop_search_bios_ic

  exit_search_bios_ic:
                popa
                ret
a_endp          search_bios_ic

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

