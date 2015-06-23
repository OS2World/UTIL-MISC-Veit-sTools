title   message string definition and DevHlp_Save_Message record

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IFDEF OS2

Message_table           dw 1178 ; "%1"  ; message number
                        dw 1            ; one paramter
  fillin_string_ptr     dd ?            ; first fill in item
                        Public Message_table
                        Public fillin_string_ptr
ENDIF

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

messagestring_nologo    Macro ID,ZK

IFDEF HAVE_MSG16_SEGMENT

IFDEF OS2
                        data16 EndS
ELSE ; DOS
                        code16 EndS
ENDIF
                        msg16 Segment
ENDIF ; HAVE_MSG16_SEGMENT

                        &ID db &ZK,0
                        Public &ID

IFDEF HAVE_MSG16_SEGMENT
                        msg16 EndS
IFDEF OS2
                        data16 Segment
ELSE ; DOS
                        code16 Segment
ENDIF
ENDIF ; HAVE_MSG16_SEGMENT

                        EndM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IFDEF message_logo
messagestring           Macro ID,ZK
                        messagestring_nologo ID,<message_logo,&ZK>
                        EndM
ELSE
messagestring           Macro ID,ZK
                        messagestring_nologo ID,<             &ZK>
                        EndM
ENDIF

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

crlf                    equ <13,10>

messagestring_nologo msg_crlf crlf

IFDEF console_logo
messagestring_nologo messagestring_consoleprefix console_logo
ENDIF ; console_logo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
