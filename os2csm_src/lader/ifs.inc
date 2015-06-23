Title   OS2LDR/MICRO IFS interface

; Schnittstelle beim Aufruf von OS2LDR (IFS.INF)
; der Zeiger darauf ist in ES:DI

FileTable               Struc
  ft_cfiles             dw ? ; # of entries in this table
  ft_ldrseg             dw ? ; paragraph # where OS2LDR is loaded
  ft_ldrlen             dd ? ; length of OS2LDR in bytes
  ft_museg              dw ? ; paragraph # where microFSD is loaded
  ft_mulen              dd ? ; length of microFSD in bytes
  ft_mfsseg             dw ? ; paragraph # where miniFSD is loaded
  ft_mfslen             dd ? ; length of miniFSD in bytes
  ft_ripseg             dw ? ; paragraph # where RIPL data is loaded
  ft_riplen             dd ? ; length of RIPL data in bytes
  ; The next four elements are pointers to microFSD entry points
  ft_muOpen             dd ? ; (const pName:pchar;var pulFileSize:longint):smallword;
  ft_muRead             dd ? ; (const loffseek:longint;const pBuf:pointer;const cbBuf:longint):longint;
  ft_muClose            dd ? ; :longint;
  ft_muTerminate        dd ? ; :longint;
FileTable               EndS

