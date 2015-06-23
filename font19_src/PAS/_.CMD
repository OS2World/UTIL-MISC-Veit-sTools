@echo off
if not x%1x==xx goto %1


REM VMI
:vmi
call stampdef vmi.def
call pasvpo vmi ..\font19.vk\
if not x%1x==xx goto ende

REM DCP_X
:dcp_x
call stampdef dcp_x.def
call pasvpo dcp_x ..\font19.vk\
if not x%1x==xx goto ende

REM DCP_A
:dcp_a
call stampdef dcp_a.def
call pasvpo dcp_a ..\font19.vk\
if not x%1x==xx goto ende

REM DSPRESX
:dspresx
call stampdef dspresx.def
call pasvpo dspresx ..\font19.vk\
if not x%1x==xx goto ende

REM LISTFONT
:listfont
call stampdef listfont.def
call pasvpo listfont ..\font19.vk\
if not x%1x==xx goto ende

REM OS2FNT_X
:os2fnt_x
call stampdef os2fnt_x.def
call pasvpo os2fnt_x ..\font19.vk\ /L\unit\uniapi /U\unit\uniapi
if not x%1x==xx goto ende

REM SFONT
:sfont
call stampdef sfont.def
call pasvpo sfont ..\font19.vk\
if not x%1x==xx goto ende

REM PATCHDLL
:patchdll
call stampdef patchdll.def
call pasvpo patchdll ..\font19.vk\
if not x%1x==xx goto ende

REM P_VGA
:p_vga
call stampdef p_vga.def
call pasvpo p_vga ..\font19.vk\
if not x%1x==xx goto ende

REM P_SVGA
:p_svga
call stampdef p_svga.def
call pasvpo p_svga ..\font19.vk\
if not x%1x==xx goto ende

REM FONT19EN
:font19en
call stampdef font19en.def
call pasvpo font19en ..\font19.vk\
if not x%1x==xx goto ende

REM CRTC
:crtc
call stampdef crtc.def
call dual crtc ..\font19.vk\
if not x%1x==xx goto ende

REM SAVEVBIO
:savevbio
call stampdef savevbio.def
call dual savevbio ..\font19.vk\
if not x%1x==xx goto ende

REM LOADFONT
:loadfont
call stampdef loadfont.def
call dual loadfont ..\font19.vk\
if not x%1x==xx goto ende

REM SHOW_VPT
:show_vpt
call stampdef show_vpt.def
call dual show_vpt ..\font19.vk\
if not x%1x==xx goto ende

:ende
