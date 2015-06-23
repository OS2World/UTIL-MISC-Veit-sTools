Title           used by REXX_VIO/REXX_PM

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                .386
                .model flat

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

RexxResourceType = 'R'+'E' shl 8 ; 17746
RexxResourceName = 1
ModuleHandle    = 0

exit_Thread     = 0
exit_Process    = 1

rxCommand       = 0 ; Program called as Command
rxSubroutine    = 1 ; Program called as Subroutine
rxFunction      = 2 ; Program called as Function


StdErr          = 2

RxString        Struc
  strlength     dd ?
  strptr        dd ?
RxString        EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

data32          Segment 'DATA' Use32

RexxSource:     RxString <0,0>
  RexxSource1   RxString <0,0>

Arguments:      RxString <0,0>
RexxRetVal:     RxString <0,0>
RexxRC          dw 0

ActualWritten   dd 0

data32          EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

code32          Segment 'CODE' Use32

Extrn Dos32QueryResourceSize: Near
Extrn Dos32GetResource: Near
Extrn Dos32FreeResource: Near
Extrn Dos32FreeMem: Near
Extrn RexxStart: Near
Extrn Dos32Write: Near

;InitialEnvironmentName db 'REXX_PM',0
InitialEnvironmentName db 'CMD',0
ErrorMessage_Dos32QueryResource db 'Failed to get Resource!'
ErrorMessage_Dos32QueryResourceLen = $-ErrorMessage_Dos32QueryResource

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

rexx_vio_main   Proc C Near
                Arg @@ModuleHandle:DWord, @@Reserved:DWord, @@Environment:DWord, @@CmdLine:DWord

                push Offset RexxSource.strlength
                push RexxResourceName
                push RexxResourceType
                push @@ModuleHandle
                call Dos32QueryResourceSize
                add esp,4*4
                test eax,eax
                jz @@ResourceAvailable

  @@ResourceProblem:
                push eax
                  push Offset ActualWritten
                  push ErrorMessage_Dos32QueryResourceLen
                  push Offset ErrorMessage_Dos32QueryResource
                  push StdErr
                  call Dos32Write
                  add esp,4*4
                pop eax
                jmp @@Halt

  @@ResourceAvailable:
                push Offset RexxSource.strptr
                push RexxResourceName
                push RexxResourceType
                push @@ModuleHandle
                call Dos32GetResource
                add esp,4*4
                test eax,eax
                jnz @@ResourceProblem

                mov esi,@@CmdLine
                cld
  @@search_Arg:
                lodsb
                cmp al,0
                jne @@search_Arg

                mov Arguments.strptr,esi

  @@search_ArgEnd:
                lodsb
                cmp al,0
                jne @@search_ArgEnd

                sub esi,Arguments.strptr
                dec esi
                mov Arguments.strlength,esi


                push Offset RexxRetVal  ; Rexx program output
                push Offset RexxRC      ; Rexx program output
                push 0                  ; No EXITs on this call
                push rxCommand          ; Code for how invoked
                push Offset InitialEnvironmentName ; Initial environment name
                push Offset RexxSource  ; Location of the procedure
                push @@CmdLine          ; Name of the REXX procedure (?)
                push Offset Arguments   ; Argument array
                push 1                  ; Number of arguments
                call RexxStart
                add esp,9*4

                test eax,eax
                jnz @@NotUseRexxRC
                movzx eax,RexxRC
  @@NotUseRexxRC:

                push eax

                  mov eax,RexxRetVal.strptr
                  test eax,eax
                  jz @@NoRexxRetVal

                  push eax
                  call Dos32FreeMem
                  pop eax ; add esp,1*4
  @@NoRexxRetVal:

                  mov eax,RexxSource1.strptr
                  test eax,eax
                  jz @@NoTokenizedSource

                  push eax
                  call Dos32FreeMem
                  pop eax ; add esp,1*4
  @@NoTokenizedSource:

                  push RexxSource.strptr
                  call Dos32FreeResource
                  pop eax ; add esp,1*4

                pop eax
                jmp @@Halt

                ; eax=error code
  @@Halt:
                ret
rexx_vio_main   EndP

code32          EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

.stack 32*1024

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                End rexx_vio_main

