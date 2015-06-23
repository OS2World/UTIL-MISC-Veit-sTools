{$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y-}
(*$IFNDEF VIRTUALPASCAL*)
{$M 16384,0,655360}
(*$ENDIF*)
(* $I TYP_COMP.PAS*)
program bus_exe0;

uses
  crt,
  typ_type,
  buschbau;

function bytesuche_sekt_puffer_0(const sig:string):boolean;
  var
    egal:byte;
  begin
    bytesuche_sekt_puffer_0:=bytesuche(egal,sig);
  end;

procedure ausschrift_signatur(const zk:string);
  begin
    ausschrift(zk,signatur);
  end;


begin
          (* $2E: *)
          if bytesuche_sekt_puffer_0(#$2e#$ff#$2e#$3e#$7c#$fa#$8c#$c8) then
            (* MAXBLAST *)
            ausschrift_signatur('EZ-Drive / Micro House'(* MHLDR.BIN *));

          (* $31: *)
          (* der Sprung ist wahrscheinlich falsch, sollte auf $fa,.. zeigen *)
          if bytesuche_sekt_puffer_0(#$31#$c0#$8e#$d8#$8e#$c0#$fc#$b9#$00#$01#$be#$00#$7c#$bf) then
            ausschrift('mtools?',signatur);

          (* $33: *)

          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$c0#$8e#$d8#$8e#$d0#$bc#$00#$7c#$fc#$8b#$f4
            +#$bf#$00#$06#$b9#$00#$01#$f2#$a5#$ea#$67#$06#$00#$00#$8b#$d5) then
            (* FreeBSD 3.2 (DOS-Programm) *)
            ausschrift_signatur('Boot Installer; BOOTEASY / Serge Vakulenko [1.7]');

          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$c0#$8e#$d8#$fa#$8e#$d0#$bc#$00#$7c#$fb#$fc) then
            ausschrift_signatur('BOOTEASY [1.4] / Serge Vakulenko');


          if bytesuche_sekt_puffer_0(#$33#$c0#$fa#$8e#$d0#$bc#$fc#$7b#$fb#$bb#$78#$00#$36#$c5#$37#$1e#$56#$16) then
            ausschrift_signatur('FDBOOT / Yury Semenov'); (* 1.10 *)

          if bytesuche_sekt_puffer_0(#$33#$ed#$8e#$d5#$bc'??'#$be'??'#$8e#$c5) then
            ausschrift_signatur('System Commander / V-Communcations [4.0]');


          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$7c#$fc#$8b#$f4#$bf#$00#$06#$b9#$00#$01
              +#$f3#$a5#$ea'?'#$06#$00#$00'Canno') then
            (* PART237D.ZIP *)
            ausschrift_signatur('Ranish Partition Manager [2.37.11]');

          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$d0#$bc#$00#$7c#$8e#$d8#$a1#$13#$04) then
            ausschrift('Pingpong',virus);

          if bytesuche_sekt_puffer_0(#$33#$ff#$be#$00#$7c#$fa#$8b#$e6#$8e#$d7#$fb#$8e#$c7#$b8#$02#$02) then
            (* HAGEN SCHMIDT 08.12.1996 *)
            ausschrift('Junkie / DrWhite',virus);

          if bytesuche_sekt_puffer_0(#$33#$ff#$8e#$df#$c4#$16#$4c#$00#$89#$16) then
            ausschrift('Stoned.Anti-Exe',virus);

          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$d8#$fa#$8e#$d0#$b8#$00#$7c#$8b#$e0#$fb#$1e#$50#$a1) then
            ausschrift('Stoned.Michelangelo',virus);

          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$d0#$bc#$00#$7c#$fb#$50#$07#$50#$1f) then
            ausschrift_signatur('FDISK / MS'); (* Version $070a *)

          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$d8#$fa#$8e#$d0#$bc#$00#$7c#$fb#$b8#$00#$0a#$8e#$c0) then
            (* BOSS110.ZIP\LOADER.BIN *)
              ausschrift_signatur('Better Operating System Selector / Rink Springer [1.1]');

          if bytesuche_sekt_puffer_0(#$33#$c9#$8e#$d9#$bc#$00#$7c#$8e#$d1#$fc#$8b#$dc#$b8) then
            ausschrift('Zharinov',virus); (* AVPL *)

          (* $43: *)
          if bytesuche_sekt_puffer_0('CCSGus') then
            ausschrift_signatur('Gusdrive / Can Cetkin [2]');

          (* $4e: *)
          if bytesuche_sekt_puffer_0('NOVELL  '#$00) then
            ausschrift_signatur('VDISK Novell DOS 7');

          (* $50: *)
          if bytesuche_sekt_puffer_0(#$50#$53#$51#$52#$56#$57#$55#$54#$e8#$00#$00#$0e#$1e#$06#$16#$b8#$03#$00) then
            ausschrift_signatur('Speicherbildschirm / Veit Kannegieser 08/1997');

          (* $58 *)
          if bytesuche_sekt_puffer_0(#$58#$3d'?'#$01#$75'?'#$bb#$00#$b8#$8e#$c3#$b4#$fe) then
            ausschrift('Be Boot Loader [4.5]',signatur);

          (* $5b: *)
          if bytesuche_sekt_puffer_0(#$5b#$33#$c0#$8e#$d0#$bc#$00#$7c#$8e#$d8#$8e#$c0#$fb#$fc#$ff#$e3) then
            ausschrift_signatur('PhysTechSoft BootWizard');

          (* $5d: *)
          if bytesuche_sekt_puffer_0(#$5d#$33#$c0#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$7c#$55#$bd'??'#$fc#$fb#$c3) then
            ausschrift_signatur('Acronis OS Selector');

          (* $5e: *)
          if bytesuche_sekt_puffer_0(#$5e#$b8#$00#$0e#$2e#$0a#$04#$74#$fe#$bb) then
            ausschrift_signatur('Stacker / Stac Electronics');

          (* $66: *)
          if bytesuche_sekt_puffer_0(#$66#$50#$66#$53#$66#$51#$66#$52#$66#$56#$66#$57#$66#$55#$66#$54#$66
             +#$e8#$00#$00#$00#$00#$0e#$1e#$06#$16#$b8#$03#$00) then
            ausschrift_signatur('Speicherbildschirm / Veit Kannegieser 09/1997 [386]');

          if bytesuche_sekt_puffer_0(#$66#$ea#$53#$00#$00#$00#$c0#$07'reading boot'#$00#$fa#$31) then
            (* FLOPPY26.SEK *)
            (* Dateisystem UFS *)
            ausschrift_signatur('OpenBSD [2.6]');

          (* $8c: *)
          if bytesuche_sekt_puffer_0(#$8c#$c8#$8e#$d0#$bc#$ff#$7b#$fb#$8e#$d8) then
            ausschrift_signatur('PTS-DOS [nicht startbar]');

          if bytesuche_sekt_puffer_0(#$8c#$c8#$8e#$d8#$8e#$c0#$54#$55#$b8#$01#$13#$bb#$09) then
            ausschrift_signatur('Sample Format / Protected Cristmas [0.1]');

          (* $8e: *)
          if bytesuche_sekt_puffer_0(#$8e#$1e#$18#$7c#$a0#$12#$7c#$a2) then
            ausschrift_signatur('WWBMU / ToolMaker [1.3.0]');

          (* $a1: *)
          if bytesuche_sekt_puffer_0(#$a1#$13#$04#$2e#$a3#$34#$7d#$90#$90) then
            (* VEIT9608.TBU *)
            ausschrift_signatur('IDE-Enhancer-Lader * modifiziert von V.K. fÅr Chipsatz SIS471');

          (* $b1: *)
          if bytesuche_sekt_puffer_0(#$b1#$01#$b2#$80#$e9#$ff#$00'*BSL') then
            ausschrift_signatur('Beret'#39's System Loader / Thomas "Beret" Kawecki [1.11]');

          (* $b4: *)
          if bytesuche_sekt_puffer_0(#$b4#$02#$8a#$fd#$ba#$00#$19#$cd#$10) then
            ausschrift_signatur('CCP / McAfee [1.1]');

          (* $b8: *)
          if bytesuche_sekt_puffer_0(#$b8#$00#$90#$8e#$d0#$31#$e4#$80#$fa#$80#$73#$02#$b2#$80#$b8#$00#$70
            +#$2e#$80#$3e#$b2#$7d#$00#$75#$03#$05#$00#$10#$8e#$c0#$2e#$a0#$b3#$7d#$b9#$01#$00) then
            ausschrift_signatur('SyMon / Vladimir Dashevsky; Daniel Smelov');

          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$d8#$fa#$8e#$d0#$bc#$00#$00#$fb#$8a#$16#$11#$00
            +#$52#$52#$66#$33#$c0#$cd#$13#$5a#$b4#$08#$cd#$13#$88#$36) then
            ausschrift_signatur('SPFDisk / Shiuh-Pyng Ferng <LOADER>');

          if bytesuche_sekt_puffer_0(#$b8#$24#$00#$8e#$d8#$ff#$0e) then
            ausschrift('Stoned.Angelina',virus);

          if bytesuche_sekt_puffer_0(#$b8#$10#$02#$bb#$c0#$08#$8e#$c3#$33#$db) then
            ausschrift_signatur('Lader IDE-Enhancer / SPExports');

          if bytesuche_sekt_puffer_0(#$b8#$00#$00#$8e#$d0#$8e#$d8#$bb#$00#$7c) then
            ausschrift_signatur('Access II / Robert Ortner');

          if bytesuche_sekt_puffer_0(#$b8#$03#$00#$cd#$10#$50#$b8#$00#$00#$8e#$d8) then
            ausschrift_signatur('Speicherbildschirm / Veit Kannegieser');

          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$50#$1f#$b9#$8a#$01#$90) then
            ausschrift_signatur('Master Disk / Rosenthal Engineering [2.0]');

          (* $b9: *)
          if bytesuche_sekt_puffer_0(#$b9'??'#$49#$be'??'#$8c#$c8) then
            ausschrift_signatur('Locksmith / REM Software');

          (* $bb: *)
          if bytesuche_sekt_puffer_0(#$bb#$c0#$07#$fa#$8e#$d3#$bc#$7c#$02) then
            ausschrift_signatur('FIXBOOT / (Autor:???)');

          (* $cd: *)
          if bytesuche_sekt_puffer_0(#$cd#$19) then
            (* Memdisk alt ohne installierten Startsektor *)
            ausschrift_signatur('Int 19');

          (* $ea: *)
          if bytesuche_sekt_puffer_0('?'#$43#$00#$c0#$07#$fc#$0e#$1f#$33#$db#$8e#$d3#$bc#$00) then
            ausschrift_signatur('BOOTIT / TeraByte Unlimited [2.2]');

          if bytesuche_sekt_puffer_0((*#$ea*)'?'#$45#$7c#$00#$00#$31#$c0#$8e#$d8#$8e#$c0#$8e#$d0
            +#$bc#$00#$58#$8a#$16#$ad#$7d#$80#$fa#$80#$72#$05#$c6#$06) then
            ausschrift_signatur('Shag/OS Loader / Frank E. Barrus');

          (* $fa $0e: *)
          if bytesuche_sekt_puffer_0(#$fa#$0e#$1f#$a1#$4c#$00#$a3
               +#$d3#$7c#$a1#$4e#$00#$a3#$d5#$7c#$a0#$6e#$04#$a2#$bd#$7d) then
            ausschrift('Parity',virus);
          if bytesuche_sekt_puffer_0(#$fa#$0e#$1f#$a1#$4c#$00#$a3
               +#$d8#$7c#$a1#$4e#$00#$a3#$da#$7c#$a1#$24#$00#$a3#$ba#$7d) then
            ausschrift('Parity 3',virus);
          if bytesuche_sekt_puffer_0(#$fa#$0e#$1f#$be#$00#$7c#$8b#$fe#$e8'?'#$00) then
            ausschrift('Parity .E',virus);

          (* $fa $2b: *)
          if bytesuche_sekt_puffer_0(#$fa#$2b#$c0#$8e#$d0#$8e#$c0#$8e#$d8#$b8#$00#$7c) then
            (* MDISK / MCAFEE *)
            ausschrift_signatur('FDISK / MS-DOS 3.00,3.20,3.30,4.00,,]');
          if bytesuche_sekt_puffer_0(#$fa#$2b#$db#$8e#$db#$8e#$d3#$bc#$00#$7c#$ea#$2f) then
            ausschrift('Monkey',virus); (* AVPL *)

          (* $fa $31: *)
          if bytesuche_sekt_puffer_0(#$fa#$31#$c0#$8e#$d0#$bc#$00#$7c#$fb#$bb#$40#$00#$8e#$db#$a1#$13#$00) then
            ausschrift('Yale',virus);

          if bytesuche_sekt_puffer_0(#$fa#$31#$db#$8e#$d3#$8e#$db#$8e#$c3) then
            ausschrift_signatur('NVCLEAN / Norman Data Defense Systems [4 PART]');

          if bytesuche_sekt_puffer_0(#$fa#$31#$c0#$8e#$d0#$bc#$00#$7c#$fb#$8e#$d8#$be#$00#$7c#$8e#$c0
                   +#$bf#$00#$06#$b9#$00#$02
                   +#$fc#$f3) then
            (* BOOTNN-D.ZIP\BM-SETUP.EXE nach entfernen des BM *)
            ausschrift_signatur('BMDOS / IngenieurbÅro Hoyer [3.82] <1>');

          if bytesuche_sekt_puffer_0(#$fa#$31#$c0#$8e#$d0#$bc#$00#$7c#$fb#$06#$57#$8e#$d8#$be#$00#$7c
                   +#$8e#$c0
                   +#$bf#$00#$06#$b9#$00#$02) then
            (* BOOTMENU.ZIP\BMDOS.EXE nach entfernen des BM *)
            ausschrift_signatur('BMDOS / IngenieurbÅro Hoyer [4.31] <2>');

          if bytesuche_sekt_puffer_0(#$fa#$31#$c0#$8e#$d0#$bb#$00#$7c#$89#$dc#$fb#$8e#$d8#$89#$e6#$8e#$c0#$bf#$00#$06
                   +#$b9#$00#$02#$fc#$f3#$a4#$ea#$1f#$06#$00#$00#$a3#$04#$06) then
            ausschrift_signatur('BSDOS / IngenieurbÅro Hoyer [7.07] <BEBootstrapAsmCode>');

          if bytesuche_sekt_puffer_0(#$fa#$31#$c0#$8e#$d0#$bc#$00#$7c#$fb#$06#$57#$56#$8e#$d8#$be#$00#$7c#$8e#$c0#$bf#$00#$06
                   +#$b9#$00#$02#$fc#$f3#$a4#$5e#$5f#$07#$ea#$24#$06#$00#$00#$bd#$be#$07#$b9#$04#$00) then
            ausschrift_signatur('BSDOS / IngenieurbÅro Hoyer [7.07] <BSBootstrapAsmCode>');


          if bytesuche_sekt_puffer_0(#$fa#$31#$c0#$8e#$d0#$bc#$00#$7c#$89#$e6#$50#$07#$50#$1f#$fb
                   +#$fc#$52#$bf#$00#$06#$b9#$00#$01#$f2#$a5#$ea#$1e#$06#$00#$00#$bf#$05) then
            ausschrift_signatur('LegendOS Boot Manager / Serdar Ozler [0.92]');

          (* $fa $33: *)
          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$8e#$d8#$8e#$c0#$bc#$00#$7c#$8b#$f4#$bf#$00#$06#$fb#$b9#$00#$02
                   +#$fc#$f2#$a5#$ea'?'#$06#$00#$00#$a0#$17#$04#$80#$26#$17#$04#$7f#$24) then
            ausschrift_signatur('OSL2000 / Vijai K. Amarnath'); (* R3 *)

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$7c#$fb#$fc#$be#$00#$7c#$bf#$00#$06
                   +#$b9#$00#$01#$f3#$a5#$ea#$1e#$06#$00#$00
                   +#$b8#$01#$02#$b9#$11#$00#$ba#$80#$00#$bb#$00#$08#$cd#$13#$be#$b1#$06#$72#$39#$81#$3e#$fe#$09) then
            ausschrift_signatur('dual boot / Kai Uwe Rommel [4.3]');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$8e#$c0#$8e#$d8#$bc#$00#$7c#$8b#$f4#$fb#$fc#$bf#$00#$06#$b9#$00#$01#$f2#$a5#$b8#$1d#$06#$50#$c3
                   +#$50#$ba#$80#$00#$e8#$f3#$00#$b0#$90#$a2#$28#$07#$58#$b4#$02#$cd#$16#$24#$40) then
            ausschrift_signatur('EXTIPL: CAPS-FD / Takamiti Kimura');
          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$8e#$c0#$8e#$d8#$bc#$00#$7c#$8b#$f4#$fb#$fc#$bf#$00#$06#$b9#$00#$01#$f2#$a5#$b8#$1d#$06#$50#$c3
                   +#$50#$b4#$02#$cd#$16#$24#$40#$58#$75#$14#$b9#$04#$00#$bf#$be#$07#$b6#$30#$fe#$c6#$f6) then
            ausschrift_signatur('EXTIPL: CAPS-HD / Takamiti Kimura');
          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$8e#$c0#$8e#$d8#$bc#$00#$7c#$8b#$f4#$fb#$fc#$bf#$00#$06#$b9#$00#$01#$f2#$a5#$b8#$1d#$06#$50#$c3
                   +#$50#$ba#$80#$00#$e8#$f9#$00#$b0#$90#$a2#$2e#$07#$58#$f6#$06) then
            ausschrift_signatur('EXTIPL: EXTFDTST / Takamiti Kimura');
          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$8e#$c0#$8e#$d8#$bc#$00#$7c#$8b#$f4#$fb#$fc#$bf#$00#$06#$b9#$00#$01#$f2#$a5#$b8#$1d#$06#$50#$c3
                   +#$f6#$06#$17#$04#$03#$75#$1b#$f6#$06#$3f#$04#$0f#$75#$f2#$b9#$04#$00#$bf#$be#$07#$b6#$30#$fe#$c6) then
            ausschrift_signatur('EXTIPL: EXTIPL / Takamiti Kimura');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$50#$07#$50#$1f#$fb#$fc#$be#$00#$7c
                  +#$bf#$00#$06#$b9#00#$01#$f3#$a5#$bb#$00#$06#$81#$eb#$00#$01) then
            (* Kennwort md5? *)
            ausschrift_signatur('Boot-US / Dr. Ulrich Straub [2.04]');

          if bytesuche_sekt_puffer_0(#$fa#$33#$e4#$8e#$d4#$8e#$c4#$0e#$1f#$bf#$0f#$08) then
            ausschrift_signatur('VAMOS / Michael Tartsch [1.1.1]');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$fb#$8b#$f4#$8b#$dc) then
            ausschrift_signatur('FMT 1.00 / Oleg Kibirev');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$fb#$eb#$2c) then
            ausschrift('Quox',virus);

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8b#$f4#$50#$1f#$8c) then
            ausschrift_signatur('Suspicious / Stefan Kurzhals [1.40]');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$fb#$be#$00#$00#$b8) then
            ausschrift_signatur('Bootmanager OS/2');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8e#$d8#$8e#$c0#$fb#$fc#$bd) then
            ausschrift_signatur('Fixutils SafeMBR / Padgett Peterson');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$05#$c0#$07#$50#$07#$50#$1f) then
            ausschrift_signatur('GH-Login Pro / R. Herweg & S. Schumann [1.20]');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$ea'?'#$01#$c0#$07#$8c#$c8) then
            ausschrift_signatur('IDE-Enhancer / SPExports');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$b8#$b0#$07#$50#$1f#$be) then
            ausschrift_signatur('JAM'); (* viele Autoren *)

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$fb#$fc#$8e#$d8#$8e#$c0#$8b#$f4#$bf) then
            ausschrift_signatur('EZ-Drive / Micro House');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d8#$8b#$e0#$b8#$c0#$07#$8e#$d0#$fb#$a1#$4c#$00) then
            ausschrift('NoInt',virus); (* AVPL *)

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$f0#$1e#$16#$1f#$a1) then
            ausschrift('PRTSCR',virus);

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d8#$a2#$c4#$7d) then
            ausschrift('Aircop',virus);

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$40) then
            ausschrift_signatur('DocsBoot+ / Zac Schroff [0.33·]');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d8#$8e#$c0#$fb#$be#$00#$7c#$bf#$00#$60#$b9) then
            ausschrift_signatur('Unboot / Yanovsky [1.0]');

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$50#$17#$bc#$fe#$7b#$50#$1f#$fb#$a0#$12#$7c#$a2) then
            ausschrift_signatur('WWBMU / Wolfgang Wirth'); (* 1.6.0 *)

          if bytesuche_sekt_puffer_0(#$fa#$33#$db#$8e#$db#$8e#$d3#$bc#$00#$7c#$fb#$33#$ff) then
            ausschrift('Tequilla',virus); (* 15.09.1995 Keller Rechenzentrum *)

          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$fb#$eb#$31#$90'MasterB') then
            ausschrift_signatur('Fjfdisk / Fuitsu'); (* 3.0 *)


          (* $fa $66: *)
          if bytesuche_sekt_puffer_0(#$fa#$66#$be#$00#$7c#$00#$00#$33#$c0#$8e#$d0#$8b#$e6
               +#$fb#$50#$1f#$50#$07#$b5#$02#$bf) then
            ausschrift_signatur('MBR Killer / Ralph Roth [0.98.2]');

          (* $fa $8c: *)
          if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$7c#$fb
               +#$89#$16'??'#$06#$b8#$40#$00) then
            ausschrift_signatur('Solaris x86 / Sun Microsystems');

          if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$8e#$d0#$8e#$c0#$8b#$e0#$bb#$78) then
            ausschrift_signatur('ÊTOS Bootmanager / Ulf Beckmann');

          if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$8e#$d8#$8e#$d0#$bc#$00#$f0#$fb#$a1) then
            ausschrift('Joshi',virus);

          if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$7c#$fb
              +#$b9#$00#$01#$be#$00#$7c#$bf#$00#$06#$fc#$f3#$a5#$ea#$9c#$07) then
            (* normaler mbr *)
            ausschrift_signatur('BootManager++ / Ralph Kirschner [1.3 /bd]');

          if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$7c#$fb
              +#$e9'?'#$01#$0a'HDn:') then
            (* bm lader *)
            ausschrift_signatur('BootManager++ / Ralph Kirschner [1.3 /bi]');


          (* $fa $b8: *)
          if bytesuche_sekt_puffer_0(#$fa#$b8#$30#$00#$8e#$d0#$bc#$fc#$00#$fb#$0e#$1f#$be#$66) then
            ausschrift_signatur('DFP / Michael Tischer [PC-Intern/M&T]');

          if bytesuche_sekt_puffer_0(#$fa#$b8#$00#$10#$8e#$d0#$bc#$00#$b0#$b8#$00#$00#$8e#$d8#$8e#$c0#$fb#$be#$00#$7c
              +#$bf#$00#$06#$b9#$00#$02#$f3#$a4#$ea#$21#$06#$00#$00#$be#$be#$07) then
            ausschrift_signatur('? / Red Hat Linux [7.3]'); (* irgendein Installationprogramm, leere VPC-Platte *)

          (* $fa $eb: *)
          if bytesuche_sekt_puffer_0(#$fa#$eb#$01'?'#$8c#$c8#$8e#$d8#$8e#$c0) then
            ausschrift_signatur('BootMagic / Powerquest [2.0]');

          (* $fa $fa: *)
          if bytesuche_sekt_puffer_0(#$fa#$fa#$8c#$c8#$8e#$d8#$8e#$d0#$bc#$00#$f0#$fb#$b8) then
            ausschrift('Denzuk',virus);

          if bytesuche_sekt_puffer_0(#$fa#$fa#$fa#$bc#$00#$7c#$33#$c0#$8e#$d0#$66#$0f#$b7#$f4#$50#$1f#$50) then
            ausschrift_signatur('MBR Killer / Ralph Roth [0.98.6-1.2.2]');

          (* $fa $fc: *)
          if bytesuche_sekt_puffer_0(#$fa#$fc#$8c#$c8#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$7c#$fb#$52#$e8'??'
             +#$b8#$01#$13#$b9) then
            (* BOOTM010.ZIP *)
            ausschrift_signatur('Wolfpack Boot Manager / Adrian Horatiu Hilgardth [00.01.00]');

          if bytesuche_sekt_puffer_0(#$fa#$fc#$8c#$c8#$8e#$d8#$8e#$c0#$8e#$d0#$8e#$e8#$bb#$00#$7c
            +#$8b#$e3#$fb+#$0e#$53#$8a#$36#$75#$04) then (* sowohl Fesplatte als auch Diskette *)
            (* BOOTM020.ZIP *)
            ausschrift_signatur('Icepack Boot Manager / Adrian Horatiu Hilgardth [00.02.00]');

          (* $fc: *)
          if bytesuche_sekt_puffer_0(#$fc#$31#$c9#$8e#$c1#$8e#$d9#$8e#$d1#$bc#$00#$7c#$89#$e6#$bf#$00#$07) then
            ausschrift_signatur('BTX loader [1.00] -> FreeBSD/i386');

          if bytesuche_sekt_puffer_0(#$fc#$b8#$c0#$07#$8e#$d8#$b8#$e0#$07#$8e#$c0
            +#$33#$f6#$33#$ff#$b9#$00#$01#$f3#$a5#$b8#$19#$7e#$ff#$e0#$fa#$8c#$c0#$1e#$07) then
            ausschrift_signatur('SPFDisk / Shiuh-Pyng Ferng <PRE_LOAD>');

          if bytesuche_sekt_puffer_0(#$fc#$33#$c0#$8e#$d8#$8e#$c0#$be'??'#$bf#$00#$06#$b9#$00#$01#$f3#$a5#$ea#$06#$06#$00#$00'GAG') then
            (* GAG *)
            ausschrift_signatur('el Gestor de Arranque Grafico / Sergio Costas Rodriguez');









  writeln;

  abspeichern('sekt.dat');
end.

