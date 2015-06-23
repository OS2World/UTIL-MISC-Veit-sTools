Title           aPLib decompression code, derived from depack16.asm(0.43)

;;
;; aPLib compression library  -  the smaller the better :)
;;
;; TASM / MASM / WASM 16bit assembler depacker
;;
;; Copyright (c) 1998-2005 by Joergen Ibsen / Jibz
;; All Rights Reserved
;;
;; http://www.ibsensoftware.com/
;;
;; -> 16bit by Metalbrain (metalbrain_coder@gmx.net)
;; -> "15,9bit" (<=64K) Veit Kannegieser 2002.02.02

;*.MODEL TINY                   ; or whatever your code is :)
;*
;*.CODE
;*.386
;*


; DS:SI=source
; ES:DI=target
; -> AX=unpacked

a_proc          aP_depack16_asm
    push   bp
    mov    bp, sp
    pusha

    push   bp

    push   di

    cld
    mov    dl, 80h
literal:
    lodsb
putedi_nexttag:
    stosb
    mov    dh, 1
    jmp    nexttag

normalcodepair:
    xchg   ax, cx
    dec    ax
    shl    ax, 8
    lodsb
    call   getgamma
    cmp    ax, 32000 ; impossible ?
    jae    domatch_with_2inc
    cmp    ah, 5
    jae    domatch_with_inc
    cmp    ax, 127
    ja     domatch_new_lastpos

domatch_with_2inc:
    inc    cx
domatch_with_inc:
    inc    cx

domatch_new_lastpos:
    xchg   ax, bp
domatch_lastpos:
    mov    ax, bp
    mov    dh, 0

domatch:
    push   si

    mov    si, di
    sub    si, ax
    rep movs byte ptr es:[di],es:[si]

    pop    si

nexttag:
    call   getbit
    jnc    literal
    xor    cx, cx
    call   getbit
    jnc    codepair
    xor    ax, ax
    call   getbit
    jnc    shortmatch
    mov    dh, 1
    inc    cx
    mov    al, 10h
getmorebits:
    call   getbit
    adc    al, al
    jnc    getmorebits
    jnz    domatch
    jmp    putedi_nexttag

codepair:
    call   getgamma_no_ecx
    shr    dh, 1
    sbb    cx, 1
    jnz    normalcodepair
    push   offset domatch_lastpos

getgamma:
    xor    cx, cx
getgamma_no_ecx:
    inc    cx
getgammaloop:
    call   getbit
    adc    cx, cx
    call   getbit
    jc     getgammaloop
    ret

shortmatch:
    lodsb
    shr    ax, 1
    jz     donedepacking
    adc    cx, cx
    jmp    domatch_with_2inc

getbit:
    add    dl, dl
    jnz    stillbitsleft
    pushf
    xchg   ax, dx
    lodsb
    xchg   ax, dx
    popf
    adc    dl, dl
stillbitsleft:
    ret

donedepacking:
    pop    ax

    pop    bp
    sub    di, ax
    mov    [bp - 2], di      ; return unpacked length in ax

    popa
    pop    bp
    ret
a_endp          aP_depack16_asm

;*END
