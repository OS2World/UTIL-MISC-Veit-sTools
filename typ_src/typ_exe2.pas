(*$I TYP_COMP.PAS*)
unit typ_exe2;

interface

var
  extratext                                 :longint;
  pklitekopf,pktinykopf                     :boolean;
  pkliteversion                             :string[80];

function bytesuche_codepuffer_0(const s:string):boolean;


(* $80..$ff *)

procedure exe_81;far;
procedure exe_83;far;
procedure exe_86;far;
procedure exe_87;far;
procedure exe_8a;far;
procedure exe_8b;far;
procedure exe_8c;far;
procedure exe_8d;far;
procedure exe_8e;far;
procedure exe_90;far;
procedure exe_95;far;
procedure exe_96;far;
procedure exe_9c;far;
procedure exe_b4;far;
procedure exe_b8;far;
procedure exe_b9;far;
procedure exe_ba;far;
procedure exe_bb;far;
procedure exe_bc;far;
procedure exe_bd;far;
procedure exe_be;far;
procedure exe_bf;far;
procedure exe_c7;far;
procedure exe_c8;far;
procedure exe_cc;far;
procedure exe_cd;far;
procedure exe_e4;far;
procedure exe_f6;far;
procedure exe_f8;far;
procedure exe_f9;far;
procedure exe_fa;far;
procedure exe_fb;far;
procedure exe_fc;far;
procedure exe_fd;far;

implementation

uses
  typ_type,
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
  typ_for4,
  typ_spra,
  typ_exe0,
  typ_xexe,
  typ_kopf,
  typ_entp,
  buschsuc,
  typ_posm;


(*$I TYP_EXEI.PAS*)

