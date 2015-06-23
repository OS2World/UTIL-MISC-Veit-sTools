unit int_13;

(*********************
 * Physical Disk-I/O *
 *********************)

(*$R-*)(*$S-*)(*$G+*)

interface

type
  sector_typ    =packed array[0..511] of byte;
  sector_z_typ  =^sector_typ;


(* drive: 0=a,1=b..$80=HD0,$81=HD1... *)

(* read 1 sector *)
function read_phys_sector(const drive:byte;
                          const cylinder,head,sector:longint;
                          const num_heads,sector_per_track:longint;
                          var   s:sector_typ):word;

(* write 1 sector *)
function write_phys_sector(const drive:byte;
                           const cylinder,head,sector:longint;
                           const num_heads,sector_per_track:longint;
                           const s:sector_typ):word;

(* get drive type and parameters *)
function get_phys_drive_parameters
                        (const drive:byte;
                         var   cylinders,
                               num_heads,
                               sectors:longint;
                         var   floppy_type:byte):word;

(* seek to track 0 *)
procedure reset_phys_disk(const drive:byte);

const
  floppy_type_360       =1;
  floppy_type_1200      =2;
  floppy_type_720       =3;
  floppy_type_1440      =4;
  floppy_type_2880_1    =5;
  floppy_type_2880      =6;
  floppy_type_atapi     =7;


implementation

uses
  Dos;

type
  smallword             =word;
  disk_address_packet=
    packed record
      size_of_packet    :byte;
      reserved          :byte;
      number_of_blocks  :smallword;
      transfer_buffer   :pointer;
      starting_absolute_block_number_lo:longint;
      starting_absolute_block_number_hi:longint;
    end;

  drive_parameters=     (* Version 1.x *)
    packed record
      size_of_buffer    :smallword;
      information_flags :smallword;
      physical_cylinders:longint;
      physical_heads    :longint;
      physical_sectors_per_track        :longint;
      total_number_of_sectors_lo        :longint;
      total_number_of_sectors_hi        :longint;
      bytes_per_sector  :smallword;
    end;


function read_phys_sector_chs(
                        const drive     :byte;
                        const cylinder  :longint;
                        const head      :byte;
                        const sector    :byte;
                        var   s         :sector_typ):word;assembler;
  asm
    push es
      mov ax,$0201
      mov dl,[drive]
      mov dh,[head]
      mov cx,word ptr [cylinder]
      ror cx,8
      shl cl,6
      or cl,[sector]
      les bx,[s]
      int $13
      jc @ret
      sub ax,ax
    @ret:
    pop es
  end;

function read_phys_sector_linear(
                        const drive     :byte;
                        const lin_block :longint;
                        var   s         :sector_typ):word;
  var
    r                   :registers;
    disk_packet         :disk_address_packet;
  begin
    with r do
      begin
        ah:=$42;
        dl:=drive;
        ds:=Seg(disk_packet);
        si:=Ofs(disk_packet);
      end;

    with disk_packet do
      begin
        size_of_packet    :=SizeOf(disk_address_packet);
        reserved          :=0;
        number_of_blocks  :=1;
        transfer_buffer   :=@s;
        starting_absolute_block_number_lo :=lin_block;
        starting_absolute_block_number_hi :=0;
      end;

    Intr($13,r);

    read_phys_sector_linear:=r.ah;
  end;

function read_phys_sector(
                        const drive     :byte;
                        const cylinder,
                              head,
                              sector    :longint;
                        const num_heads,
                              sector_per_track:longint;
                        var   s         :sector_typ):word;
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
                        const s         :sector_typ):word;assembler;
  asm
    push es
      mov ax,$0301
      mov dl,[drive]
      mov dh,[head]
      mov cx,word ptr [cylinder]
      ror cx,8
      shl cl,6
      or cl,[sector]
      les bx,[s]
      int $13
      jc @ret
      sub ax,ax
    @ret:
    pop es
  end;

function write_phys_sector_linear(
                        const drive     :byte;
                        const lin_block :longint;
                        const s         :sector_typ):longint;
  var
    r                   :registers;
    disk_packet         :disk_address_packet;
  begin
    with r do
      begin
        ax:=$4300;
        dl:=drive;
        ds:=Seg(disk_packet);
        si:=Ofs(disk_packet);
      end;

    with disk_packet do
      begin
        size_of_packet    :=SizeOf(disk_address_packet);
        reserved          :=0;
        number_of_blocks  :=1;
        transfer_buffer   :=@s;
        starting_absolute_block_number_lo :=lin_block;
        starting_absolute_block_number_hi :=0;
      end;

    Intr($13,r);

    write_phys_sector_linear:=r.ah;
  end;


function write_phys_sector(
                        const drive     :byte;
                        const cylinder,
                              head,
                              sector    :longint;
                        const num_heads,
                              sector_per_track:longint;
                        const s         :sector_typ):word;
  begin
    if cylinder>=1024 then
      write_phys_sector:=write_phys_sector_linear(drive,(cylinder*num_heads+head)*sector_per_track+sector-1,s)
    else
      write_phys_sector:=write_phys_sector_chs(drive,cylinder,head,sector,s);
  end;


function get_phys_drive_parameters
                        (const drive:byte;
                         var   cylinders,
                               num_heads,
                               sectors:longint;
                         var   floppy_type:byte):word;
  var
    r                   :registers;
    info                :drive_parameters;
  begin
    get_phys_drive_parameters:=0;
    with r do
      begin
        FillChar(r,SizeOf(r),0);

        ah:=$08;
        dl:=drive;
        Intr($13,r);

        if (flags and fCarry)=0 then
          begin
            floppy_type:=bl;
            num_heads:=longint(dh)+1;
            sectors:=cl and $3f;
            cylinders:=(ch+(cl and $c0) shl 2)+1;

            if cylinders=1024 then
              begin
                ah:=$48;
                dl:=drive;
                ds:=Seg(info);
                si:=Ofs(info);
                Intr($13,r);
                if ah=0 then
                  cylinders:=(info.total_number_of_sectors_lo div num_heads) div sectors;
              end;
          end
        else
          get_phys_drive_parameters:=ah;
      end;
  end;

procedure reset_phys_disk(const drive:byte);assembler;
  asm
    mov ah,0
    mov dl,[drive]
    int $13
  end;


end.
