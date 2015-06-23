title   'detect' MemDisk or OS2LDR variant of OS2CSM, memdisk disksize

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

p8str name_os2csm_memdisk 'OS2CSM_MEMDISK'

IFDEF memdisk
val_name_os2csm_memdisk equ 1
ELSE
val_name_os2csm_memdisk equ 0
ENDIF

p8str name_os2csm_memdisk_disksize 'OS2CSM_MEMDISK_DISKSIZE'
p8str name_os2csm_memdisk_diskfree 'OS2CSM_MEMDISK_DISKFREE'


a_proc          detect_memdisk_or_os2ldr_variant
                pusha

                  mov si,Offset name_os2csm_memdisk
                  call suche_variable_p8
                  test di,di
                  if_nz <mov [di].aktuelle_einstellung,val_name_os2csm_memdisk>

                popa
                ret
a_endp          detect_memdisk_or_os2ldr_variant

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          detect_memdisk_disk_size
                pusha

                  ; MemDisk disksize in MiB
IFDEF memdisk
                  mov ax,icmd.memdisk_disksize
ELSE
                  sub ax,ax ; no disk or no idea -> report disksize 0
ENDIF
                  mov si,Offset zeichenketten_zwischenspeicher
                  call Int2Str

                  ; si=string
                  ; bx=variable name
                  mov bx,Offset name_os2csm_memdisk_disksize
                  call store_string_to_anything_varname


                  ; MemDisk diskfree in MiB
IFDEF memdisk
                  mov ax,icmd.memdisk_diskfree
ELSE
                  sub ax,ax ; no disk or no idea -> report diskfree 0
ENDIF
                  mov si,Offset zeichenketten_zwischenspeicher
                  call Int2Str

                  ; si=string
                  ; bx=variable name
                  mov bx,Offset name_os2csm_memdisk_diskfree
                  call store_string_to_anything_varname

                popa
                ret
a_endp          detect_memdisk_disk_size

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
