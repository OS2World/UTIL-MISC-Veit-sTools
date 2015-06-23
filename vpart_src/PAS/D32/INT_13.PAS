unit int_13;

(*********************
 * Physical Disk-I/O *
 *********************)

(*$R-*)(*$S-*)

interface

(* error codes from interrupt list:

(Table 00216)
Values for disk operation status:
 00h    successful completion
 01h    invalid function in AH or invalid parameter
 02h    address mark not found
 03h    disk write-protected
 04h    sector not found/read error
 05h    reset failed (hard disk)
 05h    data did not verify correctly (TI Professional PC)
 06h    disk changed (floppy)
 07h    drive parameter activity failed (hard disk)
 08h    DMA overrun
 09h    data boundary error (attempted DMA across 64K boundary or >80h sectors)
 0Ah    bad sector detected (hard disk)
 0Bh    bad track detected (hard disk)
 0Ch    unsupported track or invalid media
 0Dh    invalid number of sectors on format (PS/2 hard disk)
 0Eh    control data address mark detected (hard disk)
 0Fh    DMA arbitration level out of range (hard disk)
 10h    uncorrectable CRC or ECC error on read
 11h    data ECC corrected (hard disk)
 20h    controller failure
 31h    no media in drive (IBM/MS INT 13 extensions)
 32h    incorrect drive type stored in CMOS (Compaq)
 40h    seek failed
 80h    timeout (not ready)
 AAh    drive not ready (hard disk)
 B0h    volume not locked in drive (INT 13 extensions)
 B1h    volume locked in drive (INT 13 extensions)
 B2h    volume not removable (INT 13 extensions)
 B3h    volume in use (INT 13 extensions)
 B4h    lock count exceeded (INT 13 extensions)
 B5h    valid eject request failed (INT 13 extensions)
 BBh    undefined error (hard disk)
 CCh    write fault (hard disk)
 E0h    status register error (hard disk)
 FFh    sense operation failed (hard disk)                      *)

type
  sector_typ    =packed array[0..511] of byte;
  sector_z_typ  =^sector_typ;

const
  floppy_type_360       =1;
  floppy_type_1200      =2;
  floppy_type_720       =3;
  floppy_type_1440      =4;
  floppy_type_2880_1    =5;
  floppy_type_2880      =6;
  floppy_type_atapi     =7;


(* drive: 0=a,1=b..$80=HD0,$81=HD1... *)

// read 1 sector
function read_phys_sector(const drive:byte;
                          const cylinder,head,sector:longint;
                          const num_heads,sector_per_track:longint;
                          var   s:sector_typ):longint;

// write 1 sector
function write_phys_sector(const drive:byte;
                           const cylinder,head,sector:longint;
                           const num_heads,sector_per_track:longint;
                           const s:sector_typ):longint;

// get drive type and parameters
function get_phys_drive_parameters
                        (const drive:byte;
                         var   cylinders,       // 0..cylinders-1
                               num_heads,       // 0..num_head-1
                               sectors:longint; // 1..sectors
                         var   floppy_type:byte):longint;

// seek to track 0
procedure reset_phys_disk(const drive:byte);


implementation

uses
  dpmi32df,
  dpmi32;

var
  // realmode segment
  int_13_buffer_16      :smallword;
  // flat offset
  int_13_buffer_32      :longint;

type
  disk_address_packet=
    packed record
      size_of_packet    :byte;
      reserved          :byte;
      number_of_blocks  :smallword;
      transfer_buffer   :real_mode_ptr_typ;
      starting_absolute_block_number :Comp;
    end;

  drive_parameters=     (* Version 1.x *)
    packed record
      size_of_buffer    :smallword;
      information_flags :smallword;
      physical_cylinders:longint;
      physical_heads    :longint;
      physical_sectors_per_track        :longint;
      total_number_of_sectors           :Comp;
      bytes_per_sector  :smallword;
    end;


function read_phys_sector_chs(
                        const drive     :byte;
                        const cylinder  :longint;
                        const head      :byte;
                        const sector    :byte;
                        var   s         :sector_typ):longint;assembler;
