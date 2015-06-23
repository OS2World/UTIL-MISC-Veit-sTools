(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_poly;

interface

uses
  typ_type;

procedure poly_test(var poly_puffer:puffertyp);

implementation

uses
  typ_eiau,
  typ_ausg,
  typ_varx,
  typ_dien,
  typ_die2,
  typ_die3,
  typ_spra,
  typ_poem,
  typ_for3,
  typ_var;


procedure poly_test(var poly_puffer:puffertyp);
  var
    mte_zaehler         :integer_norm;
    pme_zaehler         :integer_norm;
    guard_zaehler       :integer_norm;
    herst_suche_org     :boolean;
    jerusalem           :boolean;
    verteil             :word_norm;
    kompressionsverteilung:word_norm;
    kompressions_puffer :puffertyp;
    poly_tmp_puffer     :puffertyp;

  label
    rueckkehr;

  procedure incx(const um_max:integer_norm;var l:integer_norm;const um:integer_norm);
    begin
      if um>um_max then
        Inc(l,um_max)
      else
        Inc(l,um);
    end;

  function verteilung(const p:puffertyp):word;
    var
      vp                :array[0..255] of word_norm;
      f                 :word_norm;
      m                 :word_norm;
    begin
      FillChar(vp,SizeOf(vp),0);
      for f:=1 to p.g do Inc(vp[p.d[f-1]]);

      m:=0;
      for f:=0 to 255 do
        if m<vp[f] then m:=vp[f];

      if p.g=0 then
        verteilung:=0
      else
        verteilung:=m*100 div p.g;
    end;

 function puffer_pos_suche_poly_puffer_gefunden(const suchzk:string;const max:word_norm):boolean;
   begin
     puffer_pos_suche_poly_puffer_gefunden:=(puffer_pos_suche(poly_puffer,suchzk,max)<>nicht_gefunden);
   end;

 function puffer_pos_suche_poly_puffer(const suchzk:string;const max:word_norm):word_norm;
   begin
     puffer_pos_suche_poly_puffer:=puffer_pos_suche(poly_puffer,suchzk,max);
   end;

 function puffer_anzahl_suche_poly_puffer(const suchzk:string;max:word_norm):word_norm;
   begin
     puffer_anzahl_suche_poly_puffer:=puffer_anzahl_suche(poly_puffer,suchzk,max);
   end;

 function auch_vorhanden(var posi:word_norm;const abstand_max:word_norm;const suchzk:string):boolean;
   var
     w1,w2              :word_norm;
   begin
     w1:=posi;
     w2:=posi+abstand_max;
     if w2+Length(suchzk)>512 then
       w2:=512-Length(suchzk);
     while w1<w2 do
       begin
         if bytesuche(poly_puffer.d[w1],suchzk) then
           begin
             posi:=w1+Length(suchzk);
             auch_vorhanden:=true;
             Exit;
           end;
         Inc(w1);
       end;
     auch_vorhanden:=false;
   end;

  var
    w1,w2,w3,w4         :word_norm;
  begin
    (*******************************************************************)
    (* Alles was schnell zu erkennen ist                               *)
    (*******************************************************************)

    (* PCRYPT 3.50 geht nicht in POEM, weil PrÑfix $66 verwendet wird *)
    w1:=0;
    if auch_vorhanden(w1,16,#$6a#$00)     then
      if auch_vorhanden(w1,16,#$e8#$00#$00) then
        if auch_vorhanden(w1,25,#$66)         then
          if auch_vorhanden(w1,40,#$81)         then
            if auch_vorhanden(w1,28,#$2e#$67#$01) then
              if auch_vorhanden(w1,20,#$2e#$67#$81) then
                if auch_vorhanden(w1,32,#$2e#$67#$8a) then
                  begin
                    if exe and (exe_kopf.ip_wert<>$100) then
                      begin (* MH *)
                        case exe_kopf.ip_wert of
                          $60:exezk:='3.41';
                          $67:exezk:='3.41u';
                          $70:exezk:='3.43';
                          $73:exezk:='3.44u';
                          $81:exezk:='3.45u';
                          $ac:exezk:='3.45';
                          $86:exezk:='3.45u';
                          $bc:exezk:='3.50';
                          $8c:exezk:='3.51';
                        else
                              exezk:='3.?? ¯';
                        end;
                        ausschrift('PCRYPT / MERLiN ['+exezk+' .EXE]',packer_exe)
                      end
                    else
                      begin
                        (* .COM UnterstÅtzung ab 3.43, ab 3.50 werden COM-Datein anders erkannt *)
                        exezk:='3.43,3.44,3.45 ¯';

                        (* Erkennung der Unterversionen aus FI 2.11 *)
                        if puffer_gefunden(poly_puffer,#$f9#$06#$75) then
                          exezk:='3.45r'

                        else if puffer_gefunden(poly_puffer,#$55#$03#$75) then
                          exezk:='3.45u'

                        else if puffer_gefunden(poly_puffer,#$46#$03#$75) then
                          exezk:='3.44u'

                        else if puffer_gefunden(poly_puffer,#$de#$02#$75) then
                          exezk:='3.43u'

                        else if puffer_gefunden(poly_puffer,#$55#$03#$75) then
                          exezk:='3.45m';

                        ausschrift('PCRYPT / MERLiN ['+exezk+' .COM]',packer_exe);
                      end;

                    goto rueckkehr;
                  end;

    (* TYP_POEM geht nicht weil das ende zuerst enschlÅsselt wird *)
    (* geht jetzt doch aber dauert ziemlich lange *)
    if  exe and (exe_kopf.ip_wert=$0000) (* bei GUARDID is CS<>0 *)
    and (puffer_pos_suche_poly_puffer_gefunden(#$2e,$20)) (* Operation CS:[Register],Register *)
    and (puffer_pos_suche_poly_puffer_gefunden(#$f7,$35)) (* NOT Register *)
     then
      begin
        guard_zaehler:=0;

        Inc(guard_zaehler,puffer_anzahl_suche_poly_puffer(#$cc,$25)); (* INT 3 *)
        Inc(guard_zaehler,puffer_anzahl_suche_poly_puffer(#$f5,$25)); (* CMC   *)
        Inc(guard_zaehler,puffer_anzahl_suche_poly_puffer(#$f8,$25)); (* CLC   *)
        Inc(guard_zaehler,puffer_anzahl_suche_poly_puffer(#$fc,$25)); (* CLD   *)
        Inc(guard_zaehler,puffer_anzahl_suche_poly_puffer(#$fd,$25)); (* STD   *)

        if guard_zaehler>8 then
          begin
            ausschrift('PC-Guard / Blagoje Ceklic [3.05,3.10,3.20]',packer_exe);
            if bytesuche(analysepuffer.d[$3c],' PC G')
            or bytesuche(analysepuffer.d[$3c],' PCG V') (* 3.20D GUARD.EXE *)
             then
              begin
                ausschrift(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(analysepuffer.d[$3c],#0,80)),beschreibung);
              end;
            goto rueckkehr;
          end;
      end;

    w1:=puffer_pos_suche(poly_puffer,'Memory al',200);
    if (w1<>nicht_gefunden) and (w1>40) then
      begin
        w2:=w1;
        if (poly_puffer.d[w1-3]=$e9)
        or ((poly_puffer.d[w1-3]=$eb) and (poly_puffer.d[w1-3+2]=$90))
         then
          dec(w2,3)
        else
          if poly_puffer.d[w1-2]=$eb then
            dec(w2,2);

        if  (w1<>w2)
        and bytesuche(poly_puffer.d[w2-2],#$cd#$21)
         then
          begin
            dec(w2,2);

            if bytesuche(poly_puffer.d[w2-2],#$0e#$1f) then
              dec(w2,2);

            if bytesuche(poly_puffer.d[w2-5],#$b4#$09#$ba)
            and (poly_puffer.d[w2-5+3]=byte(w1)) (* +/- $100 *)
             then
              ausschrift('MoonRock / Rawan Crowe',compiler);

          end;
      end;

    (* hat 386+ in EntschlÅsselung *)
    if  (codeoff_off>=$0080)
    and (codeoff_off<=$00b0)
    and (codeoff_seg>0) then
      for w1:=$60 to $c0 do
        if  (poly_puffer.d[w1+0]= poly_puffer.d[w1+1])
        and (poly_puffer.d[w1+2]= poly_puffer.d[w1+4])
        and (poly_puffer.d[w1+0]<>poly_puffer.d[w1+2])
        and (poly_puffer.d[w1+2]<>poly_puffer.d[w1+3])
         then
          begin
            ausschrift('PCRYPT / MERLiN [3.51]',packer_exe);
            goto rueckkehr;
          end;

    if bytesuche(poly_puffer.d[8],#$2e#$80'????'+'???'+#$75#$f5) then
      if puffer_pos_suche_poly_puffer_gefunden(#$eb#$00,20) then
        begin
          ausschrift('WWPack Mutator / Stefan Esser [1.1c]',packer_exe);
          goto rueckkehr;
        end;

    if bytesuche(poly_puffer.d[3],#$b1'?'#$2e'?????'#$81'???'#$75#$f4#$e9) then
      begin
        (* PPIPV200 *)
        ausschrift('Passcode Protect / Wu Wei Team [2.00r]',packer_exe);
        goto rueckkehr;
      end;

    (* NETWARE LITE: NWREMOTE.COM,.. *)
    if puffer_pos_suche_poly_puffer_gefunden(#$b8#$00#$c0#$50#$1e#$cd#$2f#$3c#$ff#$1f,80) then
      begin
        ausschrift('LSL install test',signatur);
        goto rueckkehr;
      end;


    w1:=puffer_pos_suche_poly_puffer(#$cd#$21                           ,28);
    w2:=puffer_pos_suche_poly_puffer(#$fc'?'#$8b'?'#$2c#$00#$8e         ,50);
    w3:=puffer_pos_suche_poly_puffer(#$f2#$ae#$ae                       ,75);
    w4:=puffer_pos_suche_poly_puffer(#$1e#$06#$1f#$07                   ,90);

    if w1=nicht_gefunden then
      w1:=puffer_pos_suche_poly_puffer(#$56#$cb#$be#$50,40);


    if  (w1<>nicht_gefunden)
    and (w2<>nicht_gefunden)
    and (w3<>nicht_gefunden)
    and (w4<>nicht_gefunden)
    and (w1<w2)
    and (w2<w3)
    and (w3<w4)
     then
      begin
        upstop('[0.94,0.94a,0.95,0.96]');
        goto rueckkehr;
      end;


    if puffer_pos_suche_poly_puffer_gefunden(#$b9#$ff#$ff#$f3#$26#$ac#$e3#$53,50) then
      begin
        (* ATEU.EXE 0.9 *)
        (*ausschrift('Mess / Stonehead [1.?] "'+puffer_zu_zk_l(poly_puffer.d[0],4)+'"',packer_exe);*)
        mess(' [1.?]',' "'+puffer_zu_zk_l(poly_puffer.d[0],4)+'"');
        goto rueckkehr;
      end;

    if puffer_pos_suche_poly_puffer_gefunden('ed!$'#$9c#$5b#$81#$cb#$00#$f0#$53#$9d#$9c#$58#$25,$a0) then
      begin
        (* KFT.EXE(BUNCH.EXE) "1.07"*)
        (* JMCE07M/N "1.25" *)
        (*ausschrift('Mess / Stonehead [1.?] "'+puffer_zu_zk_l(poly_puffer.d[0],4)+'"',packer_exe);*)
        mess(' [1.?]',' "'+puffer_zu_zk_l(poly_puffer.d[0],4)+'"');
        goto rueckkehr;
      end;


    if puffer_pos_suche_poly_puffer_gefunden(#$33#$f6#$33#$ff#$48#$4b#$8e#$c0#$8e#$db#$b9#$08#$00,$40) then
      begin
        ausschrift('aPACK code-mover / Joergen Ibsen [0.82 .EXE]',packer_exe);
        goto rueckkehr;
      end;

    if puffer_pos_suche_poly_puffer_gefunden(#$33#$f6#$33#$ff#$4b#$8e#$db#$8d#$87'??'#$8e#$c0#$b9#$08#$00,$60) then
      begin
        ausschrift('aPACK code-mover / Joergen Ibsen [0.90b..0.94b .EXE]',packer_exe);
        apack_code_mover(poly_puffer);
        goto rueckkehr;
      end;

    w1:=puffer_pos_suche_poly_puffer(#$ff#$d5#$73'?'#$ff#$d5#$73'?'#$ff#$d5#$73,$70);
    if w1<>nicht_gefunden then
      if puffer_pos_suche_poly_puffer_gefunden(#$b6#$01#$bd,w1) then
        begin
          ausschrift('aPACK / Joergen Ibsen [0.5X..0.66,0.71b]',packer_exe);
          goto rueckkehr;
        end;


    (* 0.90b .COM/.EXE -m *)
    if puffer_pos_suche_poly_puffer_gefunden(#$ff#$d5#$73'?'#$ff#$d5#$73'?'#$33#$db#$b1#$04#$ff#$d5#$13#$db#$e2,$70) then
      begin
        ausschrift('aPACK / Joergen Ibsen [0.90b..0.91b -m]',packer_exe);
        goto rueckkehr;
      end;

    (* 0.94b EXE -m *)
    if puffer_pos_suche_poly_puffer_gefunden(#$ff#$d5#$73'?'#$ff#$d5#$b1#$01#$73'?'#$ff#$d5#$bb#$10#$00#$73,$70) then
      begin
        ausschrift('aPACK / Joergen Ibsen [0.94b -m]',packer_exe);
        goto rueckkehr;
      end;


    w1:=puffer_pos_suche_poly_puffer(#$ff#$d5#$72'?'#$a4#$eb'?'#$ff#$d5#$73'?'#$ff#$d5#$73,$70);
    if w1<>nicht_gefunden then
      if puffer_pos_suche_poly_puffer_gefunden(#$b6#$01#$bd,w1) then
        begin
          ausschrift('aPACK / Joergen Ibsen [0.69..0.74,0.82]',packer_exe);
          goto rueckkehr;
        end;

    w1:=puffer_pos_suche_poly_puffer(#$ff#$d5#$72'?'#$ac#$f6#$d0#$aa#$eb#$f6#$ff#$d5#$73'?'#$ff#$d5#$73,$70);
    if w1<>nicht_gefunden then
      if puffer_pos_suche_poly_puffer_gefunden(#$b6#$01#$bd,w1) then
        begin
          ausschrift('aPACK / Joergen Ibsen [0.7...  -i]',packer_exe);
          goto rueckkehr;
        end;


    (* 0.98 -m , -t -s -h *) (* movsb              *)
    if puffer_pos_suche_poly_puffer_gefunden(#$bb#$10#$00#$ff#$d5#$73'?'#$ff#$d5#$41#$73'?'#$ff#$d5#$72'?'#$ff#$d5,$80)
    (* 0.98 -i  -t        *) (* lodsb not al stosb *)
    or puffer_pos_suche_poly_puffer_gefunden(#$bb#$10#$00#$ff#$d5#$72'?'#$ff#$d5#$41#$73'?'#$ff#$d5#$72'?'#$ff#$d5,$80)
     then
      (* MOV BX,$0010
         CALL BP
         JAE ...
         CALL BP
         INC CX
         JAE ...
         CALL BP
         JB ...
         CALL BP *)
      begin
        ausschrift('aPACK / Joergen Ibsen [0.98]',packer_exe);
        goto rueckkehr;
      end;

    if puffer_pos_suche_poly_puffer_gefunden(#$1e#$52#$b8#$42#$30#$cd#$21#$86#$c4#$3d'?'#$02#$73,100) then
      begin
        hackstop('1.18');
        goto rueckkehr;
      end;

    if puffer_pos_suche_poly_puffer_gefunden(#$2e#$80#$37'?'#$43#$e2#$f9,512) then
      begin
        ausschrift('Secure / Piotr Warezak [0.19]',packer_exe);
        goto rueckkehr;
      end;


    if puffer_pos_suche_poly_puffer_gefunden(#$c7#$06#$01#$01'jm'#$c6#$06,$40) then
      begin
        (* XPACK 1.67.l *)
        ausschrift(textz_exe__unbekannte_Verschluesselung^+'<XD.COM/JauMing Tseng>',packer_exe);
        goto rueckkehr;
      end;


    (* nur in einfachen .com zu finden aber nicht in Turbo Pascal .exe *)
    if puffer_pos_suche_poly_puffer_gefunden(#$9c#$9c#$58#$80#$f4#$40#$50#$9d#$9c#$5b#$9d,512) then
      begin
        ausschrift('FLAT / Herman Dullink [1.2]',dos_win_extender);
        goto rueckkehr;
      end;

    if bytesuche(poly_puffer.d[9],#$8b#$e2'?'#$f9#$06#$33#$c9) then
      begin
        ausschrift('WWPACK PU -uh Prozedur [3.03/04/04a]',packer_exe);
        goto rueckkehr;
      end;

    (* MOV AX,$xxxx *)
    if  puffer_pos_suche_poly_puffer_gefunden(#$b8,$30)
    (* MOV DX,CS *)
    and puffer_pos_suche_poly_puffer_gefunden(#$8c#$ca,$30)
    (* ADD DX,AX *)
    and puffer_pos_suche_poly_puffer_gefunden(#$03#$d0,$30)
    (* MOV CX,CS *)
    and puffer_pos_suche_poly_puffer_gefunden(#$8c#$c9,$30)
    (* ADD CX,$xxxx *)
    and puffer_pos_suche_poly_puffer_gefunden(#$81#$c1,$30)
    (* PUSH CX *)
    and puffer_pos_suche_poly_puffer_gefunden(#$51,$30)
    (* MOV CL,8 / REPZ MOVSW *)
    and puffer_pos_suche_poly_puffer_gefunden(#$b1#$08#$f3#$a5,$40)
     then
      begin
        (* fÅr WWPACK 3.04a reg *)
        ausschrift('WWPACK mutation engine / B†rth†zi Andr†s [1.00 (WWPack 3.04a reg)]',packer_exe);
        goto rueckkehr;
      end;

    if bytesuche(poly_puffer.d[$d],#$81#$fc'??'#$72#$f3)
    and (poly_puffer.d[$b] in [$50..$57])                         (* PUSH ?? *)
    and (poly_puffer.d[$c] in [$58..$5f])                         (* POP ??  *)
    and puffer_pos_suche_poly_puffer_gefunden(#$fa,$6)            (* CLI *)
     then
       (* AVP: WereWolf.1361.a *)
       ausschrift('WereWolf-'+textz_verschluesselung^+' (FACESFIN.ARJ) ['
        +str0_DGT(einzel_laenge-(codeoff_seg*16+codeoff_off))+']',virus);


    (*>>>*)

    (*******************************************************************)
    (* polymorph oder wie INT 21/09                                    *)
    (*******************************************************************)

    if hersteller_gefunden then
      goto rueckkehr;

    poly_emulator(poem_modus_normal);

    if hersteller_gefunden then
      goto rueckkehr;

    (*******************************************************************)
    (* Alles langsame                                                  *)
    (*******************************************************************)


    mte_zaehler:=0;
    pme_zaehler:=0;
    verteil:=verteilung(poly_puffer);

    if codeoff_off=$3c4 then (* etwas wenig *)
      begin
        ausschrift('CSCRYPT / Christian Schwarz [3.30]',packer_exe);
        goto rueckkehr;
      end;



    {verbessern!!!!!!!!!!!!!!!!!}
    if puffer_pos_suche_poly_puffer_gefunden(#$e8#$00#$00#$5b#$81#$eb,20)
    or puffer_pos_suche_poly_puffer_gefunden(#$e8#$00#$00#$5e#$81#$ee,20)
     then
      begin
        cascade(poly_puffer);
        goto rueckkehr;
      end;


    if bytesuche(poly_puffer.d[6],#$2e#$81) then
      if (poly_puffer.d[0] in [$b8..$bf]) and
         (poly_puffer.d[3] in [$b8..$bf]) and
           (
           (poly_puffer.d[$b]=poly_puffer.d[$c]) and
           ((poly_puffer.d[0]-$b8=poly_puffer.d[$b]-$40) or (poly_puffer.d[3]-$b8=poly_puffer.d[$b]-$40))
           )
           or
           (bytesuche(poly_puffer.d[$b],#$3c'?'#$02#$e2#$f6))
       then
        ausschrift('PS-MPC-'+textz_Verschluesselung^,virus);


    (* TYP_POEM macht es besser: sogar Fehlermeldungen ...
    ( * 50: cute mouse driver 1.4 * )
    w1:=puffer_pos_suche_poly_puffer(#$ba'??'#$b4#$09#$cd#$21,50);
    if w1<>nicht_gefunden then
      begin
        ansi_anzeige(analyseoff+ds_off+x_word(poly_puffer.d[w1+1])
         ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
        goto rueckkehr;
      end; *)


    (* nÅtzlich bei z.B. UNROSE (386 code) *)
    w1:=puffer_pos_suche_poly_puffer(#$b8#$00#$09#$ba'??'#$cd#$21,24);
    if w1<>nicht_gefunden then
      begin
        ansi_anzeige(analyseoff+ds_off+word_z(@poly_puffer.d[w1+4])^
         ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
       goto rueckkehr;
      end;

    w1:=puffer_pos_suche_poly_puffer(#$ba'??'#$b8#$00#$09#$cd#$21,24);
    if w1<>nicht_gefunden then
      begin
        ansi_anzeige(analyseoff+ds_off+word_z(@poly_puffer.d[w1+1])^
         ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
         goto rueckkehr;
      end;

    {???????}
    w1:=puffer_pos_suche_poly_puffer(#$f3#$a6#$e3#$02#$eb'?'#$ba'??'#$b4#$09#$cd#$21,50);
    if w1<>nicht_gefunden then
      begin
        ausschrift(textz_poly__TSR_Mechanismus^+' ¯ :',signatur); (* DSA2CRK *)
        w2:=w1+4+poly_puffer.d[w1+5]+2;
        if w2<$180 then
          begin
            if bytesuche(poly_puffer.d[w2+13],#$33#$d2#$be'??') then
              ansi_anzeige(analyseoff+ds_off+word_z(@poly_puffer.d[w2+13+3])^
               ,'$',poly_puffer.d[w2+13+6],absatz,wahr,wahr,unendlich,'');

          end;
        ansi_anzeige(analyseoff+ds_off+word_z(@poly_puffer.d[w1+7])^
         ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;


    {ÅberflÅssig?}
    w1:=puffer_pos_suche_poly_puffer(#$e8'??'#$2e#$80#$3e'??'#$01#$74#$07#$ba'??'#$b4#$09#$cd#$21,50);
    if w1<>nicht_gefunden then
      begin
        ausschrift(textz_Maustreiber^+' [Aero 1.30]',signatur);
        ansi_anzeige(analyseoff+ds_off+word_z(@poly_puffer.d[w1+12])^
         ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    {ÅberflÅssig?}
    if puffer_pos_suche_poly_puffer_gefunden(#$26#$80#$3e#$00#$01#$4d#$75'?'#$26#$80#$3e#$01#$01#$54,50) then
      begin
        ausschrift(textz_Maustreiber^+' [Mitsumi 8.0]',signatur);
        w2:=puffer_pos_suche_poly_puffer('Mits',180);
        if w2<>nicht_gefunden then
          ausschrift(puffer_zu_zk_e(poly_puffer.d[w2],'$',255),beschreibung);
      end;

    {ÅberflÅssig?}
    w1:=puffer_pos_suche_poly_puffer(#$b8#$00#$06#$b7#$07#$b9#$00#$00#$ba#$4f#$18#$cd#$10#$ba#$00#$00
          +#$e8'??'#$ba'??'#$b4#$09,80);
    if w1<>nicht_gefunden then
      begin
        ausschrift(textz_Maustreiber^+' [Anubis 8.20]',signatur);
        ansi_anzeige(analyseoff+ds_off+word_z(@poly_puffer.d[w1+$13+1])^
          ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    {ÅberflÅssig?}
    if puffer_pos_suche_poly_puffer_gefunden(#$e8'??'#$e8'??'#$2e#$88#$0e'??'#$80#$f9#$00#$74,30) then
      begin
        ausschrift(textz_Maustreiber^+' [Genius 9.06+]',signatur);
        w1:=puffer_pos_suche_poly_puffer(#$ba'??'#$b4#$09#$cd#$21#$2e,$1f0);
        if w1<>nicht_gefunden then
          ansi_anzeige(analyseoff+ds_off+word_z(@poly_puffer.d[w1+1])^
         ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    {ÅberflÅssig?}
    w1:=puffer_pos_suche_poly_puffer(#$8a#$fb#$2b#$d2#$b4#$02#$cd#$10#$ba'??'#$b4#$09#$cd#$21#$ba'??',300);
    if w1<>nicht_gefunden then
      begin
        ausschrift(textz_Maustreiber^+' [AMOUSE]',signatur);
        ansi_anzeige(analyseoff+ds_off+word_z(@poly_puffer.d[w1+16])^
         ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    {ÅberflÅssig?}
    w1:=puffer_pos_suche_poly_puffer(#$be#$80#$00#$ac#$3a#$c4#$7f#$10#$e8,30);
    if w1=nicht_gefunden then
      w1:=puffer_pos_suche_poly_puffer(#$be#$80#$00#$ac#$3a#$c4#$7f#$03#$e9'??'#$ac#$3c,30);
    if w1<>nicht_gefunden then
      begin
        ausschrift(textz_Maustreiber^+' [Genius 9.04-]',signatur);

        datei_lesen(poly_tmp_puffer,codeoff_seg*16+codeoff_off+longint(word_z(@poly_puffer.d[w1+19])^)-$10000,512);
        w1:=puffer_pos_suche(poly_tmp_puffer,#$0e#$1f#$e8'??'#$ba'??'#$e8,$1f0);
        if w1<>nicht_gefunden then
          ansi_anzeige(codeoff_seg*16+word_z(@poly_tmp_puffer.d[w1+6])^
         ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
      end;

    {ÅberflÅssig?}
    w1:=puffer_pos_suche_poly_puffer(#$0e#$0e#$1f#$07#$ba'??'#$e8,40);
    if w1<>nicht_gefunden then
      begin
        ausschrift(textz_Maustreiber^+' JBOND [4.17]',signatur);
        ansi_anzeige(analyseoff+ds_off+word_z(@poly_puffer.d[w1+5])^
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'')
      end;

    w1:=puffer_pos_suche_poly_puffer(#$50#$cb#$0e#$1f#$ba'??'#$e8,40);
    if w1<>nicht_gefunden then
      begin
        ausschrift(textz_Maustreiber^+' JBOND [4.23]',signatur);
        ansi_anzeige(analyseoff+codeoff_seg*16+$100+word_z(@poly_puffer.d[w1+5])^
        ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'')
      end;


    {ÅberflÅssig?}
    if puffer_pos_suche_poly_puffer_gefunden(#$fb#$b8#$33#$35#$cd#$21#$8c#$c0#$0b#$c3#$74,50) then
      ausschrift(textz_Maustreiber^+' [Logitech 6.02-]',signatur);

    if puffer_pos_suche_poly_puffer_gefunden(#$c7#$44'???'#$89#$44'?'#$b8#$2f#$35#$cd#$21#$8c#$06,200) then
      ausschrift(textz_Maustreiber^+' [Logitech 6.12+]',signatur);


    {ÅberflÅssig?}
    w1:=puffer_pos_suche_poly_puffer(#$2e#$2b#$06'??'#$2e#$a3'??'#$e8,50);
    if w1<>nicht_gefunden then
      begin
        ausschrift(textz_Maustreiber^+' [Agiler,Artec]',signatur);
        datei_lesen(poly_tmp_puffer,codeoff_seg*16+codeoff_off+word_z(@poly_puffer.d[w1+10])^+w1-20,40);
        w2:=puffer_pos_suche(poly_tmp_puffer,#$ba'??'#$b4#$09#$cd#$21#$b8'?'#$4c,40);
        if w2<>nicht_gefunden then
          ansi_anzeige(analyseoff+ds_off+word_z(@poly_tmp_puffer.d[w2+1])^
          ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'')
      end;

    {ÅberflÅssig?}
    if puffer_pos_suche_poly_puffer_gefunden(#$b8#$33#$35#$cd#$21#$8c#$c0#$0b#$c3#$74#$1c#$8c#$c6#$33#$c9#$ba#$48#$54,50) then
      ausschrift(textz_Maustreiber^+' [Microsoft]',signatur);

    if puffer_pos_suche_poly_puffer_gefunden(#$0e#$1f#$b8#$66#$06#$cd#$33,50) then
      ausschrift(textz_Maustreiber^+' [JASI,TRUEDOX]',signatur);


    if hersteller_gefunden then goto rueckkehr;

    w1:=puffer_pos_suche_poly_puffer(#$cd#$21#$3d,50);
    if w1=nicht_gefunden then
      w1:=puffer_pos_suche_poly_puffer(#$cd#$21#$80,50);
    if w1=nicht_gefunden then
      w1:=puffer_pos_suche_poly_puffer(#$cd#$21#$2e,50);
    if w1<>nicht_gefunden then
      begin
        jerusalem:=falsch;
        if w1>=3 then
          begin
            if bytesuche(poly_puffer.d[w1-3],#$b8#$40#$a3) or
               bytesuche(poly_puffer.d[w1-3],#$b8#$40#$4b) or
               bytesuche(poly_puffer.d[w1-3],#$b8#$50#$4b) or
               bytesuche(poly_puffer.d[w1-3],#$b8#$f1#$f1) or
               bytesuche(poly_puffer.d[w1-3],#$b4#$e0#$fc) or
               bytesuche(poly_puffer.d[w1-3],#$b4#$ff#$fc)
             then jerusalem:=wahr;
          end;
        if w1>=2 then
          begin
            if bytesuche(poly_puffer.d[w1-2],#$b4#$e0) or
               bytesuche(poly_puffer.d[w1-2],#$b4#$e4) or
               bytesuche(poly_puffer.d[w1-2],#$b4#$f0) or
               bytesuche(poly_puffer.d[w1-2],#$b4#$ff)
             then jerusalem:=wahr;
          end;
        if jerusalem then
          ausschrift('Jerusalem',virus);
      end;

    if puffer_pos_suche_poly_puffer_gefunden(#$b8#$da#$33#$cd#$21#$80#$fc#$a5,36) then
      ausschrift('Coffershop',virus);

    if  puffer_pos_suche_poly_puffer_gefunden(#$06#$1e#$57,30)
    and puffer_pos_suche_poly_puffer_gefunden(#$b9#$08#$00#$8e#$db#$33#$f6#$8e#$c0,70)
     then
      ausschrift('Gonz†les Mart°nez '+textz_modifiziertes^+' Diet / Teddy Matsumoto ¯',packer_exe);


    (*************************************************************)

    {->poem ??}
    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$95#$b8,200));
      (* xchg bp,ax mov ax,????  *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$8b'?'#$d3#$c0,200));
      (* mov cx,?? rol ax,cl *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$97#$74#$74#$75,200));
      (* xchg di,ax, inc di inc di jnz ?? *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$8b'?'#$43#$43#$75,200));
      (* mov bx,??, inc bx inc bx jnz ?? *) (* 15 *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$8b'?'#$45#$45#$75,200));
      (* 54 *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$95#$45#$45#$75,200));
      (* 22 *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$93#$43#$43#$75,200));
      (* 44 *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$d3'?'#$43#$43#$75,200));
      (* 55 *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$8b'?'#$46#$46#$75,200));
      (* 91 *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$bb'??'#$b1#$03#$d3#$cb,200));
      (* 96 *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$b8'??'#$ba'??'#$f7,200));
      (* 13,7 *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$50#$be'??'#$81,200));
      (* 46,47 *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$d3'?'#$b1'?'#$d3,200));
      (* 40,20 *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$8a'?'#$80#$e1'?'#$d3,200));
      (* 74 *)

    incx(2,mte_zaehler,puffer_anzahl_suche_poly_puffer(#$bd'??'#$81#$f5,200));
      (* 90 *)

    if verteil>3 then
      dec(mte_zaehler,2);

    dec(herstellersuche);
    if mte_zaehler<0 then
      mte_zaehler:=0;

    case mte_zaehler of
    0:;
    1:ausschrift(' 1 * MTE '+textz_Vermutung^,signatur);
    2:ausschrift(' 2 * MTE '+textz_Vermutung^,signatur);
    else
      ausschrift(' '+str0(mte_zaehler)+' * MTE '+textz_Vermutung^,virus);
    end;
    inc(herstellersuche);

    incx(2,pme_zaehler,puffer_anzahl_suche_poly_puffer(#$2e#$80#$36,$50));
    incx(2,pme_zaehler,puffer_anzahl_suche_poly_puffer(#$2e#$f7#$16,$80));
    incx(2,pme_zaehler,puffer_anzahl_suche_poly_puffer(#$2e#$f7#$1e,$90));
    incx(2,pme_zaehler,puffer_anzahl_suche_poly_puffer(#$2e#$8b#$06,$c0));
    incx(2,pme_zaehler,puffer_anzahl_suche_poly_puffer(#$2e#$8b#$06,$c0));
    if pme_zaehler>=3 then
      ausschrift(' Phantasie Mutation Engine / Bulgar',virus);


    (**********************************************************************)


    if puffer_pos_suche_poly_puffer(#26#$ff#$77'?'#26#$ff#$77'?'#$8f#$87'??'#$8f#$87'??',100)<>nicht_gefunden then
      ausschrift(' Lockmaster 9.0 = CODELOCK? ¯',packer_exe);





    if hersteller_gefunden then goto rueckkehr;


    if signaturen then ausschrift('maximales Vorkommen='+str0(verteilung(poly_puffer))+' %',signatur);


    if hersteller_gefunden then goto rueckkehr;



    if einzel_laenge>analyseoff+longint(codeoff_seg)*16+codeoff_off+10000 then
      datei_lesen(kompressions_puffer,analyseoff+longint(codeoff_seg)*16+codeoff_off+1000,512)
    else
      if exe then
        begin
          if analyseoff+longint(codeoff_seg)*16+codeoff_off>analyseoff+longint(exe_kopf.kopfgroesse)*16+512 then
            datei_lesen(kompressions_puffer,analyseoff+longint(exe_kopf.kopfgroesse)*16,512)
          else
            FillChar(kompressions_puffer,SizeOf(kompressions_puffer),0);
        end
      else
        datei_lesen(kompressions_puffer,analyseoff+8,512);

    if kompressions_puffer.g=512 then
      kompressionsverteilung:=verteilung(kompressions_puffer)
    else
      kompressionsverteilung:=100;

    if vermutung_pk and (kompressionsverteilung<10) then
      pkware_lib;

    dec(herstellersuche);
    if not hersteller_gefunden and (einzel_laenge>3000) then
      case kompressionsverteilung of
      0..1:ausschrift(textz_poly__wahrscheinlich^ +textz_poly__leer_komprimiert^,packer_exe);
      2..3:ausschrift(textz_poly__moeglicherweise^+textz_poly__leer_komprimiert^,packer_exe);
      end;
    inc(herstellersuche);


  rueckkehr:

  end;

end.

