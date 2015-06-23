unit dcp_form;

interface

  (* VIOTBL.DCP format, changed to IBM names,
   see \ddk\video\rel\os2c\include\base\os2\inc\fontfile.inc *)

type

  fontfilehdr           =
    packed record                       (* CodePage File header         *)
      ffh_length        :smallword;     (* Length of Header             *)
      ffh_flags         :smallword;     (* CodePage File flags          *)
      ffh_ptroffset     :smallword;     (* Offset of first font pointer *)
      ffh_numfonts      :smallword;     (* Number of fonts in the file  *)
    end;

  fonthdr               =
    packed record                       (* CodePage Font header         *)
      fh_length         :smallword;     (* Length of Font Entry         *)
      fh_hdrlen         :smallword;     (* Length of Header (24)        *)
      fh_cpid           :smallword;     (* CodePage File flags          *)
      fh_type           :smallword;     (* Font Type (0)                *)
      fh_flags          :smallword;     (* Font Flags (0)               *)
      fh_cellcols       :byte;          (* Columns in character cell    *)
      fh_cellrows       :byte;          (* Rows in character cell       *)
      fh_basecols       :byte;          (* Columns in base cell (0)     *)
      fh_baserows       :byte;          (* Rows in base cell (0)        *)
      fh_dataoffset     :smallword;     (* Font data offset from header (24) *)
      fh_datalen        :smallword;     (* Length of the font data      *)
      fh_numpoints      :smallword;     (* Number of code points (256)  *)
      fh_lowpoint       :smallword;     (* Lowest code point (0)        *)
      fh_highpoint      :smallword;     (* Highest code point (255)     *)
    end;

const
  FULL                  =0;
  PARTIAL               =1;
  CODEPTS               =2;

implementation

end.
