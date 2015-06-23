--------m-2F4310-----------------------------
INT 2F - EXTENDED MEMORY SPECIFICATION (XMS) v2+ - GET DRIVER ADDRESS
        AX = 4310h
Return: ES:BX -> driver entry point (see #02749,#02750,#02753,#02760,#02769,#027
Notes:  HIMEM.SYS v2.77 chains to previous handler if AH is not 00h or 10h
        HIMEM.SYS requires at least 256 bytes free stack space when calling
          the driver entry point
SeeAlso: AX=4300h,AX=4310h"Cloaking",AX=4310h"Netroom",AX=4310h"XMZ"

Format of XMS driver entry point:
Offset  Size    Description     (Table 02749)
 00h  5 BYTEs   jump to actual handler
                either short jump (EBh XXh) followed by three NOPs or
                  far jump (EAh XXXX:XXXX) to a program which has hooked itself
                  into the XMS driver chain
Note:   to hook into the XMS driver chain, a program should follow the chain of
          far jumps until it reaches the short jump of the driver at the end
          of the chain; this short jump is to be replaced with a far jump to
          the new handler's entry point, which should contain a short jump
          followed by three NOPs.  The new handler must return to the address
          pointed at by the short jump which was overwritten.  Using this
          method, the new handler becomes the first to see every XMS request.

(Table 02750)
Call the XMS driver "Get XMS version number" function with:
        AH = 00h
Return: AX = XMS version (in BCD, AH=major, AL=minor)
        BX = internal revision number (in BCD for HIMEM.SYS)
        DX = High Memory Area (HMA) state
            0001h HMA (1M to 1M + 64K) exists
            0000h HMA does not exist
SeeAlso: #02751,#02752,#02757,#02758,#02764

(Table 02751)
Call the XMS driver "Request High Memory Area" function with:
        AH = 01h
        DX = memory in bytes (for TSR or device drivers)
            FFFFh if application program
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h,81h,90h,91h,92h) (see #02775)
Note:   HIMEM.SYS will fail function 01h with error code 91h if AL=40h and
          DX=KB free extended memory returned by last call of function 08h
SeeAlso: #02752,#02784

(Table 02752)
Call the XMS driver "Release High Memory Area" function with:
        AH = 02h
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h,81h,90h,93h) (see #02775)
SeeAlso: #02751

(Table 02753)
Call the XMS driver "Global enable A20, for using the HMA" function with:
        AH = 03h
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h,81h,82h) (see #02775)
SeeAlso: #02754,#02755,MSR 00001000h

(Table 02754)
Call the XMS driver "Global disable A20" function with:
        AH = 04h
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h,81h,82h,94h) (see #02775)
SeeAlso: #02753,#02756,MSR 00001000h

(Table 02755)
Call the XMS driver "Local enable A20" function with:
        AH = 05h
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h,81h,82h) (see #02775)
Note:   this function is used for direct access to extended memory
SeeAlso: #02753,#02756

(Table 02756)
Call the XMS driver "Local disable A20" function with:
        AH = 06h
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h,81h,82h,94h) (see #02775)
SeeAlso: #02754,#02755

(Table 02757)
Call the XMS driver "Query A20 state" function with:
        AH = 07h
Return: AX = status
            0001h enabled
            0000h disabled
                BL = error code (00h,80h,81h) (see #02775)
SeeAlso: #02750,#02758

(Table 02758)
Call the XMS driver "Query free extended memory" function with:
        AH = 08h
        BL = 00h (some implementations leave BL unchanged on success)
Return: AX = size of largest extended memory block in KB
        DX = total extended memory in KB
        BL = error code (00h,80h,81h,A0h) (see #02775)
Note:   this function does not include the HMA in the returned memory sizes
SeeAlso: #02750,#02757,#02759,#02771

(Table 02759)
Call the XMS driver "Allocate extended memory block" function with:
        AH = 09h
        DX = Kbytes needed
Return: AX = status
            0001h success
                DX = handle for memory block
            0000h failure
                BL = error code (80h,81h,A0h) (see #02775)
SeeAlso: #02758,#02761,#02764,#02765,#02766,#02772

(Table 02760)
Call the XMS driver "Free extended memory block" function with:
        AH = 0Ah
        DX = handle of block to free
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h,81h,A2h,ABh) (see #02775)
SeeAlso: #02759,#02772

(Table 02761)
Call the XMS driver "Move extended memory block" function with:
        AH = 0Bh
        DS:SI -> EMM structure (see #02776)
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h-82h,A3h-A9h) (see #02775)
Note:   if either handle in the EMM structure is 0000h, the corresponding
          offset is considered to be an absolute segment:offset address in
          directly addressable memory
SeeAlso: #02759,#02762

(Table 02762)
Call the XMS driver "Lock extended memory block" function with:
        AH = 0Ch
        DX = handle of block to lock
Return: AX = status
            0001h success
                DX:BX = 32-bit physical address of locked block
            0000h failure
                BL = error code (80h,81h,A2h,ACh,ADh) (see #02775)
Note:   MS Windows 3.x rejects this function for handles allocated after
          Windows started
SeeAlso: #02759,#02761,#02763,#02777

(Table 02763)
Call the XMS driver "Unlock extended memory block" function with:
        AH = 0Dh
        DX = handle of block to unlock
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h,81h,A2h,AAh) (see #02775)
SeeAlso: #02762

(Table 02764)
Call the XMS driver "Get handle information" function with:
        AH = 0Eh
        DX = handle for which to get info
Return: AX = status
            0001h success
                BH = block's lock count
                BL = number of free handles left
                DX = block size in KB
            0000h failure
                BL = error code (80h,81h,A2h) (see #02775)
BUG:    MS Windows 3.10 acts as though unallocated handles are in use
Note:   MS Windows 3.00 has problems with this call
SeeAlso: #02750,#02759,#02773

(Table 02765)
Call the XMS driver "Reallocate extended memory block" function with:
        AH = 0Fh
        DX = handle of block
        BX = new size of block in KB
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h,81h,A0h-A2h,ABh) (see #02775)
SeeAlso: #02759,#02768

(Table 02766)
Call the XMS driver "Request upper memory block" function with:
        AH = 10h
        DX = size of block in paragraphs
Return: AX = status
            0001h success
                BX = segment address of UMB
                DX = actual size of block
            0000h failure
                BL = error code (80h,B0h,B1h) (see #02775)
                DX = largest available block
Notes:  Upper Memory consists of non-EMS memory between 640K and 1024K
        the XMS driver need not implement functions 10h through 12h to be
          considered compliant with the standard
        under DOS 5+, if CONFIG.SYS contains the line DOS=UMB, then no upper
          memory blocks will be available for allocation because all blocks
          have been grabbed by MS-DOS while booting
SeeAlso: #02759,#02767,#02785,INT 21/AH=58h"UMB"

(Table 02767)
Call the XMS driver "Release upper memory block" function with:
        AH = 11h
        DX = segment address of UMB to release
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h,B2h) (see #02775)
Note:   the XMS driver need not implement functions 10h through 12h to be
          considered compliant with the standard
SeeAlso: #02760,#02766,#02768

(Table 02768)
Call the XMS v3.0+ driver "Reallocate upper memory block" function with:
        AH = 12h
        DX = segment address of UMB to resize
        BX = new size of block in paragraphs
Return: AX = status
            0001h success
            0000h failure
                BL = error code (80h,B0h,B2h) (see #02775)
                DX = maximum available size (RM386)
Note:   the XMS driver need not implement functions 10h through 12h to be
          considered compliant with the standard
SeeAlso: #02765,#02766,#02767,#02783

(Table 02769)
Call the QEMM v5.11 "???" function with:
        AH = 34h  (QEMM 5.11 only, undocumented)
        ???
Return: ???
SeeAlso: #02770

(Table 02770)
Call the QEMM v5.11 "???" function with:
        AH = 44h  (QEMM 5.11 only, undocumented)
        ???
Return: ???
SeeAlso: #02769,#02783

(Table 02771)
Call the XMS v3.0 driver "Query free extended memory" function with:
        AH = 88h
Return: EAX = largest block of extended memory, in KB
        BL = status (00h,80h,81h,A0h) (see #02775)
        ECX = physical address of highest byte of memory
            (valid even on error codes 81h and A0h)
        EDX = total Kbytes of extended memory (0 if status A0h)
BUG:    HIMEM v3.03-3.07 crash on an 80286 machine if any of the 8Xh functions
          are called
SeeAlso: #02758,#02772

(Table 02772)
Call the XMS v3.0 driver "Allocate any extended memory" function with:
        AH = 89h
        EDX = Kbytes needed
Return: AX = status
            0001h success
                DX = handle for allocated block (free with AH=0Ah) (see #02760)
            0000h failure
                BL = status (80h,81h,A0h,A1h,A2h) (see #02775)
SeeAlso: #02759,#02771

(Table 02773)
Call the XMS v3.0 driver "Get extended EMB handle information" function with:
        AH = 8Eh
        DX = handle
Return: AX = status
            0001h success
                BH = block's lock count
                CX = number of free handles left
                EDX = block size in KB
            0000h failure
                BL = status (80h,81h,A2h) (see #02775)
BUG:    MS-DOS 6.0 HIMEM.SYS leaves CX unchanged
SeeAlso: #02764,#02772,#02774

(Table 02774)
Call the XMS v3.0 driver "Reallocate any extended memory block" function with:
        AH = 8Fh
        DX = unlocked memory block handle
        EBX = new size in KB
Return: AX = status
            0001h success
            0000h failure
                BL = status (80h,81h,A0h-A2h,ABh) (see #02775)
BUG:    HIMEM v3.03-3.07 crash on an 80286 machine if any of the 8Xh functions
          are called
SeeAlso: #02765,#02773

(Table 02775)
Values for XMS error code returned in BL:
 00h    successful
 80h    function not implemented
 81h    Vdisk was detected
 82h    an A20 error occurred
 8Eh    a general driver error
 8Fh    unrecoverable driver error
 90h    HMA does not exist or is not managed by XMS provider
 91h    HMA is already in use
 92h    DX is less than the /HMAMIN= parameter
 93h    HMA is not allocated
 94h    A20 line still enabled
 A0h    all extended memory is allocated
 A1h    all available extended memory handles are allocated
 A2h    invalid handle
 A3h    source handle is invalid
 A4h    source offset is invalid
 A5h    destination handle is invalid
 A6h    destination offset is invalid
 A7h    length is invalid
 A8h    move has an invalid overlap
 A9h    parity error occurred
 AAh    block is not locked
 ABh    block is locked
 ACh    block lock count overflowed
 ADh    lock failed
 B0h    only a smaller UMB is available
 B1h    no UMB's are available
 B2h    UMB segment number is invalid

Format of EMM structure:
Offset  Size    Description     (Table 02776)
 00h    DWORD   number of bytes to move (must be even)
 04h    WORD    source handle
 06h    DWORD   offset into source block
 0Ah    WORD    destination handle
 0Ch    DWORD   offset into destination block
Notes:  if source and destination overlap, only forward moves (source base
          less than destination base) are guaranteed to work properly
        if either handle is zero, the corresponding offset is interpreted
          as a real-mode address referring to memory directly addressable
          by the processor

Format of XMS handle info [array]:
Offset  Size    Description     (Table 02777)
 00h    BYTE    handle
 01h    BYTE    lock count
 02h    DWORD   handle size
 06h    DWORD   handle physical address (only valid if lock count nonzero)
SeeAlso: #02747,#02762
