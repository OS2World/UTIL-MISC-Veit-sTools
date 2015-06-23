{$M 16384,0,0}
program vpt_list;
(* V.K. 07.08.1997 *)

(* 11.03.1998 crt neu *)

uses crt,dos,vpt;

const
  anzeige_zeilen_vpt=24;
  anzeige_zeilen_eintrag=22;

  hexziffern:array[0..$f] of char='0123456789abcdef';
  enter=^m^j;

  sequenzerhilfe:array[1..4] of string=
    ('H1',
     'H2',
     'H3',
     'H4');

  attri_hilfe:array[0..$13] of string= (* 3C0 *)
    ('EGA-Farbe [0..63] fÅr Schwarz',
     'EGA-Farbe [0..63] fÅr Blau',
     'EGA-Farbe [0..63] fÅr GrÅn',
     'EGA-Farbe [0..63] fÅr Zyan',
     'EGA-Farbe [0..63] fÅr Rot',
     'EGA-Farbe [0..63] fÅr Magenta-Rot',
     'EGA-Farbe [0..63] fÅr Braun',
     'EGA-Farbe [0..63] fÅr Grau',
     'EGA-Farbe [0..63] fÅr Wei·',
     'EGA-Farbe [0..63] fÅr leuchtendes Blau',
     'EGA-Farbe [0..63] fÅr leuchtendes GrÅn',
     'EGA-Farbe [0..63] fÅr leuchtendes Zyan',
     'EGA-Farbe [0..63] fÅr leuchtendes Rot',
     'EGA-Farbe [0..63] fÅr Rosa',
     'EGA-Farbe [0..63] fÅr Gelb',
     'EGA-Farbe [0..63] fÅr leuchtendes Wei·',
     'MODE-Control Register: Bit0=(0:Text,1:Grafik) Bit1=(0:Farbe,1:Mono)'+enter+
      'Bit2=(0:8 Punkte,1:9 Punkte breite Zeichen) Bit3(0:heller,1=Blinken)'+enter+
      'Bit5=? Bit6=(1:256 Farben) Bit7=Palette',
     'EGA-Farbe [0..63] des Bildschirmrandes',
     'Bit01234=Speicherebenen 0..3',
     'Bit 0123=Horizontal PEL Panning');

  gra_hilfe:array[0..8] of string=  (* 3CE *)
    ('Set/Reset Register',
     'Enable Set/Reset Register',
     'Color Compare Register',
     'Data Rotate',
     'Read Map Select Register',
     'Mode Register',
     'Miscellaneous Register: Bit0:(0=Text,1=Grafik) Bit1:(Enables Odd/Even mode)'+enter+
      'Bit23=(0=A000-BFFF,1=A000-AFFF,2=B000-B7FF,3=B800-BFFF)',
     'Color Don''t Care Register: Bit0123:Ignore bit plane X in Read mode 1 if clear',
     'Bit Mask Register: Bit01234567 (1: Schreiben auf Speicher X)');




type

  datentyp=(typ_byte,typ_word);
  anzeigetyp=(anzeige_dez,anzeige_hex);

  edit_tabelle_eintrag=
    record
      name:string;
      daten:datentyp;
      anzeige:anzeigetyp;
      position:word;
      hilfe:string;
    end;

  vpt_info_tabelle_eintrag=
    record
      vpt_index:word;
      titel:string[79];
    end;

  word_z=^word;

var
  zaehler:word;
  index:word;
  taste:char;

  edit_tabelle:array[1..63] of edit_tabelle_eintrag;
  edit_tabelle_pos:integer;
  edit_tabelle_zeile0:integer;

  vpt_info_tabelle:array[1..256] of vpt_info_tabelle_eintrag;
  vpt_arbeitsindex:integer;
  vpt_info_tabelle_zeile0:integer;
  vpt_info_tabelle_max:integer;
  tmpzk:string[79];

  dateiname:string;
  datei:file;

function hole_taste:char;assembler;
  asm
    mov ah,8
    int $21
  end;

function strf(w:word;z:byte):string;
  var
    tmp:string;
  begin
    str(w:z,tmp);
    strf:=tmp;
  end;

function hexb(b:byte):string;
  begin
    hexb:='$'+hexziffern[b shr 4]+hexziffern[b and $f];
  end;

function hexw(w:word):string;
  begin
    hexw:='$'+hexziffern[(w shr 12) and $f]
             +hexziffern[(w shr  8) and $f]
             +hexziffern[(w shr  4) and $f]
             +hexziffern[(w shr  0) and $f];
  end;

procedure pause;
  begin
  end;

