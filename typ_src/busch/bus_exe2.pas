unit bus_exe2;

interface

(* $80..$ff *)

procedure exe_80;far;
procedure exe_81;far;
procedure exe_83;far;
procedure exe_87;far;
procedure exe_89;far;
procedure exe_8b;far;
procedure exe_8c;far;
procedure exe_8e;far;
procedure exe_90;far;
procedure exe_93;far;
procedure exe_96;far;
procedure exe_9c;far;
procedure exe_a1;far;
procedure exe_b0;far;
procedure exe_b3;far;
procedure exe_b4;far;
procedure exe_b7;far;
procedure exe_b8;far;
procedure exe_b9;far;
procedure exe_ba;far;
procedure exe_bb;far;
procedure exe_bc;far;
procedure exe_bd;far;
procedure exe_be;far;
procedure exe_bf;far;
procedure exe_c3;far;
procedure exe_c6;far;
procedure exe_c7;far;
procedure exe_c8;far;
procedure exe_cc;far;
procedure exe_cd;far;
procedure exe_db;far;
procedure exe_e4;far;
procedure exe_f9;far;
procedure exe_fa;far;
procedure exe_fb;far;
procedure exe_fc;far;
procedure exe_fd;far;
procedure exe_ff;far;

implementation

uses
  typ_type,
  buschbau;

function bytesuche_codepuffer_0(const sig:string):boolean;
  var
    egal:byte;
  begin
    bytesuche_codepuffer_0:=bytesuche(egal,sig);
  end;


