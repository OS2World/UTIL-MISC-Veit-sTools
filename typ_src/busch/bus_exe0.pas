{$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y-}
(*$IFNDEF VIRTUALPASCAL*)
{$M 16384,0,655360}
(*$ENDIF*)
(* $I TYP_COMP.PAS*)
program bus_exe0;

uses
  crt,
  bus_exe2,
  typ_type,
  buschbau;

function bytesuche_codepuffer_0(const sig:string):boolean;
  var
    egal:byte;
  begin
    bytesuche_codepuffer_0:=bytesuche(egal,sig);
  end;



(*$F+*)
type
  prozedur_exe_typ=procedure;


procedure exe_nichts;
  begin
  end;

procedure exe_00;
  begin
    if bytesuche_codepuffer_0(#$00#$00#$00#$00#$b0#$ad#$e6#$64#$e8#$00#$00#$5d) then
      ausschrift('DS-CRP / Dark Stalker [1.30]' (* UCF *),packer_exe);
  end;

procedure exe_01;
  begin
    if bytesuche_codepuffer_0(#$01#$84#$0f#$60) then
      ausschrift('DOSPLUS.SYS [1.2] Digital Research DOSPLUS',dos_win_extender);
  end;

procedure exe_06;
  begin
    if bytesuche_codepuffer_0(#$06#$1e#$0e#$0e#$07#$1f'???'#$b9'??'#$87'?'#$81'???'#$53#$e8#$0d#$00) then
      (* xwwp.zip, lÑuft nicht wegen Prefetch-Queue-Tricks *)
      ausschrift('(Nuke?) Protection by Black Wolf',packer_exe);

    if bytesuche_codepuffer_0(#$06#$e5#$21#$0c#$02#$e6#$21#$90#$cc#$2e) then
      ausschrift('UniquE Software Protection / UniquE [?.? (EXUP) <1>]',packer_exe);

    if bytesuche_codepuffer_0(#$06#$1e#$8c#$d8#$05#$10#$00#$8e#$d8#$33#$db) then
      ausschrift('CRYPACK / George Stark [3.0]',packer_exe);

    if bytesuche_codepuffer_0(#$06#$0e#$07#$bb#$00#$01#$31#$c0#$90#$90) then
      (* SDM-HV51 *)
      ausschrift('Anti-LAME / [ptPower ¯',packer_exe);

    if bytesuche_codepuffer_0(#$06#$b8#$2e#$35#$cd#$21#$26#$80#$3f#$cf) then
      ausschrift('BatLite / Pieter A. Hintjens [1.5]',compiler);

    if bytesuche_codepuffer_0(#$06#$BA'??'#$8E#$DA#$26#$8B#$3E) then
      (* 3D.EXE zu MUSICIAN *)
      ausschrift('BASICA',compiler);

    if bytesuche_codepuffer_0(#$06#$E8'??'#$2B#$DB#$BF) then
      (* TROLLS *)
      ausschrift('GFA-Basic / GFA Systemtechnik GmbH',compiler);

    if bytesuche_codepuffer_0(#$06#$e8#$00#$00#$5e#$83#$ee#$04) then
      ausschrift('DSHIELD / Ben Castricum [UNP]',packer_exe);

    if bytesuche_codepuffer_0(#$06#$8c#$c8#$8e#$d8#$8e#$c0#$fc) then
      ausschrift('GA / Stefan Verkoyen [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$06#$8c#$c8#$8e#$c0#$be'??'#$26#$8a#$04#$34) then
      ausschrift('ExeLock / JON Software [ 1.00 /D ]',packer_exe);

    if bytesuche_codepuffer_0(#$06#$1E#$55#$57#$56#$52#$51#$53) then
      ausschrift('TSCRUNCH / Clarion Software [Modula 2]',packer_exe);

    if bytesuche_codepuffer_0(#$06#$fc#$8c#$c8#$ba'??'#$03#$d0#$52#$ba) then
      ausschrift('RJCrush / Roland Skinner [1.0..1.10]',packer_exe);

    if bytesuche_codepuffer_0(#$06#$e8'??'#$bf#$00#$b8#$b4#$0f) then
      ausschrift('TXT2COM / Cefek Computer Group',compiler);

  end;

procedure exe_0e;
  begin
    if bytesuche_codepuffer_0(#$0e#$1f#$e8'??'#$c7#$06'????'#$fc#$b0#$43#$e6#$43#$32#$c0#$e6#$40) then
      (* ist eigentlich auch ein Compiler, aber das Programm ist das Overlay *)
      (* XS36208b.zip: 1.04.36208b *)
      ausschrift('XSCompiler / Victor Prodan [1.04]',dos_win_extender);

    if bytesuche_codepuffer_0(#$0e#$5a#$2b#$c0#$8e#$c0#$bb'??'#$50#$a0#$01#$01#$26#$c7#$47#$0a) then
      ausschrift('File Protection / Bumerang [2.20 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$0e#$5a#$2e#$c4#$1e'??'#$26#$c7#$07'??'#$2b#$c0#$26#$c7#$47#$02) then
      ausschrift('File Protection / Bumerang [2.20 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$0e#$b8'??'#$8b#$ec#$01#$46#$00#$9c#$b8#$00#$01#$89#$46#$fe#$cb) then
      ausschrift('Sesame / Goreinov S.A. [1.1 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$0e#$be#$00#$01#$56#$8b#$fe#$8c#$c8#$80#$c4#$10#$8e#$c0#$b9'??'#$fc) then
      ausschrift('XE / JauMing Tseng [dos/com 1.3.*,1.4.*]',packer_exe);

    if bytesuche_codepuffer_0(#$0e#$1f#$8c#$06'??'#$b4#$30#$cd#$21#$3c#$03#$73#$05#$b8#$07#$00
        +#$eb#$1b#$c6#$06'???'#$c6#$06) then
      (* CCDL180E.ZIP: CC386.EXE *)
      (* PMODE 3.08 *)
      ausschrift('Stub-386 / David Lindauer',dos_win_extender);

    (* BIN\STUB32C.EXE "configurable" 6.00 *)
    if bytesuche_codepuffer_0(#$0e#$1f#$8c#$c0#$8c#$d3#$a3'??'#$2b#$d8#$8b#$c4#$c1#$e8#$04#$03#$d8) then
      ausschrift('STUB DOS/32 Advanced / Supernar Systems',dos_win_extender);

    if bytesuche_codepuffer_0(#$0e#$1f#$8c#$c0#$8c#$d3#$a3'??'#$2b#$d8#$8b#$c4#$d1#$e8#$d1#$e8#$d1#$e8#$d1#$e8#$03#$d8#$43#$b4#$4a) then
      (* STUB/32C, R8-07.0101.0076, (C) 1996-98, 2002 by Narech Koumar., All Rights Reserved., 10-15-02, 11:25:08 *)
      ausschrift('STUB DOS/32 Advanced / Supernar Systems',dos_win_extender);

    if bytesuche_codepuffer_0(#$0e#$1f#$fc#$c6#$06'??'#$01#$e8'??'#$33#$c9) then
      ausschrift('Maustreiber [SICMOUSE]',signatur);

    if bytesuche_codepuffer_0(#$0e#$07#$be'??'#$bf#$00#$01#$b9#$05#$00#$f3#$a4#$b9) then
      ausschrift('MSCC / Mad Scientist [1.0·]',packer_exe);

    if bytesuche_codepuffer_0(#$0e#$07#$b9'??'#$be#$00#$01#$33#$ff#$fc#$f3#$a4) then
      ausschrift('AINEXE / Transas Marine [2.3]',packer_exe);

    if bytesuche_codepuffer_0(#$0e#$1f#$06#$8c#$06'??'#$26#$a1#$2c#$00#$a3) then
      ausschrift('DOS-EXTENDER TMT Pascal [PMODE]',dos_win_extender);


    if bytesuche_codepuffer_0(#$0e#$58#$8e#$c0#$8e#$d8#$8d#$16'??'#$68#$00#$70#$9d) then
      ausschrift('GPatch / JES [1.2b]',packer_exe);

    if bytesuche_codepuffer_0(#$0e#$58#$fa#$bc#$00#$01#$8e#$d0#$fb#$0e) then
      (* normal *)
      ausschrift('ANZC / Paul Schubert',compiler);

    if bytesuche_codepuffer_0(#$0e#$07#$b8#$40#$00#$8e#$d8#$a0#$84#$00#$8b#$0e) then
      ausschrift('ANZC / Paul Schubert [Luxus]',compiler);

    if bytesuche_codepuffer_0(#$0e#$1f#$fc#$9c#$5b#$8b#$c3#$80) then
      ausschrift('DOS32 / Adam Seychell 3.3',dos_win_extender);

    if bytesuche_codepuffer_0(#$0E#$1f#$a3'??'#$8c#$1e'??'#$8c#$1e) then
      (* SIMCITY *)
      ausschrift('"EXECUTRIX" = "COMPRESSOR" / Knowledge Dynamics Corp [SIMCITY]',packer_exe);

    if bytesuche_codepuffer_0(#$0e#$1f#$9a'????'#$73#$11#$8b#$f0#$03#$f0) then
      ausschrift('DOS-Extender PMODE [3.0X] / Thomas Pytel',dos_win_extender);

  end;

procedure exe_16;
  begin
    if bytesuche_codepuffer_0(#$16#$17#$9c#$58#$f6#$c4#$01#$74#$03#$fa#$eb#$fd#$e8#$01#$00#$ea#$58) then
      (* -=[ Crypt Version 1.0 (c) Alex 1999 ]=-
          <®¨Ô_‰†©´†>                             *)
      ausschrift('Crypt / Alex [1.0]',packer_exe);


    if bytesuche_codepuffer_0(#$16#$53#$66#$5b) then
      ausschrift('X-32(VM) Dos-Extender / Doug Huffman; FlashTek [1994]',dos_win_extender);
  end;

procedure exe_18;
  begin
    if bytesuche_codepuffer_0(#$18#$01#$00#$1a#$eb) then
      ausschrift('TinyProt / Igor Hakszer [1.0c,e]',packer_exe);
  end;

procedure exe_1e;
  begin
    if bytesuche_codepuffer_0(#$1e#$e9#$84#$00#$e9#$8c#$02#$80#$fc#$4c) then
      ausschrift('KL / Sergej Rastorgujev',packer_exe);

    if bytesuche_codepuffer_0(#$1e#$06#$56#$57#$fc#$8c#$c8#$8e#$d8#$8e#$c0#$31#$db#$c7#$07'??'#$89#$5f#$02#$bf) then
      (* LHASFX.EXE, T2EVIEW.DOS *)
      ausschrift('ise / P.Fischer-Haaser [?.?]',packer_exe);

    if bytesuche_codepuffer_0(#$1e#$06#$be#$00#$01#$bf#$00#$01#$b9'??'#$0e#$1f#$0e#$07#$e8#$02#$00#$eb) then
      ausschrift('mCRYPT / Ufo Crew 98 [0.1·eta]',packer_exe);

    if bytesuche_codepuffer_0(#$1e#$06#$90#$8c#$dd#$83#$c5#$10#$89#$e8#$ba'??'#$8b#$1e) then
      ausschrift('Fool! / Christoph Gabler[1.1 ComprEXE / Tom Torfs 1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$1e#$06#$8c#$c8#$ba'??'#$03#$c2#$8b#$d8#$05'??'#$fc#$33#$f6#$33#$ff#$48) then
      ausschrift('aPACK code-mover / Joergen Ibsen [0.73+]',packer_exe);

    if bytesuche_codepuffer_0(#$1e#$06#$8c#$c8#$2e#$2b#$06'??'#$8e#$c0#$8b#$d0) then
      ausschrift('RELOCation handler / Piotr Warezak [1.00]',packer_exe);

    if bytesuche_codepuffer_0(#$1e#$06#$9a#$db#$06'??'#$2e#$8c) then
      ausschrift('VM Manager [->Borland C]',overlay_);

    if bytesuche_codepuffer_0(#$1E#$06#$fc#$8c#$c8#$8e#$d8) then
      ausschrift('BLINKER (ƒ CLIPPER)',compiler);

    if bytesuche_codepuffer_0(#$1E#$06#$8c#$c8#$8e#$d8#$8e#$c0#$2e#$c6#$06) then
      (* ausschrift('unbekannte Kompression <PENTAGON>',packer_exe); *)
      ausschrift('Protect! / Jeremy Lilley [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$1E#$06#$8c#$c8#$8e#$d8#$8e#$c0#$be#$a7#$00) then
      (* UNPLEO.EXE *)
      ausschrift('Protect! / Jeremy Lilley [2.0]',packer_exe);

    if bytesuche_codepuffer_0(#$1E#$0e#$0e#$1f#$07#$e8#$e1#$00#$58#$2e) then
      ausschrift('Compressor 1.1 ¯',packer_exe);

    if bytesuche_codepuffer_0(#$1e#$06#$33#$c0#$8e#$d8#$ff) then
      ausschrift('ProtEXE / Tom Torfs [2.11 -0]',packer_exe);

    if bytesuche_codepuffer_0(#$1E#$0e#$0e#$1f#$07#$53#$e8#$00#$00#$5b) then
      ausschrift('AVPL Testvirus .COM ',virus);

    if bytesuche_codepuffer_0(#$1e#$b4#$30#$cd#$21#$3c#$02#$73#$02#$cd#$20#$be'??'#$e8) then
      ausschrift('Protect! / Jeremy Lilley [6.0]',packer_exe);

  end;

procedure exe_2e;
  begin
    if bytesuche_codepuffer_0(#$2e#$8b#$1e#$01#$01#$ba'??'#$2b#$da#$81#$c3#$00#$01#$e8#$ce#$ff#$55#$cc#$5d) then
      ausschrift('Anti-Debug Coder / Majorov Ruslan [1.6]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8b#$3e#$01#$01#$81#$c7#$00#$01#$2e#$8b#$05#$8a#$c8#$2e#$a3#$00#$01#$2e#$8a#$45#$02
      +#$2e#$a2#$02) then
      ausschrift('Maverick''s C0DER [1.00a]',packer_exe); (* maverick.com,manticore *)


    if bytesuche_codepuffer_0(#$2e#$c6#$06#$00#$00#$e9#$2e#$c6#$06#$01#$00'?'#$2e#$c6#$06#$02#$00'?'#$e9) then
      (* VGACOPY 5.2 *)
      ausschrift('PKTiny / Mînkemeier [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8c#$1e#$02#$00#$2e#$a3#$04#$00#$8c#$c8#$8e#$d8#$2e#$a3#$0a#$00#$06#$8c#$c0#$48
         +#$8e#$c0#$26#$80#$3e) then
      ausschrift('Xenia EXE-file Protector [1.00]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8c#$1e#$04#$02#$e8#$c4#$fc#$1e#$06#$8c#$d8) then
      (* JMCE 0.7r *)
      ausschrift('JMCryptExe / JauMing Tseng [0.7r]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$a3#$0c#$00#$2e#$8c#$1e#$08#$00#$55#$e2#$fe) then
      ausschrift('CryptExe / Dop?;JauMing Tseng? [1.01 <XPACK.COM 1.45(2)>',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$83#$26#$01#$01#$00#$8b#$ec#$eb#$01'?'#$fa#$b8) then
      ausschrift('XPACK / JauMing Tseng [1.40 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$a3#$0d#$00#$53#$51#$52#$1e#$06#$b4#$09) then
      (* CPT20 EXE *)
      ausschrift('Copy Protector / A.Vodyanik [2.0]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8b#$26#$06#$01#$81#$c4'??'#$2e#$a1) then
      (* UCF96.COM (CUP386),UCF2000.COM *)
      ausschrift('Character Intro Engine / SoNiC [4.1]',compiler);

    if bytesuche_codepuffer_0(#$2e#$a1#$4c#$00#$3c#$00#$74#$4d#$be#$00#$a0#$bd#$01#$00#$8c#$ca#$bf#$a3#$00) then
      (* TRX-GFEX.ZIP *)
      ausschrift('GFX to EXE / t-REX [1.0]',compiler);

    if bytesuche_codepuffer_0(#$2e#$a1#$4d#$00#$3c#$00#$74#$55#$be#$00#$a0#$bd#$01#$00#$8c#$ca#$bf#$ac#$00) then
      (* TCEC,SDW178 *)
      (* TRX-GFX2-ZIP *)
      ausschrift('GFX to EXE / t-REX [2.0]',compiler);

    if bytesuche_codepuffer_0(#$2e#$8c#$1e'??'#$2e#$8c#$06'??'#$2e#$8c#$1e'??'#$2e#$8c#$0e'??'#$8c#$c8) then
      ausschrift('Fastcopy / Kwok Ka Yeung [5.01]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$f6#$06'??'#$80#$74#$05#$fa#$bc'??'#$fb#$1e#$0e) then
      ausschrift('TextRun / Sawada',compiler);

    if bytesuche_codepuffer_0(#$2e#$c7#$06#$04#$01#$00#$00) then
      ausschrift('XPACK / JauMing Tseng [1.0..1.34]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$c7#$06#$01#$01#$00#$00#$8b#$ec#$eb#$01) then
      ausschrift('XPACK / JauMing Tseng [1.36 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8c#$1e#$35#$00#$eb) then
      ausschrift('DoP''s CRYPTEXE [1.01]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8c#$06'??'#$0e#$1f#$bf'??'#$33#$db) then
      ausschrift('Ady''s Glue [1.10]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8c#$06'??'#$0e#$07#$33#$c0#$8e#$d8#$be) then
      (* in SBUST.EXE, gefunden von XO.EXE *)
      ausschrift('Ady''s Glue [0.1X] ¯',packer_exe);

    if bytesuche_codepuffer_0(#$2E#$8c#$1e#$06#$00#$2e#$8c#$06#$08#$00#$8C#$c3) then
      ausschrift('PACK / TurboPower Sofware',packer_exe);

    if bytesuche_codepuffer_0(#$2E#$8C#$1E'??'#$FC#$2B#$C0#$8C#$D3) then
      ausschrift('TopSpeed Modula / Jensen & Partners I. [1.17]',compiler);

    if bytesuche_codepuffer_0(#$2E#$8C#$1E#$06#$30#$8C#$06#$6C#$0a#$50#$53) then
      ausschrift('IBMDOS.COM  Digital Research DOS 6',dos_win_extender);

    if bytesuche_codepuffer_0(#$2E#$C6#$06#$00#$00#$C3#$BC#$00) then
      ausschrift('IBMBIO.COM  Novell DOS 7',dos_win_extender);

    if bytesuche_codepuffer_0(#$2E#$81#$26'??'#$FF#$F7#$2E) then
      ausschrift('IBMDOS.COM  Novell DOS 7',dos_win_extender);

    if bytesuche_codepuffer_0(#$2E#$88#$0e#$a9#$04#$2e#$89#$3e) then
      ausschrift('PTSBIO.SYS  PTS-DOS',dos_win_extender);

    if bytesuche_codepuffer_0(#$2e#$c6#$06#$07#$00#$04#$eb#$00) then
      (* TPCX10 *)
      ausschrift('ANTI-TRACE 1.0 / Oren Maurice',packer_exe);

    if bytesuche_codepuffer_0(#$2E#$8C#$1E#$00#$00#$2E#$A3#$02#$00) then
      (* cruncher 1.0 *)
      ausschrift('Cruncher',packer_exe);

    if bytesuche_codepuffer_0(#$2E#$8c#$06'??'#$2e#$87#$06'??'#$8b#$ec) then
      ausschrift('Shield / V Communications + Ret Rat [170.386]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$a3#$00#$00#$8c#$d8#$2e#$a3#$02#$00#$8c#$c8) then
      ausschrift('Protect! / Jeremy Lilley [3.1?,.EXE ¯]',packer_exe);

    if bytesuche_codepuffer_0(#$2e#$8c#$06'??'#$2e#$a3'??'#$e8'??'#$b4#$08#$b2#$00#$cd#$13) then
      ausschrift('CONVOY++ / Elias Copy-Protection Systems [3.2]',packer_exe);

  end;

procedure exe_31;
  begin

    (* 32 Bit COM Overlay *)
    if bytesuche_codepuffer_0(#$31#$c0#$48#$ba'???'#$00#$cd#$21#$73#$04#$b4#$4c#$cd) then
      ausschrift('32LiTE / OleGPro [0.02d]',packer_exe);

    if bytesuche_codepuffer_0(#$31#$ed#$9a'????'#$55#$89#$e5#$9a) then
      ausschrift('StonyBrook Pascal [6.1G]',compiler);

    if bytesuche_codepuffer_0(#$31#$c0#$8e#$c0#$26#$c7#$06#$04#$00#$64#$01#$26#$8c#$0e) then
      ausschrift('BIN-Lock / Hit-BBS Programmers crew [1.00]',packer_exe);

  end;

procedure exe_33;
  begin
    if bytesuche_codepuffer_0(#$33#$db#$b5#$78#$8b#$f9#$8b#$e9#$be#$12#$01#$57#$f3#$a4#$bf#$00#$01#$c3#$57#$33) then
      ausschrift('Dn.Com Cruncher / ? [1.2]',packer_exe);

    if bytesuche_codepuffer_0(#$33#$db#$b9'??'#$d1#$e9#$41#$b8#$ac#$0b#$8b#$97#$03#$01#$33#$c2#$89#$87) then
      ausschrift('hijaq cryptor',packer_exe); (* hijaq.com, manticore *)

    if bytesuche_codepuffer_0(#$33#$c0#$33#$db#$33#$c9#$33#$d2#$33#$ed#$bf#$00#$01#$be#$03#$01#$b9'??'#$ac#$83#$c3) then
      (* ryptor10.zip *)
      ausschrift('ShadE'#39's COM encRYPTOR [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$33#$ed#$83#$ed#$04#$2e#$d0#$56#$00#$5e#$0e#$8b#$fe#$81#$e7) then
      ausschrift('MCOD / ? [2.0]',packer_exe);

    if bytesuche_codepuffer_0(#$33#$c0#$8e#$d8#$ff#$36#$00#$00#$ff#$36#$02#$00#$68) then
      (* V.K. 23.03.1997 "RAR25" *)
      ausschrift('Olivia / AndrÇ',virus);

    if bytesuche_codepuffer_0(#$33#$C0#$be'??'#$8b#$d8#$b9'??'#$bf) then
      ausschrift('CHECKPRG / Jordi Mas Hern†ndez ¯',packer_exe);

    if bytesuche_codepuffer_0(#$33#$DB#$B4#$03#$CD#$10#$89#$16#$5F#$01) then
      ausschrift('ASIC - Basic Compiler / David A. Visti [3.00]',compiler);

  end;

procedure exe_3a;
  begin

  end;

procedure exe_3e;
  begin
    if bytesuche_codepuffer_0(#$3e#$c6#$06#$08'??'#$90#$eb#$03) then
      ausschrift('T.P.C.''s  COM File Scrambler',packer_exe);
  end;

procedure exe_40;
  begin
    (* COM2TXT / Dandler Productions nach busch_dat verschoben (als Text arkannt) *)
  end;

procedure exe_42;
  begin
    if bytesuche_codepuffer_0('Bj@jzh`0X-`/PPPPPPa(DE(DM(DO(Dh(Ls(Lu(LX(LeZRR]E') then
      ausschrift('TEXT 2 ASCII / Herbert Kleebauer',packer_exe);

    if bytesuche_codepuffer_0('BEGIN==='#$74#$66#$75#$64) then
      ausschrift('Com4Mail / Juri Krasilnikov [1.0]',packer_exe);

    if bytesuche_codepuffer_0('BWT'#$be#$12#$01) then
      ausschrift('EXECON tc1 / Keve G†bor [2.5]',packer_exe);

    if bytesuche_codepuffer_0('BWT'#$eb#$6a) then
      ausschrift('EXECON tc2 / Keve G†bor [2.5]',packer_exe);

  end;


procedure exe_44;
  begin
    if bytesuche_codepuffer_0('DUKELISTXXX'#$81#$fc#$fe#$ff#$74) then
      (* CRYPT_A.COM (M. Hering) *)
      ausschrift('Super LAME! Crypt / P.S.A.',packer_exe);
  end;

procedure exe_45;
  begin
    if bytesuche_codepuffer_0('ENC.COM.B&F') then
      ausschrift('COMT / Alexander Pruss [3->4]',packer_exe);
    if bytesuche_codepuffer_0('ENC.COM.BEG') then
      ausschrift('COMT / Alexander Pruss [1->2]',packer_exe);
  end;


procedure exe_46;
  begin
    if bytesuche_codepuffer_0(#$46#$55#$43#$4b#$59#$4f#$55#$1a#$ff#$5f#$b8#$00#$70#$50#$9d) then
      ausschrift('SCRAM! / Stonehead [·5]',packer_exe);
  end;

procedure exe_48;
  begin
    if bytesuche_codepuffer_0('HQD'#$2e#$a1#$01#$01#$2d#$11#$00#$8b#$d8) then
      ausschrift('Mr.HDKiLLeR ProtectioN [1.1‡ / eMX!]',packer_exe);

    if bytesuche_codepuffer_0('HENDRIX'#$fa'OF'#$fa'UCF') then
      ausschrift('GTR / Hendr≠x',signatur);
  end;

procedure exe_4d;
  begin
  end;

procedure exe_50;
  begin
    if bytesuche_codepuffer_0(#$50#$53#$8b#$dc#$8c#$d0#$bc#$00#$f0#$8e#$d4#$90#$90#$90#$90#$90) then
      ausschrift('Crack Soft''s cryptor',packer_exe); (* crk_soft.com,manticore *)

    if bytesuche_codepuffer_0(#$50#$53#$51#$52#$1e#$06#$57#$e8#$00#$00#$5f#$83#$ef#$0d#$b4#$09#$1e#$0e#$1f#$ba) then
      (* CPT20 COM *)
      ausschrift('Copy Protector / A.Vodyanik [2.0]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$b8'??'#$8e#$d8#$8f#$06#$04#$00#$8c#$06) then
      (* NE-DOSX *)
      ausschrift('CA-Realia / Computer Associates International',dos_win_extender);

    (* SGAFMT3.EXE *)
    if bytesuche_codepuffer_0(#$50#$b4#$30#$cd#$21#$3c#$02#$7d#$03#$e9#$2b#$02#$e8) then
      ausschrift('File Shield / McAfee Associates [1.2] ¯',packer_exe);

    if bytesuche_codepuffer_0(#$50#$1e#$eb#$71#$90#$00#$00) then (* EXE *)
      ausschrift('File Shield / McAfee Associates [1.5]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$e8#$00#$00#$5b#$b1#$04#$d3#$eb#$8c#$c9) then (* COM *)
      ausschrift('File Shield / McAfee Associates [1.5]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$b8'??'#$1e#$06#$e8#$00#$00#$58#$2d'?'#$00#$b1#$04) then
      (* RA_CPLOK *)
      ausschrift('COPS Copylock II',packer_exe);

    if bytesuche_codepuffer_0(#$50#$58#$4c#$4c#$5b#$3b#$c3#$75#$fe#$f9#$9c) then
      ausschrift('Fool! / Christoph Gabler [1.1 Diet]',packer_exe);

    if bytesuche_codepuffer_0('PULP'#$83#$c4#$07#$fc#$bf#$00#$80) then
      (* 624 *)
      ausschrift('Six-2-Four / Kim Holviala [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$1e#$33#$c0#$8e#$d8#$a1#$04#$00#$8b#$1e#$06#$00#$3b#$06#$0c#$00) then
      ausschrift('LockProg / Myrlochar^Kryst^TPD^PDL [0.5a]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$58#$4c#$4c#$5b#$3b#$c2) then
      ausschrift('FOOL! / Christoph Gabler [1.0 DIET]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$53#$51#$52#$56#$57#$1e#$06#$e8#$00#$00#$5e#$81#$ee'??'#$2e#$89#$36#$00#$01) then
      ausschrift('IMMUN / Jens Bleuel [1.2 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$53#$51#$52#$56#$57#$1e#$06#$2e#$8b#$0e'??'#$e3#$1e#$1e#$06#$d1#$e1) then
      ausschrift('IMMUN / Jens Bleuel [1.2 .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$2e#$8c#$06'??'#$33#$c0#$8e#$c0#$2e#$f6#$06) then
      (* BJIM Bonijoni Intromaker *)
      ausschrift('Eliashim'#39's CodeTrack ¯',packer_exe);

    if bytesuche_codepuffer_0(#$50#$fc#$0e#$1f#$1e#$07#$ba'??'#$b4#$09) then
      ausschrift('CRYPTEXE / Dmitriy Borisov [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$eb#$2c#$00#$00) then
      ausschrift('CRYPTEXE / Dmitriy Borisov [1.0 .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$9c#$fc#$be#$1f#$01) then
      ausschrift('SHRINK / Thomas G. Hanlin III [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$9c#$fc#$be#$27#$01#$8b#$fe#$8c#$c8#$05) then
      ausschrift('Shrink 2.0 / JauMing Tseng',packer_exe);

    if bytesuche_codepuffer_0(#$50#$1e#$06#$0e#$55#$0e#$1f#$33#$c0) then
      (* .COM *)
      ausschrift('Protect! / Jeremy Lilley [3.1?,.COM ¯]',packer_exe);

    if bytesuche_codepuffer_0(#$50#$50#$50#$53#$51#$52) then
      (* F-MACRO.EXE - F-Prot 2.23 *)
      ausschrift('F-XLOCK [1.16] / Frisk Software',packer_exe);


  end;

procedure exe_52;
  begin
    if bytesuche_codepuffer_0(#$52#$ba#$eb#$05#$5a#$eb#$fb#$66#$69#$66#$fa#$52#$ba) then
      ausschrift('TCEC / ThE CLERiC [3.55b]',packer_exe);

  end;

procedure exe_53;
  begin
    if bytesuche_codepuffer_0('SCRAM'#$b4#$30#$cd#$21#$3c#$02) then
      ausschrift('SCRAM / Bushwoeli [0.7c1,0.8a1]',packer_exe);

    if bytesuche_codepuffer_0(#$53#$8c#$d3#$15'??'#$8b#$ec#$eb#$01'?'#$b8'??'#$ff#$e0) then
      ausschrift('MSLite / Mecury Soft [3]',packer_exe);

  end;

procedure exe_54;
  begin
    if bytesuche_codepuffer_0('TCEC'#$b9#$ff#$ff#$83#$c4#$04#$33#$c0) then
      (* MESS 1.07 - MESSR / Sefan Esser funktioniert bis auf CS:IP (um ein Byte verschoben) *)
      ausschrift('TCEC / ThE CLERiC [3.55]',packer_exe);

    if bytesuche_codepuffer_0(#$54#$58#$3b#$c4#$f8) then
      ausschrift('Micro Focus COBOL',compiler);

  end;

procedure exe_55;
  begin

    if bytesuche_codepuffer_0(#$55#$57#$cc#$53#$fc#$58#$50#$41#$43#$fa#$8b#$ec#$83#$6e#$06#$03#$ff#$76#$06) then
      (* xpack 165b6 xpack.com(1) *)
      ausschrift('XPAC / JauMing Tseng [2.4]',packer_exe);

    if bytesuche_codepuffer_0(#$55#$8B#$EC#$83#$EC#$50#$32#$C0) then
      (* PAK 2.51 *)
      ausschrift('Pak Sfx',packer_dat);

    if bytesuche_codepuffer_0(#$55#$8B#$EC#$83#$EC#$1E) then
      ausschrift('Propack Sfx / Rob Northen Computing',packer_dat);

    if bytesuche_codepuffer_0(#$55#$8b#$ec#$2e#$8e#$1e'??'#$a1'??'#$d1#$c8) then
      ausschrift('Fitted Modula-2 / Roger Carvalho [2.0a,3.1]',compiler);

  end;

procedure exe_56;
  begin

    if bytesuche_codepuffer_0(#$56#$60#$56#$d1#$ef#$95#$91#$f3#$a5#$5f#$e9#$ff#$7e#$57#$bb'??'#$ba'??'#$b1) then
      ausschrift('TiNYPack / Jibz [1]',packer_exe);

    if bytesuche_codepuffer_0(#$56#$60#$56#$d1#$ef#$95#$91#$f3#$a5#$5f#$e9#$ff#$7e#$bb'??'#$ba'??'#$b1) then
      ausschrift('TiNYPack / Jibz [2]',packer_exe);

    if bytesuche_codepuffer_0(#$56#$56#$be'??'#$bf'??'#$b9'??'#$fd#$f3#$a4#$fc#$5f#$bd'??'#$ba'??'#$e9) then
      ausschrift('TiNYPack / metalbrain [3]',packer_exe);

    if bytesuche_codepuffer_0(#$56#$c6#$44#$02'?'#$b9'??'#$c7#$04'??'#$56#$80#$34'?'#$46#$e2#$fa#$5e#$c3) then
      ausschrift('LaMe CoM eNCRyPToR / CyberRax [1.2 /S]',packer_exe);

    if bytesuche_codepuffer_0(#$56#$fa#$b8'??'#$8e#$d8#$8e#$d0) then
      ausschrift('LHARK SFX / Kerwin F. Medina [0.1,0.2]',packer_dat);

  end;

procedure exe_58;
  begin
    if bytesuche_codepuffer_0('X502503P_5:S)E8,wP-Q_P5r35;4P-+JP5JS-W$Phkxh-k-$'#$27'$^PTXSW9#') then
      ausschrift('com to text / Joergen Ibsen [c2t1]',packer_exe);

    if bytesuche_codepuffer_0('X502503P_5:P)En-whP,QP5rH5;TP-{IP-kB-kTP-*BP-hc-iZP5O35JTP-za-eB'+#$0d#$0a
          +'QP-{X,}P-_s$DPh;y-0m-(jP-!\P-5O-JAPh^$TZSXSW9$') then
      ausschrift('com to text / Joergen Ibsen [c2t2]',packer_exe);

    if bytesuche_codepuffer_0('XP[@PPD]5`P(f#(f((f?5!QP^P_u!2$=po}l=!!rZF*$*$ =') then
      ausschrift('YAAA / Padgett [1.01]',packer_exe); (* 1994 *)

    if bytesuche_codepuffer_0(#$58#$bc'??'#$50#$b4#$4a#$bb'??'#$cd#$21#$73#$08#$b4#$09#$ba'??'#$cd#$21#$c3) then
      ausschrift('SPHINX C-- / Peter Cellik',compiler); (* 1994 *)

    if bytesuche_codepuffer_0(#$58#$bc'??'#$50#$b4#$4a#$bb'??'#$cd#$21#$73#$01#$c3) then
      ausschrift('SPHINX C-- / Peter Cellik',compiler); (* 1994 *)


    if bytesuche_codepuffer_0('X5O!P%@AP[4\PZ') then
      ausschrift('EICAR AV-Test',signatur); (* F-PROT *)

    if bytesuche_codepuffer_0(#$58#$40#$50#$c3) then
      ausschrift('LamerStop / Stefan Esser [1.0·]',packer_exe);

    if bytesuche_codepuffer_0('XPACKI2'#$c0) then
      (* EXPAND.EXE *)
      ausschrift('XPACK.UPC.Guard.[Quickbasic] [1.67.l] / JauMing Tseng',packer_exe);
  end;

procedure exe_59;
  begin
    if bytesuche_codepuffer_0(#$59#$8b#$e9) then
      ausschrift('Deep-Crypter / PLaSMoiD [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$59#$1f#$a1#$00#$00#$1e#$51#$0e) then
      ausschrift('QBASIC / MS',compiler);

    if bytesuche_codepuffer_0(#$59#$1f#$a0#$01#$00#$1e#$51#$06) then
      ausschrift('QBASIC / MS',compiler);


  end;

procedure exe_5a;
  begin
    if bytesuche_codepuffer_0(#$5a#$5f#$57#$8b#$f7#$8b#$ce#$33#$db#$b7'?'#$ac#$fe#$c0#$f6#$d0#$32#$c7#$aa) then
      ausschrift('Scrypt! / DarkGrey [0.4,1.4]',packer_exe);

    if bytesuche_codepuffer_0(#$5d#$81#$ed'??'#$b9'??'#$be'??'#$03#$f5#$8b#$fe#$b4'?'#$ac#$32#$c4#$f6#$d4#$aa#$e2#$f8) then
      (* AVP sagt Crypt.Beep *)
      ausschrift('Scrypt! / DarkGrey [0.4]',packer_exe);

  end;

procedure exe_5b;
  begin
    if bytesuche_codepuffer_0(#$5b#$83#$eb#$03#$8d#$b8#$16#$ff#$b9#$7a#$00#$2e#$81#$35'??'#$af#$e2#$f8) then
      (* lîscht sich selbst (NWDOS 7) *)
      (* COM/EXE *)
      ausschrift('Copy Protector / Andrew V. Basharimoff [1.02]',packer_exe);

    if bytesuche_codepuffer_0(#$5b#$0e#$1f#$81#$eb#$50#$02#$8b#$c3#$05#$69#$02) then
      (* EXE/COM *)
      ausschrift('Scramb / B.U.G. [1.20]',packer_exe);

  (*if bytesuche_codepuffer_0(#$5b#$0e#$1f#$81#$eb#$5d#$02#$8b#$c3#$05#$76#$02) then*)
    if bytesuche_codepuffer_0(#$5b#$0e#$1f#$81#$eb'?'#$002#$8b#$c3#$05'?'#$002) then
      (* wd_720.com *)
      ausschrift('Scramb / B.U.G. [1.20??]',packer_exe);


    if bytesuche_codepuffer_0('[ESP]'#$b5#$78#$8b#$f9#$8b#$e9#$be#$12#$01#$57#$f3) then
      (* 624 *)
      ausschrift('Six-2-Four / Kim Holviala; Boogie/ESP [1.1]',packer_exe);

    if bytesuche_codepuffer_0(#$5b#$81#$eb#$1d#$00#$8d#$b7#$00#$00#$bf) then
      ausschrift('EXE2COM / Paul Shpilsher [2.00]',packer_exe);

  end;

procedure exe_5d;
  begin
    if bytesuche_codepuffer_0(#$5d#$81#$ed'??'#$60#$53#$bb#$eb#$04#$5b#$eb#$fb#$9a#$66#$33#$c0#$b8) then
      (* UNLCC 1.12 *)
      ausschrift('SECURELOCK / tecPiG [0.3]',packer_exe);

    if bytesuche_codepuffer_0(#$5d#$8d#$5e#$48#$eb#$5f#$01#$37#$eb#$78#$bf#$03#$01#$e9#$91#$00) then
      ausschrift('Simple CRYPTer / hijaq [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$5d#$b2'?'#$8b#$cd#$83#$ed#$03#$bf#$00#$01#$be#$03#$01#$2b#$cf#$ac#$32) then
      ausschrift('EXE2COM / Basil V. Vorontsov [Z /M4 9.50a]',packer_exe);

    if bytesuche_codepuffer_0(#$5d#$83#$ed#$04#$55#$d9#$d0#$9c#$58#$25#$ff#$fe#$50#$9d#$50#$57) then
      ausschrift('C-Crypt / De'#39'FeinD/uCT [1.02]',packer_exe);

    if bytesuche_codepuffer_0(#$5d#$81#$ed'??'#$1e#$06#$0e#$1f#$0e#$07#$07#$58#$06#$50#$b9'??'#$05#$0f#$00#$40) then
      (* STNCRP *)
      ausschrift('ExeCrypt / Stone',packer_exe);

    if bytesuche_codepuffer_0(#$5D#$81#$ED'??'#$33#$C0#$8E#$D8) then
      (* Test mit SW-Version Protect! 4.0  .COM *)
      ausschrift('Protect! / Jeremy Lilley [4.0]',packer_exe);

    if bytesuche_codepuffer_0(#$5d#$81#$ed'??'#$81#$ed'??'#$2e#$8c#$8e) then
      ausschrift('"util coded v0.21" ??? ¯',packer_exe);

    if bytesuche_codepuffer_0(#$5d#$83#$ed#$03#$1e#$8c#$da#$83#$c2#$10#$8e#$da#$8e#$c2) then
      ausschrift('EXETools / DISMEMBER [2.1 /E .EXE]',packer_exe);

    if bytesuche_codepuffer_0(#$5d#$8b#$cd#$83#$ed#$03#$bf#$00#$01#$be#$03#$01) then
      ausschrift('EXETools / DISMEMBER [2.1 /3:EXE->COM]',packer_exe);

    if bytesuche_codepuffer_0(#$5d#$81#$ed'??'#$eb#$01#$66#$bf#$00#$01#$eb#$01#$ea#$b0#$ad) then
      (* UCFDSCPR *)
      ausschrift('CC286x˝ / Dark Stalker',packer_exe);

  end;

procedure exe_5e;
  begin
    if bytesuche_codepuffer_0(#$5e#$8e#$06#$2c#$00#$51#$1e#$0e#$1f#$8d#$94'??'#$b4#$1a#$cd#$21#$31#$c0#$bf#$01#$00#$fc) then
      (* exe2com.exe  Selbsttest:
           (c) MultiScan. Ç≠®¨†≠®• !!! ù‚„ Ø‡Æ£‡†¨¨„ ®ß¨•≠®´ ¢®‡„·.
          éØ‡•§•´®‚• §†´Ï≠•©Ë®• §•©·‚¢®Ô :
           C - ¢Î´•Á®‚Ï ‰†©´;
           N - ≠• Ø‡Æ®ß¢Æ§®‚Ï ´•Á•≠®•;
           Q - ≠•¨•§´•≠≠Î© ¢ÎÂÆ§ ®ß Ø‡Æ£‡†¨¨Î. *)
      ausschrift('Vaccine (MultiScan?) / ?',packer_exe);

    if bytesuche_codepuffer_0(#$5e#$e4#$61#$0c#$80#$e6#$61#$2e#$89#$36#$fc#$00#$81) then
      ausschrift('CC / Basil V. Vorontsov [1.5]',packer_exe);

    if bytesuche_codepuffer_0(#$5e#$bf#$00#$01#$57#$b9'??'#$ac#$34'?'#$aa#$e2#$fa#$c3) then
      (* UCFDSCPR *)
      ausschrift('X3 / Dark Stalker',packer_exe);

    if bytesuche_codepuffer_0(#$5e#$8b#$d6#$83#$ea#$03#$83#$c6#$27#$06#$0e) then
      ausschrift('WWPACK-Mutator / Stefan Esser [1.0]',packer_exe);

    if bytesuche_codepuffer_0(#$5e#$81#$ee#$03#$01#$e8#$1a#$00#$e8) then
      ausschrift('Ambulance',virus);

  end;

procedure exe_5f;
  begin
    if bytesuche_codepuffer_0(#$5f#$87#$fe#$57#$b9'??'#$ac#$32#$c1#$aa#$e2#$fa#$c3) then
      ausschrift('invisible Cryptor / VAG [0.77] (17)',packer_exe);

    if bytesuche_codepuffer_0(#$5f#$87#$f7#$57#$b9'??'#$ac#$34#$ff#$aa#$e2#$fa#$c3) then
      ausschrift('Wumpus Soft Lab cryptor',packer_exe); (* wumpus.com, manticore *)

    if bytesuche_codepuffer_0(#$5f#$83#$ef#$03#$e8#$00#$00#$5e) then
      ausschrift('Perfume',virus);

    (* EXE -> COM aus ARK101.ZIP *)
    if bytesuche_codepuffer_0(#$5f#$81#$fc'??'#$72#$3b#$87#$45#$35#$a3#$00#$01#$8a) then
      ausschrift('EXC / Kris Heidenstrom [1.0.0]',packer_exe);

  end;

procedure exe_60;
  begin

    if bytesuche_codepuffer_0(#$60#$eb#$02#$e8'?'#$83#$c6#$03#$eb#$02#$e8'?'#$b9'??'#$eb#$01) then
      ausschrift('comer / bart [1.1]',packer_exe);

    if bytesuche_codepuffer_0(#$60#$33#$c9#$be#$22#$01#$f7#$e1#$ab#$8d#$7c#$de#$60#$e8'??'#$cd#$21#$33#$c9#$93#$8b#$d1) then
      (* 'step' *)
      ausschrift('Self Test Envelope Protection / Joergen Ibsen [0.02b]',packer_exe);

    (*                         `hcmX-D95?4PhCkX-0l522Ph]ZX-0[5w2P-;N5;[Ph}~X-0_5i;PhyvX-0`5C2J= *)
    if bytesuche_codepuffer_0('`h??X-??5??Ph??X-??5??Ph??X-??5??P-??5??Ph??X-??5??Ph??X-??5??J=') then
      ausschrift('COM2UUEX / Z0MBiE',packer_exe);

    if bytesuche_codepuffer_0('`hAzX-B15<HPh5vX-X>54?P-jA5wGPhD3X-Es5>UPh]NX-^T5u;P-F<56fPh1vJ=') then
      ausschrift('COM2UUE / Z0MBiE',packer_exe);

    if bytesuche_codepuffer_0(#$60#$1e#$06#$e8#$00#$00#$5e#$83#$ee#$20#$8c#$d8#$05#$10#$00#$8e#$d8#$2e#$01#$84) then
      ausschrift('PCRYPT / Andry Kobilykov [3.2u]',packer_exe); (* MERLiN *)

    if bytesuche_codepuffer_0(#$60#$1e#$06#$b4#$30#$cd#$21#$3c#$02#$73#$05#$33#$c0#$06#$50#$cb#$b4#$30#$cd) then
      ausschrift('PCRYPT / Andry Kobilykov [3.32r]',packer_exe); (* MERLiN *)

    if bytesuche_codepuffer_0(#$60#$06#$b8#$eb#$02#$eb#$fc#$b0#$ad#$e6#$64#$50#$e4#$15#$0c#$02#$e6#$15) then
      ausschrift('E-Prot 386+ / MasterBall Systems [1.0· .COM]',packer_exe);

    if bytesuche_codepuffer_0(#$60#$8e#$06#$2c#$00#$87#$cf#$87#$fb#$fe#$c0#$f2#$af#$06#$89#$3e) then
      ausschrift('VACCINE Sphinks-2 / RedArc',packer_exe);

    if bytesuche_codepuffer_0(#$60#$9c#$fc#$be#$03#$01#$bf#$00#$01'?'#$13#$00#$01'?'#$01#$2a) then
      (* ? FI: A.Alferowich *)
      ausschrift('Scramble / Tiny Spaceman Software [0.2]',packer_exe);

    if bytesuche_codepuffer_0(#$60#$c7#$04'??'#$c6#$44#$02'?'#$b9'??'#$bf'??'#$ac) then
      ausschrift('C0M-C0DEr / SkullC0DEr [0.04]',packer_exe);

    if bytesuche_codepuffer_0(#$60#$bb'??'#$b9'??'#$30#$0f#$43#$e2#$fb) then
      ausschrift('USCC / UniquE [1.4]',packer_exe);

    if bytesuche_codepuffer_0(#$60#$8e#$06#$2c#$00#$33#$c0#$8b#$f8#$b9#$ff#$7f#$fc) then
      ausschrift('MkEXE / Lui TaoTao',packer_exe);

    if bytesuche_codepuffer_0(#$60#$06#$fa#$e4#$64#$0c#$40#$e6#$64#$b8#$40#$00#$8e#$c0#$26) then
      ausschrift('UComCry / UniquE',packer_exe);

    if bytesuche_codepuffer_0(#$60#$1e#$b4#$09#$0e#$1f#$0e#$07#$ba'??'#$cd#$21#$e8) then
      ausschrift('SuckStop / Ka0t^N0Ps [1.08r..1.11r /P]',packer_exe);

  end;

procedure exe_66;
  begin
    if bytesuche_codepuffer_0(#$66#$fa#$e8#$00#$00#$5d#$81#$ed#$69#$29#$b8#$27#$18#$8b#$d4#$8d#$a6#$89#$29#$b9) then
      ausschrift('TCEC / ThE CLERiC [3.58]',packer_exe);

    if bytesuche_codepuffer_0(#$66#$b8'????'#$66#$a3#$00#$01#$be#$04#$01#$8b#$fe#$b9'??'#$fc#$ad#$35) then
      ausschrift('Evil Genius cryptor',packer_exe); (* evil_gen.com, manticore *)

  end;

procedure exe_68;
  begin
    if bytesuche_codepuffer_0(#$68'??'#$1f#$fc#$bd'??'#$90#$81#$ed#$00#$00#$8c#$06'??'#$b4#$30#$cd#$21) then
      (* pngcrush.exe *)
      ausschrift('pmodedj / DJ Delorie <1997>',dos_win_extender); (* COFF *)

    if bytesuche_codepuffer_0(#$68'??'#$1f#$bd'??'#$90#$81#$ed#$00#$00#$8c#$06'??'#$fc#$b4#$30#$cd#$21) then
      (* rarx320.exe *)
      ausschrift('pmodedj / DJ Delorie <2000>',dos_win_extender); (* COFF *)

    if bytesuche_codepuffer_0(#$68#$00#$01#$60#$be#$04#$01#$66#$b8'????'#$66#$87#$06#$00#$01#$b9) then
      ausschrift('NoAV / Vladimir Gneushev',packer_exe);

    if bytesuche_codepuffer_0(#$68#$00#$01#$9c#$0f#$a0#$0f#$a8#$60#$fd) then
      (* AdFlt2=#4,#5 AdFlt2A=extra *)
      ausschrift('AdFlt2,AdFlt2a (fILTER #4,#5,..) / EliCZ',packer_exe);

    if bytesuche_codepuffer_0(#$68#$00#$01#$60#$bf#$03#$01#$b9'??'#$b0'?'#$2e#$30#$05#$fe) then
      ausschrift('R-Crypt / Ralph Roth [0.91]',packer_exe); (* +0.93 *)

    if bytesuche_codepuffer_0(#$68#$00#$01#$60#$bf#$03#$01#$b9'??'#$b0'?'#$2e#$30#$05#$47) then
      ausschrift('R-Crypt / Ralph Roth [0.95]',packer_exe);

    if bytesuche_codepuffer_0(#$68#$00#$01#$68#$30#$01#$68'??'#$be#$16#$01) then
      ausschrift('EXETools / DISMEMBER [2.1 /E .COM]',packer_exe);

  end;

procedure exe_72;
  begin
    if bytesuche_codepuffer_0(#$72#$f0#$3b#$c8#$75#$ec#$36#$66) then
      ausschrift('X-32(VM) Dos-Extender / Doug Huffman; FlashTek [1992,93,94]',dos_win_extender);
  end;

procedure exe_73;
  begin
    if bytesuche_codepuffer_0(#$73#$01#$90#$e9) then
      ausschrift('Jerusalem.Taiwan',virus);
  end;

const
  exe_verteiler:array[0..255] of prozedur_exe_typ=
   (exe_00,
    exe_01,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_06,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_0e,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_16,
    exe_nichts,
    exe_18,
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
    exe_nichts,
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
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_3a,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_3e,
    exe_nichts,
    exe_40,
    exe_nichts,
    exe_42,
    exe_nichts,
    exe_44,
    exe_45,
    exe_46,
    exe_nichts,
    exe_48,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_4d,
    exe_nichts,
    exe_nichts,
    exe_50,
    exe_nichts,
    exe_52,
    exe_53,
    exe_54,
    exe_55,
    exe_56,
    exe_nichts,
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
    exe_72,
    exe_73,
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
    exe_80,
    exe_81,
    exe_nichts,
    exe_83,
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_87,
    exe_nichts,
    exe_89,
    exe_nichts,
    exe_8b,
    exe_8c,
    exe_nichts,
    exe_8e,
    exe_nichts,
    exe_90,
    exe_nichts,
    exe_nichts,
    exe_93,
    exe_nichts,
    exe_nichts,
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
    exe_a1,
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
    exe_b0,
    exe_nichts,
    exe_nichts,
    exe_b3,
    exe_b4,
    exe_nichts,
    exe_nichts,
    exe_b7,
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
    exe_c3,
    exe_nichts,
    exe_nichts,
    exe_c6,
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
    exe_db,
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
    exe_nichts,
    exe_nichts,
    exe_nichts,
    exe_f9,
    exe_fa,
    exe_fb,
    exe_fc,
    exe_fd,
    exe_nichts,
    exe_ff);

(* €€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€ *)


var
  z:byte;
begin
  for z:=$00 to $ff do
    begin
      write(^m,z:3);
      exe_verteiler[z];
    end;
  writeln;

  abspeichern('exe.dat');
end.

