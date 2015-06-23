(****************************
 * DPMI32: Logical Disk-I/O *
 ****************************)

unit int_2526;

interface

(* drive ..*)
function sector_size(drive:byte):longint;
function read_logical_sector (drive:byte;var   sector;sector_number:longint):longint;
function write_logical_sector(drive:byte;const sector;sector_number:longint):longint;

function getdeviceparams(      drive:byte;
                         var   cylinders,       // 0..cylinders-1
                               num_heads,       // 0..num_head-1
                               sectors:longint; // 1..sectors
                         var   floppy_type:byte):longint;

function  lock_logical_drive  (drive:byte;var   handle:longint):longint;
procedure unlock_logical_drive(drive:byte;const handle:longint);

const
  lock_error_taskmgr    =$10000000;
  lock_error_os2        =$20000000;

implementation

uses
  VpSysLow,
  Os2Base,
  Os2Def;


function sector_size(drive:byte):longint;
  begin
    sector_size:=512;
  end;

function read_logical_sector(drive:byte;var sector;sector_number:longint):longint;
  const
    para                :longint=$DEADFACE;

  var
    hand,gelesen,ulAction       :longint;
    laufwerk_zk                 :string[3];
    fehler                      :longint;
    posi                        :longint;
    zu_lesen                    :longint;
    datalen,paralen             :ULong;
    temp_sector                 :pointer;
    temp_sector_a               :array[0..2*512-1] of byte;

  begin
    laufwerk_zk:='A:'#0;
    Inc(laufwerk_zk[1],drive);

    temp_sector:=Fix_64K(@temp_sector_a,512);

    fehler:=
      DosOpen(
        Addr(laufwerk_zk[1]),
        hand,ulAction,0,0,FILE_OPEN,
        OPEN_FLAGS_DASD or OPEN_SHARE_DENYNONE or OPEN_ACCESS_READONLY
          or open_flags_Fail_On_Error,
        nil);

    if fehler<>0 then
      begin
        read_logical_sector:=fehler;
        Exit;
      end;

    zu_lesen:=512;

    if sector_number<>0 then
      begin

        fehler:=DosSetFilePtr(hand,sector_number*512,file_Begin,posi);

        if fehler=5 then
          begin (* >4 GB *)
            datalen:=0;
            paralen:=SizeOf(para);
            fehler:=DosFSCtl(nil  ,datalen,datalen,
                             @para,paralen,paralen,
                             $9014,nil,hand,fsctl_Handle);
            zu_lesen:=1;
          end;

        if fehler<>0 then
          begin
            read_logical_sector:=fehler;
            Exit;
          end;
      end;


    fehler:=
      DosRead(
        hand,
        temp_sector^,
        zu_lesen,
        gelesen);

    read_logical_sector:=fehler;
    if fehler=0 then
      Move(temp_sector^,sector,512);

    fehler:=DosClose(hand);
  end;

function write_logical_sector(drive:byte;const sector;sector_number:longint):longint;
  const
    nullbefehl                  :byte=0;
    para                        :longint=$DEADFACE;
  var
    hand,geschrieben,ulAction   :longint;
    laufwerk_zk                 :string[3];
    fehler                      :longint;
    nullbefehl_laenge           :longint;
    posi                        :longint;
    datalen,paralen             :ULong;
    zu_schreiben                :longint;
    temp_sector                 :pointer;
    temp_sector_a               :array[0..2*512-1] of byte;

  begin
    laufwerk_zk:='A:'#0;
    Inc(laufwerk_zk[1],drive);

    temp_sector:=Fix_64K(@temp_sector_a,512);
    Move(sector,temp_sector^,512);

    fehler:=DosOpen(
      addr(laufwerk_zk[1]),
      hand,
      ulAction,0,0,FILE_OPEN,
      OPEN_FLAGS_DASD or OPEN_SHARE_DENYNONE or OPEN_ACCESS_WRITEONLY
        or open_flags_Fail_On_Error,
      nil);

    if fehler<>0 then
      begin
        write_logical_sector:=fehler;
        Exit;
      end;

    nullbefehl_laenge:=SizeOf(nullbefehl);

    fehler:=DosDevIOCtl(
      hand,
      IOCTL_DISK,
      DSK_LOCKDRIVE,
      @nullbefehl,SizeOf(nullbefehl),@nullbefehl_laenge,
      nil,0,nil);

    zu_schreiben:=512;

    if fehler<>0 then
      write_logical_sector:=fehler
    else
      begin
        fehler:=
          DosSetFilePtr(hand,sector_number*512,file_Begin,posi);

        if fehler=5 then
          begin (* >4 GB *)
            datalen:=0;
            paralen:=SizeOf(para);
            fehler:=DosFSCtl(nil  ,datalen,datalen,
                             @para,paralen,paralen,
                             $9014,nil,hand,fsctl_Handle);
            zu_schreiben:=1;
          end;

        if fehler=0 then
          fehler:=
            DosWrite(
              hand,
              temp_sector^,
              zu_schreiben,
              geschrieben);

        write_logical_sector:=fehler;

        fehler:=
          DosDevIOCtl(
          hand,
          IOCTL_DISK,
          DSK_UNLOCKDRIVE,
          @nullbefehl,1,@nullbefehl_laenge,
          nil,0,nil);

      end;

    fehler:=DosClose(hand);

  end;


