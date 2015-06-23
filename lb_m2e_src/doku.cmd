@echo off
ipfc /L:ENG /C:850 /D:1 /inf doku.ipf >doku.log
list doku.log
del doku.log
rem view doku.inf
if exist lb_m2e.vk\m2e.inf del lb_m2e.vk\m2e.inf
move doku.inf lb_m2e.vk\m2e.inf