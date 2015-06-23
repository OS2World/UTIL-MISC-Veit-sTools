Title   copy memdisk OS2LOGO delete setting<->'MEMDISK_OS2LOGO_DELETE' variables

;***************************************************************************

p8str   name_MEMDISK_OS2LOGO_DELETE 'MEMDISK_OS2LOGO_DELETE'

p8str   value_MEMDISK_OS2LOGO_DELETE '0'

;***************************************************************************

a_proc  set_MEMDISK_OS2LOGO_DELETE
        pusha

          mov al,[icmd].delete_os2logo_s3

          or  al,'0'
          cmp al,'9'
          if_a <mov al,'0'>

          ; length
          mov Byte Ptr [value_MEMDISK_OS2LOGO_DELETE+0],1
          ; char
          mov Byte Ptr [value_MEMDISK_OS2LOGO_DELETE+1],al

          mov si,Offset value_MEMDISK_OS2LOGO_DELETE
          mov bx,Offset name_MEMDISK_OS2LOGO_DELETE
          call store_string_to_anything_varname

        popa
        ret
a_endp  set_MEMDISK_OS2LOGO_DELETE

;***************************************************************************

a_proc  copy_MEMDISK_OS2LOGO_DELETE
        pusha

          mov si,Offset name_MEMDISK_OS2LOGO_DELETE
          call suche_variable_p8

          test di,di
          jz @@not_defined

          call liefere_aktuellezeichenkette_der_variable

          mov al,ds:[si+1] ; first char

          and al,(not '0') ; convert '1' to 1=true

          mov Byte Ptr [icmd].delete_os2logo_s3,al

  @@not_defined:

        popa
        ret
a_endp  copy_MEMDISK_OS2LOGO_DELETE

;***************************************************************************
