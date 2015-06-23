Title   Erkennung CPU-Typ und Cache-Manipulation
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                                .286p

cpu_typ                         db 0
cpu_modell                      db 0
cpu_stepping                    db 0

                                ;  'GenuineIntel'
                                ;  'AuthenticAMD'
                                ;  '
cpu_name                        db 3*4*4 dup ('$'),'$'


pentium_msr                     db 0
mtrr_supported                  db 0
cpu_amd                         db 0
cpu_intel                       db 0
v86_mode                        db 0

Public cpu_typ
Public cpu_name
Public pentium_msr
Public mtrr_supported
Public cpu_amd
Public cpu_intel
Public pci_present

cr0_org                         dd ?
k7_cache_org                    db 8 dup (?) ; 64 Bit

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                                ; opcode.txt (inter51)
a_proc                          bestimme_cpu_typ
                                pushf
                                push ax

                                  ; 8086 - likelly cause hang even before
                                  pushf
                                  pop ax
                                  and ah,00fh                   ; clear Bit15..12
                                  push ax
                                  popf
                                  pushf
                                  pop ax
                                  and ah,0f0h
                                  cmp ah,0f0h
                                  je ende_bestimme_cpu_typ

                                  mov cpu_typ,2                 ; 286+

                                  ; Ud2
                                  ;trap_protect <db 00fh,00bh>

                                  sub ax,ax
                                  trap_protect <db 066>,<inc ax> ; inc eax
                                  test ax,ax
                                  jz ende_bestimme_cpu_typ

                                  .586p
                                  mov cpu_typ,3                 ; 386+


                                  pushfd
                                  pushad

                                  ; 486 check from uniflash

                                  pushfd
                                    pushfd
                                    pop eax
                                    mov ebx,eax
                                    xor eax,Bit18 ; Alignment Check bit
                                    push eax
                                    popfd
                                    pushfd
                                    pop eax
                                  popfd
                                  xor eax,ebx
                                  shr eax,18+1
                                  jnc ende386_bestimme_cpu_typ

                                  mov cpu_typ,4                 ; 486+

                                  pushfd
                                  pop eax
                                  or eax,Bit21                  ; set ID bit
                                  push eax
                                  popfd

                                  pushfd
                                  pop eax
                                  shr eax,21+1
                                  jnc ende386_bestimme_cpu_typ

                                  mov eax,0
                                  cpuid
                                  cmp eax,1
                                  jb ende386_bestimme_cpu_typ

                                  mov si,Offset cpu_name
                                  mov [si+0],ebx
                                  mov [si+4],edx
                                  mov [si+8],ecx
                                  cmp ecx,'cAMD'
                                  sete cpu_amd
                                  cmp ecx,'ntel'
                                  sete cpu_intel

                                  mov eax,1
                                  cpuid

                                  mov dl,al
                                  and dl,0fh
                                  mov [cpu_stepping],dl
                                  shr al,4
                                  mov [cpu_modell],al
                                  shr ax,8              ; bit11..8 family
                                  and al,0fh
                                  mov cpu_typ,al

                                  test edx,Bit5
                                  setne [pentium_msr]
                                  test edx,Bit12
                                  setne [mtrr_supported]

                                  mov eax,080000000h
                                  cpuid
                                  cmp eax,080000004h
                                  jb kein_erweiterter_cpu_name

                                  mov eax,080000002h
                                  mov si,Offset cpu_name
  erweiterer_cpu_name_schleife:
                                  push eax
                                    cpuid
                                    mov [si+ 0],eax
                                    mov [si+ 4],ebx
                                    mov [si+ 8],ecx
                                    mov [si+12],edx
                                    add si,4*4
                                  pop eax
                                  inc eax
                                  cmp eax,080000004h
                                  jne erweiterer_cpu_name_schleife
  kein_erweiterter_cpu_name:

  ende386_bestimme_cpu_typ:
                                  popad
                                  popfd

                                  .286p
  ende_bestimme_cpu_typ:

                                  mov al,cpu_typ
                                  call ausschrift_4bit
                                  mov al,'8'
                                  call ausschrift_zeichen
                                  mov al,'6'
                                  call ausschrift_zeichen

                                  cmp cpu_typ,4
                                  jb kein_modell_stepping

                                  mov al,':'
                                  call ausschrift_zeichen
                                  mov al,cpu_modell
                                  call ausschrift_4bit
                                  mov al,':'
                                  call ausschrift_zeichen
                                  mov al,cpu_stepping
                                  call ausschrift_4bit
  kein_modell_stepping:
                                  cmp Byte Ptr [cpu_name],'$'
                                  je ohne_cpu_name

                                  mov al,' '
                                  call ausschrift_zeichen
                                  mov al,'"'
                                  call ausschrift_zeichen
                                  ausschrift_a cpu_name
                                  mov al,'"'
                                  call ausschrift_zeichen

  ohne_cpu_name:
                                  ausschrift_a zeilenumbruch

                                  cmp cpu_typ,3
                                  jbe ohne_cache_test

                                  ausschrift text_wbinvd_test

                                  smsw ax
                                  test al,Bit0
                                  jz test_cache_real

                                  mov v86_mode,1
                                  ausschrift text_wbinvd_v86
  test_cache_real:
                                  call cache_sichern_und_abschalten
                                  call cache_wiederherstellen

                                  cmp v86_mode,1
                                  if_ne <ausschrift text_ok>

                                  ausschrift_a zeilenumbruch
  ohne_cache_test:

                                pop ax
                                popf
                                ret
