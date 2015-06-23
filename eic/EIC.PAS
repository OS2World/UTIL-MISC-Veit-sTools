(*$G+,R-,S-*)
unit eic;
(* 29.04.1998 Veit Kannegieser *)

interface


const
  eic_result:word=0;

procedure exec_internal_com(start:pointer;parameter:string);


implementation


procedure exec_internal_com(start:pointer;parameter:string);
  const
    p64k=64*1024 div 16;

  var
    com_segment:word;
    org_psp:word;
    orgint22:pointer;
    fehler:word;

  begin
    asm
      push ds
        mov word [@rest_ss-2],ss
        mov word [@rest_sp-2],sp
        mov word [@rest_bp-2],bp

        (* GET PSP *)
        mov ah,$51
        int $21
        mov org_psp,bx

        (* GET INT 22 *)
        mov ax,$3522
        int $21
        mov word ptr orgint22+0,bx
        mov word ptr orgint22+2,es

        (* ALLOCATE MEM *)
        mov fehler,8 (* Nicht genug Speicher .. *)
        mov ah,$48
        mov bx,p64k
        int $21
        jc @eic_fehler

        mov com_segment,ax


        (* CREATE NEW PSP *)
        mov dx,ax
        mov ah,$55
        mov si,dx
        add si,p64k-1
        int $21


        (* Kopieren .. *)
        (* ..Parameter *)
        mov es,com_segment
        mov di,$80
        cld
        lea si,parameter
        push ss
        pop ds
        mov cl,[si]
        mov ch,0
        rep movsb
        movsb
        mov al,$0d
        stosb
        mov al,$00
        stosb

        (* ..COM *)
        lds si,start
        mov di,$100

        mov cx,$e000
@kopiere_com_schleife:
        dec cx
        jcxz @kopiere_com_schleife_ende
        lodsb
        stosb
        (* "[EIC]" *)
        cmp al,'['
        jne @kopiere_com_schleife
        cmp word [si],'IE'
        jne @kopiere_com_schleife
        cmp word [si+2],']C'
        jne @kopiere_com_schleife

@kopiere_com_schleife_ende:


        (* SET PSP *)
        mov ah,$50
        mov bx,com_segment
        int $21

        (* Aufruf *)
        mov es,com_segment
        mov dx,offset @weiter
        mov es:[$000a+0],dx
        mov es:[$000a+2],cs
        mov ds,com_segment
        cli
        mov ss,com_segment
        mov sp,$fffe
        sti
        mov word [$fffe],0 (* ret -> INT $20 *)

        push ds
        push $0100
        retf


@weiter:
        cli
        mov bp,'**'
@rest_ss:
        mov ss,bp
        mov sp,'**'
@rest_sp:
        mov bp,'**'
@rest_bp:
        mov fehler,0 (* kein Fehler *)

        (* INT 22 zurÅck *)
        mov ax,$2522
        lds dx,orgint22
        int $21

        (* PSP zurÅck *)
        mov ah,$50
        mov bx,org_psp
        int $21
        
        (* Speicher freigenben *)
        mov ah,$49
        mov es,com_segment
        int $21

        @eic_fehler:

      pop ds
    end;
    eic_result:=fehler;
  end;

end.