(*$FRAME-*)(*$USES NONE*)
  var
    r                   :real_mode_call_structure_typ;
  asm
    lea eax,[r]
    push eax
    call init_register

    mov [r.ax_],$0201           // read 1 sector

    mov al,[drive]
    mov [r.dl_],al

    mov al,[head]
    mov [r.dh_],al

    mov eax,[cylinder]
    mov [r.ch_],al              // cylinder Bits 0..7
    shl ah,6                    // cylinder Bits 8..9
    or ah,[sector]
    mov [r.cl_],ah

    mov ax,[int_13_buffer_16]   // ES:BX=buffer
    mov [r.es_],ax
    mov [r.bx_],0

    lea eax,r
    push eax
    push $13
    call intr_realmode

    test [r.flags_],flags_carry
    jnz @error

    // copy sector
    mov eax,[s]
    push [int_13_buffer_32]
    push eax
    push 512
    call _MemMove
    sub eax,eax
    jmp @ret

  @error:
    movzx eax,[r.ah_]

  @ret:
  end;

function read_phys_sector_linear(
                        const drive     :byte;
                        const lin_block :longint;
                        var   s         :sector_typ):longint;
  var
    r                   :real_mode_call_structure_typ;
  begin
    init_register(r);
    with r do
      begin
        ah_:=$42;               // extended BIOS read
        dl_:=drive;
        ds_:=int_13_buffer_16;  // DS:SI=disk packet
        esi_:=0;
      end;

    with disk_address_packet(Ptr(int_13_buffer_32)^) do
      begin
        size_of_packet    :=SizeOf(disk_address_packet);
        reserved          :=0;
        number_of_blocks  :=1;
        transfer_buffer.ofs_:=SizeOf(disk_address_packet);
        transfer_buffer.seg_:=int_13_buffer_16;
        starting_absolute_block_number :=lin_block;
      end;

    intr_realmode(r,$13);

    Move(Ptr(int_13_buffer_32+SizeOf(disk_address_packet))^,s,512);

    read_phys_sector_linear:=r.ah_;
  end;

function read_phys_sector(
                        const drive     :byte;
                        const cylinder,
                              head,
                              sector    :longint;
                        const num_heads,
                              sector_per_track:longint;
                        var   s         :sector_typ):longint;
  begin
    if cylinder>=1024 then
      read_phys_sector:=read_phys_sector_linear(drive,(cylinder*num_heads+head)*sector_per_track+sector-1,s)
    else
      read_phys_sector:=read_phys_sector_chs(drive,cylinder,head,sector,s);
  end;


function write_phys_sector_chs(
                        const drive     :byte;
                        const cylinder  :longint;
                        const head      :byte;
                        const sector    :byte;
                        const s         :sector_typ):longint;assembler;
(*$FRAME-*)(*$USES NONE*)
  var
    r                   :real_mode_call_structure_typ;
  asm
    lea eax,[r]
    push eax
    call init_register

    push [s]
    push [int_13_buffer_32]
    push 512
    call _MemMove


    mov [r.ax_],$0301           // write 1 sector

    mov al,[drive]
    mov [r.dl_],al

    mov al,[head]
    mov [r.dh_],al

    mov eax,[cylinder]
    mov [r.ch_],al              // cylinder Bits 0..7
    shl ah,6                    // cylinder Bits 8..9
    or ah,[sector]
    mov [r.cl_],ah

    mov ax,[int_13_buffer_16]   // ES:BX=buffer
    mov [r.es_],ax
    mov [r.bx_],0

    lea eax,r
    push eax
    push $13
    call intr_realmode

    sub eax,eax
    test [r.flags_],flags_carry
    jz @no_error

    mov al,[r.ah_]

  @no_error:
  end;