a_endp                          bestimme_cpu_typ

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                          cache_sichern_und_abschalten
                                pushf
                                  cli

                                  cmp cpu_typ,3
                                  jbe ende_cache_sichern_und_abschalten

                                  .586p

                                  pushfd
                                  pushad

                                  ; 486+

                                  call cache_leeren
                                  trap_protect <wbinvd>

                                  trap_protect <mov eax,cr0>
                                  mov [cr0_org],eax
                                  or eax,Bit30+Bit29 ; +Cache disabled +Write-through
                                  trap_protect <mov cr0,eax>

                                  trap_protect <wbinvd>
                                  call cache_leeren

                                  ;<< AMD L2: K7L2CACH.INC

                                  cmp cpu_amd,1
                                  jne nicht_amd_k7_cache_aus

                                  cmp cpu_typ,6
                                  jb nicht_amd_k7_cache_aus

                                  mov ecx,0C0010010h
                                  trap_protect <rdmsr>
                                  mov DWord Ptr [Offset k7_cache_org+0],eax
                                  mov DWord Ptr [Offset k7_cache_org+4],edx
                                  or  eax,000080000h
                                  trap_protect <wrmsr>

  nicht_amd_k7_cache_aus:
                                  popad
                                  popfd

                                  .286p

  ende_cache_sichern_und_abschalten:
                                  sti
                                popf
                                ret
a_endp                          cache_sichern_und_abschalten

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                          cache_leeren
                                pusha
                                  cmp cpu_typ,3
                                  jbe ende_cache_leeren

                                  .586p
                                  cmp [v86_mode],1
                                  je cache_leeren_v86

                                  call cpu_4GiB_mode_cache_loeschen
                                  jmp ende_cache_leeren
  cache_leeren_v86:

                                  trap_protect <wbinvd>
                                  push ds
                                  push eax
                                    mov dx,09000h
  cache_leeren_v86_schleife:
                                    mov ds,dx
                                    mov cx,04000h
                                    sub si,si
                                    cld
                                    rep lodsd
                                    sub dh,010h
                                    jnz cache_leeren_v86_schleife

                                  pop eax
                                  pop ds
                                  trap_protect <wbinvd>

                                  .286p
  ende_cache_leeren:
                                popa
                                ret
