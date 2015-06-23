Title   copy config.sys editor setting memdisk<->'MEMDISK_CONFIG_SYS_EDIT' variable

p8str   name_MEMDISK_CONFIG_SYS_EDIT 'MEMDISK_CONFIG_SYS_EDIT'

a_proc  set_MEMDISK_CONFIG_SYS_EDIT
        pusha

          ; disable editor if os2csm is invisible, else copy setting
          mov al,[icmd].os2csm_mode
          and [icmd].config_sys_edit,al
          movzx ax,[icmd].config_sys_edit

          mov si,Offset name_MEMDISK_CONFIG_SYS_EDIT
          call suche_variable_p8
          test di,di
          if_nz <mov [di].aktuelle_einstellung,ax>

        popa
        ret
a_endp  set_MEMDISK_CONFIG_SYS_EDIT

a_proc  copy_MEMDISK_CONFIG_SYS_EDIT
        pusha

          mov si,Offset name_MEMDISK_CONFIG_SYS_EDIT
          call suche_variable_p8
          test di,di
          jz @@exit

          mov ax,[di].aktuelle_einstellung
          mov [icmd].config_sys_edit,al

  @@exit:

        popa
        ret
a_endp  copy_MEMDISK_CONFIG_SYS_EDIT