procedure exe_81;
  begin
    if bytesuche_codepuffer_0(#$81#$fc'??'#$77#$02#$cd#$20#$b9'??'#$be'??'#$bf'??'#$bb#$00#$80#$fd#$f3#$a4
      +#$fc#$87#$f7#$83) then
      ausschrift_upx_version(codepuffer,codepuffer,$1c,81,255,'dos/com');
  end;

procedure exe_83;
  begin

    if bytesuche_codepuffer_0(#$83#$EC#$10#$83#$E4#$E0) then
      begin
        (* Test mit Tinyprog 3.6 *)
        exezk:='';
        if bytesuche(codepuffer.d[$AA-$74],#$EE#$B9) then
          exezk:=textz_exe__komma_mit_Kennwort^;

        extratext:=x_word__datei_lesen(analyseoff+ds_off+$100+$1)-1;

        if extratext>0 then
          exezk_anhaengen(textz_exe__komma_mit^+str0(extratext)+textz_exe__Byte_Programmdaten^);

        if bytesuche(analysepuffer.d[28],'tz') then
            ausschrift('TinyProg / Tranzoa '+str0(analysepuffer.d[30]-$C0)+'.X'+exezk,packer_exe)
        else
          begin
            ausschrift('TinyProg / Tranzoa '+textz_exe__veraenderter_Kopf^+'!'+exezk,packer_exe);
            kopftext_anzeige('',packer_exe);
          end;

        if (copy(kopftext,1,2)='RT') then (* schon abgeklemmt ... [CUP] *)
          begin
            ausschrift('ROSETINY / Ralph Roth'+version_x_y(ord(kopftext[3]),ord(kopftext[4])),packer_exe);
            kopftext_nullen;
            extratext:=0;
          end
        else
          if (puffer_pos_suche(codepuffer,'ROSE',$100)<>nicht_gefunden) then
            begin
              ausschrift('ROSETINY / Ralph Roth [0.96]',packer_exe);
              kopftext_nullen;
              extratext:=0; (* 644 *)
            end;

        if extratext=722 then
          begin
            ausschrift('TBNLOCK-PKLITE '+textz_exe__Kopf^+' / Andreas Fiedler',packer_exe);
            extratext:=0; (* 722 *)
          end;

        if extratext>0 then
          (* eigentlich    CS+0000:0000
             aber MEGALITE CS:FFF0:0100 *)
          ansi_anzeige(analyseoff+ds_off+$100+$3
          ,#$1a,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    if bytesuche_codepuffer_0(#$83#$e4#$fc#$9c#$55#$57) then
      ausschrift(textz_exe__Entschluesseler_zu_Scorpion_Kopierschutz^,packer_exe);
  end;

procedure exe_86;
  begin
    if bytesuche_codepuffer_0(#$86#$c0#$eb'?'#$0d) then
      ausschrift('AngehÑngtes Programm "'+puffer_zu_zk_e(codepuffer.d[5],^z,120)+'" / AC Veit Kannegieser',beschreibung);
  end;

procedure exe_87;
  begin
    if bytesuche_codepuffer_0(#$87#$db#$b8'??'#$15'??'#$72'?') then
      ausschrift('Thunderbyte EXE - '+textz_exe__Verschluesselung^+' <87>',packer_exe);

  end;

procedure exe_8a;
  begin
    if bytesuche_codepuffer_0(#$8a#$f6#$87#$c9#$b8#$01#$fa#$ba'EY'#$87#$c9#$e8#$00#$00) then
      trap('1.13 SW');
  end;

procedure exe_8b;
  begin
    if bytesuche_codepuffer_0(#$8b#$c4#$2d'??'#$24#$00#$8b#$f8#$57) then
      begin
        ausschrift(textz_exe__unbekannte_Kompression^+'<ARI/RAO Inc.>',packer_exe);
        ausschrift(textz_exe__WARNUNG_Programm_ist_nur_mit_CH_0_startbar^,dat_fehler);
      end;

    if bytesuche_codepuffer_0(#$8b#$e8#$ba'??'#$b4#$09#$cd#$21#$2e#$a1#$09#$01) then
      ausschrift('ExeCode / Bal†zs Scheidler [1.0 '+textz_exe__unregistriert^+']',packer_exe);

  end;

procedure exe_8c;
  var
    exe_tmp_puffer      :puffertyp;
    w1                  :word_norm;
  begin

    if bytesuche_codepuffer_0(#$8c#$da#$8e#$c2#$b8'??'#$8e#$d8#$8c#$06'??'#$bb#$00#$00#$81#$c3'??'
        +#$80#$e3#$f0#$8e#$d0#$8b#$e3#$d1#$eb#$d1#$eb) then
      begin
        ausschrift('Watcom W32RUN.EXE loader (DOS)',dos_win_extender);
        datei_lesen(exe_tmp_puffer,analyseoff+ds_off+$100,$26);
        if bytesuche(exe_tmp_puffer.d[0],'CF') then
          begin
            merke_position(analyseoff+longint_z(@exe_tmp_puffer.d[4])^                                  ,datentyp_w32run_fc);
            merke_position(analyseoff+longint_z(@exe_tmp_puffer.d[4])^+longint_z(@exe_tmp_puffer.d[12])^,datentyp_unbekannt);
          end;
      end;


    if bytesuche_codepuffer_0(#$8c#$ca#$8e#$da#$e8'?'#$00#$73#$07#$ba'??'#$b0#$ff#$eb'?'#$8c#$c0#$8e) then
      begin
        ausschrift('STUB4GW / Vladimir Arnost [1.10]',dos_win_extender);
        ansi_anzeige(analyseoff+ds_off+$100,#$8c,
          ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    if bytesuche_codepuffer_0(#$8c#$cf#$83#$ef#$10#$57#$b9'??'#$51#$cb#$b4#$30#$cd#$21) then
      begin
        (* ARK 1.0.1 *)
        w1:=puffer_pos_suche(codepuffer,#$89#$56#$0c#$8d#$55'?'#$89,512);
        if w1<>nicht_gefunden then
          ark101((codeoff_seg+longint(codepuffer.d[w1+5])-$10)*16);
      end;

    if bytesuche_codepuffer_0(#$8c#$cb#$8d#$bf'??'#$57#$b9'??'#$ba'??'#$be) then
      (* 0.05 *)
      ausschrift_upx_version(codepuffer,codepuffer,0,005,005,'');

    if bytesuche_codepuffer_0(#$8c#$cb#$b9'??'#$be'??'#$89#$f7#$1e#$a9#$b5#$80) then
      ausschrift_upx_version(codepuffer,codepuffer,$3b-4,0,255,'dos/exe');

    if bytesuche_codepuffer_0(#$8c#$d8#$1e#$e8#$00#$00#$5d#$83#$c0#$0f#$81) then
      ausschrift('REC/Small / Ralph Roth [1.01]',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$d8#$1e#$e8#$00#$00#$83#$c0'?'#$5d) then
      begin
        (*w1:=puffer_pos_suche(codepuffer,#$eb#$00#$ea,512);
        if w1<>0 then
          inc(w1,11);*)

        case codepuffer.d[15] of
          $ba:exezk:='1.02';     (* erkennt auch einige "1.02b" *)
          $eb:exezk:='1.02a';    (* 70 Byte *)
          $ea:exezk:='1.02b,1.03';
          $cc:exezk:='/AV 1.01'; (* REC/AV 1.01 *)
        else
              exezk:='1.?? ¯'(*' (.'+str0(w1)+')'*);
        end;
        ausschrift('REC/Small / Ralph Roth ['+exezk+']',packer_exe);
      end;


    if bytesuche_codepuffer_0(#$8c#$d8#$1e#$e8'??'#$b4#$09#$e8'??'#$07#$0d#$0a) then
      begin
        if codepuffer.d[$e]<>$0d then
          ausschrift('REC/SMALL/AV / Ralph Roth [1.02]',packer_exe)
        else
          begin
            exezk:=datei_lesen__zu_zk_pstr(analyseoff+codeoff_seg*16+org_code_off+1);
            if bytesuche(exezk[1],#$0d#$0a) then
              exezk:=leer_filter(exezk)
            else
              exezk:='';
            if exezk<>'' then
              exezk:=' '+in_doppelten_anfuerungszeichen(exezk);
            ausschrift('REC/SMALL/AV / Ralph Roth [1.03/4/5/6]'+exezk,packer_exe);
          end;
      end;

    if bytesuche_codepuffer_0(#$8c#$d1#$ba#$99#$cb#$8e#$d2#$33#$d2#$8e#$d1#$8b#$ca) then
      begin
        if bytesuche(codepuffer.d[$d],#$b9#$e8#$03) then
          trap('1.14')
        else if bytesuche(codepuffer.d[$d],#$eb#$04) then
          trap('1.13(a)')
        else if bytesuche(codepuffer.d[$d],#$eb#$05) then
          trap('1.13b')
        else
          trap('1.?? ¯');
      end;

    if bytesuche_codepuffer_0(#$8c#$d0#$bb#$99#$cb#$90#$8e#$d3#$33#$db#$8e#$d0) then
      (* EXE 1.16· *)
      trap('1.16·');

    if bytesuche_codepuffer_0(#$8c#$d0#$bb#$99#$cb#$8e#$d3#$33#$c9#$8e#$d0) then
      (* EXE 1.16 *)
      begin
        case codepuffer.d[$57] of
          $7b:trap('1.16');
          $e2:trap('1.17.1');
          $e9:trap('1.17.2');
          $0f:trap('1.18');
        else
              trap('1.16/7? ¯');
        end;
      end;

    if bytesuche_codepuffer_0(#$8c#$d0#$bb#$99#$cb#$8e#$d3#$33#$db#$8e#$d0#$8b#$c3) then
      (* EXE 1.16· 2 *)
      trap('1.16·2');

    if bytesuche_codepuffer_0(#$8c#$d0#$bb#$99#$cb#$8e#$d3#$33#$d2#$8e#$d0#$b9'??'#$eb) then
      trap('1.19');


    if bytesuche_codepuffer_0(#$8c#$da#$0e#$1f#$01#$16'??'+'????'+'????'+#$01#$16'??'#$eb#$00) then
      ausschrift(textz_exe__Anpasser_von^+'REKOMB / Veit Kannegieser (1/1998)',signatur);

    if bytesuche_codepuffer_0(#$8c#$ca#$b8'??'#$03#$d0#$8c#$c9#$81#$c1'??'#$51#$b9) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<BSL.EXE[2]/Thomas "Beret" Kawecki>',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c8#$05'??'#$50#$b8'??'#$50#$cb) then
      begin
        case word_z(@codepuffer.d[7])^ of
          $190:exezk:='2.1b';
        else
          exezk:='?.? ¯';
        end;
        ausschrift('Secure / G.M.McKay ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$8c#$ca#$8e#$da) then
      (* TESTVID.EXE *)
      ds_off:=codeoff_seg*16;

    if bytesuche_codepuffer_0(#$8c#$ca#$2e#$89#$16#$cd#$eb#$b4#$1e#$cd#$21#$8b#$2e#$02#$00#$8b#$1e#$2c#$00#$8e#$da) then
      begin
        (* fds0ft c0m pr0tect v0.0 - no anti-debug shit at all yet :-) *)
        ausschrift('fds-cp / fds0ft [0.0]',packer_exe); (* FDS000.COM *)
        Exit;
      end;


    if bytesuche_codepuffer_0(#$8c#$ca#$2e#$89#$16'??'#$b4#$30#$8b#$2e#$02#$00#$8b#$1e#$2c#$00) then
      begin
        ausschrift('fds-cp / fds0ft [0.4a] ≥ jmt-cp / JauMing Tseng [0.5a]',packer_exe);
        Exit;
      end;


    if bytesuche_codepuffer_0(#$8c#$ca#$2e#$89#$16#$cd#$eb#$b4#$30#$cd#$21#$8b#$2e#$02#$00#$8b#$1e#$2c#$00#$8e#$da) then
      begin
        (* XPACK 1.67.[ml] *)
        ausschrift('jmt-cp / JauMing Tseng [0.5?]',packer_exe);
        Exit; (* kein BC! *)
      end;

    if bytesuche_codepuffer_0(#$8c#$da#$8c#$c8#$8e#$d8#$a3'??'#$89#$16'??'#$8e#$c2) then
      begin
        ausschrift('STUB LSxPower / Laserstars Technologies',dos_win_extender);
        ansi_anzeige(analyseoff+$40,#$1a,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    if bytesuche_codepuffer_0(#$8c#$c5#$8c#$c8#$8e#$d8#$a3'??'#$a3'??'#$a3'??'#$b4#$30) then
      ausschrift('WIN.COM-'+textz_exe__Starter^+' Screen Thief / Nildram Software',signatur);

    if bytesuche_codepuffer_0(#$8c#$cb#$8b#$c4#$b1#$04#$d3#$e8#$40#$03#$d8#$8c#$d8#$2b#$d8#$b4) then
      ausschrift('DOS32-'+textz_exe__Lader^+' / Adam Seychell 3.0',dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$d8#$8c#$cb#$2b#$d8#$8b#$c4#$b1#$04) then
      ausschrift('DOS32-'+textz_exe__Lader^+' / Adam Seychell 3.3',dos_win_extender);

    if bytesuche_codepuffer_0(#$8C#$D3#$8E#$C3#$8C) then
      begin
        case codepuffer.d[$4e] of
          $83:exezk:='-m1';
          $be:exezk:='-m2';
        else
              exezk:='-m???';
        end;
        (* Pro-Pack 2.08 bei M-Pockets intro.exe *)
        ausschrift('Pro-Pack / Rob Northen Computing [2.08 '+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$8C#$CB#$8E#$DB#$8C#$06) then
      (* DSA2 *)
      ausschrift(textz_exe__unbekannte_Overlay_Kompression^+'<Pocket Soft> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$8C#$C8#$8E#$D8#$8c#$1e#$42#$00#$8c#$06#$3c#$00) then
      ausschrift('Borland PE-'+textz_exe__Lader^,dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$c8#$8c#$db#$8e#$d8#$8e#$c0#$89#$1e) then
      begin
        ausschrift('SARC / SEA [6.02]',dos_win_extender);
        ausschrift(textz_exe__Vermutung_des_Archives_EXE_Kopflaenge_stimmt_nicht^,signatur);
        einzel_laenge:=codeoff_seg*16+codeoff_off+exe_kopf.sp_wert;
      end;

    if bytesuche_codepuffer_0(#$8c#$dd#$83#$c5#$10#$fc#$31#$c0#$bb'??'#$b9'??'#$fa) then
      ausschrift(textz_exe__unbekannter_DONGEL_Schutz^+'<Tedi>',packer_dat);

    if bytesuche_codepuffer_0(#$8C#$C8#$8E#$D8#$8E#$D0#$BC'??'#$A3) then
      begin
        (* Derive *)
        ausschrift('SOFT-Warehouse muLISP-90',compiler);
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$8C#$CA#$2E#$89#$16'??'#$B4#$30#$CD#$21)
    or bytesuche_codepuffer_0(#$8C#$CA#$B4#$30#$CD#$21#$2E#$89#$16'??')
     then
      (* SPEECH.EXE zu ULTIMA 8 *)
      begin
        tc_verfolgung(codepuffer);
        if einzel_laenge=$1906 then (* scrpaint *)
          thegrab($1906-161*25-18,25,161,'');
        if codepuffer.d[2]=$b4 then
          ausschrift('ProtUPC / DaRKMaN/TPiNC',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$8C#$CA#$2E#$89#$16'??'#$8b#$2e'??'#$8b#$1e)
     then
      (* EVERY.COM *)
      tc_verfolgung(codepuffer);

    if bytesuche_codepuffer_0(#$8C#$CA#$8c#$dd#$8e#$da#$81#$ea) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<X-OPEN PLUSES / Guy Shattah>',packer_exe);

    if bytesuche_codepuffer_0(#$8C#$D8#$BB'??'#$8E#$DB#$BA) then
      ausschrift('Overlay-'+textz_exe__Lader^+' [A-Train]',overlay_);

    if bytesuche_codepuffer_0(#$8C#$D8#$33#$db#$8e#$d0#$8b#$e3#$53#$50) then
      ausschrift('VBasic WIN-'+textz_exe__Starter^+' / MS',compiler);

    if bytesuche_codepuffer_0(#$8c#$d8#$bb'??'#$8e#$db#$8b) then
      ausschrift(textz_exe__unbekannte_Overlayverwaltung_zu^+' ??? <eov>',overlay_); (* MUENZEN *)

    if bytesuche_codepuffer_0(#$8C#$CA#$8B#$2E#$02#$00#$8E#$DA) then
      (* HeartLight PC *)
      ausschrift(textz_exe__unbekannte_Kompression^+'<ADAMIK>',packer_exe);

    if bytesuche_codepuffer_0(#$8C#$C8#$8e#$d8#$8c#$c3#$81#$c3) then
      ausschrift(textz_exe__unbekannte_Relokations_Kompression^+'<ZIPSCRUB>',packer_exe);

    if bytesuche_codepuffer_0(#$8C#$C8#$8e#$d0#$bc'??'#$fb#$50#$53) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<HUMANS>',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c8#$8e#$d8#$8c#$c0#$a3#$14#$00) then
      begin
        ausschrift(textz_exe__unbekannte_Kompression^+'<SIMCITY.EXE/MAXIS>',packer_exe);
        ansi_anzeige(analyseoff+16*longint(codeoff_seg)+word_z(@codepuffer.d[$91-$40])^,
          '$',ftab.f[farblos,hf]+ftab.f[farblos,vf],absatz,wahr,wahr,unendlich,'');
      end;

    if bytesuche_codepuffer_0(#$8C#$db#$ba'??'#$b8'??'#$03#$d8#$3b#$1e) then
      begin
        ausschrift(textz_exe__unbekannte_Kompression^+'<GRABBER> / G.A.Monroe',packer_exe);
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$8C#$C0#$05#$10#$00#$0E#$1F#$A3#$04#$00) then
      begin
        if bytesuche(codepuffer.d[$1c],#$50) then
          begin
            if bytesuche(codepuffer.d[$48],#$74#$0A) then
              (* HDPARK UTILITY COMPUSOFT *)
              if codepuffer.d[$7f]=$56 then
                ausschrift('MS LINK /EXEPACK 4.00',packer_exe)
              else
                ausschrift('MS LINK /EXEPACK 4.03',packer_exe);

            if bytesuche(codepuffer.d[$48],#$74#$09) then
              (* RAILROAD *)
              ausschrift('MS LINK /EXEPACK 3.60 .. 3.65',packer_exe);
            if bytesuche(codepuffer.d[$48],#$8c#$da) then
              (* IBM PS/Valuepoint *)
              ausschrift('MS LINK /EXEPACK 4.?? <PS/Valuepoint> ¯',packer_exe);
          end
        else
          begin
            exezk:='?.?? ¯';
            if bytesuche(codepuffer.d[$48],#$89#$f0#$f7) then
              exezk:='4.05/4.06 + LOWFIX / Steve Burg';

            if bytesuche(codepuffer.d[$48],#$8b#$c6#$f7) then
              exezk:='4.05/4.06'; (* SIMCITY SETTINGS intern *)

            ausschrift('MS LINK /EXEPACK '+exezk,packer_exe);
          end;
      end;

    if bytesuche_codepuffer_0(#$8C#$C8#$8E#$D8#$E8'??'#$8A#$17) then
      (* Lasthalf of Darkness *)
      ausschrift('Microsoft QBasic [2] '+textz_exe__Laufzeitbibliothek^,compiler);

    if bytesuche_codepuffer_0(#$8c#$da#$01#$16#$0c#$01) then
      ausschrift(textz_exe__umgewandelte_EXE_Datei^+': SCRE2B (SCRNCH) / Graeme W. McRae',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$d8#$05#$10#$00#$8b#$d8#$05#$f0#$ff) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<FRACZOOM / Black Mind> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$d8#$05'??'#$50#$b8'??'#$50#$1e#$06#$8c#$da#$83) then
      (* in SBUST.EXE, gefunden von XO.EXE *)
      ausschrift(textz_exe__Rekokationskompression_von^+'Protect! [1.0] / Jeremy Lilley  (XO:Relocation 3)',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c8#$8e#$d8#$b4#$0f#$cd#$10#$3c#$07) then
      begin
        ausschrift(textz_exe__unbekannter_Textbildschirm^,musik_bild);
        thegrab(analyseoff+codeoff_off+16*longint(codeoff_seg)+$32,25,160,'');
      end;

    if bytesuche_codepuffer_0(#$8c#$c8#$8e#$d8#$8e#$c0#$e8'??'#$a3'??'#$e8) then
      begin
        datei_lesen(exe_tmp_puffer,analyseoff+$c,80);
        ausschrift('"'+puffer_zu_zk_e(exe_tmp_puffer.d[0],#0#13,255)+'" / The Audio Solution',bibliothek);
      end;

    if bytesuche_codepuffer_0(#$8c#$ce#$8c#$c7#$3b#$f7#$75) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<SOKOBALL / Jim Radcliffe> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$db#$8c#$ca#$8e#$da#$fa#$8b#$ec) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<UNPACK / VSF&K> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$d0#$8e#$d8#$8e#$c0#$bf'??'#$b9'??'#$2b#$cf) then
      begin
        ausschrift('Mark Williams C',compiler);
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$8c#$da#$03#$16'??'#$39#$16'??'#$73) then
      begin
        w1:=puffer_pos_suche(analysepuffer,'AVPACK',100); (* .COM *)
        if w1<nicht_gefunden then
          begin
            exezk:=version_x_y(analysepuffer.d[w1+7],analysepuffer.d[w1+6]);
            if analysepuffer.d[w1+8]=2 then
              exezk_anhaengen(' Extra');
            if analysepuffer.d[w1+8]=3 then
              exezk_anhaengen(' Kopierschutz');
          end
        else
          exezk:=' (?)';

        ausschrift('AVPACK / Andrei Volkov'+exezk,packer_exe);
      end;

    if bytesuche_codepuffer_0(#$8c#$c8#$8e#$c0#$8e#$d8#$e8) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<BRKARJ/UTG>',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c8#$8e#$d8#$8e#$d0#$bc'??'#$26#$a1'??'#$a3'??'#$8c#$06) then
      ausschrift('TaskMgr '+textz_exe__Lader^+' / Novell',dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$db#$8b#$16'??'#$b8#$00#$00#$8e#$d8#$8e#$c0#$b8'??'#$8e#$d0#$bc#$00#$01#$e8) then
      ausschrift('DPMS '+textz_exe__Lader^+' / Novell',dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$c8#$8e#$d8#$c6#$06#$00#$01#$ea#$c7#$06#$01#$01#$00) then
      ausschrift(textz_exe__unbekannter_Programmschutz^+'<DMC 2.0> / Adlersparre & Associates ¯',packer_exe);

  end;

procedure exe_8d;
  begin
    if bytesuche_codepuffer_0(#$8d#$26'??'#$e8'??'#$b8#$00#$4c#$cd#$21) then
      begin
        ausschrift('TXT2COM / Keith P. Graham [2.06]',compiler);
        suche_txt2com_titel($f50);
      end;

    if bytesuche_codepuffer_0(#$8d#$16#$ae#$00#$e8'??'#$8b#$ec#$83#$ec) then
      begin
        ausschrift('CHArc-SFX',packer_dat);
        if einzel_laenge=1734 then
          begin
            ausschrift(textz_exe__Korrektur_der_EXE_Laenge^,dat_fehler);
            einzel_laenge:=$73a;
          end;
      end;

  end;

procedure exe_8e;
  begin
    if bytesuche_codepuffer_0(#$8e#$06#$2c#$00#$33#$c0#$bf#$01#$00#$4f#$af#$75#$fc) then
      begin
        ausschrift('ANSI2COM / oZoNe/sMAUG [1.0]',compiler);
        thegrab(analyseoff+ds_off+$30a,24,80*2,'');
      end;
  end;

procedure exe_90;
  begin

    if bytesuche_codepuffer_0(#$90#$90#$90#$e9) then
      if bytesuche__datei_lesen(analyseoff+codeoff_seg*16+codeoff_off+3+3+word_z(@codepuffer.d[3+1])^,
        #$fc#$88#$26'??'#$53#$51#$52#$57) then
        COMPACKR;

    if bytesuche_codepuffer_0(#$90#$b8#$ff#$ff#$e7#$21#$33#$d2#$52#$be#$00#$01#$bd#$61#$01#$b9) then
      begin
        (* "P.S.A." *)
        case codepuffer.d[$d8] of
          $8f:exezk:='1.0a';
          $57:exezk:='1.01a';
        else
              exezk:='1.??';
        end;
        ausschrift('MegaShield / t-REX ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$90#$90#$e9#$59#$13#$b0) then
      begin
        ausschrift('VPART / Veit Kannegieser '+textz_exe__Hauptprogramm^,signatur);
        vpart_neu(codepuffer);
      end;

    if bytesuche_codepuffer_0(#$90#$90#$e9#$c0#$06'SSS') then
      ausschrift(textz_exe__unbekannte_Kompression^+'<1995CARD>',packer_exe);

    if bytesuche_codepuffer_0(#$90#$90#$90#$8c#$c8#$05'??'#$50#$6a) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<Magic Circle/Radical,TET>',packer_exe);

  end;

procedure exe_95;
  begin
    if bytesuche_codepuffer_0(#$95#$8C#$C0#$05#$10#$00#$0E#$1F) then
      ausschrift(textz_exe__unbekannte^+' EXEPACK-'+textz_exe__Version^+' (WordPerfect) ¯',compiler);

  end;

procedure exe_96;
  begin
    if bytesuche_codepuffer_0(#$96#$97#$57#$56#$58#$50#$35#$60#$3e#$86) then
      begin
        case codepuffer.d[$2f] of
          $70:exezk:='4.7';
          $7d:exezk:='5.0, 6.0'; (* EXE -> ??Y *)
        else
              exezk:='?.? ¯'
        end;
        (* nicht sauber 7 bit .. *)
        ausschrift('EXE_PROTECTOR / FAG ['+exezk+' 7 BIT]',packer_exe);
      end;
  end;

procedure exe_9c;
  begin
    if bytesuche_codepuffer_0(#$9c#$57#$51#$e8#$02#$00#$eb#$1a#$e8#$02#$00'??'#$5f#$b9'??'#$b8'??'#$2e#$87#$05#$2e) then
      hackstop('1.20'); (* 235 *)

    if bytesuche_codepuffer_0(#$9c#$58#$25#$ff#$fe#$50#$9d#$8b#$d4#$8c#$d3#$8e#$d3#$bc#$03#$00) then
      (* SS107SRC *)
      (*  [0.01·] *)
      ausschrift('N0Ps Shit Protector / Cyber Cop'+zusatzcodelaenge_zk,packer_exe); (* KAOT? *)

    if bytesuche_codepuffer_0(#$9c#$06#$1e#$60#$fd#$b9'??'#$bf'??'#$be'??'
      +#$f3#$a4#$8b#$f7#$46#$bf#$00#$01#$68'??'#$fc#$c3) then
      (* 1.00betaF *)
      begin
        exezk:='?.?? ¯';
        if codeoff_off=$100 then
          exezk:='1.00';
        if codeoff_off=$103 then
          exezk:='2.00';
        ausschrift('ExeLITE / Code Blasters ['+exezk+' .COM]',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$9c#$fa#$50#$53#$51#$52#$1e#$06#$56#$57#$ba'??'#$be'??'#$8b#$ca#$0e#$07#$49#$8b#$d9) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<CRKCOM/ST!LLS0N> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$9C#$50#$52#$0E#$53#$8B#$EC) then
      ausschrift(textz_exe__Softwareschutz^+' CRYPTO-BOX',packer_exe);

    if bytesuche_codepuffer_0(#$9C#$58#$2e#$a3'??'#$fa#$8c#$d0#$8b#$dc) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<INEXE 3.0/DEJAVUE>',packer_exe);

    if bytesuche_codepuffer_0(#$9C#$1e#$06#$50#$53#$51#$52#$57#$56#$55#$8b)
    or bytesuche_codepuffer_0(#$9C#$1e#$06#$53#$51#$57#$56#$55#$83)
     then
      begin
        ausschrift('Creative Labs '+textz_exe__Klangtreiber^,bibliothek);
        ansi_anzeige(analyseoff+codeoff_seg*16+$103
          ,#$1a,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,analyseoff+codeoff_seg*16+$12f,'');
      end;

  end;


procedure exe_b4;
  begin
    if bytesuche_codepuffer_0(#$b4#$4a#$b7#$10#$cd#$21#$8c#$c8#$8e#$d8#$8e#$c0#$b4#$3c#$31#$c9#$ba'??'#$52
         +#$cd#$21#$93#$b4#$40#$ba'??'#$b9'??'#$cd#$21) then
      pe2com(codeoff_seg*16+word_z(@codepuffer.d[$11])^,
             codeoff_seg*16+word_z(@codepuffer.d[$1a])^,
             word_z(@codepuffer.d[$1d])^);

    if bytesuche_codepuffer_0(#$b4#$30#$cd#$21) then
      begin
        case codepuffer.d[4] of
          $86:
            begin

              if bytesuche_codepuffer_0(#$B4#$30#$CD#$21#$86#$E0#$2E#$A3'??'#$3d#$00#$02) then
                begin
                  (* DGNCPY ...  *)
                  ausschrift('Microsoft C [1990] NE-'+textz_exe__Lader^,signatur);
                  x_exe_stub_fehler;
                end;

              if bytesuche_codepuffer_0(#$B4#$30#$cd#$21#$86#$c4#$3d#$0a#$14#$72) then
                begin
                  if bytesuche(codepuffer.d[$b],#$be#$80#$00#$8a#$1c#$32#$ff) then
                    (* VPASCAL BGIDEMO 1.1 *)
                    (* LXLITE *)
                    ausschrift(textz_exe__Aufruf_OS2_Programm_aus_DOS_Sitzung^,signatur)
                  else
                    ausschrift(textz_exe__Test_auf_OS2_2_10^,signatur);

                  codepuffer.d[0]:=$eb;
                  codepuffer.d[1]:=$9+codepuffer.d[$a];
                  trace(codepuffer);
                  durchsuchen;
                  x_exe_stub_fehler;
                end;

              if bytesuche_codepuffer_0(#$B4#$30#$cd#$21#$86#$e0#$3d#$00#$03#$73#$06) then
                begin
                  exezk:='?.?';
                  if bytesuche(codepuffer.d[$11],#$50#$b8'??'#$58) then
                     exezk:='0.99˙˙1.00';
                  if bytesuche(codepuffer.d[$11],#$e8#$b9) then
                     exezk:='1.02·';
                  hackstop(exezk);
                end;

              if bytesuche_codepuffer_0(#$B4#$30#$cd#$21#$86#$e0#$3d#$00#$03#$73#$12) then
                hackstop('1.10');

              if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$86#$e0#$3d#$00#$03#$73#$0a) then
                hackstop('1.11');

              if bytesuche_codepuffer_0(#$B4#$30#$cd#$21#$86#$c4#$3d#$0a#$03#$73#$06#$ba#$ec#$08) then
                ausschrift(textz_exe__unbekannte_Kompression^+'<GAME WIZARD 2.3a..2.60>',packer_exe);

            end;
          $3c:
            begin
              if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$3c#$02#$77#$01#$c3)then
                begin
                  if  (puffer_anzahl_suche(codepuffer,#$d7,200)>=2)
                  and (puffer_anzahl_suche(codepuffer,#$90,200)>=2)
                   then
                    ausschrift('ENcryptCOM / Stewart Moss [3.06]',packer_exe);
                end;

              if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$3c#$02#$73#$06#$33#$c0#$06#$50#$cb'?'#$bf#$00#$01#$be) then
                ausschrift(textz_exe__unbekannte_Verschluesselung^+'<TEU/JVP>',packer_exe);

              if bytesuche_codepuffer_0(#$B4#$30#$CD#$21#$3C'?'#$73#$02#$CD#$20#$BF'??'#$8B#$36#$02#$00)
               and (codepuffer.d[$25]=$0B) (* CPBACKUP! *) then
                begin
                  ausschrift('QBASIC / MS',compiler);
                  codepuffer.d[0]:=0;
                end;

              if bytesuche_codepuffer_0(#$B4#$30#$CD#$21#$3C'???'#$B8'??'#$50) then
                (* ZAP.EXE (SCAN-MenÅ) C 1986 *)
                c_copy_run(word_z(@codepuffer.d[$17])^*16+8,
                '','Microsoft '+textz_exe__Laufzeitbibliothek^+' [C]',compiler,10,#0,'Mic');

              if bytesuche_codepuffer_0(#$B4#$30#$CD#$21#$3C#$02#$73#$15#$9A) then
                (* ZEISATZ *)
                c_copy_run(longint(word_z(@codepuffer.d[$1E])^)*16+8,
                 '','Microsoft Fortran [1987]',compiler,10,#0,'Mic');

              if bytesuche_codepuffer_0(#$B4#$30#$CD#$21#$3C#$02#$73#$02#$CD#$20#$BF'??'#$8B) then
                (* C, DP.EXE=1987 SUBST.EXE MS-DOS 6.20=1988 LHDIR Profdos =1989 *)
                c_copy_run(longint(word_z(@codepuffer.d[$B])^)*16+8,
                 '','Microsoft '+textz_exe__Laufzeitbibliothek^+' [C]',compiler,10,#0,'Mic');

              if bytesuche_codepuffer_0(#$B4#$30#$CD#$21#$3C#$02#$73#$05#$33#$C0#$06#$50#$CB) then
                (* MegaTraveller2 SPACE.DAT/.EXE ** Fehler bei PV.EXE!, C1990,1992 *)
                c_copy_run(longint(word_z(@codepuffer.d[$E])^)*16+8,
                 '','Microsoft '+textz_exe__Laufzeitbibliothek^+' [C]',compiler,10,#0,'Mic');

            end;

          end;
      end
    else (* nicht B4 30 CD 21 *)
      begin

        if bytesuche_codepuffer_0(#$b4#$48#$bb#$ff#$ff#$b9'??'#$8b#$ec#$cd#$21#$fa#$fc) then
          begin
            case codepuffer.d[$55] of
              $34:exezk:='1.03'; (* und einige 1.02 *)
              $05:exezk:='1.02';
              $df:exezk:='1.0b';
              $f6:exezk:='1.01';
              $04:exezk:='1.03 - 05.03.1998';
            else
                  exezk:='1.??';
            end;
            ausschrift('CrackStop / Stefan Esser ['+exezk+']',packer_exe);
            crackstop(codeoff_seg*16+codeoff_off+$57+word_z(@codepuffer.d[$57+1])^+3);
          end;

        if bytesuche_codepuffer_0(#$b4#$19#$cd#$21#$a2'??'#$eb) then
          begin
            ausschrift('Dropper.Boot.Aircop',virus);
            DecDGT(einzel_laenge,512+5);
          end;

        if bytesuche_codepuffer_0(#$b4#$4c#$cd#$21) then
          if bytesuche(codepuffer.d[4],#$9d#$89) then
            begin
              if bytesuche(codepuffer.d[4+2],'dlz') then
                diet_datendatei(codepuffer,'1.4X',4+2+3)
              else
                diet_datendatei(codepuffer,'1.00',nicht_gefunden)
            end
          else
            ausschrift(textz_exe__Programmabbruch^,signatur);

        if bytesuche_codepuffer_0(#$b4#$4c#$b0'?'#$cd#$21) then
          ausschrift(textz_exe__Programmabbruch^+' ('+str0(codepuffer.d[3])+')',signatur);

        if bytesuche_codepuffer_0(#$B4#$62#$cd#$21#$8c#$d8#$3b#$c3) then
          begin
            case codepuffer.d[8] of
             $0f:exezk:='4.35: Privater';
             $74:exezk:='5.00: WC 3';
            else
              exezk:='?.?? ¯';
            end;

            ausschrift('JEMM / ORIGIN / Jason M Yenawine ['+exezk+']',dos_win_extender);
          end;

        if bytesuche_codepuffer_0(#$B4#$0F#$CD#$10#$BB#$00#$B8#$3C#$02#$74#$18) then
          begin
            (* THEDRAW 4.61 , 4.63 *)
            ausschrift('TheDraw / TheSoft Programming Services [4.6X]',musik_bild);
            thedraw_com(longint(codeoff_seg)*16+longint(codeoff_off),falsch);
          end;

        if bytesuche_codepuffer_0(#$B4#$0F#$CD#$10#$8C#$CB#$8E#$DB#$BB#$00#$B0) then
          begin
            (* THEDRAW ?.?? CD-MAN *)
            ausschrift('TheDraw / TheSoft Programming Services [3.30]',musik_bild);
            thedraw_com_alt(codeoff_seg*16+codeoff_off);
          end;

        (* ASD013.EXE: DEMO.COM *)
        if bytesuche_codepuffer_0(#$b4#$0f#$cd#$10#$32#$e4#$50#$b8#$14#$11#$cd#$10#$b4#$01) then
          begin
            ausschrift('Ansied 2.0',musik_bild);
            thegrab(analyseoff+codeoff_seg*16+$158,24,160,'');
          end;

        if bytesuche_codepuffer_0(#$B4#$09#$ba#$14#$01#$cd#$21#$b8#$00#$4c#$cd#$21) then
          ausschrift('PKLite .SYS ['+textz_exe__Ausschrift^+']',packer_exe);

        if bytesuche_codepuffer_0(#$B4#$09#$5a#$cd#$21) then
          (* ZZYQXHAY.COM *)
          ansi_anzeige(analyseoff+ds_off+stack_inhalt
         ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');

      end;

  end;


procedure exe_b8;
  var
    exe_tmp_puffer      :puffertyp;
    cfg_ende            :dateigroessetyp;
    w1,w2               :word_norm;

  begin

    (* rose allbugs.com, z.B. rc286 1.17 *)
    if bytesuche_codepuffer_0(#$b8#$13#$00#$cd#$10#$bd'?'#$02#$b9'?'#$00#$ba'??'#$e8'??'#$60#$bf) then
      ausschrift(puffer_zu_zk_e(codepuffer.d[word_z(@codepuffer.d[6])^-$100],'$',128),farblos);

    if bytesuche_codepuffer_0(#$b8#$00#$00#$8e#$d8#$8c#$06#$2e#$00#$8e#$d0#$bc#$00#$27#$50#$bb#$00#$10#$b4#$4a#$cd#$21
      +#$58#$8e#$c0#$2e#$a1#$16#$00#$a3) then
      begin
        (* was hat der Code fÅr eine Zweck? Das angehÑngte DOS-Programm lÑuft so vie besser! *)
        ausschrift('XDX16? DosXtndr / ?',dos_win_extender);
        befehl_schnitt(analyseoff+einzel_laenge,dateilaenge-analyseoff-einzel_laenge,erzeuge_neuen_dateinamen('.COM'));
      end;

    if bytesuche_codepuffer_0(#$b8#$00#$00#$bb'??'#$2b#$d8#$43#$83#$c3#$10#$b4#$4a#$cd#$21#$b8'??'
      +#$8e#$c0#$06#$1f#$bf'??'#$bb#$00#$00#$b4#$1b#$cd#$10) then
      begin
        (* DOSIB143.EXE *)
        ausschrift('NCR Disk Creation Tool [2.00]',signatur);
        cfg_ende:=datei_pos_suche(analyseoff+einzel_laenge,analyseoff+einzel_laenge+2000,#$0d#$0a#$00);
        if cfg_ende<>nicht_gefunden then
          merke_position(cfg_ende+1,datentyp_unbekannt);
      end;

    if bytesuche_codepuffer_0(#$b8#$8c#$d3#$15#$33#$75#$72#$f9#$8a#$c4#$fc) then
      begin (* XOR $ac, XOR $55 *)
        case word_z(@codepuffer.d[$c])^ of
          $0166:exezk:='610'; (* WARMBOOT.COM *)
          $01f7:exezk:='759'; (* NUMLOCK.COM  *)
          $01ef:exezk:='751'; (* STACHELN.COM *)
          $027b:exezk:='891'; (* CANNABIS.COM *)
        else
                    exezk:='? ¯';
        end;
        ausschrift('ROSE'#39's COMPROTECT ? [1.?? - '+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$b8#$8c#$d3#$15#$33#$75#$72#$f9#$8a#$c4#$bb'??'#$50#$51#$52#$53
         +#$54#$55#$56#$57#$06#$1e#$50#$b8#$eb#$04) then
      ausschrift('ROSE'#39's COMPROTECT [2.05]',packer_exe); (* FRODO.COM ($66f, XOR $cf) *)

    if bytesuche_codepuffer_0(#$b8'??'#$56#$50#$c3) then
      if bytesuche__datei_lesen(analyseoff+16*longint(codeoff_seg)+word_z(@codepuffer.d[1])^,
        #$bf#$06#$01#$8b#$de#$b9'??'#$8b#$05#$33#$c6#$89#$07#$47#$47) then
        ausschrift('PC0RSAiR cryptor [type 2]',packer_exe); (* pcor$2.com, manticore *)

    (* Country.Sys DRDOS 7.03 Beta *)
    if bytesuche_codepuffer_0(#$b8#$00#$01#$52#$ba'??'#$03#$d0#$b4#$09#$cd#$21) then
      begin
        ansi_anzeige(analyseoff+ds_off+$100+word_z(@codepuffer.d[5])^
            ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        if bytesuche__datei_lesen(analyseoff+10,'COUNTRY.SYS') then
          drdos_country_sys_anzeige(10);
      end;

    if bytesuche_codepuffer_0(#$b8'??'#$8e#$d8#$8c#$06'??'#$33#$ed#$e8'??'#$e8'??'#$8b#$c4) then
      turbo_pascal(codepuffer,'Pascal Patcher / G†bor Keve <ax>');

    if bytesuche_codepuffer_0(#$b8#$01#$25#$33#$d2#$cd#$21#$05#$02#$00#$cd#$21) then
      (* SAFEEXEC *)
      case codepuffer.d[$0c] of
        $8a:ausschrift('CRYPTCOM / Arminio Grgic [1.0·]',packer_exe);
        $1e:
          begin
            case codepuffer.d[$10] of
              $c3:exezk:='';
              $c0:exezk:=' /NC';
            else
                  exezk:=' ? ¯';
            end;
            ausschrift('LOCKEXE / Arminio Grgic [1.0·'+exezk+']',packer_exe);
          end;
      end;

    if bytesuche_codepuffer_0(#$b8#$10#$40#$cd#$2f#$3d#$10#$40#$74'?'#$bf'??'#$b1#$0f) then
      begin
        (* LXLITE 1.2.1 *)
        ausschrift(textz_exe__Aufruf_OS2_Programm_aus_DOS_Sitzung^+' [STUB_VDM.BIN / LXLite]',signatur);
        ansi_anzeige(analyseoff+ds_off+$100,
           '$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,analyseoff+codeoff_seg*16+codeoff_off,'')
      end;

    if bytesuche_codepuffer_0(#$b8'??'#$8e#$d8#$8c#$d3#$2b#$d8#$c1#$e3#$04#$8e#$d0#$03#$e3#$b4#$30) then
      ausschrift(textz_exe__Aufruf_OS2_Programm_aus_DOS_Sitzung^+' [HV/Michael H. Shacter]',signatur);

    if bytesuche_codepuffer_0(#$b8#$03#$00#$cd#$10#$b4#$01#$b9#$00#$20#$cd#$10#$e8#$cb#$ff) then
      begin
        (* bei ANSI2COM / oZoNe/sMAUG *)
        ausschrift('ACiDDRAW / ?',compiler);
        thegrab(analyseoff+ds_off+$100+$18d,word_z(@codepuffer.d[$10])^,80*2,'');
      end;

    if bytesuche_codepuffer_0(#$b8'??'#$8b#$e0#$50#$b4#$01#$cd#$16#$74#$08#$32#$e4) then
      begin
        case codepuffer.d[$61] of
          $65:exezk:='[0.9·]' ; (* 0465 *)
          $77:exezk:='[0.91·]'; (* 0477 *)
          $9c:exezk:='[0.92·]'; (* 049c *)
        else
              exezk:='[0.9? ¯]'
        end;
        upstop(exezk);
      end;

    if bytesuche_codepuffer_0(#$b8#$09#$35#$cd#$21#$8c#$06) then
      begin
        ausschrift('TXT2RES / Keith P. Graham [1.0]',compiler);
        suche_txt2com_titel($600);
      end;

    if bytesuche_codepuffer_0(#$b8#$00#$00#$8e#$d8#$ba'??'#$b9'??'#$bb#$01#$00#$b4#$40#$cd#$21) then
      begin
        (* OS/2 WARP 4 \OS2\REXX*.EXE *)
        (* XX_EXE: *)
        if bytesuche__datei_lesen(analyseoff+ds_off+$100,#$0d#$0a) then
          ansi_anzeige(analyseoff+ds_off+$100,
           #0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'')
        else
          ansi_anzeige(analyseoff+ds_off+$100+word_z(@codepuffer.d[6])^,
           #0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,
            ds_off+$100+word_z(@codepuffer.d[6])^+word_z(@codepuffer.d[9])^,'');

        x_exe_stub_fehler;
      end;

    if bytesuche_codepuffer_0(#$B8'??'#$8E#$D8) then
      ds_off:=codeoff_seg*16+word_z(@codepuffer.d[1])^*16;

    if bytesuche_codepuffer_0(#$B8'??'#$8E#$D8#$B8'??'#$BB)
    or bytesuche_codepuffer_0(#$B8'??'#$8E#$D8#$06#$26)
    or bytesuche_codepuffer_0(#$B8'??'#$8E#$D8#$8c#$06#$02#$00) then
      (* GERMANY3 *)
      ausschrift('Borland RTM DPMI-'+textz_exe__Lader^,dos_win_extender);

    if bytesuche_codepuffer_0(#$b8#$03#$00#$cd#$10#$fa#$f9#$b9'??'#$be) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<KROC>',packer_exe);

    if bytesuche_codepuffer_0(#$b8'??'#$50#$b8'??'#$50#$cb#$eb) then
      begin
        datei_lesen(exe_tmp_puffer,(longint(exe_kopf.stackoffset)+longint(exe_kopf.kopfgroesse))*16,512);
        if exe_tmp_puffer.d[0]=0 then
          exezk:=puffer_zu_zk_e(exe_tmp_puffer.d[1],'..',255)
        else
          exezk:=puffer_zu_zk_e(exe_tmp_puffer.d[0],'..',255);
        ausschrift(exezk,compiler)
      end;


    if bytesuche_codepuffer_0(#$b8#$00#$00#$8e#$d0#$b8'??'#$8b#$e0#$8c#$d8) then
      ausschrift('Borland BOSS '+textz_exe__Lader^,dos_win_extender);

    if bytesuche_codepuffer_0(#$B8'??'#$8E#$D8#$FA#$8E#$D0#$BC'??'#$FB#$8C) then
      (* ATTRIB.EXE MS-DOS 6.20 C 1988 *)
      (* lange Folge zur Unterscheidung von TPC.EXE TP6,7 *)
      c_copy_run(longint(word_z(@codepuffer.d[$1])^)*16+8,
       '','Microsoft '+textz_exe__Laufzeitbibliothek^+' [C]',compiler,10,#0,'Mic');

    if bytesuche_codepuffer_0(#$B8'??'#$8E#$C0#$06) then
      begin
        (* LHA 2.13 *)
        c_copy_run(longint(word_z(@codepuffer.d[$1])^)*16+4,
         '','LSI C',compiler,10,#0,'L');
      end;

    if bytesuche_codepuffer_0(#$b8'??'#$8e#$d8#$8b#$1e'??'#$8e#$d0#$8b#$e3) then
      (* Unique C/C++ / insp110d.zip *)
      ansi_anzeige(analyseoff+longint(word_z(@codepuffer.d[1])^)*16+longint(exe_kopf.kopfgroesse)*16+$c,
        #$0d,ftab.f[compiler,hf]+ftab.f[compiler,vf],absatz,wahr,wahr,unendlich,'');

    if bytesuche_codepuffer_0(#$B8#$00#$00#$BB#$CE#$00#$8E#$D0#$8B#$E3) then
      (* GERMANY3 *)
      ausschrift('Borland [Pascal] NE-'+textz_exe__Lader^,signatur);

    if bytesuche_codepuffer_0(#$B8#$8C#$D3#$15#$33#$75#$72#$F9#$D4#$FF#$8A#$C4) then
      ausschrift('Thunderbyte EXE - '+textz_exe__Verschluesselung^+' <b8>',packer_exe);

    if bytesuche_codepuffer_0(#$B8'??'#$BA'??'#$05'??'#$3b#$06'??'#$73'?'#$2d)
    or bytesuche_codepuffer_0(#$B8'??'#$BA'??'#$05'??'#$3b#$06'??'#$72'?'#$b4#$09)
      then
      (* EXE Versuch mit Pklite SW-Version 1.20 also 1.12 *)
      begin
        if bytesuche_codepuffer_0(#$b8'??'#$ba'??'#$05#$00#$00#$3b#$2d#$73#$67) then
          begin
            ausschrift('MEGALiTE / ThE KiLLeR of MEGATEAM '#39'n CTF [1.20a]',packer_exe);
          end
        else if bytesuche_codepuffer_0(#$B8#$d5#$01#$BA#$7a#$00#$05#$00#$00) then
          begin
            ausschrift('TBNLOCK / Andreas Fiedler [1.3]',packer_exe);
            pktinykopf:=falsch;
          end
        else
          begin
            if pklitekopf then
              ausschrift(pkliteversion,packer_exe)
            else
              begin
                if codepuffer.d[$d]=$73 then
                  exezk:='[1.12..1.13]'
                else
                  exezk:='[1.14..1.20]';
                ausschrift('PKLite '+exezk+', '+textz_exe__veraenderter_Kopf^,packer_exe);
                IncDGT(kopftextstart,2);
                Dec(kopftextlaenge,2);
                kopftext_anzeige('',packer_exe);
                DecDGT(kopftextstart,2);
                Inc(kopftextlaenge,2);
              end;
          end;
        pklitekopf:=falsch;
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$B8'??'#$BA'??'#$3B#$C4) then
      (* COM Versuch mit Pklite SW-Version 1.20 also 1.12 *)
      begin
        if pklitekopf then
          ausschrift(pkliteversion,packer_exe)
        else
          begin
            ausschrift('PKLite [1.01..1.15], '+textz_exe__veraenderter_Kopf^,packer_exe);
            w1:=puffer_pos_suche(codepuffer,#$cb,$40);
            if codepuffer.d[w1+1]=$90 then
              inc(w1);

            if w1<>nicht_gefunden then
              case codepuffer.d[$9] of
                $22:; (* ohne COPYRIGHT *) (* EXE2COM.COM *)
                $4b:ausschrift('"'+puffer_zu_zk_l(codepuffer.d[w1+4-1],$4b-w1+6)+'"',signatur);
                $67:ausschrift('"'+puffer_zu_zk_l(codepuffer.d[w1+4-1],$67-$37)+'"',signatur);
                $69:ausschrift('"'+puffer_zu_zk_l(codepuffer.d[w1+3  ],$69-$37-1)+'"',signatur);
              (*$IfNDef ENDVERSION*)
              else
                ausschrift('',virus);
              (*$EndIf*)
              end;
          end;
        pklitekopf:=falsch;
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$B8'??'#$BA'??'#$8C#$DB) then
      begin
        if pklitekopf then
          ausschrift(pkliteversion,packer_exe)
        else
          begin
            ausschrift('PKLite [1.00..1.03], '+textz_exe__veraenderter_Kopf^,packer_exe);
            IncDGT(kopftextstart,2);
            Dec(kopftextlaenge,2);
            kopftext_anzeige('',packer_exe);
            DecDGT(kopftextstart,2);
            Inc(kopftextlaenge,2);
          end;
        pklitekopf:=falsch;
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$b8#$00#$00#$50#$b8'??'#$50#$1e#$8c#$c8) then
      ausschrift('Amisetup '+textz_exe__Lader^+' / Robert Muchsel ',packer_exe);

    if bytesuche_codepuffer_0(#$b8'??'#$8e#$d8#$b4#$09#$ba'??'#$cd#$21#$b4#$4C#$CD#$21) then
      (* STACFM.DLL *)
      if exe then
        begin
          (* XX_EXE: *)
          ansi_anzeige(analyseoff+codeoff_off+16*longint(codeoff_seg)+word_z(@codepuffer.d[$08])^
            +longint(word_z(@codepuffer.d[$01])^)*16,
           '$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
          hersteller_erforderlich:=falsch; (* keine Nullen *)
        end;

    if bytesuche_codepuffer_0(#$B8'?'#$4c#$cd#$21) then
      if (codepuffer.d[5]=$cb) and (einzel_laenge>90) then
        begin
          datei_lesen(exe_tmp_puffer,analyseoff+einzel_laenge-90,90);
          if bytesuche(exe_tmp_puffer.d[0],'URAM'#$0d#$0a) then
            begin
              ausschrift('URAM "BIOS"-'+textz_Modul^,signatur);
              ausschrift(puffer_zu_zk_e(exe_tmp_puffer.d[6     ],#$0d,40),beschreibung);
              ausschrift(puffer_zu_zk_e(exe_tmp_puffer.d[6+40+2],#$0d,40),beschreibung);
            end
          else
            ausschrift(textz_exe__Programmabbruch^,signatur);
        end
      else
        ausschrift(textz_exe__Programmabbruch^,signatur);

    if bytesuche_codepuffer_0(#$b8#$00#$00#$8e#$d8#$9a'????'#$55#$8b) then
      ausschrift(textz_exe__unbekannter_Compiler^+' (?) / Meridian Software ¯ ',compiler);

    if bytesuche_codepuffer_0(#$b8'??'#$2b#$06'??'#$a3'??'#$e8) then
      begin
        ausschrift('SHOW / Gary M. Raymond [2.0]',compiler);
        datei_lesen(exe_tmp_puffer,analyseoff+codeoff_seg*16+$281,80);
        ausschrift(leer_filter(puffer_zu_zk_l(exe_tmp_puffer.d[0],80)),beschreibung);
      end;

    if bytesuche_codepuffer_0(#$B8#$00#$b8#$8e#$c0#$bf#$00#$00#$be#$25#$01#$fc) then
      begin
        ausschrift(textz_exe__unbekannter_Textbildschirm^+' <B8 00> ¯',signatur);
        thegrab(analyseoff+codeoff_off+longint(codeoff_seg)*16+$22,word_z(@codepuffer.d[13])^ div (80*2),160,'');
      end;

    if bytesuche_codepuffer_0(#$b8#$03#$00#$cd#$10#$b8#$12#$11) then
      (* VGA50 / GTR184 *)
      if not bytesuche(codepuffer.d[$c],#$b8#$00#$4c#$cd#$21) then
        begin
          ausschrift(textz_exe__unbekannter_Textbildschirm^+' <B8 03> ¯',signatur);
          thegrab(analyseoff+exe_kopf.kopfgroesse+$10,49,160,'');
        end;

    if bytesuche_codepuffer_0(#$B8'??'#$8c#$ca#$03#$d0#$8c#$c9#$81#$c1) then
      begin
        (* P/PU/... *)
        ausschrift('WWPACK / Rafal Wierzbicki '+textz_exe__und^+' Piotr Warezak '
         +wwpack_version(
            byte__datei_lesen(analyseoff+codeoff_off+codeoff_seg*16-1)
                         ),packer_exe);

        if kopftext<>'WWP ' then
          kopftext_anzeige(textz_exe__veraenderter_Kopf^,packer_exe);

        if copy(kopftext,1,4)='LSxP' then (* LSXPOWER Version 4 *)
          ansi_anzeige(analyseoff+$40,#$1a,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        kopftext_nullen;

        if (einzel_laenge=8688) and (exe_kopf.pruefsumme=$be60) then
          begin
            ausschrift('Lock-King / Double-Star Computer [2.0b]',packer_exe);
            if dateilaenge>8688 then
              begin
                ausschrift_leerzeile;
                datei_lesen(
                  exe_tmp_puffer,
                  dateilaenge-x_word__datei_lesen(dateilaenge-2),
                  512);
                ausschrift('-> '+puffer_zu_zk_e(exe_tmp_puffer.d[0],#0,128),beschreibung);
                einzel_laenge:=dateilaenge-analyseoff;
              end;
          end;
      end;

    if bytesuche_codepuffer_0(#$b8'??'#$8e#$d8#$8c#$06'??'#$e8'??'#$e8'??'#$e8) then
      begin
        datei_lesen(exe_tmp_puffer,longint(exe_kopf.kopfgroesse)*16,100);
        ausschrift('EMX '+textz_exe__oder^+' EMX-'+textz_exe__Lader^+' / Eberhard Mattes "'
         +puffer_zu_zk_e(exe_tmp_puffer.d[0],#0,255)+'"',dos_win_extender);
      end;

    if bytesuche_codepuffer_0(#$b8'??'#$8e#$d8#$8c#$06'??'#$cb) then
      (* PACKOBJ *)
      ausschrift('Borland Pascal, '+textz_exe__veraenderte_leer^
        +textz_exe__Laufzeitbibliothek^
        +' / Wilbert van Leijen',compiler);

    if bytesuche_codepuffer_0(#$b8#$00#$15#$b2#$81#$cd#$13) then
      ausschrift('Linux Kernel+'+textz_exe__Dekompressor^,dos_win_extender);

    if bytesuche_codepuffer_0(#$b8#$ff#$ff#$cd#$e6) then
      ausschrift('Linux dosemu '+textz_exe_Ende_der_DOS_Sitzung^,signatur);

    if bytesuche_codepuffer_0(#$b8#$00#$30#$8b#$fc#$06#$57#$cd#$21#$0e#$1f#$5f) then
      begin
        (* NVCLEAN : TBAV 8.00 *)
        ausschrift(textz_exe__Immunisierung^+' "RE"/Norman Data Defense Systems" [EXE] ¯',signatur);
        (* PKLITE KOPF ... *)
        kopftext_nullen;
        pklitekopf:=falsch;
      end;

    if bytesuche_codepuffer_0(#$b8#$00#$30#$8b#$fc#$06#$57#$cd#$21#$5f#$07#$36#$8b#$35#$83) then
      begin
        (* BG.EXE (COM) Norman AV 4.60 *)
        ausschrift(textz_exe__Immunisierung^+' "RE"/Norman Data Defense Systems" [COM] ¯',signatur);
        (* PKLITE KOPF ... *)
        kopftext_nullen;
        pklitekopf:=falsch;
      end;

  end;


procedure exe_b9;
  var
    f1:dateigroessetyp;
  begin

    if bytesuche_codepuffer_0(#$b9'??'#$8c#$d8#$83#$c0#$0f#$fa#$8b#$dc#$8c#$d7#$bc#$05#00#$44) then
      begin

        case codepuffer.d[$11] of
          $40:exezk:='1.05..b';
          $44:begin
                case codepuffer.d[$17] of
                  $b2:
                    case codepuffer.d[$3f] of
                      $7b:exezk:='1.05c';
                      $86:exezk:='1.06';
                    else
                      exezk:='1.05c/6?';
                    end;
                  $ba:exezk:='1.07';
                  $68:exezk:='1.07/BiosCrypt'
                else  exezk:='1.07?';
                end;
              end;
        else
          exezk:='1.05??';
        end;
        f1:=einzel_laenge-(codeoff_seg*16+codeoff_off);
        ausschrift('REC/SMALL / Ralph Roth ['+exezk+':'+str0_DGT(f1)+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$b9'??'#$8e#$d9#$8c#$06'??'#$33#$ed#$e8'??'#$e8'??'#$8b#$c4) then
      turbo_pascal(codepuffer,'Pascal Patcher / G†bor Keve <cx>');

    if bytesuche_codepuffer_0(#$b9#$11#$00#$8e#$d9#$2a#$ff#$26#$8a#$1e#$80#$00#$26#$c6#$87#$81#$00#$00) then
      begin
        (* CFGMAINT *)
        (*ausschrift('Oberon ??? / ???',compiler);*)
        ausschrift('HOPE Oberon / David C. Morrill',compiler);
        ansi_anzeige(ds_off+$100+longint(word_z(@codepuffer.d[1])^)*16,
          #0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    if bytesuche_codepuffer_0(#$b9'??'#$be'??'#$bf#$c0#$ff#$bd#$ff#$ff#$fd#$f3#$a4) then
      (* 0.05: $1c 0.20,0.30: $1d *)
      ausschrift_upx_version(codepuffer,codepuffer,$1c,0,40,'dos/com');

    if bytesuche_codepuffer_0(#$b9'??'#$be'??'#$bf#$c0#$ff#$fd#$f3#$a4#$fc#$f7#$e1) then
      ausschrift_upx_version(codepuffer,codepuffer,$1c,50,255,'dos/com');

    if bytesuche_codepuffer_0(#$b9'??'#$be'??'#$bf#$c0#$ff#$fd#$f3#$a4#$fc#$bb#$00#$80) then
      (* 0.76.1 *)
      ausschrift_upx_version(codepuffer,codepuffer,$1c,50,255,'dos/com');
                                                                                  {#$05#$00}
    if bytesuche_codepuffer_0(#$b9'??'#$be'??'#$89#$f7#$1e#$a9#$b5#$80#$8c#$c8#$05'??'#$8e#$d8) then
      (* 0.81 *)
      ausschrift_upx_version(codepuffer,codepuffer,$1c,81,255,'dos/exe');


    if bytesuche_codepuffer_0(#$b9#$e8#$03#$eb#$03#$90#$cd#$20#$e2#$f9) then
      begin
        (* .EXE *)
        case codepuffer.d[$a] of
          $33:trap('1.14a');
          $8c:trap('1.15');
        else
              trap('1.1? ¯');
        end;
      end;

    if bytesuche_codepuffer_0(#$b9'??'#$bf'??'#$2b#$cf#$32#$c0#$f3#$aa) then
      begin
        (* PKZIP PKSFX A3 *)
        ausschrift('PKZip Mini-Sfx',packer_dat);
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$b9'??'#$ba'??'#$bf'??'#$bb'??'#$b8'??'#$be) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<!TWIN> <1>¯',packer_exe);

    if bytesuche_codepuffer_0(#$b9'??'#$be'??'#$89#$f7#$0e#$1f#$0e#$07#$bb'??'#$fc#$ad#$31#$d8#$ab#$e2#$fa) then
      ausschrift('COMCrypt / ??? <$28> [XOR '+hex_word(word_z(@codepuffer.d[$d])^)+']',packer_exe);

  end;

procedure exe_ba;
  var
    ip,cs               :word;
    exe_tmp_puffer      :puffertyp;
    w1,w2               :word_norm;
  begin
    if bytesuche_codepuffer_0(#$ba#$f8#$03#$8e#$da#$8c#$d3#$2b#$da#$d1#$e3#$d1#$e3#$d1#$e3#$d1#$e3
      +#$fa#$8e#$d2#$03#$e3#$fb#$fc#$b8#$02#$00#$e8'??'#$73) then
      ausschrift(textz_exe__unbekannter^+' DOS-Extender: <Acronis OS Selector 5>',dos_win_extender);

    if bytesuche_codepuffer_0(#$ba#$6d#$02#$b4#$09#$cd#$21#$ba#$4e#$02#$b4#$09) then
      begin
        dec(herstellersuche);
        ausschrift('MkPatch / eGIS! [1.0]',compiler);
        inc(herstellersuche);
      end;

    if bytesuche_codepuffer_0(#$ba'??'#$e8'??'#$b4#$30#$cd#$21#$0a#$c0#$74#$d2#$be'??'#$ad#$91) then
      buildsfx(codeoff_seg*16+word_z(@codepuffer.d[$0f])^,codeoff_seg*16+word_z(@codepuffer.d[$01])^);

    if bytesuche_codepuffer_0(#$ba'??'#$bf'??'#$eb#$01'?'#$e8) then
      begin
        datei_lesen(exe_tmp_puffer,analyseoff+codeoff_seg*longint(16)+0,$30);
        w1:=word_z(@exe_tmp_puffer.d[$1e])^;
        w2:=word_z(@exe_tmp_puffer.d[$20])^;

        cs:=word_z(@exe_tmp_puffer.d[$18])^;
        ip:=word_z(@exe_tmp_puffer.d[$1a])^;

        exezk:='?.??';

        if codeoff_off=$0ad then
          exezk:='EG 1.3';

        if codeoff_off=$2d6 then
          exezk:='EL 1.01b';

        if codeoff_off=$325 then
          exezk:='EL 1.02';

        if codeoff_off=$114 then
          exezk:='EL 1.03';

        if codeoff_off=$0d7 then
          exezk:='EL 1.04';

        if codeoff_off=$11b then
          exezk:='EL 1.05';


        if  (codeoff_off<$325)  (* 1.03+ *)
        and (codeoff_off<>$2d6) (* <>1.01 *)
         then
          begin
            cs:=cs xor w2;
            ip:=ip xor w2;
          end;

        if (w1 xor w2)=1 then
          exezk_anhaengen(' /c {XOR '+hex_word(w2)+'}');

        ausschrift('EXEGUARD / Ivanov Vadim  ≥ EXELOCK 666 / ST!LLS0N',packer_exe);
        ausschrift('['+exezk+']  ORG CS:IP='+hex_word(cs)+':'+hex_word(ip),packer_exe);
      end;

    (* if bytesuche_codepuffer_0(#$ba#$98#$02#$bf#$b9#$00#$eb#$01'?'#$e8) then
      ausschrift('EXEGUARD / Ivanov Vadim [1.3]',packer_exe); *)

    if bytesuche_codepuffer_0(#$ba#$4b#$02#$fe#$0e) then
      begin
        ausschrift('Dropper.Boot.A.(PingPong)',virus);
        DecDGT(einzel_laenge,512);
      end;

    if bytesuche_codepuffer_0(#$ba'??'#$8e#$da) then
      ds_off:=codeoff_seg*16+word_z(@codepuffer.d[1])^*16;

    if bytesuche_codepuffer_0(#$ba#$03#$00#$8e#$da#$8c#$d3#$2b#$da#$d1#$e3#$d1#$e3#$d1#$e3#$d1#$e3
      +#$fa#$8e#$d2#$03#$e3#$fb#$b4#$09#$ba'??'#$cd)
     then (* 3dmaze *)
      ansi_anzeige(analyseoff+16*longint(codeoff_seg+3)+word_z(@codepuffer.d[$1a])^,
       '$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');

    if bytesuche_codepuffer_0(#$BA'??é'#$DA#$8C#$06) then
      begin
        if bytesuche(codepuffer.d[9],#$bb'??'#$2b#$1e) then
          ausschrift('Sierra Script Interpreter',signatur)
        else
          turbo_pascal(codepuffer,'');
      end;

    if bytesuche_codepuffer_0(#$ba'??'#$8e#$da#$8c#$d3#$2b#$da#$d1#$e3) and (codepuffer.d[$1c]=$1e) then
      ausschrift('TurboChainer [1.03] / TWT',packer_exe); (* sonst konflikt zu kboom *)

    if bytesuche_codepuffer_0(#$BA'??'#$2E#$89#$16'??'#$b4#$30)
    or bytesuche_codepuffer_0(#$BA'??'#$b4#$30#$cd#$21#$2E#$89#$16'??')
     then
      (* DR-DOS ASSIGN.COM(EXE),ARJ 2.41,INTRO.DAT zu EMPIRE DELUXE *)
      (* HEARTLIGHT PC HL.EXE (INTERN!) *)
      begin
        tc_verfolgung(codepuffer);
        if codepuffer.d[$a]=$90 then
          ausschrift('Antiupc / Hold',packer_exe);
        if codepuffer.d[3]=$b4 then
          ausschrift('ProtUPC / TPiNC',packer_exe);
        if  (codepuffer.d[$a]=$2e)
        and (codepuffer.d[$b]=$89)
         then
          (* TINYPROG.EXE *)
          ausschrift('XPACK.UPC.Guard.[BC] [1.67.l] / JauMing Tseng',packer_exe);
      end;


    if bytesuche_codepuffer_0(#$BA'??'#$0e#$1f#$b4#$09#$cd#$21) then
      begin
        (* WINVER.EXE XX_EXE: *)
        ansi_anzeige(analyseoff+16*longint(codeoff_seg)+word_z(@codepuffer.d[1])^
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        hersteller_erforderlich:=falsch; (* keine Nullen *)

        (* Korrektur: DELPH2MSG.EXE *)
        x_exe_stub_fehler;
      end
    else
      if bytesuche_codepuffer_0(#$BA#$10#$00#$0E) or bytesuche_codepuffer_0(#$BA#$0E#$00#$0E) then
        begin
          (* BWCC.DLL HEADUP 1.00   XX_EXE: *)
          ausschrift(textz_exe__Ausschrift^+'Borland',signatur);
          ansi_anzeige(analyseoff+codeoff_off+16*longint(codeoff_seg)+word_z(@codepuffer.d[1])^
                 ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
          hersteller_erforderlich:=falsch; (* keine Nullen *)
        end;

    if bytesuche_codepuffer_0(#$BA'??'#$a1'??'#$2d'??'#$8c#$cb#$81#$c3) then
      begin (* PKLITE 1.00· .COM *)
        if pklitekopf or bytesuche(codepuffer.d[$26],'PK Copyr') then (* EWP.COM *)
          ausschrift('PKLite 1.00·',packer_exe)
        else
          begin
            ausschrift('PKLite 1.00·, '+textz_exe__veraenderter_Kopf^,packer_exe);
            ausschrift('"'+puffer_zu_zk_l(codepuffer.d[$24+2],$54-$24-2)+'"',signatur);
          end;
        pklitekopf:=falsch;
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$BA#$02#$00#$8e#$da#$be#$08#$00#$bf#$00#$00) then
      begin
        ausschrift('Ansi To Exe Compiler / BUFF',compiler);
        thegrab(analyseoff+codeoff_off+longint(codeoff_seg)*16+$28,25,160,'');
      end;

  end;


procedure exe_bb;
  begin
    (* SMT_SMF *)
    if bytesuche_codepuffer_0(#$bb#$00#$fe#$00#$1f#$4b#$eb#$fb) then
      begin
        case codepuffer.d[8] of
          $48,$26:exezk:='Scrypt 1.2';
          $f3,$d1:exezk:='Crypt.Trivial.173';
        else
                  exezk:='?';
        end;
        ausschrift(exezk+' / SMT/SMF',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$bb'??'#$b4#$09#$ba'??'#$cd#$21#$2e#$89#$1e'??'#$b4#$4a#$bb'??'#$cd#$21) then
      begin
        ausschrift('SFX WSP self update amapro Wakichi [1.50]',packer_dat);
        einzel_laenge:=word_z(@codepuffer.d[1])^-$100;
      end;

    if bytesuche_codepuffer_0(#$bb'??'#$b9'??'#$30#$0f#$43#$e2#$fb) then
      with codepuffer do
        if d[$82]=$6d then (* USCC *)
          ausschrift('USCC / UniquE [1.3]',packer_exe)
        else               (* dARK *)
          ausschrift('USCC / UniquE + DaRK DesStRoYeR [1.31]',packer_exe);

    if bytesuche_codepuffer_0(#$bb'??'#$8e#$db#$8c#$06'??'#$33#$ed#$e8'??'#$e8'??'#$8b#$c4) then
      turbo_pascal(codepuffer,'Pascal Patcher / G†bor Keve <bx>');

    if bytesuche_codepuffer_0(#$bb'??'#$ba'??'#$81#$c3#$07#$00#$b8'??'#$b1#$04#$d3#$e8#$03#$c3) then
      begin

        case codepuffer.d[$de] of
          $2b:exezk:='3.0';           (* auch 3.4 *)
          $c3:exezk:='3.0 Demo';      (* auch 3.4 *)
        else
               exezk:='?.?';
        end;
        ausschrift('Shrinker / Blinkinc ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$BB#$FF#$FF#$B4#$4A#$CD#$21#$81#$EB) then
      begin
        (* A320 ,Test mit SCRNCH 1.0 *)
        case word_z(@codepuffer.d[$e])^ of
          $116:exezk:='1.00';
          $12b:exezk:='1.02';
        else
          exezk:='?.?'
        end;
        ausschrift('Scrnch / Graeme W. RcRae ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$BB#00#$B0#$31#$c0#$50#$1f#$a1#$63#$04#$3d#$b4) then
      begin
        ausschrift(textz_exe__unbekannter_Textbildschirm^+' <BB> ¯',signatur);
        thegrab(analyseoff+codeoff_off+longint(codeoff_seg)*16+word_z(@codepuffer.d[$1A])^-$100,
        word_z(@codepuffer.d[$1d])^ div (80*2),160,'');
      end;

    if bytesuche_codepuffer_0(#$bb#$03#$00#$8b#$eb#$b9#$f1#$00#$90) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<WORLD/Delphine> ¯',packer_exe);
  end;

procedure exe_bc;
  begin
    if bytesuche_codepuffer_0(#$bc#$6d#$01#$e9#$05#$03) then
      begin
        ausschrift('SCR2COM / P.Fischer-Haaser',compiler);
        thegrab(1203,25,2*80,'');
      end;

    if bytesuche_codepuffer_0(#$bc'??'#$b4#$50#$8c#$c3#$cd#$21#$b8#$00#$30#$cd)
    (* bc $xxxx: MOV SP,$xxxx *)
    and (codepuffer.d[2] in [5..6]) (* PCDOS 7 russisch $0584 *)
     then
      begin
        ausschrift('COMMAND.COM / MS ≥ COMMAND.COM / IBM  DOS '+str0(codepuffer.d[$0F])+'.'
          +str_(codepuffer.d[$10],2),dos_win_extender);
        suche_bin_bldlevel;
      end;

    if bytesuche_codepuffer_0(#$BC#$03#$06#$B4#$50#$8C#$C3#$CD) then
      ausschrift('COMMAND.COM / MS ≥ COMMAND.COM / IBM  DOS 6.00',dos_win_extender);

    if bytesuche_codepuffer_0(#$BC#$3E#$05#$B4#$50#$8C#$C3#$CD) then
      ausschrift('COMMAND.COM / MS ≥ COMMAND.COM / IBM  DOS 5.00',dos_win_extender);

    if bytesuche_codepuffer_0(#$bc'??'#$e8'??'#$73#$11#$b8#$cd#$01) then
      begin
        exezk:='4.?? ¯';

        if bytesuche(codepuffer.d[1],#$23#$0e) then
          exezk:='4.01'; (* MS *)

        if bytesuche(codepuffer.d[1],#$22#$0e) then
          exezk:='4.00'; (* IBM *)

        ausschrift('COMMAND.COM / MS ≥ COMMAND.COM / IBM  DOS '+exezk,dos_win_extender);
      end;


    if bytesuche_codepuffer_0(#$BC#$3D#$08#$B4#$30#$CD#$21#$3D#$03#$1E) then
      ausschrift('COMMAND.COM / MS ≥ COMMAND.COM / IBM  DOS [TADOS] DOS 3.30',dos_win_extender);

    if bytesuche_codepuffer_0(#$bc#$5d#$07#$b4#$30#$cd#$21#$86#$e0#$3d#$14#$03) then
      ausschrift('COMMAND.COM / MS ≥ COMMAND.COM / IBM  DOS 3.20',dos_win_extender);

    if bytesuche_codepuffer_0(#$BC#$74#$00#$c3) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'"FCP/IV" <Second Reality>',packer_exe);

    if bytesuche_codepuffer_0(#$bc'??'#$8c#$c8#$8e#$c0#$8e#$d8#$fc#$be) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<TERMALLF/UTG>',packer_exe);
  end;


procedure exe_bd;
  begin
    if bytesuche_codepuffer_0(#$bd'??'#$8e#$dd#$8c#$06'??'#$33#$ed#$e8'??'#$e8'??'#$8b#$c4) then
      turbo_pascal(codepuffer,'Pascal Patcher / G†bor Keve <bp>');

    if bytesuche_codepuffer_0(#$BD'??'#$50#$06#$8C#$cb#$03#$dd) then
      (* Test mit SW-Version Compack 4.5 EXE *)
      if codepuffer.d[$2f-$20]=$4a then
        ausschrift('Compack [5.1]',packer_exe)
      else
        if codepuffer.d[$4f-$20]=$f9 then
          ausschrift('Compack [4.5]',packer_exe)
        else
          ausschrift('Compack [4.4]',packer_exe);


  end;

procedure exe_be;
  var
    exe_tmp_puffer      :puffertyp;
    passcom_l2          :word;
    w1                  :word_norm;
  begin
    if bytesuche_codepuffer_0(#$be#$03#$01#$b9'??'#$33#$db#$33#$d2#$b2'?'#$c1#$ca'?'#$80#$c2'?'#$f6) then
      begin
        datei_lesen(exe_tmp_puffer,codeoff_seg*16+codeoff_off+$33+word_z(@codepuffer.d[$31])^,512);
        if bytesuche(exe_tmp_puffer.d[0],#$1e#$b8#$00#$fe#$8e#$d8) then
          exezk:='BIOS'
        else if bytesuche(exe_tmp_puffer.d[0],#$b4#$04#$cd#$1a) then
          begin
            exezk:='DATE ';
            exezk_anhaengen(str_(bcd_zu_dezimal(word_z(@exe_tmp_puffer.d[6])^),4));
            exezk_anhaengen('.');
            exezk_anhaengen(str_(bcd_zu_dezimal(exe_tmp_puffer.d[13]),2));
            exezk_anhaengen('.');
            exezk_anhaengen(str_(bcd_zu_dezimal(exe_tmp_puffer.d[12]),2));
          end
        else if exe_tmp_puffer.d[0]=$e9 then
          begin
            exezk:='PASS "';
            for w1:=1 to exe_tmp_puffer.d[1] do
              exezk_anhaengen(Chr(256-exe_tmp_puffer.d[3+w1-1]));
            exezk_anhaengen('"');
          end
        else
          exezk:='?';

        ausschrift('HCF / Robino R. [3.0 '+exezk+']',packer_exe);
      end;

    if  bytesuche_codepuffer_0(#$be'??'#$b9#$64#$01#$87) then
      begin (* (SI) *)
        passcom_l2:=word_z(@codepuffer.d[1])^;
        if (codeoff_off+$20<passcom_l2) and (passcom_l2<codeoff_off+$300) then
          if bytesuche__datei_lesen(analyseoff+longint(codeoff_seg)*16+passcom_l2-8,
            #$46#$46#$49#$74#$03#$e9) then
            ausschrift('PassCOM 2.0 / Black Wolf Enterprises',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$be'?'#$01#$bf'??'#$b9'??'#$56#$fc#$f3#$a5#$5f#$e9) then
      begin
        ausschrift('PACK / Sergey Belyakov',packer_exe);
        if word_z(@codepuffer.d[3+1])^=((codeoff_off+$111+1) and -2) then
          begin
            (* 0.48 *)
            datei_lesen(exe_tmp_puffer,ds_off+$100,$20);
            if bytesuche(exe_tmp_puffer.d[0],'ZRDX') then
              ausschrift('Zurenava DOS Extender / Sergey Belyakov '+puffer_zu_zk_l(exe_tmp_puffer.d[0+4],4),dos_win_extender);
            if bytesuche(exe_tmp_puffer.d[2],'ZRDX') then
              ausschrift('Zurenava DOS Extender / Sergey Belyakov '+puffer_zu_zk_l(exe_tmp_puffer.d[2+4],4),dos_win_extender);
          end;

      end;

    {doppelt aber nicht getestet if bytesuche_codepuffer_0(#$be#$12#$01#$bf'??'#$b9'??'#$56#$fc#$f3#$a5#$5f#$e9) then
      begin
        (* 0.45 mit XE aus XTMTP *)
        datei_lesen(exe_tmp_puffer,ds_off+$100,$20);
        ausschrift('Zurenava DOS Extender / Sergey Belyakov '+puffer_zu_zk_e(exe_tmp_puffer.d[0],#0,$12),dos_win_extender);
      end;}


    (* viel bessere ausschrift mit typ_poem
    if bytesuche_codepuffer_0(#$be#$81#$00#$fc#$e8'??'#$ac#$3c#$0d#$74) then
      begin
        datei_lesen(exe_tmp_puffer,analyseoff+codeoff_seg*16+$100+$280,512);
        w1:=puffer_pos_suche(exe_tmp_puffer,'Cute',500);
        if w1<>nicht_gefunden then
          ausschrift('Cute Mouse Driver / Nagy Daniel "'+puffer_zu_zk_e(exe_tmp_puffer.d[w1],#0,40)+'"',signatur);
      end; *)

    if bytesuche_codepuffer_0(#$be'??'#$bd'??'#$55#$8b#$ce#$8d'??'#$bf) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<GPatch / JES [1.2b]>',packer_exe);

    if bytesuche_codepuffer_0(#$be'??'#$81#$c6'??'#$fa#$8e#$d8#$ff#$36'??'#$ff#$36'??'#$a1) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<PROARJ/PrO)(ZoS>',packer_exe);

    if bytesuche_codepuffer_0(#$be'??'#$b9'??'#$26#$81#$34'??'#$46#$46#$e2#$f7) then
      (* verursacht sonst auch passcom / black worlf *)
      ausschrift(textz_exe__Verschluesselung^+textz_exe__leer_zu^
      +' Junkie / DrWhite [XOR '+hex_word(word_z(@codepuffer.d[9])^)+']',virus);

    if bytesuche_codepuffer_0(#$BE'??'#$BF'??'#$B9'??'#$3B#$FC#$72#$04) then
      (* CHEAT MACHINE zu PRINCE 2 *)
      begin
        w1:=word_z(@codepuffer.d[$4])^-word_z(@codepuffer.d[$21])^;
        case w1 of
          $016e,
          $016f:exezk:='1.10a';
          $016b,
          $016c:exezk:='1.20';
        else
                exezk:='1.?? ¯';
        end;

        ausschrift('Diet / Teddy Matsumoto ['+exezk+' .COM]',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$BE#$b5#$01#$b9#$07#$00#$8a#$04) then
      begin
        ausschrift('NUCOM / Rexxcom Systems [3.5]',musik_bild);
        thegrab(analyseoff+$3c3,25,160,'');
      end;

    if bytesuche_codepuffer_0(#$be'??'#$bf'??'#$b9'??'#$8c#$cd) then
       begin
         (* PR *)
         ausschrift('WWPACK / Rafal Wierzbicki '+textz_exe__und^+' Piotr Warezak '
           +wwpack_version(14
                          +byte__datei_lesen(analyseoff+codeoff_off+codeoff_seg*16-1)
                           ),packer_exe);

         if kopftext<>'WWP ' then
           kopftext_anzeige(textz_exe__veraenderter_Kopf^,packer_exe);
         kopftext_nullen;
       end;


    if bytesuche_codepuffer_0(#$be'??'#$ba'??'#$bf'??'#$b9'??'#$8c#$cd) then
       begin
         ausschrift('WWPACK / Rafal Wierzbicki '+textz_exe__und^+' Piotr Warezak [3.01 PR]',packer_exe);
         if kopftext<>'WWP ' then
           kopftext_anzeige(textz_exe__veraenderter_Kopf^,packer_exe);
         kopftext_nullen;
       end;

    if bytesuche_codepuffer_0(#$be'??'#$bb'??'#$02#$1f#$43#$8A#$04#$88#$07) then
      ausschrift('CAN / Dave Dunfield  Parameter: "'+puffer_zu_zk_e(codepuffer.d[$2a],#$0d#$e9,255)+'"',packer_exe);

    if bytesuche_codepuffer_0(#$be#$03#$01#$8b#$fe#$b9'??'#$ac#$34#$45#$aa) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<Harry Lime CRUE>',packer_exe);

    if bytesuche_codepuffer_0(#$be#$0e#$01#$89#$f7#$b9) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<EMPIRE> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$be#$81#$00#$ac#$3c#$0d#$74#$2e#$3c#$2d) then
      begin
        ausschrift('INSTALLIT Multilingual WIN.COM '+textz_exe__Starter^,packer_dat);
        hersteller_erforderlich:=falsch; (* keine Nullen *)
      end;


    if bytesuche_codepuffer_0(#$be#$00#$01#$56#$b9'??'#$c7#$04'??'#$c6#$44'??'#$81#$34) then
      ausschrift('CryptCom 2.0 / Nowhere Man [XOR '+hex_word(word_z(@codepuffer.d[$11])^)+']',packer_exe);

    if bytesuche_codepuffer_0(#$be#$d0#$01#$8b#$04#$3d'??'#$74#$01#$cb) then
      (* PASCAL.COM / ACP *)
      begin

        if bytesuche(codepuffer.d[6],'MZ') then
          exezk:=''
        else
          if bytesuche(codepuffer.d[6],'ZM') then
            exezk:=' "ZM"'
          else
            exezk:=' ['+textz_exe__modifiziert^+' Doctor Stein''s Labs (MZ!)]';

        ausschrift(textz_exe__Konverter^+' EXE->COM / BuZZ Soft'+exezk,packer_exe);
        einzel_laenge:=$d0;
      end;

    if bytesuche_codepuffer_0(#$be#$f0#$01#$8b#$04#$3d'MZ'#$74#$09) then
      (* CHLIB/Spyral *)
      begin
        ausschrift('ExeToCom / RaskY',packer_exe);
        einzel_laenge:=$f0;
      end;

    if bytesuche_codepuffer_0(#$be#$b0#$01#$8b#$c6#$b1#$04#$d3#$e8#$8c#$db#$03#$c3#$03#$44#$08) then
      begin
        (*ausschrift(textz_exe__Konverter^+' EXE -> COM <JMT-CP5.COM/JauMing Tseng>',packer_exe);*)
        ausschrift(textz_exe__Konverter^+' EXE -> COM Kevin Executable file Kit / JauMing Tseng [1.16b]',packer_exe);
        einzel_laenge:=$b0;
      end;

    if bytesuche_codepuffer_0(#$be#$4a#$01#$bf#$50#$fe#$b9'?'#$00#$fc#$57) then
      (* UNTPACK *)
      begin
        einzel_laenge:=word_z(@codepuffer.d[1])^-$100+word_z(@codepuffer.d[6+1])^*2;
        case codepuffer.d[6+1] of
          $32:exezk:='1.02a';
          $53:exezk:='1.02b (RELO)';
        else
              exezk:='1.0? ¯'
        end;
        ausschrift('E2C / DoP ['+exezk+']',packer_exe);
      end;

  end;

procedure exe_bf;
  var
    passcom_l2          :word;
    dos16mpuffer        :puffertyp;
    dos4g_text          :string;
    w1                  :word_norm;
  begin

    if bytesuche_codepuffer_0(#$bf#$e4#$00#$be#$52#$01#$b9#$0e#$00#$f3#$a4#$8c#$d8#$05#$16) then
      begin
        (* CC / UniHackers Group [2.61] *)
        ausschrift('Micro EXE-to-COM / Anry Hacker',packer_exe);
        einzel_laenge:=$60;
      end;

    if  bytesuche_codepuffer_0(#$bf'??'#$b9#$64#$01#$87) then
      begin (* (DI) *)
        passcom_l2:=word_z(@codepuffer.d[1])^;
        if (codeoff_off+$20<passcom_l2) and (passcom_l2<codeoff_off+$300) then
          if bytesuche__datei_lesen(analyseoff+longint(codeoff_seg)*16+passcom_l2-8,
            #$47#$47#$49#$74#$03#$e9) then
            ausschrift('PassCOM 2.0 / Black Wolf Enterprises',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$BF#$00#$00#$8E) then
      begin
        (* DOS/4G oder DOS/16M *)
        datei_lesen(dos16mpuffer,org_code_imagestart,512);
        w1:=puffer_pos_suche(dos16mpuffer,'DOS/',500);
        if w1=nicht_gefunden then
          dos4g_text:='DOS/4G'
        else
          dos4g_text:=puffer_zu_zk_e(dos16mpuffer.d[w1],' ',14);

        dos4g_text:=dos4g_text+' Rational Systems, Tenberry Software * DOS Extender * ';

        (* DOOM,INDYCAR,...*)
        exezk:=' ?.??';
        if einzel_laenge= $d56a then exezk:=' 1.30';
        if einzel_laenge= $d1c8 then exezk:=' 1.40';
        if einzel_laenge= $d55d then exezk:=' 1.60';
        if einzel_laenge= $dde3 then exezk:='CA-Realia'; (* /16M *)
        if einzel_laenge= $e2f3 then exezk:=' 1.80';

        if einzel_laenge= $f284 then exezk:=' 1.90'; (* Mortal Combat *)

        if einzel_laenge= $f264 then
          if codepuffer.d[$78]=$9c then
            exezk:=' 1.93,1.94' (* ?? DOOM *)
          else
            exezk:=' 1.92';

        if einzel_laenge= $F2A4 then exezk:=' 1.95';
        if einzel_laenge= $F444 then exezk:=' 1.96';
        if einzel_laenge= $F474 then exezk:=' 1.97';
        if einzel_laenge= $FB90 then exezk:='RMINFO'; (* /16M *)
        if einzel_laenge=$10060 then exezk:='PMINFO'; (* /16M *)
        if einzel_laenge= $F424 then exezk:=' 2.0X';  (* C&C Red Alarm *)
        if einzel_laenge= $eed0 then exezk:='NU10';   (* /16M: NDD/UNFORMAT *)

        if exezk[1]=' ' then
          dos4g_text:=dos4g_text+textz_exe__Version^;

        ausschrift(dos4g_text+exezk,dos_win_extender);

        if w1<>nicht_gefunden then
          ausschrift(puffer_zu_zk_e(dos16mpuffer.d[w1],#0,80),beschreibung);
      end;


    if bytesuche_codepuffer_0(#$BF'??'#$8B#$36'??'#$2B) then
      (* CRACKER.EXE C 1985 *)
      c_copy_run(longint(word_z(@codepuffer.d[$1])^)*16+8,
       '','Microsoft '+textz_exe__Laufzeitbibliothek^+' [C]',compiler,10,#0,'Mic');

    if bytesuche_codepuffer_0(#$BF'??'#$3B#$FC#$72#$04#$B4#$4C#$CD#$21#$BE) then
      begin
        ausschrift('Diet / Teddy Matsumoto [1.00 .COM]',packer_exe);
        (* COM ? *)
        kopftext_nullen;
      end;

    if bytesuche_codepuffer_0(#$BF'??'#$3B#$FC#$72#$04#$B4#$4C#$CD#$20#$BE) then
      begin
        ausschrift('Diet / Teddy Matsumoto [1.00 '+textz_exe__veraendert_frage^+'] ¯',packer_exe);
        kopftext_nullen;
      end;

    if bytesuche_codepuffer_0(#$bf'??'#$3b#$fc#$72#$04#$cd#$20'IK'#$fd#$be'??'#$b9'??'#$f3#$a5) then
      ausschrift('<FIO+DIET1.00?> / Igor Khristoforov',packer_exe);


    if bytesuche_codepuffer_0(#$BF#$00#$10#$b8'??'#$fa#$8e#$d0#$8b#$e7#$fb) then
      ausschrift(textz_exe__unbekannte_Kompression^+'Russ <TFX>',packer_exe);

    if bytesuche_codepuffer_0(#$bf'??'#$8a'??'#$32#$ed#$b0'?'#$f2#$ae) then
      begin
        ausschrift(textz_exe__unbekannter^+' WIN.COM-'+textz_exe__Starter^+' <bf>',packer_exe);
        hersteller_erforderlich:=falsch; (* keine Nullen *)
      end;

    if bytesuche_codepuffer_0(#$bf'??'#$b9'??'#$8b#$c1#$fd#$33#$05) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<Budokan>',packer_exe);

    if bytesuche_codepuffer_0(#$bf#$03#$01#$ba#$00#$00#$0e#$1f#$b7#$0b#$8a#$05) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<KILOTRN/Mr.Mb>',packer_exe);

    if bytesuche_codepuffer_0(#$bf'??'#$be'??'#$b9'??'#$fd#$f3#$a5#$fc#$8b#$f7#$bf) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<DAVE-T/PHOENIX>',packer_exe);

    if bytesuche_codepuffer_0(#$bf'??'#$be'??'#$b9'??'#$fd#$f3#$a5#$fc#$eb#$06(* 'TiGGER'*)) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<PATCHPAS/Basil V. Vorontsov>',packer_exe);

    if bytesuche_codepuffer_0(#$bf'??'#$be'??'#$b9'??'#$ac#$32#$06#$09#$01) then
      ausschrift('Command Obfuscation Processor / Jack A. Orman [1.0] (XOR '
       +hex_word(word_z(@codepuffer.d[$118-$100])^)+')',packer_exe);

    if bytesuche_codepuffer_0(#$bf#$00#$01#$57#$b9'??'#$c7#$05'??'#$c6#$45#02'?'#$81) then
      ausschrift(textz_exe__unbekannte_Verschluesselung^+'<in HS386.EXE/Ralph Roth>',packer_exe);

  end;

procedure exe_c7;
  begin
    if bytesuche_codepuffer_0(#$c7#$06#$01#$01'??'#$be'??'#$bf'??'#$b8#$00#$00#$fd#$8b#$0c) then
      (* TPOWER.LZH\DIFF.COM *)
      ausschrift(textz_exe__unbekannte_Kompression^+'<TurboPower Utilities/1991/Kim Kokkonen>',packer_exe);

    if bytesuche_codepuffer_0(#$C7#$06#$5C#$00'??'#$8C) then
      (* UNP 3.10 bei PKZIP 2.04g *)
      ausschrift('"'+chr(codepuffer.d[4])+chr(codepuffer.d[5])+'"-Signatur - Programmbetrug ( Unp )',signatur);

    if bytesuche_codepuffer_0(#$C7#$06#$5C#$00'??'#$E9) then
      (* DISLITE *)
      ausschrift('"'+chr(codepuffer.d[4])+chr(codepuffer.d[5])+'"-Signatur - Programmbetrug ( Dislite )',signatur);

    if bytesuche_codepuffer_0(#$C7#$06'????'#$80#$3E'???'#$75) then

      begin
        (* ACCESS II ACC_BUCH, TXT2COM V. 1.1 *)
        ausschrift('TXT2COM / Keith P. Graham [1.01˙˙1.03˙]',compiler);
        suche_txt2com_titel(750);
      end;
  end;

procedure exe_c8;
  begin
    if bytesuche_codepuffer_0(#$C8#$00#$00#$00#$53#$51#$52#$56) then
      if codepuffer.d[8]=$8b then
        (* GERMANY3 *)
        ausschrift('Borland DPMI16BI.OVL DMPI-Server',dos_win_extender)
      else
        ausschrift('Borland DPMI32VM.OVL DMPI-Server',dos_win_extender);

  end;

procedure exe_cc;
  begin
    (* FI: Crypt v1.3 (cOm) [1995] ............... 04K_13.COM    ......4269   1999-12-13 *)
    if bytesuche_codepuffer_0(#$cc#$b4#$01#$be#$19#$01#$bf#$ff#$fd#$b9'?'#$00#$68#$00#$01#$68'?'#$01#$68) then
      ausschrift('Crypt / ? [1.3 com +'+str0(codepuffer.d[$10])+']',packer_exe);
  end;

procedure exe_cd;
  begin
    if bytesuche_codepuffer_0(#$cd#$11#$24#$30) then
      ausschrift('Creative '+textz_exe__Betrachter^,signatur);

    if bytesuche_codepuffer_0(#$cd#$20) then
      begin
        if bytesuche(codepuffer.d[2],'sLiM') then
          ausschrift('SLIM / Dominic Herity  Methode '+str0(codepuffer.d[7]),packer_dat)
        else
          ausschrift(textz_exe__Programmabbruch^,signatur);
      end;
  end;

procedure exe_e4;
  begin
    if bytesuche_codepuffer_0(#$e4#$21#$2E#$a2'??'#$0c#$02) then
      ausschrift(textz_exe__unbekannter_Anti_Debug_Schutz^+' <ACME>',packer_exe);
  end;

procedure exe_f6;
  var
    l1:longint;
  begin
    if bytesuche_codepuffer_0(#$f6#$06'???'#$74'?'#$ba'??'#$b4#$09#$cd#$21#$b4#$07) then
      begin
        l1:=DGT_zu_longint(word_z(@codepuffer.d[2])^+analyseoff+ds_off);
        exezk:=puffer_zu_zk_e(codepuffer.d[l1]
         ,#0,512-l1);
        if exezk<>'' then exezk:=' "'+filter(exezk)+'"';
        ausschrift('NETPIC / Jim Tucker [1.0e,4.2]'+exezk,musik_bild);
      end;
  end;

procedure exe_f8;
  var
    exe_tmp_puffer:puffertyp;
  begin
    if bytesuche_codepuffer_0(#$f8#$60#$f9#$72#$1f) then
      begin
        exezk:='(BPLN[???] ¯)';
        if bytesuche(codepuffer.d[$2e],#$33#$ed#$e8'??'#$e8'??'#$8b#$c4) then
            exezk:='BPLN[16]';
        if bytesuche(codepuffer.d[$2e],#$33#$ed#$8b#$c4) then
          exezk:='TPLN[19]';

        ausschrift('Turbo/Borland Pascal 6,7'+textz_exe__mit^+textz_exe__Laufzeitbibliothek^
          +' '+exezk+' / Norbert Juffa',compiler);
        datei_lesen(exe_tmp_puffer,
          analyseoff+word_z(@codepuffer.d[$22])^+$22+$72+longint(codeoff_seg)*16+longint(codeoff_off),
          4*16);
        ausschrift(puffer_zu_zk_l(exe_tmp_puffer.d[0],4*16),beschreibung);
      end;
  end;

procedure exe_f9;
  var
    diet_diff           :longint;
    w1                  :word_norm;
  begin
    if bytesuche_codepuffer_0(#$f9#$b9'??'#$be'??'#$bf'?'#$ff#$bd#$00#$01#$55#$60#$fd#$57) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<UXLBPMUL.COM/ACE>',packer_exe);

    if bytesuche_codepuffer_0(#$f9#$9c#$eb#$09) then
      begin
        if (exe_kopf.pruefsumme<>$899D) then pruefsummezeigen:=wahr;

        case codepuffer.d[$19] of
          $2e:(* 1.44  *)
            begin
              exezk:='1.43,1.44..1.45d '+textz_exe__Vorsicht_auf_486^;


              diet_diff:=(longint(word_z(@codepuffer.d[$69-$20])^-word_z(@codepuffer.d[$46-$20])^)*16
               +word_z(@codepuffer.d[$67-$20])^ ) and $fffff
                  -(longint(codepuffer.d[$4e] and $0f)*$10000+word_z(@codepuffer.d[$4f])^);

              case diet_diff of
                $0cf:;
                $113:exezk_anhaengen(' -G');
              else
                     exezk_anhaengen('?? ¯');
              end;

            end;
          $ba:(* 1.45f *)
            begin

              exezk:='1.45f';

              diet_diff:=(longint(word_z(@codepuffer.d[$1a])^-word_z(@codepuffer.d[$2b])^)*16
                          +word_z(@codepuffer.d[$20])^) and $fffff
                  -(longint(codepuffer.d[$4f] and $0f)*$10000+word_z(@codepuffer.d[$50])^);

              case diet_diff of
                $0d0:;
                $114:exezk_anhaengen(' -G');
              else
                     exezk_anhaengen('?? ¯');
              end;
            end;

        else
            exezk:='1.?? ¯'
        end;

        ausschrift('Diet / Teddy Matsumoto ['+exezk+ (* ' '+str(diet_diff,4)+*) ']',packer_exe);

        if (kopftext<>'diet') then
          kopftext_anzeige(textz_exe__veraenderter_Kopf^,packer_exe);
        kopftext_nullen;
      end;

    if bytesuche_codepuffer_0(#$F9#$9C#$EB#$0A'??????????'#$55#$06) then
      begin
        w1:=word_z(@codepuffer.d[$2b])^-word_z(@codepuffer.d[$3f])^;
        case w1 of
          $00c7,
          $00c8:exezk:='1.44..1.45f -G';
          $00ac,
          $00ad:exezk:='1.43..1.45f';
        else
                exezk:='1.4?? ¯';
        end;
        ausschrift('Diet / Teddy Matsumoto ['+exezk+' -XC .COM]',packer_exe);
      end;

  end;

procedure exe_fa;
  var
    l1                  :longint;
    f1                  :dateigroessetyp;
    exe_tmp_puffer      :puffertyp;
    w1                  :word_norm;
  begin

    case codepuffer.d[1] of
      $16:
        begin
          if bytesuche_codepuffer_0(#$fa#$16#$1f#$26#$a1'??'#$83#$e8'?'#$8e#$d0#$fb#$06) then
            begin
              case codepuffer.d[9] of
                $10:exezk:='2.65,69, 3.08,14';
                $40:exezk:='3.25..3.49'; (* '3.25,34,38,41,49' *)
              else
                    exezk:='?.??';
              end;
              ausschrift('Causeway DOS Extender / Michael Devore ['+exezk+']',dos_win_extender);
              if exe then
                ansi_anzeige(analyseoff+longint(exe_kopf.kopfgroesse+exe_kopf.stackoffset)*16
                 +word_z(@codepuffer.d[$10+1])^+$22,
                 #0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
            end;

        end;
      $2e:
        begin
          if bytesuche_codepuffer_0(#$FA#$2E#$8C#$16'??'#$2E#$89#$26'??'#$8c#$c8#$8e#$d0#$8d#$06) then
            (* HC 1.2 .EXE *)
            ausschrift('HELPCOM '+textz_exe__fuer^+' .EXE / Geoff Friesen',signatur);
        end;
      $33:
        begin

          if bytesuche_codepuffer_0(#$fa#$33#$db#$b9'??'#$0e#$1f#$33#$f6#$fc#$ad) then
            begin
              case codepuffer.d[4] of
                $18:exezk:='1.03';
                $33:exezk:='1.10';
              else
                    exezk:='1.?? ¯';
              end;
              ausschrift('Antivirial Vaccine / Rustam M. Abdrakhimov ['+exezk+']',packer_exe);
            end;

        end;
      $8b:
        begin
          if bytesuche_codepuffer_0(#$FA#$8B#$EC#$E8#$00#$00#$5B) then
            cascade(codepuffer);

        end;
      $8c:
        begin
          if bytesuche_codepuffer_0(#$fa#$8c#$c8#$8e#$d0#$bc#$00#$04#$fb#$8c#$ca#$be#$00#$04#$1e#$2b#$c0) then
            begin
              ausschrift('ES / Veit Kannegieser',packer_exe);
              if exe then
                einzel_laenge:=exe_kopf.kopfgroesse*16+$400-$100
              else
                einzel_laenge:=$400-$100;
            end;

          if bytesuche_codepuffer_0(#$FA#$8C#$d8#$05#$10#$00#$8e#$d8#$8e#$d0) then
            begin
              ausschrift('Intel Code Builder (DOS-Extender)',dos_win_extender);
              codebuilder:=wahr;
            end;

          if bytesuche_codepuffer_0(#$fa#$8c#$c3#$83#$c3#$10#$8b#$d3) then
            ausschrift(textz_exe__unbekannte_Verschluesselung^+'<TRAK/Volker Zinke>',packer_exe);

        end;
      $b8:
        begin

          (* bessere UnterstÅtzung in TYP_POEM
          ( * LOADDSKF.EXE / SAVEDSKF.EXE * )
          if bytesuche_codepuffer_0(#$fa#$b8'??'#$8e#$d0#$bc'??'#$fb#$8e#$c0#$1e#$8e#$d8#$b4#$30#$cd#$21
            +#$86#$c4#$3d#$14#$03'??'#$ba'??'#$b4) then
            ansi_anzeige(analyseoff+ds_off+$100+longint(word_z(@codepuffer.d[$1+1])^)*16+word_z(@codepuffer.d[$1a+1])^
              ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');*)

          if bytesuche_codepuffer_0(#$FA#$B8'??'#$8E#$D8#$B8'??'#$8E#$D0#$BC#$80#$00) then
            c_copy_run(longint(word_z(@codepuffer.d[2])^)*16+2,'','Lattice-C',compiler,7,#0,'');

          if bytesuche_codepuffer_0(#$FA#$B8'??'#$05#$10#$00#$B1#$04#$D3#$E8) then
            c_copy_run((longint(word_z(@codepuffer.d[2])^+$10) div 16 )*16+2-$100,'','Lattice-C',compiler,7,#0,'');

          if bytesuche_codepuffer_0(#$FA#$B8'??'#$05#$0f#$00#$B9#$04#$00#$d3#$E8) then
            begin
              l1:=longint(word_z(@codepuffer.d[2])^)+longint(word_z(@codepuffer.d[5])^)-$100;
              l1:=l1 and -16;
              c_copy_run(codeoff_off+l1+codeoff_seg*16+17,'','Zortech-C',compiler,7,#0,'');
            end;

          if bytesuche_codepuffer_0(#$fa#$b8'??'#$db#$e3#$8e#$d8#$8c#$06) then
            c_copy_run(longint(word_z(@codepuffer.d[2])^)*16+$14,'','Zortech C [4.00]',compiler,7,#0,'');

          if bytesuche_codepuffer_0(#$FA#$B8'?'#$8E#$D8#$B8'??'#$8E#$D0) then
            if bytesuche(codepuffer.d[2],#$00#$02#$8E#$D8#$B8#$89#$11) then
              (* MMFILES DRHALO *)
              ausschrift('PKArc Sfx 3.5',packer_dat)
            else
              (* COMPUSOFT GERALD *)
              ausschrift('Clipper / Nantucket ',compiler);

          if bytesuche_codepuffer_0(#$fa#$b8#$09#$35#$cd#$21#$89#$1e) then
            begin
              ausschrift('TSRMaker / Jack A. Orman [1.1]',compiler);
              ansi_anzeige(analyseoff+codeoff_off+16*longint(codeoff_seg)+$8d1-$8ae,
               '$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
            end;

        end;
      $bb:
        begin (* MOV BX,$xxxx / JMP BX *)
          if bytesuche_codepuffer_0(#$fa#$bb'??'#$ff#$e3) then
            rcc_test(word_z(@codepuffer.d[2])^);
        end;
      $bc:
        begin
          if bytesuche_codepuffer_0(#$fa#$bc'??'#$ff#$e4) then
            rcc_test(word_z(@codepuffer.d[2])^);
        end;
      $bd:
        begin
          if bytesuche_codepuffer_0(#$fa#$bd'??'#$ff#$e5) then
            rcc_test(word_z(@codepuffer.d[2])^);
        end;
      $be:
        begin
          if bytesuche_codepuffer_0(#$fa#$be'??'#$ff#$e6) then
            rcc_test(word_z(@codepuffer.d[2])^);
        end;
      $e8:
        begin
          if bytesuche_codepuffer_0(#$fa#$e8#$00#$00#$58#$2d'??'#$74) then
            ausschrift(textz_exe__unbekannte_Kompression^+'<AMOUR>',packer_exe);
        end;
      $e9:
        begin
          if bytesuche_codepuffer_0(#$FA#$e9#$ae#$06) then
            begin
              exezk:='';
              for w1:=1 to codepuffer.d[$22] do
                exezk_anhaengen(chr(codepuffer.d[w1-1+$e] xor $31));
              ausschrift('"'+textz_exe__Softwareschutz^+'" / Manfred Bunjes * '
                +textz_exe__Kennwortversion^+' "'+exezk+'"',signatur);
            end;

          if bytesuche_codepuffer_0(#$FA#$e9#$bf#$09) then
            ausschrift('"'+textz_exe__Softwareschutz^+'" / Manfred Bunjes * '
              +textz_exe__Manipulationsschutz^,signatur);

          if bytesuche_codepuffer_0(#$FA#$e9#$e9#$08) then
            ausschrift('"'+textz_exe__Softwareschutz^+'" / Manfred Bunjes * '
              +textz_exe__Installationsschutz^,signatur);

        end;
      $fc:
        begin
          (* AMIFLASH 4.60,4.65 *)
          if bytesuche_codepuffer_0(#$fa#$fc#$b0#$01#$e6#$80#$2e#$8c#$16#$04#$05#$2e#$89#$26) then
            if bytesuche(codepuffer.d[$31],#$cd#$10#$e8'??'#$b3#$07#$be) then
              ansi_anzeige(analyseoff+ds_off+word_z(@codepuffer.d[8])^
                ,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');

          (* AMIFLASH 6.31 *)
          if bytesuche_codepuffer_0(#$fa#$fc#$50#$b0#$00#$e6#$80#$58#$2e#$8c#$16'??'#$2e) then
            begin
              f1:=datei_pos_suche(analyseoff,analyseoff+einzel_laenge,
                #$ba#$14#$01#$b3#$07#$be'??'#$e8'??'#$be'??'#$e8'??'#$c3);
              if l1<>nicht_gefunden then
                ansi_anzeige(analyseoff+ds_off+x_word__datei_lesen(l1+6)
                ,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
            end;

          if bytesuche_codepuffer_0(#$FA#$FC#$2E#$89#$16#$F2#$02#$2E#$89#$26) then
            begin
              case codepuffer.d[$16] of
                $34:exezk:='3.20';
                $c4:exezk:='3.30';
                $a4:exezk:='3.30 (IBM)';
              else
                exezk:='3.?? ¯';
              end;
              (* TADOS ,.. *)
              ausschrift('MSDOS.SYS   / MS ≥ IBMDOS.COM  / IBM  DOS '+exezk,dos_win_extender);
            end;

          if bytesuche_codepuffer_0(#$FA#$FC#$52#$56#$1E#$57#$8C#$C3) then
            begin
              datei_lesen(exe_tmp_puffer,analyseoff+9,2);
              ausschrift('MSDOS.SYS   / MS ≥ IBMDOS.COM  / IBM  DOS '
                +str_(exe_tmp_puffer.d[0],1)+'.'+str_(exe_tmp_puffer.d[1],2)
                ,dos_win_extender);
              suche_bin_bldlevel;
            end;

          if bytesuche_codepuffer_0(#$FA#$FC#$B8'??'#$8E#$D8#$8C#$06) then
            c_copy_run(longint(word_z(@codepuffer.d[3])^)*16+20,'','Zortech+Symantec C',compiler,10,#0,'');
            (* auch symantec *)

          if bytesuche_codepuffer_0(#$fa#$fc#$8c#$c8#$8e#$d8#$8e#$d0#$bc#$10#$00#$9c#$bc#$2e#$00#$c2) then
            ausschrift(textz_exe__unbekannte_Kompression^+'<Renaisance>',packer_exe);

          if bytesuche_codepuffer_0(#$fa#$fc#$0e#$1f#$e8'??'#$8c#$c0#$66)
          or bytesuche_codepuffer_0(#$fa#$fc#$0e#$1f#$e8'??'#$e8'??'#$8c#$c0#$66)
           then
            ausschrift('DOS-Extender PMODE [2.51] / Thomas Pytel',dos_win_extender);

          if bytesuche_codepuffer_0(#$FA#$FC#$0e#$1f#$0e#$17) then
            (* LW A: B: *)
            ausschrift(textz_exe__Systemauswahl^+' / DR-DOS + Novell DOS [Fdisk]',signatur);

          if bytesuche_codepuffer_0(#$fa#$fc#$8c#$c8#$8e#$d0#$bc'??'#$81#$e4#$fe#$ff#$1e#$8e#$d8) then
            ausschrift(textz_exe__Systemauswahl^+' / DR-DOS + Novell DOS [Loader.Com]',signatur);


        end;
     end;(* CASE *)
  end;

procedure exe_fb;
  var
    exe_tmp_puffer:puffertyp;
  begin
    if bytesuche_codepuffer_0(#$fb#$e4#$21#$50#$b0#$ff#$e6#$21#$2e#$c6#$06#$00#$01'?'#$2e#$c7#$06) then
      ausschrift('ExeConv / Conea Software [3.06 /P]',packer_exe);

    if bytesuche_codepuffer_0(#$fb#$fc#$1e#$07#$1e#$0e#$1f#$50#$33#$f6#$8a#$44#$05#$3c#$9a#$75'?'#$e8) then
      begin
        datei_lesen(exe_tmp_puffer,codeoff_seg*16+codeoff_off+$14+word_z(@codepuffer.d[$12])^,30);
        (* IBMBIO.COM,IBMDOS.COM DRDOS 7.03 Beta "VeRsIoN".. *)
        if bytesuche(exe_tmp_puffer.d[0],#$be'??'#$75#$04#$81#$ee) then
          ansi_anzeige(analyseoff+ds_off+word_z(@exe_tmp_puffer.d[1])^-word_z(@exe_tmp_puffer.d[7])^
          ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');

      end;

    if bytesuche_codepuffer_0(#$fb#$0e#$1f#$8c#$1e'??'#$8c#$06'??'#$8c#$16'??'#$26#$a1#$2c#$00#$a3'??'#$fc#$e8) then
      begin
        datei_lesen(exe_tmp_puffer,analyseoff+ds_off+$118,2);
        ausschrift('DOS/32 Advanced / Supernar Systems'
          +version_x_y(exe_tmp_puffer.d[1],exe_tmp_puffer.d[0]),dos_win_extender);
      end;

    if bytesuche_codepuffer_0(#$fb#$ba'??'#$2e#$89) then
      (* DR-DOS DISKOPT.EXE *)
      tc_verfolgung(codepuffer);

    if bytesuche_codepuffer_0(#$FB#$B9'??'#$8E#$C1#$BB)
    or bytesuche_codepuffer_0(#$FB#$B9'??'#$BB'??'#$8E#$C1#$26)
    or bytesuche_codepuffer_0(#$FB#$B9'??'#$8e#$c1#$26#$bb'??'#$83)
      then
      (* GEOSCAPE.EXE , TACTICAL.EXE ,     VRF_DLL.EX2 [SC2000] *)
      begin
        datei_lesen(exe_tmp_puffer,org_code_imagestart+org_code_seg*16+org_code_off,512);
        if bytesuche(exe_tmp_puffer.d[3],'Open')
        or bytesuche(exe_tmp_puffer.d[3],'WATCOM')
        or bytesuche(exe_tmp_puffer.d[3],'Watcom') then
          ausschrift_watcom(exe_tmp_puffer,3,140)
        else
          ausschrift('Watcom C',compiler);
      end;

    if bytesuche_codepuffer_0(#$fb#$2e#$8c#$1e#$22#$02#$2e#$8c#$06) then
      begin
        datei_lesen(exe_tmp_puffer,analyseoff+longint(codeoff_seg)*16+codeoff_off-$50+$3a2,$20);
        ausschrift('USERNAME / Jordi Mas Hern†ndez [3.00 .EXE] "'+username300_pw(exe_tmp_puffer)+'"',packer_exe);
      end;
  end;

procedure exe_fc;
  var
    exe_tmp_puffer      :puffertyp;
    ldiff_archivanfang  :dateigroessetyp;
    f1                  :dateigroessetyp;
    bootblob            :buntzeilen_typ;
    w1                  :word_norm;
  begin

    (* 2.10 *)
    if bytesuche_codepuffer_0(#$fc#$be'??'#$e8'??'#$8c#$c8#$2e#$03#$06#$02#$01#$8e#$d8#$8e#$d0)
    (* ?.??:LZEX98.COM *)
    or bytesuche_codepuffer_0(#$fc#$56#$be'??'#$e8'??'#$5e#$8c#$c8#$2e#$03#$06#$02#$01)
     then
      begin
        ausschrift('SFX LDIFF / Kazuhiko MIKI [2.10]',packer_dat);
        ldiff_archivanfang:=datei_pos_suche(analyseoff,analyseoff+einzel_laenge,'LDIFF>'#$00'????LZ');
        if ldiff_archivanfang<>nicht_gefunden then
          einzel_laenge:=ldiff_archivanfang+7;
      end;

    if bytesuche_codepuffer_0(#$fc#$be#$03#$01#$bf#$00#$01#$57#$b9'??'#$ac#$34'?'#$aa#$e2#$fa#$c3) then
      (* UN_XOR10 *)
      ausschrift('XorCom / tFF [1.0] "'+chr(codepuffer.d[$d])+'"',packer_exe);

    if bytesuche_codepuffer_0(#$fc#$8c#$db#$33#$c0#$8e#$c0#$b8'??'#$26#$a3#$04#$00) then
      begin
        ausschrift('XLOADER / CyberMan + ST!LLS0N [2.00]',packer_exe);
        einzel_laenge:=$270;
      end;

    if bytesuche_codepuffer_0(#$fc#$8c#$06#$fd#$00#$e4#$21#$a2#$ff#$00) then
      begin
        (* BLUES.COM *)
        case codepuffer.d[$0e] of
          $fb:exezk:='Best Protection Kit-B / Eric Zmiro [1993]';
          $bd:exezk:='Best Protection Kit / Eric Zmiro [1992]';
        else
              exezk:='Best Protection Kit / Eric Zmiro [199?] ¯';
        end;
        ausschrift(exezk,packer_exe);
      end;

    if bytesuche_codepuffer_0(#$fc#$b8#$33#$35#$cd#$21#$8c#$c0#$0b#$c3#$74'?'#$8c#$c6#$33#$c9) then
      ausschrift(textz_exe__Maustreiber^+' [Microsoft]',signatur);

    if bytesuche_codepuffer_0(#$fc#$06#$1e#$0e#$8c#$c8#$01#$06) then
      begin
        case codepuffer.d[8] of
          $35:exezk:='1.10a,1.20';
          $38:exezk:='1.00';
        else
          exezk:='1.?? ¯';
        end;
        ausschrift('Diet / Teddy Matsumoto ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$fc#$0e#$1f#$ba'??'#$e8'??'#$e8'??'#$bb'??'#$8c#$c0#$2b#$d8#$b4#$4a#$cd#$21) then
      begin
        ausschrift('ECLIPSE DOS-Extender [3.00]',dos_win_extender);
        ansi_anzeige(longint(codeoff_seg)*16+word_z(@codepuffer.d[3+1])^
          ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    if bytesuche_codepuffer_0(#$fc#$0e#$1f#$be'??'#$b9'??'#$fe#$0c#$46#$49#$75#$fa#$ba'??'#$e8'??'#$e8'??'#$bb'??'
     +#$8c#$c0#$2b#$d8#$b4#$4a#$cd#$21) then
      begin
        ausschrift('ECLIPSE DOS-Extender [3.03]',dos_win_extender);
        datei_lesen(exe_tmp_puffer,analyseoff+longint(codeoff_seg)*16+word_z(@codepuffer.d[3+1])^,512);
        for w1:=1 to codepuffer.d[6+1] do
          dec(exe_tmp_puffer.d[w1-1]);
        ausschrift(puffer_zu_zk_e(exe_tmp_puffer.d[0],'$',255),beschreibung);
      end;


    if bytesuche_codepuffer_0(#$FC#$16#$07#$bf#$00#$01#$8B#$f7) then
      (* Univbe 5.1 *)
       begin
         ausschrift('PMODE/W / Charles Scheffold + Thomas Pytel ['
          +puffer_zu_zk_l(analysepuffer.d[longint(exe_kopf.kopfgroesse)*16+$1e],4)+']',dos_win_extender);
         if odd(analysepuffer.d[longint(exe_kopf.kopfgroesse)*16+$a]) then
           ausschrift('VCPI '+textz_exe__vor^+' DPMI',signatur)
         else
           ausschrift('DPMI '+textz_exe__vor^+' VCPI',signatur);
       end;

    if bytesuche_codepuffer_0(#$FC#$5F#$81#$EF#$03#$00#$B1#$04#$8C#$C8) then
      if puffer_anzahl_suche(codepuffer,#$1f#$2e#$a3'??'#$b4#$dd#$b2#$00,$100)=0 then
        ausschrift('COMMAND.COM Digital Research DOS 6',dos_win_extender)
      else
        ausschrift('COMMAND.COM Novell DOS 7',dos_win_extender);


    if bytesuche_codepuffer_0(#$fc#$8c#$ca#$8e#$c2#$2e) then
      (* OS2BOOT *)
      ausschrift('OS/2 '+textz_exe__Starter^+' [FAT]',dos_win_extender); (* OS/2 3.0 *)

    (*alt: if bytesuche_codepuffer_0(#$fc#$2e#$8c#$06#$2b#$6e) then*)
    (* Warp 4 FP0, eCS Prev3 *)
    if bytesuche_codepuffer_0(#$fc#$2e#$8c#$06'??'#$2e#$89#$3e'??'#$8c#$c8#$8e#$c0#$bf'??'#$b9'??'
      +#$2b#$cf#$d1#$e9#$33#$c0#$f3#$ab#$b8'??'#$05) then
      begin
        (* OS2LDR *)
        ausschrift('OS/2 '+textz_exe__Lader_des_Betriebssystemkerns^,dos_win_extender); (* OS/2 3.0 *)
        f1:=datei_pos_suche(analyseoff,analyseoff+einzel_laenge,#$bd'??'#$b9'?'#$00#$33#$d2#$8b#$da#$b8#$02#$13#$cd#$10);
        if f1<>nicht_gefunden then
          begin
            datei_lesen(exe_tmp_puffer,f1,512);
            w1:=exe_tmp_puffer.d[4]; (* LÑnge *)
            datei_lesen(exe_tmp_puffer,analyseoff+word_z(@exe_tmp_puffer.d[1])^,2*w1); (* Position *)
            fuell_word(bootblob,SizeOf(bootblob) div 2,$7);
            Move(exe_tmp_puffer.d[0],bootblob[1,1],2*w1);
            schreibe_zeile(bootblob);
          end;
      end;

    if bytesuche_codepuffer_0(#$FC#$BE#$81#$00#$AC#$3C#$20#$74#$FB#$3c#$3f#$74#$1a#$3c#$2f) then
      (* HC 1.2 .COM *)
      ausschrift('HELPCOM '+textz_exe__fuer^+' .COM / Geoff Friesen',signatur);

    if bytesuche_codepuffer_0(#$FC#$BC#$00#$01#$8C#$C8#$05) then
      begin
        ausschrift('Lha Sfx 2.X',packer_dat);
        (* LHA 2.13 *)
        lzh_sfx(codeoff_seg*16+codeoff_off+1000,'Lha / Haruyasu Yoshizaki');
        com2exe_test:=falsch;
        einzel_laenge:=dateilaenge-analyseoff;
      end;

    if bytesuche_codepuffer_0(#$FC#$BC#$00#$01#$BB'??'#$E8) then
      begin
        ausschrift('Lha Sfx 1.X',packer_dat);
        (* LHA 1.13 *)
        (* exe und com *)
        lzh_sfx(codeoff_seg*16+codeoff_off+1000,'Lha / Haruyasu Yoshizaki');
        com2exe_test:=falsch;
        einzel_laenge:=dateilaenge-analyseoff;
      end;

    if bytesuche_codepuffer_0(#$fc#$bd'??'#$8b) then
      begin
        case word_z(@codepuffer.d[2])^ of
          $120:exezk:='1.2,3';
          $15c:exezk:='1.5';

          $1d8:(* Sprung Åber den Unreg-Text $e9 $ac $00 *)
               exezk:='TurboBat 5.01 CR (RUE 1.3) ¯'; (* ROSE *)
          $1de:(* Sprung Åber den Unreg-Text $e9 $b2 $00 *)
               exezk:='TurboBat 3.10 CR'; (* verÑnderter Version aus RTD_DAT.ZIP *)
          $129:(* Unreg-Code entfernt *)
               exezk:='TurboBat 5.01 CR'; (* verÑnderter Version (V.K.) *)
          $11c:(* Unreg-Code entfernt *)
               exezk:='TurboBat 2.31 CR'; (* verÑnderter Version (V.K.) *)
        else
               exezk:='1.? ¯';
        end;
        ausschrift('BAT2EXEC / Douglas Boling ['+exezk+']',compiler);
      end;

    if bytesuche_codepuffer_0(#$FC#$06#$A1#$2C#$00#$2E#$A3'??'#$85#$C0#$74#$1E) then
      ausschrift('Thunderbyte EXE/SYS - '+textz_exe__Verschluesselung^,packer_exe);

    if bytesuche_codepuffer_0(#$FC#$8c#$c0#$2e#$a3#$24#$00) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<WORKS/MS/2.0> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$fc#$8c#$c8#$01#$06'??'#$ba'??'#$03#$c2) then
      begin
        (* FLEX.ZIP *)
        (* ausschrift('unbekannte Kompression <Flex/iRRTUM> ¯',packer_exe); *)
        exezk:='';
        if codepuffer.d[$23]=$8e then
          exezk:='1.00'
        else
          if codepuffer.d[$23]=$0e then
            begin
              if bytesuche(codepuffer.d[$2f],#$eb#$78#$90) then
                exezk:='2.00 -virinfo'
              else
                exezk:='2.00';
            end;
        ausschrift('ExeLITE / Code Blasters ['+exezk+']',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$FC#$2E#$8C#$0E#$6F#$04#$A1#$02#$00#$8C#$CB) then
      begin
        ausschrift('Zip Sfx / PKWare [1.1]',packer_dat);
        com2exe_test:=falsch;
      end;

    if bytesuche_codepuffer_0(#$FC#$06#$B8#$03#$35#$CD#$21#$BF) then
      ausschrift('NU '+puffer_zu_zk_l(analysepuffer.d[$3D],7)+'.RTL '+textz_exe__Lader^,overlay_);

    if bytesuche_codepuffer_0(#$FC#$2b#$ed#$bc'??'#$b8) then
      ausschrift('Topspeed NE-'+textz_exe__Lader^+' / Clarion',overlay_);

    if bytesuche_codepuffer_0(#$fc#$1e#$b4#$30#$cd#$21#$3c) then
      ausschrift('Topspeed NF/NE-'+textz_exe__Lader^+' / Clarion',overlay_);

    if bytesuche_codepuffer_0(#$fc#$8C#$db#$b8#$08#$00#$8e#$d8#$8e#$c3) then
      (* Version ?.? *)
      ausschrift('GRABBER Bild ; '+textz_exe__unbekannte_Kompression^+'<GRABBER> / G.A.Monroe',musik_bild);

    if bytesuche_codepuffer_0(#$fc#$8c#$db#$b8#$08#$00#$8e#$d8#$a3#$0d#$00) then
      (* Version ?.? *)
      ausschrift('GRABBER Bild ; '+textz_exe__unbekannte_Kompression^+'<GRABBER> / G.A.Monroe [3.96]',musik_bild);

    if bytesuche_codepuffer_0(#$fc#$8c#$c8#$03#$06'??'#$8e#$c0#$8e#$d0) then
      begin
        exezk:='LArc SFX / K.Miki, H.Okumura, K.Masuyama ';
        if exe then
          ausschrift(exezk,packer_dat)
        else
          lzh(codeoff_seg*16+codeoff_off+100,exezk+' [COM]');
      end;

    if bytesuche_codepuffer_0(#$fc#$be'??'#$bf#$fa#$00#$57#$b9#$06#$00) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<!TWIN> <2>¯',packer_exe);

  end;

procedure exe_fd;
  begin
    if bytesuche_codepuffer_0(#$fd#$53#$56#$5b#$0f#$a1#$be'??'#$ad#$64) then
      begin
        (* FILTER..*)
        if bytesuche(codepuffer.d[$30],#$2b#$06#$10) then
          ausschrift('Simple Com Cryptor / ThE CLERiC!',packer_exe)
        else (* auch in #5 enthalten *)
          ausschrift('fDEMO / EliCZ',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$fd#$0e#$be'??'#$8b#$fe#$06#$16#$07) then
      ausschrift(textz_exe__unbekannte_Kompression^+'<HPFS/Andreas Kinzler>',packer_exe);
  end;


end.