a_endp                          cache_leeren

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                          cache_wiederherstellen
                                pushf
                                  cli

                                  cmp cpu_typ,3
                                  jbe ende_cache_wiederherstellen

                                  .586p

                                  pushfd
                                  pushad

                                  ; 486+

                                  call cache_leeren
                                  trap_protect <wbinvd>

                                  cmp cpu_amd,1
                                  jne nicht_amd_k7_cache_ein

                                  cmp cpu_typ,6
                                  jb nicht_amd_k7_cache_ein

                                  mov ecx,0C0010010h
                                  mov eax,DWord Ptr [Offset k7_cache_org+0]
                                  mov edx,DWord Ptr [Offset k7_cache_org+4]
                                  trap_protect <wrmsr>
  nicht_amd_k7_cache_ein:

                                  cmp [mtrr_supported],1
                                  jne nicht_enable_mtrr

                                  mov ecx,02ffh ; Pentium Pro - "MTRRdefType" - DEFAULT MEMORY TYPE
                                  sub di,di
                                  trap_protect <rdmsr>,<inc di>
                                  test di,di
                                  jz nicht_enable_mtrr

                                  push eax
                                  push edx

                                  and ax,(not Bit10)    ; 10: Fixed MTRR enable
                                  trap_protect <wrmsr>

                                  pop edx
                                  pop eax

                                  trap_protect <wrmsr>
  nicht_enable_mtrr:

                                  mov eax,[cr0_org]
                                  trap_protect <mov cr0,eax>

                                  trap_protect <wbinvd>
                                  call cache_leeren


                                  popad
                                  popfd

                                  .286p

  ende_cache_wiederherstellen:
                                  sti
                                popf
                                ret
a_endp                          cache_wiederherstellen

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

;--flat_code                    equ 1

ifdef flat_code
                                include flat.inc
else

                                ; from flat (1.2)
                                Align 8
gdt:
                                dw 15           ; limit (16 byte)
                                dw Offset gdt,0
                                dw 0            ; unused

flat_descriptor:                dw 0ffffh       ; limit (15..0)
                                db 0,0,0        ; base (23..0)
                                db 092h         ; access rights
                                db 0cfh         ; page granularity, limit(19..16)
                                db 0            ; base (31..24)
endif

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                          cpu_4GiB_mode_cache_loeschen
                                .586p
                                pushf
                                cli
                                pushad

                                  call save_and_enable_a20

                                  push ds
ifdef flat_code
                                  call FLAT_install
else
                                  mov si,Offset gdt
                                  movzx esi,si
                                  mov ax,cs
                                  movzx eax,ax
                                  shl eax,4
                                  add eax,esi
                                  mov DWord Ptr [si+2],eax ; cs shl 4+Offset gdt

                                  lgdt QWord Ptr [si]

                                  mov eax,cr0
                                  or al,Bit0
                                  mov cr0,eax
                                  jmp flush_queue1
  flush_queue1:

endif

                                  wbinvd

                                  mov eax,cr3
                                  mov cr3,eax

                                 ;mov ax,(Offset flat_descriptor)-(Offset gdt)
                                  mov ax,8
                                  mov ds,ax
                                  cld
                                  mov esi,4*1024*1024
                                  mov ecx,080000h
                                  rep lodsd

                                  mov esi,(512+4)*1024*1024
                                  mov ecx,080000h
                                  rep lodsd

                                  wbinvd

ifdef flat_code
                                  call FLAT_destall
else
                                  mov eax,cr0
                                  and al,not Bit0
                                  mov cr0,eax
                                  jmp flush_queue2
  flush_queue2:

endif
                                  pop ds

                                  call restore_A20

                                popad
                                ; kein sti n봳ig, da priviligiert
                                popf
                                ret
a_endp                          cpu_4GiB_mode_cache_loeschen

                                .286p
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

