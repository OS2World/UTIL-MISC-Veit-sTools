unit vpt;

interface

type
  video_parameter_table_eintrag_typ=
    record
      case integer of
        1:(
          zeichen_spalten:byte;
          zeichen_zeilen:byte;
          zeichenhoehe:byte;
          groesse_des_bildschirmspeichers:word;
          sequenzer:array[1..4] of byte;
          misc_output:byte;
          crtc:array[0..$18] of byte;
          attribute_controller:array[0..$13] of byte;
          graphics_controller:array[0..8] of byte);
        2:
          (f:array[0..63] of byte;)
    end;

  video_parameter_table_typ=array[0..255] of video_parameter_table_eintrag_typ;
  video_parameter_table_zeiger_typ=^video_parameter_table_typ;

var
  mem_0040_00a8:^video_parameter_table_zeiger_typ absolute $0040:$00a8;

function gueltig(index:word):boolean;
function vpt_beschreibbar:boolean;

implementation

function gueltig(index:word):boolean;
  begin
    gueltig:=((mem_0040_00a8^^[index].zeichen_spalten  in [40,80,100,128,132]) and
              (mem_0040_00a8^^[index].zeichen_zeilen+1 in [25,28,30,37,43,44,48,50,60,80]))
	   or (index<=$1c) (* 320*200*256 *)

  end;

function vpt_beschreibbar:boolean;
  var
    sicherung:byte;
  begin
    asm
      cli
    end;

    sicherung:=mem_0040_00a8^^[7].zeichen_spalten;
    mem_0040_00a8^^[7].zeichen_spalten:=255;
    vpt_beschreibbar:=mem_0040_00a8^^[7].zeichen_spalten=255;
    mem_0040_00a8^^[7].zeichen_spalten:=sicherung;

    asm
      sti
    end;
  end;


begin


end.