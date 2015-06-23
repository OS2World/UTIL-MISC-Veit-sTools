@echo off
if not [%1]==[] goto l1

call stampdef phoedeco.def
call stampdef e_bcpvpd.def
call stampdef e_snipac.def

call pasvp phoe_def %tmp%\ @phoedeco.cfg
%tmp%\phoe_def.exe
del %tmp%\phoe_def.exe

call pasvpdsp phoedeco phoedeco.vk\exe\ @phoedeco.cfg
copy phoedeco.vk\exe\phoedeco.exe phoedeco.vk\exe\phoedeco.com
call pasvpdsp e_bcpvpd phoedeco.vk\exe\ @phoedeco.cfg
copy phoedeco.vk\exe\e_bcpvpd.exe phoedeco.vk\exe\e_bcpvpd.com
call pasvpdsp e_snipac phoedeco.vk\exe\ @phoedeco.cfg
copy phoedeco.vk\exe\e_snipac.exe phoedeco.vk\exe\e_snipac.com
call copywdx phoedeco.vk\exe\

call pasvpw phoedeco phoedeco.vk\exe\ @phoedeco.cfg
copy phoedeco.vk\exe\phoedeco.exe phoedeco.vk\exe\phoedecw.exe
call pasvpw e_bcpvpd phoedeco.vk\exe\ @phoedeco.cfg
copy phoedeco.vk\exe\e_bcpvpd.exe phoedeco.vk\exe\e_bcpvpw.exe
call pasvpw e_snipac phoedeco.vk\exe\ @phoedeco.cfg
copy phoedeco.vk\exe\e_snipac.exe phoedeco.vk\exe\e_snipaw.exe

call pasvpl phoedeco phoedeco.vk\exe\ @phoedeco.cfg
call upx phoedeco.vk\exe\phoedeco
call pasvpl e_bcpvpd phoedeco.vk\exe\ @phoedeco.cfg
call upx phoedeco.vk\exe\e_bcpvpd
call pasvpl e_snipac phoedeco.vk\exe\ @phoedeco.cfg
call upx phoedeco.vk\exe\e_snipac


:l1
call pasvp phoedeco phoedeco.vk\exe\ @phoedeco.cfg
call pasvp e_bcpvpd phoedeco.vk\exe\ @phoedeco.cfg
call pasvp e_snipac phoedeco.vk\exe\ @phoedeco.cfg
if not [%1]==[] goto ende

call ..\genvk PhoeDeco

cd phoedeco.vk
call genpgp
cd ..

:ende
