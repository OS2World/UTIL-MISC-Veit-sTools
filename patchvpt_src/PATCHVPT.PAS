program patch_vpt;

(* V.K. 10.08.1997 *)
(*      22.11.1997 /I Parameter *)
(*      31.12.1997 Sprache *)
(*      11.03.1998 spra_aus neu *)

uses vpt,patchspr;

var
  zaehler:word;
  fehler:boolean;
  blink:(blink_unveraendert,blink_hell,blink_blinken);
  taktgenerator:(clock_unveraendert,clock_00,clock_01,clock_10,clock_11);
  para:string;
  hilfe:boolean;
  einzel_index:byte;
  kontrolle:integer;
  index_menge:set of byte;

begin
  fehler:=false;
  hilfe:=false;
  blink:=blink_unveraendert;
  taktgenerator:=clock_unveraendert;
  index_menge:=[];

  for zaehler:=1 to paramcount do
    begin
      para:=paramstr(zaehler)+'   ';
      if copy(para,1,1)='/' then delete(para,1,1);
      if copy(para,1,1)='-' then delete(para,1,1);

      if copy(para,2,1)=':' then delete(para,2,1);
      if copy(para,2,1)='=' then delete(para,2,1);

      case upcase(para[1]) of
        'B':
          case para[2] of
            ' ':blink:=blink_hell;
            '0':blink:=blink_hell;
            '1':blink:=blink_blinken;
          else
            fehler:=true;
          end;
        'C':
          case para[2] of
            ' ':taktgenerator:=clock_11;
            '0':taktgenerator:=clock_00;
            '1':taktgenerator:=clock_01;
            '2':taktgenerator:=clock_10;
            '3':taktgenerator:=clock_11;
          else
            fehler:=true;
          end;
        'I':
          begin
            val(copy(para,2,pos(' ',para)-2),einzel_index,kontrolle);
            if kontrolle<>0 then
              hilfe:=true
            else
              index_menge:=index_menge+[einzel_index];
          end;
        '?':hilfe:=true;
      else
        fehler:=true;
      end;
    end;

  if (paramcount=0) or hilfe or fehler then
    begin
      if fehler then
        writeln(textz_Parameterfehler_^);

      writeln(textz_Benutzung_PATCHVPT_EXE^);
      writeln;
      writeln(' /B ..... '+textz_Blinken_oder_Intenstitaet^);
      writeln('          0='+textz_Intensive_Hintergrundfarben^);
      writeln('          1='+textz_Blinken^);
      writeln;
      writeln(' /C ..... '+textz_Frequenz_des_Bildschirmsignals^);
      writeln('          0=25 MHz     1=28 MHz     2=?? MHz     3=?? MHz');
      writeln;
      writeln(' /I ..... '+textz_Tabellenindex^);
      writeln('          /I:24 = '+textz_nur_fuer_VGA_Textmodus_80_25^);
      writeln('          /I:28 = '+textz_nur_fuer_VGA_320_200_256^);
      writeln;
      writeln(' ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ');
      writeln(textz_gemessene_Ergebnisse_im_Textmodus^+' 80*25,16 (720*400)');
      writeln('                        /C:0   ³  /C:1    ³  /C:2    ³  /C:3');
      writeln(' ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ');
      writeln(' ET4000       (Veit)   62,0 Hz ³  69,5 Hz ³  88,5 Hz ³  98,0 Hz');
      writeln(' Trio32/S3    (Ehm)    61,5 Hz ³  69,0 Hz ³  61,5 Hz ³  69,0 Hz');
      writeln(' Spea Mercury (Jost)    ?,? Hz ³  69,0 Hz ³ 123,0 Hz ³ 123,0 Hz');
      halt;

    end;

  if not vpt_beschreibbar then
    begin
      writeln('"Video Parameter Table" '+textz_ist_nicht_beschreibbar_^);
      write  (textz_Damit_AEnderungen_wirksam_werden_sollte_VPT_RAM_COM_geladen_werden_^);
      halt;
    end;

  if index_menge=[] then
    index_menge:=[0..255];

  for zaehler:=0 to 255 do
    if gueltig(zaehler) and (zaehler in index_menge) then
      with mem_0040_00a8^^[zaehler] do
        begin

          case blink of
            blink_hell   :attribute_controller[$10]:=attribute_controller[$10] and ($ff-1 shl 3);
            blink_blinken:attribute_controller[$10]:=attribute_controller[$10] or  (    1 shl 3);
          end;

          case taktgenerator of
            clock_00:misc_output:=(misc_output and ($ff-3 shl 2)) or (0 shl 2);
            clock_01:misc_output:=(misc_output and ($ff-3 shl 2)) or (1 shl 2);
            clock_10:misc_output:=(misc_output and ($ff-3 shl 2)) or (2 shl 2);
            clock_11:misc_output:=(misc_output and ($ff-3 shl 2)) or (3 shl 2);
          end;

        end;

  asm
    push ds
      mov ax,$0040
      mov ds,ax
      mov al,[$0049]
      ; mov ah,0
      int $10
    pop ds
  end;
end.
