@echo off
xcopy ..\os2csm.vk\* m:\m\ /s /e
copy e:\config.sys m:\m\
copy e:\os2ldr.bin m:\m\
copy e:\os2ldr     m:\m\
