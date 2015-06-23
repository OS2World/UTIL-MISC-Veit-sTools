@echo off

call stampdef auto_pw.def
call pasvpo auto_pw ..\IOMZUNPR.VK\

call stampdef autostop.def
call pasvpo autostop ..\IOMZUNPR.VK\

call stampdef inquiry.def
call pasvpo inquiry ..\IOMZUNPR.VK\

call stampdef protect.def
call pasvpo protect ..\IOMZUNPR.VK\

call stampdef protstat.def
call pasvpo protstat ..\IOMZUNPR.VK\