function getdeviceparams(      drive:byte;
                         var   cylinders,       // 0..cylinders-1
                               num_heads,       // 0..num_head-1
                               sectors:longint; // 1..sectors
                         var   floppy_type:byte):longint;
  var
    parameter:
      packed record
        b0              :byte;
        laufwerk        :byte;
      end;

    daten:
      packed record
        sector_size_in_bytes            :smallword;
        sectors_per_cluster             :byte;
        number_of_reserved_sectors      :smallword;
        number_of_FATs_on_disk          :byte;
        number_of_root_directory_entries:smallword;
        number_of_total_sectors         :smallword;
        media_descriptor_byte           :byte;
        sectors_per_FAT                 :smallword;
        sectors_per_track               :smallword;
        number_of_heads                 :smallword;
        number_of_hidden_sectors        :longint;
        number_of_total_sectors_l       :longint;
        reserved                        :array[1..6] of byte;
        anzahl_zylinder                 :smallword;
        geraetetyp                      :byte;
        geraeteattribute                :smallword;
      end;

    parameter_laenge,
    daten_laenge        :longint;

    laufwerk            :array[0..2] of char;
    infohandle          :longint;
    gueltig             :boolean;

  begin
    gueltig:=false;
    num_heads:=-1;
    sectors:=-1;

    FillChar(daten,SizeOf(daten),0);

    laufwerk:='A:'#0;
    Inc(laufwerk[0],drive);

    if SysFileOpen(
      laufwerk,
      OPEN_FLAGS_DASD or OPEN_SHARE_DENYNONE or OPEN_ACCESS_READONLY or open_flags_Fail_On_Error,
      infohandle)=0 then

      begin
        parameter.b0:=1; (* eingelegter DatentrÑger - nur mit gÅltiger Handhabe *)
        parameter.laufwerk:=0;

        parameter_laenge:=SizeOf(parameter);
        daten_laenge    :=SizeOf(daten);

        if DosDevIOCtl(
             infohandle,
             IOCTL_DISK,
             DSK_GETDEVICEPARAMS,
             @parameter,SizeOf(parameter),@parameter_laenge,
             @daten    ,SizeOf(daten    ),@daten_laenge    )=0 then
          gueltig:=true;

        SysFileClose(infohandle);
      end;

    if not gueltig then
      begin
        parameter.b0:=0; (* Laufwerksparameter *)
        parameter.laufwerk:=drive;

        parameter_laenge:=SizeOf(parameter);
        daten_laenge    :=SizeOf(daten);

        if DosDevIOCtl(
             -1,
             IOCTL_DISK,
             DSK_GETDEVICEPARAMS,
             @parameter,SizeOf(parameter),@parameter_laenge,
             @daten    ,SizeOf(daten    ),@daten_laenge    )=0 then
          gueltig:=true;
      end;

    if gueltig then
      begin
        cylinders:=daten.anzahl_zylinder;
        num_heads:=daten.number_of_heads;
        sectors:=daten.sectors_per_track;
        floppy_type:=daten.geraetetyp;
        getdeviceparams:=0;
      end
    else
      begin
        cylinders:=-1;
        floppy_type:=255;
        getdeviceparams:=-1;
      end;
  end;

function  lock_logical_drive  (drive:byte;var   handle:longint):longint;
  begin
    lock_logical_drive:=0;
  end;

procedure unlock_logical_drive(drive:byte;const handle:longint);
  begin
  end;

end.

