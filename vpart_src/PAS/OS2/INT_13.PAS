unit int_13;

(*********************
 * Physical Disk-I/O *
 *********************)

(*$R-*)(*$S-*)

interface

type
  sector_typ            =packed array[0..511] of byte;
  sector_z_typ          =^sector_typ;

const
  floppy_type_48_TPI_low_density        = 0;
  floppy_type_96_TPI_high_density       = 1;
  floppy_type_3_5_inch_720KB            = 2;
  floppy_type_8_Inch_single_density     = 3;
  floppy_type_8_Inch_double_density     = 4;
  floppy_type_Fixed_disk                = 5;
  floppy_type_Tape_drive                = 6;
  floppy_type_Other_1440                = 7;
  floppy_type_RW_optical_disk           = 8;
  floppy_type_3_5_inch_2880             = 9;


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
  Os2Base,
  Os2Def,
  int_2526;



function read_phys_sector(
                        const drive     :byte;
                        const cylinder,
                              head,
                              sector    :longint;
                        const num_heads,
                              sector_per_track:longint;
                        var   s         :sector_typ):longint;

  var
    laufwerk            :string[3];
    hand                :smallword;
    tl                  :tracklayout;
    tl_laenge           :longint;
    anzahl_gelesen      :longint;
    fehler              :longint;

  begin
    (* keine Festplatte ? *)
    if drive<$80 then
      begin
        read_phys_sector:=read_logical_sector(drive,s,(cylinder*num_heads+head)*sector_per_track+sector-1);
        Exit;
      end;

    laufwerk:='1:'#0;
    Inc(laufwerk[1],drive-$80);

    (* Zuordnen/™ffnen *)
    fehler:=DosPhysicalDisk(INFO_GETIOCTLHANDLE,@hand,SizeOf(hand),Addr(laufwerk[1]),Length(laufwerk));
    if fehler<>0 then
      begin
        read_phys_sector:=-1;
        Exit;
      end;

    (* Lesen *)
    tl_laenge     :=SizeOf(tl);

    with tl do
      begin
        bCommand:=1-1; (* ??? *)
        usHead:=head;
        usCylinder:=cylinder;
        usFirstSector:=0;
        cSectors:=1;
        TrackTable[0].usSectorNumber:=sector;
        TrackTable[0].usSectorSize:=512;
      end;

    read_phys_sector:=DosDevIOCtl(hand,ioctl_physicaldisk,pdsk_readphystrack,
                                  Addr(tl),SizeOf(tl),Addr(tl_laenge     ),
                                  Addr(s ),512       ,Addr(anzahl_gelesen));


    (* Schliessen *)
    fehler:=DosPhysicalDisk(INFO_FREEIOCTLHANDLE,
                            Ptr(0)    ,0,
                            Addr(hand),2);

  end;


function write_phys_sector(
                        const drive     :byte;
                        const cylinder,
                              head,
                              sector    :longint;
                        const num_heads,
                              sector_per_track:longint;
                        const s         :sector_typ):longint;
  var
    laufwerk            :string[3];
    hand                :smallword;
    tl                  :tracklayout;
    tl_laenge           :longint;
    anzahl_gelesen      :longint;
    fehler              :longint;

  begin
    (* keine Festplatte ? *)
    if drive<$80 then
      begin
        write_phys_sector:=write_logical_sector(drive,s,(cylinder*num_heads+head)*sector_per_track+sector-1);
        Exit;
      end;

    laufwerk:='1:'#0;
    Inc(laufwerk[1],drive-$80);

    (* Zuordnen/™ffnen *)
    fehler:=DosPhysicalDisk(INFO_GETIOCTLHANDLE,@hand,SizeOf(hand),Addr(laufwerk[1]),Length(laufwerk));
    if fehler<>0 then
      begin
        write_phys_sector:=-1;
        Exit;
      end;

    (* Lesen *)
    tl_laenge     :=SizeOf(tl);

    with tl do
      begin
        bCommand:=1-1; (* ??? *)
        usHead:=head;
        usCylinder:=cylinder;
        usFirstSector:=0;
        cSectors:=1;
        TrackTable[0].usSectorNumber:=sector;
        TrackTable[0].usSectorSize:=512;
      end;

    write_phys_sector:=DosDevIOCtl(hand,ioctl_physicaldisk,pdsk_writephystrack,
                                  Addr(tl),SizeOf(tl),Addr(tl_laenge     ),
                                  Addr(s ),512       ,Addr(anzahl_gelesen));


    (* Schliessen *)
    fehler:=DosPhysicalDisk(INFO_FREEIOCTLHANDLE,
                            Ptr(0)    ,0,
                            Addr(hand),2);

  end;


function get_phys_drive_parameters
                        (const drive:byte;
                         var   cylinders,       // 0..cylinders-1
                               num_heads,       // 0..num_head-1
                               sectors:longint; // 1..sectors
                         var   floppy_type:byte):longint;
  var
    laufwerk            :string[3];
    hand                :smallword;
    para                :byte;
    para_laenge         :longint;
    data                :deviceparameterblock;
    data_laenge         :longint;
    fehler              :longint;
  begin
    (* keine Festplatte ? *)
    if drive<$80 then
      begin
        get_phys_drive_parameters:=getdeviceparams(drive,cylinders,num_heads,sectors,floppy_type);
        Exit;
      end;

    laufwerk:='1:'#0;
    Inc(laufwerk[1],drive-$80);

    (* Zuordnen/™ffnen *)
    fehler:=DosPhysicalDisk(INFO_GETIOCTLHANDLE,@hand,SizeOf(hand),Addr(laufwerk[1]),Length(laufwerk));
    if fehler<>0 then
      begin
        get_phys_drive_parameters:=-1;
        Exit;
      end;

    (* Lesen *)
    para:=0;
    para_laenge:=SizeOf(para);

    FillChar(data,SizeOf(data),0);
    data_laenge:=SizeOf(data);

    get_phys_drive_parameters:=DosDevIOCtl(hand,ioctl_physicaldisk,pdsk_getphysdeviceparams,
                                           Addr(para),SizeOf(para),Addr(para_laenge),
                                           Addr(data),SizeOf(data),Addr(data_laenge));


    (* Schliessen *)
    fehler:=DosPhysicalDisk(INFO_FREEIOCTLHANDLE,
                            Ptr(0)    ,0,
                            Addr(hand),2);

    cylinders:=data.cCylinders;
    num_heads:=data.cHeads;
    sectors  :=data.cSectorsPerTrack;
    floppy_type:=$ff;
  end;

procedure reset_phys_disk(const drive:byte);
  begin
  end;

end.

