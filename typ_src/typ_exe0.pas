(*$I TYP_COMP.PAS*)
unit typ_exe0;

interface

uses
  typ_type;

procedure durchsuchen;

var
  codepuffer:puffertyp;

implementation

uses
  (*$IfDef ERWEITERUNGSDATEI*)
  typ_erw,
  (*$EndIf*)
  (*$IfDef GTDATA*)
  typ_gt,
  (*$EndIf*)
  typ_var,
  typ_eiau,
  typ_spru,
  typ_dien,
  typ_die2,
  typ_ausg,
  typ_varx,
  typ_for1,
  typ_for2,
  typ_for3,
  typ_spra,
  typ_exe1,
  typ_exe2,
  typ_xexe,
  typ_kopf,
  buschsuc,
  typ_entp,
  typ_posm;


type
  prozedur_exe_typ=procedure;


(*$I TYP_EXEI.PAS*)

procedure exe_nichts;far;
  begin
  end;

procedure exe_00;far;
  begin
    if bytesuche_codepuffer_0(#$00#$f6#$33#$c9#$b8#$01#$fa#$ba'EY'#$87#$c9#$e8#$00#$00) then
      trap('1.13a SW');

    if bytesuche_codepuffer_0(#$00#$f6#$8b#$d0#$b8#$01#$fa#$ba'EY'#$33#$d2#$e8#$00#$00) then
      trap('1.13b SW');

    if bytesuche_codepuffer_0(#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#$0e#$1f#$ba'?'#$00#$b9'??'#$90#$b4#$40#$cd#$21) then
      begin
        (* XX_EXE: *)
        ausschrift(textz_exe__fehlerhafte_vernullte_NE_Ausschrift^+' / Bernd Herd',dat_fehler);
        ausschrift('"'+puffer_zu_zk_l(codepuffer.d[codepuffer.d[3+$10]],codepuffer.d[6+$10])+'"',beschreibung);
        x_exe_stub_fehler;
      end;

    if bytesuche_codepuffer_0(#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00
    +#$b8'??'#$8e#$d8#$b4#$09#$ba'??'#$cd#$21#$b4#$4C#$CD#$21) then
      begin
        (* XX_EXE: *)
        ausschrift(textz_exe__fehlerhafte_vernullte_NE_Ausschrift^+' / Kevin L. Patch',dat_fehler);
        ansi_anzeige(analyseoff+codeoff_off+16*longint(codeoff_seg)+word_z(@codepuffer.d[$08+$10])^
          +longint(word_z(@codepuffer.d[$01+$10])^)*16,
         '$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)
        x_exe_stub_fehler;
      end;

  end;

{procedure exe_01;far;
  begin
  end;}

procedure exe_03;far;
  begin
    if bytesuche_codepuffer_0(#$03'TUSCON'#$03) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<TPack/TUSCON>',packer_exe);
  end;

procedure exe_05;far;
  var
    exe_tmp_puffer      :puffertyp;
    w1                  :word_norm;
  begin
    (* MOV AX,XXXX ; JMP AX *)
    if bytesuche_codepuffer_0(#$05#$0f#$00#$8b#$f0#$b9'??'#$80#$34) then
      begin
        b1:=codepuffer.d[$a];
        datei_lesen(exe_tmp_puffer,analyseoff+longint(codeoff_seg)*16+codeoff_off+$1dd,13);
        for w1:=0 to 13 do
          exe_tmp_puffer.d[w1]:=exe_tmp_puffer.d[w1] xor b1;
        ausschrift('SUN-PROT 1.01 / Matias Dahl "'+puffer_zu_zk_e(exe_tmp_puffer.d[0],#0,13)+'"',packer_exe);
      end;
  end;

procedure exe_06;far;
  var
    ga_zaehler          :integer_norm;
    w1,w2               :word_norm;
  begin
    if bytesuche_codepuffer_0(#$06#$1e#$60#$2e#$c6#$06#$00#$01'?'#$2e#$c6#$06#$01#$01'?'#$2e#$c6#$06#$02#$01'?'
        +#$be#$03#$01#$2e#$8a#$0e'??'#$bb) then
      ausschrift('ExeConv / Conea Software [3.06 /Z]',packer_exe);

    {baum}
    if bytesuche_codepuffer_0(#$06#$1e#$0e#$0e#$07#$1f#$b4#$30#$cd#$21#$86#$e0#$3d) then
      (* UNTINY 0.91 (UNTINY.EXE,FLAMES.COM) -> FI 2.09 : "0.04" *)
      ausschrift('REC / Ralph Roth [0.04]',packer_exe);

    if bytesuche_codepuffer_0(#$06#$8c#$c0#$05#$10#$00#$50#$50#$50#$0e#$59#$2b) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<MRECOVER.EXE/Monirul Islam Sharif>',packer_exe);

    if bytesuche_codepuffer_0(#$06#$30#$ed#$31#$db#$fa#$9c#$58#$80#$e4#$0f#$50#$9d#$9c) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<IROMDISK.EXE/H+BEDV>',packer_exe);

    if bytesuche_codepuffer_0(#$06#$1e#$0e#$0e#$07#$1f#$52#$b8'?'#$30#$1e#$cd#$21#$86#$e0#$3d) then
      begin
        w1:=puffer_pos_suche(codepuffer,#$e7#$e4#$9b,180); (* HS 1.13· COM2EXE.EXE *)
        if w1<>nicht_gefunden then
          begin
            ausschrift('REC / Ralph Roth "'+puffer_zu_zk_l(codepuffer.d[w1],8)+'"',packer_exe);
          end
      end;

    if  (     bytesuche_codepuffer_0(#$06#$1e#$b4#$30#$cd#$21)
          and (puffer_pos_suche(codepuffer,#$2b#$f7#$81#$fe'??'#$eb,$20)<>nicht_gefunden))
    or  (bytesuche_codepuffer_0(#$06#$1e#$53#$bb#$eb#$04#$5b#$eb#$fb'?'#$eb'?'#$0d#$0a#$fe)) (* 0.40.5 in HS 1.19 217 *)
    or  (bytesuche_codepuffer_0(#$06#$1e#$50#$b8#$eb#$04#$58#$eb#$fb'?'#$eb'?'#$0d#$0a#$fe)) (* 0.40.5 in aktion.exe *)
    or  (bytesuche_codepuffer_0(#$06#$1e#$57#$bf#$eb#$04#$5f#$eb#$fb'?'#$eb'?'#$0d#$0a#$fe)) (* 0.42 in HS 1.20 241 *)
     then
      begin
        w1:=puffer_pos_suche(codepuffer,#$e7#$e4#$9b,180); (* HS 1.18 (HSR anwenden) *)
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche(codepuffer,'rEC',180);      (* HS 1.19 unter HS und SCRNCH *)
        if w1<>nicht_gefunden then
          begin
            w2:=5;
            while codepuffer.d[w1+w2] in [ord('0')..ord('9'),ord('.'),ord('·')] do
              inc(w2);
            ausschrift('REC / Ralph Roth "'+puffer_zu_zk_l(codepuffer.d[w1],w2)+'"',packer_exe);
          end
      end;


    if bytesuche_codepuffer_0(#$06#$1e#$1e#$52#$b8'?'#$30#$cd#$21#$86#$c4#$3d'?'#$02#$73#$02#$cd#$20#$52) then
      rosetiny('1.02');

    if bytesuche_codepuffer_0(#$06#$1e#$52#$b8'?'#$30#$1e#$cd#$21#$86'?'#$3d'?'#$02#$73#$02#$cd#$20) then
      begin
        w1:=puffer_pos_suche(codepuffer,#$e7#$e4#$9b,180);
        if w1<>nicht_gefunden then
          ausschrift('REC / Ralph Roth "'+puffer_zu_zk_l(codepuffer.d[w1],8)+'"',packer_exe)
        else
          rosetiny('1.01');

        kopftext_nullen;
      end;

    if bytesuche_codepuffer_0(#$06#$1e#$33#$c0#$8e#$d8#$be#$04#$00#$89#$04) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<ACADW12/SafeSoft>',packer_exe);

    if bytesuche_codepuffer_0(#$06#$1e#$0e#$0e#$07#$1f'???'#$b9#$53#$01#$87)
    and (codepuffer.d[6] in [$bf,$be])
     then
      ausschrift('PassEXE 2.0 / Black Wolf Enterprises',packer_exe);

    if bytesuche_codepuffer_0(#$06#$0E#$0E#$1F#$07#$BE#$3D#$05) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<GAME WIZARD 2.20..2.30> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$06#$1e#$57#$56#$50#$53#$51) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<VEXE> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$06#$57#$1e#$56#$55#$52#$51#$53) then
      begin
        exezk:='?.?';
        if bytesuche(codepuffer.d[8],#$50#$bb'??'#$81#$c3#$00#$01#$2e#$8b#$07) then
          begin
            case codepuffer.d[$17] of
              $05:exezk:='1.2 .COM';
              $83:exezk:='1.3 .COM';
            else
                  exezk:='1.? .COM ¯';
            end;
          end;
        if bytesuche(codepuffer.d[8],#$50#$2e#$8c#$06#$08#$00#$8c#$c0) then
          begin
            case codepuffer.d[$10] of
              $05:exezk:='1.2 .EXE';
              $83:exezk:='1.3 .EXE';
            else
                  exezk:='1.? .EXE ¯';
            end;
          end;
        ausschrift('EPW / Aland D. Jones  ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$06#$fc) then
      begin
        ga_zaehler:=0;
        if puffer_pos_suche(codepuffer,#$e4#$21,100)<>nicht_gefunden then
          inc(ga_zaehler);

        if puffer_pos_suche(codepuffer,#$0c#$02,100)<>nicht_gefunden then
          inc(ga_zaehler);

        if puffer_pos_suche(codepuffer,#$e6#$21,100)<>nicht_gefunden then
          inc(ga_zaehler);

        if puffer_pos_suche(codepuffer,#$eb#$02#$eb,100)<>nicht_gefunden then
          inc(ga_zaehler);

        if puffer_pos_suche(codepuffer,#$eb#$fc,100)<>nicht_gefunden then
          inc(ga_zaehler);

        if puffer_pos_suche(codepuffer,#$06#$fc,100)<>nicht_gefunden then
          inc(ga_zaehler);

        if (ga_zaehler>=3) and (puffer_anzahl_suche(codepuffer,#$eb,100)>8) then
          ausschrift('GA / Stefan Verkoyen [1.0, Reg]',packer_exe)
      end;

    if bytesuche_codepuffer_0(#$06#$1E#$50#$56#$57#$51#$1e#$5a) then
      begin
        ausschrift('Screen Designer / Gary Ivany [1.0]',musik_bild);
        screen_designer(analyseoff+codeoff_off+16*longint(codeoff_seg)+$68);
      end;

    if bytesuche_codepuffer_0(#$06#$b4#$0f#$cd#$10#$3c#$07#$74#$06#$b8#$00#$b8#$eb#$04) then
      begin
        ausschrift('The Laughing Dog / Jeff SLoan [1.14]',musik_bild);
        thegrab(analyseoff+codeoff_off+16*longint(codeoff_seg)+$5b,25,80*2,'');
      end;

    if bytesuche_codepuffer_0(#$06#$0E#$1F) then
      begin
        if (codepuffer.d[$14]=$B4) then
          begin
            ausschrift('LzExe 0.90 / Fabrice Bellard',packer_exe);
            if kopftext<>'LZ09' then
              kopftext_anzeige(textz_exe__veraenderter_Kopf^,packer_exe);
            kopftext_nullen;
          end;
        if (codepuffer.d[$14]=$FD) then
          begin
            if kopftext='RJSX' then
              ausschrift('Arj-Sfx [LzExe 0.91]',packer_dat)
            else
              if kopftext='RSFX' then
                ausschrift('RAR-Sfx [LzExe 0.91]',packer_dat)
              else
                if kopftext='JARC' then
                  ausschrift('JARCS-Sfx [LzExe 0.91]',compiler)
                else
                  if kopftext='WöQP' then
                    ausschrift('TXT2EXE [LzExe 0.91]',compiler)
                  else
                    begin
                      ausschrift('LzExe 0.91 / Fabrice Bellard',packer_exe);
                      if kopftext<>'LZ91' then
                        kopftext_anzeige(textz_exe__veraenderter_Kopf^,packer_exe);
                    end;
            kopftext_nullen;
          end;
      end;

    if bytesuche_codepuffer_0(#$06#$e8'??'#$8c#$d0#$8c#$db#$2b#$c3#$b1#$04) then
      ausschrift('EMM386 '+textz_exe__Lader^+' / Novell',dos_win_extender);

    if bytesuche_codepuffer_0(#$06#$33#$c0#$8e#$c0#$26#$a0) then
      (* ET4000: CENTER und VMODE *)
      ausschrift(textz_exe__Zugriff_auf^+'$0000:'+hex_word(word_z(@codepuffer.d[7])^),signatur);

  end;

procedure exe_0e;far;
  var
    go32_puffer         :puffertyp;
    f1                  :dateigroessetyp;
    w1                  :word_norm;
  begin

    if bytesuche_codepuffer_0(#$0e#$1f#$8c#$c6#$b4#$4a#$50) then
      begin
        ausschrift(textz_exe__Lader^+' X-32(VM) Dos-Extender / Doug Huffman; FlashTek',dos_win_extender);
        datei_lesen(go32_puffer,analyseoff+ds_off+$100,$14);
        if not bytesuche(go32_puffer,^M^J'Fatal') then
          (* wie bei w32run.exe *)
          merke_position(analyseoff+word_z(@go32_puffer.d[0])^+word_z(@go32_puffer.d[2])^,datentyp_flashtek);
        (* sonst: EXE wie bei X32TEST.EXE *)
      end;

    if exe then
      ds_off:=codeoff_seg*16; (* fÅr Ausschriften *)

    if bytesuche_codepuffer_0(#$0e#$1e#$8b#$c4#$b1#$04#$d3#$e8#$8c#$d3#$03#$c3#$83#$c0#$30#$8e#$c0#$bf'??'
        +#$06#$57#$8b#$df#$be) then
      begin
        datei_lesen(go32_puffer,analyseoff+codeoff_seg*16+codeoff_off+$31c,512);
        exezk:=puffer_zu_zk_l(go32_puffer.d[5],go32_puffer.d[0]);
        for w1:=1 to length(exezk) do
          exezk[w1]:=Chr(Ord(exezk[w1]) xor go32_puffer.d[4]);
        ausschrift('King Shell / Double-Star Computer [1.21] '+exezk,packer_exe);
      end;


    if bytesuche_codepuffer_0(#$0e#$58#$1e#$be'?'#$00#$8c#$c2#$06#$83#$c2#$10#$8e#$d8#$fc#$ad#$09#$c0#$75) then
      begin
        case codepuffer.d[$13] of
          $0f:exezk:='[1.21]';
          $11:exezk:='[1.21 /4]';
        else
              exezk:='[1.?? ¯]';
        end;
        ausschrift('RP/x86 / Michael Hering '+exezk,packer_exe);
      end;


    if bytesuche_codepuffer_0(#$0e#$1f#$1e#$07#$be'??'#$bf'??'#$fd#$b9'??'#$f3#$a4#$87#$fe) then
      begin
        (* "Entpacker" fÅr DOS-Extender *)
        ausschrift('WDOSX / Michael Tippach [$WdX]',dos_win_extender);
        ansi_anzeige(analyseoff+longint(codeoff_seg)*16+$14,
         #0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;


    if bytesuche_codepuffer_0(#$0e#$1f#$b4#$09#$8d#$16'??'#$cd#$21#$b8#$01#$4c#$cd#$21) then
      begin
        (* XX_EXE: *)
        ausschrift(textz_exe__Ausschrift^+'Chris Graham',signatur);
        ansi_anzeige(analyseoff+16*codeoff_seg+word_z(@codepuffer.d[6])^
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)
        x_exe_stub_fehler;
      end;


    if bytesuche_codepuffer_0(#$0e#$68'??'#$68'??'#$55#$89#$e5#$81#$6e) then
      begin
        ausschrift('AC / Veit Kannegieser [EXEFIX,11/97]',packer_exe);
        einzel_laenge:=longint(codeoff_seg)*16+codeoff_off+$20;
        zeige_ueberhang_nicht_an:=wahr;
      end;

    if bytesuche_codepuffer_0(#$0e#$17#$9c#$58#$f6#$c4#$01#$74#$03) then
      begin
        case codepuffer.d[$c] of
          $1e:exezk:='1.7 .exe';
          $b4:exezk:='1.7 .com';
        else
              exezk:='?.?';
        end;
        (* "Dismember" *)
        ausschrift('Crypt / Alex Lemenkov ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$0E#$1F#$BA#$0E#$00) then
      (* SYMBOL.FOT 3.10 *)
      (* LINK386 aus OS/2 4.0 *)
      begin
        (* XX_EXE: *)
        ausschrift(textz_exe__Ausschrift^+'NE/LE/PE/LX',signatur);
        ansi_anzeige(analyseoff+16*codeoff_seg+word_z(@codepuffer.d[3])^
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)

        (* Korrektur: PGP.EXE fÅr OS/2 *)
        x_exe_stub_fehler;

      end;

    if bytesuche_codepuffer_0(#$0e#$1f#$ba#$00#$00#$b4#$09#$cd#$21) then
      begin
        (* XX_EXE: *)
        ansi_anzeige(analyseoff+16*codeoff_seg+word_z(@codepuffer.d[3])^
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)
      end;

    if bytesuche_codepuffer_0(#$0e#$1f#$ba'??'#$b8#$00#$40#$b9) then
      begin
        (* IBM SDS XX_EXE: *)
        f1:=analyseoff+16*longint(codeoff_seg)+word_z(@codepuffer.d[3])^;
        ansi_anzeige(f1,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
          absatz,wahr,wahr,f1+word_z(@codepuffer.d[9])^*4,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)
      end;

    if bytesuche_codepuffer_0(#$0e#$1f#$b4#$09#$ba'??'#$cd#$21) then
      begin
        (* RAR SFX OS/2 XX_EXE: *)
        ansi_anzeige(analyseoff+16*codeoff_seg+word_z(@codepuffer.d[5])^
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)

        x_exe_stub_fehler;
      end;

    if bytesuche_codepuffer_0(#$0E#$1f#$8c#$c0#$a3#$fa#$00) then
      ausschrift(textz_exe__unbekannter_DONGEL_Schutz^+'<HIGHWAY-PC/DöSI>',packer_exe);

    if bytesuche_codepuffer_0(#$0E#$8C#$D3#$8E#$C3#$8C#$CA) then
      begin
        (* Propack bei Speedball INSTALL.EXE *)
        case codepuffer.d[$33] of
          $d8:exezk:='-m1';
          $d0:exezk:='-m2';
        else
              exezk:='-m?'
        end;
        ausschrift('Pro-Pack / Rob Northen Computing [2.14/19 '+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$0e#$1f#$8c#$1e'??'#$8c#$06'??'#$fc#$b4#$30#$cd#$21) then
      begin
        (* EXECUTOR *)
        ausschrift('DPMI-'+textz_exe__Lader^+' / DJ Delorie',dos_win_extender);
        datei_lesen(go32_puffer,analyseoff+longint(codeoff_seg)*16,512);
        if go32_puffer.d[$2c]<>0 then
          (* BZIP2 *)
          ausschrift('runfile='+puffer_zu_zk_e(go32_puffer.d[$2c],#0,24),beschreibung);
      end;

    if bytesuche_codepuffer_0(#$0e#$0e#$1f#$07#$be'??'#$bf'??'#$ac) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<REDROCK/TORCH> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$0e#$1f#$b4#$1a#$ba#$00#$04#$cd#$21) then
      begin
        (* XX_EXE: *)
        (* ausschrift(textz_exe__unbekanntes_Archiv_GLB_fuer_MSWindows^,packer_dat); *)
        ausschrift('STUB InstallMaster / Wise Solutions',packer_dat);
        hersteller_erforderlich:=falsch; (* keine Nullen *)
      end;

  end;

procedure exe_0f;far;
  begin
    if bytesuche_codepuffer_0(#$0f#$01#$e0#$a8#$01#$0f#$84'??'#$33#$c0#$8e#$d8) then
      (* SMSW AX
         TEST AL,001
         JE ...
         XOR AX,AX
         MOV DS,AX
         CMP DD [2FC],0
         ..             *)
      begin
        (* XX_EXE: *)
        ausschrift(textz_exe__Ausschrift^+'PTS-DOS 7+',signatur);
        ansi_anzeige(analyseoff+longint(exe_kopf.kopfgroesse)*16
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)
      end;
  end;

procedure exe_16;far;
  var
    exe_tmp_puffer:puffertyp;
  begin
    if bytesuche_codepuffer_0(#$16#$1f#$33#$d2#$b4#$09#$cd#$21) then
      begin
        datei_lesen(exe_tmp_puffer,analyseoff+exe_kopf.kopfgroesse*16,512);
        (* ausschrift('Ausschrift OPTLOADER / SLR Systems',signatur); *)
        (* COREL *)
        ausschrift('"'+puffer_zu_zk_e(exe_tmp_puffer.d[0],'$',255)+'"',beschreibung);
      end;

  end;


procedure exe_1e;far;

  procedure pktiny(const version:string);
    begin
      ausschrift('PKTiny / Thomas Mînkemeier ['+version+']',packer_exe);
    end;
  var
    w1                  :word_norm;

  begin
    if bytesuche_codepuffer_0(#$1e#$0e#$1f) then
      begin
        if bytesuche_codepuffer_0(#$1e#$0e#$1f#$c7#$06#$00#$00'??'#$c7#$06#$02#$00'??') then
          begin
            case codepuffer.d[$0f] of
              $9c:
                (* VGAUNZIP "COPYRIGHT '93" *)
                pktiny('1.4? <VGAUNZIP>');
              $b8: (* #$b8#$f0#$ff#$31#$d2 *)
                (* VGACOPY.EXE 6.01 - 1994.??.?? *)
               (*pktiny('1.4? <VC 6.01>');*)
               pktiny('1.4');
            end;
          end
        else if bytesuche_codepuffer_0(#$1e#$0e#$1f#$fa#$55#$89#$e5#$8d#$06#$23#$00#$05#$00#$01#$50#$83) then
          begin
            pktiny('1.5'); (* instabil; Int 6 *)
          end
        else if bytesuche_codepuffer_0(#$1e#$0e#$1f#$b8#$f0#$ff#$8e#$c0#$26#$8a#$1e#$0e#$00) then
          begin
            if codepuffer.d[$1b]=$86 then
              (* VGACOPY.EXE 6.04 - 1994.08.20 *)
              pktiny('1.5? <VC 6.04>')
            else
              (* PKTIN162.ZIP *)
              pktiny('1.62');
          end
        else
          begin
            if puffer_gefunden(codepuffer,#$b4#$09#$ba'?'#$01#$cd#$21#$1f#$b8#$86#$4c#$cd#$21) then
              pktiny('1.?');
          end;
      end;

    if bytesuche_codepuffer_0(#$1e#$8c#$da#$83#$c2#$10#$8e#$da#$8e#$c2#$bb'??'#$ba'??'#$85#$d2#$74#$29#$b4#$01) then
      begin (* FI.EXE 1.50F / Michael Hering *)
        (* "Dismember" *)
        ausschrift('Crypt / Alex Lemenkov [1.3 exe]',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$1e#$06#$0e#$58#$2d#$10#$00#$8e#$d8#$8e#$c0#$e8#$32#$01) then
      begin
        for w1:=0 to 9 do
          exezk[w1]:=chr(codepuffer.d[$17+w1] xor codepuffer.d[$21]);
        ausschrift('EXE-File Defender / Varavva Brothers [2.0 .EXE] "'+exezk+'"',packer_exe);
      end;


    (* GPFREXX *)
    if bytesuche_codepuffer_0(#$1e#$2b#$c0#$50#$b8#$00#$00#$8e#$d8#$8e#$c0#$eb#$41) then
      ansi_anzeige(analyseoff+ds_off+$100
        ,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');

    if bytesuche_codepuffer_0(#$1e#$06#$e8#$32#$01#$dd#$85) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<NOD-ICE/ESET>',packer_exe);

    if bytesuche_codepuffer_0(#$1e#$06#$e8'?'#$00) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<BSQ,Trace Lock 0.9 / J.V†lky & L.Vrt°k> ',packer_exe);

    if bytesuche_codepuffer_0(#$1e#$06#$8c#$d8#$05#$10#$00#$8e#$d8) then
      begin
        (* ausschrift(textz_exe__unbekannte_Verschluesselung^+'<HAP4/Harald Feldmann>',packer_exe); *)
        case codepuffer.d[$20] of
          $85:
            case codepuffer.d[$31] of
              $74:exezk:='0.7j';
              $ad:exezk:='0.7m';
            else
                  exezk:='0.7? ¯';
            end;
          $0b:exezk:='?.? <HAP4/Harald Feldmann>';
        else
            exezk:='?.?';
        end;
        ausschrift('JMCryptExe / JauMing Tseng ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$1E#$BA'??'#$8E#$DA) then
      (* Topspeed Modula Dos 3.01 *)
      if bytesuche(codepuffer.d[6],#$5A#$89'???'#$1E#$07) (* /mo *)
      or bytesuche(codepuffer.d[6],#$8B#$0E'??'#$8B#$36) (* /m? *) then
        ts_verfolgung(codepuffer,'[3+]');


    if bytesuche_codepuffer_0(#$1E#$06#$BE'??'#$E8#$A5#$0C#$89#$36) then
      (* Limited ED `94 (fraglich) *)
      ausschrift(textz_exe__unbekannter^+' CLIPPER <1> (MS-C)',compiler);

    if bytesuche_codepuffer_0(#$1E#$b8#$0f#$01'??????????'#$00#$1e) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<Marek Sell>',packer_exe);

    if bytesuche_codepuffer_0(#$1e#$17#$50#$b4#$30#$cd#$21#$3c#$02#$73#$04) then
      begin
        case codepuffer.d[$11] of
          $9a:exezk:='0.14';
          $a5:exezk:='0.15';
        else
              exezk:='0.?? ¯';
        end;
        ausschrift('PGMPAK / Todor Todorov ['+exezk+'] (ZIP)',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$1E#$B8'??'#$8E#$D8#$B4#$30#$CD#$21) then
      (* RAILROAD C-1988 *)
      c_copy_run(longint(word_z(@codepuffer.d[$2])^)*16+8
       ,'','Microsoft '+textz_exe__Laufzeitbibliothek^+' [C]',compiler,10,#0,'');

    if bytesuche_codepuffer_0(#$1e#$06#$8c#$c8#$8e#$d8#$8c#$c0#$a3'?'#$00#$83) then
      begin
        (* Alchemy 1.9, JAR *)
        ausschrift('Microsoft '+textz_exe__Overlayverwaltung^,overlay_);
        if codepuffer.d[25]=$b8 then
          c_copy_run(longint(word_z(@codepuffer.d[25+1])^)*16+8
         ,'','Microsoft '+textz_exe__Laufzeitbibliothek^+' [C]',compiler,10,#0,'');

      end;

    if bytesuche_codepuffer_0(#$1E#$B8#$02#$00#$8e#$d8#$ba#$02#$00) then
      begin
        (* XX_EXE: *)
        ansi_anzeige(analyseoff+16*longint(codeoff_seg)+longint(codeoff_off)+$12
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)
        x_exe_stub_fehler;
      end;

    if bytesuche_codepuffer_0(#$1E#$06#$2e#$8c#$06#$06#$00#$fc#$0e#$1f) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<Rolle & Schild>',packer_exe);

    if bytesuche_codepuffer_0(#$1e#$06#$8c#$c3#$83#$c3#$10) then
      (* ausschrift(textz_exe__unbekannte_Relokations_Kompression^+'<GRAU/VaRedSoftware> ¯',packer_exe);*)
      begin
        (* PERUSE.ZIP,CLRSET.ZIP *)
        exezk:='[?:? ¯]';
        if bytesuche(codepuffer.d[7],#$2e#$01#$1e#$0c#$00#$b9) then
          exezk:='[1:RLE]';
        if bytesuche(codepuffer.d[7],#$0e#$1f#$01#$1e#$04#$00#$01#$1e#$06#$00#$be) then
          exezk:='[2:RELO]';
        ausschrift('Pack / Turbo Power [?.? ¯ - Turbo Analyst] '+exezk,packer_exe);
      end;

    if bytesuche_codepuffer_0(#$1E#$33#$c0#$50#$b8#$00#$00#$8e#$d8) then
      begin
        (* XX_EXE: MSDOS62 .DLL : CENTRAL POINT *)
        ansi_anzeige(analyseoff+16*exe_kopf.kopfgroesse
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)
        x_exe_stub_fehler;
      end;

    if bytesuche_codepuffer_0(#$1e#$33#$f6#$8e#$de#$06#$8e#$c6) then
      ausschrift('Basic-'+textz_exe__Laufzeitbibliothek^,compiler); (* BASRUN.EXE *)

    if bytesuche_codepuffer_0(#$1e#$6a#$00#$b8'??'#$8e#$d8#$8d#$16'??'#$b4#$09#$cd#$21) then
      begin
        (* XX_EXE: *)
        ansi_anzeige(analyseoff+ds_off+longint(codepuffer.d[4])*16+word_z(@codepuffer.d[$a])^+$100
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)
      end;

    if bytesuche_codepuffer_0(#$1e#$33#$c0#$50#$be#$19#$00#$81#$c6) then
      (* liemeer.com *)
      thegrab(analyseoff+codeoff_off+16*longint(codeoff_seg)+$19,word_z(@codepuffer.d[$14])^ div 80,80*2,'');

  end;

{procedure exe_26;far;
  begin

  end;}

procedure exe_2b;far;
  begin
    if bytesuche_codepuffer_0(#$2b#$f6#$2e#$f6#$06#$b0#$06#$ff#$74#$12#$0e#$58#$8b#$d8) then
      begin
        ausschrift('V-LOAD / ONYX ≥ Kartz / Tai Pan  [aTEU / MaX / MovSD [0.9]]',packer_exe);
        ansi_anzeige(analyseoff+codeoff_seg*16+$6d9
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

  end;

procedure exe_2e;far;
  var
    exe_tmp_puffer:puffertyp;
  begin

    if bytesuche_codepuffer_0(#$2e#$8c#$1e#$fe#$00#$8c#$ca#$8e#$da) then
      case codepuffer.d[$19] of
        $a7:ausschrift('NTShell / Mr. ZhouHui [4.0]',packer_exe);
        $f2:ausschrift('LOCK95 / Mr. ZhouHui [1.0]',packer_exe);
      else
            ausschrift('? / Mr. ZhouHui [4.0]',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$2e#$8c#$1e'??'#$1e#$06#$8c#$d8#$05#$10#$00#$8e#$d8#$8e#$c0#$2e#$01#$06) then
      begin
        (*case codepuffer.d[$] of
          $:exezk:='';
          $:exezk:='';
        else
            exezk:='?.? ¯';
        end;*)
        ausschrift('JMCryptExe / JauMing Tseng [0.7n]',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$2e#$c6#$06#$63#$00#$e2#$be#$04#$00#$bf'??'#$b9) then
      ausschrift(textz_exe__Kompression^+'HARDLOCK / Aladdin',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8c#$16'??'#$eb#$00#$ea) then
      begin
        case word_z(@codepuffer.d[3])^ of
         $0111:exezk:='1.20';
         $010e:exezk:='1.23,1.24,1.25,1.27';
        else
          exezk:='?.??';
        end;
        ausschrift('XDOC / JauMing Tseng ['+exezk+']',compiler);
      end;

    if bytesuche_codepuffer_0(#$2E#$FF#$16#$E4#$00#$E9) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<Wizardy>',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8b#$36#$0c#$00#$2e#$89#$74#$04) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<ECSTASY>',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$80#$06#$08#$01#$28#$eb#$00) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<Infinity / Mischa>',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8c#$1e'??'#$8b#$1e'??'#$8c#$da#$81) then
      begin (* PKLITE 1.00· .EXE *)
        if pklitekopf then
          ausschrift(pkliteversion+'·',packer_exe)
        else
          begin
            ausschrift('PKLite 1.00·, '+textz_exe__veraenderter_Kopf^,packer_exe);
            IncDGT(kopftextstart,2);
            Dec(kopftextlaenge,2);
            kopftext_anzeige('',packer_exe);
            DecDGT(kopftextstart,2);
            Inc(kopftextlaenge,2);
          end;
        pklitekopf:=falsch;
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$2E#$8C#$06'??'#$2E#$8C#$1E'??'#$BB) then
      (* PCTOOLS UNDEL.EXE *)
      ausschrift('RTLink '+textz_exe__Overlayverwaltung^+' <1>',overlay_);

    if bytesuche_codepuffer_0(#$2E#$8C#$06'??'#$2E#$8C#$1E'??'#$9a'????'#$bb) then
      (* PCTOOLS CPAV *)
      ausschrift('RTLink '+textz_exe__Overlayverwaltung^+' <2>',overlay_);

    if bytesuche_codepuffer_0(#$2e#$8c#$1e'??'#$bb'??'#$8e#$db) then
      ausschrift('RTLink '+textz_exe__Overlayverwaltung^+' [3.13]',overlay_);

    if bytesuche_codepuffer_0(#$2e#$8c#$06'??'#$2e#$8c#$16'??'#$2e#$89#$26'??'#$fa#$8c#$c8) then
      ausschrift(textz_exe__unbekannte_Overlayverwaltung_zu^+' WATCOM C/C++16 <Jet Commander>',overlay_);

    if bytesuche_codepuffer_0(#$2e#$89#$1e'??'#$2e#$88#$2e'??'#$2e#$88#$16'??'#$2e#$89#$36'??'#$1e#$2e) then
      begin
        datei_lesen(exe_tmp_puffer,analyseoff+3,2);
        ausschrift('IO.SYS      / MS ≥ IBMBIO.COM  / IBM  DOS '
         +str_(exe_tmp_puffer.d[0],1)+'.'+str_(exe_tmp_puffer.d[1],2),dos_win_extender);
      end;

    if bytesuche_codepuffer_0(#$2e#$89#$1e'??'#$2e#$88#$2e'??'#$2e#$88#$16'??'#$5e#$1f#$5e#$1f#$2e#$89#$36'??'#$1e#$2e) then
      begin (* PCDOS 7.10 *)
        datei_lesen(exe_tmp_puffer,analyseoff+3,2);
        ausschrift('IO.SYS      / MS ≥ IBMBIO.COM  / IBM  DOS '
         +str_(exe_tmp_puffer.d[0],1)+'.'+str_(exe_tmp_puffer.d[1],2),dos_win_extender);
        suche_bin_bldlevel;
      end;

    if bytesuche_codepuffer_0(#$2E#$8C#$1E'?'#$00#$2E#$C7#$06'?'#$00#$00#$00#$e8) then
      begin
        case codepuffer.d[3] of
          $b2:(* Turbo Basic Demos von CD Limited Edition `94 *)
              exezk:='Turbo/Borland Basic [1.0]'; (* 1987 *)
          $3e:(* $3e/$3c *)
              (* POPSI : PowerBasic 2.10 *)
              exezk:='PowerBasic [2.10]';
          $80:exezk:='PowerBasic [3.2]';
        else
              exezk:='Turbo-/PowerBasic [?.??] ¯';
        end;
        ausschrift(exezk,compiler);
      end;

    if bytesuche_codepuffer_0(#$2E#$C7#$06#$09#$00) then
      begin
        (* GWS 6.1 SW *)
        datei_lesen(exe_tmp_puffer,analyseoff+exe_kopf.kopfgroesse*16,512);
        ausschrift(puffer_zu_zk_e(exe_tmp_puffer.d[$1d],#0,255)+' / Alchemy Mindworks  '
          +str0(word_z(@exe_tmp_puffer.d[$0B])^)+' * '
          +str0(word_z(@exe_tmp_puffer.d[$0d])^)+' '
          +str0(1 shl longint(exe_tmp_puffer.d[$11]))+textz_exe__Farben^,musik_bild);
      end;

    if bytesuche_codepuffer_0(#$2E#$8C#$1E#$CE#$01#$8C#$C8#$8E) then
      (* Backstage / LIVECLUB XP00.EXE *)
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<Parsec>',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$80#$36#$08#$01#$28#$eb#$00#$c3) then
      (* UCFUXSRC *)
      ausschrift(textz_exe__unbekannte_Kompression^+'<UX.COM/Mischa> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8c#$1e'??'#$bb'??'#$81#$c3) then
      begin
        ausschrift('unbekannte WIN.COM-Starter <2e>',packer_exe);
        hersteller_erforderlich:=falsch; (* keine Nullen *)
      end;

    if bytesuche_codepuffer_0(#$2e#$a1#$44#$01#$a3#$5c) then
      ausschrift(textz_exe__Anpasser_von^+'REKOMB / Veit Kannegieser (1996)',signatur);

    if bytesuche_codepuffer_0(#$2e#$a1#$6c#$01#$a3#$5c#$00#$8c#$d8) then
      ausschrift(textz_exe__Anpasser_von^+'REKOMB / Veit Kannegieser (5/1997)',signatur);

    if bytesuche_codepuffer_0(#$2e#$8c#$16#$0b#$00#$2e#$89#$26) then
      ausschrift(textz_exe__unbekannter_Programmschutz^+'<DMC 3.5> / Adlersparre & Associates ¯',packer_exe);

  end;

procedure exe_31;far;
  begin
    if bytesuche_codepuffer_0(#$31#$c0#$8e#$d8#$c7#$06#$04#$00#$34) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<HyperType/Mr.Fanatic> ¯',packer_exe);

  end;


procedure exe_33;far;
  var
    w1                  :word_norm;
  begin

    if bytesuche_codepuffer_0(#$33#$f6#$2e#$f6#$06#$b0#$06#$ff#$74#$12#$0e#$58#$8b#$d8) then
      begin
        ausschrift('V-LOAD / ONYX [0.9·] ≥ Kartz / Tai Pan [0.3]',packer_exe);
        ansi_anzeige(analyseoff+codeoff_seg*16+$6d9
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;


    if bytesuche_codepuffer_0(#$33#$C0#$CD#$33#$3D#$FF#$FF#$75#$0E) then
      begin
        ausschrift('ASC2COM / MorganSoft [1.75+]',compiler);
        if bytesuche__datei_lesen(analyseoff+codeoff_seg*16+$12f,#$da#$c4) then
          w1:=$11f
        else
          w1:=$12f;
        ansi_anzeige(analyseoff+codeoff_seg*16+w1,
        #0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    if bytesuche_codepuffer_0(#$33#$C0#$8E#$D8#$8E#$C0#$FC#$FA#$BE#$04) then
      ausschrift(textz_exe__unbekannte_Kompression^+'(Ady) <XOPEN[3.20]>',packer_exe);

    if bytesuche_codepuffer_0(#$33#$C0#$be#$80#$00#$ac#$3c#$00) then
      compak(codeoff_seg*16+$100);

    if bytesuche_codepuffer_0(#$33#$f6#$33#$ff#$8c#$db#$8b#$d3#$81#$c3#$00#$10#$8e#$c3) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<Martinic Computers>',packer_exe);

  end;

procedure exe_36;far;
  begin
    if bytesuche_codepuffer_0(#$36#$8C#$1E'??'#$A1) then
      if bytesuche_codepuffer_0(#$36#$8C#$1E'??'#$A1#$2C#$00#$36#$A3) then
        (* LASTBYTE Memory Manager 2.51 *.EXE *)
        ausschrift('C / DeSmet/C-Ware [3.1]',compiler)
      else
        if bytesuche_codepuffer_0(#$36#$8C#$1E'??'#$A1'??'#$8C#$D3#$2B#$C3) then
          ausschrift('C / DeSmet/C-Ware [1.2]',compiler)
        else
          ausschrift('C / DeSmet/C-Ware [?.?]',compiler)
  end;

procedure exe_3a;far;
  begin
    if bytesuche_codepuffer_0(#$3a#$3d#$25'00'#$25'AA'#$35'$Q'#$50#$5e) then
      (*ausschrift('NetCode / G†bor Keve [?.? ¯]',packer_exe);*)
      com2text_nide('1.11..1.12 -c',codepuffer.d[$39],Length('com2txtNide'));

    if bytesuche_codepuffer_0(#$3a#$3d#$37#$25'00'#$25'AA'#$50#$59#$35) then
      com2text_nide('1.20 -c',codepuffer.d[$4b],Length('com2txtNide'));

    if bytesuche_codepuffer_0(#$3a#$3f#$37#$25'00'#$25'CC'#$50#$59#$2d'@=') then
      (* Version 0.3.1 und XPACK 1.76n *)
      (*ausschrift(textz_exe__ausfuehrbarer_Text^+' <iCEuNP 0.3.1/Jauming Tseng>',packer_exe);*)
      com2text_nide('1.40..1.41 -c',codepuffer.d[$4b],Length('Nide/com2txt'));

    if bytesuche_codepuffer_0(#$3a#$db#$74#$07#$b8#$01#$4c#$cd#$21#$eb#$1e#$b4#$30#$cd#$21) then
      hackstop('1.17');
  end;


procedure exe_42;far;
  begin

    if bytesuche_codepuffer_0('BWT'#$b4#$1a#$b0#$00#$cd#$2f) then
      begin
        ausschrift('EXECON ac / Keve G†bor [2.5]',packer_exe);
        ansi_anzeige(analyseoff+codeoff_seg*16+$14e,
        #0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    if bytesuche_codepuffer_0('BARTi!/INFINY'#$1a'?'#$f9) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<BARTI/INFINY> ¯',packer_exe);
  end;

procedure exe_43;far;
  begin
    if bytesuche_codepuffer_0('CNTX'#$e8) then
      if bytesuche__datei_lesen(analyseoff+codeoff_off+16*longint(codeoff_seg)+4+1+2+word_z(@codepuffer.d[4+1])^,
        #$5e#$8b#$4c#$fe#$bf#$00#$01#$ac#$33) then
        ausschrift('C0NtRiVER''s cryptor',packer_exe); (* cntx.com, manticore *)

  end;

procedure exe_46;far;
  begin
    if bytesuche_codepuffer_0(#$46#$55#$43#$4b#$59#$4f#$55#$1a#$ff#$5f#$b9#$ff#$ff) then
      begin
        case codepuffer.d[$5f] of
          $c6:exezk:='07';
          $02:exezk:='10';
          $00:exezk:='15';
          $c8:exezk:='14';
        else
              exezk:='?? ¯';
        end;
        ausschrift('Mess / Stonehead [COM 1.'+exezk+']',packer_exe);
      end;

  end;

procedure exe_4b;far;
  begin
    if bytesuche_codepuffer_0('KAOT?'#$eb#$02'??'#$be#$10#$00#$b4#$30#$cd#$21) then
      begin
        exezk:='?.??';
        case codepuffer.d[4] of
          ord('\'): (* POP SP *)
            case codepuffer.d[$29] of
              $67:exezk:='1.08r';   (* "Windows suxx! Use DOS instead!" *)
              $5e:exezk:='1.10r';   (* "Anarchy will rule da world!" *)
            end;
          ord('X'): (* POP AX *)
            case codepuffer.d[$29] of
              $43:exezk:='1.07.02r';(* "" *)
              $69:exezk:='1.11r';   (* "Greetz to all green and white potatos!" *)
            end;
        end;
        ausschrift('SuckStop / Ka0t^N0Ps ['+exezk+'] '(*+zusatzcodelaenge_zk*),packer_exe)
      end;

  end;
procedure exe_4e;far;
  begin
    if bytesuche_codepuffer_0('NETPIC.COM/=') then
      ausschrift(textz_exe__ausfuehrbarer_Text^+' NETPIC / Jim Tucker [1.0e] ¯',packer_exe)
  end;

procedure exe_4d;far;
  begin
    if bytesuche_codepuffer_0('MMX'#$b8'??'#$ba) then
      ausschrift('XcomOR / madmax! [0.99f]',packer_exe);

    if bytesuche_codepuffer_0('MMX'#$66#$81#$36#$03#$01#$92) then
      begin
        case codepuffer.d[$12] of
          $fd:exezk:='h';
          $0e:exezk:='i';
        else
              exezk:='? ¯';
        end;
        ausschrift('XcomOR / madmax! [0.99'+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0('M'#$e9)
    or bytesuche_codepuffer_0('M'#$eb)
     then
      ausschrift('7son',virus);

    if bytesuche_codepuffer_0('MESS'#$b9) then
      begin
        case codepuffer.d[$10] of
          $50:exezk:='1.07';
          $53:exezk:='1.15';
        else
              exezk:='1.?? ¯';
        end;
        (*ausschrift('Mess / Stonehead [EXE '+exezk+']',packer_exe);*)
        mess(' [EXE '+exezk+']','');
      end;

    if bytesuche_codepuffer_0('MESS'#$fa#$b9) then
      (* COM/EXE *)
      (*ausschrift('Mess / Stonehead [1.20]',packer_exe);*)
      mess(' [1.20]','');

    if bytesuche_codepuffer_0('MESS'#$fa#$54#$5b) then
      (* JMCE07M/N *)
      mess(' [1.25..1.31]','');

  end;

procedure exe_50;far;
  var
    exe_tmp_puffer      :puffertyp;
    w1                  :word_norm;
  begin
    if bytesuche_codepuffer_0(#$50#$51#$1e#$06#$54#$b8'??'#$50#$40#$b1#$20#$f7#$e1#$8c#$ca) then
      begin (* AVK.ZIP *)
        case codepuffer.d[$1b] of
          $73:exezk:='PCRYPT [2.6]';
          $85:exezk:='PCRYPT [3.0]';
          $b0:exezk:='PROTECT [7.1]';
          $f7:exezk:='PASSWORD [6.1]';
        else
              exezk:='?';
        end;
        ausschrift(exezk+' / Andry Kobilykov',packer_exe); (* MERLiN *)
      end;

    if bytesuche_codepuffer_0('PCRYPT'#$ff'v?.??'#$00#$e9) then
      ausschrift('PCRYPT / MERLiN ['+puffer_zu_zk_l(codepuffer.d[8],1+1+2)+' .COM]',packer_exe);

    if bytesuche_codepuffer_0('PCRYPT'#$e9) then
      begin
        ausschrift('PCRYPT / MERLiN ['+{3.45..}'3.50 .COM]',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$50#$53#$a1#$01#$01#$05#$03#$01#$d1#$e8#$d1#$e8#$d1#$e8#$d1#$e8
         +#$8b#$d8#$8c#$c8#$03#$c3#$50) then
      begin
        ausschrift('??? <VALIDATE.COM/Dennis Yelle>',packer_exe);
        datei_lesen(exe_tmp_puffer,codeoff_seg*16+codeoff_off-word_z(@codepuffer.d[$18])^+55,512);
        case chr(exe_tmp_puffer.d[0]) of
          'P':
            begin
              (* Kennwort - ohne Wirkung *)
              exezk:=puffer_zu_zk_pstr(exe_tmp_puffer.d[$1d-$1b]);
              for w1:=1 to length(exezk) do
                exezk[w1]:=chr(ord(exezk[w1]) xor $ff);
              ausschrift('  P: "'+exezk+'"',packer_exe);
            end;
          'D':
            begin
              (* Datum - mit Lîschen! *)
              ausschrift('  D: '+str_(word_z(@exe_tmp_puffer.d[$2c])^,4)+'.'
                                +str_(exe_tmp_puffer.d[$2e],2)+'.'+str_(exe_tmp_puffer.d[$2f],2),packer_exe);
            end;
          'L':
            begin
              (* DatentrÑgername - ohne Wirkung *)
              ausschrift('  L: "'+puffer_zu_zk_e(exe_tmp_puffer.d[$4b-$1b],#0,13)+'"',packer_exe);

            end;
        else
              ausschrift('  '+chr(exe_tmp_puffer.d[0])+' ??? ¯',packer_exe);
        end;
      end;

    if bytesuche_codepuffer_0(#$50#$53#$51#$52#$57#$56#$1e#$06#$54#$e8'?'#$01) then
      begin
        for w1:=0 to 9 do
          exezk[w1]:=chr(codepuffer.d[$f+w1] xor codepuffer.d[$1d]);
        ausschrift('EXE-File Defender / Varavva Brothers [2.0 .COM] "'+exezk+'"',packer_exe);
      end;

    (* INT.EXE *)
    if bytesuche_codepuffer_0(#$50#$e9#$8a#$00#$0d#$0a'RO') then
      rosetiny('0.90');

    if bytesuche_codepuffer_0(#$50#$0e#$8c#$c8#$05'??'#$50#$33#$c0#$50#$cb) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<CODEKEY 2.00;WiDa/NSISDN.COM> ¯',packer_exe);
    if bytesuche_codepuffer_0(#$50#$eb'?'#$50#$53#$51#$52#$1e#$56#$57#$1e#$33#$c0) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<CODEKEY 2.00;WiDa/RCON.EXE> ¯',packer_exe);


    if bytesuche_codepuffer_0(#$50#$8c#$d8#$05#$10#$00#$8e#$d8#$06#$1e#$05'??'#$8e#$c0#$8c#$c5#$8c#$d9#$2b#$e9#$b8) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<BSL.EXE[0]/Thomas "Beret" Kawecki>',packer_exe);

    if bytesuche_codepuffer_0(#$50#$53#$51#$57#$bb#$80#$00#$80#$3f#$00#$74) then
      begin
        ausschrift('ASC2COM / Morgansoft [2.00,2.05 COMPRESS]',compiler);
        ansi_anzeige(analyseoff+codeoff_seg*16+$12f,
        #0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    if bytesuche_codepuffer_0(#$50#$53#$51#$52#$1e#$0e#$1f#$2e#$a0#$04#$00#$3c#$01) then
      begin
        (* COMLOCK 0.10 *)
        ausschrift('??? / ??? <COMLOCK/Troble Makers> ¯',packer_exe);
        if byte__datei_lesen(analyseoff+longint(codeoff_seg)*16+$0004)=1 then
          ansi_anzeige(analyseoff+codeoff_seg*16+$5
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    if bytesuche_codepuffer_0(#$50#$33#$c0#$8e#$c0#$2e#$f6#$06'??0'#$74#$11) then
      ausschrift('CODESAFE-'+textz_exe__Verschluesselung^+' / EliaShim Ltd',packer_exe);

    if bytesuche_codepuffer_0(#$50#$b8'??'#$BA'??'#$05) then
      (* 1.20 "1.50" *)
      begin
        if pklitekopf then
          ausschrift(pkliteversion,packer_exe)
        else
          begin
            ausschrift('PKLite [1.12..1.20], '+textz_exe__veraenderter_Kopf^,packer_exe);
            IncDGT(kopftextstart,2);
            Dec(kopftextlaenge,2);
            kopftext_anzeige('',packer_exe);
            DecDGT(kopftextstart,2);
            Inc(kopftextlaenge,2);
          end;
        pklitekopf:=falsch;
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$50#$b8'??'#$ba'??'#$3b#$c4#$73'?'#$8b#$c4) then
      (* 1.50 .COM *)
      begin
        if pklitekopf then
          ausschrift(pkliteversion,packer_exe)
        else
          begin
            ausschrift('PKLite 1.50, '+textz_exe__veraenderter_Kopf^,packer_exe);
            ausschrift('"'+puffer_zu_zk_l(codepuffer.d[$30],$36)+'"',signatur);
          end;
        pklitekopf:=falsch;
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$50#$06#$8C#$CA#$8E#$DA#$BE#$08) then
      (* PowerStream 3 QS3.exe *)
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<Microsolutions>',packer_exe);

    if bytesuche_codepuffer_0(#$50#$06#$0E#$1F) then
      begin
        (* SETSOUND.EXE PINBALL FANTASY *)
        ausschrift('LzExe 0.91· / Fabrice Bellard',packer_exe);
        if kopftext<>'LZ91' then
          kopftext_anzeige(textz_exe__veraenderter_Kopf^,packer_exe);
        kopftext_nullen;
      end;

    if bytesuche_codepuffer_0(#$50#$53#$51#$52#$56#$57#$55#$1E) then
      (* Invertia Player PLAY.EXE ISETUP.EXE : LzExe91-VerschlÅsselung *)
      begin
        datei_lesen(exe_tmp_puffer,analyseoff+longint(codeoff_seg)*16+longint(codeoff_off)-16,16);
        ausschrift('Inertia '+textz_exe__Verschluesselung^+' "'+puffer_zu_zk_l(exe_tmp_puffer.d[0],16)+'"',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$50#$1e#$0e#$1f#$fc#$33#$f6) then
      begin
        ausschrift('UCEXE / AIP: Andrew Cadach',packer_exe);
        if (kopftext<>'UC2X') then
          kopftext_anzeige(textz_exe__veraenderter_Kopf^,packer_exe);
        kopftext_nullen;
      end;

    if bytesuche_codepuffer_0(#$50#$1e#$0e#$1f#$fc#$16#$07) then
      begin
        ausschrift('UCEXE (?) / AIP: Andrew Cadach',packer_exe);
        if (kopftext<>'UC2X') then
          kopftext_anzeige(textz_exe__veraenderter_Kopf^,packer_exe);
        kopftext_nullen;
      end;

    if bytesuche_codepuffer_0(#$50#$1e#$0e#$1f#$16#$07#$33#$f6) then
      begin
        w1:=puffer_pos_suche(analysepuffer,'AVPACK',100); (* .EXE *)
        if w1<nicht_gefunden then
          begin
            exezk:=version_x_y(analysepuffer.d[w1+7],analysepuffer.d[w1+6]);
            if analysepuffer.d[w1+8]=2 then
              exezk_anhaengen(' Extra');
            if analysepuffer.d[w1+8]=3 then
              exezk_anhaengen(textz_exe__Kopierschutz^);
          end
        else
          exezk:=' (?)';

        ausschrift('AVPACK / Andrei Volkov'+exezk,packer_exe);
      end;

    if bytesuche_codepuffer_0(#$50#$bf'??'#$2e#$8c'???'#$2e#$c6) then
      ausschrift(textz_exe__Kopierschutzhuelle^+'[FRITZ3] ¯',packer_exe);

    if bytesuche_codepuffer_0(#$50#$06#$16#$07#$be'??'#$8b#$fe#$b9'??'#$fd#$fa) then
      ausschrift('JAM / Eugen Vasilchenko [2.11] '+textz_exe__Vorsicht_auf_486^,packer_exe);

    if bytesuche_codepuffer_0(#$50#$b4#$30#$cd#$21#$86#$e0#$3d#$00#$03#$73#$02#$cd#$20#$eb#$02) then
      hackstop('0.99 .COM');

    if bytesuche_codepuffer_0(#$50#$53#$b4#$30#$cd#$21#$86#$e0#$3d#$00#$03) then
      rosetiny('0.94');
  end;

procedure exe_51;far;
  begin
    if bytesuche_codepuffer_0(#$51#$e8#$00#$00#$59#$50#$53#$52#$56#$57#$1e#$33#$f6#$8b#$c6#$8e#$d8) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<IMMUN.EXE/Jens Bleuel>',packer_exe);
  end;

procedure exe_52;far;
  begin
    if bytesuche_codepuffer_0(#$52#$b8'?'#$30#$1e#$cd#$21) then
      begin
        if (puffer_pos_suche(codepuffer,'˛ROSETINY˛',500)<>nicht_gefunden)
        or (puffer_pos_suche(codepuffer,'INY (',500)<>nicht_gefunden)
         then
          rosetiny('0.96+')
        else
          hackstop('1.13·+');

        kopftext_nullen;
      end;
  end;

procedure exe_53;far;
  begin
    if bytesuche_codepuffer_0(#$53#$bb#$eb#$04#$5b#$eb#$fb#$ea#$58#$2d#$07) then
      rosetiny('1.03');

    if bytesuche_codepuffer_0(#$53#$bb#$eb#$04#$5b#$eb#$fb#$ea#$9c#$1e) then
      hackstop('1.19 217;1.20B EXE');

  end;

procedure exe_54;far;
  var
    exe_tmp_puffer      :puffertyp;
    w1,w2               :word_norm;
  begin

    if bytesuche_codepuffer_0(#$54#$5b#$3b#$dc#$75#$11#$eb#$00#$9c#$5b#$81#$cb#$00#$f0#$53#$9d) then
      begin
        case codepuffer.d[$16] of
          $17:exezk:='1.7';  (* WWPE *)
          $1e:exezk:='1.71'; (* WWPE *)
        else
          exezk:='?.?? ¯';
        end;
        ausschrift('ShaDoW COM cryptor / MANtiC0RE ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$54#$58#$50#$50#$50#$2d#$68#$68#$2d#$67#$67) then
      com2text_nide('1.00',codepuffer.d[$37],Length('com2txt/Nide'));

    if bytesuche_codepuffer_0(#$54#$5f#$4f#$4f) then
      begin
        case codepuffer.d[$c] of
          $35:exezk:='1.01..1.12';
          $50:exezk:='1.20..1.41'
        else
              exezk:='1.?? ¯';
        end;
        com2text_nide(exezk,codepuffer.d[$38],Length('com2txt/Nide'));
      end;

    if bytesuche_codepuffer_0(#$54#$58#$3b#$c4#$75#$10#$9c) then
      begin
        ausschrift('Turbo/Borland Pascal 7'+textz_exe__mit^+textz_exe__Laufzeitbibliothek^
         +' Eagle Performance [386+]',compiler);
        datei_lesen(exe_tmp_puffer,analyseoff+longint(codeoff_seg)*16+word_z(@codepuffer.d[$1d-6])^,512);
        w1:=puffer_pos_suche(exe_tmp_puffer,#0,200);
        w2:=0;
        repeat
          inc(w2);
        until (w2>=255) or (exe_tmp_puffer.d[w1+1+w2]>$80);
        (* 255-Grenze: Impulse Tracker 2.14 *)
        if w1<>nicht_gefunden then
          ausschrift(puffer_zu_zk_l(exe_tmp_puffer.d[w1+1],w2),beschreibung);
      end;

  end;

procedure exe_55;far;
  begin
    if bytesuche_codepuffer_0(#$55#$57#$cd#$03#$fc'MASK') then
      begin
        case codepuffer.d[$1b] of
          $52:exezk:='2.1';
          $a6:exezk:='2.3';
          $f1:exezk:='2.4';
          $56:exezk:='2.5';
        else
              exezk:='2.? ¯';
        end;
        ausschrift('MASK / JosÇ M. L. Lopes ['+exezk+']',packer_exe);
      end;
  end;

procedure exe_56;far;
  begin
    if bytesuche_codepuffer_0(#$56#$be#$eb#$04#$5e#$eb#$fb#$9a#$1e#$52)
    and (   bytesuche(codepuffer.d[$A],#$b8'?'#$30) (* F_MIRC.EXE *)
         or bytesuche(codepuffer.d[$A],#$b4#$30))   (* CPUID.EXE *)
     then
      hackstop('1.19+');

    if bytesuche_codepuffer_0(#$56#$57#$55#$1e#$8c#$c8#$8e#$d8) then
      (* IPLAY 1.21,1.22 - Aufruf im Programm als "overlay" *)
      ausschrift(textz_exe__Verschluesseltes_Bild^+' / Inertia Player',packer_exe);

    if bytesuche_codepuffer_0(#$56#$50#$56#$fd#$8b#$fc#$83#$ef#$3c#$b9) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<DEVICE/Alex> ¯',packer_exe);
  end;

procedure exe_57;far;
  begin
    if bytesuche_codepuffer_0(#$57#$bf#$eb#$04#$5f#$eb#$fb#$ea#$58#$2d#$07#$00#$50#$06#$1e#$57#$51#$e8#$02#$00) then
      rosetiny('1.05');

    if bytesuche_codepuffer_0(#$57#$56#$50#$53#$51#$06#$0e#$07#$b9'??'#$bf'??'#$be'??'#$8a#$04) then
      begin
        ausschrift('ASC2COM / Morgansoft [2.05 PRINTER]',compiler);
        ansi_anzeige(analyseoff+codeoff_seg*16+$12f,
        #0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

  end;

procedure exe_58;far;
  begin
    {baum}
    if bytesuche_codepuffer_0(#$58#$50#$53#$51#$56#$57#$50#$32#$44#$35#$30#$44#$35#$32) then
      (* HPA_C2T *)
      ausschrift('HPA COM to ASCII converter / Lukundoo [0.6]',packer_exe);

    if bytesuche_codepuffer_0(#$58#$50#$35#$7e#$7e#$2d#$7e#$7d#$50#$5d#$58#$50) then
      ausschrift(textz_exe__ausfuehrbarer_Text^+' ??? / MikroLab',packer_exe);

    if bytesuche_codepuffer_0('XPPPYZIQD[L-f6') then
      case chr(codepuffer.d[$2d]) of
        '_':ausschrift(textz_exe__ausfuehrbarer_Text^
            +' NETPIC / Jim Tucker [4.2] '+puffer_zu_zk_e(codepuffer.d[$71],'>',255),packer_exe);
        '-':ausschrift(textz_exe__ausfuehrbarer_Text^
            +' NETSEND / Jim Tucker [1.00] '+puffer_zu_zk_e(codepuffer.d[$70],'_',255),packer_exe);
        '<':ausschrift(textz_exe__ausfuehrbarer_Text^
            +' NETRUN / Jim Tucker [3.10] '+puffer_zu_zk_e(codepuffer.d[$2e],'>',255),packer_exe);
      else
            ausschrift(textz_exe__ausfuehrbarer_Text^
            +' NET??? / Jim Tucker ¯',packer_exe)
      end;

  end;

procedure exe_59;far;
  begin
{!!    if bytesuche_codepuffer_0(#$59#$83#$e9#$04#$5e#$2b#$ce#$83#$e1) then
      ausschrift('Coder /}

  end;

procedure exe_5a;far;
  begin
    if bytesuche_codepuffer_0(#$5a#$0e#$1f#$b4#$09) then
      begin
        (* XX_EXE: CHARMAP.EXE WIN 3.10 *)
        ausschrift(textz_exe__Ausschrift^+'MS C',signatur);
        ansi_anzeige(analyseoff+codeoff_seg*16+stack_inhalt
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)

        (* Korrektur: ESSVSD88.DLL *)
        x_exe_stub_fehler;
      end;

  end;

procedure exe_5b;far;
  var
    carmel_text_pos     :dateigroessetyp;
    w1                  :word_norm;
  begin
    if bytesuche_codepuffer_0(#$5b#$81#$eb'??'#$1e#$06#$50#$51#$52#$53#$54#$55#$56#$57#$06#$1e#$8b#$eb#$b4#$30#$cd#$21) then
      begin
        w1:=codeoff_off-word_z(@codepuffer.d[3])^;
        ausschrift('VSS / Ralph Roth',packer_exe);
        exezk:=datei_lesen__zu_zk_zeilenende(ds_off+w1);
        if Pos('VSS',exezk)=1 then
          ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
      end;

    if bytesuche_codepuffer_0(#$5b#$83#$c3'?'#$90#$8b#$d3#$e8#$01#$00'?'#$5b#$2e#$80) then
      trap('1.20');

    if bytesuche_codepuffer_0(#$5b#$81#$eb'??'#$8b#$eb#$66#$51#$66#$53#$66#$50#$66#$b9) then
      begin
        case word_z(@codepuffer.d[3])^ of
          $318:exezk:='1.2';
        else
               exezk:='?.?';
        end;
        ausschrift('aTEU / MaX / MovSD ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$5B#$2E#$89#$47#$FB) then
      begin
        w1:=puffer_pos_suche(codepuffer,#$3c'?'#$73#$32,40);
        if w1=nicht_gefunden then
          exezk:=''
        else
          exezk:='.'+str0(codepuffer.d[w1+1]);

        ausschrift('Vacsina.TP'+exezk+' / T.P.',virus);
      end;

    if bytesuche_codepuffer_0(#$5B#$50#$8C#$C0#$05) then
      if codepuffer.d[9]=$1E then
        begin
          (* bei FORMAT.COM MS-DOS 5.00 *)
          ausschrift(textz_exe__Konverter^+' EXE -> COM / MS',signatur);
          (* nur beim ersten Mal:

          1. jmp code
          2. exe
          3. code
          4. *)
          if bytesuche__datei_lesen(analyseoff+ds_off+$110,'MZ') then
            einzel_laenge:=$10

          else
          if bytesuche(codepuffer.d[$70-3],#$ff#$6f#$f5) then
            einzel_laenge:=$73;


          if codeoff_off>$100+einzel_laenge then
            befehl_schnitt(analyseoff+ds_off+$100+einzel_laenge,codeoff_off-3-$100-einzel_laenge,
              erzeuge_neuen_dateinamen('.EXE'));

        end
      else
        ausschrift('Vacsina <2> '+textz_exe__Konverter^+' EXE -> COM ',virus);


    if bytesuche_codepuffer_0(#$5B#$81#$EB'??'#$2E) then
      begin
        if bytesuche_codepuffer_0(#$5b#$81#$eb#$f5#$02#$2e#$8c#$9f#$08#$00#$2e#$89#$87#$0a) then
          begin
            (* PROT!!.EXE "* * *  Bad Copy  * * *" *)
            ausschrift(' ??? <EXE-File Defender / Varavva Brothers [2.0]>',packer_exe);
            exit;
          end;

        ausschrift('Yankee "Doodle" / TP [44] ',virus);
      end;

    if bytesuche_codepuffer_0(#$5b#$81#$eb'??'#$b9'??'#$2e#$80#$37)
    or bytesuche_codepuffer_0(#$5b#$b9'??'#$81#$eb'??'#$2e#$80#$37)
     then
      ausschrift('Fish#6',virus);

    if bytesuche_codepuffer_0(#$5B#$8C#$C8#$2E#$03#$47#$06#$2E#$03#$47#$08) then
      case codepuffer.d[$17] of
        (* HANGMAN.EXE [COM] *)
        $A0:ausschrift('Turbo/Borland Pascal 2.? 1984',compiler);
        (* PRINTER UTILS *)
        $95:ausschrift('Turbo/Borland Pascal 2.? 1983',compiler);
        $8D:ausschrift('Surpas/Tixaku Pascal [1.0]',compiler);
      else
        ausschrift('Pascal? ¯',compiler);
      end;

    if bytesuche_codepuffer_0(#$5B#$81#$EB'??'#$50#$51#$52) then
      begin
        (* Test mit TNT 8.50 EXE und COM *)
        ausschrift('TNT-AV , CP-AV , MS-AV / Yuval Sherman & Eli Shapira',signatur);
        carmel_text_pos:=datei_pos_suche(analyseoff+codeoff_seg*16+codeoff_off,
                                         analyseoff+codeoff_seg*16+codeoff_off+$300,
                                         #$b8#$01#$4c#$cd#$21);

        if carmel_text_pos<>nicht_gefunden then
          ansi_anzeige(carmel_text_pos+3+2,
            '$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');

        pklitekopf:=falsch;
        kopftext_nullen;
      end;

  end;

procedure exe_5d;far;
  var
    exe_tmp_puffer:puffertyp;
  begin
    if bytesuche_codepuffer_0(#$5d#$81#$ed'??'#$b4#$09#$8d#$96'??'#$cd#$21#$bf#$00#$01#$8d#$b6'??'#$a5) then
      begin
        ausschrift('COM Tagger / Ghiribizzo [OR&L/uCF] [1.3]',packer_exe);
        ansi_anzeige(analyseoff+codeoff_off+16*longint(codeoff_seg)+$1d,
         '$',ftab.f[farblos,hf]+ftab.f[farblos,vf],vorne,wahr,wahr,unendlich,'');
      end;

    if bytesuche_codepuffer_0(#$5d#$8c#$cb#$83#$c3#$10#$53#$81#$ed#$f3#$00#$55#$cb#$8b#$fd#$81#$ef#$10#$01) then
      ausschrift('ExeConv / Conea Software [3.06]',packer_exe); (* ohne Parameter oder mit /V *)

    if bytesuche_codepuffer_0(#$5d#$81#$ed'??'#$45#$8c#$d6#$8b#$fc#$0f#$23#$c7#$0f#$23#$ce) then
      trap('1.26'); (* EXE/COM *)

    if bytesuche_codepuffer_0(#$5d#$81#$ed#$03#$00#$1e#$06#$0e#$1f#$b4#$02#$8d#$b6) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<Phrozen Crew>',packer_exe);

    if bytesuche_codepuffer_0(#$5d#$81#$ed#$06#$01#$e8) then
      begin
        ausschrift('VCL-'+textz_exe__Verschluesselung^,virus); (* 30.09.1996 Veit *)
        if bytesuche(codepuffer.d[$f6-6],'*.COM') then
          ausschrift('DEBUG-Bombe / Cheat Machine 2.04',virus);
      end;

    if bytesuche_codepuffer_0(#$5D#$83#$ED#$03#$fa#$fc#$33#$f6) then
      begin
        datei_lesen(exe_tmp_puffer,analyseoff+longint(codeoff_seg)*16+codeoff_off-$28+$2ca,$20);
        ausschrift('USERNAME / Jordi Mas Hern†ndez [3.00 .COM] "'+username300_pw(exe_tmp_puffer)+'"',packer_exe);
      end;

    (* EINZELFALL GA.COM
    if bytesuche_codepuffer_0(#$5d#$81#$ed'??'#$9c#$58#$8b#$c8#$25) then
      ausschrift('GA / Stefan Verkoyen [1.0, +386]',packer_exe);
    *)

  end;

procedure exe_5e;far;
  var
    tai_pan_laenge:dateigroessetyp;
  begin
    {baum}
    if bytesuche_codepuffer_0(#$5e#$1e#$b9'??'#$bb'??'#$2b#$cb#$b8'??'#$83#$e0'?'#$8b#$d8) then
      ausschrift('Lock-King / Double-Star Computer [2.0a]',packer_exe);

    if bytesuche_codepuffer_0(#$5e#$8b#$ee#$81#$ed#$03#$01#$8d#$b6#$16#$01#$b9'??'#$f6#$14) then
      begin
        case word_z(@codepuffer.d[$c])^ of
          $010a:exezk:='1.0 beta';
        else
                exezk:='1.? ¯';
        end;
        ausschrift('COM file protect / B!Z0n ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$5e#$83'??'#$90#$b9'??'#$8c#$d8#$05#$10#$00#$2e#$c4#$3c#$8c#$c3#$03#$d8) then
      ausschrift(textz_exe__unbekannte_Relokations_Kompression^+'<SCANEXE.2.00>',packer_exe);

    if bytesuche_codepuffer_0(#$5e#$83#$ee#$03#$b8#$ce#$7b#$cd#$21) then
      begin
        (* 21.09.1997 Raimond Kîhler *)
        tai_pan_laenge:=einzel_laenge-codeoff_seg*16-codeoff_off+3;
        ausschrift('Tai-Pan ['+str0_DGT(tai_pan_laenge)+']',virus);
      end;

    if bytesuche_codepuffer_0(#$5e#$81#$ee#$03#$01#$56#$e8'?'#$ff#$5e) then
      ausschrift('VCS-'+textz_exe__Verschluesselung^,virus);

    if bytesuche_codepuffer_0(#$5e#$8c#$c8#$2e#$03#$44#$06#$2e) then
      (* APRUN210 *)
      ausschrift(textz_exe__fraglich_doppelpunkt^+'Turbo/Borland Pascal 3 (APRUNE210)',compiler);

    if bytesuche_codepuffer_0(#$5e#$fc)
    or bytesuche_codepuffer_0(#$5e#$81)
      then eddie_test(codepuffer);

  end;

procedure exe_5f;far;
  begin
    if bytesuche_codepuffer_0(#$5f#$fc)
    or bytesuche_codepuffer_0(#$5f#$81)
      then eddie_test(codepuffer);

  end;

procedure exe_60;far;
  begin

    if bytesuche_codepuffer_0(#$60#$1e#$06#$e8#$0b#$00#$ea#$eb#$16#$e1#$0e#$eb#$07) then
      begin
        case codepuffer.d[$27] of
          $b8:exezk:='2.0';
          $52:exezk:='4.7';
        else
              exezk:='?.? ¯';
        end;
        ausschrift('EXE_PROTECTOR / FAG ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$60#$33#$db#$8e#$db#$8b#$f3#$b9#$40#$00#$ad#$50#$e2#$fc#$8b#$f3#$e8) then
      (* EXE -> Y Y N *)
      (* EXE -> Y N N *)
      (* EXE -> N Y N *)
      (* EXE -> N N N *)
      (* 5.0 *)
      ausschrift('EXE_PROTECTOR / FAG [5.0 8 BIT]',packer_exe);

    if bytesuche_codepuffer_0(#$60#$8b#$ec#$b0#$26#$34#$08#$8a#$e0#$b9#$80#$00#$50#$e2#$fd#$93#$b8) then
      (* EXE -> ? ? N *)
      ausschrift('EXE_PROTECTOR / FAG [6.0 8 BIT]',packer_exe);

    if bytesuche_codepuffer_0(#$60#$bb'??'#$be#$16#$01#$bf#$5f#$01#$8b#$cf#$03#$fb#$57) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<UNIUBC2/???>',packer_exe);
  end;

procedure exe_66;far;
  begin
    if bytesuche_codepuffer_0(#$66#$b8#$01#$09#$cd#$31#$66#$b8#$ff#$ff) then
      ausschrift('PEStub / Michael Tippach [0.1]',dos_win_extender);

    if bytesuche_codepuffer_0(#$66#$b8#$01#$09#$cd#$31#$2b#$c0#$b9) then
      (* WDOSX 0.91, 0.95 1UP, ... *)
      ausschrift('PEStub / Michael Tippach [0.1?]',dos_win_extender);


    if bytesuche_codepuffer_0(#$66#$b8#$01#$09#$cd#$31#$8c#$05#$08#$00#$00#$00#$1e) then
      ausschrift('WDOSX / Michael Tippach [$LDR 0.95]',dos_win_extender);
  end;

procedure exe_68;far;
  begin

    if bytesuche_codepuffer_0(#$68'?'#$00#$0e#$68#$00#$01#$55#$89#$e5#$1e#$57#$83#$6e#$08#$04#$c5) then
      begin
        ausschrift('AC / Veit Kannegieser [COMFIX,11/97]',packer_exe);
        einzel_laenge:=longint(codeoff_seg)*16+codeoff_off+$30;
        zeige_ueberhang_nicht_an:=wahr;
      end;

    if bytesuche_codepuffer_0(#$68#$00#$01#$fd#$60#$be'??'#$bf) then
      begin
        case word_z(@codepuffer.d[9])^ of

          $ffd3:exezk:='[0.55 -m1]';
          $ff48:exezk:='[0.55 -m2]';
        else
          exezk:='[?.?]';
        end;
        ausschrift('TPack / TUSCON '+exezk,packer_exe);
      end;
  end;



const
  exe_verteiler:array[0..255] of prozedur_exe_typ=
   (exe_00,
    exe_nichts,
    exe_nichts,
    exe_03,
    exe_nichts,
    exe_05,
    exe_06,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_0e,
    exe_0f,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_16,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_1e,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_2b,
    exe_nichts,
    exe_nichts,
    exe_2e,
    exe_nichts,
    exe_nichts,
    exe_31,
    exe_nichts,
    exe_33,
    exe_nichts,
    exe_nichts,
    exe_36,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_3a,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_42,
    exe_43,
    exe_nichts,
    exe_nichts,
    exe_46,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_4b,
    exe_nichts,
    exe_4d,
    exe_4e,
    exe_nichts,
    exe_50,
    exe_51,
    exe_52,
    exe_53,
    exe_54,
    exe_55,
    exe_56,
    exe_57,
    exe_58,
    exe_59,
    exe_5a,
    exe_5b,
    exe_nichts,
    exe_5d,
    exe_5e,
    exe_5f,
    exe_60,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_66,
    exe_nichts,
    exe_68,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_81,
    exe_nichts,
    exe_83,
    exe_nichts,
    exe_nichts,
    exe_86,
    exe_87,
    exe_nichts,
    exe_nichts,
    exe_8a,
    exe_8b,
    exe_8c,
    exe_8d,
    exe_8e,
    exe_nichts,
    exe_90,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_95,
    exe_96,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_9c,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_b4,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_b8,
    exe_b9,
    exe_ba,
    exe_bb,
    exe_bc,
    exe_bd,
    exe_be,
    exe_bf,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_c7,
    exe_c8,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_cc,
    exe_cd,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_e4,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_f6,
    exe_nichts,
    exe_f8,
    exe_f9,
    exe_fa,
    exe_fb,
    exe_fc,
    exe_fd,
    exe_nichts,
    exe_nichts);

(* €€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€ *)


procedure durchsuchen;

  begin
    (*$IfNDef PROFILER*)
    pklitekopf:=falsch;
    pktinykopf:=falsch;

    if bytesuche(kopftext[0],#4'??PK') then
      begin
        pktinykopf:=wahr; (* PKTINY *)
        pkliteversion:=textz_exe__KOPF^+pkver(ord(kopftext[2]),ord(kopftext[1]));
      end;

    if (kopftextlaenge>5) and (length(kopftext)>10) and (bytesuche(kopftext[3],'PKLITE') or bytesuche(kopftext[3],'PKlite'))
     then
      begin
        pklitekopf:=wahr;
        pkliteversion:=pkver(ord(kopftext[2]),ord(kopftext[1]));
      end;

    trace(codepuffer);

    (*$IfDef ERWEITERUNGSDATEI*)
    suche_erweiterungen(codepuffer);
    (*$EndIf*)

    (*$IfDef GTDATA*)
    //
    suche_gtdata(gt_exe_0j ,codepuffer.d[0]);
    suche_gtdata(gt_exe_1j ,codepuffer.d[0]);
    suche_gtdata(gt_exe_1lj,codepuffer.d[0]);
    suche_gtdata(gt_exe_2j ,codepuffer.d[0]);
    (*$EndIf*)


    exe_verteiler[codepuffer.d[0]];
    (*$IfDef VirtualPascal*)
    busch_suche(Ptr(Ofs(exe_busch))^,codepuffer.d[0]);
    (*$Else*)
    busch_suche(Ptr(Seg(exe_busch),Ofs(exe_busch))^,codepuffer.d[0]);
    (*$EndIf*)

    dec(herstellersuche);

    if kopftext='diet' then ausschrift('Diet'      +textz_exe__Kopf_aber_kein_Kode_gefunden^,signatur);
    if kopftext='LZ09' then ausschrift('LzExe 0.90'+textz_exe__Kopf_aber_kein_Kode_gefunden^,signatur);
    if kopftext='LZ91' then ausschrift('LzExe 0.91'+textz_exe__Kopf_aber_kein_Kode_gefunden^,signatur);
    if kopftext='WWP ' then ausschrift('WWpack'    +textz_exe__Kopf_aber_kein_Kode_gefunden^,signatur);
    if kopftext='UC2X' then ausschrift('UCEXE'     +textz_exe__Kopf_aber_kein_Kode_gefunden^,signatur);
    if copy(kopftext,1,2)='RT'
                       then ausschrift('ROSETINY'  +version_x_y(ord(kopftext[3]),ord(kopftext[4]))+
                                                   +textz_exe__Kopf_aber_kein_Kode_gefunden^,signatur);
    if pklitekopf      then ausschrift('Pklite'    +textz_exe__Kopf_aber_kein_Kode_gefunden^,signatur);
(*  PKTINY ist in TYP_POLY
    if pktinykopf      then ausschrift('PKTiny'    +textz_exe__Kopf_aber_kein_Kode_gefunden^,signatur); *)

    inc(herstellersuche);
    (*$EndIf*)
  end;

end.

