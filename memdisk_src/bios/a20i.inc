Title A20/extended memory copy method setup

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; 'ThinkPad T42'
; 'Phoenix FirstBIOS(tm) Notebook Pro Version 2.0 for IBM ThinkPad'

p8str T42_searchstring          'Phoenix FirstBIOS(tm) Notebook Pro'

; 'Phoenix ServerBIOS 3 Release 6.1.U'
; 'IBM eServer x226-[86480AY]-'

p8str x226_searchstring         'Phoenix ServerBIOS'

; 'SystemSoft BIOS For 430TX (c) SystemSoft 1996...'
p8str quarz_searchstring        'SystemSoft BIOS For 430TX'

; Soyo mainboard with VIA chipset (speedup 38->8)
p8str zucker_searchstring       '0-VP3-586B-8669-2A5LES2AC'

p8str searchstring_twoos2two    'twoOStwo(R) v'
p8str searchstring_svista       'SViSta(R) v'
p8str searchstring_svistaU      'SVISTA(R) v'
p8str searchstring_svista2      'SVISTA(R) 2'
p8str searchstring_vpc          'Virtual PC'

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          setup_a20_access
                STEP 'A20I'
                push es
                pushad

                  cmp [a20_access],a20_access_auto
                  jne @@exit_setup_a20_access

                  mov [a20_access],a20_access_private

                  push 0f000h
                  pop es

                  ; Thinkpad T42 dramticly faster with private code
                  mov si,Offset T42_searchstring
                  call search_bios
                  jnc @@exit_setup_a20_access

                  ; dramaticly slow
                  mov si,Offset x226_searchstring
                  call search_bios
                  jnc @@exit_setup_a20_access

                  ; my notebook: a bit faster with private code
                  mov si,Offset quarz_searchstring
                  call search_bios
                  jnc @@exit_setup_a20_access

                  mov si,Offset zucker_searchstring
                  call search_bios
                  jnc @@exit_setup_a20_access


                  ; SVISTA is faster with BIOS code
                  mov si,Offset searchstring_twoos2two
                  call search_bios
                  jnc @@exit_setup_a20_access_set_BIOS

                  mov si,Offset searchstring_svista
                  call search_bios
                  jnc @@exit_setup_a20_access_set_BIOS

                  mov si,Offset searchstring_svistaU
                  call search_bios
                  jnc @@exit_setup_a20_access_set_BIOS

                  mov si,Offset searchstring_svista2
                  call search_bios
                  jnc @@exit_setup_a20_access_set_BIOS

                  ; VPC is faster with private code
                  mov si,Offset searchstring_vpc
                  call search_bios
                  jnc @@exit_setup_a20_access

  @@exit_setup_a20_access_set_BIOS:

                  mov [a20_access],a20_access_BIOS

  @@exit_setup_a20_access:

                  ; when using the private extended memory copy function,
                  ; 'globaly' enabling the A20 would speed up the copy
                  ; function since it does not need to switch/undo every time
                  cmp [a20_access],a20_access_private
                  jne @@exit2_setup_a20_access

                  call enable_a20

  @@exit2_setup_a20_access:


                popad
                pop es
                ret
a_endp          setup_a20_access


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                        ; ds:si search string
                        ; es=F000 segment
                        ; -> cf=1=not found
                        ;    cf=0=found
a_proc                  search_bios
                        pusha

                          sub di,di
                          mov cx,0fff0h
                          cld
                          mov dh,0
                          mov dl,Byte Ptr ds:[si]

                          test dx,dx            ; empty string?
                          clc
                          jz @@exit

                          inc si
                          lodsb                 ; may not be '?'
                          dec dx                ; one char less

  @@loop:
                          test cx,cx
                          stc
                          jz @@exit

                          repnz scasb

                          test cx,cx
                          stc
                          jz @@exit

                          pusha
                            mov cx,dx

                            test cx,cx
                            clc
                            jz @@compare_done
  @@compare_loop:
                            lodsb
                            mov ah,es:[di]
                            inc di
                            cmp al,ah
                            je @@compare_next
                            cmp al,'?'
                            stc
                            jne @@compare_done
  @@compare_next:
                            loop @@compare_loop
                            clc
  @@compare_done:
                          popa
                          ; have clc=equal stc=differnt
                          jc @@loop
  @@exit:
                        ; have clc=found stc=not found

                        popa
                        ret
search_bios             endp

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
