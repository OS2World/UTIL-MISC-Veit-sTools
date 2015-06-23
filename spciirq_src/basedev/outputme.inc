title   message string output, +call log/serial
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                        ; msg16:ARG1=message string
p_proc                  outputmessage
                        ARG @@message_offset:Word

                        push es
                        push si

IFDEF HAVE_MSG16_SEGMENT
                          mov si,msg16
                          mov es,si
ELSE ; -HAVE_MSG16_SEGMENT
                          push ds
                          pop es
ENDIF ; -HAVE_MSG16_SEGMENT
                          mov si,@@message_offset
                          call outputmessage_es_si

                        pop si
                        pop es
                        ret
p_endp                  outputmessage

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


Buf512                  Struc
                        db 512 dup (?)
Buf512                  EndS


                        ; es:si=message

IFDEF console_logo
p_proc                  outputmessage_es_si

                        Local @@StringBuffer:Buf512
ELSE ; -console_logo

a_proc                  outputmessage_es_si
ENDIF ; -console_logo


                        pushf
                        pusha

IFDEF HAVE_MESSAGE_LOG
                          call log_message

                          push es
                          push si

                            push SEG msg_crlf
                            pop es
                            mov si,Offset msg_crlf

                            call log_message

                          pop si
                          pop es

ENDIF ; HAVE_MESSAGE_LOG


IFDEF DEBUG_COM2
                          push si

                            jmp @@while_output_com2
  @@loop_output_com2:
                            call output_com2
  @@while_output_com2:
                            mov al,es:[si]
                            inc si
                            cmp al,0
                            jne @@loop_output_com2

                            mov al,13
                            call output_com2

                            mov al,10
                            call output_com2

                          pop si
ENDIF ; DEBUG_COM2


IFDEF screen_output_disabled
                          cmp [screen_output_disabled],true
                          je @@exit
ENDIF ; screen_output_disabled




IFDEF console_logo
                          lea di,@@StringBuffer
                          mov cx,Size Buf512

                          ; special handling for pause message 'SYS '...
                          cmp DWord Ptr es:[si],' SYS'
                          je @@skip_consoleprefix

                          push si
                            mov si,Offset messagestring_consoleprefix
                            cld
  @@copy_consoleprefix:
                            mov al,es:[si]
                            inc si
                            mov ss:[di],al
                            inc di
                            dec cx
                            cmp al,0
                            jne @@copy_consoleprefix
                          pop si

                          ; restart at
                          dec di
                          inc cx

  @@append_to_prefix_loop:
                          mov al,es:[si]
                          inc si
                          mov ss:[di],al
                          inc di
                          dec cx
                          jz  @@append_to_prefix_break
                          cmp al,0
                          jne @@append_to_prefix_loop
  @@append_to_prefix_break:

                          ; insure terminating #0
                          mov Byte Ptr ss:[di-1],0

                          ; continue using the combined string
                          push ss
                          pop es
                          lea si,@@StringBuffer

  @@skip_consoleprefix:

ENDIF ; console_logo



ifdef DOS


                          jmp @@while_screen
  @@loop_screen:
                          mov ah,002h
                          int 021h
  @@while_screen:
                          mov dl,es:[si]
                          inc si
                          cmp dl,0
                          jne @@loop_screen

                          mov ah,002h
                          mov dl,13
                          int 021h

                          mov ah,002h
                          mov dl,10
                          int 021h
endif


ifdef OS2

                          mov fillin_string_ptr.offs,si
                          mov fillin_string_ptr.sel ,es
                          mov si,Offset Message_table
                          sub bx,bx
                          mov dl,DevHlp_Save_Message
                          call Device_Help
endif


  @@exit:

                        popa
                        popf
                        ret
IFDEF console_logo
p_endp                  outputmessage_es_si
ELSE ; -console_logo
a_endp                  outputmessage_es_si
ENDIF ; -console_logo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
