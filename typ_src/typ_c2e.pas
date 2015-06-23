(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_c2e;

interface

procedure comtoexe_test;

implementation

uses
  (*$IfDef GTDATA*)
  typ_gt,
  (*$EndIf*)
  typ_ausg,
  typ_var,
  typ_spra,
  typ_type,
  typ_varx,
  typ_kopf;

procedure comtoexe_test;
  var
    code_para:longint;
  begin
    dec(herstellersuche);

    if  (exe_kopf.relokationspositionen=0)
    and (exe_kopf.ip_wert=$0100)
    and (exe_kopf.cs_wert=$FFF0)
    and (com2exe_test)
     then
       begin

         (*$IfDef GTDATA*)
         suche_gtdata_c2e(gt_c2e);
         (*$EndIf*)

         code_para:=DGT_zu_longint(MinDGT(DivDGT(einzel_laenge-longint(exe_kopf.kopfgroesse)*16+15,16),1024*1024 div 16));

         case exe_kopf.sp_wert of
           $0000: (* SP *)
             case exe_kopf.kopfgroesse of
               $0020:
                 begin
                   ausschrift(textz_umgewandelte_COM_Datei^+': SCRB2E (SCRNCH) / Graeme W. McRae',packer_exe);
                   com2exe_test:=falsch;
                 end;
             else (* unp m *)
               if exe_kopf.memmin=0 then
                 begin
                   ausschrift(textz_umgewandelte_COM_Datei^+': UNP / Ben Castricum',packer_exe);
                   com2exe_test:=falsch;
                 end
               else
                 if exe_kopf.memmin=einzel_laenge then
                   begin
                     ausschrift(textz_umgewandelte_COM_Datei^+': COM2EXE / PHaX [1.01]',packer_exe);
                     if kopftext='PHAX' then
                       kopftext_nullen;
                     com2exe_test:=falsch;
                   end

             end;
           $0200: (* SP *)
             case exe_kopf.kopfgroesse of
               $0020:
                 begin
                   ausschrift(textz_umgewandelte_COM_Datei^
                     +' (>64k): SCRB2E (SCRNCH) / Graeme W. McRae',packer_exe);
                   com2exe_test:=falsch;
                 end;
             end;
           $fffe: (* SP *)
             case exe_kopf.memmin of
               $0000: (* MIN *)
                 begin
                   if bytesuche(analysepuffer.d[$1c],'Ady''') then
                     begin
                       ausschrift(textz_umgewandelte_COM_Datei^+': Ady COM2EXE',packer_exe);
                       com2exe_test:=falsch;
                       kopftext_nullen;
                     end;
                   if bytesuche(analysepuffer.d[$1c],'    ') then
                     begin
                       ausschrift(textz_umgewandelte_COM_Datei^+': WWPACK',packer_exe);
                       com2exe_test:=falsch;
                     end;
                   if bytesuche(analysepuffer.d[$1c],#0#0#0#0) then
                     begin
                       ausschrift(textz_umgewandelte_COM_Datei^+': COM2EXE / Stefan Esser '
                        +'³ COM2EXE / Daniel Arndt',packer_exe);
                       com2exe_test:=falsch;
                     end;
                   if bytesuche(analysepuffer.d[$1c],#$00#$00#$92#$4b) then
                     begin
                       ausschrift(textz_umgewandelte_COM_Datei^+
                       ': COM2EXE / '#$92'narchistic KA0T',packer_exe);
                       com2exe_test:=falsch;
                       kopftext_nullen;
                     end;
                   if bytesuche(analysepuffer.d[$1c],'C2X') then
                     begin
                       ausschrift(textz_umgewandelte_COM_Datei^+
                       ': COM2EXE / Tom Torfs',packer_exe);
                       com2exe_test:=falsch;
                       kopftext_nullen;
                     end;
                 end;
               $0dd7: (* MIN *)
                 begin
                   ausschrift(textz_umgewandelte_COM_Datei^+
                   ': COM2EXE / Trills and Technologies',packer_exe);
                   com2exe_test:=falsch;
                   if kopftextlaenge=4 then
                     kopftext_nullen;
                 end;

               $0d8f:
                 begin
                   ausschrift(textz_umgewandelte_COM_Datei^+': HACKSTOP COM2EXE',packer_exe);
                   com2exe_test:=falsch;
                 end;

               $0fff:
                 begin (* KE.COM e ?.com *) (* Version 1.16 *)
                   ausschrift(textz_umgewandelte_COM_Datei^+': Kevin Executable file Kit / JauMing Tseng',packer_exe);
                   com2exe_test:=falsch;
                   if kopftext='JMTZ' then
                     kopftext_nullen;
                 end;

               $1000:
                 begin
                   (* in E-PROT 386 1.0 enthalten *)
                   ausschrift(textz_umgewandelte_COM_Datei^+': COM2EXE / MasterBall Systems',packer_exe);
                   com2exe_test:=falsch;
                 end;

             else (* MIN *)
               (* ausschrift(hex_longint(exe_kopf.memmin+code_para),signatur); *)

               if exe_kopf.memmin+code_para=$1000 then
                 begin
                   (* 64K min *)
                   if exe_kopf.memmax=$ffff then
                     begin
                       (* auch PCG305 *)
                       ausschrift(textz_umgewandelte_COM_Datei^+': LzExe COMTOEXE',packer_exe);
                       com2exe_test:=falsch;
                     end;
                 end;

             end;
         end;


         if com2exe_test then
           begin
             if not hersteller_gefunden then
               ausschrift(textz_umgewandelte_COM_Datei^+textz_unbekannter_Konverter^,signatur);
             com2exe_test:=falsch;
           end;
       end;

    inc(herstellersuche);

  end;

end.

