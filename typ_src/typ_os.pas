(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

(* $Define ENDVERSION*)
unit typ_os;

interface

uses
  typ_type;

var
  os_2                  :boolean;
  taskmgr               :boolean;

procedure systemuntersuchung;
procedure multitask_start;
procedure titel_aendern(const ea:boolean);
procedure typ_os_init;
procedure selbsttest;
procedure zeit_weggeben;
{$IfNDef VirtualPascal}
function SysGetCodepage:word_norm;
{$EndIf VirtualPascal}

const
  titel_geaendert       :boolean=falsch;

implementation

uses

  (*$IfDef OS2 *)
  Os2Base,
  Os2Def,
  (*$EndIf*)
  (*$IfDef DPMI32*)
  dpmi32df,
  dpmi32,
  taskm,
  idle,
  (*$EndIf*)
  dos,
  typ_eiau,
  typ_var,
  typ_sekt,
  typ_ausg,
  typ_varx,
  typ_para,
  typ_spra;


(*$IfDef DOS*)
  (*$Define DOSMCB*)
(*$EndIf*)

(*$IfDef DPMI*)
  (*$Define DOSMCB*)
(*$EndIf*)

(*$IfDef DPMI32*)
  (*$Define DOSMCB*)
(*$EndIf*)

(*$IfDef OS2*)
function os2_memw(const linear:longint):word;
  var
    sp:puffertyp;
    q:quelle_typ;
  begin
    q:=quelle;
    speicher_lesen(linear shr 4,linear and $f,sp,2);
    quelle:=q;
    os2_memw:=word_z(@sp.d[0])^;
  end;
(*$EndIf OS2*)

(*$IfDef DOSMCB*)
function mcb_test(grenze:word):word;
  type
    mcbr=
      record
        xx              :word;
        verkettung      :char;
        psp_segment     :word;
        anzahl_para     :word;
        res_5           :array[5..7] of byte;
        name            :array[8-8+1..15-8+1] of char;
        daten           :array[0..$80] of byte;
      end;
  var
    mcbseg              :word;
    mcb_puffer          :puffertyp;
    mcb                 :mcbr absolute mcb_puffer;
    (*$IfDef DPMI*)
    regs                :real_mode_call_structure_typ;
    (*$EndIf*)
    (*$IfDef DPMI32*)
    regs                :real_mode_call_structure_typ;
    (*$EndIf*)
  begin
    (* Bestimmung erster MCB *)

    (*$IfDef DOS*)
    asm
      mov ah,$52
      int $21
      mov si,bx
      mov ax,es:[si-2]
      mov mcbseg,ax
    end;
    (*$EndIf*)

    (*$IfDef DPMI*)
    FillChar(regs,SizeOf(regs),0);
    regs.ah_:=$52;
    intr_realmode(regs,$21);
    mcbseg:=lies_speicher_wOrd(regs.es_,regs.bx_-2);
    (*mcbseg:=MemW[regs.es:regs.bx-2];*)
    (*$EndIf*)

    (*$IfDef DPMI32*)
    regs.ah_:=$52;
    intr_realmode(regs,$21);
    mcbseg:=MemW[dosseg_linear(regs.es_)+regs.bx_-2];
    (*$EndIf*)

    repeat
      if mcbseg>$f800 then
        break;

      speicher_lesen(mcbseg,0,mcb_puffer,512);

      if not (mcb.verkettung in ['M','Z']) then
        break;

      if bytesuche(mcb.daten[$4d],#$e8#$00#$00#$5b#$50) then
        ausschrift('Vacsina  '+textz_bei^+' '+hex_wOrd(mcbseg)+':$0000',virus);

      if mcbseg<grenze then
        if mcbseg+mcb.anzahl_para+1>grenze then
          mcb_test:=mcbseg+1
        else
          mcb_test:=mcbseg+mcb.anzahl_para+1;

      inc(mcbseg,mcb.anzahl_para+1);

    until false;
  end;

procedure resident_install_test;
  (*$IfDef DOS*)
  var
    _di                 :word;
  (*$EndIf*)
  (*$IfDef DPMI*)
  var
    r                   :real_mode_call_structure_typ;
  (*$EndIf*)
  (*$IfDef DPMI32*)
  var
    r                   :real_mode_call_structure_typ;
  (*$EndIf*)
  begin
    (*$IfNDef OS2*)

    (*$IfDef DOS*)
    asm (* selber getestet, I-LIST *)
      mov ah,$4B;
      mov si,0;
      mov di,0
      mov al,$FF;
      int $21
      mov _di,di
    end;
    (*$EndIf*)

    (*$IfDef DPMI*)
    FillChar(r,SizeOf(r),0);
    r.ah_:=$4b;
    r.si_:=0;
    r.di_:=0;
    r.al_:=$ff;
    intr_realmode(r,$21);
    (*$EndIf*)

    (*$IfDef DPMI32*)
    FillChar(r,SizeOf(r),0);
    r.ah_:=$4b;
    r.si_:=0;
    r.di_:=0;
    r.al_:=$ff;
    intr_realmode(r,$21);
    (*$EndIf*)

    (*$IfDef DOS*)
    if _di=$55AA then
    (*$EndIf*)

    (*$IfDef DPMI*)
    if r.di_=$55aa then
    (*$EndIf*)

    (*$IfDef DPMI32*)
    if r.di_=$55aa then
    (*$EndIf*)

      ausschrift('Cascade (170?) '+textz_hat_mir_im_Speicher_geantwortet^,virus);

    (*$EndIf -OS2*)
  end;
(*$EndIf*)

procedure systemuntersuchung;
  var
    xbda,
    hauptspeicher_seg,
    soll_speicher,
    dos_max,
    arbeits_seg         :smallword;
    festplatte,
    festplattenzahl     :byte;
    dos_beleger_bekannt :boolean;
    fund                :word_norm;
    zylinder,koepfe,
    sektoren            :word_norm;
    festplatten_name,
    lba_text            :string;
    speicher_puffer     :puffertyp;
    jetzt               :word_norm;

  procedure ide_enhancer;
    begin

      with speicher_puffer do
        begin

          if bytesuche(d[$e],'IDENHANCER VERSION') then
            begin
              ausschrift('IDE-Enhancer / SPExports',signatur);
              jetzt:=3*1024;
            end;

          if bytesuche(d[$08],'Tauscher') then
            begin
              ausschrift('VPART-Laufwerkstausch / Veit Kannegieser',signatur);
              jetzt:=word_z(@d[$03])^*16;
            end;

          if bytesuche(d[0],#$55#$aa'?'#$cb'MemDisk') then
            begin
              ausschrift('MEMBOOT.BIN / Veit Kannegieser',signatur);
              ausschrift(puffer_zu_zk_e(d[4],#$0d#$0a#$1a,128),beschreibung);
              jetzt:=d[$03]*512;
            end;

          if bytesuche(d[$06],'2M-') then
            begin
              ausschrift('2M-Superboot / Ciriaco Garcia de Celis',signatur);
              jetzt:=5*1024;
            end;

          if bytesuche(d[$5c],#$55#$8b#$ec#$83#$c5#$06) then
            begin
              ausschrift('CCP / McAfee [1.1]',signatur);
              jetzt:=2*1024;
            end;

          if bytesuche(d[3],#02'??'#$ff'?'#$f6) then
            begin
              (* OS/2 4.0 von Diskette gestartet *)
              ausschrift('Diskette Parameter Table (Int 1E)',signatur);
              jetzt:=1024;
            end;

        end; (* with *)
    end; (* ide_enhancer *)

  begin
    ausschrift_v(textz_Systemuntersuchung^);

    if (jahr<typ_jahr)
    or ((jahr=typ_jahr) and (monat<typ_mon))
    or ((jahr=typ_jahr) and (monat=typ_mon) and (tag<typ_tag))
    or (jahr>typ_jahr+50)
      then ausschrift(textz_ungueltiges_Systemdatum^+' ('+str_(jahr,4)+'.'+str_(monat,2)+'.'+str_(tag,2)+')',dat_fehler);

    (*$IfDef Linux*)
    ausschrift(textz_funktion_nicht_implementiert^,dat_fehler);
    Exit;
    (*$EndIf Linux*)

    (*$IfDef Win32*)
    ausschrift(textz_funktion_nicht_implementiert^,dat_fehler);
    Exit;
    (*$EndIf Win32*)

    (*$IfDef DOSMCB*)
    resident_install_test;
    (*$EndIf*)

    (* hauptspeicher_seg:="640" *)
    (*$IfDef OS2*)
    hauptspeicher_seg:=os2_memw($00000413) shl 6;
    (*$Else OS2*)
    asm
      int $12
      shl ax,6
      mov hauptspeicher_seg,ax
    end;
    (*$EndIf OS2*)

    (*$IfDef DOSMCB*)
    dos_max:=mcb_test(hauptspeicher_seg);
    (*$EndIf DOSMCB*)


    (* xbda:="639" *)
    (*$IfDef DOS_ODER_DPMI*)
    xbda:=MemW[Seg0040:$000E];
    (*$EndIf DOS*)
    (*$IfDef DPMI32*)
    xbda:=MemW[Seg0040+$000E];
    (*$EndIf DPMI32*)
    (*$IfDef OS2*)
    xbda:=os2_memw($0000040e);
    (*$EndIf OS2*)

    if xbda<>0 then
      ausschrift(textz_Erweiterter_Bios_Datenbereich_bei^+hex_wOrd(xbda)+':$0000',signatur);

    ausschrift(textz_Grundspeicher_bis^+hex_wOrd(hauptspeicher_seg)+':$0000 ('
     +str0(hauptspeicher_seg div 64)+')',signatur);

    soll_speicher:=$A000;
    if (xbda<$A000) and (xbda>$7000) then soll_speicher:=xbda;

    if hauptspeicher_seg<soll_speicher then
      begin
        ausschrift(textz_Dem_BIOS_wurden^+str0(longint(soll_speicher-hauptspeicher_seg) div 64)+textz_KB_gestohlen^,signatur);
        arbeits_seg:=hauptspeicher_seg;
        repeat
          ausschrift_v(textz_Speicherauszug_bei^+hex_wOrd(arbeits_seg)+':$0000]');
          speicher_lesen(arbeits_seg,0,speicher_puffer,512);
          codeoff_off:=0;
          codeoff_seg:=arbeits_seg;
          analyseoff:=0;
          einzel_laenge:=512;
          hersteller_gefunden:=falsch;
          herstellersuche:=1;
          jetzt:=512;
          ide_enhancer;
          if not hersteller_gefunden then start_sekt(speicher_puffer,wahr,255,falsch,0,0,0);
          if not hersteller_gefunden then ausschrift_nichts_gefunden(signatur);
          inc(arbeits_seg,jetzt div 16);
        until arbeits_seg>=soll_speicher;
      end;

    (*$IfDef DOSMCB*)
    if hauptspeicher_seg>dos_max{+1} then
      begin
        ausschrift(textz_Dem_DOS_wurden^+str0(hauptspeicher_seg-dos_max)+textz_Speichereinheiten_klammer^
        +str0((hauptspeicher_seg-dos_max) div (1024 div 16))+textz_KB_gestohlen^,signatur);
        speicher_lesen(dos_max,0,speicher_puffer,512);
        dos_beleger_bekannt:=falsch;

        if bytesuche(speicher_puffer.d[0],#$F4#$7A#$2C#$00) then
          begin
            ausschrift('Yankee  "Doodle" / TP [44]  '+textz_bei^+' '+hex_wOrd(dos_max)+':$0000',virus);
            dos_beleger_bekannt:=wahr;
          end;

        if bytesuche(speicher_puffer.d[$13],#$8b#$e5#$b8'?'#$30#$cd#$21#$e8) then
          begin
            ausschrift('WereWolf'+textz_bei^+' '+hex_wOrd(dos_max)+':$0000',virus);
            dos_beleger_bekannt:=wahr;
          end;

        if puffer_gefunden(speicher_puffer,'NACSBT ') then
          begin
            (* EXELISTE 1999.06.05 TCEC *)
            ausschrift('Guerilla.1996',virus);
            dos_beleger_bekannt:=wahr;
          end;

        fund:=puffer_pos_suche(speicher_puffer,#$81#$c6'??'#$33#$c0#$8e#$c0#$26#$8a#$0e#$6c#$04,500);
        if fund<>nicht_gefunden then
          begin
            case word_z(@speicher_puffer.d[fund+2])^ of
             $144:exezk:='[#3]';
             $149:exezk:='[#6]';
             $1f9:exezk:='[#9]';
            else
              exezk:='[#?,'+textz_unbekannt^+']';
            end;
            ausschrift('URUGUAY '+exezk+'  bei '+hex_wOrd(dos_max)+':$0000',virus);
            dos_beleger_bekannt:=wahr;
          end;

        if not dos_beleger_bekannt then
          ausschrift_nichts_gefunden(virus);

      end;
    (*$EndIf DOSMCB*)

    (*$IfDef DOS*)
    festplattenzahl:=4;
    (*$EndIf DOS*)

    (*$IfDef DPMI*)
    festplattenzahl:=4;
    (*$EndIf DPMI*)

    (*$IfDef DPMI32*)
    festplattenzahl:=4;
    (*$EndIf DPMI32*)

    (*$IfDef OS2*)
    festplattenzahl:=ermittle_partitionierbare_platten;
    (*$EndIf OS2*)


    for festplatte:=1 to festplattenzahl do
      begin
        physikalische_festplatten_parameter(festplatte+$80-1,zylinder,koepfe,sektoren,festplatten_name,lba_text);
        if zylinder=0 then
          exezk:=''
        else
          exezk:=' ['+str0(zylinder)+'/'+str0(koepfe)+'/'+str0(sektoren)+textz_os__zyl_koepfe_sekt^;

        (*$IfDef DOS*)
        ausschrift_v(textz_Partitionstabelle_von_Festplatte^+str0(festplatte-1)+']'+exezk);
        (*$EndIf DOS*)

        (*$IfDef DPMI*)
        ausschrift_v(textz_Partitionstabelle_von_Festplatte^+str0(festplatte-1)+']'+exezk);
        (*$EndIf DOS*)

        (*$IfDef DPMI32*)
        ausschrift_v(textz_Partitionstabelle_von_Festplatte^+str0(festplatte-1)+']'+exezk);
        (*$EndIf DPMI32*)

        (*$IfDef OS2*)
        ausschrift_v(textz_Partitionstabelle_der^+str0(festplatte)+textz_partitionierbaren_Platte^+exezk);
        (*$EndIf OS2*)

        if festplatten_name<>'' then
          ausschrift('"'+festplatten_name+'"',beschreibung);
        if lba_text<>'' then
          ausschrift(lba_text,beschreibung);

        sekt_bios_fehler:=bios_sektor_lesen(festplatte+$80-1,0,0,1,sektoren,koepfe,speicher_puffer);
        if sekt_bios_fehler=0 then
          begin
            hersteller_gefunden:=falsch;
            herstellersuche:=1;
            codeoff_seg:=0;
            codeoff_off:=0;
            analyseoff:=0;
            start_sekt(speicher_puffer,falsch,$80+festplatte-1,wahr,zylinder,sektoren,koepfe);
            if not hersteller_gefunden then ausschrift_nichts_gefunden(signatur);
          end
        else
          ausschrift(textz_nicht_vorhanden^,signatur);
      end;

  end;


procedure multitask_start;
  var
    orgpara             :string;
    (*$IfDef DOS*)
    fehler              :word;
    selbst_name_ofs     :word;
    task_para_block_ofs :word;
    selbst_name_seg     :word;
    task_para_block_seg :word;
    task_para_block     :record (* Novell Dos 7 Taskmgr *)
                           reserviert   :word;
                           befzeile,
                           fcb_1,
                           fcb_2        :pointer;
                         end;
    os2_para_block      :record
                           blocklaeng   :word;
                           w2           :word;
                           w4           :word;
                           w6           :word;
                           titel        :pointer;
                           prg          :pointer;
                           para         :pointer;
                           termq        :pointer;
                           umgebung     :pointer;
                           vererbung    :word;
                           sizungstyp   :word;
                         end;
    os2_para_block_ofs  :word;
    os2_para_block_seg  :word;
    (*$EndIf*)

    (*$IfDef VirtualPascal*)
    cmdline_1:pchar;
    (*$EndIf*)

  begin
    (*$IfDef DOS*)
    orgpara:=paramstr(1);
    for b1:=2 to paramcount do
      orgpara:=orgpara+' '+paramstr(b1);

    orgpara:=orgpara+' -!-';
    (*$EndIf*)

    (*$IfDef VirtualPascal*)
    cmdline_1:=CmdLine;
    while cmdline_1^<>#0 do
      inc(cmdline_1);
    inc(cmdline_1);
    orgpara:=puffer_zu_zk_e(cmdline_1^,#0,250)+' -!-';
    (*$EndIf*)


    (*$IfDef TERM_ROLLEN*)
    if term=term_rollen then
      orgpara:=orgpara+' -B'+terminal_para[term_farbig];
    (*$EndIf*)



    (*$IfDef DOS*)
    exezk:=paramstr(0)+#0;
    orgpara:=orgpara+#0;
    selbst_name_ofs:=ofs(exezk[1]);
    selbst_name_seg:=seg(exezk[1]);
    task_para_block_ofs:=ofs(task_para_block);
    task_para_block_seg:=seg(task_para_block);

    with task_para_block do
      begin
        reserviert:=0;
        befzeile:=ptr(seg(orgpara[0]),ofs(orgpara[0]));
        fcb_1:=nil;
        fcb_2:=nil
      end;

    with os2_para_block do
      begin
        blocklaeng:=$18+4+2+2;
        w2:=0;  (* unabhÑngig *)
        w4:=1;  (* Hintergrund *)
        w6:=0;  (* ? *)
        titel:=nil;
        prg:=@exezk[1];
        para:=@orgpara[1];
        termq:=nil;
        umgebung:=nil;
        vererbung:=0;
        sizungstyp:=4; (* DOS Vollbild *)
      end;
    os2_para_block_ofs:=Ofs(os2_para_block);
    os2_para_block_seg:=Seg(os2_para_block);

    fehler:=1; (* nicht installiert *)

    if os_2 then
      asm
        push ds
          mov ax,$6400
          mov bx,$0025
          mov si,os2_para_block_ofs
          push os2_para_block_seg
          pop ds
          mov cx,'cl'
          int $21
        pop ds
        mov fehler,3
      end
    else
      if taskmgr then
        asm
          push ds
            push es
              mov fehler,2 (* kein Prozess mehr *)

              mov ax,$2701 (* GET STATUS,INDEX *)
              int $2F

              cmp ax,cx  (* noch Platz fÅr einen Prozess? *)
              jz @task_start_ende

              mov fehler,3 (* gestartet *)

              mov ax,$2707 (* CREAT NEW TASK *)
              mov dx,selbst_name_ofs;
              mov bx,task_para_block_ofs;
              mov cx,10
              push selbst_name_seg
                push task_para_block_seg
                pop es
              pop ds
              int $2f

              @task_start_ende:

            pop es
          pop ds
        end;

    case fehler of
      1:abbruch(textz_OS2_oder_TaskMrg_nicht_installiert^,abbruch_Rechnerausruestung_passt_nicht);
      2:abbruch(textz_kein_Platz_fuehr_Prozess_mehr^,abbruch_Rechnerausruestung_passt_nicht);
      3:abbruch(textz_Programm_laeuft^,abbruch_kein_problem);
    end;
    (*$EndIf*)

    (*$IfDef OS2*)
    Exec(GetEnv('COMSPEC'),'/C START "Typ ['+textz_Hintergundsuche^+']" /N /B /PGM /FS "'+Paramstr(0)+'" '+orgpara);
    if ExitCode=0 then
      Abbruch(textz_Programm_laeuft^,abbruch_kein_problem)
    else
      Abbruch(textz_Fehler_beim_Anlegen_des_Hintergrundprozesses^,abbruch_Rechnerausruestung_passt_nicht);
    (*$EndIf*)

    (*$IfDef DPMI32*)
    ExecFlags:=efAsync;
    Exec(Paramstr(0),orgpara);

    if Dos.DosError=0 then
      Abbruch(textz_Programm_laeuft^,abbruch_kein_problem)
    else
      Abbruch(textz_OS2_oder_TaskMrg_nicht_installiert^,abbruch_Rechnerausruestung_passt_nicht);
    (*$EndIf*)
  end;

procedure titel_aendern(const ea:boolean);
  (*$IfDef DOS*)
  const
    task_name_setzen  :array[1..8+1] of char=' Typ  '+#0;
    task_name_loeschen:array[1..8+1] of char=#0#0#0#0#0#0#0#0+#0;
  var
    _of:word;
    os2_titel:string[80];
  (*$EndIf*)
  begin
    (*$IfDef DOS*)
    (* TaskMAX , TaskMgr *)
    if ea then
      _of:=ofs(task_name_setzen)
    else
      _of:=ofs(task_name_loeschen);

    if taskmgr then
      asm
        push ds

          mov ax,$2701
          int $2f

          (* BX= index *)

          (* index->ID *)
          mov ax,$270a
          mov dx,bx
          int $2f

          mov ax,$2709 (* Name vergeben *)
          mov si,_of
          (* DS=turbo DS *)
          int $2F

        pop ds
      end;

    if os_2 then
      asm
        mov ax,$6400 (* enable auto title switch *)
        mov bx,$0000
        mov cx,$636C
        mov dx,$0000
        int $21
        mov ax,$6400 (* session title *)
        mov bx,$0000
        mov cx,$636C
        mov dx,$0001
        push ds  (* DS=TURBO DS *)
        pop es
        mov di,_of
        int $21
      end;
    (*$EndIf*)

    (*$IfDef DPMI32*)
    if ea then
      begin
        if taskmgr then
          taskmgr_name_task(' Typ  ');
        if os_2 then
          os2_set_session_title(' Typ  ');
      end
    else
      begin
        if taskmgr then
          taskmgr_name_task(#0#0#0#0#0#0#0#0);
        if os_2 then
          os2_set_session_title('');
      end;
    (*$EndIf*)

    (*$IfDef DPMI*)
    (* nichts *)
    (*$EndIf*)

    (*$IfDef OS2*)
    (* nichts *)
    (*$EndIf*)

    titel_geaendert:=ea;
  end;

procedure typ_os_init;
  begin
    (*$IfDef DOS_ODER_DPMI*)
    asm
      mov os_2,false
      mov ax,$4010 (* ist OS/2 da? *)
      int $2f
      cmp ax,$4010
      je @weiter
      mov os_2,true
      @weiter:
    end;

    asm (* TASKMGR *)
      mov taskmgr,false
      mov ax,$2700 (* Installiert? *)
      int $2F
      cmp al,$ff
      jne @weiter
      mov taskmgr,true
      @weiter:
    end;
    (*$EndIf*)

    (*$IfDef OS2*)
    taskmgr:=falsch;
    os_2:=wahr;
    (*$EndIf*)

    (*$IfDef DPMI*)
    (*taskmgr:=falsch;
    os_2:=falsch;*)
    (*$EndIf*)

    (*$IfDef DPMI32*)
    taskmgr:=taskmgr_installed;
    os_2:=os2_running;
    (*$EndIf*)

  end;

procedure selbsttest;
  const
    xjoker=Chr(Ord('?') xor $ff);
  var
    selbsttest_puffer   :puffertyp;
  begin
    (*$IfDef ENDVERSION*)
    (*$IfDef DOS*)
    quelle.sorte:=q_datei;
    vergiss_cache;

    Assign(datei,ParamStr(0));
    datei_oeffnen;

    if fehler<>0 then
      begin
        ausschrift_v(textz_Selbsttest^);
        ausschrift_x(textz_Fehler_anfuerungszeichen^+fehlertext(fehler)+'"!',dat_fehler,vorne)
      end
    else
      begin
        datei_lesen(selbsttest_puffer,0,$44);
        exezk:=Chr(not($4D)) (* 00 SIGNATUR *)
              +Chr(not($5A))
              +xjoker
              +xjoker
              +xjoker
              +xjoker
              +Chr(not($00)) (* 06 RELOANZ *)
              +Chr(not($00))
              +Chr(not($04)) (* 08 KOPFLAENGE *)
              +Chr(not($00))
              +xjoker        (* 0a min heap *)
              +xjoker
              +xjoker        (* 0c max heap *)
              +xjoker
              +xjoker        (* 0e ss *)
              +xjoker
              +Chr(not($80)) (* 10 STACKPOINTER *)
              +Chr(not($00))
              +Chr(not($9d)) (* 12 DIET SIG *)
              +Chr(not($89))
              +Chr(not($00)) (* 14 IP *)
              +Chr(not($00))
              +Chr(not($00)) (* 16 CS *)
              +Chr(not($00))
              +Chr(not($1C)) (* 18 RELOOFF *)
              +Chr(not($00))
              +xjoker
              +xjoker
              +Chr(not(Ord(' '))) (* 1c *)
              +Chr(not(Ord('T'))) (* 1d *)
              +Chr(not(Ord('Y'))) (* 1e *)
              +Chr(not(Ord('P'))) (* 1f *)
              +Chr(not(Ord(' '))) (* 20 *)
              +Chr(not(Ord('*'))) (* 21 *)
              +Chr(not(Ord(' '))) (* 22 *)
              +Chr(not(Ord('V'))) (* 23 *)
              +Chr(not(Ord('.'))) (* 24 *)
              +Chr(not(Ord('K'))) (* 25 *)
              +Chr(not(Ord('.'))) (* 26 *)
              +Chr(not(Ord(' '))) (* 27 *)
              +Chr(not(Ord('*'))) (* 28 *)
              +Chr(not(Ord(' '))) (* 29 *)
              +xjoker
              +xjoker
              +xjoker
              +xjoker
              +Chr(not(Ord('.'))) (* 2e *)
              +xjoker
              +xjoker
              +Chr(not(Ord('.'))) (* 31 *)
              +xjoker
              +xjoker
              +Chr(not(Ord(' '))) (* 34 *)
              +Chr(not($1A))      (* 35 TYPE Ende *)
              +Chr(not($00))      (* 36 *)
              +xjoker             (* 37 *) (* SIEGEL *)
              +xjoker
              +xjoker
              +xjoker
              +Chr(not($00))      (* 3b *)
              +Chr(not($00))      (* 3c *)
              +Chr(not($00))      (* 3d *)
              +Chr(not($00))      (* 3e *)
              +Chr(not($00))      (* 3f *)
              +Chr(not($F9))      (* 40 DIET 1.45f *)
              +Chr(not($9C))      (* 41 *)
              +Chr(not($EB))      (* 42 *)
              +Chr(not($09));     (* 43 *)

        (*$IfDef DOS_OVERLAY*)
        with selbsttest_puffer do
          begin
            einzel_laenge:=longint(word_z(@d[2])^)+512*longint(word_z(@d[4])^);
            if word_z(@d[2])^>0 then Dec(einzel_laenge,512);
          end;
        (*$Else*)
        einzel_laenge:=dateilaenge;
        (*$EndIf*)
        Move(einzel_laenge,exezk[1+$37],SizeOf(einzel_laenge));

        Close(datei);

        for fehler:=1 to Length(exezk) do
          exezk[fehler]:=Chr(not(Ord(exezk[fehler])));

        if not bytesuche(selbsttest_puffer.d[0],exezk) then
          begin
            ausschrift_v(textz_Selbsttest^);
            ausschrift(textz_TYP_EXE_ist_veraendert_Selbsttest^,signatur);
            FSplit(ParamStr(0),pfad,name,erweiterung);
            dateiliste:=pfad+name+erweiterung+#0+dateiliste;
          end;
      end;
    (*$EndIf DOS*)
    (*$EndIf ENDVERSION*)
  end;


procedure zeit_weggeben;
  begin
    (*$IfDef OS2*)
    Exit;
    (*$EndIf OS2*)

    (*$IfDef DOS_ODER_DPMI*)
    asm
      int $28      (* fÅr TSR *)
      mov ax,$1680
      int $2f      (* fÅr Multitasker *)
    end;
    (*$EndIf DOS*)

    (*$IfDef DPMI32*)
    give_up_cpu_time;
    (*$EndIf DPMI32*)
  end;

{$IfNDef VirtualPascal}
function SysGetCodepage:word_norm;assembler;
  asm
    mov ax,$6601
    mov bx,437
    int $21
    mov ax,bx
  end;
{$EndIf VirtualPascal}


end.

