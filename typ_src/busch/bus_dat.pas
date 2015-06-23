{$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y-}
(*$IFNDEF VIRTUALPASCAL*)
{$M 16384,0,655360}
(*$ENDIF*)
(* $I TYP_COMP.PAS*)
program bus_dat;

uses
  crt,
  typ_type,
  buschbau;

function bytesuche_dat_puffer_0(const sig:string):boolean;
  var
    egal:byte;
  begin
    bytesuche_dat_puffer_0:=bytesuche(egal,sig);
  end;


  begin
    (*** _00 ***)

    if bytesuche_dat_puffer_0(#$00#$01#$00#$00'Standard Jet DB'#$00) then
      ausschrift('Access DB / Microsoft',bibliothek);

    (* EBDIC/CHCP 1047                                                C   O   P  *)
    if bytesuche_dat_puffer_0(#$00'?'#$00#$00#$00#$00#$00'?'#$b4#$40#$c3#$96#$97) then
      ausschrift('IBM BookManager',bibliothek); (* .BOO *)

    if bytesuche_dat_puffer_0(#$00#$00#$00#$00#$00#$00#$00#$00'(C) Copyright Jean-Bernard C') then
      ausschrift('GpfREXX ORC / Jean-Bernard CLERIN',compiler);

    if bytesuche_dat_puffer_0(#$00#$00#$02#$00'?'#$51) then
      ausschrift('Quattro Pro Worksheet / Borland',musik_bild);

    if bytesuche_dat_puffer_0(#$00#$00#$04#$00'DeScribe') then
      ausschrift('DeScribe / DeScribe Inc [5 OS/2]',musik_bild);

    if bytesuche_dat_puffer_0(#$00#$05#$e1#$03#$00#$00#$20#$e2) then
      (* WPS WORKS 2.0 *)
      ausschrift('Text DCA / IBM',musik_bild);

    if bytesuche_dat_puffer_0(#$00'NORTON Ver ') then
      ausschrift('Norton Backup',packer_dat);


    (*** _01 ***)

    if bytesuche_dat_puffer_0(#$01'fcp') then
      ausschrift('X11 portable compiled font',musik_bild);

    if bytesuche_dat_puffer_0(#$01#$00'???2'#$01#$00#$01#$00) then
      ausschrift('Index EABackup / David Thorn',signatur);

    if bytesuche_dat_puffer_0(#$01#$00'?'#$25'W1') then
      ausschrift('EABACKUP / David Thorn',packer_dat);

    if bytesuche_dat_puffer_0(#$01#$fe#$01#$00) then
      ausschrift('Text Works / MS [2.0]',musik_bild);

    (*** _05 ***)

    if bytesuche_dat_puffer_0(#$05'[LRM]') then
      ausschrift('Instalit Multilingual / ??? ø',bibliothek);

    (*** _06 ***)

    if bytesuche_dat_puffer_0(#6'062939') then
      ausschrift('PowerBatch / CSD [2.2]',compiler);

    (*** _08 ***)

    if bytesuche_dat_puffer_0(#8'062939') then
      ausschrift('PowerBatch / CSD [2.2]',compiler);

    if bytesuche_dat_puffer_0(#$08#$80#$30#$30#$43) then
      ausschrift('Quest for Glory 4 / Sierra',spielstand);

    (*** _0A ***)

    if bytesuche_dat_puffer_0(#$0a#$80#$30#$20) then
      ausschrift('Space Quest 6 / Sierra',spielstand);

    (*** _11 ***)

    if bytesuche_dat_puffer_0(#$11'Preface') then
      ausschrift('Escriba Word Processor',musik_bild); (* OS/2 , 0.96 *)

    (*** _1A ***)

    if bytesuche_dat_puffer_0(#$1a'$R$D$C$0') then
      ausschrift('IBM Secure Distribution Control System',signatur);

    (*** _1C ***)
    if bytesuche_dat_puffer_0(#$1c'(c) 19') then
      ausschrift('TXT2EXE / P.Fischer-Haaser [3.01,3.49]',compiler);

    (*** _1D ***)

    if bytesuche_dat_puffer_0(#$1D#$7d#$00#$00) then
      (* GEOWORKS 2.0 *)
      ausschrift('Wordstar 5+',musik_bild);

    (*** _21 ***)

    if bytesuche_dat_puffer_0(#$21#$15#$70#$07) then
      ausschrift('XACT / SciLab: chart file; Stylecheet',musik_bild); (* *.XGF;*.STL *)

    (*** _23 ***)

    if bytesuche_dat_puffer_0('# PETRI V') then
      ausschrift('Petri Netz Editor',signatur);

    (*** _2B ***)

    if bytesuche_dat_puffer_0('+//ISO 9070/A') then
      ausschrift('OpenDOC / APPLE',musik_bild);

    (*** _2E ***)

    if bytesuche_dat_puffer_0('.file') then
      ausschrift('DJGPP DEBUG INFO',compiler);

    if bytesuche_dat_puffer_0('.\\\ WRITER') then
      ausschrift('Star Writer / Star Division [Dos]',musik_bild);

    (*** _30 ***)
    if bytesuche_dat_puffer_0(#$30#$26#$b2#$75#$8e#$66#$cf#$11) then
      (* .ASF .WMA .WMV *)
      ausschrift('Windows Media file',musik_bild);

    (*** _31 ***)

    if bytesuche_dat_puffer_0(#$31#$be#$00#$00#$00#$ab) then
      ausschrift('Write,Word / MS',musik_bild);

    (*** _32 ***)

    if bytesuche_dat_puffer_0(#$32#$be#$00#$00#$00#$ab) then
      ausschrift('Write,Word / MS',musik_bild);

    (*** _33 ***)

    if bytesuche_dat_puffer_0('@P@P@P@P@P@P@P@P=-==DA=ND=LE=R!=-=XXXXXXXX='#$0d#$0a) then
      ausschrift('COM2TXT / Dandler Productions [1.0]',packer_exe);
    if bytesuche_dat_puffer_0('@P@P@P@P@P@P@P@P=-==DA=ND=LE=R!=-=XXXXXXXX=00') then
      ausschrift('COM2TXT / Dandler Productions [1.0 /n]',packer_exe);
    if bytesuche_dat_puffer_0('@P@P@P@P@P@P@P@P=-==DA=ND=LE=R!=-=XXXXXXXX=0'#$0a) then
      ausschrift('COM2TXT / Dandler Productions [1.0 /u]',packer_exe);

    if bytesuche_dat_puffer_0('3DC '#$7b) then
      ausschrift('Corel Dream 3D',musik_bild);


    (*** _3E ***)

    if bytesuche_dat_puffer_0('>'#$00#$00#$00#$05#$03#$dd) then
      ausschrift('Read / Bruce Guthrie',compiler);

    (*** _43 ***)

    if bytesuche_dat_puffer_0(#$43#$84#$7f#$3e) then
      (* MKPAT *)
      ausschrift('BinPatch / Kay Hayen [2.2]',packer_dat);

    if bytesuche_dat_puffer_0('COLONIZE'#0) then
      ausschrift('Colonisation / Microprose',spielstand);

    (*** _44 ***)

    if bytesuche_dat_puffer_0('Disk IMage VER') then
      ausschrift('DIM / Ray Arachelian',packer_dat);

    if bytesuche_dat_puffer_0('Data file generated by RCOM') then
      ausschrift('Readme Compiler / David Harris [2.1]',compiler);

    if bytesuche_dat_puffer_0('DSA VERSION'#0'???'#0'DESC') then
      ausschrift('Das Schwarze Auge 2 "Sternenschweif" / ATTIC Entertainment Software',spielstand);

    (*** _45 ***)

    if bytesuche_dat_puffer_0('EmbDataFileFormat') then
      ausschrift('Embellish / dadaware',musik_bild);

    if bytesuche_dat_puffer_0('EmbMaskFileFormat') then
      ausschrift('Embellish Mask / dadaware',musik_bild);

    (*** _46 ***)

    if bytesuche_dat_puffer_0('Farallon Replica (TM)   '#$00) then
      ausschrift('Replica / Farallon',musik_bild);

    (*** _47 ***)

    if bytesuche_dat_puffer_0('GPSCRIPT') then
      ausschrift('GuidProc Script / Alessandro Cantatore',musik_bild);

    (*** _48 ***)

    (*wegen typ_entp hier nicht mehr
    if bytesuche_dat_puffer_0('HMIMIDI') then
      ausschrift('MIDI / Human Machine Interface',musik_bild);*)

    if bytesuche_dat_puffer_0('HMIDIGI') then
      ausschrift('DIGI / Human Machine Interface',musik_bild);

    if bytesuche_dat_puffer_0('HCOM'#0) then
      ausschrift('Macintosh Sound Tools Format',musik_bild);

    (*** _49 ***)

    if bytesuche_dat_puffer_0('IrTs24') then
      ausschrift('Papyrus String Resource',bibliothek); (* resource993.dat *)

    if bytesuche_dat_puffer_0('Ix'#$1a#$01) then
      (* Bytecode *)
      (* IPB2OS2 *)
      ausschrift('Irie Pascal VM',compiler);

    if bytesuche_dat_puffer_0('IM'#$00) then
      ausschrift('DiskDupe / Micro System Design, Inc [4.0]',packer_dat);

    (*** _4A ***)

    if bytesuche_dat_puffer_0('JTM'#$03'???'#$00) then
      ausschrift('Multinote Database [bin:JTM] / John Martin Alfredsson',bibliothek);

    if bytesuche_dat_puffer_0('JTD100?'#$00) then
      ausschrift('Multinote Database [bin:JTD] / John Martin Alfredsson',bibliothek);

    if bytesuche_dat_puffer_0('Joy!peffpwpc') then
      (* IDA 3.8b: PEF  PEF=PowerPC Executable Format? *)
      ausschrift('PEF: MAC OS, Be OS',signatur);

    (*** _4C ***)

    if bytesuche_dat_puffer_0('LVLP') then
      ausschrift('Descent (1) Level',bibliothek);

    if bytesuche_dat_puffer_0('LM89') then (* CONVERT *)
      ausschrift('Yamaha TX-16W Wave-File',musik_bild);

    (*** _4D ***)

    if bytesuche_dat_puffer_0('MSTS') then
      ausschrift('Npack Symatec/Stac',packer_dat);

    if bytesuche_dat_puffer_0('MSQP') then
      (* 1.0 *)
      ausschrift('Quick / MS Pascal Unit',bibliothek);

    if bytesuche_dat_puffer_0('MSD Image Version 1 '#$1a) then
      ausschrift('DiskDupe / Micro System Design, Inc [5.0]',packer_dat);

    (*** _4E ***)

    if bytesuche_dat_puffer_0('NeoBook Document') then
      ausschrift('NeoBook Document File',beschreibung);

    if bytesuche_dat_puffer_0('NeoPaint Pal') then
      ausschrift('NeoPaint Palette',musik_bild);

    if bytesuche_dat_puffer_0(#$4E#$BD#$2C#$BC) then
      ausschrift('A-Train / Maxis',spielstand);

    if bytesuche_dat_puffer_0('OWS 0') then
      ausschrift('"Archiv" OWS',virus);

    (*** _4F ***)

    if bytesuche_dat_puffer_0('OS/2 API Trace Version ?.??') then
      ausschrift('OS/2 API Trace / Dave Blaschke',signatur);

    (*** _50 ***)

    (* *.flt wird als exe gewertet.. *)
    if bytesuche_dat_puffer_0('PMView Filter') then (* PMV 2000,.. *)
      ausschrift('PMView Filter matrix / Peter Nielsen',musik_bild);

    if bytesuche_dat_puffer_0('PMView Palette') then (* PMV 2000,.. *)
      ausschrift('PMView Palette table / Peter Nielsen',musik_bild);

    if bytesuche_dat_puffer_0('PMView SlideShow') then (* PMV 2000,.. *)
      ausschrift('PMView SlideShow script / Peter Nielsen',musik_bild);

    if bytesuche_dat_puffer_0('PAP1') then
      (* 7 demo *)
      ausschrift('Papyrus / R.O.M. logicware',musik_bild);

    if bytesuche_dat_puffer_0('PEP') then
      ausschrift('PEP / ???',signatur);

    (*** _52 ***)

    if bytesuche_dat_puffer_0('RAD by REALiTY!!'#$10) then
      ausschrift('Reality ADlib Player / Reality Productions',musik_bild);

    if bytesuche_dat_puffer_0('RDK POC ') then
      ausschrift('Ports of Call / RDK',spielstand);

    (*** _53 ***)

    if bytesuche_dat_puffer_0('STTNG_GAME'#$00'GNT') then
      ausschrift('Startreck The Next Generation - A Final Unity / Spectrum Holobytes',spielstand);

    if bytesuche_dat_puffer_0('SN/UD') then
      ausschrift('DiskMap / Novell Dos 7',bibliothek);

    if bytesuche_dat_puffer_0('SOUND SAMPLE DATA ') then
      ausschrift('Turtle Beach SampleVision',musik_bild);

    if bytesuche_dat_puffer_0('SWAS') then
      ausschrift('SWALLOW / Thomas Kurschel Segmentdefinition',dos_win_extender);

    if bytesuche_dat_puffer_0('SND ') then (* CONVERT *)
      ausschrift('SBStudio II Sound File',musik_bild);

    if bytesuche_dat_puffer_0('SY80') then (* CONVERT *)
      ausschrift('Yamaha SY-85/SY-99 Wave-File',musik_bild);

    (*** _54 ***)

    if bytesuche_dat_puffer_0('TPF0') then (* VP 2.1 *)
      ausschrift('Classes.PAS TFiler',compiler);

    if bytesuche_dat_puffer_0('TPOV') then
      (* LArc 3.33 *)
      ausschrift('Turbo Pascal Overlay [5.5]',overlay_);


    (*** _55 ***)

    if bytesuche_dat_puffer_0('UC2'#$1A) then
      ausschrift('UC2 / AIP',packer_dat);

    if bytesuche_dat_puffer_0('Ultima 8 SaveGame File.') then
      ausschrift('Ultima 8 / ORIGIN',spielstand);

    (*** _57 ***)

    if bytesuche_dat_puffer_0('WordPro'#$0d) then
      (* WARP 4 Application Sampler *)
      ausschrift('Lotus WordPro',musik_bild);

    (*** _5C ***)

    if bytesuche_dat_puffer_0('\\z'#$c5) then
      ausschrift('EMTCOPY / IBM',packer_dat);

    (*** _5F ***)

    if bytesuche_dat_puffer_0('__CBSZIPSTREAM__') then
      ausschrift('ZipStream / Carbon Based Software',packer_dat);

    (*** _60 ***)

    (*** _64 ***)

    if bytesuche_dat_puffer_0(#$64#$a3#$01) then
      ausschrift('Sound Tools IRCAM Soundfile',musik_bild);

    (*** _69 ***)

    if bytesuche_dat_puffer_0('idska32'^Z) then
      ausschrift('Inno Setup 32 bit / Jordan Russell',packer_dat);
    if bytesuche_dat_puffer_0('idska16'^Z) then
      ausschrift('Inno Setup 16 bit / Jordan Russell',packer_dat);

    (*** _6E ***)

    if bytesuche_dat_puffer_0('n-- 2ASCII v2') then
      ausschrift('2ASCII / Arminio Grgic-GrGa [2.0]',packer_dat);

    (*** _70 ***)

    if bytesuche_dat_puffer_0('p'#$00#$c8#$8f'1.000') then
      ausschrift('Robin / Sierra',spielstand);

    (*** _72 ***)

    if bytesuche_dat_puffer_0('rz'#$01#$00) then
      ausschrift('Powerbasic Overlay',overlay_);

    (***_74 ***)

    if bytesuche_dat_puffer_0(#$74#$51#$36#$73) then
      ausschrift('XACT / SciLab: table',musik_bild); (* *.XTF *)

    (*** _89 ***)

    if bytesuche_dat_puffer_0(#$89#$42#$57#$54#$0D#$0A#$1A#$0A) then
      ausschrift('bwtzip / Stephan T. Lavavej',packer_dat);

    (*** _8E ***)

    if bytesuche_dat_puffer_0(#$8e#$00#$b0#$a3'1.0') then
      ausschrift('Kings Quest 6 / Sierra',spielstand);

    (*** _96 ***)

    if bytesuche_dat_puffer_0(#$96#$19#$18#$04#$00) then
      ausschrift('NeoLite / Neoworx [1.0,2.0]',packer_exe);

    (*** _A9 ***)

    if bytesuche_dat_puffer_0(#$a9#$d1#$6a) then
      ausschrift('SEQ / Accent Software',musik_bild);

    (*** _AE ***)

    if bytesuche_dat_puffer_0(#$ae'FD??'#$af#$ae) then
      ausschrift('XyWrite / ? [3]',musik_bild);

    (*** _BE ***)

    if bytesuche_dat_puffer_0(#$BE#$BA#$02#$00) then
      ausschrift('Visual Basic Quelltextverwaltung',signatur);

    (*** _CE ***)

    if bytesuche_dat_puffer_0(#$ce#$ce#$f6#$00) then
      ausschrift('ClearLook / Sundial Systems',musik_bild);

    (*** _DA ***)

    if bytesuche_dat_puffer_0(#$da#$03) then
      ausschrift('Central Point Backup [9]',bibliothek);

    (*** _DB ***)

    if bytesuche_dat_puffer_0(#$db#$a5#$2d#$00) then
      ausschrift('Winword [2.0] / MS',signatur);

    (*** _DF ***)

    if bytesuche_dat_puffer_0(#$df#$9b#$57#$13) then
      (* Speicher -  5.0 OS/2 *)
      ausschrift('Virtual PC / Conectix PC',musik_bild);

    (*** _FC ***)

    if bytesuche_dat_puffer_0(#$fc#$7e#$00#$00#$04) then
      ausschrift('Die Siedler / Blue Byte',spielstand);

    (*** _FE ***)

    if bytesuche_dat_puffer_0(#$fe#$01#$07#$09) then
      ausschrift('mySQL',bibliothek);
    if bytesuche_dat_puffer_0(#$fe#$fe#$07#$01) then
      ausschrift('mySQL index',bibliothek);

    if bytesuche_dat_puffer_0(#$fe#$ef#$01) then
      ausschrift('Ghost / Symantec',packer_dat); (* "2000" *)

    (*** _FF ***)

    if bytesuche_dat_puffer_0(#$ff#$ba#$ff#$ba#$ff'???CQSAV') then
      (* Chris Link,... *)
      ausschrift('Crusade',spielstand);







    WriteLn;

    abspeichern('dat.dat');
  end.

