Title           Record+const definitions for Int $13, $15 functions

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; int 15/c7

ps2_memory_map  Struc                           ; Table 00526
                dw 028h ; length of table (excluding this word)
ps2_local_1M    dd ?    ; local memory between 1M and 16M, in 1K blocks
ps2_local_16M   dd ?    ; local memory between 16M and 4G, in 1K blocks
ps2_system_1M   dd ?    ; system memory between 1M and 16M, in 1K blocks
ps2_system_16M  dd ?    ; system memory between 16M and 4G, in 1K blocks - used by ms himem.sys 3.95
                dd ?    ; cacheable memory between 1M and 16M, in 1K blocks
                dd ?    ; cacheable memory between 16M and 4G, in 1K blocks
                dd ?    ; 1K blocks before start of non-system memory between 1M and 16M
                dd ?    ; 1K blocks before start of non-system memory between 16M and 4G
                dw ?    ; start segment of largest free block from C0000h-DFFFFh
                dw ?    ; size of largest free block
                dd ?    ; reserved
ps2_memory_map  EndS


; int 15/e820
smap            Struc
  base_lo       dd ?
  base_hi       dd ?
  length_lo     dd ?
  length_hi     dd ?
  memtype       dd ?
smap            EndS

smap_memtype_memory equ 1

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

mcb                     Struc
  mcb_kennung           db ? ; 'M' oder 'Z'
  mcb_eigentuemer_mcb   dw ?
  mcb_anzahl_para       dw ?
  mcb_reserviert_05     db ? ; OS2BOOT  ...
  mcb_reserviert_06     db ?
  mcb_reserviert_07     db ?
  mcb_name              db 8 dup (?)
mcb                     EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

MB1             = 1*1024*1024
MB16            = 16*1024*1024
MB16_in_KB      = 16*1024
MB15            = 15*1024*1024
MB15_in_KB      = 15*1024
MINUS_1MB       = (4*1024-1- 1)*1024*1024
MINUS_16MB      = (4*1024-1-16)*1024*1024
MINUS_16MB_in_KB = (4*1024-1-16)*1024

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

bios0040                equ 00040h
bios0040r0000           equ 000400h
biosb000                equ 0b000h
biosb800                equ 0b800h
Extended_BIOS_Data_Area equ 0000eh ; MemW[$40:$0e]
equipements_list_flag   equ 00010h ; MemW[$40:$10] Int $11 result
number_of_KB            equ 00013h ; MemW[$40:$13]
keyboard_flag_byte0     equ 00017h ; Mem [$40:$17]
keyboard_flag_byte1     equ 00018h ; Mem [$40:$18]
keyboardbuffer_head     equ 0001ah ; MemW[$40:$1a]
keyboardbuffer_tail     equ 0001ch ; MemW[$40:$1c]
current_video_mode      equ 00049h ; Mem [$40:$49]
number_of_columns       equ 0004ah ; MemW[$40:$4a]
current_cursor          equ 00050h ; MemW[$40:$50] first page, (0..n-1,0..n-1)
current_column          equ 00050h ; Mem [$40:$50] first page, (0..n-1)
current_row             equ 00051h ; Mem [$40:$51] first page, (0..n-1)
daily_timer_counter     equ 0006ch ; MemL[$40:$6c]
harddisk_count          equ 00075h ; Mem [$40:$75]
keyboardbuffer_start    equ 00080h ; MemW[$40:$80]
keyboardbuffer_end      equ 00082h ; MemW[$40:$82]
number_of_lines_less1   equ 00084h ; Mem [$40:$84]
char_matrix_height      equ 00085h ; MemW[$40:$85]
video_mode_options      equ 00087h ; Mem [$40:$87]
keyboard_flag_byte2     equ 00096h ; Mem [$40:$96] ; "Keyboard mode/type"
keyboard_flag_byte3     equ 00097h ; Mem [$40:$97] ; "Keyboard LED flags"

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

progress_indicator_none            equ 0
progress_indicator_block           equ 1
progress_indicator_display_files   equ 2

a20_access_BIOS                 equ 0
a20_access_private              equ 1
a20_access_auto                 equ 2

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

