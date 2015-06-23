@echo off
cls

for %%d in (pci_ca.tpu pci_hw.tpu pirt.tpu redircon.tpu *.exe) do if exist %%d del %%d

echo * copy F000 BIOS
call stampdef save_bio.def
if exist ..\spciirq.vk\exe\save_bio.exe del ..\spciirq.vk\exe\save_bio.exe
call dual save_bio ..\spciirq.vk\exe\ /U\unit\tputils
if not exist ..\spciirq.vk\exe\save_bio.exe goto fehler


echo * extract PIRT
call stampdef extr_pir.def
if exist ..\spciirq.vk\exe\extr_pir.exe del ..\spciirq.vk\exe\extr_pir.exe
call dual extr_pir ..\spciirq.vk\exe\ /U\unit\tputils
if not exist ..\spciirq.vk\exe\extr_pir.exe goto fehler

echo * show rounting links
call stampdef show_lnk.def
if exist ..\spciirq.vk\exe\show_lnk.exe del ..\spciirq.vk\exe\show_lnk.exe
call dual show_lnk ..\spciirq.vk\exe\ /U\unit\tputils
if not exist ..\spciirq.vk\exe\show_lnk.exe goto fehler

echo * show routing table
call stampdef show_pir.def
if exist ..\spciirq.vk\exe\show_pir.exe del ..\spciirq.vk\exe\show_pir.exe
call dual show_pir ..\spciirq.vk\exe\ /U\unit\tputils
if not exist ..\spciirq.vk\exe\show_pir.exe goto fehler

goto ende

:fehler
echo %0: Fehler
pause
:ende
