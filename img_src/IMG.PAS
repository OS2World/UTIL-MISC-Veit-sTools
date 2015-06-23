(*$I IMG_COMP*)


(* test "Erweitert" (trans4)
   100 Versuche dann ignorieren *)

(*$IFDEF OS2*)
(*$M 64000*) (* HD-COPY hat 24000+ Blitzcopy noch mehr *)
(*$ELSE*)
(*$M 64000,0,0*)
(*$ENDIF*)

(*..02.06.1997*)
(* 11.03.1998 crt,spra_aus neu, copy-qm registriert mit Text *)

program img;

(*$D IMG * Disketten(abzugs)kopierprogramm * Veit Kannegieser *)

uses img_spra,zugriff,crt,popup,strnull;


procedure hilfe;
  begin
    writeln;
    writeln('  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
    writeln('  ³                                                                          ³');
    writeln('  ³  '+textz_Benutzung_IMG_Quelle_Ziel_^+'                                   ³');
    writeln('  ³                                                                          ³');
    writeln('  ³    1.: IMG A: B:                       '+textz_hilfe_img_1^+'   ³');
    writeln('  ³    2.: IMG A: I:\test\test.img         '+textz_hilfe_img_2^+'   ³');
    writeln('  ³    3.: IMG I:\test\test.img A:         '+textz_hilfe_img_3^+'   ³');
    writeln('  ³    4.: IMG R:\disk1.img I:\test\test   '+textz_hilfe_img_4^+'   ³');
    writeln('  ³                                                                          ³');
    writeln('  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
    halt(0);
  end;

type
  str_z=^string;
label
  bestimme_quelle,fertig_kopiert;

const
  logischer_anfang:longint=0;

var
  parameter:string;
  zaehler:longint;

  (*$IFDEF OS2*)
  puffer:array[0..360*1024-1] of byte;
  (*$ELSE*)
  puffer:array[0..18*2*512-1] of byte;
  (*$ENDIF*)
  puffer_signatur_exe:
    record
      sig:array[0..1] of char;
      im_mod_512:word;
      im_div_512:word;
    end absolute puffer;

  puffer_signatur_loaddskf:
    record
      sig:word;
      x:array[2..$25] of byte;
      kopflaenge:word;
    end absolute puffer;

  gelesen:lesegroesse;
  blockgroesse:longint;

  dxp_position:longint;
  kommentar:string;
  w1:word;
(**************************************************************************)

(*$I ROH.PAS     *)
(*$I HD_COPY.PAS *)
(*$I DSK_FACT.PAS*)
(*$I CISCOPY.PAS *)
(*$I COPYQM.PAS  *)
(*$I DIM.PAS     *)
(*$I DISKDUPE.PAS*)
(*$I EMTCOPY.PAS *)
(*$I SCOPY.PAS   *)
(*$I DISKLONE.PAS*)
(*$I BLITZCPY.PAS*)

(**************************************************************************)


begin
  strich;
  writeln('IMG * V.K. * 28.05.1997úú17.01.1998 * '+textz_Kopieren_von_Laufwerken_Dateien^);

  parameter:='';
  for zaehler:=1 to paramcount do
    parameter:=parameter+paramstr(zaehler)+' ';


  if (parameter='') or (pos('?',parameter)>0) then
    hilfe;

  for zaehler:=1 to 2 do
    if parameter[1]='"' then
      begin
        para[zaehler]:=copy(parameter,2,pos('"',copy(parameter,2,255))-1);
        delete(parameter,1,1+length(para[zaehler])+1);
      end
    else
      begin
        para[zaehler]:=copy(parameter,1,pos(' ',parameter)-1);
        delete(parameter,1,length(para[zaehler])+1);
      end;

  if (parameter<>'') and (parameter<>' ') then
    hilfe;

  (************************************************************************)

  initialisiere_hand(hand[1]);
  initialisiere_hand(hand[2]);
  schliess_fehler_egal:=false;

  gesichertes_ende_sauber_beenden:=exitproc;
  exitproc:=addr(sauber_beenden_hand);

  oeffne(para[1],hand[1],true);
  oeffne(para[2],hand[2],false);

  anzahl_anzuzeigender_ziffern_ist_gross:=(hand[1].groesse>1024*1024*10); (* 10MB *)

  if (hand[2].datei_oder_laufwerk='L')
  and not (upcase(para[2][1]) in ['A','B'])
   then
    begin
      writeln(textz_warnung_festplattenlaufwerk^);
      write  (textz_fortfahren^);
      if not (upcase(readkey) in ['J','Y']) then
        abbruch('');
      writeln;
    end;

  if hand[1].datei_oder_laufwerk='D' then
    begin
      write(textz_Bestimme_Quellformat_^);

bestimme_quelle:

      springe_physikalisch(hand[1],logischer_anfang);
      blockgroesse:=512;
      lies(hand[1],puffer,blockgroesse);

      (* EXE ? *)
      if (puffer_signatur_exe.sig='MZ')
      or (puffer_signatur_exe.sig='ZM')
        then
          begin
            writeln_clreol('EXE...');
            inc(logischer_anfang,longint(puffer_signatur_exe.im_div_512)*512);
            if puffer_signatur_exe.im_mod_512<>0 then
              begin
                inc(logischer_anfang,longint(puffer_signatur_exe.im_mod_512));
                dec(logischer_anfang,512);
              end;
            goto bestimme_quelle
          end;

      if  (puffer[0]=$60)
      and (puffer[1]=$ea)
       then
        abbruch('ARJ x '+paramstr(1)+' !');

      if  (puffer[0]=ord('P'))
      and (puffer[1]=ord('K'))
       then
        abbruch('(PK)UNZIP '+paramstr(1)+' !');

      (* VMDISK *)
      if  (puffer[0]=0)
      and (puffer[1] in [1,2])
      and (puffer[7]=2)
      and (puffer[8] in [$e9,$eb])
       then
        begin
          writeln_clreol('VMDISK-'+textz_Kopf^);
          inc(logischer_anfang,8);
        end;

      (* FLOPPY-COPY *)
      if  (puffer[0]=ord('C'))
      and (puffer[1]=ord('D'))
      and (puffer[2]=ord('I'))
      and (puffer[3]=ord('S'))
      and (puffer[4]=ord('K'))
      and (puffer[5]=ord(' '))
      and (puffer[6]=ord('C'))
      and (puffer[7]=ord('o'))
      and (puffer[8]=ord('m'))
       then
        begin
          writeln_clreol('Floppy-Copy / Soenke Mumm, Oliver J. Albrecht');
          if puffer[$4c]>3 then
            abbruch(textz_Die_Quelldatei_ist_komprimiert_IMG_kann_sie_nicht_bearbeiten^);

          inc(logischer_anfang,$60);
          goto bestimme_quelle
        end;

      (* PMFLOPPY *)
      if  (puffer[0]=ord('D'))
      and (puffer[1]=ord('i'))
      and (puffer[2]=ord('s'))
      and (puffer[3]=ord('k'))
      and (puffer[4]=ord('I'))
      and (puffer[5]=ord('m'))
      and (puffer[6]=ord('a'))
      and (puffer[7]=ord('g'))
      and (puffer[8]=ord('e'))
      and (puffer[9]=0)
       then
        begin
          writeln_clreol('PMFloppy-'+textz_Kopf^);
          inc(logischer_anfang,$2d);
          goto bestimme_quelle;
        end;

      (* Disk eXPress *)
      for dxp_position:=0 to 4 do
        if  (puffer[dxp_position+0]=ord('A'))
        and (puffer[dxp_position+1]=ord('S'))
        and (puffer[dxp_position+2]=2)
        and (puffer[dxp_position+3]=0)
         then
          begin
            writeln_clreol('Disk eXPress-Kopf/Albert J. Shan');
            for w1:=1 to 5 do
              begin
                move(puffer[dxp_position+$134+(w1-1)*40],kommentar[1],40);
                kommentar[0]:=#40;
                writeln(kommentar);
              end;

            if puffer[dxp_position+10]<>0 then
              abbruch(textz_Komprimiert__Version_^+strf(puffer[dxp_position+10])+')');

            inc(logischer_anfang,dxp_position+$200);
            goto bestimme_quelle;
          end;


      (* Loaddskf *)
      if (puffer_signatur_loaddskf.sig=$59aa)
      or (puffer_signatur_loaddskf.sig=$5aaa)
       then
        begin
          writeln_clreol('Loaddskf/IBM');
          zaehler:=$28;
          while puffer[zaehler]<>0 do
            begin
              write(chr(puffer[zaehler]));
              inc(zaehler);
            end;

          if puffer_signatur_loaddskf.sig=$5aaa then
            abbruch(textz_Die_Quelldatei_ist_komprimiert_IMG_kann_sie_nicht_bearbeiten^);

          inc(logischer_anfang,puffer_signatur_loaddskf.kopflaenge);
          goto bestimme_quelle
        end;

      (* DDUMP *)
      if (puffer[0] in [0..3]) and (puffer[1]=0) and (puffer[$a2] in [$e9,$eb]) then
        begin
          writeln_clreol('DDUMP-'+textz_kopf^);

          for zaehler:=1 to 4 do
            begin
              puffer[1+(zaehler-1)*$28]:=$28;
              writeln('"',string_ptr(addr(puffer[1+(zaehler-1)*$28]))^,'"');
            end;

          inc(logischer_anfang,$a2);
          goto bestimme_quelle
        end;

      (* EMTCOPY *)
      if  (puffer[$00]=ord('\'))
      and (puffer[$01]=ord('\'))
      and (puffer[$02]=ord('z'))
      and (puffer[$03]=$c5)
       then
        begin
          emtcopy;
          goto fertig_kopiert;
        end;

      (* DIM .EXE *)
      if  (puffer[$000]=0)
      and (puffer[$131]=ord('D'))
      and (puffer[$132]=ord('i'))
      and (puffer[$133]=ord('s'))
      and (puffer[$134]=ord('k'))
      and (puffer[$135]=ord(' '))
      and (puffer[$136]=ord('I'))
      and (puffer[$137]=ord('M'))
      and (puffer[$138]=ord('a'))
       then
        begin
          (* DIM ..EXE *)
          inc(logischer_anfang,$131);
          goto bestimme_quelle;
        end;

      (* DIM *)
      if  (puffer[0]=ord('D'))
      and (puffer[1]=ord('i'))
      and (puffer[2]=ord('s'))
      and (puffer[3]=ord('k'))
      and (puffer[4]=ord(' '))
      and (puffer[5]=ord('I'))
      and (puffer[6]=ord('M'))
      and (puffer[7]=ord('a'))
       then
        begin
          dim;
          goto fertig_kopiert;
        end;

      (* 2FILE/2DISK *)
      if  (puffer[0]=ord('P'))
      and (puffer[1]=ord('C'))
      and (puffer[2]=ord('M'))
       then
        begin
          writeln_clreol('2FILE-'+textz_kopf^);
          inc(logischer_anfang,$0d);
          goto bestimme_quelle
        end;

      (* UCOPY *)
      if  (puffer[7]=0)
      and (puffer[8]=2)
      and (puffer[9]=0)
      and (puffer[10] in [1*40..1*41,2*40..2*41,2*80..2*85])
       then
        begin
          writeln_clreol('UCOPY-'+textz_Kopf^);
          inc(logischer_anfang,$0b);
          goto bestimme_quelle
        end;

      (* CFSDISKEMU *)
      if  (puffer[0]=ord('C'))
      and (puffer[1]=ord('F'))
      and (puffer[2]=ord('S'))
      and (puffer[3]=ord('D'))
      and (puffer[4]=ord('I'))
      and (puffer[5]=ord('S'))
      and (puffer[6]=ord('K'))
       then
        begin
          writeln_clreol('CFSDISKEMU-'+textz_Kopf^);
          inc(logischer_anfang,$44);
          goto bestimme_quelle
        end;


      if  (puffer[$00]=$ff)
      and (puffer[$01]=$ff)
      and (puffer[$02]=$ff)
      and (puffer[$51] in [$e9,$eb])
       then
        begin (* FASTPACKET *)
          writeln_clreol('FastPacket-'+textz_Kopf^+' (1.2)');
          inc(logischer_anfang,$51);
          goto bestimme_quelle
        end;

      if  (puffer[$00]=$ff)
      and (puffer[$01]=$ff)
      and (puffer[$02]=$ff)
      and (puffer[$166] in [$e9,$eb])
       then
        begin (* FASTPACKET *)
          writeln_clreol('FastPacket-'+textz_Kopf^+' (1.4)');
          writeln('"'+str_z(addr(puffer[$14]))^+'"');
          for zaehler:=1 to 5 do
            writeln('"'+str_z(addr(puffer[$67+(zaehler-1)*51]))^+'"');
          (* 14 67 9a *)
          inc(logischer_anfang,$166);
          goto bestimme_quelle
        end;

      if  (puffer[$00]=$ff)
      and (puffer[$01] in [8..36])
      and (puffer[$02] in [0..8+3])
      and (puffer[$10]=$01)
       then
        begin (* HD-Copy *)
          hd_copy;
          goto fertig_kopiert
        end;

      (* CISCOPY *)
      if (puffer[0] in [1..7]) and (puffer[1]=ord('L')) then
        begin
          ciscopy;
          goto fertig_kopiert
        end;

      (* BLITZCOPY 2.0 *)
      if (puffer[0]=2) and (puffer[1] in [0,1,2]) and (puffer[$58] in [$e9,$eb]) then
        begin
          writeln_clreol('BlitzCopy 2.0');
          blitzcopy;
          goto fertig_kopiert;
        end;

      (* 1PASS *)
      if (puffer[0] in [8..36]) and (puffer[2] in [$e9,$eb]) then
        begin
          writeln_clreol('One_Pass-'+textz_Kopf^);
          inc(logischer_anfang,2);
          goto bestimme_quelle
        end;

      (* AST DISKFILE *)
      if (longint(word_ptr(addr(puffer[0]))^)*512=hand[1].groesse-4) and (puffer[4] in [$e9,$eb]) then
        begin
          writeln_clreol('Diskfile-'+textz_Kopf^);
          inc(logischer_anfang,4);
          goto bestimme_quelle
        end;

      (* EZ-Disklone Plus *)
      if  (puffer[0]=$1a)
      and (puffer[1]=ord('F'))
      and (puffer[2]=ord('D'))
      and (puffer[3]=ord('F'))
       then
        begin
          writeln_clreol('EZ-Disklone Plus');
          ez_disklone_plus;
          goto fertig_kopiert;
        end;

      (* EZ-DiskCopy PRO *)
      if  (puffer[$00]=ord('E'))
      and (puffer[$01]=ord('Z'))
      and (puffer[$02]=ord('C'))
      and (puffer[$03]=ord('P'))
      and (puffer[$2e] in [$e9,$eb])
       then
        begin
          writeln_clreol('EZ-DiskCopy-PRO-'+textz_Kopf^);
          inc(logischer_anfang,$2e);
          goto bestimme_quelle
        end;

      if (puffer[0]=ord('C')) and (puffer[1]=ord('Q')) then
        if puffer[8] in [$e9,$eb] then
          begin
            (* EZCOPY *)
            writeln_clreol('EZ-Copy-'+textz_Kopf^);
            inc(logischer_anfang,8);
            goto bestimme_quelle
          end
        else
          begin
            (* COPYQM *)
            copyqm;
            goto fertig_kopiert
          end;

      (* SCOPY *)
      if  (puffer[$00]=ord('D'))
      and (puffer[$01]=ord('I'))
      and (puffer[$02]=ord('S'))
      and (puffer[$03]=ord('K'))
      and (puffer[$04]=ord('F'))
      and (puffer[$05]=ord('I'))
      and (puffer[$06]=ord('L'))
       then
        begin

          writeln_clreol('DiskFile / Craig Gaumer, Ed Bachman ['+strf(puffer[$12])+']');

          if puffer[$13]<>0 then
            writeln(str0(puffer[$20]));

          case puffer[$12] of
            0:
              begin
                inc(logischer_anfang,$20+puffer[$13]);
                goto bestimme_quelle
              end;
            1:
              begin
                scopy_1;
                goto fertig_kopiert
              end;
          end;
        end;


      (* DISKDUPE 4.0 *)
      if  (puffer[0]=ord('I'))
      and (puffer[1]=ord('M'))
      and (puffer[2]=0)
       then
        begin
          diskdupe_4;
          goto fertig_kopiert
        end;

      (* DISKDUPE 5.0 *)
      if  (puffer[0]=ord('M'))
      and (puffer[1]=ord('S'))
      and (puffer[2]=ord('D'))
      and (puffer[3]=ord(' '))
      and (puffer[4]=ord('I'))
      and (puffer[5]=ord('m'))
       then
        begin
          diskdupe_5;
          goto fertig_kopiert
        end;


      if (puffer[0]=$e0) and (puffer[1]=$ea) and (puffer[2]=$0b) and (puffer[3]=$0c) then
        begin
          writeln_clreol('Disk-Factory / Responsive Software');
          if puffer[4]<>0 then
            abbruch(textz_Komprimiert__Version_^+strf(puffer[4])+')');
          disk_factory;
          goto fertig_kopiert
        end;

      if  (puffer[0]=ord('E'))
      and (puffer[1]=ord('r'))
      and (puffer[2]=ord('w'))
      and (puffer[3]=ord('e'))
       then
        begin
          writeln('Kopf "Erweiterter Plattenabzug(Packung.exe)"');
          inc(logischer_anfang,512);
          if puffer[0+80+2+1+1+1]<>0 then
            writeln(puffer[0+80+2+1+1+1],textz_kopiergeschuetzte_Sektoren_werden_uebergangen_^);
          goto bestimme_quelle;
        end;



      roh_kopierer;
    end
  else
    roh_kopierer;

fertig_kopiert:

  schliesse(hand[1]);
  schliesse(hand[2]);
end.

