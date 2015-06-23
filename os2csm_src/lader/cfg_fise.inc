Title   copy memdisk file set rename setting<->'MEMDISK_RENAME_FILESET*' variables

;***************************************************************************

p8str   name_MEMDISK_RENAME_FILESETx 'MEMDISK_RENAME_FILESET*'
name_MEMDISK_RENAME_FILESETx_edit equ Byte Ptr $-1

p8str   value_MEMDISK_RENAME_FILESETx '0'

;***************************************************************************

a_proc  set_MEMDISK_RENAME_FILESET
        pusha

          ; 'A'..'D'
          mov di,Offset rename_fileset_a
          mov name_MEMDISK_RENAME_FILESETx_edit,'A'

  @@loop:
          mov ah,0
          mov al,Byte Ptr [icmd+di]
          or  al,'0'
          cmp al,'9'
          if_a <mov al,'0'>

          ; length
          mov Byte Ptr [value_MEMDISK_RENAME_FILESETx+0],1
          ; char
          mov Byte Ptr [value_MEMDISK_RENAME_FILESETx+1],al

          mov si,Offset value_MEMDISK_RENAME_FILESETx
          mov bx,Offset name_MEMDISK_RENAME_FILESETx
          call store_string_to_anything_varname

          inc name_MEMDISK_RENAME_FILESETx_edit
          inc di
          cmp di,rename_fileset_d
          jbe @@loop

        popa
        ret
a_endp  set_MEMDISK_RENAME_FILESET

;***************************************************************************

a_proc  copy_MEMDISK_RENAME_FILESET
        pusha

          ; 'A'..'D'
          mov si,Offset rename_fileset_a
          mov name_MEMDISK_RENAME_FILESETx_edit,'A'

  @@loop:
          push si
            mov si,Offset name_MEMDISK_RENAME_FILESETx
            call suche_variable_p8
          pop si

          test di,di
          jz @@not_defined

          push si
            call liefere_aktuellezeichenkette_der_variable
            mov al,ds:[si+1] ; first char
          pop si
          mov Byte Ptr [icmd+si],al

  @@not_defined:

          inc name_MEMDISK_RENAME_FILESETx_edit
          inc si
          cmp si,rename_fileset_d
          jbe @@loop

        popa
        ret
a_endp  copy_MEMDISK_RENAME_FILESET

;***************************************************************************
