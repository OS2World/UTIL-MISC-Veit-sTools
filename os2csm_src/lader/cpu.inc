Title   setup CPU detection variables

p8str   name_OS2CSM_CPU_FMS  'OS2CSM_CPU_FMS'
p8str   name_OS2CSM_CPU_NAME 'OS2CSM_CPU_NAME'


cpu_fms dw 0300h
p8str   cpu_fmsp8 '000'
p8str   cpu_name 'unknown_____'

a_proc  detect_cpu
        pushad
        mov bp,sp

        and sp,-4

        ; OS/2 2.x+ -> assume 386 or better
        mov cpu_fms,0300h
        mov Byte Ptr [cpu_name],7 ; Length('unknown')

        pushfd
          pushfd
          pop eax
          mov ebx,eax
          xor eax,(1 shl 18) ; Alignment Check bit
          push eax
          popfd
          pushfd
          pop eax
        popfd
        xor eax,ebx
        shr eax,18+1
        jnc continue_detect_cpu

        ; can set AC, is 486 or better
        mov cpu_fms,0400h

        pushfd
        pop eax
        or eax,(1 shl 21) ; set ID bit
        push eax
        popfd

        pushfd
        pop eax
        shr eax,21+1
        jnc continue_detect_cpu


        ; can set ID bit, CpuID available
        sub eax,eax
        sub ebx,ebx
        sub ecx,ecx
        sub edx,edx
        db 00fh,0a2h ; cpuid
        mov si,Offset cpu_name
        mov Byte Ptr  [si+0],12
        mov DWord Ptr [si+1],ebx
        mov DWord Ptr [si+5],edx
        mov DWord Ptr [si+9],ecx
        mov eax,1
        db 00fh,0a2h ; cpuid
        and ax,0fffh
        mov cpu_fms,ax

  continue_detect_cpu:
        mov cx,cpu_fms
        mov di,Offset cpu_fmsp8+1
        cld
  loop_cpu_fmsp8:
        mov al,ch
        and al,00fh
        cmp al,10
        sbb al,69h
        das
        stosb
        rol cx,4
        cmp di,Offset cpu_fmsp8+1+3
        jne loop_cpu_fmsp8

        mov bx,Offset name_OS2CSM_CPU_FMS
        mov si,Offset cpu_fmsp8
        call store_string_to_anything_varname

        mov bx,Offset name_OS2CSM_CPU_NAME
        mov si,Offset cpu_name
        call store_string_to_anything_varname

        mov sp,bp
        popad
        ret
a_endp  detect_cpu

