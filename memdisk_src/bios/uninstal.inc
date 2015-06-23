Title   Deactivate resident MemDisk

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          uninstall
                push es
                pushad

                  call remove_exception_handler

                  ; one disk less
                  push bios0040
                  pop es
                  mov al,ds:[my_harddisk_count_inc]
                  sub byte ptr es:[harddisk_count],al
                  cmp ds:[drive_number],0
                  if_e <call hide_our_floppy>

                  ; release memory
IFDEF fastboot_function
                  ; free additional 1KiB copy of interrupt table
                  add word ptr fs:[number_of_KB],num_kb+1
ELSE
                  add word ptr fs:[number_of_KB],num_kb
ENDIF
                  ; remove int 13 handler
                  mov si,Offset orgint13
                  call uninstall_int
  IFNDEF dos
                  ; remove int 15 handler
                  mov si,Offset orgint15
                  call uninstall_int

  ENDIF ; -dos
                  ; uninstall only once!
                  mov Byte Ptr cs:[uninstall],0c3h

                popad
                pop es
                ret
a_endp          uninstall

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