procedure eintrag(name:string;daten:datentyp;anzeige:anzeigetyp;position:word;hilfe:string);
  begin
    inc(edit_tabelle_pos);
    edit_tabelle[edit_tabelle_pos].name         :=name;
    edit_tabelle[edit_tabelle_pos].daten        :=daten;
    edit_tabelle[edit_tabelle_pos].anzeige      :=anzeige;
    edit_tabelle[edit_tabelle_pos].position     :=position;
    edit_tabelle[edit_tabelle_pos].hilfe        :=hilfe;
  end;

procedure tabellenanzeige;
  var
    z:word;
  begin
    for z:=0 to anzeige_zeilen_eintrag-1 do
      begin
        gotoxy(1,z+1);

        if edit_tabelle_zeile0+z=edit_tabelle_pos then
          textattr:=$1e
        else
          textattr:=$2f;

        if edit_tabelle_zeile0+z<=high(edit_tabelle) then
          begin
            write('        ');
            write(edit_tabelle[edit_tabelle_zeile0+z].name);
            while wherex<60 do write(' ');

            case edit_tabelle[edit_tabelle_zeile0+z].daten of
              typ_byte:
                case edit_tabelle[edit_tabelle_zeile0+z].anzeige of
                  anzeige_dez:write(mem_0040_00a8^^[vpt_info_tabelle[vpt_arbeitsindex].vpt_index].
                    f[edit_tabelle[edit_tabelle_zeile0+z].position]);
                  anzeige_hex:write(hexb(mem_0040_00a8^^[vpt_info_tabelle[vpt_arbeitsindex].vpt_index].
                    f[edit_tabelle[edit_tabelle_zeile0+z].position]));
                end;
              typ_word:
                case edit_tabelle[edit_tabelle_zeile0+z].anzeige of
                  anzeige_dez:write(word_z(@mem_0040_00a8^^[vpt_info_tabelle[vpt_arbeitsindex].vpt_index].
                    f[edit_tabelle[edit_tabelle_zeile0+z].position])^);
                  anzeige_dez:write(hexw(word_z(@mem_0040_00a8^^[vpt_info_tabelle[vpt_arbeitsindex].vpt_index].
                    f[edit_tabelle[edit_tabelle_zeile0+z].position])^));
                end;
            end;
          end;

        clreol;

        textattr:=$0f;
      end;

    textattr:=$70;
    gotoxy(1,23);clreol;
    gotoxy(1,24);clreol;
    gotoxy(1,25);clreol;
    gotoxy(1,23);write(edit_tabelle[edit_tabelle_pos].hilfe);

  end;

procedure editor;
  begin
    textattr:=$0f;
    clrscr;
    edit_tabelle_zeile0:=1;
    edit_tabelle_pos:=1;
    repeat
      if edit_tabelle_pos<low (edit_tabelle) then
        edit_tabelle_pos:=low (edit_tabelle);

      if edit_tabelle_pos>high(edit_tabelle) then
        edit_tabelle_pos:=high(edit_tabelle);

      if edit_tabelle_pos<edit_tabelle_zeile0 then
        edit_tabelle_zeile0:=edit_tabelle_pos;

      if edit_tabelle_pos>=edit_tabelle_zeile0+anzeige_zeilen_eintrag then
        edit_tabelle_zeile0:=edit_tabelle_pos-anzeige_zeilen_eintrag+1;

      tabellenanzeige;
      case hole_taste of
        #0:
          case hole_taste of
            #$48:dec(edit_tabelle_pos);
            #$50:inc(edit_tabelle_pos);
            #$49:dec(edit_tabelle_pos,10);
            #$51:inc(edit_tabelle_pos,10);
            #$47:edit_tabelle_pos:=low (edit_tabelle);
            #$4f:edit_tabelle_pos:=high(edit_tabelle);
          end;
        #13:
          begin
            gotoxy(70,edit_tabelle_pos-edit_tabelle_zeile0+1);
            textattr:=$4f;
            write(' '^h);

            case edit_tabelle[edit_tabelle_pos].daten of
              typ_byte:
                readln(mem_0040_00a8^^[vpt_info_tabelle[vpt_arbeitsindex].vpt_index].
                    f[edit_tabelle[edit_tabelle_pos].position]);
              typ_word:
                readln(word_z(@mem_0040_00a8^^[vpt_info_tabelle[vpt_arbeitsindex].vpt_index].
                    f[edit_tabelle[edit_tabelle_pos].position])^);
            end;
          end;
        #27:exit;
      end;
    until false;
  end;

(*************************************************************************)