cdrom_specification_packet      Struc   ; #281
 cdrom_spec_pkt_size            db ?    ; Size of cdrom_specification_packet
 cdrom_boot_media_type          db ?
 cdrom_drive_number             db ?    ; 0=floppy, 80=hd 81=noboot/noemu
 cdrom_controller_number        db ?
 cdrom_lba_address_to_emulate   dd ?
                                dw ?    ; drive specification
 cdrom_buffer_segment           dw ?    ; 3 KB
 cdrom_load_segment             dw ?
 cdrom_load_numsectors          dw ?
 cdrom_i13f08_cx                dw ?
 cdrom_i13f08_dh                db ?
cdrom_specification_packet      EndS

cdrom_mediatype_no_emu          equ 0
cdrom_mediatype_12M             equ 1
cdrom_mediatype_14M             equ 2
cdrom_mediatype_28M             equ 3
cdrom_mediatype_HD              equ 4
cdrom_mediatype_atapi_driver    equ 040h
cdrom_mediatype_scsi_driver     equ 080h

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

ptr1616                         Struc
  _OFF                          dw ?
  _SEG                          dw ?
ptr1616                         EndS

disk_address_packet             Struc
  disk_address_packet_size      db ?
  reserved_0                    db ?            ; reserved
  number_of_blocks_to_transfer  dw ?
  transfer_buffer               dd ?
  starting_block_number         dq ?
disk_address_packet             EndS


drive_parameter_table_i13x      Struc           ; Table 00273
  i13x_buffer_size              dw ?
  i13x_informationflags         dw ?
  i13x_physical_cylinders       dd ?
  i13x_physical_heads           dd ?
  i13x_physical_sec_p_track     dd ?
  i13x_number_of_sectors        dq ?
  i13x_bytes_per_sector         dw ?            ; end 1.x

  EDD_configuration_parameters  dd ?            ; 2.0+

drive_parameter_table_i13x      EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

false                           equ 0
true                            equ 1

debugoption_STEP                equ 001h        ; 4 debug chars progress
debugoption_memtest             equ 002h        ; check memory conflict with video

keyboard_status0_right_shift    equ 001h
keyboard_status0_left_shift     equ 002h
keyboard_status0_ctrl           equ 004h
keyboard_status0_alt            equ 008h
keyboard_status0_scrollock      equ 010h
keyboard_status0_numlock        equ 020h
keyboard_status0_capslock       equ 040h
keyboard_status0_insert         equ 080h

keyboard_status1_left_ctrl      equ 001h
keyboard_status1_left_alt       equ 002h
keyboard_status1_system_key     equ 004h
keyboard_status1_suspend_key    equ 008h
keyboard_status1_scrollock_dp   equ 010h
keyboard_status1_numlock_dp     equ 020h
keyboard_status1_capslock_dp    equ 040h
keyboard_status1_insert_dp      equ 080h

keyboard_status2_lastcode_e1    equ 001h
keyboard_status2_lastcode_e0    equ 002h
keyboard_status2_right_ctrl     equ 004h
keyboard_status2_right_alt      equ 008h
keyboard_status2_101_102_kbd    equ 010h
keyboard_status2_force_num_lock_if_Rd_ID_KBX    equ 020h
keyboard_status2_lastchar_was_first_ID          equ 040h
keyboard_status2_read_ID_in_progress            equ 080h

keyboard_status3_scroll_lock_indicator          equ 001h
keyboard_status3_num_lock_indicator             equ 002h
keyboard_status3_caps_lock_indicator            equ 004h
keyboard_status3_cirrus_system_indicator        equ 008h
keyboard_status3_ack_received                   equ 010h
keyboard_status3_resebd_receive_flag            equ 020h
keyboard_status3_mode_indicator_update          equ 040h
keyboard_status3_keyboard_transmit_error_flag   equ 080h

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

GDTDesc                         Struc
  SegmentLimit                  dw ?
  BaseAddr1500                  dw ?
  BaseAddr2316                  db ?
  Access                        db ?
  Access386                     db ?
  BaseAddr3124                  db ?
GDTDesc                         EndS
; access bit 7          present
;            65         DPL
;            4          0=System 1=code/data
;            321        tss/gate/..
;            0          accessed
; 93=present+DPL(0)+code/data+load descriptor table+accessed
; 9b=present+DPL(0)+code/data+286/386 task gate    +accessed

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
