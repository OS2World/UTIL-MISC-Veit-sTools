:userdoc.
:title.LB_M2E: pipe mixer driver for ESS Maestro 2e

.*-------------------------------------------------------------------
:h1.Program description

:p.
LB_M2E is a driver module for ESS Maestro 2E sound package and works with LbMix / Lesha Bogdanow.
.br
It uses only the AC 97 part and should work with other AC 97 sound cards from ESS.
:p.
This driver can change the volume from CD ROM even if digital audio transfer is used.

.*-------------------------------------------------------------------
:h1.Configuration

:ol.
:li.Start the driver configuration program of LbMix:
:link reftype=launch object='CMD.EXE' data='/K echo . && PMixCfg.CMD'. PMixCfg.CMD :elink..
:li.Select "ESS AC97".
:li.If you have a CD ROM driver that supports digital transfer you should give the drive letter.
.br
If you are unsure you can try it without (delete the letter).
:li.Select [Proceed] to test if LB_M2E does work with your hardware.
:eol.

.*-------------------------------------------------------------------
:h1.Parameters

:p.
If you prefer the command line usage or the other method does not work,
use M2E.EXE from command line.
.br
The syntax is [DETACH] M2E.EXE [options]
:p.
Options are:
:parml.
  :pt./P&colon.1 :pd.uses first (default) ESS audio device found.
  :pt./V :pd.verbose, display all input and output.
  :pt./Q :pd.quit running M2E driver.
  :pt./CD&colon.H :pd.use adjust volume on CD ROM drive with letter H.
  :pt./N&colon.\&bslash.PIPE\&bslash.MIXER :pd. configure control pipe name.
:eparml.
:p.
example: DETACH M2E.EXE /P&colon.$3100
.*-------------------------------------------------------------------
:h1.License
:p.
You may use M2E freely, at your own risk.
.*
.*-------------------------------------------------------------------
:h1.Source code
:p.
You can download the source code from my
:link reftype=launch object='netscape.exe' data='http://www-user.tu-cottbus.de/~kannegv/quelle/index.html'. source directory :elink..
.br
The program is written in Virtual Pascal 2.1 in about 1400 lines.
.br
It could be used to produce backends for similar chips.
.*
.*-------------------------------------------------------------------
:h1.History
:p.
:hp2.2001.04.21:ehp2.
:ul compact.
  :li.added detection for CD drive letter into PMixCfg control script
  :li.better tempfile name calculation
:eul.
:p.
.*
:hp2.2001.04.24:ehp2.
:ul compact.
  :li.adjusted STARTUPDIR in WarpIN file for M2E.INF
:eul.
:p.
.*
:hp2.2001.06.06:ehp2.
:ul compact.
  :li.previous version failed if data cd was used first
:eul.
:p.
.*
:hp2.2003.11.27:ehp2.
:ul compact.
  :li.added primitive DOS version (prompt)
  :li.obsoleted baseport parameter, get baseposrt from PCI config space
:eul.
:p.
.*
:hp2.2004.06.17..08.05:ehp2.
:ul compact.
  :li. PCI-search corrected, use pci_hw from pci049vkC
  :li. included adapted minimix
  :li. M2E.EXE loads startup commands M2E.LOA. The file is searched in EXE directory and %HOME%. Please adapt for your sound environment.
  :li. evalute mute field as hexadecimal
  :li. do not send length byte and terminating #0 over pipe
:eul.
.*
.*-------------------------------------------------------------------
:h1.Author
:p.
Veit.Kannegieser@gmx.de
.br
http&colon.//www-user.TU-Cottbus.DE/~kannegv
.*
.*-------------------------------------------------------------------
:euserdoc.
