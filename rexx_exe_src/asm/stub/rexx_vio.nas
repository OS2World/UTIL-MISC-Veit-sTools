org 0100h
mov ah,009h
mov dx,message
int 021h
mov ax,04c01h
int 021h

message: db 'This is an OS/2 VIO wrapped REXX program!',13,10,'$'
