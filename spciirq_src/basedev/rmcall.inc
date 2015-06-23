Title           Communication with Resource Manager - call code

;-----------------------------------------------
;               CALL RESMGR$ IDC
;-----------------------------------------------

a_proc          CallResourceManager
;               pop     bx                      ; bx:=function code
;               pop     ax                      ; caller ip

                pop     ax                      ; caller ip
                pop     bx                      ; bx:=function code

                push    cs                      ;        cs
                push    ax                      ;        ip

                push    bp
                mov     bp, sp
                                                ; [bp+ 0]=old bp
                                                ; [bp+ 2]=caller ip
                                                ; [bp+ 4]=       cs
                                                ; [bp+ 6]=parameters
                                                ; bx=function code

                cmp     [RM_Help0], 0
                mov     ax, -1                  ; fail with -1 if not available
                je      CallResourceManager_exit

                mov     ax, cs
                test    al, 3
                jz      CallResourceManager_R0

                push    ss                      ; \ Seg: of parameters
                lea     ax, [bp+ 6]             ; / :Ofs
                push    ax
                push    bx                      ; > function code
                call    [RM_Help3]
               ;add     sp, 3*2
                jmp     CallResourceManager_exit

  CallResourceManager_R0:
                ; parameters are taken from [bp+..]

                push    cs                      ; dummy far call ...
                push    Offset CallResourceManager_R0_continue

                push    bp
                mov     bp, sp

                push    bx                      ; > function code
                call    [RM_Help0]
                ; warning: resource manager does not return here...
                ; instead it does 2x leave and retf.. ~around parameters
                leave

                add     sp, 4                   ; "retf"
  CallResourceManager_R0_continue:

  CallResourceManager_exit:

                leave
                retf
a_endp          CallResourceManager


;===============================================

CallRM          Macro   FN
                push    &FN
                Call    CallResourceManager
                EndM

;===============================================

RMGetVersion                    equ     1
RMCreateDriver                  equ     2
RMDestroyDriver                 equ     3
RMCreateAdapter                 equ     4
RMDestroyAdapter                equ     5
RMCreateDevice                  equ     6
RMDestroyDevice                 equ     7
RMAllocResource                 equ     8
RMDeallocResource               equ     9
RMDeAllocResource               equ    RMDeallocResource
RMClaimResources                equ    10 ; dummy, returns ax=RMRC_SUCCESS
RMReleaseResources              equ    11 ; dummy, returns ax=RMRC_SUCCESS
RMCreateLDev                    equ    12
RMDestroyLDev                   equ    13
RMCreateSysName                 equ    14
RMDestroySysName                equ    15
RMADDToHDEVICE                  equ    16
RMKeyToHandleList               equ    17
RMHandleToType                  equ    18
RMHandleToParent                equ    19
RMUpdateAdjunct                 equ    20
RMAdjToHandleList               equ    21
RMHDevToHLDev                   equ    22
RMResToHandleList               equ    23
RMActivateAdapter               equ    24 ; dummy, returns ax=RMRC_SUCCESS
RMDeactivateAdapter             equ    25 ; dummy, returns ax=RMRC_SUCCESS
RMCreateLinkDevice              equ    26 ; dummy, returns ax=RMRC_SUCCESS
RMModifyResources               equ    27
RMGetNodeInfo                   equ    28
RMParseScsiInquiry              equ    29
RMCreateDetected                equ    30
RMDestroyDetected               equ    31
RMDevIDToHandleList             equ    32
RMHandleToResourceHandleList    equ    33
RMModifyNodeFlags               equ    34
RMConvertID                     equ    35
RMGetCommandLine                equ    36

;===============================================

