@ECHO OFF
CALL A86COM SAUBER SAUBER.VK\
CALL ..\GENVK SAUBER
COPY SAUBER.VK\SAUBER.COM C:\SONST\SAUBER.COM
CALL TBS /MONO C:\SONST\SAUBER.COM
