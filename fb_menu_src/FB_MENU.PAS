(*$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+*)
(*$M 16384,66000,66000*)
program reb_menu_installation;

uses dos,fb_m_spr;

const
  freier_platz=$dc80; (* F000:DC80 *)

type
  bios_32K=array[0..$7fff] of byte;
  menukode_anfang=
    record
      sig_word:word;
      jmp1:word;
      menu_code_laenge:word;
      org_reboot_ofs:word;
      org_word01:word;
      org_byte2:byte;
      xmm_handhabe:word;
      zusatz_lineare_adresse:longint;
      orgint15:pointer;
    end;

  ladekode_anfang=
    record
      laenge:word;
      rest:array[2..1023] of byte;
    end;

  menukode_anfang_zeiger=^menukode_anfang;
  ladekode_anfang_zeiger=^ladekode_anfang;

var
  datei:file;
  p:dirstr;
  n:namestr;
  e:extstr;
  itab_name,bios_name,uram_name:string;
  bios1,bios2:^bios_32K;

  lader_itab_uram:
    record
      itab:array[0..255] of pointer;
      lader:ladekode_anfang;
      uram:array[0..2047] of byte;
    end;


  ofs_:word;
  w1,w2,w3,w4,w5:word;

  menu_ziel:menukode_anfang_zeiger;

  para_zk:string;

  xmm:pointer;
  xmm_handhabe:word;

  xms_kopierer:
    record
      anzahl:longint;
      quell_handhabe:word;
      quell_ofs:longint;
      ziel_handhabe:word;
      ziel_ofs:longint;
    end;

procedure menu_kode_deu;external;
(*$L MENU_DEU.OBJ*)
procedure menu_kode_eng;external;
(*$L MENU_ENG.OBJ*)
procedure lade_kode_deu;external;
(*$L LADE_DEU.OBJ*)
procedure lade_kode_eng;external;
(*$L LADE_ENG.OBJ*)


procedure oeffne_datei(dateiname,kommentar:string);
  begin
    assign(datei,dateiname);
    (*$I-*)
    reset(datei,1);
    (*$I+*)
    if ioresult<>0 then
      begin
        writeln(textz_Fehler_beim_OEffnen_der_Datei^,dateiname);
        writeln('(',kommentar,')');
        halt(1);
      end;
  end;

function bestimme_xmm_handler:boolean;
  begin
    asm
      mov @result,false
      mov ax,$4300
      int $2f
      cmp al,$80
      jne @kein_xms

      mov ax,$4310
      int $2f
      mov word ptr xmm+0,bx
      mov word ptr xmm+2,es
      mov @result,true

      @kein_xms:
    end;
  end;


function xms_anfordern(kb:word):boolean;
  var
    lin_lo,lin_hi:word;
  begin
    asm
      mov lin_lo,0
      mov lin_hi,0
      mov @result,false

      mov ah,$09                  (* Anforderung         *)
      mov dx,kb                   (* Speichergr”áe in KB *)
      call dword ptr xmm

      cmp ax,$0001                (* 1=erfolgreich *)
      jne @nicht_genug_xms

      mov xmm_handhabe,dx

      mov ah,$0c                  (* LOCK                *)
      (* mov dx,dx                   Handhabe            *)
      call dword ptr xmm

      cmp ax,$0001                (* 1=erfolgreich *)
      jne @nicht_genug_xms

      mov lin_lo,bx                   (* DX:BX linear        *)
      mov lin_hi,dx
      mov @result,true

      @nicht_genug_xms:

    end;
    menu_ziel^.zusatz_lineare_adresse:=lin_hi*$10000+lin_lo;
  end;


procedure kopiere_ins_xms(quelle:pointer;nach,anzahl:word);
  begin
    xms_kopierer.anzahl         :=longint(anzahl)*1024;
    xms_kopierer.quell_handhabe :=0;
    xms_kopierer.quell_ofs      :=longint(quelle);
    xms_kopierer.ziel_handhabe  :=xmm_handhabe;
    xms_kopierer.ziel_ofs       :=longint(nach)*1024;
    asm
      mov ah,$0b
      mov si,offset xms_kopierer
      call dword ptr xmm
    end;
  end;

procedure xms_freigeben(xmm_handhabe:word);
  begin
    asm
      (* UNLOCK *)
      mov ah,$0d
      mov dx,xmm_handhabe
      call dword ptr xmm

      (* weggeben *)
      mov ah,$0a
      mov dx,xmm_handhabe
      call dword ptr xmm
    end;
  end;

function teste_ob_noch_schreibgeschuetzt(var w):boolean;
  var
    org,t1,t2:word;
    speicher:word absolute w;
  begin
    org:=speicher;
    speicher:=$0f;
    t1:=speicher;
    speicher:=$f0;
    t2:=speicher;
    speicher:=org;
    teste_ob_noch_schreibgeschuetzt:=(t1<>$0f) or (t2<>$f0);
  end;

