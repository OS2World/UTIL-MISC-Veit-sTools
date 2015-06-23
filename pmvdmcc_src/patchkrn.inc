Title           patch OS2KRNL in memory for better INT 10/13 MiniVDM setup

; ATI M7 BIOS calls INT15 from INT10, requires memboot.bin mapped.
; the _VDMINT10CreateMiniVDMSub procedure only maps EBDA.
; this results in a trap or hanging machince when SNAP creates the
; MiniVDM during PMSHELL switch to graphics mode.
; This BIOS issues INT 15/AX=5F08(unknown) calls.
; The call is routed to not correctly mapped code.
; reported and seen on Thinkpad T42, when not docked
;
; similary IBM1S506.ADD, ibmint13.i13 and DaniS506.ADD have problems
; when/if they create the Int 13 VDM.
;
;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様

;
a_proc          Apply_Int10_Int13_MiniVDM_Patch
                push ds
                push es
                pushad

                  mov ax,ds
                  mov es,ax

                  ; System Anchor Segment
                  mov ax,070h
                  mov ds,ax

                  ; vm_area
                  mov si,Word Ptr ds:[000ch] ; (2c)

                  ; Kernel ModuleTableEntry records
                  mov esi,DWord Ptr ds:[si+0ch] ; (ffecf178)

                  ; FLAT DS
                  mov ds,Word Ptr ds:[0006h] ; 160(retail)/170(debug)

                  ; Object Table Entry Count
                  mov ecx,DWord Ptr ds:[esi+048h]
                  ; Object Table Offset
                  mov esi,DWord Ptr ds:[esi+044h]

  @@all_objects_loop:
                  push ecx
                  push esi

                    ; check for  readable executable discardable shared 32-bit
                    cmp Word Ptr ds:[esi+8],02035h
                    jne @@ignore_object
                    ; object size
                    mov ecx,DWord Ptr ds:[esi+0]
                    ; object base addr
                    mov esi,DWord Ptr ds:[esi+4]
                    call Apply_Int10_Int13_MiniVDM_Patch_object
  @@ignore_object:
                  pop esi
                  pop ecx

                  ; try next object table entry
                  add esi,018h
                  loop @@all_objects_loop

                  mov ax,es
                  mov ds,ax


                  mov al,true
                  cmp [patch10_success],1+2+4
                  je @@complete_success_10

                  mov si,Offset message_Patch_minivdm10
                  mov ah,[patch10_success]
                  or  ah,'0'
                  mov [si+49],ah
                  call Display_Message
                  mov al,false
  @@complete_success_10:
                  cmp [patch13_success],1+2+4
                  je @@complete_success_13

                  mov si,Offset message_Patch_minivdm13
                  mov ah,[patch13_success]
                  or  ah,'0'
                  mov [si+49],ah
                  call Display_Message
                  mov al,false
  @@complete_success_13:
                  mov si,Offset message_Patch_minivdm1013_success
                  cmp al,true
                  if_e <call Display_Message_verbose>

                popad
                pop es
                pop ds
                ret
a_endp          Apply_Int10_Int13_MiniVDM_Patch

;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様

; patch code in one object
; esi=addr
; ecx=size

