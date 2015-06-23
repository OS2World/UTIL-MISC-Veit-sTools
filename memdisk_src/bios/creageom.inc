Title   Create new geometry for memory disk

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; eax=number of bytes memory free
                ; -> data structures updated
a_proc          create_memdisk_geometry
                pushad

                  ; take away minimum OS size
                  sub eax,cfg_record.cfg_os2_min_memory
                  jnc create_memdisk_geometry_reserved_OS

  create_memdisk_geometry_not_enough_memory:
                  fehler_halt msg_Not_enough_memory

  create_memdisk_geometry_reserved_OS:
                  ; take away minimum disk size
                  mov edx,cfg_record.cfg_disksize_min
                  sub eax,edx
                  jc create_memdisk_geometry_not_enough_memory

                  mov ecx,edx

                  ; if size extension is available, take it.
                  mov edx,cfg_record.cfg_disk_additional_const
                  cmp eax,edx
                  jb not_cfg_disk_additional_const

                  sub eax,edx
                  add ecx,edx

  not_cfg_disk_additional_const:

                  ; subtract percentage of remaining memory
                  movzx ebx,cfg_record.cfg_disk_additional_percent
                  mul ebx
                  mov ebx,100
                  div ebx
                  add eax,ecx

                  ; because of INT 15/E801 interface counts >16MiB memory
                  ; in 64KiB blocks, size must be multiple of 64KiB

                  and eax,0ffff0000h

                  ; eax=disk size

                  shr eax,9

                  ; eax=disk size in sectors, now find a geometry for it..

                  ; disk size <= 4096-16 MiB = 4080 MiB
                  mov ecx,1024*255*32 ; 4080 MiB
                  cmp eax,ecx
                  if_a <mov eax,ecx>

                  mov ecx,512 ; 256KiB minimum size
                  cmp eax,ecx
                  if_b <mov eax,ecx>

                  mov MemDiskBIOS_Info._anzahl_sektoren_je_spur,32

                  ; 32=1 shl 5
                  shr eax,5

                  ; eax=cylinders*heads

                  ; 64 KiB/(512 Byte/sector)/(32 sectors/track)=4

                  mov ecx,4 ; 4 heads
                  mov ebx,eax
  search_geometry:
                  mov eax,ebx
                  cdq
                  div ecx
                  test edx,edx
                  if_nz <inc eax>
                  cmp eax,1024                  ; <=1024.0?
                  jbe have_geometry

                  add ecx,4
                  cmp ecx,255
                  if_a <mov ecx,255>
                  jmp search_geometry
  have_geometry:
                  mov MemDiskBIOS_Info._anzahl_zylinder,eax
                  mov MemDiskBIOS_Info._anzahl_koepfe,ecx

                  ; cylinders*heads*sekctors per track
                  mul ecx
                  mul MemDiskBIOS_Info._anzahl_sektoren_je_spur
                  mov MemDiskBIOS_Info._anzahl_sektoren,eax

                popad
                ret
a_endp          create_memdisk_geometry