begin
  writeln('FB_MENU * Veit Kannegieser * 11.07.úú04.08.1998');
  
  if not bestimme_xmm_handler then
    begin
      writeln(textz_XMS_2_erforderlich^);
      halt(1);
    end;

  (* suche Ziel ... *************************************************)
  ofs_:=$e05b;
  repeat
    (* relativer Sprung *)
    if mem[$f000:ofs_]=$e9 then
      begin
        ofs_:=ofs_+3+memw[$f000:ofs_+1];
        continue;
      end;

    (* kurzer relativer Sprung *)
    if mem[$f000:ofs_]=$eb then
      begin
        ofs_:=ofs_+2+shortint(mem[$f000:ofs_+1]);
        continue;
      end;

    break;

  until false;

  menu_ziel:=ptr($f000,freier_platz);

  if memw[$f000:ofs_]=$9090 then
    begin
      writeln(textz_REB_MENU_bereits_installiert^);
      if (ofs_<>freier_platz)
      or (lo(menu_ziel^.jmp1)<>$eb)
       then
        begin
          writeln(textz_installierte_Version_unbekannt^);
          halt(1);
        end;

      if teste_ob_noch_schreibgeschuetzt(menu_ziel^)
      or teste_ob_noch_schreibgeschuetzt(memw[$f000:menu_ziel^.org_reboot_ofs])
       then
        begin
          writeln(textz_Speicherbereich_ist_noch_schreibgeschuetzt^);
          halt(1);
        end;

      writeln(textz_Entferne_FB_MENU^);

      (* Aush„ngen *)
      memw[$f000:menu_ziel^.org_reboot_ofs+0]:=menu_ziel^.org_word01;
      mem [$f000:menu_ziel^.org_reboot_ofs+2]:=menu_ziel^.org_byte2;

      xms_freigeben(menu_ziel^.xmm_handhabe);

      fillchar(menu_ziel^,menu_ziel^.menu_code_laenge,0);
      halt(0);
    end;


  (* Test ob Platz frei ist *****************************************)
  menu_ziel:=ptr($f000,freier_platz);
  if (menu_ziel^.sig_word<>0)
  or (menu_ziel^.menu_code_laenge<>0)
   then
    begin
      writeln(textz_Speicherbereich_ist_schon_benutzt_inkompatibles_BIOS^);
      halt(1);
    end;


  (* Test ROM *******************************************************)

  if teste_ob_noch_schreibgeschuetzt(memw[$f000:ofs_])
  or teste_ob_noch_schreibgeschuetzt(menu_ziel^.sig_word)
   then
    begin
      writeln(textz_Speicherbereich_ist_noch_schreibgeschuetzt^);
      halt(1);
    end;


  (* Dateien laden **************************************************)
  new(bios1);
  new(bios2);

  fillchar(bios1^,sizeof(bios1^),$cc);
  fillchar(bios2^,sizeof(bios2^),$cc);
  fillchar(lader_itab_uram,sizeof(lader_itab_uram),$cc);


  filemode:=$40;
  fsplit(fexpand(paramstr(0)),p,n,e);
  if not (p[length(p)] in ['\','/']) then
    p:=p+'\';

  itab_name:=p+'ITAB.DAT';
  bios_name:=p+'BIOS.DAT';
  uram_name:=p+'URAM.DAT';

  for w1:=1 to paramcount do
    begin
      para_zk:=paramstr(w1);
      if para_zk[1] in ['/','-'] then
        delete(para_zk,1,1);

      if para_zk[2] in [':','='] then
        delete(para_zk,2,1);

      case upcase(para_zk[1]) of
        'I':itab_name:=copy(para_zk,2,255);
        'B':bios_name:=copy(para_zk,2,255);
        'U':uram_name:=copy(para_zk,2,255);
      else
        writeln(textz_unbekannter_Parameter^+para_zk+textz_Dokumentation_lesen^);
        halt(1);
      end;
    end;

  if textz_OBJ_SPRACHE^='D' then
    move(@lade_kode_deu^,lader_itab_uram.lader,ladekode_anfang_zeiger(@lade_kode_deu)^.laenge)
  else
    move(@lade_kode_eng^,lader_itab_uram.lader,ladekode_anfang_zeiger(@lade_kode_eng)^.laenge);

  lader_itab_uram.lader.laenge:=$9090; (* nop *)

  oeffne_datei(itab_name,textz_Kopie_der_Itab^);
  blockread(datei,lader_itab_uram.itab,sizeof(lader_itab_uram.itab));
  close(datei);

  oeffne_datei(bios_name,textz_Kopie_des_System_BIOS^);
  blockread(datei,bios1^,sizeof(bios1^));
  blockread(datei,bios2^,sizeof(bios2^));
  close(datei);

  oeffne_datei(uram_name,textz_URAM_Kode_zur_Restauration_des_oberen_Speicherbereiches^);
  blockread(datei,lader_itab_uram.uram,filesize(datei));
  close(datei);

  if textz_OBJ_SPRACHE^='D' then
    move(@menu_kode_deu^,menu_ziel^,menukode_anfang_zeiger(@menu_kode_deu)^.menu_code_laenge)
  else
    move(@menu_kode_eng^,menu_ziel^,menukode_anfang_zeiger(@menu_kode_eng)^.menu_code_laenge);


  (* XMS anfordern **************************************************)
  if not xms_anfordern(64+4+1) then
    begin
      writeln(textz_Fehler_bei_Anforderung_von_68K_Speicher_ueber_XMS_2^);
      halt(1);
    end;

  menu_ziel^.xmm_handhabe:=xmm_handhabe;
  menu_ziel^.org_reboot_ofs:=ofs_;
  menu_ziel^.org_word01:=memw[$f000:ofs_+0];
  menu_ziel^.org_byte2 :=mem [$f000:ofs_+2];
  menu_ziel^.orgint15  :=lader_itab_uram.itab[$15];

  (* Installation ***************************************************)

  mem [$f000:ofs_]:=$e9;
  memw[$f000:ofs_+1]:=ofs(menu_ziel^)-ofs_-3;


  kopiere_ins_xms(@lader_itab_uram,0     , 4);
  kopiere_ins_xms(bios1           ,0+4   ,32);
  kopiere_ins_xms(bios2           ,0+4+32,32);

  writeln(textz_installiert^);
end.
