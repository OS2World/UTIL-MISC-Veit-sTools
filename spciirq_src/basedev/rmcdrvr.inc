Title           Communication with Resource Manager - attach and register

;-----------------------------------------------
;               GET RESMGR$ IDC
;-----------------------------------------------

a_proc          AttachResMgrDD
                pusha

                mov     bx, Offset NameResmgrDD
                mov     di, Offset IDC_ResmgrDD
                mov     dl, DevHlp_AttachDD
                call    [Device_Help]

                popa
                ret
a_endp          AttachResMgrDD

;===============================================


a_proc          RegisterResourceManager
                push es
                pushad
                enter 0,0

                les bx,es:[bx].RequestBlock.Pointer_2
                mov di,Offset DrvrFileName
  @@loop_copy_drivername:
                mov al,es:[bx]
                inc bx
                cmp al,' '
                jbe @@end_of_drivername

                ; copy driver filename
                mov ds:[di],al
                inc di
                jmp @@loop_copy_drivername

  @@end_of_drivername:


                ; connect to Resource Manager if installed
                call    AttachResMgrDD
                jc      @@no_ResourceManager

                mov     eax, DWord Ptr ResmgrIDC_CS_R0
                mov     RM_Help0, eax

                mov     ax, ResmgrIDC_CS_R3
                shl     eax, 16
                mov     RM_Help3, eax


                ; get handle
                push    ds
                push    Offset hDriver
                push    ds
                push    Offset DriverStructure
                CallRM  RMCreateDriver
                add     sp,4*2

  @@no_ResourceManager:

                leave
                popad
                pop es
                ret
a_endp          RegisterResourceManager

;===============================================

