{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 16384,10000,10000}

program vesamax;
(* V.K. 14.03.1996 *)
(*      11.03.1998 sprache *)

(*$IFDEF DPMI*)
*bitte Real Mode*
(*$ENDIF*)

uses vesm_spr;

const
  bit4=1 shl 4;

type
  modi_tab_typ=array[0..1000] of word;

  modi_info_typ=
    record
      m_attribute:word;
      x1:array[$02..$11] of byte;
      breite:word;
      hoehe:word;
      font_breite:byte;
      font_hoehe:byte;
      ebenen:byte;
      bits_je_punkt:byte;
      x2:array[$1a..$ff] of byte;
    end;

  vesa_info_typ=
    record
      id:array[1..4] of char;
      vers:word;
      oem:longint;
      capa:longint;
      sup_modi:^modi_tab_typ;
      rest:array[$12..$400] of byte; (* mit Sicherheit *)
    end;

var
  fehler,zaehler:word;
  zahl:word;
  max_zeilenzahl,max_farbtiefe:word;
  vesa_puffer:vesa_info_typ;
  zwischen_tabelle:modi_tab_typ;
  mode_info:modi_info_typ;

function hexw(w:word):string;
  const
    hz:array[0..15] of char='0123456789ABCDEF';
  begin
    hexw:=hz[(w and $f000) shr 12]+
          hz[(w and $0f00) shr  8]+
          hz[(w and $00f0) shr  4]+
          hz[(w and $000f) shr  0];
  end;

function pruefe_modus(m:word):boolean;
  var
    x,y:word;
  begin
    fillchar(mode_info,sizeof(mode_info),$fe);
    asm
      mov bx,seg   (mode_info)
      mov di,offset(mode_info)
      mov ax,$4f01
      mov cx,m
      mov es,bx
      int $10
    end;
    write(' ³   ',hexw(m),'  ³ ');
    if (mode_info.m_attribute and bit4)=bit4 then
      begin
        write(textz_Grafik_^);
        x:=mode_info.breite;
        y:=mode_info.hoehe;
      end
    else
      begin
        write(textz_Text_^,mode_info.breite:3,' * ',mode_info.hoehe:3);
        x:=mode_info.breite*mode_info.font_breite;
        y:=mode_info.hoehe*mode_info.font_hoehe;
      end;

    write(' ³ ',x:4,' *',y:4,'  ³ ',mode_info.bits_je_punkt:2,textz_Bit_strich^);

    if (mode_info.bits_je_punkt>max_farbtiefe) or (y>max_zeilenzahl) then
      begin
        writeln(textz_entfernt_strich^);
        pruefe_modus:=true;
      end
    else
      begin
        writeln(textz_bleibt_strich^);
        pruefe_modus:=false;
      end;
    (* Test: pruefe_modus:=true; *)
  end;

begin
  writeln(' VESA-MAX * Veit Kannegieser * 14.03.1996úú11.03.1998');
  fehler:=0;
  zaehler:=1;

  max_zeilenzahl:=10000;
  max_farbtiefe :=10000;


  (* Auswertung der Parameter *)
  if paramcount=0 then fehler:=1;

  while (zaehler<=paramcount) and (fehler=0) do
    begin
      val(paramstr(zaehler),zahl,fehler);
      if fehler<>0 then
        break;

      case zahl of
       8,15,16,24:
         max_farbtiefe:=zahl;
       480,600,768,1024:
         max_zeilenzahl:=zahl;
      else
        inc(fehler);
      end;
      inc(zaehler);
    end;


  (* Hilfe n”tig ? *)
  if fehler>0 then
    begin
      writeln(textz_beschreibung_1^);
      writeln(textz_beschreibung_2^);
      writeln;
      writeln('                    '+textz_Benutzung_^);
      writeln('  VESAMAX.EXE '+textz_groesste_Zeilenzahl__groesste_Farbtiefe^);
      writeln('               ÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄ  ÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ');
      writeln('                            ³          ³');
      writeln('       720 *  480 '#17'ÄÄ 480 ÄÄ´          ÃÄ  8 Ä'#16' 256 ',textz_Farben^);
      writeln('       800 *  600 '#17'ÄÄ 600 ÄÄ´          ÃÄ 15 Ä'#16' 32K ',textz_Farben^);
      writeln('      1024 *  768 '#17'Ä  768 ÄÄ´          ÃÄ 16 Ä'#16' 64K ',textz_Farben^);
      writeln('      1280 * 1024 '#17'Ä 1024 ÄÄÙ          ÀÄ 24 Ä'#16' 16M ',textz_Farben^);
      writeln;
      halt(1);
    end;

  fillchar(vesa_puffer,sizeof(vesa_puffer),'V');

  (* Installationstest *)
  asm
    mov ax,$4f00
    mov bx,seg   (vesa_puffer)
    mov di,offset(vesa_puffer)
    mov es,bx
    int $10
  end;

  with vesa_puffer do
    begin
      if id<>'VESA' then
        begin
          writeln(textz_kein_VESA_Treiber_installiert^);
          halt(2);
        end;

      if vers<$102 then
        begin
          writeln(textz_fuer_meine_Zwecke_benoetige_ich_einen_VESA_Treiber_Version_1_02^);
          writeln(textz_Schreiben_sie_an_den_Autor^);
          halt(3);
        end;

      zaehler:=0;

      writeln(      ' ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿');
      while sup_modi^[zaehler]<>$ffff do
        begin
          if (zaehler mod 20)=0 then
            writeln(textz_tabellenkopf^);

          if not pruefe_modus(sup_modi^[zaehler]) then
            (* best„tigt *)
            zwischen_tabelle[zaehler]:=sup_modi^[zaehler]
          else
            (* nur Ersatz *)
            zwischen_tabelle[zaehler]:=$0100;

          inc(zaehler);
        end;

      writeln(      ' ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÙ');

      (* Abschluá mit $ffff *)
      zwischen_tabelle[zaehler]:=$ffff;
      inc(zaehler);

      (* ROM-Test *)
      sup_modi^[0]:=$1234;
      if sup_modi^[0]<>$1234 then
        begin
          writeln(textz_Problem_ROM^);
          writeln(textz_tip_rom_problem^);
        end
      else
        begin
          (* Ergebnis zurckschreiben *)

          move(zwischen_tabelle,sup_modi^,sizeof(word)*zaehler);
        end;
    end;

end.