a_proc          Apply_Int10_Int13_MiniVDM_Patch_object
                sub ecx,10
                jc  @@exit

  @@loop:

                ;--- patches for _VDMINT10CreateMiniVDMSub ---

                ;  0 | 66 8B 51 02                       mov   dx, [ecx+2]
                ;  4 | 83 EC 04                          sub   esp, 4
                ;  7 | C7 05 ?? ?? ?? ?? 7F 02 00 00     mov   ds:_vdmid_RMSIZE, 639
                ; 17 | 66 89 15 ?? ?? ?? ??              mov   _INT10TCBNumber, dx

                cmp DWord Ptr [esi   ],002518b66h
                jne @@not_patch10_1
                cmp DWord Ptr [esi+ 4],0c704ec83h
                jne @@not_patch10_1
                cmp Byte  Ptr [esi+ 8],      005h
                jne @@not_patch10_1
                cmp DWord Ptr [esi+13],      639
                jne @@not_patch10_1

                mov eax,es:top_free_DOS_memory_address
                shr eax,10                              ; /1024
                mov DWord Ptr [esi+13],      eax        ; replace 639
                or es:[patch10_success],1
  @@not_patch10_1:

                ; same for 104a SMP (at 0011381A)
                ;  0 | 66 8b 4b 02                       mov   cx, [ebx+2]
                ;  4 | c7 05 ?? ?? ?? ?? 7f 02 00 00     mov   ds:_vdmid_RMSIZE, 639
                ; 14 | 66 89 0d ?? ?? ?? ??              mov   _INT10TCBNumber, cx
                ; 21 | 89 1d ?? ?? ?? ??                 mov   ds:_vdmid_mphvdmptcb, ebx

                cmp DWord Ptr [esi   ],0024b8b66h
                jne @@not_patch10_1_smp
                cmp Word  Ptr [esi+ 4],    005c7h
                jne @@not_patch10_1_smp
                cmp DWord Ptr [esi+10],      639
                jne @@not_patch10_1_smp
                cmp Word  Ptr [esi+14],    08966h
                jne @@not_patch10_1_smp
                cmp Byte  Ptr [esi+16],      00dh
                jne @@not_patch10_1_smp
                cmp Word  Ptr [esi+21],    01d89h
                jne @@not_patch10_1_smp

                mov eax,es:top_free_DOS_memory_address
                shr eax,10                              ; /1024
                mov DWord Ptr [esi+10],      eax        ; replace 639
                or es:[patch10_success],1
  @@not_patch10_1_smp:



                ;  0 | 33 C9                 xor   ecx, ecx
                ;  2 | 66 8B 0D 0E 04 00 00  mov   cx, large ds:40Eh       ; ebda
                ;  9 | C1 E1 04              shl   ecx, 4
                ; 12 | 89 0D ?? ?? ?? ??     mov   ebda_offset_linear, ecx

                cmp DWord Ptr [esi   ],08b66c933h
                jne @@not_patch10_2
                cmp DWord Ptr [esi+ 4],000040e0dh
                jne @@not_patch10_2
                cmp DWord Ptr [esi+ 8],004e1c100h
                jne @@not_patch10_2

                mov Word  Ptr [esi+ 5],    00413h ; use memory size instead of EBDA
                mov Byte  Ptr [esi+11],       10  ; in KiB instead of paragraphs
                or es:[patch10_success],2
  @@not_patch10_2:

                ; same for 104a SMP (at 001139C2)
                ;  0 | 33 DB                 xor   ebx, ebx
                ;  2 | 66 8B 1D 0E 04 00 00  mov   bx, large ds:40Eh       ; ebda
                ;  9 | C1 E3 04              shl   ebx, 4
                ; 12 | 8B CB                 mov   ecx, ebx
                ; 14 | 89 1D 4E A2 0A 00     mov   ebda_offset_linear, ebx

                cmp DWord Ptr [esi   ],08b66db33h
                jne @@not_patch10_2_smp
                cmp DWord Ptr [esi+ 4],000040e1dh
                jne @@not_patch10_2_smp
                cmp DWord Ptr [esi+ 8],004e3c100h
                jne @@not_patch10_2_smp

                mov Word  Ptr [esi+ 5],    00413h ; use memory size instead of EBDA
                mov Byte  Ptr [esi+11],       10  ; in KiB instead of paragraphs
                or es:[patch10_success],2
  @@not_patch10_2_smp:


                ;  0 | 8B 0D ?? ?? ?? ??   mov   ecx, ebda_offset_linear
                ;  6 | 6A 04               push  4
                ;  8 | 53                  push  ebx
                ;  9 | 8B 55 F4            mov   edx, [ebp+var_C]
                ; 12 | 0F B6 09            movzx ecx, byte ptr [ecx] ; size EBDA in KiB
                ; 15 | C1 E1 0A            shl   ecx, 10
                ; 18 | 52                  push  edx
                ; 19 | 89 0D ?? ?? ?? ??   mov   ebda_size_in_bytes, ecx

                cmp  Word Ptr [esi   ],    00d8bh
                jne @@not_patch10_3
                cmp DWord Ptr [esi+ 6],08b53046ah
                jne @@not_patch10_3
                cmp DWord Ptr [esi+12],0c109b60fh
                jne @@not_patch10_3
                cmp DWord Ptr [esi+16],089520ae1h
                jne @@not_patch10_3

                cmp es:top_free_DOS_memory_size,0       ; allow EBDA somwehere else
                je @@dummy_patch10_3

                mov Byte  Ptr [esi+12],      0b9h       ; mov ecx,$xxxxxxxx
                mov eax,es:top_free_DOS_memory_size
                mov DWord Ptr [esi+13],      eax
                mov Byte  Ptr [esi+17],      090h       ; nop
  @@dummy_patch10_3:
                or es:[patch10_success],4
  @@not_patch10_3:


                ; same for 104a SMP (at 00113A6E)
                ;  0 | 8B 1D ?? ?? ?? ??   mov   ebx, ebda_offset_linear
                ;  6 | 6A 04               push  4
                ;  8 | 50                  push  eax
                ;  9 | 8B 4D F4            mov   ecx, [ebp+var_C]
                ; 12 | 0F B6 1B            movzx ebx, byte ptr [ebx]
                ; 15 | C1 E3 0A            shl   ebx, 10
                ; 18 | 51                  push  ecx
                ; 19 | 89 1D 52 A2 0A 00   mov   ebda_size_in_bytes, ebx

                cmp  Word Ptr [esi   ],    01d8bh
                jne @@not_patch10_3_smp
                cmp DWord Ptr [esi+ 6],08b50046ah
                jne @@not_patch10_3_smp
                cmp DWord Ptr [esi+12],0c11bb60fh
                jne @@not_patch10_3_smp
                cmp DWord Ptr [esi+16],089510ae3h
                jne @@not_patch10_3_smp

                cmp es:top_free_DOS_memory_size,0       ; allow EBDA somwehere else
                je @@dummy_patch10_3_smp

                mov Byte  Ptr [esi+12],      0bbh       ; mov ebx,$xxxxxxxx
                mov eax,es:top_free_DOS_memory_size
                mov DWord Ptr [esi+13],      eax
                mov Byte  Ptr [esi+17],      090h       ; nop
  @@dummy_patch10_3_smp:
                or es:[patch10_success],4
  @@not_patch10_3_smp:




                ;--- patches for _VDMInt13CreateMiniVDMSub ---

                ;  0 | E8 ?? ?? ?? ??                   call _TKUpdatePriority
                ;  5 | 8B 0D ?? ?? ?? ??                mov  ecx, _pVDMInt13
                ; 11 | 83 EC 04                         sub  esp, 4
                ; 14 | C7 05 ?? ?? ?? ?? 7F 02 00 00    mov  ds:_vdmid_RMSIZE, 639
                ; 24 | A1 ?? ?? ?? ??                   mov  eax, _pTCBCur
                cmp  Byte Ptr [esi   ],      0e8h
                jne @@not_patch13_1
                cmp  Word Ptr [esi+ 5],    00d8bh
                jne @@not_patch13_1
                cmp DWord Ptr [esi+11],0c704ec83h
                jne @@not_patch13_1
                cmp  Byte Ptr [esi+15],      005h
                jne @@not_patch13_1
                cmp DWord Ptr [esi+20],      639
                jne @@not_patch13_1
                cmp  byte Ptr [esi+24],      0a1h
                jne @@not_patch13_1

                ; replace 639 with real value
                mov eax,es:top_free_DOS_memory_address
                shr eax,10                      ; /1024
                mov DWord Ptr [esi+20],eax
                or es:[patch13_success],1
  @@not_patch13_1:
                ; (same for SMP at 001a5f21)



                ; there is an range check for ABIOS areas beeing < 9E00:x..
                ; but this is not interesting

                ; following code maps 2*4 KiB at 9E00:0m regardless how large the EBDA
                ; or other code is really.
                ;  0 | C7 45 ?? 00 E0 09 00             mov  [ebp+map_linear.address], 9E000h
                ;  7 | 6A 03                            push 3
                ;  9 | 66 89 5D ??                      mov  [ebp+map_phys.?], bx
                ; 13 | C7 45 ?? 02 00 00 00             mov  [ebp+map_linear.pages], 2
                ; 20 | C7 45 ?? 00 E0 09 00             mov  [ebp+map_phys.address], 9E000h
                ; 27 | E8 ?? ?? ?? ??                   call _VMMapVDM
                ; 32 | 33 C9                            xor  ecx, ecx
                cmp  Word Ptr [esi   ],    045c7h
                jne @@not_patch13_2
                cmp DWord Ptr [esi+ 3],00009e000h
                jne @@not_patch13_2
                cmp DWord Ptr [esi+ 7],08966036ah
                jne @@not_patch13_2
                cmp  Byte Ptr [esi+11],      05dh
                jne @@not_patch13_2
                cmp  Word Ptr [esi+13],    045c7h
                jne @@not_patch13_2
                cmp DWord Ptr [esi+16],        2
                jne @@not_patch13_2
                cmp  Word Ptr [esi+20],    045c7h
                jne @@not_patch13_2
                cmp DWord Ptr [esi+23],00009e000h
                jne @@not_patch13_2
                cmp  Byte Ptr [esi+27],      0e8h
                jne @@not_patch13_2
                cmp  Word Ptr [esi+32],    0c933h
                jne @@not_patch13_2

                mov eax,es:top_free_DOS_memory_address
                and eax,0fffff000h
                cmp eax,09e000h                 ; do not map less than original OS2KRNL would do
                ja @@dummy_patch13_2
                mov DWord Ptr [esi+ 3],eax      ; replace 9e00:0
                mov DWord Ptr [esi+23],eax      ; replace 9e00:0
                neg eax
                add eax,640*1024
                shr eax,12                      ; /4 KiB
                mov DWord Ptr [esi+16],eax      ; replace 2*4 KiB
  @@dummy_patch13_2:
                or es:[patch13_success],2
  @@not_patch13_2:

                ; code for SMP looks a bit different, at 001A6156
                ;  0 | 33 DB                            xor  ebx, ebx
                ;  2 | 38 1D ?? ?? ?? ??                cmp  ds:_PGEnabled, bl
                ;  8 | 66 89 5D FC                      mov  [ebp+var_4], bx
                ; 12 | C7 45 F4 00 E0 09 00             mov  [ebp+var_C], 9E000h
                ; 19 | C7 45 F8 02 00 00 00             mov  [ebp+var_8], 2
                ; 26 | 66 89 5D FE                      mov  [ebp+var_2], bx
                ; 30 | 66 89 5D F0                      mov  [ebp+var_10], bx
                ; 34 | C7 45 EC 00 E0 09 00             mov  [ebp+var_14], 9E000h
                cmp DWord Ptr [esi   ],01d38db33h
                jne @@not_patch13_2_smp
                cmp DWord Ptr [esi+ 8],0fc5d8966h
                jne @@not_patch13_2_smp
                cmp DWord Ptr [esi+12],000f445c7h
                jne @@not_patch13_2_smp
                cmp DWord Ptr [esi+16],0c70009e0h
                jne @@not_patch13_2_smp
                cmp DWord Ptr [esi+20],00002f845h
                jne @@not_patch13_2_smp
                cmp DWord Ptr [esi+24],089660000h
                jne @@not_patch13_2_smp
                cmp DWord Ptr [esi+28],08966fe5dh
                jne @@not_patch13_2_smp
                cmp DWord Ptr [esi+32],045c7f05dh
                jne @@not_patch13_2_smp
                cmp DWord Ptr [esi+36],009e000ech
                jne @@not_patch13_2_smp

                mov eax,es:top_free_DOS_memory_address
                and eax,0fffff000h
                cmp eax,09e000h                 ; do not map less than original OS2KRNL would do
                ja @@dummy_patch13_2_smp
                mov DWord Ptr [esi+15],eax      ; replace 9e00:0
                mov DWord Ptr [esi+37],eax      ; replace 9e00:0
                neg eax
                add eax,640*1024
                shr eax,12                      ; /4 KiB
                mov DWord Ptr [esi+22],eax      ; replace 2*4 KiB
  @@dummy_patch13_2_smp:
                or es:[patch13_success],2
  @@not_patch13_2_smp:


                ; patch code that undoes what the original code for patch13_2 does..
                ; this is in an _VDMInt13DestroyMiniVDM subprocedure
                ;  0 | F6 45 08 20                                 test [ebp+arg_0], 20h
                ;  4 | 74 0E                                       jz   @l20
                ;  6 | 6A 04                                       push 4
                ;  8 | 6A 00                                       push 0
                ; 10 | 68 00 E0 09 00                              push 9E000h
                ; 15 | E8 ?? ?? ?? ??                              call _VMFreeMem

                cmp DWord Ptr [esi   ],0200845f6h
                jne @@not_patch13_3
                cmp DWord Ptr [esi+ 4],0046a0e74h
                jne @@not_patch13_3
                cmp  Word Ptr [esi+ 8],    0006ah
                jne @@not_patch13_3
                cmp  Byte Ptr [esi+10],      068h
                jne @@not_patch13_3
                cmp DWord Ptr [esi+11],00009e000h
                jne @@not_patch13_3
                cmp  Byte Ptr [esi+15],      0e8h
                jne @@not_patch13_3

                mov eax,es:top_free_DOS_memory_address
                and eax,0fffff000h
                cmp eax,09e000h                 ; do not unmap less than original OS2KRNL would do
                ja @@dummy_patch13_3
                mov DWord Ptr [esi+11],eax      ; replace 9e00:0
  @@dummy_patch13_3:
                or es:[patch13_success],4
  @@not_patch13_3:
                ; (also for SMP at 001a5c56)
                ;---------------------------------------------

                inc esi
                dec ecx
                jnz @@loop

  @@exit:
                ret
a_endp          Apply_Int10_Int13_MiniVDM_Patch_object

;様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様
