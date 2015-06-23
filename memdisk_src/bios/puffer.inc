Title           not initialized buffer areas

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

initialized_data_end:
                        ; Align 4
                        db (16-(($-anfang_org) and 0000fh)) dup (?)

                        ; ausschrift.inc
str_puffer:             db 16 dup (?)


                        ; cdread.inc
read_sector_packet      disk_address_packet <>


                        ; cdemter,inc
specification_packet:   cdrom_specification_packet <>

IFNDEF cdloader

temp_sector             Bootsector <>
                        db (2048-Size Bootsector) dup (?)

filename83_tmp          file83 <?,?>

IFNDEF os2boot_ac_code
key_box_message_x       db ? ; 0..keybox_hardwrap
key_box_message_xmax    db ? ; 0..keybox_hardwrap
key_box_message_y       db ?
key_box_messagebuffer   db keybox_linesmax*keybox_hardwrap dup (?)
ENDIF ; -os2boot_ac_code

ENDIF ; -cdloader

linebuffer_UC           db 256 dup (?)

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF memdisk
stack                   db 8*1024 dup (?)
ENDIF ; memdisk

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
