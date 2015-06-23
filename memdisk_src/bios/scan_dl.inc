Title   scan harddisk for LVM drive letter assignments

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

driveletter_used        dd 0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                  avoid_drive_letter_conflicts
                        pushad

                          ; do nothing when trying to get letter A:(or B:)
                          ; this is safe and can not be done via LVM
                          cmp MemDiskBIOS_Info._lvm_letter,'C'
                          jb @@exit

                          ; do nothing when used on an 'DEMO CD' where no non-removeable
                          ; media should be accessible
                          cmp cfg_record.cfg_scan_lvm_letter_hd,true
                          jne @@exit

                          call collect_driveletters_all_drives

                          mov eax,1
                          mov cl,MemDiskBIOS_Info._lvm_letter
                          sub cl,'A'
                          rol eax,cl
                          test driveletter_used,eax
                          jz @@exit             ; is free.

                          mov cl,'Z'+1
                          mov eax,(1 shl ('Z'+1-'C'))
  @@search:
                          dec cl
                          cmp cl,'C'
                          jb @@exit             ; have no solution - the user has to modify config.sys driver load sequence..
                          rol eax,1
                          test driveletter_used,eax
                          jnz @@search

                          ; have found free letter
                          mov MemDiskBIOS_Info._lvm_letter,cl
  @@exit:
                        popad
                        ret
a_endp                  avoid_drive_letter_conflicts

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                  collect_driveletters_all_drives
                        pushad

                          mov eax,Size disk_info
                          mov si,Offset disk_hd
                          call getmem

                          call init_crc32

                          call bestimme_anzahl_festplatten_dl
                          movzx cx,dl
                          mov dl,080h
                          test cx,cx
                          jz @@no_harddisk
  @@loop:
                          call collect_driveletters_partition_table
                          inc dl
                          loop @@loop
  @@no_harddisk:

                          call free_crc32

                          mov si,Offset disk_hd
                          call freemem


                        popad
                        ret
a_endp                  collect_driveletters_all_drives

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; dl=drive
a_proc                  collect_driveletters_partition_table
                        push es
                        push fs
                        pushad

                          lfs si,disk_hd

                         ;mov dl,dl             ; drive number
                          mov dh,sourcetype_harddisk_MBR
                          push ds
                          pop es
                          sub eax,eax           ; first sector

                          call load_disk_info
                          jc @@exit

                          ; we expect and handle sector read errors
                          mov fs:[si].read_may_fail,true

                          sub ebp,ebp           ; not inside an extended partition
                          call collect_driveletters_partition_table_recursive
  @@exit:
                        popad
                        pop fs
                        pop es
                        ret
a_endp                  collect_driveletters_partition_table

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; eax=sector number
; ebp=start of extended partition
; dl=drive
a_proc                  collect_driveletters_partition_table_recursive
                        pushad

                          test ebp,ebp
                          if_z <mov ebp,eax>

                          call collect_driveletters_partition_table_lvm

                          mov bx,Offset temp_sector
                          call read_1_sector_eax
                          jc @@exit

                          mov edi,eax           ; current position

                          ; scan partition table for next extended partition table sector numbers..

                          ; read out values.. (should only give one result)

                          mov bx,Offset temp_sector.partition1
  @@next_block:
                          sub eax,eax           ; next extended partition (invalid)
                          mov cl,[bx].system_indicator
                          cmp cl,005h
                          je @@extended_partition
                          cmp cl,00fh
                          je @@extended_partition
                          cmp cl,015h
                          je @@extended_partition
                          cmp cl,085h
                          jne @@not_extended_partition
  @@extended_partition:
                          mov eax,[bx].sectors_preceding
                          add eax,ebp
  @@not_extended_partition:
                          push eax
                          add bx,Size partition_entry
                          cmp bx,Offset temp_sector.partition1+4*(Size partition_entry)
                          jne @@next_block

                          ; look at the results..
                          mov cx,4
  @@look_at_extended_partitions:
                          pop eax               ; next position
                          cmp eax,edi           ; ignore obvious errors and empty entries
                          if_a <call collect_driveletters_partition_table_recursive>
                          loop @@look_at_extended_partitions
  @@exit:
                        popad
                        ret
a_endp                  collect_driveletters_partition_table_recursive

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; eax=(extended) partition table sector
; dl=drive
; fs:si=@disk_info
a_proc                  collect_driveletters_partition_table_lvm
                        pushad

                          ; LVM info sector is last sector of track
                          movzx ecx,fs:[si].sectors_track
                          lea eax,[eax+ecx-1]
                          mov bx,Offset temp_sector
                          call read_1_sector_eax
                          jc @@exit

                          cmp DWord Ptr [bx+0].DLA_Signature,DLA_Signature_lo
                          jne @@exit
                          cmp DWord Ptr [bx+4].DLA_Signature,DLA_Signature_hi
                          jne @@exit

                          sub edi,edi
                          xchg edi,[bx].lvm_beschreibungstabelle_typ.DLA_CRC

                          ; es:si,cx
                          mov cx,512
                          mov si,bx
                          call calculate_crc32
                          not eax
                          cmp eax,edi
                          jne @@exit

                          ; scan all 4 blocks for drive letters...
                          mov bx,Offset temp_sector.tabelle
  @@next_block:
                          mov cl,[bx].Drive_Letter
                          and cl,(not 020h)
                          cmp cl,'C'
                          jb @@letter_invalid
                          cmp cl,'Z'
                          ja @@letter_invalid

                          sub cl,'A'
                          mov eax,1
                          rol eax,cl
                          or driveletter_used,eax
  @@letter_invalid:
                          add bx,Size lvm_partitionsbeschreibung_typ
                          cmp bx,Offset temp_sector.tabelle+4*(Size lvm_partitionsbeschreibung_typ)
                          jne @@next_block
  @@exit:
                        popad
                        ret
a_endp                  collect_driveletters_partition_table_lvm

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