function write_phys_sector_linear(
                        const drive     :byte;
                        const lin_block :longint;
                        const s         :sector_typ):longint;
  var
    r                   :real_mode_call_structure_typ;
  begin
    init_register(r);
    with r do
      begin
        ax_:=$4300;             // extended BIOS write, no verify bit
        dl_:=drive;
        ds_:=int_13_buffer_16;  // DS:SI=disk packet
        esi_:=0;
      end;

    with disk_address_packet(Ptr(int_13_buffer_32)^) do
      begin
        size_of_packet    :=SizeOf(disk_address_packet);
        reserved          :=0;
        number_of_blocks  :=1;
        transfer_buffer.ofs_:=SizeOf(disk_address_packet);
        transfer_buffer.seg_:=int_13_buffer_16;
        starting_absolute_block_number :=lin_block;
      end;

    Move(s,Ptr(int_13_buffer_32+SizeOf(disk_address_packet))^,512);

    intr_realmode(r,$13);

    write_phys_sector_linear:=r.ah_;
  end;


function write_phys_sector(
                        const drive     :byte;
                        const cylinder,
                              head,
                              sector    :longint;
                        const num_heads,
                              sector_per_track:longint;
                        const s         :sector_typ):longint;
  begin
    if cylinder>=1024 then
      write_phys_sector:=write_phys_sector_linear(drive,(cylinder*num_heads+head)*sector_per_track+sector-1,s)
    else
      write_phys_sector:=write_phys_sector_chs(drive,cylinder,head,sector,s);
  end;


function get_phys_drive_parameters
                        (const drive:byte;
                         var   cylinders,       // 0..cylinders-1
                               num_heads,       // 0..num_head-1
                               sectors:longint; // 1..sectors
                         var   floppy_type:byte):longint;assembler;
(*$FRAME-*)(*$USES ESI,EDX*)
  var
    r                   :real_mode_call_structure_typ;
  asm
    lea eax,[r]
    push eax
    call init_register

    mov [r.ah_],$08             // GET DRIVE PARAMETERS
    mov al,[drive]
    mov [r.dl_],al

    lea eax,r
    push eax
    push $13
    call intr_realmode

    test [r.flags_],flags_carry
    jnz @error

    // pass returned values
    mov al,[r.bl_]
    mov esi,[floppy_type]
    mov [esi],al

    movzx eax,[r.dh_]
    inc eax
    mov esi,[num_heads]
    mov [esi],eax
    mov edx,eax

    movzx eax,[r.cl_]
    and eax,$3f
    mov esi,[sectors]
    mov [esi],eax
    mul edx
    mov edx,eax                 // edx=sectors*num_heads

    movzx eax,[r.ch_]
    mov ah,[r.cl_]
    shr ah,6
    inc eax
    mov esi,[cylinders]
    mov [esi],eax

    cmp eax,1024
    jne @weniger_als_1024_zylinder

    mov [r.ah_],$48             // extended BIOS: GET DRIVE PARAMETERS
    mov al,[drive]
    mov [r.dl_],al
    mov ax,[int_13_buffer_16]   // DS:SI=buffer
    mov [r.ds_],ax
    sub eax,eax
    mov [r.esi_],eax

    lea eax,r
    push eax
    push $13
    call intr_realmode

    movzx eax,[r.ah_]
    or eax,eax
    jnz @ret

    mov esi,[int_13_buffer_32]
    mov eax,dword [esi.drive_parameters.total_number_of_sectors]
    mov esi,edx
    sub edx,edx
    div esi
    mov esi,[cylinders]
    mov [esi],eax

  @weniger_als_1024_zylinder:
    sub eax,eax
    jmp @ret

  @error:
    movzx eax,[r.ah_]

  @ret:
  end;

procedure reset_phys_disk(const drive:byte);assembler;
(*$FRAME-*)(*$USES EAX*)
  var
    r                   :real_mode_call_structure_typ;
  asm
    mov [r.ah_],$00             // reset
    mov al,[drive]
    mov [r.dl_],al

    lea eax,r
    push eax
    push $13
    call intr_realmode
  end;


begin
   // allocate transfer buffer (512 byte) and packet buffer
  if getdosmem(int_13_buffer_16,
               SizeOf(sector_typ)+SizeOf(disk_address_packet))=0 then
    int_13_buffer_32:=dosseg_linear(int_13_buffer_16)
  else
    runerror(8);
end.

