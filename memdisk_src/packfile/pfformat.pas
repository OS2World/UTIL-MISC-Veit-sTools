unit pfformat;

interface

type
  blocktypes            =(bt_header,bt_nextpack,bt_file,bt_output,bt_sector,bt_volume,bt_delete,bt_requestdisk);
  file83                =
    packed record
      fname             :array[0..7] of char;
      ext               :array[0..2] of char;
    end;

  aplib_header          =
    packed record
      tag               :array[0..3] of char;
      header_size       :longint;
      packed_size       :longint;
      packed_crc        :longint;
      orig_size         :longint;
      orig_crc          :longint;
    end;


const
  version_string        ='archivefile/2002-02-02/aPLib036'^Z^@;

  maxfileblock          =64*512;
                        (* Clustersize must be 512/1024/2048/4096/../32KB *)

var
  unknown_block         :
    packed record
      bl                :longint;
      bt                :blocktypes;
    end;

  header_block          :
    packed record
      bl                :longint;
      bt                :blocktypes;
      version           :string[Length(version_string)];
    end;

  nextpack_block        :
    packed record
      bl                :longint;
      bt                :blocktypes;
      next_file         :file83;
    end;

  file_block            :
    packed record
      bl                :longint;
      bt                :blocktypes;
      filename          :file83;
      sizepacked        :longint;
      sizeunpacked      :longint;
      date_time         :longint;
      attr              :byte;
    end;

  output_block          :
    packed record
      bl                :longint;
      bt                :blocktypes;
      messagetext       :array[0..256] of char;
    end;

  sector_block          :
    packed record
      bl                :longint;
      bt                :blocktypes;
      sector            :array[0..511] of byte;
    end;

  volume_block          :
    packed record
      bl                :longint;
      bt                :blocktypes;
      volumelabel       :file83;
    end;

  delete_block          :
    packed record
      bl                :longint;
      bt                :blocktypes;
      delete_file       :file83;
    end;

  requestdisk_block     :
    packed record
      bl                :longint;
      bt                :blocktypes;
      disklabel         :file83;
    end;



implementation

end.