procedure exe_80;
  begin
    if bytesuche_codepuffer_0(#$80#$06#$01#$01#$0a#$b4#$01#$50#$50#$c3#$bf) then
      ausschrift('XcomOR / madmax! [0.99a]',packer_exe);
  end;

procedure exe_81;
  begin
    if bytesuche_codepuffer_0(#$81#$fc#$e8#$80#$77#$04#$b4#$4c#$cd#$21#$fc#$bf#$00#$41#$be#$00#$01#$b9'??'#$f3#$a4) then
      ausschrift('Compact / Klaus Peichl [1.05]',packer_exe);

    if bytesuche_codepuffer_0(#$81#$fc#$ee#$fe#$74#$07#$68#$00#$01#$68#$00#$01#$c3#$bc#$f8#$ff#$bf) then
      ausschrift('LaMe CoM eNCRyPToR / CyberRax [1.2]',packer_exe);

    if bytesuche_codepuffer_0(#$81#$fc#$ee#$fe#$74#$07#$68#$00#$01#$68#$00#$01#$c3#$81#$c6#$03#$00#$56#$b9#$64#$03#$eb) then
      ausschrift('LaMe CoM eNCRyPToR / CyberRax [1.2 /H]',packer_exe);

  end;

procedure exe_83;
  begin
    if bytesuche_codepuffer_0(#$83#$c2'?'#$8e#$da#$4a#$e8'?'#$00#$81#$c3'??'#$a1#$10#$00) then
      ausschrift('EXECON ec4 / Keve G†bor [2.5]',packer_exe);

    if bytesuche_codepuffer_0(#$83#$ec'?'#$8b#$ec#$be'??'#$fc#$e8) then
      (* "2.08" *)
      ausschrift('Pro-Pack / Rob Northen Computing [2.08/14/19 -m1 .COM]',packer_exe);
  end;

procedure exe_87;
  begin
    if bytesuche_codepuffer_0(#$87#$C0#$EB#$0B) then
      (* ICO2DIB NC4 *)
      ausschrift('Optlink / SLR [Pass 2]',packer_exe);

    if bytesuche_codepuffer_0(#$87#$C0#$55#$56#$57#$52) then
      ausschrift('Optlink / SLR [Pass 1]',packer_exe);

    if bytesuche_codepuffer_0(#$87#$C0#$FC#$8C#$DA) then
      (* MSBACKUP 6.2 / "unbekannte Kompression [RoboCod]" *)
      ausschrift('Optlink / SLR [RoboCod]',packer_exe);

  end;

procedure exe_89;
  begin
    if bytesuche_codepuffer_0(#$89#$26#$46#$01#$b8#$00#$00#$a3#$26#$01) then
      ausschrift('Visible Pascal / William Hapgood Associates [1985]',compiler);

  end;

procedure exe_8b;
  begin
    if bytesuche_codepuffer_0(#$8b#$fe#$5e#$57#$b9'??'#$30#$0c#$a4#$e2#$fb#$c3) then
      ausschrift('MiCRoXoR / Joergen Ibsen [16byte]',packer_exe); (* 2000.06.04 *)

    if bytesuche_codepuffer_0(#$8b#$fc#$83#$ef#$22#$83#$ec#$22#$be#$1c#$01#$b9#$22#$00#$57#$f3#$a4#$5f) then
      ausschrift('MACHiNE GUNgsTeT/BANG! cryptor',packer_exe); (* mgcrypt.com,manticore *)

    if bytesuche_codepuffer_0(#$8b#$fc#$36#$8b#$2d#$8b#$cd#$81#$ed#$24#$02) then
      ausschrift('CRyPT / CyPoxl [1.1]',packer_exe);

    if bytesuche_codepuffer_0(#$8b#$fc#$83#$ef#$30#$b9#$5f#$00#$be'??'#$fd#$f3#$a4#$57#$b9'??'#$f3#$a4#$fc#$87) then
      ausschrift('Vaccum / Dark Fiber [0.01c]',packer_exe);

    if bytesuche_codepuffer_0(#$8b#$fc#$83#$ef#$10#$b9#$5f#$00#$be'??'#$fd#$f3#$a4#$57#$b9'??'#$f3#$a4#$fc#$87) then
      ausschrift('Vaccum / Dark Fiber [0.01c? - xpkl]',packer_exe);

    if bytesuche_codepuffer_0(#$8b#$ec#$fa#$c7#$46#$f7'??'#$42#$81#$fa'??'#$75#$f9) then
      (* 14‡,14· *)
      ausschrift('iLUCRYPT / Christian Schwarz [4.014]',packer_exe);

    if bytesuche_codepuffer_0(#$8b#$ec#$fa#$c7#$46#$fe'??'#$4c#$4c#$c3) then
      (* COM/EXE *)
      ausschrift('iLUCRYPT / Christian Schwarz [4.018]',packer_exe);

    if bytesuche_codepuffer_0(#$8b#$ec#$1e#$e8#$3f#$02) then
      ausschrift('Aluwain / Tequila [8.09]',packer_exe);

    if bytesuche_codepuffer_0(#$8b#$ec#$81#$ec#$80#$00#$ba'??'#$81#$c2'??'#$81#$fa'??'#$73#$03) then
      ausschrift('DOG / K^3 [2.12]',packer_exe);

    if bytesuche_codepuffer_0(#$8B#$E8#$8C#$C0#$05'??'#$0E#$1F#$A3#$04#$00) then
      (* Virus Police 1 Samsung zu DOS 5 COMPUSOFT ≥ EXEPACK 5.31.009 *)
      ausschrift('MS LINK /EXEPACK 3.69 | 5.31.009',packer_exe);

    if bytesuche_codepuffer_0(#$8B#$E8#$8C#$C0#$83#$C0'?'#$0E#$1F) then
      (* DECOMP.EXE *)
      ausschrift('MS LINK /EXEPACK 5.31.009 <2> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$8b#$e8#$8c#$c6#$0e#$1f#$8c#$c0#$05#$10#$00#$01) then
      ausschrift('Causeway DOS Extender / John Wildsmith [2.60,2.64]',dos_win_extender);

    if bytesuche_codepuffer_0(#$8b#$ec#$eb#$01#$e8#$b8#$96#$03) then
      ausschrift('XPACK / JauMing Tseng [1.49 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$8b#$ec#$fa#$33#$c0#$8e#$d0#$bc#$10#$00#$2e#$8f) then
      (*???ausschrift('XPACK / JauMing Tseng [1.52..1.60 .COM]',packer_exe);*)
      (* 1.64.exe stimmt *)
      ausschrift('XPACK / JauMing Tseng [1.52..1.64 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$8b#$ec#$eb#$01#$e8#$b8#$18#$04#$ff#$e0#$fa#$33#$c0) then
      (* -4 und -5 *)
      ausschrift('XPACK / JauMing Tseng [1.45 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$8b#$ec#$eb#$01#$e8#$c6#$06#$0f#$01) then
      (* ausschrift(textz_exe__unbekannte_Kompression^+'<XPACK.COM/JauMing Tseng>',packer_exe); *)
      ausschrift('PaSsCom / JauMing Tseng [1.19c]',packer_exe);

    if bytesuche_codepuffer_0(#$8b#$2e#$02#$00#$ba'??'#$8e#$da#$8c#$06'??'#$2b#$ea) then
      ausschrift('DPMI Server / Charles W. Sandmann',dos_win_extender);
      (* RKIVE 1.2 *)

    if bytesuche_codepuffer_0(#$8b#$dc#$eb) then
      ausschrift('DoP''s CRYPTEXE [1.04]',packer_exe);

  end;

procedure exe_8c;
  begin
    if bytesuche_codepuffer_0(#$8c#$d8#$05#$10#$00#$01#$06'??'#$eb#$00#$c7#$06#$00#$01'??'#$c6#$06#$02) then
      (* fi: Exe2Com (LYexin) [1997] *)
      ausschrift('Exe2Com / Yexin Liu',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$ce#$e8#$2b#$00#$8e#$ee#$bc#$9a#$01) then
      ausschrift('Sandbag / Cansing Leung [1998/11]',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c0#$01#$06#$3e#$01#$ea#$00#$00) then
      ausschrift('Exe2Com / MegaSoft [1.1]',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c8#$2e#$03#$06#$04#$01#$50#$2e#$ff#$36#$02#$01#$cb) then
      ausschrift('AVAST-Protect / Pavel Baudis',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c8#$2e#$a3'??'#$fa#$66#$33#$f6#$8e#$ee#$b8'??'#$8e#$d8#$b9'??'#$66#$65#$8b#$04) then
      ausschrift('Pro32 / Dieter Pawelczak',dos_win_extender); (* 1.7-pas32v252 *)

    if bytesuche_codepuffer_0(#$8c#$c8#$8e#$d8#$8e#$c0#$b4#$0f#$cd#$10#$a2'??'#$3c#$07#$74#$e3#$b4#$12#$bb) then
      ausschrift('Txt2Exe / LiSan Wang [2.00]',compiler);

    if bytesuche_codepuffer_0(#$8c#$c8#$8e#$d8#$8c#$c0#$8e#$d0#$bc#$00#$01#$b4#$0f#$cd#$10#$a2'??'#$3c#$07#$74) then
      ausschrift('Txt2Exe / LiSan Wang [4.01]',compiler);

    if bytesuche_codepuffer_0(#$8c#$c0#$66#$60#$50#$1e#$06#$0e#$0e#$07#$1f#$e8'?'#$00#$07#$1f#$bb'??'#$58#$48) then
      ausschrift('EXE2EXE / Andrew V. Stupachenko [0.0004c]',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c0#$05'??'#$50#$68'??'#$1e#$06#$8c#$c8#$8e#$d8#$8e#$c0#$e8#$03#$00#$07#$1f#$cb) then
      ausschrift('EXE2EXE / Andrew V. Stupachenko [0.0004c /e]',packer_exe);


    if bytesuche_codepuffer_0(#$8c#$c9#$81#$c1'??'#$51#$b9#$01#$00#$51#$06#$06#$8c#$ca#$b8'??'#$03#$d0) then
      ausschrift('WWPACK mutation <RTD_DAT.EXE/MR WiCKED>',packer_exe);

    (* ESP.EXE, UNESP.EXE *)
    if bytesuche_codepuffer_0(#$8c#$c8#$05'??'#$50#$b8'??'#$50#$b0#$ff#$06#$8c#$d2#$06#$83#$ea'?'#$50) then
      ausschrift('? WWPACK mutation engine / B†rth†zi Andr†s [1.x? (WWPack 3.05·5)]',packer_exe);


    if bytesuche_codepuffer_0(#$8c#$0e'??'#$8c#$0e'??'#$b8'??'#$e8'??'#$74'?'#$c6#$06#$10#$01'3'#$c7#$06) then
      ausschrift('Tseng ET3000/4000 VESA TSR',signatur);

    if bytesuche_codepuffer_0(#$8c#$c8#$05'??'#$8e#$c0#$59#$8e#$d0#$51#$be'??'#$bf#$00#$01#$50#$57#$fc) then
      (* auch -i *)
      ausschrift('aPACK / Joergen Ibsen [0.96b .COM -m]',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c8#$80#$c4#$10#$8e#$c0#$fc#$b9'??'#$be#$00#$01#$8b) then
      begin
        ausschrift('aPACK code-mover / Joergen Ibsen [0.82b..0.94b .COM]',packer_exe);
        (* ... *)
      end;

    if bytesuche_codepuffer_0(#$8c#$dd#$0e#$07#$0e#$1f#$bf#$00#$10) then
      ausschrift('CEPexe / Marcello Marin Isola',packer_exe);

    if bytesuche_codepuffer_0(#$8C#$DB#$2E#$8E#$1E'??'#$89#$1E) then
      ausschrift('TopSpeed Modula / Jensen & Partners I. [1.17]',compiler);

    if bytesuche_codepuffer_0(#$8c#$d8#$8e#$c0#$b8'??'#$8e#$d8#$8c#$06'??'#$8c#$16) then
      ausschrift('MM-GRASP Interpreter / John Bridges',compiler);

    if bytesuche_codepuffer_0(#$8c#$0e'??'#$8c#$0e'??'#$a1'??'#$a3) then
      ausschrift('CSTAR*FORTH (?) / Gary Chanson',compiler);

    if bytesuche_codepuffer_0(#$8C#$D0#$3D'??'#$75'?'#$8c#$c0) then
      ausschrift('Micro Focus COBOL',compiler);

    if bytesuche_codepuffer_0(#$8C#$DB#$0E#$0E#$1F#$07#$B9) then
      (* Test mit SW-Version Protect! 4.0 .EXE *)
      ausschrift('Protect! / Jeremy Lilley [4.0]',packer_exe);

    if bytesuche_codepuffer_0(#$8C#$C8#$8E#$D8#$8E#$C0#$BB#$00) then
      ausschrift('WIN.COM Microsoft WFW 3.11',dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$c8#$fa#$8e#$d0#$bc'??'#$8c#$c0#$bb) then
      ausschrift('Crypt / Light Show/ECLIPSE [1.20]',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c8#$fa#$8e#$d0#$bc'??'#$fb#$8c#$c0#$bb) then
      ausschrift('Crypt / Light Show/ECLIPSE [1.21]',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c8#$83#$e8#$10#$8e#$d8#$33#$f6#$8c#$cb) then
      ausschrift('CRYPT [1.15] ¯',packer_exe);

    if bytesuche_codepuffer_0(#$8C#$CE#$8E#$DE#$8E#$C6#$33#$F6#$8B#$36#$03) then
      ausschrift('IBMBIO.COM  Digital Research DOS 6',dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$c8#$05#$20#$00#$a3#$6f#$01) then
      ausschrift('COMMAND.COM Digital Research DOSPLUS [1.2]',dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$c8#$05'??'#$a3'??'#$03#$06'??'#$8e#$c0#$8b#$d0#$fc#$b4#$2e#$b0#$01#$cd#$21#$b4#$54) then
      (* FORMAT.COM , DISKCOPY.COM *)
      ausschrift('Test auf DOS Plus [1.2]',signatur);


    if bytesuche_codepuffer_0(#$8c#$c8#$8e#$d0#$bc#$ec#$ff#$e9) then
      ausschrift('PTSDOS.SYS  PTS-DOS',dos_win_extender);

    if bytesuche_codepuffer_0(#$8C#$DA#$83#$C2#$11#$8E#$DA) then
      (* Lasthalf of Darkness *)
      ausschrift('Microsoft QBasic [2 1987]',compiler);

    if bytesuche_codepuffer_0(#$8C#$C0#$05#$10#$00#$0E#$1F#$8b#$d8#$03#$06) then
      ausschrift('EXEPACK + EXEPACKFIX / Alan Modra',packer_exe);

    if bytesuche_codepuffer_0(#$8C#$C8#$8E#$D8#$8D#$16'??'#$B4#$09) then
      ausschrift('JEMM / ORIGIN / Jason M Yenawine [Strike C.]',dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$d8#$8e#$c0#$b8'??'#$8e#$d8#$c7#$06'????'#$b8) then
      ausschrift('Phar Lap DOS-Extender',dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$d8#$8e#$c0#$b8'??'#$8e#$d8#$bb'??'#$8c#$c0#$2b#$d8) then
      ausschrift('Phar Lap DOS-Extender',dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$c8#$48#$8e#$c0#$26#$81) then
      ausschrift('Compressor 1.0 ¯',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$ca#$81#$c2'??'#$3b#$16'??'#$76) then
      ausschrift('"EXE2COM (regular)" ¯',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$d3#$8c#$c0#$2b#$d8#$83#$c3) then
      ausschrift('Virtual File System / Lone Ranger/ACME',packer_dat);

    if bytesuche_codepuffer_0(#$8c#$d0#$2e#$a3'??'#$2e#$89#$26'??'#$8c#$c8) then
      ausschrift('GaHeader / ??? [1.00] ¯',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c8#$05#$00#$10#$8e#$c0#$bf#$00#$01) then
      ausschrift('XPACK / JauMing Tseng [1.23..1.65 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c2#$b8'??'#$8e#$d8#$8e#$c0#$8e#$d0) then
      ausschrift('RSX / Rainer Schnitker [5]',dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$c8#$2d'??'#$8e#$d8#$8e#$c0#$fa) then
      ausschrift('DOS Extender / Steffen Dingel [1.02]',dos_win_extender);

    if bytesuche_codepuffer_0(#$8c#$c8#$8e#$d8#$8e#$c0#$8e#$d0#$bc'??'#$e8) then
      (* AAOCNEUA.ZIP *)
      ausschrift('Textview / Quantum Technologies',signatur);

    if bytesuche_codepuffer_0(#$8c#$d8#$2e#$01#$06#$14#$00#$2e#$83#$06#$14#$00#$10#$2e#$ff#$2e#$12#$00) then
      (* Sprung zu LZEXE *)
      ausschrift('LHARK SFX / Kerwin F. Medina [0.3e]',packer_dat);

    if bytesuche_codepuffer_0(#$8c#$d8#$05#$10#$00#$2e#$01#$06#$11#$00) then
      (* Sprung zu LZEXE *)
      ausschrift('LHARK SFX / Kerwin F. Medina [0.3o,0.4]',packer_dat); (* 0.3o *)


    if bytesuche_codepuffer_0(#$8c#$ca#$8b#$2e#$01#$00#$8e#$da#$8c#$06) then
      ausschrift('ExeHigh / NoddegamrA [1.01]',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c0#$fa#$8e#$d0#$bc#$fe#$00#$fb#$06) then
      (* LZEXE .. *)
      ausschrift('PackWin / Yellow Rose Workgroup [1.0,2.0]',packer_exe);

    if bytesuche_codepuffer_0(#$8c#$c8#$a3'??'#$05#$00#$10#$8e#$c0#$bf#$00#$01) then
      ausschrift('LZCOM / JauMing Tseng [1.4]',packer_exe);

  end;

procedure exe_8e;
  begin
    if bytesuche_codepuffer_0(#$8e#$06#$2c#$00#$2b#$ff#$26#$80#$3d#$00#$74'?'#$57#$be'??'#$b9#$08) then
      ausschrift('DE_EN_COM / Veit Kannegieser [1998.03.11]',packer_exe);

    if bytesuche_codepuffer_0(#$8e#$06#$2c#$00#$2b#$ff#$fc#$26#$80#$3d#$00#$74'?'#$57#$be'??'#$b9#$05) then
      ausschrift('DE_EN_COM / Veit Kannegieser [1999.12.01]',packer_exe);

  end;

procedure exe_90;
  begin
    if bytesuche_codepuffer_0(#$90#$90#$90#$e9'??'#$eb#$10#$90'EXEK') then
      ausschrift('EXEKey / Ma Ke [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$90#$90#$be'?'#$00#$8b#$fe#$e8) then
      (* 13.06.1998 RARBREAK.EXE *)
      ausschrift('Burglar/H ≥ Burglar.1150',virus);

    if bytesuche_codepuffer_0(#$90#$b8'??'#$ba'??'#$05#$00#$00#$50#$52#$8c#$d1) then
      ausschrift('Fool! / Christoph Gabler [1.1 PKLite EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$90#$b8'??'#$ba'??'#$3b#$c4#$73'?'#$8b#$c4) then
      ausschrift('Fool! / Christoph Gabler [1.1 PKLite COM]',packer_exe);


    if bytesuche_codepuffer_0(#$90#$90#$90#$68'??'#$5b#$81#$eb'??'#$2e) then
      ausschrift('COM2TXT / Dark Stalker [1.2a]',packer_exe);

    if bytesuche_codepuffer_0(#$90#$90#$90#$bc'??'#$bb#$80#$00#$8a#$07) then
      ausschrift('Reletter / Hans Baer [4.00]',packer_exe);

    if bytesuche_codepuffer_0(#$90#$90#$90#$90#$90#$90#$90#$90#$2e#$a2'??'#$2e#$88#$1e'??'#$eb) then
      ausschrift('Amber / Amber Software',compiler);

    if bytesuche_codepuffer_0(#$90#$90#$90#$fa#$29#$c0#$8e#$c0#$26#$c6#$06) then
      ausschrift('MCLOCK / ??? ¯ [1.2,1.3]',packer_exe);

    if bytesuche_codepuffer_0(#$90#$06#$1e#$0e#$07#$0e#$1f#$fc#$b8'??'#$8b#$f0#$8b#$fe) then
      ausschrift('AVPL Testvirus .EXE ',virus);


  end;

procedure exe_93;
  begin
    if bytesuche_codepuffer_0(#$93#$93#$e8'??'#$54#$4c) then
      ausschrift('Ciphator Prof. / Marquis de SoirÇe [4.6]',packer_exe);
  end;

procedure exe_96;
  begin
  end;

procedure exe_9c;
  begin
    if bytesuche_codepuffer_0(#$9c#$58#$0e#$17#$f6#$c4#$01#$74#$03#$eb#$4c#$fb#$b4#$01#$be#$24#$01) then
      ausschrift('<?ALXLOGO.COM/comcr03b.rar>',packer_exe); (* alex2000 *)

    if bytesuche_codepuffer_0(#$9c#$50#$8c#$db#$53#$53#$0e#$1f#$83#$c3#$10#$33#$ff#$8e#$c3#$8b#$d3#$01) then
      ausschrift('Compress / Wang Zhong Hua [1.0 - 84]',packer_exe); (* 155b.cod *)

    if bytesuche_codepuffer_0(#$9c#$50#$8c#$da#$52#$52#$bb#$f0#$ff#$8c#$c8#$48#$8e#$d8#$05'??'#$8e#$c0) then
      ausschrift('Compress / Wang Zhong Hua [1.0 - 174;343]',packer_exe); (* 138c.cod,149d.cod *)

    if bytesuche_codepuffer_0(#$9c#$e8#$00#$00#$58#$1e#$57#$04#$0c#$bf#$ff#$d0#$5f#$eb#$fb) then
      ausschrift('IRoNtHoRN / ReDragon [1.0, HackStop 1.19]',packer_exe);

    if bytesuche_codepuffer_0(#$9c#$50#$53#$51#$52#$55#$56#$57#$81#$fc'??'#$72#$1d#$fd#$bf'??'#$be'??'#$b9'??'
      +#$f3#$a5#$fc#$af#$8b#$f7) then
      ausschrift('PKLite / PKWare + PKLXTRA / Craig Hessel [15 Dec 91]',packer_exe); (* erwartet PK 1.12? *)

    if bytesuche_codepuffer_0(#$9c#$fa#$fc#$1e#$06#$bb#$00#$10#$b4#$4a#$cd#$21#$b4#$48#$bb'??'#$cd#$21#$8e#$c0) then
      ausschrift('AliS S0fT cryptor',packer_exe); (*alis.com, manticore *)

    if bytesuche_codepuffer_0(#$9c#$2e#$8f#$06#$5c#$00#$1e#$2e#$8f#$06#$62#$00#$0e#$0e#$1f) then
      (* DONGEL-Schutz PO.EXE *)
      ausschrift('KeyPro / ? ¯',packer_exe);

    if bytesuche_codepuffer_0(#$9c#$50#$53#$51#$52#$56#$57#$55#$1e#$06#$fc#$b8#$00#$30#$cd#$21#$84#$c0) then
      ausschrift('ProtEXE / Tom Torfs [3.0X]',packer_exe);

    if bytesuche_codepuffer_0(#$9C'UV'#$8C#$CD#$83#$C5#$10) then
      (* WPUB Grafiktreiber / OBJXREF TASM *)
      ausschrift('Spacemaker / Realia Inc [1.07]',packer_exe);

    if bytesuche_codepuffer_0(#$9C#$ba'??'#$2d'??'#$81#$e1'??'#$81#$f3) then
      ausschrift('UN˝PACK / CCS-Produktions [2.0] (ƒPKLITE)',packer_exe);

    if bytesuche_codepuffer_0(#$9c#$9c#$58#$25#$ff#$0f#$50#$9d) then
      ausschrift('ProtEXE / Tom Torfs [2.11]',packer_exe);

    if bytesuche_codepuffer_0(#$9c#$0f#$a0#$66#$60#$fd#$6a#$00#$0f#$a1#$be) then
      ausschrift('AdFlt+ (fILTER #2) / EliCZ',packer_exe);

    if bytesuche_codepuffer_0(#$9c#$50#$56#$57#$e8#$00#$00#$5f#$83#$ef#$07#$be#$03#$01#$80#$34'?'#$46#$3b#$f7) then
      ausschrift('Simple COM cryptor by EliCZ ''98',packer_exe);

  end;

procedure exe_a1;
  begin
    if bytesuche_codepuffer_0(#$a1#$02#$00#$2d#$e1#$0b#$8e#$d0) then
      (* vielleicht auch 2.2 *)
      ausschrift('AINEXE / Transas Marine [2.1/2]',packer_exe);
  end;



procedure exe_b0;
  begin
    if bytesuche_codepuffer_0(#$b0#$b0#$ff#$60#$05#$07#$01#$56#$83#$c6#$18#$b9) then
      (* dccrypt.zip *)
      ausschrift('COM Crypt / DREAMMASTER [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$B0#$00#$9A'????'#$89#$E5#$81#$EC) then
      (* IEdit *)
      ausschrift('Quick/Microsoft Pascal',compiler);

    if bytesuche_codepuffer_0(#$B0'?'#$BB'??'#$53#$51#$B9) then
      (* Trainer zu Wolfenstein *)
      ausschrift('TPC SCRAMBLE',packer_exe);

  end;

procedure exe_b3;
  begin
    if bytesuche_codepuffer_0(#$b3'?'#$b9'??'#$33#$d2#$be'??'#$8b#$fe#$ac#$32#$c3#$aa) then
      ausschrift('EXE2COM / Basil V. Vorontsov [E 9.50a]',packer_exe);

    if bytesuche_codepuffer_0(#$b3'?'#$b9'??'#$eb#$08'????????'#$be#$d0#$01#$bf#$d0#$01#$ac#$32) then
      ausschrift('EXE2COM / Basil V. Vorontsov [Z /M123 9.50a]',packer_exe);

    if bytesuche_codepuffer_0(#$b3'?'#$b9'??'#$be#$d0#$01#$bf#$d0#$01#$eb#$08'????????'#$ac#$32) then
      ausschrift('EXE2COM / Basil V. Vorontsov [R 9.50a]',packer_exe);
  end;

procedure exe_b4;
  begin
    if bytesuche_codepuffer_0(#$b4#$4a#$bb'??'#$cd#$21#$73#$04#$b4#$4c#$cd#$21#$fc#$bf'??'#$be#$00#$01#$b9'??'
       +#$f3#$a4#$e9'??'#$be'??'#$bf#$00#$01) then
      ausschrift('Compact / Klaus Peichl [1.04]',packer_exe); (* ZIPCOPY *)

    if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$86#$c4#$3d#$ff#$02#$73#$02#$cd#$20#$eb#$01#$ea#$8b#$dc#$eb#$01) then
      ausschrift('DoP''s CRYPTEXE [1.00·5]',packer_exe);

    if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$86#$e0#$3d#$ff#$02#$73#$02#$cd#$20#$9c#$8c#$c0#$06#$5b) then
      (* UCFDSCPR *)
      ausschrift('ABKprot / fds0ft [ABK-COM 1.00 recoded / Dark Stalker]',packer_exe);

    if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$3c#$03#$73#$02#$fa#$f4#$a1#$2c#$00#$1e#$8e#$c0#$33#$ff#$fc#$33#$c9) then
      ausschrift('Sesame / Goreinov S.A. [1.1 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$3c#$02#$77#$02#$cd#$20#$b0#$4d#$6a#$64#$5a#$ee) then
      (* ENCOM301 *)
      ausschrift('ENcryptCOM / Stewart Moss [3.01]',packer_exe);

    if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$3c#$03#$73'?'#$ba#$1f#$00#$0e#$1f#$b4#$09) then
      (* FZC105 *)
      ausschrift('EEXE / Fernando Papa Budzyn [1.12,1.13]',packer_exe);

    if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$3c#$02#$77#$06#$90#$90#$b4#$4c#$cd#$21#$cc#$e8) then
      ausschrift('aTEU / MaX / MovSD [1.1]',packer_exe);

    if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$3c#$03#$72#$f2#$2e#$8c#$1e#$00#$00#$8c#$db#$83#$c3#$10#$2e#$01) then
      ausschrift('BITLOK / Yellow Rose Software Workgroup [3.1]',packer_exe);

    if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$3c#$01#$77) then
      ausschrift('ProtUPC / TPiNC [MS QBasic,C]',packer_exe);

    if bytesuche_codepuffer_0(#$B4#$30#$CD#$21#$3C'?'#$73#$01#$C3#$8c#$df#$8b#$36) then
      ausschrift('MS-C',compiler);

    if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$3c#$03#$7d#$02#$eb#$6d) then
      ausschrift('Codelock 3 / "Dr. Detergent" ¯',packer_exe);

    if bytesuche_codepuffer_0(#$b4#$30#$cd#$21#$b4#$00#$03#$f8#$97#$d6) then
      ausschrift('NoDebug / JVP [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$b4#$0f#$33#$db#$cd#$10#$80#$fc#$50#$74#$28#$b0#$01#$eb#$20) then
      ausschrift('TXTmaker / Jack A. Orman [1.22]',compiler);

    if bytesuche_codepuffer_0(#$b4#$30#$1e#$06#$cd#$21#$2e#$a3#$08#$00#$bf) then
      ausschrift('EXE-Manager / Solar Designer [3.2]',packer_exe);

    if bytesuche_codepuffer_0(#$b4#$62#$cd#$21#$8b#$c3#$8c#$cb) then
      ausschrift('WDOSX / Michael Tippach [0.92]',dos_win_extender);

    if bytesuche_codepuffer_0(#$b4#$c0#$cd#$21#$3d#$34#$12) then
      ausschrift('Jerusalem.Solano',virus);

    if bytesuche_codepuffer_0(#$B4#$01#$b7#$00#$b9#$00#$20) then
      ausschrift('ASC2COM / MorganSoft [1.10..1.66]',compiler);

    if bytesuche_codepuffer_0(#$B4#$0f#$cd#$10#$bb#$00#$b8#$3c#$07#$75) then
      ausschrift('Interactive Info File Reader / The Surnatural',compiler);

    if bytesuche_codepuffer_0(#$B4#$30#$E8'??'#$0A#$C0) then
      (* LSTEST.COM Longshine Maus *)
      ausschrift('Turbo/Borland Pascal 3.x 1985',compiler);

  end;

procedure exe_b7;
  begin
    if bytesuche_codepuffer_0(#$b7'?'#$e8#$05#$00#$83#$ed#$02#$eb#$03#$5d#$55#$c3) then
      (* CRYPT BTS *)
      ausschrift('ComCryptor / Jozsef Hidasi [9.12]',packer_exe);
  end;


procedure exe_b8;
  begin
    if bytesuche_codepuffer_0(#$b8'??'#$a3#$00#$01#$b8'??'#$a3#$02#$01#$b8'??'#$b9'??'#$33#$ff#$30) then
      (* vielleicht ein passendes Kennwort raten? *)
      ausschrift('CryptLite / Alex Shuman [4.50] ',packer_exe);

    if bytesuche_codepuffer_0(#$b8'??'#$8e#$d8#$8c#$c0#$a3'??'#$26#$a0#$80#$00#$a2'??'#$26#$a1#$2c#$00#$a3'??'#$9a'????'#$9a) then
      ausschrift('Gardens Point Modula',compiler); (* Version 1995.04.13 *)

    if bytesuche_codepuffer_0(#$b8#$00#$70#$9c#$50#$9d#$9c#$58#$9d#$80#$e4#$70#$ba#$18#$00#$74#$e0
         +#$b4#$30#$cd#$21#$3c#$03#$ba#$22) then
      ausschrift('4GSTUB / Kirill Joss [3:CCDL176]',dos_win_extender);

    if bytesuche_codepuffer_0(#$b8#$00#$70#$9c#$50#$9d#$9c#$5b#$9d#$ba#$13#$01#$22#$fc#$74#$df#$b8#$2e#$30) then
      ausschrift('4GS / Kirill Joss [5:CCDL180]',dos_win_extender);

    if bytesuche_codepuffer_0(#$b8#$51#$80#$cd#$10#$b4#$0f#$cd#$10#$a2'??'#$3c#$07#$74'?'#$c7#$06'??'#$00#$a0#$b8#$0e#$00) then
      (* EXESHAPE120.ZIP *)
      ausschrift('TXT2EXE / Min Jei Chen [2.10]',compiler); (* "DELUXE"*)

    if bytesuche_codepuffer_0(#$b8#$01#$09#$00#$00#$cd#$31#$66#$8c#$05'?'#$00#$00#$00#$66#$8c#$0d) then
      ausschrift('WDOSX / Michael Tippach [COFF 0.95]',dos_win_extender);

    if bytesuche_codepuffer_0(#$b8'??'#$ba'??'#$3b#$e0#$73#$0c#$b4
         +#$09#$ba#$bf#$01#$cd#$21#$b8#$01#$4c#$cd#$21#$8b#$dc) then
      ausschrift('CC / Krasilnikov [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$b8#$11#$09#$be#$47#$46#$bf#$4d#$4a#$ba'??'#$cc#$be#$03#$01#$b3'?'#$b9) then
      ausschrift('CRuNCH / Luck [1.2]',packer_exe);

    if bytesuche_codepuffer_0(#$b8#$00#$16#$cd#$2f#$3c#$04#$0f#$8c) then
      ausschrift('ExDLdr / EliCZ',dos_win_extender);

    if bytesuche_codepuffer_0(#$b8'??'#$8e#$d8#$67#$a3'??'#$00#$00#$66#$bc) then
      ausschrift('Sytem 64 / Simm/Analogue [1.210]',dos_win_extender);

    if bytesuche_codepuffer_0(#$b8'??'#$50#$e4#$21#$50#$b8'??'#$8c#$db#$03#$c3#$50#$b8'??'#$50#$cb) then
      ausschrift('ALUWAIN / The Finishing Touch [8.03]',packer_exe);

    if bytesuche_codepuffer_0(#$b8'??'#$ba'??'#$05#$00#$00#$3b#$2d#$73#$67#$72#$1b#$b4#$09#$ba'??'#$cd#$21#$cd#$90) then
      ausschrift('Megalite / ThE KiLLeR of MEGATEAM '#39'n CTF [1.20a+]',packer_exe);

    if bytesuche_codepuffer_0(#$b8'??'#$bb'??'#$ba'??'#$31#$07#$43#$40#$39#$d3) then
      ausschrift('XORCOPY / Deimos [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$b8#$00#$38#$ba'??'#$cd#$21#$be'??'#$b9) then
      ausschrift('DE_EN_COM / Veit Kannegieser [31.12.1997]',packer_exe);

    if bytesuche_codepuffer_0(#$b8'??'#$15'??'#$81#$3e#$e8#$0f#$00'?'#$e8#$f9#$ff) then
      ausschrift('XPACK / JauMing Tseng [1.67 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$b8'??'#$ba'??'#$05'??'#$3b#$06'??'#$73#$1f#$8b#$d8#$2d) then
      ausschrift('Shrinker / Blinkinc [?.?]',packer_exe);

    if bytesuche_codepuffer_0(#$b8#$03#$35#$06#$cd#$21#$2e#$8c) then
      ausschrift('Secure / Piotr Warezak [0.16]',packer_exe);

    if bytesuche_codepuffer_0(#$b8'??'#$bb'??'#$b9'??'#$31#$07#$43#$40#$e2#$fa#$c7) then
      ausschrift('XOR33 / JauMing Tseng',packer_exe);

    if bytesuche_codepuffer_0(#$b8'??'#$bb'??'#$ba'??'#$31#$07#$43#$40#$3b#$da#$75#$f8#$c7) then
      ausschrift('XOR37 / JauMing Tseng',packer_exe);

    if bytesuche_codepuffer_0(#$b8'??'#$bb'??'#$ba'??'#$31#$07#$43#$40#$3b#$da#$75#$f8#$c6) then
      ausschrift('XOR41 / JauMing Tseng',packer_exe);

    if bytesuche_codepuffer_0(#$b8#$8c#$d3#$15#$33#$75#$8b#$ec#$eb#$01) then
      ausschrift('XPACK / JauMing Tseng [1.65 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$B8#$00#$00#$8e#$d8#$9c#$5b#$b8#$ff#$0f#$23#$c3) then
      ausschrift('DOS32 / Adam Seychell 1.2',dos_win_extender);

    if bytesuche_codepuffer_0(#$B8'??'#$8E#$D8#$8C#$06'??'#$FA#$8E#$D0) then
      (* KHK Dateien Compusoft *)
      ausschrift('Microsoft QBasic',compiler);

    if bytesuche_codepuffer_0(#$B8'??'#$8E#$D8#$B8#$00#$30#$CD#$21#$A3#$01#$00#$3C#$03) then
      ausschrift('Phar Lap * Dos Extender [3]',dos_win_extender);

    if bytesuche_codepuffer_0(#$B8'??'#$8E#$D0#$8E#$D8#$8C#$06'??'#$8E#$C0) then
      (* ET4000 Fload,.. *)
      ausschrift('XXX-C ??? [Hilfe!]',compiler);

    if bytesuche_codepuffer_0(#$b8'??'#$50#$e9#$01#$00'?'#$c6#$06) then
      ausschrift('Protect! / Jeremy Lilley [1.X .COM]',packer_exe);


  end;

procedure exe_b9;
  begin

    if bytesuche_codepuffer_0(#$b9'??'#$be'??'#$8b#$fe#$51#$56#$b4'?'#$ac#$32#$c4#$c0#$c4#$03#$02) then
      ausschrift('CC / Basil V. Vorontsov [1.01]',packer_exe);

    (*
    if bytesuche_codepuffer_0(#$b9'??'#$be#$03#$01#$8b#$fe#$51#$56#$b4'?'#$ac#$32#$c4#$c0#$c4#$03#$02) then
      ausschrift('',packer_exe); *)(* cc101.com , manticore *)

    if bytesuche_codepuffer_0(#$b9'??'#$bb#$0f#$01#$2e#$d2'?'#$2e#$28'?'#$43#$e2#$f7) then
      ausschrift('Inbuild Encryption / Christoph Gabler [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$b9'??'#$bb#$0f#$01#$c0#$07'?'#$80#$2f'?'#$43#$e2#$f7) then
      ausschrift('Inbuild Encryption / Christoph Gabler [1.0 /L]',packer_exe);

    if bytesuche_codepuffer_0(#$b9'??'#$bb#$03#$01#$bf#$00#$01#$2e#$8a#$07#$34#$b9#$fe#$c8) then
      ausschrift('ComProtector / Marco Ruhmann [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$b9#$ff#$00#$e8#$00#$00#$5b#$83#$c3#$2f#$90#$fa#$8b#$d4#$8b) then
      ausschrift('ComProtector / Marco Ruhmann [1.1]',packer_exe);

    if bytesuche_codepuffer_0(#$b9#$eb#$09#$b8#$05#$fe#$eb#$fc) then
      ausschrift('Khrome Crypt / Teraphy [0.3]',packer_exe);

    if bytesuche_codepuffer_0(#$b9'??'#$bb'??'#$be#$03#$01#$bf#$00#$01#$ad#$33#$c3
      +#$ab#$86#$df#$f7#$d3#$e2#$f6#$68#$00#$01#$c3) then
      (* 1.0 beta *)
      ausschrift('Shadow COM encryptor / Tailgunner [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$b9'??'#$be'??'#$bf'??'#$ac#$d0#$c8#$aa#$e2#$fa#$be'??'#$bf'??'#$ac#$aa) then
      (* UCFDSCPR *)
      ausschrift('Encriptor / ??? [1.00· recoded / Dark Stalker]',packer_exe);

    if bytesuche_codepuffer_0(#$b9'??'#$90#$be'??'#$bf'??'#$fc#$f3#$a4) then
      ausschrift('UNIT 173 Scrambler [1.00] ¯',packer_exe);

    if bytesuche_codepuffer_0(#$b9'??'#$90#$be'??'#$bf'??'#$57#$fc#$f3#$a4) then
      ausschrift('UNIT 173 Scrambler [1.01],[1.02] ¯',packer_exe);


  end;

procedure exe_ba;
  begin
    if bytesuche_codepuffer_0(#$ba'??'#$b4#$30#$cd#$21#$3c#$02#$73#$05#$33#$c0#$06#$50#$cb#$b9#$eb) then
      ausschrift('CC / UniHackers Group [2.61]',packer_exe);

    if bytesuche_codepuffer_0(#$ba#$32#$01#$b4#$09#$cd#$21#$06#$b8#$40#$00#$8e#$c0#$b9) then
      ausschrift('TurboBat / Foley Hi-Tech Systems [2.31 demo]',compiler);

    if bytesuche_codepuffer_0(#$ba#$31#$01#$b4#$09#$cd#$21#$06#$b8#$40#$00#$8e#$c0
         +#$b9#$03#$00#$26#$8a#$26#$6c#$00#$80#$e4#$0f
         +#$26#$a0#$6c#$00#$24#$0f#$3a#$c4#$74#$f6
         +#$26#$a0#$6c#$00#$24#$0f#$3a#$c4#$75#$f6
         +#$e2#$ea#$07#$e9) then
      ausschrift('TurboBat / Foley Hi-Tech Systems [3.10 demo]',compiler);

    if bytesuche_codepuffer_0(#$ba#$31#$01#$b4#$09#$cd#$21#$06#$b8#$40#$00#$8e#$c0#$b9
         +#$03#$00#$26#$8a#$26#$6c#$00#$80#$e4#$0f
         +#$26#$a0#$6c#$00#$24#$0f#$3a#$c4#$74#$f6
         +#$26#$a0#$6c#$00#$24#$0f#$3a#$c4#$75#$f6
         +#$e2#$ea#$07#$eb) then
      ausschrift('TurboBat / Foley Hi-Tech Systems [5.01 demo]',compiler);


    if bytesuche_codepuffer_0(#$ba'??'#$bb'??'#$06#$0e#$0e#$1f#$8c#$d0#$05#$08#$00#$8e#$c0#$8b#$cb) then
      ausschrift('Kvetch / Tal Nevo [1.02·]',packer_exe);

    if bytesuche_codepuffer_0(#$ba'??'#$8c#$c8#$8b#$c8#$03#$c2#$81#$c1'??'#$51) then
      (* COM/EXE *)
      ausschrift('Pksmart / PuchKov Sergey, Alex [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$ba'??'#$b9'??'#$51#$b0#$f5#$e6#$60#$fa#$b4#$30) then
      ausschrift('XoReR / dR.No / v!P Software [2.1]',packer_exe);

    if bytesuche_codepuffer_0(#$ba'??'#$b9'??'#$51#$b8#$ff#$ff#$e7#$21#$b4#$30#$cd#$21) then
      ausschrift('XoReR / dR.No / v!P Software [2.0]',packer_exe);

    if bytesuche_codepuffer_0(#$ba'??'#$b8#$00#$3d#$cd#$21#$8b#$d8) then
      begin
        ausschrift('<EXINCT-??> ¯',packer_exe);
      end;

    if bytesuche_codepuffer_0(#$ba'??'#$2e#$89#$16'??'#$40#$2e#$89#$06#$00#$00) then
      (* borland c *)
      ausschrift('ANTIupc / Hold [1.02]',packer_exe);

  end;

procedure exe_bb;
  begin
    if bytesuche_codepuffer_0(#$bb#$0f#$01#$b9'??'#$33#$c0#$2e#$80#$2f'?'#$43#$e2#$f9) then
      (* TRAP 1.13b *)
      ausschrift('SelfEnc / Daniel Arndt [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$bb'??'#$be#$04#$00#$81#$c6#$03#$01#$03#$f3#$bf#$00#$01#$b9) then
      ausschrift('COMLOCK / BoRZoM [0.10]',packer_exe);

    if bytesuche_codepuffer_0(#$bb#$05#$01#$b9'??'#$33#$c0#$2e#$80#$2f#$01) then
      (* STNCC (1996) *)
      (* findet auch die Basic-Implementierung von ComCrypt (BlackLight,MANtiCORE) (0.01a) *)
      ausschrift('ComCrypt / Stone',packer_exe);

    if bytesuche_codepuffer_0(#$bb#$00#$10#$b4#$4a#$cd#$21#$bb'??'#$b4#$48#$cd#$21) then
      ausschrift('MkCom18 / Jens Schulz',compiler);

    if bytesuche_codepuffer_0(#$bb#$10#$00#$e8#$22#$00#$bd#$fe#$0f) then
      ausschrift('Debug-Schutz <HIEW> / SEN',packer_exe);

    if bytesuche_codepuffer_0(#$bb'??'#$b9'??'#$31#$0f#$4b#$e2#$fb#$53#$c7) then
      ausschrift('XOR23 / JauMing Tseng',packer_exe);

    if bytesuche_codepuffer_0(#$bb'??'#$b9'??'#$31#$0f#$4b#$e2#$fb#$c7) then
      ausschrift('XOR25 / JauMing Tseng',packer_exe);

    if bytesuche_codepuffer_0(#$bb'??'#$b9'??'#$31#$0f#$43#$e2#$fb#$c7) then
      ausschrift('XOR27 / JauMing Tseng',packer_exe);

    if bytesuche_codepuffer_0(#$BB#$00#$10#$B4#$4A#$CD#$21#$33#$c0#$8b#$e0) then
      ausschrift('Micro C / Dave Dunfield [.COM]',compiler);

    if bytesuche_codepuffer_0(#$BB#$00#$10#$B4#$4A#$CD#$21#$bc#$00#$00#$be#$81#$00) then
      (* COMCHK *)
      ausschrift('Micro C / Dave Dunfield [.COM]',compiler);

    if bytesuche_codepuffer_0(#$bb'??'#$ba'??'#$0e#$1f) then
      (* Novell Dos 7 / Fifth Generations Systems / Search&D. , FBX
         FBX.EXE ,SDSCAN.EXE ,SDRES.EXE *)
      ausschrift('Kvetch / Tal Nevo [1.? ]',packer_exe);

    if bytesuche_codepuffer_0(#$bb#$fc#$14#$53#$58#$56) then
      ausschrift('Codelock 4 / "Dr. Detergent" ¯',packer_exe);

    if bytesuche_codepuffer_0(#$bb'??'#$8e#$db#$8c#$06'??'#$c7#$06'????'#$8c#$d0#$2b#$c3) then
      ausschrift('SEA ARC [7.12] SFX',packer_dat);


  end;

procedure exe_bc;
  begin

    if bytesuche_codepuffer_0(#$bc'??'#$0e#$1f#$be'??'#$b0#$4d#$b4#$5a#$46#$39#$04#$75#$fb#$46#$46#$83#$e6#$fe) then
      ausschrift('ZIVpackED / Eric ZMIRO [fox.com:1991]',packer_exe);

    if bytesuche_codepuffer_0(#$bc'??'#$fc#$b4#$4a#$bb'??'#$cd#$21#$8e#$06#$2c#$00) then
      ausschrift('WDXL / Veit Kannegieser',dos_win_extender);
    if bytesuche_codepuffer_0(#$bc'??'#$fc#$8e#$06#$2c#$00#$2b#$ff#$b0#$00#$b9#$ff#$ff#$f2#$ae#$ae#$75#$fb#$47) then
      ausschrift('WDXS_WFS / Veit Kannegieser',dos_win_extender);
    if bytesuche_codepuffer_0(#$bc'??'#$fc#$bf'??'#$ba'??'#$e8'??'#$b8'.;'#$ab#$e8) then
      ausschrift('WDXS / Veit Kannegieser',dos_win_extender);

    if bytesuche_codepuffer_0(#$BC'??'#$1e#$2b#$c0#$50#$89#$26) then
      ausschrift('List / Vernon D. Buerg',signatur);

  end;

procedure exe_bd;
  begin
    if bytesuche_codepuffer_0(#$bd'??'#$50#$53#$1e#$57#$56#$0e#$1f#$8b#$f5#$83#$c6#$32#$4d#$32#$c0#$4d#$3e#$8a) then
      ausschrift('Proton / MurSoft [2.0]',packer_exe);

    if bytesuche_codepuffer_0(#$bd'??'#$1e#$06#$8c#$c8#$8e#$d8#$8e#$c0#$b8#$35#$02#$05#$26#$00#$01#$e8) then
      (* PUTPASS1.LZH 1.0 *)
      ausschrift('Putpass / Danny Cornett and John Harrington',packer_exe);

    if bytesuche_codepuffer_0(#$bd'??'#$89#$2e#$f0#$01#$81#$06#$f0#$01#$f6#$01#$8c#$0e#$f4#$01) then
      ausschrift('EXE2COM / Basil V. Vorontsov [/P 9.50a]',packer_exe);

    if bytesuche_codepuffer_0(#$BD'??'#$47#$50#$06#$8C#$cb) then
      ausschrift('Fool! / Christoph Gabler [1.1 Compack 4.5 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$BD#$00#$00#$2E#$8E) then
      (* DBASE IV  DGEN.EXE *)
      ausschrift('MetaWare High C',packer_exe);

    if bytesuche_codepuffer_0(#$bd'??'#$be'??'#$bf'??'#$b8'??'#$99#$fc#$fa) then
      ausschrift('X-PACK / Jari Kytîjoki ¯',packer_exe);

    if bytesuche_codepuffer_0(#$bd'??'#$85#$ed#$75#$02) then
      ausschrift('Unix Lib / Marty Leisner ¯',compiler);

  end;

procedure exe_be;
  begin
    if bytesuche_codepuffer_0(#$be#$00#$01#$56#$c7#$04'??'#$c6#$44#$02'?'#$b9'??'#$30#$0c#$46#$e2#$fb#$b4#$0f#$cd#$10#$c3) then
      ausschrift('COMCrypt / Alexx [0.3beta]',packer_exe); (* 1998 *)

    if bytesuche_codepuffer_0(#$be'??'#$bf#$00#$01#$a5#$a4#$8c#$ca#$83#$c2#$10#$ad#$91#$e3#$06#$ad#$97#$01#$15
       +#$e2#$fa#$01#$54#$02#$01#$54#$06#$ad#$fa#$8e#$14#$94#$fb#$ff#$6c#$02) then
      ausschrift('tecc / Joergen Ibsen [0.02 8086]',packer_exe);

    if bytesuche_codepuffer_0(#$be'??'#$bf#$00#$01#$a5#$a4#$8c#$ca#$83#$c2#$10#$ad#$91#$e3#$06#$ad#$97#$01#$15
       +#$e2#$fa#$01#$54#$02#$01#$54#$06#$0f#$b2#$24#$ff#$6c#$04) then
      ausschrift('tecc / Joergen Ibsen [0.02 80386]',packer_exe);

    if bytesuche_codepuffer_0(#$be#$0d#$01#$bf'??'#$57#$b9#$24#$00#$f3#$a4#$c3#$bf#$00#$01#$57#$66#$60#$be#$31#$01) then
      ausschrift('[nh] cryptor',packer_exe); (* nh_orig.com, manticore *)

    if bytesuche_codepuffer_0(#$be#$0d#$01#$bf#$00#$7f#$8b#$cf#$fc) then
      ausschrift('aPACK / Joergen Ibsen [0.98b .COM <27K]',packer_exe);

    if bytesuche_codepuffer_0(#$be#$12#$01#$b9#$00#$80#$8b#$fe#$ac#$32#$c1) then
      (* ASETUP27.COM, OS2CM112.COM,... *)
      ausschrift('<ASETUP27.COM> / SkullC0DEr',packer_exe);

    if bytesuche_codepuffer_0(#$be'?'#$01#$bf#$00#$70#$8b#$cf#$fc#$57#$f3#$a4#$c3#$bf#$00#$01#$57) then
      (* auch -i *)
      ausschrift('aPACK / Joergen Ibsen [0.96b .COM <27K]',packer_exe);

    if bytesuche_codepuffer_0(#$be'??'#$bb#$00#$01#$8b#$cb#$8b#$04#$89#$07#$8a) then
      ausschrift('COMCHK / Dave Dunfield',packer_exe);

    if bytesuche_codepuffer_0(#$be#$2f#$01#$eb#$0e'Jau') then
      ausschrift('TXT2EXE / JauMing Tseng [2.01]',compiler);

    (* RTD_ENC *)
    if bytesuche_codepuffer_0(#$be#$0e#$01#$bf#$00#$01#$b9'??'#$b8'??'#$50#$c3) then
      ausschrift('Encryption Program / MR WiCKED [2]',packer_exe);

    if bytesuche_codepuffer_0(#$be#$03#$01#$8b#$fe#$8b#$ce#$33#$c0#$8e#$d8#$c7#$06#$0e#$00'??'#$c6#$06#$04#$00) then
      ausschrift('Encryption Program / MR WiCKED [3]',packer_exe);

    if bytesuche_codepuffer_0(#$be'??'#$8b#$fe#$b9'??'#$33#$db#$80#$c3'?'#$ac#$32#$c3#$aa#$e2#$f7) then
      ausschrift('XoReR / dR.No [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$be'?'#$00#$b9'??'#$b0'?'#$2e#$30#$04) then
      ausschrift('Secure / Piotr Warezak [0.23]',packer_exe);

    if bytesuche_codepuffer_0(#$be#$00#$01#$8b#$e8#$8b#$d8#$8b#$f8#$83'??'#$90#$8b#$d0) then
      (* UCFDSCPR *)
      ausschrift('IBM'#39's file protector / ??? [1.00 recoded / Dark Stalker]',packer_exe);

    if bytesuche_codepuffer_0(#$be'??'#$fc#$e8'??'#$05#$00#$01#$8b#$c8) then
      ausschrift('Pro-Pack / Rob Northen Computing [2.08/14/19 -m2 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$BE'??'#$E8#$00#$00#$5d#$83#$c5#$fa#$55#$50#$53#$51#$52#$0e) then
      (* z.B. Compack 4.5, .COM *)
      ausschrift('Compack [4.5 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$BE'??'#$E8#$00#$00#$5d#$83#$c5#$fa#$55#$50#$53#$51#$0e#$07) then
      (* z.B. Compack 4.5, .COM *)
      ausschrift('Compack [5.1 .COM]',packer_exe);


    if bytesuche_codepuffer_0(#$BE'??'#$E8#$00#$00#$50#$58#$4c#$4c#$5b) then
      ausschrift('Fool! / Christoph Gabler [1.1 Compack 4.5 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$BE'??'#$50#$53#$51#$52#$0E#$07#$0E#$1F#$E8#$00#$00) then
      (* COMAPCK 4.4 COM / MP.COM *)
      ausschrift('Compack [4.4 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$be'??'#$8e#$06'??'#$31#$ff#$b9'??') then
     (*
     VIRUS PROTECTION:
     File EXE2COM.COM is protected with anti-virus driver VACCINE.  It
     will  keep  most  viruses  away  from this file.  If your copy of
     EXE2COM is "sick" by a virus,  the program  will  tell  you  that
     immediately.  Also  you  will  have  an option to remove a virus.
     Prompt:  File Damaged!!! [A]bort, [R]ewrite, [C]ontinue. Pressing
     key  [A]  will  terminate  program;  [R]  will attempt to restore
     original file and  continue  with  a  program;  [C]  will  resume
     program.  You can be false alarmed if you try to hack or compress
     EXE2COM.COM with PKLITE or similar  programs.  To  prevent  false
     alarms just leave EXE2COM.COM the way it is.*)
      ausschrift('VACCINE / ? <EXE2COM 2.0> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$be'??'#$8b#$fe#$8b#$0e'??'#$8b#$16'??'#$b8'??'#$50#$fc) then
      ausschrift('ICE / Keith P, Graham 1.00',packer_exe);

    if bytesuche_codepuffer_0(#$be'??'#$b9#$4c#$00#$fc#$2e#$81#$34'??'#$ad#$2e#$81) then
      ausschrift('Virus Self-Destructor / Wojciech Wysznacki [2.00]',packer_exe);

    if bytesuche_codepuffer_0(#$be'??'#$b9#$4c#$00#$fc#$81#$34'??'#$ad#$81) then
      ausschrift('Virus Self-Destructor / Wojciech Wysznacki [2.00 .COM]',packer_exe);


  end;

procedure exe_bf;
  begin

    if bytesuche_codepuffer_0(#$bf'??'#$be#$0d#$01#$57#$b9'?'#$00#$f3#$a4#$c3#$be'?'#$01
      +#$fb#$f4#$8e#$d1#$89#$cc#$bf#$00#$01) then
      ausschrift('NuKE protection',packer_exe); (* sagt fi zu xpkl.com<2/3/4> *)

    if bytesuche_codepuffer_0(#$bf#$00#$01#$5e#$57#$b9'??'#$30#$0c#$a4#$e2#$fb#$c3) then
      ausschrift('MiCRoXoR / Joergen Ibsen [17byte]',packer_exe); (* 2000.06.11 *)

    if bytesuche_codepuffer_0(#$bf'??'#$57#$b1'?'#$80#$35'?'#$47#$e2#$fa#$c3) then
      ausschrift('LaMe CoM eNCRyPToR / CyberRax [1.12]',packer_exe);

    if bytesuche_codepuffer_0(#$bf#$00#$01#$57#$c7#$05'??'#$b1'?'#$80#$35'?'#$47#$e2#$fa#$31#$ff#$c3) then
      ausschrift('LaMe CoM eNCRyPToR / CyberRax [1.12 "129" /S ]',packer_exe);

    if bytesuche_codepuffer_0(#$bf#$00#$01#$57#$c7#$05'??'#$c6#$45#$02'?'#$b1'?'#$80#$35'?'#$47#$e2#$fa#$31#$ff#$c3) then
      ausschrift('LaMe CoM eNCRyPToR / CyberRax [1.12 "255" /S ]',packer_exe);

    if bytesuche_codepuffer_0(#$bf#$00#$01#$57#$c7#$05'??'#$c6#$45#$02'?'#$b9'??'#$80#$35'?'#$47#$e2#$fa#$31#$ff#$c3) then
      ausschrift('LaMe CoM eNCRyPToR / CyberRax [1.12 "256" /S ]',packer_exe);

    if bytesuche_codepuffer_0(#$bf'??'#$b8'??'#$2e#$31#$05#$d1#$c8#$4f#$81#$ff) then
      (* EXE *)
      ausschrift('iLUCRYPT / Christian Schwarz [4.017]',packer_exe);

    if bytesuche_codepuffer_0(#$bf'??'#$b8'??'#$31#$05#$d1#$c8#$4f#$81#$ff) then
      (* COM *)
      ausschrift('iLUCRYPT / Christian Schwarz [4.017]',packer_exe);

    if bytesuche_codepuffer_0(#$bf'??'#$32#$db#$2e#$8a#$15#$0a#$d2#$74#$21#$b4#$06#$cd#$21) then
      ausschrift('TXT2COM / Uwe Schlenther',compiler);

    if bytesuche_codepuffer_0(#$bf#$00#$01#$be#$03#$01#$b9'??'#$0e#$0e#$1f#$07#$8a#$14#$80#$f2'?'#$88#$15#$46#$47#$e2) then
      ausschrift('Encryption Program / MR WiCKED [1]',packer_exe);

    if bytesuche_codepuffer_0(#$bf#$00#$80#$be#$0c#$01#$b5'?'#$57#$f3#$a5#$c3#$33#$ed#$be'?'#$80#$bf#$00#$01) then
      ausschrift('RTD COM Compressor / Mr.Wicked',packer_exe);

    if bytesuche_codepuffer_0(#$bf#$e1#$ff#$57#$be#$0e#$01#$90#$b9) then
      (* CC11 *)
      ausschrift('CRYPTCOM / Frank Baumgartner [1.1]',packer_exe);

    if bytesuche_codepuffer_0(#$bf#$53#$ff#$57#$be#$0e#$01#$90#$b9) then
      (* MSCIC.COM *)
      ausschrift('CRYPTCOM / Frank Baumgartner [1.?]',packer_exe);

    if bytesuche_codepuffer_0(#$bf'??'#$e8#$ef#$ff#$90#$2b#$f7#$81) then
      (* PKUNZIP.EXE *)
      ausschrift('XPACK.UPC.Guard.[MSC] [1.67.l] / JauMing Tseng',packer_exe);

    if bytesuche_codepuffer_0(#$bf#$fa#$00#$be'??'#$b9#$06#$00#$fc#$f3#$a4#$8c#$cb) then
      (* ausschrift('EXE-Manager / Solar Designer [3.3]',packer_exe); *)
      ausschrift('??? EXE->COM <EMANAGER/Solar Designer [3.3]> ¯',packer_exe);

    if bytesuche_codepuffer_0(#$bf'??'#$3b#$fc#$72#$19#$b4#$09#$ba#$12#$01#$cd#$21#$b4#$4c#$cd#$21) then
      ausschrift('LGLZ / G.Lyapko [1.03/4 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$bf'??'#$8b#$16'??'#$0b#$d2#$74#$03#$e8#$1a#$00#$57#$ba#$18#$00) then
      ausschrift('ANZC / Paul Schubert [Mini]',compiler);

    if bytesuche_codepuffer_0(#$bf#$00#$01#$be'??'#$a5#$a4#$8c#$da#$83#$c2#$10) then
      (* mehrere Varianten ... *)
      ausschrift('EXE2COM / D'#39'B [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$bf#$00#$01#$8b#$f7#$ac#$ad#$91#$8a#$e1#$57#$ac#$32#$c4#$f6) then
      ausschrift('Crypt / Alex Lemenkov [2.0 .COM]',packer_exe);

  end;

procedure exe_c3;
  begin
    if bytesuche_codepuffer_0(#$c3#$c3#$cb#$83#$ec#$02#$8b) then
      ausschrift('MS-COBOL [4.5]',compiler);
  end;

procedure exe_c6;
  begin
    if bytesuche_codepuffer_0(#$C6#$06'??'#$00#$bf'??'#$8a#$0e) then
      ausschrift('XEQ Programmbibliothek / C. J. Stearman [1.60]',packer_exe);

    if bytesuche_codepuffer_0(#$c6#$06'???'#$c7#$06'????'#$c7#$06'????'#$b4#$2c#$cd#$21
        +#$8b#$c1#$f7#$e2#$03#$c2#$a3'??'#$b8#$21#$00#$cd#$33#$b8) then
      ausschrift('Explosiv 3.0 display module / H&G Software',bibliothek);
  end;


procedure exe_c7;
  begin
    if bytesuche_codepuffer_0(#$c7#$06#$00#$01'??'#$c6#$06#02#$01'?'#$8c#$ca#$81#$c2'??'#$52#$68'??'#$2b#$d2#$cb#$1a) then
      ausschrift('.COM Ansprung / AC Veit Kannegieser',signatur);

    if bytesuche_codepuffer_0(#$c7#$06#$00#$00'??'#$c6#$06#02#$00'?'#$8c#$ca#$81#$c2'??'#$52#$68'??'#$2b#$d2#$cb#$1a) then
      ausschrift('.BIN Ansprung / AC Veit Kannegieser',signatur);

    if bytesuche_codepuffer_0(#$C7#$06#$00#$01'??'#$c6#$06#$02#$01'?'#$8c#$c8#$05'??'#$8e#$d0) then
      ausschrift('LZ2COM / Martinic Computers [2.04]',packer_exe);

    if bytesuche_codepuffer_0(#$C7#$06#$00#$01'??'#$c6#$06#$02#$01'?'#$be#$00#$01#$bf#$00#$01#$fc#$32#$db#$ac#$02#$c3) then
      ausschrift('SCRAMBLE / Martinic Computers [2.04]',packer_exe);

    if bytesuche_codepuffer_0(#$C7#$06#$D7#$02#$00#$00#$C7#$06) then
      ausschrift('WIN.COM Microsoft Windows 3.10',dos_win_extender);

  end;

procedure exe_c8;
  begin
    if bytesuche_codepuffer_0(#$c8#$08#$00#$00#$e8'??'#$0e#$07#$c6#$46#$fe#$00#$e8'??'#$e8'??'#$8b#$0e'??'
      +#$e3#$02#$eb#$03#$e9'??'#$2b#$c0#$89) then
      ausschrift('CRK2COM / MACHiNE GUNgsTeR',compiler); (* 1.23 *)

    if bytesuche_codepuffer_0(#$c8#$08#$00#$00#$57#$56#$e8'??'#$c7#$46#$f8#$ff#$ff) then
      ausschrift('Immuse / Lucas Arts',bibliothek);
  end;

procedure exe_cc;
  begin
  end;

procedure exe_cd;
  begin
    if bytesuche_codepuffer_0(#$cd#$5d#$5b#$2a#$db#$53#$60#$2a#$c0#$eb#$0d#$90#$cd#$5d#$2e) then
      ausschrift('Sy2Pack / ? [FreeDos EMM386 / tom ehlert]',packer_exe);

  end;

procedure exe_db;
  begin
    if bytesuche_codepuffer_0(#$DB#$E3#$FC#$B8'??'#$8E#$D8#$8C#$06) then
      (* ADVENT *)
      ausschrift('CII-C',dos_win_extender);
  end;

procedure exe_e4;
  begin
    if bytesuche_codepuffer_0(#$e4#$21#$2E#$a2'??'#$b0#$fe) then
      (* TITUS FOX, STORM *)
      ausschrift('Best Protection Kit / Eric Smiro [1991]',packer_exe);

    if bytesuche_codepuffer_0(#$e4#$21#$2e#$a3#$64#$00#$33#$c0#$8b#$d8#$5d#$b9#$00#$01) then
      ausschrift('AEP / Ke Jia-Hann [1.00 .EXE]',packer_exe);
  end;

procedure exe_f9;
  begin
    if bytesuche_codepuffer_0(#$f9'CG'#$f9#$20#$8b#$d9) then
      ausschrift('Fool! / Christoph Gabler [1.1 XPack 1.76l COM]',packer_exe);

  end;

procedure exe_fa;
  begin

    if bytesuche_codepuffer_0(#$fa#$b8'??'#$8e#$d8#$8e#$d0#$26#$8b#$1e#$02#$00#$2b#$d8#$f7#$c3#$00#$f0#$75) then
      (* Zeichenkette bei DS:0 aber LÑnge unbekannt *)
      ausschrift('Lattice C [1.02]',compiler); (* rouge.zip - 1984 *)

    if bytesuche_codepuffer_0(#$fa#$5a#$86#$c6#$ee#$86#$c6) then
      ausschrift('Guardian,NetSafe,ZipProt / NetSafe',packer_exe);

    if bytesuche_codepuffer_0(#$fa#$8c#$cc#$8e#$d4#$bc'??'#$9c#$51#$52#$56#$57#$55#$0e#$1f#$2e#$8c#$06#$10#$00#$2e) then
      (* bitlok 2.01 readme.exe *)
      ausschrift('BITLOK / Yellow Rose Software Workgroup [2.01]',packer_exe);

    if bytesuche_codepuffer_0(#$fa#$8c#$cc#$8e#$d4#$bc'??'#$9c#$51#$52#$56#$57#$55#$0e#$1f#$2e#$8c#$06#$10#$00
        +#$0e#$07#$be'??'#$b9) then
      (* bitlok ?.?? unkey.com  *)
      ausschrift('BITLOK / Yellow Rose Software Workgroup [?.?? ¯ <UNKEY.COM>]',packer_exe);

    if bytesuche_codepuffer_0(#$fa#$53#$50#$58#$4c#$4c#$50#$b8#$eb#$05#$90#$58#$eb) then
      ausschrift('UniquE Software Protection / UniquE [?.? (EXUP) <2>]',packer_exe);

    if bytesuche_codepuffer_0(#$fa#$06#$1e#$8c#$dd#$83#$c5#$10#$2e#$01#$2e#$c3#$00#$2e#$01) then
      ausschrift('Crypt / Alex Lemenkov [2.0 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$fa#$06#$33#$c9#$8e#$c1#$bf#$0c#$00#$ab#$8b#$c6#$ab) then
      ausschrift('WWPACK PU -uh Prozedur [3.05·3]',packer_exe);

    if bytesuche_codepuffer_0(#$fa#$1e#$17#$50#$b4#$30) then
      (* PREHISTORIK *)
      ausschrift('PGMPAK / Todor Todorov [0.13] (ZIP)',packer_exe);

    if bytesuche_codepuffer_0(#$fa#$1e#$8e#$d8#$b8#$03#$25#$cd#$21#$8e#$d9#$8b#$d3#$b8#$01#$25#$cd#$21) then
      ausschrift('WWPACK PU -uh Prozedur [3.05·5]',packer_exe);

    if bytesuche_codepuffer_0(#$fa#$33#$ff#$bc#$fe#$00) then
      (* PREHISTORIK *)
      ausschrift('"LOADER & DECRUNCHER II" / Eric Smiro [TITUS]',packer_exe);

    if bytesuche_codepuffer_0(#$FA#$33#$C0#$8E#$D0#$BC#$E2#$7B#$BD#$E2) then
      (* TADOS ,.. *)
      ausschrift('IO.SYS      / MS ≥ IBMBIO.COM  / IBM  DOS 3.30',dos_win_extender);

    if bytesuche_codepuffer_0(#$fa#$33#$c0#$8e#$d8#$a1#$4c#$00#$2e#$a3) then
      ausschrift('IO.SYS      / MS ≥ IBMBIO.COM  / IBM  DOS 3.20',dos_win_extender);

    if bytesuche_codepuffer_0(#$fa#$60#$56#$1e#$8e#$d8#$be#$04#$00#$bf) then
      ausschrift('WiZ Cryptor / SP0T //UCL [1.00a]',packer_exe);

    if bytesuche_codepuffer_0(#$fa#$8b#$d8#$8c#$c8#$8e#$d8#$8e#$c0#$b8#$00#$20) then
      ausschrift('IPL.SYS / DOS-C 1.0 / Pat Villani [0.9]',dos_win_extender);

    if bytesuche_codepuffer_0(#$fa#$8b#$ec#$e8'??'#$fb#$06#$bf'??'#$57#$e8'??'#$06) then
      ausschrift('XPACK / JauMing Tseng [1.67 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$FA#$8C#$C7#$8C#$D6#$8B#$CC#$BA'??'#$8E#$C2) then
      (* A100.EXE COMPUSOFT *)
      ausschrift('PLINK86 / Phoenix Software Associates ( -> CLIPPER? )',compiler);

    if bytesuche_codepuffer_0(#$fa#$8c#$d0#$05#$00#$10#$8e#$d0#$e8#$61#$00) then
      ausschrift('AEP / Ke Jia-Hann [1.00 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$fa#$8c#$c3#$02#$df#$50#$33#$c0) then
      ausschrift('ExeCode / Bal†zs Scheidler [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$fa#$b8'??'#$8e#$d0#$66#$bc'??'#$00#$00#$fc#$0e#$1f#$e8'?'#$ff#$8c#$c0) then
      ausschrift('DOS-Extender PMODEN [2.51] / Thomas Pytel,Cyborg/Mistery,Ivan Tomac',dos_win_extender);

    if bytesuche_codepuffer_0(#$fa#$b8'??'#$8e#$d8#$b8'??'#$a3'??'#$8e#$d0#$bc) then
      (* SymbMath = sm221a.zip *)
      ausschrift('Turbo Prolog',compiler);

    if bytesuche_codepuffer_0(#$fa#$bf'??'#$b0'?'#$b9'??'#$2e#$8a#$25) then
      ausschrift('Hyperlock / Jayeson Lee-Steere 1.0',packer_exe);

    if bytesuche_codepuffer_0(#$FA#$FC#$2E#$89#$16#$46#$03#$2E#$89#$26) then
      ausschrift('MSDOS.SYS   / MS ≥ IBMDOS.COM  / IBM  DOS 4.00/01',dos_win_extender);

    if bytesuche_codepuffer_0(#$fa#$fc#$31#$ff#$8e#$c7#$26#$ff#$36) then
      ausschrift('Scrambler [1.00]¯',packer_exe);

  end;

procedure exe_fb;
  begin
    (* BIN\STUB32A.EXE 6.00 *)
    if bytesuche_codepuffer_0(#$fb#$0e#$1f#$8c#$c0#$8c#$d3#$a3'??'#$2b#$d8#$8b#$c4#$c1#$e8#$04#$03#$d8) then
      ausschrift('STUB DOS/32 Advanced / Supernar Systems',dos_win_extender);

    if bytesuche_codepuffer_0(#$fb#$0e#$1f#$8c#$c0#$8c#$d3#$a3'??'#$2b#$d8#$8b#$c4#$d1#$e8#$d1#$e8#$d1#$e8#$d1#$e8#$03#$d8#$43#$b4#$4a) then
      (* STUB/32A R8-07.0101.0076 (C) 1996-98, 2002 by Narech Koumar. All Rights Reserved. 10-15-02 11:25:08 *)
      ausschrift('STUB DOS/32 Advanced / Supernar Systems',dos_win_extender);

    if bytesuche_codepuffer_0(#$fb#$8c#$c9#$8e#$c1#$26) then
      ausschrift('Watcom C',compiler);

  end;

procedure exe_fc;
  begin
    if bytesuche_codepuffer_0(#$fc#$1e#$b8'??'#$8e#$d8#$8e#$c0#$b9'??'#$33#$f6#$33#$ff#$ac#$32#$c1#$aa#$e2#$fa#$1f#$50#$58#$4c) then
      (* in den Quelltext eingebaute VerschlÅsselung *)
      ausschrift('<AEFDISK.EXE> / Nagy Daniel',packer_exe);

    if bytesuche_codepuffer_0(#$fc#$8a#$0e#$80#$00#$32#$ed#$e3#$19#$bf#$81#$00#$b0#$20#$f3#$ae#$74#$10#$e8'??'
       +#$ba'??'#$cd#$21#$ba#$0c#$01#$cd#$21) then
      ausschrift('Doc2Page / Ralph Roth',compiler);

    if bytesuche_codepuffer_0(#$fc#$bf#$00#$80#$57#$be#$0d#$01#$b5'?'#$f3#$a5#$c3#$2b#$ed#$be#$6c#$80) then
      (* ROSE SWE Ultra COM File Compressor *)
      ausschrift('RUCC / Ralph Roth [1.00]',packer_exe);(* ,1.01 *)

    (* XE 1.4.0 fÅr TMT *)
    if bytesuche_codepuffer_0(#$fc#$8c#$1d'????'#$66#$b8#$ff#$ff#$ba'????'#$cd#$21) then
      ausschrift('TMTSTUB / Rustam Gadeyev; JauMing Tseng [0.33]',dos_win_extender);

    if bytesuche_codepuffer_0(#$fc#$66#$67#$8c#$1e'??'#$66#$b8#$ff#$ff#$ba'????'#$cd#$21) then
      ausschrift('TMTSTUB / Rustam Gadeyev [0.31]',dos_win_extender);

    if bytesuche_codepuffer_0(#$fc#$b8'??'#$bb'??'#$b9'??'#$be#$03#$01#$30#$04#$02#$c3#$86#$c4#$86#$df#$46#$e2#$f5) then
      ausschrift('Tiny Xor / dR.No / v!P Software [0.1]',packer_exe);

    if bytesuche_codepuffer_0(#$fc#$1e#$06#$8c#$c3#$83#$c3#$10#$0e#$1f#$be) then
      ausschrift('RERP / Ralph Roth [0.02]',packer_exe);

    if bytesuche_codepuffer_0(#$fc#$1e#$06#$8c#$dd#$83#$c5#$10#$89#$e8#$ba'??'#$8b#$1e) then
      ausschrift('ComprEXE / Tom Torfs [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$fc#$1e#$06#$0e#$8c#$c8#$01#$06'??'#$ba'??'#$03#$c2) then
      ausschrift('LGLZ / G.Lyapko [1.03/4 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$fc#$be#$00#$01#$8b#$fe#$b9'??'#$51#$56#$57#$b4#$18#$04#$0a#$ac) then
      ausschrift('Com Sccrambler / Moshe [0.1]',packer_exe);

    if bytesuche_codepuffer_0(#$fc#$2b#$ed#$b8'??'#$8e#$d8#$fa#$8e#$d0#$bc'??'#$fb#$1e#$0e#$1f) then
      (* SHRINKER/BLINKINC *)
      ausschrift('DOS-Extender Blinker 4.11 "BLX286" / Assembler Software Manufacturers Inc',dos_win_extender);

    if bytesuche_codepuffer_0(#$fc#$8c#$c8#$8e#$d8#$8e#$c0#$80#$3e#$41#$00#$00#$74#$30) then
      ausschrift('BoniJoni Intomaker [0.4]',compiler);

    if bytesuche_codepuffer_0(#$fc#$e8#$d0#$00#$c3#$00) then
      (* OBSOLETE.EXE/*.com *)
      ausschrift('Mouse Systems Menu Compiler',compiler);

    if bytesuche_codepuffer_0(#$FC#$8B#$0E#$16#$07#$49#$8B#$36#$1A#$07) then
      (* DOC2COM 1.3 *)
      ausschrift('DOC2COM / Jerry DePyper',compiler);

    if bytesuche_codepuffer_0(#$fc#$bc#$00#$01#$b8#$00) then
      ausschrift('COMMAND.COM PTS-DOS',dos_win_extender);

    if bytesuche_codepuffer_0(#$FC#$BC'??'#$0E#$1F) then
      (* Golf.EXE VIRSTOP.EXE *)
      ausschrift('SEA-AXE',packer_exe);

    if bytesuche_codepuffer_0(#$FC#$B8'??'#$8E#$D8#$89#$26) then
      ausschrift('Lattice C ??? (WordPerf)¯',overlay_);

    if bytesuche_codepuffer_0(#$fc#$bb#$00#$01#$e8'??'#$b4#$30#$cd#$21#$8b#$d8#06) then
      ausschrift('EXARJ / Jakub Jel°nek',packer_dat);

    if bytesuche_codepuffer_0(#$fc#$8c#$d8#$bb'??'#$8e#$db#$8c#$16) then
      ausschrift('GEOWORKS [1.0]',dos_win_extender);

    if bytesuche_codepuffer_0(#$fc#$0e#$1f#$8c#$06'??'#$26#$a1) then
      ausschrift('GEOWORKS [2.X]',dos_win_extender);

    if bytesuche_codepuffer_0(#$fc#$be#$5c#$00#$bf#$0b#$fe#$bb) then
      ausschrift('BatchMaster / Clockwork Software [1993]',compiler);

    if bytesuche_codepuffer_0(#$fc#$1e#$8a#$1e'??'#$16#$07#$0e#$1f) then
      ausschrift('LARC / K.Miki, H.Okumura, K.Masuyama [EXE]',packer_dat);

    if bytesuche_codepuffer_0(#$fc#$2e#$89#$26'??'#$2e#$8c#$16'??'#$2e#$8c#$1e'??'#$8c#$c8) then
      (* LHARK 0.2a *)
      ausschrift('anti-virus kit ".exe" file vaccine / Kerwin F. Medina',packer_exe);

  end;

procedure exe_fd;
  begin
    if bytesuche_codepuffer_0(#$fd#$53'?????????????????'#$eb'?'#$33#$c2#$8f#$06#$1e#$01#$31#$04) then
      (* sagt fi zu hwinfo.com (EliCZ [pCE] pRESENTZ:pATCH fOR HWiNFO v4.3.0 Mar-02-98 *)
      (* 100..11f EntschlÅsselung,                            +32
         120..8e9 entschlÅsseltes Programm,
         8ea..8f7 entschlÅsselter Kopierer,                   +14
         8f8..8fb VerschlÅsselungsdaten                       + 4 *)
      ausschrift('<Slovakian COM-Crypt [1997-99] hwinfo.com> [+50]',packer_exe);

    if bytesuche_codepuffer_0(#$fd#$e8#$ff#$ff#$c7#$5e#$83#$ee'?'#$e8) then
      ausschrift('aPATCH / Joergen Ibsen [0.05]',packer_exe);

  end;

procedure exe_ff;
  begin
    if bytesuche_codepuffer_0(#$ff#$26'??'#$9c#$50#$53#$51#$8c#$d8) then
      ausschrift('NOCLIP / TD Tecnologia Digital [4.0]',packer_exe);
  end;

end.