procedure anzeige_vpt_info_tabelle;
  var
    zaehler:word;
  begin
    for zaehler:=1-1 to anzeige_zeilen_vpt-1 do
      begin
        gotoxy(1,zaehler+1);

        if zaehler+vpt_info_tabelle_zeile0=vpt_arbeitsindex then
          textattr:=$1e
        else
          textattr:=$2f;

        if zaehler<=vpt_info_tabelle_max then
          write(vpt_info_tabelle[zaehler+vpt_info_tabelle_zeile0].titel);
        clreol;
      end;
    gotoxy(1,anzeige_zeilen_vpt+1);
    textattr:=$70;
    write(' ['^x']['^y']=AuswÑhlen ['^q'ƒŸ]=Editieren [L]=Laden [S]=Speichern [Esc]=Ende');
    clreol;
  end;




(*************************************************************************)

begin
  asm
    mov ax,$0003
    int $10
  end;

  if not vpt_beschreibbar then
    begin
      writeln('"Video Parameter Table" ist nicht beschreibbar.');
      write  ('Damit énderungen wirksam werden, sollte VPT_RAM.COM geladen werden.');
      taste:=hole_taste;
    end;

  vpt_info_tabelle_max:=0;
  vpt_arbeitsindex:=0;

  for zaehler:=0 to 255 do
    with mem_0040_00a8^^[zaehler] do
      if gueltig(zaehler) then
        begin
          inc(vpt_info_tabelle_max);
          vpt_info_tabelle[vpt_info_tabelle_max].vpt_index:=zaehler;
          tmpzk:=
            '≥'+
            strf(zaehler,3)+' ≥'+
            strf(zeichen_spalten,4)+#15+strf(zeichen_zeilen+1,3)+' ≥'+
            strf(zeichen_spalten*(9-((attribute_controller[$10] and 1) or (crtc[9] shr 7))),4)+#15+
            strf((zeichen_zeilen+1)*zeichenhoehe,4)+' ≥'+
            strf(zeichenhoehe,3)+
            ' ∫  ';

            case zaehler of
              0:tmpzk:=tmpzk+'00/00  CGA ....... 40* 25*  2 [200 Zeilen]';
              1:tmpzk:=tmpzk+'01/01  CGA ....... 40* 25* 16 [200 Zeilen]';
              2:tmpzk:=tmpzk+'02/02  CGA ....... 80* 25* 16 [200 Zeilen]';
              3:tmpzk:=tmpzk+'03/03  CGA ....... 80* 25* 16 [200 Zeilen]';

              4:tmpzk:=tmpzk+'04/04  CGA ...... 320*200*  4';
              5:tmpzk:=tmpzk+'05/05  CGA ...... 320*200*  4';
              6:tmpzk:=tmpzk+'06/06  CGA ...... 640*200*  2';
              7:tmpzk:=tmpzk+'07/07  Mono .....  80* 25';
              8:tmpzk:=tmpzk+'08/08             160*200* 16';
              9:tmpzk:=tmpzk+'09/09             320*200* 16';
            $0a:tmpzk:=tmpzk+'10/0A             640*200*  4';
            $0b:tmpzk:=tmpzk+'11/0B  ----------------------';
            $0c:tmpzk:=tmpzk+'12/0C  ----------------------';
            $0d:tmpzk:=tmpzk+'13/0D  EGA ...... 320*200* 16';
            $0e:tmpzk:=tmpzk+'14/0E  EGA ...... 640*200* 16';

            $0f:tmpzk:=tmpzk+'15/0F  EGA 64K .. 640*350*  2';
            $10:tmpzk:=tmpzk+'16/10  EGA 64K .. 640*350*  4';

            $11:tmpzk:=tmpzk+'15/0F  EGA 128K . 640*350*  2';
            $12:tmpzk:=tmpzk+'16/10  EGA 128K . 640*350* 16';

            $13:tmpzk:=tmpzk+'00/00  EGA ......  40* 25*  2 [350 Zeilen]';
            $14:tmpzk:=tmpzk+'01/01  EGA ......  40* 25* 16 [350 Zeilen]';
            $15:tmpzk:=tmpzk+'02/02  EGA ......  80* 25* 16 [350 Zeilen]';
            $16:tmpzk:=tmpzk+'03/03  EGA ......  80* 25* 16 [350 Zeilen]';

            $17:tmpzk:=tmpzk+'00/00* VGA ......  40* 25*  ? [400 Zeilen]'; (* *=00 oder 01 *)
            $18:
              begin
                tmpzk:=tmpzk+'02/02* VGA ......  80* 25* 16 [400 Zeilen]'; (* *=02 oder 03 *)
                vpt_arbeitsindex:=vpt_info_tabelle_max;
              end;

            $19:tmpzk:=tmpzk+'07/07  VGA ......  80* 25*  ? [400 Zeilen]';

            $1a:tmpzk:=tmpzk+'17/11  VGA ...... 640*480*  2';
            $1b:tmpzk:=tmpzk+'18/12  VGA ...... 640*480* 16';
            $1c:tmpzk:=tmpzk+'19/13  VGA ...... 320*200*256';
            end;

          vpt_info_tabelle[vpt_info_tabelle_max].titel:=tmpzk;
        end;

  edit_tabelle_pos:=0;
  with mem_0040_00a8^^[0] do
    begin
      index:=0;
      eintrag('Spalten'                      ,typ_byte,anzeige_dez,index,'gemessen in Textzeichen');inc(index);
      eintrag('Zeilen-1'                     ,typ_byte,anzeige_dez,index,'gemessen in Textzeichen');inc(index);
      eintrag('Zeichenhîhe'                  ,typ_byte,anzeige_dez,index,'');inc(index);
      eintrag('Grî·e des Bildschirmspeichers',typ_word,anzeige_dez,index,
        'Textmodus: Zeilen*Spalten*(2 Byte je Zeichen)*Bildschirmseiten'+enter+'40*25*2=2000˜2048');inc(index,2);

      for zaehler:=low(sequenzer) to high(sequenzer) do
        begin
          eintrag('Sequenzer Register ['+hexb(zaehler)+']',typ_byte,anzeige_hex,index,sequenzerhilfe[zaehler]);
          inc(index);
        end;

      eintrag('Miscellaneous Output Register',typ_byte,anzeige_hex,index,
        'Bit0=(0:Mono(3bx),1:Farbe(3dx)    Bit1=CPU-Zugriff auf Speicher'+
        'Bit23=(00:25Mhz,01:28Mhz,10:??Mhz,11=??Mhz) Bit xxxxxxxxxxxxxxxxxxx'
        );
      inc(index);

      for zaehler:=low(crtc) to high(crtc) do
        begin
          eintrag('CRTC Register ['+hexb(zaehler)+']',typ_byte,anzeige_hex,index,'CRTC=xxxxxxxxxxxxxxxx');
          inc(index);
        end;

      for zaehler:=low(attribute_controller) to high(attribute_controller) do
        begin
          if zaehler<=15 then
            eintrag('Attribute Controller ['+hexb(zaehler)+']',typ_byte,anzeige_dez,index,attri_hilfe[zaehler])
          else
            eintrag('Attribute Controller ['+hexb(zaehler)+']',typ_byte,anzeige_hex,index,attri_hilfe[zaehler]);
          inc(index);
        end;

      for zaehler:=low(graphics_controller) to high(graphics_controller) do
        begin
          eintrag('Graphics Controller ['+hexb(zaehler)+']',typ_byte,anzeige_hex,index,gra_hilfe[zaehler]);
          inc(index);
        end;
    end;



    (*******************************************************************)
    vpt_info_tabelle_zeile0:=1;

    repeat
      if vpt_arbeitsindex<1 then
        vpt_arbeitsindex:=1;

      if vpt_arbeitsindex>vpt_info_tabelle_max then
        vpt_arbeitsindex:=vpt_info_tabelle_max;

      if vpt_arbeitsindex<vpt_info_tabelle_zeile0 then
        vpt_info_tabelle_zeile0:=vpt_arbeitsindex;

      if vpt_arbeitsindex>=vpt_info_tabelle_zeile0+anzeige_zeilen_vpt then
        vpt_info_tabelle_zeile0:=vpt_arbeitsindex-anzeige_zeilen_vpt+1;


      anzeige_vpt_info_tabelle;

      case hole_taste of
        #0:
          case hole_taste of
            #$48:dec(vpt_arbeitsindex);
            #$50:inc(vpt_arbeitsindex);
            #$49:dec(vpt_arbeitsindex,10);
            #$51:inc(vpt_arbeitsindex,10);
            #$47:vpt_arbeitsindex:=0;
            #$4f:vpt_arbeitsindex:=vpt_info_tabelle_max;
          end;
        #13:editor;
        #27:
          begin
            textmode(lastmode);
            exit;
          end;
        'l','L':
          begin
            write(^m'Dateiname ? ');
            clreol;
            readln(dateiname);
            assign(datei,dateiname);
            reset(datei,1);
            blockread(datei,mem_0040_00a8^^,filesize(datei));
            close(datei);
          end;
        's','S':
          begin
            write(^m'Dateiname ? ');
            clreol;
            readln(dateiname);
            assign(datei,dateiname);
            rewrite(datei,1);
            blockwrite(datei,mem_0040_00a8^^,64*vpt_info_tabelle_max);
            close(datei);
          end;
      end;
    until false;
end.
