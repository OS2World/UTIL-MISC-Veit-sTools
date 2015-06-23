(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

(* $Define DEBUG*)

(*$IfDef ENDVERSION*)
  (*$UnDef DEBUG*)
(*$EndIf*)

unit typ_xexe;

interface

uses
  typ_type;

procedure pmwlite(var p:puffertyp;var pmwlite_laenge:dateigroessetyp);
procedure x_exe_untersuchung;
procedure coff(const coff_basis,coff_ofs:dateigroessetyp;var coff_ende:dateigroessetyp);
procedure pruefe_coff(const p:puffertyp;const intel_richtung:boolean);
procedure x_exe_stub_fehler;
procedure beos_information;
procedure elf_386(const p:puffertyp);
function coff_prozessor(const n:word_norm):string;

implementation

uses
  (*$IfDef ERWEITERUNGSDATEI*)
  typ_erw,
  (*$EndIf*)
  (*$IfDef GTDATA*)
  typ_gt,
  (*$EndIf*)
  typ_eiau,
  typ_dat,
  typ_ausg,
  typ_varx,
  typ_ende,
  typ_dien,
  typ_die2,
  typ_die3,
  typ_spra,
  typ_var,
  typ_for0,
  typ_for1,
  typ_for2,
  typ_for3,
  typ_for4,
  typ_for5,
  typ_spei,
  typ_posm,
  typ_zeic,
  typ_entp;



procedure untersuche_debuginfo(const o,l:dateigroessetyp);
  var
    deb_puffer:puffertyp;
  begin
    datei_lesen(deb_puffer,o,512);

    with deb_puffer do
      begin

        if bytesuche(d[0],#$db#$24) then
          begin
            ausschrift_x('runtime REXX interpreter / Dennis Bareis',compiler,leer);
            ausschrift_x('["SET '+dateiname+'=0x'
              +Copy(hex_longint(longint_z(@d[$18])^ xor $7469523c),2,8)
              +'"]',packer_dat,leer);
            (* >= $f0000000 klappt nur im gepatchten Modul .. *)
            befehl_rexx2exe(dateiname,longint_z(@d[$18])^ xor $7469523c)
          end

        (* PATCHLDR.EXE *)
        else if  bytesuche(d[0],'NB')
             and (d[2] in [Ord('0'), Ord('1')])
             and (d[3] in [Ord('0')..Ord('9')])
         then
          codeview(deb_puffer,0,leer)

        (* DELP2MSG.EXE *)
        else if  bytesuche(d[0],'FB')
             and (d[2] in [Ord('0'), Ord('1')])
             and (d[3] in [Ord('0')..Ord('9')])
         then
          ausschrift_x('Borland Debug Info',compiler,leer)

        (* fwresmg.exe (Open Watcom) *)
        else if bytesuche(d[0],#$7f'ELF') then
          ausschrift_x('ELF',compiler,leer)

        else
          ausschrift_x(textz_unbekannt^,signatur,leer);

      end;
  end;


procedure pmwlite(var p:puffertyp;var pmwlite_laenge:dateigroessetyp);
  var
    zaehler,obj:longint;
  begin
    ausschrift('PMWLITE / Charles Scheffold + Thomas Pytel'+version100(100+p.d[5]),packer_exe);

    obj:=longint_z(@p.d[$1c])^;
    if (obj>0) and (obj<15) then
      begin
        pmwlite_laenge:=longint_z(@p.d[$24])^;
        for zaehler:=1 to obj do
          IncDGT(pmwlite_laenge,longint_z(@p.d[$2c-$18+zaehler*$18])^);
      end;

    (*$IfNDef ENDVERSION*)
    if not (p.d[$1c] in [1,2,3]) then
      ausschrift('PMW <> 1,2,3!',dat_fehler);
    (*$EndIf*)
  end;

procedure adam_dos32(var p:puffertyp;var adam_dos32_laenge:dateigroessetyp);
  var
    kopflaenge          :longint;
    startpos            :longint;
    flags               :longint;
    dos32_puffer        :puffertyp;
  begin

    if word_z(@p.d[4])^<$350 then
      begin
        kopflaenge:=longint_z(@p.d[$c])^;

        if $18<kopflaenge then
          startpos:=kopflaenge+longint_z(@p.d[$18])^
        else
          startpos:=kopflaenge;

        adam_dos32_laenge:=longint_z(@p.d[$08])^;

        if $28<kopflaenge then
          IncDGT(adam_dos32_laenge,longint_z(@p.d[$28])^);

        if $24<kopflaenge then
          flags:=longint_z(@p.d[$24])^
        else
          flags:=0;
      end
    else
      begin
        kopflaenge:=longint_z(@p.d[$10])^;

        if $18<kopflaenge then
          startpos:=kopflaenge+longint_z(@p.d[$14])^
        else
          startpos:=kopflaenge;

        if $24<kopflaenge then
          flags:=longint_z(@p.d[$24+2])^
        else
          flags:=0;

        adam_dos32_laenge:=longint_z(@p.d[$c])^;
      end;


    if (flags and 1)=0 then
      exezk:=''
    else
      exezk:=' [pack]';

    ausschrift(textz_Programm_fuer^+'DOS32 / Adam Seychell '
     +str0(p.d[5])+'.'+str0(p.d[4] div 16)+str0(p.d[4] mod 16)+exezk,dos_win_extender);

    if (flags and 1)=0 then
      begin
        datei_lesen(dos32_puffer,analyseoff+startpos,512);

        if bytesuche(dos32_puffer.d[0],#$57#$8d#$b7'????'#$8d#$bf'????'#$b9'????'#$fd#$f3#$a4#$fc#$8d) then
          ausschrift_upx_version(dos32_puffer,dos32_puffer,$27,50,255,'tmt/adam');

        if bytesuche(dos32_puffer.d[0],#$bf'????'#$57#$8d#$b7'????'#$8d#$bf'????'#$b9'????'#$fd#$f3#$a4) then
          ausschrift_upx_version(dos32_puffer,dos32_puffer,$29,120,255,'tmt/adam');

        if dos32_puffer.d[0]=$e8 then
          begin
            Inc(startpos,5+longint_z(@dos32_puffer.d[1])^);
            datei_lesen(dos32_puffer,analyseoff+startpos,512);

            if bytesuche(dos32_puffer.d[0],#$55#$8d#$6c#$24#$fc#$c8'?'#$00#$00#$53) then
              ausschrift('TMT Pascal / TMT Development Corporation [2.11]',compiler);
          end;


      end;
  end;

procedure x_exe_untersuchung;
  var
    cs_ofs,ds_ofs       :longint;
    api_info            :longint;
    xx_sig              :string[2];
    namenpuffer         :puffertyp;
    anzahl_object_map_table:longint;
    rle_kompression,
    lzw_kompression     :boolean;
    zaehler             :longint;
    lx_ende_nonres_name :longint;
    l0,l1               :longint;
    f2                  :dateigroessetyp;
    res_typ_id          :word_norm;
    schon_angezeigt     :boolean;
    nexepuffer          :puffertyp;
    ne_relokationen     :boolean;
    file_aligment       :longint;
    resource_alignment  :longint;
    anzahl_resource_dieses_types:longint;
    resource_summe      :dateigroessetyp;
    resource_position   :dateigroessetyp;
    x_exe_ende          :dateigroessetyp; (* beinhaltet nicht analyseoff/x_exe_basis aber x_exe_ofs *)

    oploader_copyr      :longint;
    selbstlader         :boolean;

    hersteller_gefunden_sicherung:boolean;
    hersteller_suche_sicherung:word_norm;

    vxd_laenge          :longint;

    xexe_codepuffer,
    ds_puffer           :puffertyp;

    n_exe_kopf:         (* NE *)
      record
        xx              :word;
        exe_sig         :array[0..1] of byte; (* $00 *)
        linker_version  :array[0..1] of byte; (* $02 *)
        ofs_to_entry_table:word;          (* $04 *)
        length_of_entry_table:word;       (* $06 *)
        file_load_crc   :longint;         (* $08 *)
        program_flags   :byte;            (* $0c *)
        application_flags:byte;           (* $0d *)
        auto_data_segment_index:word;     (* $0e *)
        initial_local_heap_size:word;     (* $10 *)
        initial_stack_size:word;          (* $12 *)
        ip              :word;            (* $14 *)
        cs              :word;            (* $16 *)
        sp              :word;
        ss              :word;
        segment_count   :word;            (* $1c *)
        module_reference_count:word;      (* $1e *)
        length_nonresident_name_table:word;
        segtab_ofs      :word;            (* $22 *)
        resource_table_offset:word;       (* $24 *)
        resident_name_table_offset:word;  (* $26 *)
        x3              :array[$28..$2B] of byte;
        non_resident_name_offset:longint;
        x4              :word;            (* $30 *)
        file_alignment_size_shift_count:word;
        resource_table_entries:word;
        target_os       :byte;            (* $36 *)
        flags_other     :byte;            (* $37 *)
        x38             :word;
        x3a             :word;
        x3c             :word;
        excpectedwindowsversion:array[0..1] of byte; (* $3e *)
      end absolute nexepuffer;

    l_exe_kopf:
      record
        xx              :word;
        signatur        :array[0..1] of char;
        byte_order      :byte;
        word_order      :byte;
        executable_format_level:longint;
        cpu_type        :word;
        target_operating_system:word;
        module_version  :longint;
        module_type     :longint;
        number_of_memory_pages:longint;
        cs_obj          :longint;
        ip              :longint;
        esp_obj_nummer  :longint;
        esp             :longint;
        page_size       :longint;
        page_shift_count:longint;
        x30_3f          :array[$30..$3f] of byte;
        offset_of_object_table:longint;
        object_table_entrys:longint;
        object_page_map_table_offset:longint;
        object_iterate_data_map_offset:longint;
        resource_table_offset:longint;
        resource_table_entries:longint;
        resident_name_offset:longint;
        entry_table_offset:longint;
        module_directives_table_offset:longint;
        module_directives_entries:longint;
        fixup_page_table_offset:longint;
        fixup_record_table_offset:longint;
        imported_modules_name_table_offset:longint;
        imported_modules_count:longint;
        imported_procedures_name_table_offset:longint;
        per_page_checksum_table_offset:longint;
        data_pages_offset:longint;
        preload_page_count:longint;
        non_resident_name_offset:longint;
        non_resident_name_length:longint;
        non_resident_name_checksum:longint;
        automatic_ds_obj:longint;
        debug_info_ofs  :longint; (* relativ *)
        debug_info_laenge:longint;
        preload_instance_pages_number:longint;
        demand_instance_pages_number:longint;
        extra_heap_allocation:longint;
        reserved_ac_12  :array[$ac..$b7] of byte;
        offset_versioninfo_vxd:longint;
      end absolute nexepuffer;

    p_exe_kopf:
      record
        xx              :word;
        x1              :array[0..$d3-$80] of byte;
        kopflaenge      :longint;
      end absolute nexepuffer;

    icon1_zaehler        :byte;
    font1_zaehler        :byte;

  label
    untersuche_ne_code_fertig;


  procedure x_exe_fuellnullen(const seitengroesse:longint);
    var
      zaehler           :integer_norm;
      rest_puffer       :puffertyp;
      test              :integer_norm;
      test1,testu,testp :integer_norm;
    begin
      if (x_exe_basis+x_exe_ende>=dateilaenge)
      or (ModDGT(x_exe_ende,seitengroesse)=0) then
        Exit;

      test:=DGT_zu_longint(seitengroesse-(ModDGT(x_exe_ende,seitengroesse)));
      if x_exe_basis+x_exe_ende+test>dateilaenge then
        test:=DGT_zu_longint(dateilaenge-(x_exe_basis+x_exe_ende));

      testu:=test;
      testp:=0; (* test position *)
      repeat
        if testu>512 then
          test1:=512
        else
          test1:=testu;
        datei_lesen(rest_puffer,x_exe_basis+x_exe_ende+testp,test1);
        for zaehler:=1 to test1 do
          if rest_puffer.d[zaehler-1]<>0 then exit;
        Dec(testu,test1);
        Inc(testp,test1);
      until testu=0;

      IncDGT(x_exe_ende,test);
    end;

  function linker:string;
    begin
      with n_exe_kopf do
        linker:=textz_Linker_doppelpunkt^+str0(linker_version[0])+'.'+str_(linker_version[1],2)+']';
    end;

  procedure lade_ne(var puffer:puffertyp;obj,offs:longint);
    var
      o                 :longint;
      flags             :word_norm;
      anzahl,
      laenge,
      jetzt,
      lesen,
      schreiben,
      lesegrenze,
      schreibgrenze     :longint;
    begin
      if obj=0 then
        obj:=n_exe_kopf.segment_count;

      flags:=x_word__datei_lesen(x_exe_basis+x_exe_ofs+n_exe_kopf.segtab_ofs+(obj-1)*8+4);

      o:=longint(x_word__datei_lesen(x_exe_basis+x_exe_ofs+n_exe_kopf.segtab_ofs+(obj-1)*8))
                shl n_exe_kopf.file_alignment_size_shift_count;

      (* Dekompression hat zum Beispiel bei Shrinker keinen Sinn *)
      (* (anderes Packverfahren, wahrscheinlich ist das bit unverÑndert geblieben) *)

      if (flags and $8)=0 then
        begin
          datei_lesen(puffer,x_exe_basis+o+offs,512);
          Exit;
        end;

      (* /EXEPACK *)

      if offs+512>groesse_allgemeiner_zwischenspeicher then
        with puffer do (* nicht genug Platz ... *)
          begin
            g:=SizeOf(d);
            FillChar(d,SizeOf(d),$cc);
            Exit;
          end;

      FillChar(allgemeiner_zwischenspeicher^,SizeOf(allgemeiner_zwischenspeicher^),0);

      lesen:=0;
      schreiben:=0;
      lesegrenze:=x_word__datei_lesen(x_exe_basis+x_exe_ofs+n_exe_kopf.segtab_ofs+(obj-1)*8+2); (* Image *)
      schreibgrenze:=Min(groesse_allgemeiner_zwischenspeicher,
         x_word__datei_lesen(x_exe_basis+x_exe_ofs+n_exe_kopf.segtab_ofs+(obj-1)*8+6)); (* Alloc *)
      while schreiben<offs+512 do
        begin
          if lesen+4>=lesegrenze then Break;
          if schreiben>=schreibgrenze then Break;
          datei_lesen(puffer,o+lesen,4);
          Inc(lesen,4);
          anzahl:=word_z(@puffer.d[0])^;
          laenge:=word_z(@puffer.d[2])^;
          if (anzahl=0) or (laenge=0) then Break;
          laenge:=Min(laenge,schreibgrenze-schreiben);
          laenge:=Min(laenge,lesegrenze-lesen);
          datei_lesen_grosser_block(allgemeiner_zwischenspeicher^[schreiben],o+lesen,laenge);
          Inc(lesen,laenge);
          Inc(schreiben,laenge);
          Dec(anzahl);
          while anzahl>0 do
            begin
              jetzt:=Min(laenge,schreibgrenze-schreiben);
              Move(allgemeiner_zwischenspeicher^[schreiben-laenge],allgemeiner_zwischenspeicher^[schreiben],jetzt);
              Inc(schreiben,jetzt);
              Dec(anzahl);
            end;


        end;

      puffer.g:=512;
      Move(allgemeiner_zwischenspeicher^[offs],puffer.d,512);

    end;

  procedure lade_lx(var puffer:puffertyp;const obj,offs:longint;const base_beruecksichtigen:boolean);
    var
      obj_puffer        :puffertyp;
      base              :longint;
      objekt_nummer     :longint;
      uebrig            :longint;
      seitenposition    :longint;
      jetzt,jetzt0      :longint;
      ziel              :pointer;
      pagemap_puffer    :puffertyp;
      daten_puffer      :puffertyp;
      offs1             :longint;

    (*$IfDef VirtualPascal*)
    procedure kopiere(const quelle,ziel;const laenge:longint);assembler;
      (*$Frame-*)(*$Uses ESI,EDI,ECX*)
      asm
        mov esi,quelle
        mov edi,ziel
        mov ecx,laenge
        cld
        rep movsb
      end;
    (*$Else*)
    procedure kopiere(const quelle,ziel;const laenge:word);assembler;
      asm
        push ds
          lds si,quelle
          les di,ziel
          mov cx,laenge
          cld
          rep movsb
        pop ds
      end;
    (*$EndIf*)

    (*$IfNDef VirtualPascal*)
      (*$Define SEG *)
    (*$EndIf*)


    procedure un_exepack1(const ql:word_norm);
      var
        quelle                    :word_norm;
        ziel                      :word_norm;
        ze                        :word_norm;
        mehrfach                  :word_norm;
        laenge                    :word_norm;
        qe                        :word_norm;
        (*$IfDef SEG*)
        zseg                      :word_norm;
        (*$EndIf*)
      begin
        quelle:=Ofs(allgemeiner_zwischenspeicher^[0*4096]);
        qe    :=quelle+ql;
        ziel  :=Ofs(allgemeiner_zwischenspeicher^[1*4096]);
        ze    :=ziel+4096;
        (*$IfDef SEG*)
        zseg:=Seg(allgemeiner_zwischenspeicher^);
        (*$EndIf*)
        repeat
          mehrfach:=MemW[(*$IfDef SEG*)zseg:(*$EndIf*)quelle];
          Inc(quelle,2);
          if mehrfach=0 then break;

          laenge:=MemW[(*$IfDef SEG*)zseg:(*$EndIf*)quelle];
          Inc(quelle,2);

          while mehrfach>0 do
            begin
              if longint(ziel)+longint(laenge)>longint(ze) then
                begin
                  ausschrift('unexepack1: Fehler in den gepackten Daten!',dat_fehler);
                  Break;
                end;

              Move(Mem[(*$IfDef SEG*)zseg:(*$EndIf*)quelle],Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel],laenge);
              Dec(mehrfach);
              Inc(ziel,laenge);
            end;

          Inc(quelle,laenge);
        until quelle>=qe;

        if ziel<ze then
          FillChar(Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel],ze-ziel,0)
      end;

    (* -> OS2EXE.PAS LXLITE 1.21 *)
    procedure un_exepack2(const ql:word_norm);
      var
        quelle                    :word_norm;
        ziel                      :word_norm;
        ze                        :word_norm;
        laenge                    :word_norm;
        steuerwort                :longint;
        qe                        :word_norm;
        (*$IfDef SEG*)
        zseg                      :word_norm;
        (*$EndIf*)
      begin

        quelle:=Ofs(allgemeiner_zwischenspeicher^[0*4096]);
        qe    :=quelle+ql;
        ziel  :=Ofs(allgemeiner_zwischenspeicher^[1*4096]);
        ze    :=ziel+4096;
        (*$IfDef SEG*)
        zseg:=Seg(allgemeiner_zwischenspeicher^);
        (*$EndIf*)
        repeat

          steuerwort:=MemW[(*$IfDef SEG*)zseg:(*$EndIf*)quelle];
          case (steuerwort and $3) of
            0: (* Fall 0 *)
              begin
                (* Bits 23..16          = FÅllbyte
                   Bits 15.. 8          = laenge2
                   Bits  7.. 2          = laenge
                   Bits  1.. 0          = Fall          *)

                (* Fall 0, laenge0 *)
                if Lo(steuerwort)=0 then
                  begin

                    (* FÅllen (laenge2) *)
                    laenge:=Hi(steuerwort);

                    (* laenge2=0? -> Ende *)
                    if laenge=0 then
                      break;

                    FillChar(Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel],laenge,Mem[(*$IfDef SEG*)zseg:(*$EndIf*)quelle+2]);
                    Inc(quelle,3);
                    Inc(ziel,laenge);
                  end
                else
                  begin
                    (* Block kopieren (laenge) *)
                    laenge:=Lo(steuerwort) shr 2;
                    kopiere(Mem[(*$IfDef SEG*)zseg:(*$EndIf*)quelle+1],Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel],laenge);
                    Inc(quelle,1+laenge);
                    Inc(ziel,laenge);
                  end;
              end;

            1: (* Fall 1 *)
              begin
                (* Bits 15.. 7          = rueckwaerts
                   Bits  6.. 4      +3  = laenge2
                   Bits  3.. 2          = laenge1
                   Bits  1.. 0          = Fall          *)

                (* laenge1 kopieren *)
                laenge:=(steuerwort shr 2) and 3;
                kopiere(Mem[(*$IfDef SEG*)zseg:(*$EndIf*)quelle+2],Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel],laenge);
                Inc(quelle,2+laenge);
                Inc(ziel,laenge);
                (* laenge2 vom entpackten holen *)
                laenge:=((steuerwort shr 4) and $7)+3;
                kopiere(Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel-(steuerwort shr 7)],
                        Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel],laenge);
                Inc(ziel,laenge);
              end;

            2: (* Fall 2 *)
              begin
                (* Bits 15.. 4          = rueckwaerts
                   Bits  3.. 2   +3     = laenge
                   Bits  1.. 0          = Fall          *)

                laenge:=((steuerwort shr 2) and $3)+3;
                kopiere(Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel-(steuerwort shr 4)],
                        Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel],laenge);
                Inc(quelle,2);
                Inc(ziel,laenge);
              end;

            3: (* Fall 3 *)
              begin
                steuerwort:=MemL[(*$IfDef SEG*)zseg:(*$EndIf*)quelle];
                (* Bits 23..21          = ?
                (* Bits 20..12          = rueckwaets
                   Bits 11.. 6          = laenge2
                   Bits  5.. 2          = laenge1
                   Bits  1.. 0          = Fall          *)

                (* Block kopieren (laenge1) *)
                laenge:=(steuerwort shr 2) and $f;
                kopiere(Mem[(*$IfDef SEG*)zseg:(*$EndIf*)quelle+3],Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel],laenge);
                Inc(quelle,3+laenge);
                Inc(ziel,laenge);

                (* schon entpacktes nochmal kopieren (laenge2) *)
                laenge:=(steuerwort shr 6) and $3f;
                kopiere(Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel-((steuerwort shr 12) and (4096-1))],
                        Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel],laenge);
                Inc(ziel,laenge);
              end;

          end; (* case *)

        until quelle>=qe;

        if ziel<ze then
          FillChar(Mem[(*$IfDef SEG*)zseg:(*$EndIf*)ziel],ze-ziel,0)

      end;

    begin
      FillChar(puffer,SizeOf(puffer),0);
      uebrig:=SizeOf(puffer.d);
      ziel:=@puffer.d;
      offs1:=offs;

      if obj=0 then
        begin
          for objekt_nummer:=1 to anzahl_object_map_table do
            begin
              datei_lesen(obj_puffer,x_exe_basis+x_exe_ofs+(objekt_nummer-1)*$18+l_exe_kopf.offset_of_object_table,$18);
              if  (longint_z(@obj_puffer.d[$4])^<=offs1)
              and (longint_z(@obj_puffer.d[$0])^+longint_z(@obj_puffer.d[$4])^>offs1) then
                Break;
            end
        end
      else
        datei_lesen(obj_puffer,x_exe_basis+x_exe_ofs+(obj-1)*$18+l_exe_kopf.offset_of_object_table,$18);

      if base_beruecksichtigen then
        base:=longint_z(@obj_puffer.d[$4])^
      else
        base:=0;


      (* TEST
      ausschrift(' '+hex_longint(x_exe_basis+x_exe_ofs+l_exe_kopf.object_page_map_table_offset),signatur);
      ausschrift('+'+hex_longint((longint_z(@obj_puffer.d[$c])^-1+((offs1-base) div $1000))*8),signatur);
      *)
      repeat

        (* Anzahl "page map entrys" gro· genug? *)
        if (offs1-base) shr 12>=longint_z(@obj_puffer.d[$10])^ then
          Exit; (* Nullen *)

        datei_lesen(pagemap_puffer,x_exe_basis+x_exe_ofs+l_exe_kopf.object_page_map_table_offset
         +(longint_z(@obj_puffer.d[$c])^-1+((offs1-base) shr 12))*8,8);

        (* page_data_offset: longint;
           data_size:        smallword;
           flags:            smallword; *)

        seitenposition:=(offs1-base) and (4096-1);
        jetzt :=4096                         -seitenposition;
        jetzt0:=word_z(@pagemap_puffer.d[4])^-seitenposition;
        if jetzt>uebrig then
          jetzt:=uebrig;
        if jetzt0>uebrig then
          jetzt0:=uebrig;

        case pagemap_puffer.d[6] of
          0: (* normal *)
            if jetzt0>0 then
              begin
                datei_lesen(daten_puffer,
                            x_exe_basis
                           +l_exe_kopf.data_pages_offset
                           +longint_z(@pagemap_puffer.d[0])^ shl l_exe_kopf.page_shift_count
                           +seitenposition,
                            jetzt0);
                Move(daten_puffer.d[0],ziel^,jetzt0);
              end;

          1, (* exepack:1 *)
          5: (* exepack:2 *)
            begin
              datei_lesen_grosser_block(allgemeiner_zwischenspeicher^[0*4096],
                          x_exe_basis
                         +l_exe_kopf.(*object_iterate_data_map_offset*)data_pages_offset
                         +longint_z(@pagemap_puffer.d[0])^ shl l_exe_kopf.page_shift_count,
                          word_z   (@pagemap_puffer.d[4])^);
              if pagemap_puffer.d[6]=1 then
                un_exepack1(word_z (@pagemap_puffer.d[4])^)
              else (* 5 *)
                un_exepack2(word_z (@pagemap_puffer.d[4])^);
              Move(allgemeiner_zwischenspeicher^[1*4096+seitenposition],ziel^,jetzt);
            end;
        (*$IfNDef ENDEVRSION*)
          2, (* invalid (zero) *)
          3, (* zero filled *)
          4: (* range of pages? *)
            ; (* Nullen *)
        else
          ausschrift('LX Seitentyp?',virus);
        (*$EndIf*)
        end;

        Inc(longint(ziel),jetzt);
        Dec(uebrig,jetzt);
        Inc(offs1,jetzt);
        Inc(puffer.g,jetzt);
      until uebrig=0;

    end;

  (* unzuverlÑssig/vereinfacht *)
  function lx_berechne_dateiposition(const obj:word_norm;const ofs_:longint):dateigroessetyp;
    var
      pagemap_puffer,
      obj_puffer        :puffertyp;
    begin
      datei_lesen(obj_puffer,x_exe_basis+x_exe_ofs+(obj-1)*$18+l_exe_kopf.offset_of_object_table,$18);

      datei_lesen(pagemap_puffer,x_exe_basis+x_exe_ofs+l_exe_kopf.object_page_map_table_offset
         +(longint_z(@obj_puffer.d[$c])^-1+(ofs_ shr 12))*8,8);

      lx_berechne_dateiposition:=x_exe_basis
                                +l_exe_kopf.data_pages_offset
                                +longint_z(@pagemap_puffer.d[0])^ shl l_exe_kopf.page_shift_count
                                +ofs_ and (4096-1);
    end;

  procedure resource_lx(const res_tab_anfang:dateigroessetyp;const anzahl:longint;mozilla_installer:boolean);
    var
      z1                :longint;
      o                 :dateigroessetyp;
      res_puffer        :puffertyp;
      res_summe         :longint;
      resource_anfang   :puffertyp;
      r_o,r_j           :longint;
      sro               :longint;
      sn                :word_norm;
      res_inhalt        :string;
    type
      lx_res_typ=
        packed record
          TYPE_ID     :smallword;
          NAME_ID     :smallword;
          Laenge      :longint;
          Obj         :smallword;
          Ofs         :longint;
          r           :array[14..512-1] of byte;
        end;

    begin

      if mozilla_installer then
        befehl_echo('rem TYP: rename Mozilla Installer files > %tmp%\rename.cmd');

      o:=res_tab_anfang;
      res_summe:=0;
      for z1:=1 to anzahl do
        begin

          datei_lesen(res_puffer,o,2+2 +4 +2+4);
          with lx_res_typ(res_puffer.d) do
            begin

              if resource_anzeigen then
                os2_resource_ausschrift(TYPE_ID,NAME_ID,Laenge);

              (* Pointer 1 *)
              if ico_anzeige
              and (TYPE_ID=$0001) and (icon1_zaehler=0) then
                if Laenge<=SizeOf(q_entpackt_puffer_speicher) then
                  begin

                    r_o:=0;
                    while r_o<Laenge do
                      begin
                        r_j:=Laenge-r_o;
                        if r_j>SizeOf(resource_anfang.d) then
                          r_j:=SizeOf(resource_anfang.d);

                        lade_lx(resource_anfang,obj,ofs+r_o,false);
                        Move(resource_anfang.d,q_entpackt_puffer_speicher[r_o],r_j);
                        Inc(r_o,r_j);
                      end;

                    quelle_kopie:=quelle;
                    quelle.sorte:=q_entpackt_puffer;
                    quelle.entpackt_laenge:=Laenge;
                    os2_ico(0,absatz);
                    quelle:=quelle_kopie;
                    icon1_zaehler:=1;
                  end;

              (* Stringtable *)
              if (TYPE_ID=5) and (name_id>=(10001 div 16-1)) and (name_id<=(19999 div 16-1))  and mozilla_installer then
                begin
                  sro:=2;
                  for sn:=0 to 15 do
                    begin
                      lade_lx(resource_anfang,obj,ofs+sro,false);
                      exezk:=puffer_zu_zk_e(resource_anfang.d[1],#0,255);
                      if exezk<>'' then
                        begin
                          ausschrift(exezk,packer_dat);
                          befehl_echo('REN '+str0((name_id-1)*16+sn)+' '+exezk+' >> %tmp%\rename.cmd');
                        end;
                      Inc(sro,1+resource_anfang.d[0]);
                    end;

                end;

              (* rcdata *)
              if TYPE_ID=9 then
                begin

                  if name_id=1 then
                    (* (C) Copyright Steven Higgins 1995. All Rights Reserved. *)
                    begin
                      lade_lx(resource_anfang,obj,ofs,false);
                      if   bytesuche(resource_anfang.d[0],#$60#$ea)
                      and  bytesuche(resource_anfang.d[13],'REXXSAA') then
                        begin (* wie in typ_dat.pas bei _60 *)
                          exezk:=puffer_zu_zk_l(resource_anfang.d[$4],33);
                          if exezk[28]=' ' then
                            Dec(exezk[0]);
                          ausschrift(exezk,compiler);
                        end;
                    end;

                  if(name_id>=10001) and (name_id<=19999)  and mozilla_installer then
                    begin
                      (* Ich kenne den Namen nicht mehr *)
                      befehl_schnitt(lx_berechne_dateiposition(obj,ofs),laenge,Str0(name_id));
                    end;
                end;

              if TYPE_ID=123 then (* Peter Koller *)
                begin
                  lade_lx(resource_anfang,obj,ofs,false);
                  if bytesuche(resource_anfang.d[0],#$a5#$96) then
                    pack_ibm(analyseoff,integer_z(@resource_anfang.d[2])^,' (Peter Koller)');
                end;

              if TYPE_ID=256 then (* WPI2EXE *)
                begin
                  if (Laenge>$214) then
                    wpi(lx_berechne_dateiposition(obj,ofs),'.WPI'+str0(NAME_ID));
                end;

              if (TYPE_ID=400) or (TYPE_ID=420) then (* security/2 install.exe *)
                begin
                  lade_lx(resource_anfang,obj,ofs+r_o,false);
                  if bytesuche(resource_anfang.d[0],'PK') then
                    res_inhalt:='zip'
                  else
                  if bytesuche(resource_anfang.d[0],'MZ')
                  or bytesuche(resource_anfang.d[0],'LX') then
                    res_inhalt:='exe/dll/..'
                  else
                    res_inhalt:='';
                  if res_inhalt<>'' then
                    begin
                      if not resource_anzeigen then
                        os2_resource_ausschrift(TYPE_ID,NAME_ID,Laenge);
                      ausschrift_x(res_inhalt,packer_dat,absatz);
                    end;
                end;

              if TYPE_ID=999 then
                begin
                  lade_lx(resource_anfang,obj,ofs,false);
                  bdsap(resource_anfang,NAME_ID);
                end;

              (*
              if (TYPE_ID=$ffff) and (laenge>1) then
                begin
                  lade_lx(resource_anfang,obj,ofs,false);
                  if bytesuche(resource_anfang.d[0],#$cc#$c8#$bf#$f6) then
                     .. "/* VisPro/REXX */"
                end;*)

              if (TYPE_ID=1000) and (ico_anzeige) and (font1_zaehler=0) then
                if Laenge<=SizeOf(q_entpackt_puffer_speicher) then
                  begin
                    r_o:=0;
                    while r_o<Laenge do
                      begin
                        r_j:=Laenge-r_o;
                        if r_j>SizeOf(resource_anfang.d) then
                          r_j:=SizeOf(resource_anfang.d);

                        lade_lx(resource_anfang,obj,ofs+r_o,false);
                        Move(resource_anfang.d,q_entpackt_puffer_speicher[r_o],r_j);
                        Inc(r_o,r_j);
                      end;

                    os2_font(true,Addr(q_entpackt_puffer_speicher),Laenge);
                    font1_zaehler:=1;
                  end;

              Inc(res_summe,Laenge);
            end;
          IncDGT(o,2+2 +4 +2+4);
        end;

      if mozilla_installer then
        begin
          befehl_sonst('call %tmp%\rename.cmd');
          befehl_sonst('del  %tmp%\rename.cmd');
        end;



      if anzahl>0 then
        ausschrift(leer_filter(strx(res_summe,11))+textz_xexe__byte_resource1^
           +str0(anzahl)+textz_xexe__byte_resource2^,compiler);
    end;

  procedure lade_le(var puffer:puffertyp;const obj,offs:longint);
    var
      obj_puffer        :puffertyp;
      page_num          :longint;
    begin
      if obj=0 then {??};
      datei_lesen(obj_puffer,x_exe_basis+x_exe_ofs+(obj-1)*$18+l_exe_kopf.offset_of_object_table,$18);
      (* page index                     [$c] *)
      (* objet reloacation base address [$4] *)
      page_num:=(offs div l_exe_kopf.page_size)+longint_z(@obj_puffer.d[$c])^-1;

      datei_lesen(puffer,x_exe_basis+l_exe_kopf.data_pages_offset+
        +page_num*l_exe_kopf.page_size
        +(offs mod l_exe_kopf.page_size),512);
    end;



  procedure untersuche_lx_le_code(const lx_modus:boolean);
    var
      test              :longint;
      lx_cs_puffer,
      lx_cs_puffer2,
      lx_ds_puffer      :puffertyp;
      hersteller_gefunden_sicherung:boolean;
      hersteller_suche_sicherung:word;
      hersteller_anfang :word;
      ds_objekt         :longint;
      w1,w2             :word_norm;
    label
      untersuche_lx_le_code_fertig;

    procedure lade_lxle_falsch(var puffer:puffertyp;const obj,offs:longint);
      begin
        if lx_modus then
          lade_lx(puffer,obj,offs,falsch)
        else
          lade_le(puffer,obj,offs);
      end;



    begin (* untersuche_lx_le_code *)

      lade_lxle_falsch(lx_cs_puffer,l_exe_kopf.cs_obj,l_exe_kopf.ip);

      with l_exe_kopf do
        if (automatic_ds_obj=0) (* RCOMP.EXE SP 1.5, EPFIUPK2.EXE *)
        or (automatic_ds_obj>object_table_entrys) (* ibm1381.lcl *)
         then
          ds_objekt:=object_table_entrys
        else
          ds_objekt:=automatic_ds_obj;

      lade_lxle_falsch(lx_ds_puffer,ds_objekt,0);



      hersteller_gefunden_sicherung:=hersteller_gefunden;
      hersteller_suche_sicherung:=herstellersuche;
      hersteller_gefunden:=falsch;
      herstellersuche:=1;

      (*$IfDef ERWEITERUNGSDATEI*)
      suche_erweiterungen(lx_cs_puffer);
      (*$EndIf*)

      (* arch10a.zip *)
      if bytesuche(lx_cs_puffer.d[0],#$eb#$0e'?_CEESTART'#$00) then
        ausschrift('VisualAge PL/I / IBM [1.1]',compiler);

      if bytesuche(lx_cs_puffer.d[0],#$55#$8b#$ec#$db#$e3#$d9#$2d'????'#$e8'????'#$5d#$6a#$01#$50#$9a) then
        ausschrift('Visual Prolog Library Version 5.2 for OS/2 / Prolog Development Center A/S',compiler);


      if bytesuche(lx_cs_puffer.d[0],#$fc#$a3'??'#$89#$1e'??'#$c7#$06'????'#$e3#$17#$33#$c9#$51#$1e#$9a'????'#$91#$e3) then
        ausschrift('Basic / MS [?]',compiler);

      if bytesuche(lx_cs_puffer.d[0],#$b9'????'#$b8'????'#$e8'???'#$00#$e8'???'#$00) then
        ausschrift('Virtual Pascal / vpascal.com'(*fPrint UK*),compiler);

      if bytesuche(lx_cs_puffer.d[0],#$e8) then
        begin
          lade_lxle_falsch(lx_cs_puffer2,l_exe_kopf.cs_obj,l_exe_kopf.ip+1+4+longint_z(@lx_cs_puffer.d[1])^);
          if bytesuche(lx_cs_puffer2.d[0],#$8f#$05'????'#$e8'????'#$f4) then
            ausschrift('GCC [Innotek]',compiler); (* innotek - lame,exe *)
        end;

      if bytesuche(lx_cs_puffer.d[0],#$6a#$00#$e8'????'#$fc#$e8'????'#$e8'????'#$83#$c4#$0c#$50#$e8'????'#$eb#$fe) then
        ausschrift('GCC [Innotek]',compiler); (* wv gui, a52dec.exe 2004.01.02 *)

      if bytesuche(lx_cs_puffer.d[0],#$83#$7c#$24#$08#$00#$74#$02#$eb#$11#$6a'?'#$e8'????'#$83#$c4#$04#$09#$c0
        +#$74#$03#$31#$c0#$c3) then
        ausschrift('GCC [Innotek,DLL]',compiler); (* wv gui, a52dec.exe 2004.01.02 *)



      if bytesuche(lx_cs_puffer.d[0],#$b9'????'#$e8'???'#$00) then
        begin
          Inc(l_exe_kopf.ip,longint_z(@lx_cs_puffer.d[1+4+1])^+1+4+1+4);
          lade_lxle_falsch(lx_cs_puffer,l_exe_kopf.cs_obj,l_exe_kopf.ip);

          (* VPIDE20.DLL *)
          if bytesuche(lx_cs_puffer.d[0],#$83#$7c#$24#$0c#$00#$75'?'#$51#$e8)
          (* +mov[??],1 *)
          or bytesuche(lx_cs_puffer.d[0],#$c6#$05'????'#$01#$83#$7c#$24#$0c#$00#$75'?'#$51#$e8) then
            ausschrift('Virtual Pascal / vpascal.com [DLL]',compiler);

          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$8b#$44#$24#$04#$a3'????'#$58#$68'????'#$50#$e8) then
        (*
              mov    eax,[esp+4]
              mov    [70048h],eax
              pop    eax
              push   70034h
              push   eax
              call   320A0h
                                 *)
        begin
          ausschrift('Borland C++ 1992',compiler);
          (* problem mit pmmixer.exe
          lade_lx(lx_ds_puffer,0,longint_z(@lx_cs_puffer.d[$5])^ and $ffff0000,wahr);
          ausschrift(puffer_zu_zk_e(lx_ds_puffer.d[0],#0,70),compiler);
                                                                              *)
          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$5a#$ff#$74#$24#$0c#$ff#$74#$24#$0c#$ff#$74#$24#$0c#$8b#$44#$24#$0c#$a3) then
         (*   pop    edx
              push   DWord Ptr [esp+0Ch]
              push   DWord Ptr [esp+0Ch]
              push   DWord Ptr [esp+0Ch]
              mov    eax,[esp+0Ch]
              mov    [30050h],eax
              push   eax         *)
        begin
          ausschrift('Borland C++ 1994',compiler);

          (* problem mit look.exe (clearlook)
          lade_lx(lx_ds_puffer,l_exe_kopf.automatic_ds_obj,longint_z(@lx_cs_puffer.d[$12])^ and $ffff0000,wahr);
          ausschrift(puffer_zu_zk_e(lx_ds_puffer.d[0],#0,70),compiler); *)
          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$8b#$44#$24#$04#$a3'????'#$58#$68'????'#$50#$e9'???'#$00) then
        begin
          (* PMDIFFSM.DLL *)
          ausschrift('Borland C++ 1992 [DLL]',compiler);
          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$64#$67#$8b#$16#$08#$00#$8b#$42#$f8#$a3'????'#$8b#$42#$fc) then
        begin
          (* XITTEXT.DLL *)
          ausschrift('Borland C++ 1994 [DLL]',compiler);
          goto untersuche_lx_le_code_fertig;
        end;

      (* NE -> LX *)
      (* ARJ/2 2.62 1,3,4 *)
      if bytesuche(lx_cs_puffer.d[0],#$06#$1e#$60#$68'??'#$68'??'#$68'??'#$68'??'#$9a'????'#$1e#$68)
      (* ARJ/2 2.62 2 *)
      or bytesuche(lx_cs_puffer.d[0],#$b4#$30#$9a'????'#$ba'??'#$8e#$da#$89#$16'??'#$a3'??'#$1e#$68'??'#$1e#$68'??'#$9a)
       then
        begin
          ausschrift('Borland C++ 1991',compiler);
          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$68#$00#$00'??'#$e8'????'#$eb#$0c#$e8'????'#$c3#$90#$90) then
        (*    6800000200      push   20000h
              E8F6FFCC15      call   15CE0000h
              EB0C            jmp    10018h
              E8D700CD15      call   15CE00E8h
              C3              ret
              90              nop
              90              nop
              90              nop
              90              nop
              90              nop                *)
        begin
          ausschrift('gcc+emx [0.9]',compiler);
          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$68#$00#$00'??'#$e8'????'#$eb#$06#$e8'????'#$c3) then
        begin
          ausschrift('gcc+emx [0.8]',compiler);
          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$89#$e5#$8b#$75#$10#$56#$e8#$01#$00#$00#$00#$00#$55#$89#$e5#$68) then
        (* MINE.EXE, RDCPP.EXE *)
        begin
          ausschrift('GCC/2 '(*[2.3.3]*),compiler);
          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$fc#$a3'??'#$89#$1e'??'#$49) (* 1990 *)
      or bytesuche(lx_cs_puffer.d[0],#$fc#$89#$26'??'#$89#$26'??'#$8c#$1e'??'#$49#$89) (* 1987 *)
      or bytesuche(lx_cs_puffer.d[0],#$fc#$89#$25'????'#$8b#$44#$24'?'#$a3'????'#$8b#$44#$24'?'
        +#$a3'????'#$e8) (* PMFORMAT.EXE (1988) *)

      (* \MPTN\DLL\TCPMRI.DLL (1990) -> LX *)
      or bytesuche(lx_cs_puffer.d[0],#$55#$8b#$ec#$1e#$68'??'#$1e#$68'??'#$9a'????'#$8e#$06'??'#$26#$a1)
       then
        begin
          lade_lxle_falsch(lx_ds_puffer,ds_objekt,0);
          exezk:=puffer_zu_zk_e(lx_ds_puffer.d[8],#0,56);
          if Pos('opyri',exezk)<>0 then
            ausschrift(exezk,compiler)
          else (* PKZIPSFX *)
            ausschrift('MS C',compiler);
          goto untersuche_lx_le_code_fertig;
        end;


      if bytesuche(lx_cs_puffer.d[0],#$e9'???'#$00#$0e#$66#$8c#$cb#$b4#$01#$8d#$0d'????'#$ff#$d6#$c3) then
        if bytesuche(lx_cs_puffer.d[$18],'Watcom ')
        or bytesuche(lx_cs_puffer.d[$18],'WATCOM ')
        or bytesuche(lx_cs_puffer.d[$18],'Open ') then
          begin (* die OS/2-Version lÑd nicht W32RUN.EXE sonder hat alles selbst. *)
            ausschrift('Watcom W32RUN loader (OS/2)',dos_win_extender);
            ausschrift_watcom(lx_cs_puffer,$18,140);
            goto untersuche_lx_le_code_fertig;
          end;


      if bytesuche(lx_cs_puffer.d[0],#$e9'???'#$00'????WATCOM') then
        begin
          (* Watcom fÅr OS/2: LHA.EXE *)
          ausschrift_watcom(lx_cs_puffer,9,140);
          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$e9'???'#$00'????Open Wat') then
        begin
          (* Open Watcom fÅr OS/2: WRC2.EXE *)
          ausschrift_watcom(lx_cs_puffer,9,$5f);
          goto untersuche_lx_le_code_fertig;
        end;


      if bytesuche(lx_cs_puffer.d[0],#$eb#$06'WATCOM'#$fc#$66#$8c#$05#$00#$00#$00#$00#$b4#$09#$ba'???'#$00#$cd#$21) then
        begin
          (* XLE: Pack for LE  1.1.0 *)
          ausschrift('XELoader Xpack for LE / JauMing Tseng',packer_exe);
          goto untersuche_lx_le_code_fertig;
        end;


      if bytesuche(lx_cs_puffer.d[0],#$eb'?WATCOM')
      or bytesuche(lx_cs_puffer.d[0],#$eb'?Open WATCOM')
      or bytesuche(lx_cs_puffer.d[0],#$eb'?Open Watcom')
       then
        begin
          (* INSTALL.EXE Supernar System (DOS32) *)
          ausschrift_watcom(lx_cs_puffer,2,lx_cs_puffer.d[1]);
          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$e8#$07#$00#$00#$00'WATCOM'
        +#$00#$5a#$83#$ea#$05#$b8'????'#$03#$c2#$50) then
        begin
          ausschrift('PE2LE /P:2 / Veit Kannegieser',packer_exe);
          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$e8#$07#$00#$00#$00'WATCOM'
        +#$00#$5a#$81#$ea'????'#$b8'????'#$03#$c2#$50#$be) then
        begin
          ausschrift('PE2LE /P:2 / Veit Kannegieser [2000.01.31]',packer_exe);
          goto untersuche_lx_le_code_fertig;
        end;

      if bytesuche(lx_cs_puffer.d[0],#$e8#$1a#$00#$00#$00'WATCOM*VPDB'#$00'\DEV\VPDDID$$'
        +#$00#$5a#$83#$ea#$05#$8b#$ea#$b8#$00#$3d) then
        begin
          ausschrift('PE2LE /P:3 / Veit Kannegieser',packer_exe);
          goto untersuche_lx_le_code_fertig;
        end;

      (* OS/2 FDISK (LXLITE) (ZORTECH) *)
      if bytesuche(lx_cs_puffer.d[0],#$89#$26'??'#$49#$89#$0e'??'#$89#$0e'??'#$a3'??'#$a3'??'#$89#$1e) then
          (* cs:BD9689265908         mov    [859h],sp
             cs:BD9A 49               dec    cx
             cs:BD9B 890EB707         mov    [7B7h],cx
             cs:BD9F 890EB907         mov    [7B9h],cx
             cs:BDA3 A35708           mov    [857h],ax
             cs:BDA6 A39E09           mov    [99Eh],ax
             cs:BDA9 891E5508         mov    [855h],bx
             cs:BDAD 8BD9             mov    bx,cx
             cs:BDAF B104             mov    cl,4
             cs:BDB1 D3EB             shr    bx,cl
             cs:BDB3 891EB507         mov    [7B5h],bx *)
        begin
          hersteller_anfang:=puffer_pos_suche(lx_ds_puffer,#$00,200);
          if hersteller_anfang<>nicht_gefunden then
            ausschrift(puffer_zu_zk_e(lx_ds_puffer.d[hersteller_anfang+1],#$00,120),compiler);
        end;

      if bytesuche(lx_cs_puffer.d[0],#$1e#$ba'??'#$8e#$da#$8b#$0e'??'#$8b#$36) then
        (* NE->LX *)
        ausschrift('Topspeed Modula 2 / Clarion',compiler);

      if bytesuche(lx_cs_puffer.d[0],#$89#$e5#$81#$ec'????'#$89#$04#$24#$c6#$05) then
        (* 1.5 *)
        ausschrift('SpeedSoft Pascal',compiler);

      if bytesuche(lx_cs_puffer.d[0],#$8b#$ec#$fc#$81#$ec'????'#$89#$04#$24#$8b#$45#$10#$a3) then
        (* ?.? *)
        ausschrift('SpeedSoft Pascal',compiler);


      (*SIBYL3A.ZIP: Version 2.0 Beta III *)
      (* SIBDEMO3.ZIP: 2.0 Fix3 *)
      if (    bytesuche(lx_cs_puffer.d[0],#$55#$89#$e5#$83#$ec'?'#$89#$04#$24#$c6#$05'?????'#$c7)
          and (lx_cs_puffer.d[15] in [0,1]))
      or (    bytesuche(lx_cs_puffer.d[0],#$55#$89#$e5#$81#$ec'????'#$89#$04#$24#$c6#$05'?????'#$c7)
          and (lx_cs_puffer.d[15+3] in [0,1]))
          (* mit stackcheck: newview 2.9.8 *)
      or (    bytesuche(lx_cs_puffer.d[0],#$55#$89#$e5#$68'????'#$e8'????'#$83#$ec'?'#$89#$04#$24#$c6))
      or (    bytesuche(lx_cs_puffer.d[0],#$55#$89#$e5#$68'????'#$e8'????'#$81#$ec'????'#$89#$04#$24#$c6))
       then
        ausschrift('SpeedSoft Pascal [Sibyl 2.x]',compiler);



      if bytesuche(lx_cs_puffer.d[0],#$9a#$00#$00#$00#$00#$55#$89#$e5#$31#$c0)
      or (bytesuche(lx_cs_puffer.d[0],#$9a#$00#$00#$00#$00#$9a#$00#$00#$00#$00)
          and (puffer_pos_suche(lx_cs_puffer,#$55#$89#$e5#$31#$c0,40)<>nicht_gefunden))
       then
        ausschrift('Borland Pascal 7 + Patch / Matthias Withopf / c'#39't ',compiler);


      if bytesuche(lx_cs_puffer.d[0],#$55#$8b#$ec#$6a#$00#$8b#$7d#$14#$b0#$00#$fc#$89#$3d'????'
                                    +#$b9#$00#$01#$00#$00#$f2#$ae#$81#$e9#$00#$01#$00#$00#$f7#$d9#$49) then
        ausschrift('Prospero Pascal / Prospero Software',compiler);(* ?.? 1993? *)

      if bytesuche(lx_cs_puffer.d[0],#$55#$8b#$ec#$db#$e3#$9b#$d9#$2d'????'#$68'????'#$64) then
          (* cs:17BF855              push   ebp
             cs:17BF9 8BEC            mov    ebp,esp
             cs:17BFB DBE3            finit
             cs:17BFD 9B              wait
             cs:17BFE D92D8C090200    fldcw  Word Ptr [2098Ch]
             cs:17C04 687C9B0100      push   19B7Ch
             cs:17C09 64FF3500000000  push   DWord Ptr fs:[0]
             cs:17C10 E8CB000000      call   17CE0h
             cs:17C15 83F8FF          cmp    eax,0FFFFFFFFh *)
        ausschrift('IBM C++',compiler);

      if bytesuche(lx_cs_puffer.d[0],#$83#$ec#$0c#$e8'????'#$e8'????') then
        ausschrift('IBM Visual Age C++',compiler);

      if bytesuche(lx_cs_puffer.d[0],#$53#$83#$ec#$0c#$e8'????'#$e8'????')
      or bytesuche(lx_cs_puffer.d[0],#$55#$8b#$ec#$db#$e3#$8b#$45#$14#$50#$e8)
          (* OS/2 COMETRUN.EXE
             PUSH EBP
             MOV EBP,ESP
             FNINIT
             MOV EAX,[EBP+arg_C]
             PUSH EAX
             CALL _setuparg *)
       then
        ausschrift('IBM C Set 2.x/3.x',compiler);

      if bytesuche(lx_cs_puffer.d[0],#$55#$8b#$ec#$68'????'#$64#$ff#$35#$00#$00#$00#$00#$64#$89#$25#$00#$00#$00#$00#$e8) then
          (* MNOTEB04: OS/2+Win32 EXE *)
          (* push   ebp
             mov    ebp,esp
             push   1B570h
             push   DWord Ptr fs:[0]
             mov    fs:[0],esp
             call   1AB76h
             call   1B300h                *)
        ausschrift('IBM VisulalAge C',compiler);

      (* DSMI.DLL,...*)
      if bytesuche(lx_cs_puffer.d[0],#$83#$ec#$04#$83#$7c#$24#$0c#$00#$74#$0e#$e8'????'#$e8'????'#$eb)
      (* ACCSSWPS.DLL,.. *)
      or bytesuche(lx_cs_puffer.d[0],#$83#$ec#$04#$83#$7c#$24#$0c#$00#$74#$0e#$e8'????'#$b0#$00#$e8'????'#$eb)
       then
        ausschrift('IBM C',compiler);

      (* CBSCOMP.DLL *)
      if bytesuche(lx_cs_puffer.d[0],#$83#$ec#$04#$83#$7c#$24#$0c#$00#$74#$0a#$e8'????'#$eb'????'#$b8)
       then
        ausschrift('IBM C <2>',compiler);

      (* MAOPEN3.DLL *)
      if bytesuche(lx_cs_puffer.d[0],#$83#$7c#$24#$08#$00#$74#$0d#$e8'????'#$e8'????'#$eb)
       then
        ausschrift('IBM C <3>',compiler);

      if bytesuche(lx_cs_puffer.d[0],#$eb#$66#$e8'????'#$e8'????') then
        ausschrift('TMT Development Pascal',compiler);

      (*
        10010>83EC0C          sub    esp,0Ch
        10013 E84C333C15      call   153D3364h
        10018 E84B333C15      call   153D3368h
        1001D E826D73C15      call   153DD748h
        10022 83F8FF          cmp    eax,0FFFFFFFFh
        10025 7509            jne    10030h
        10027 83C40C          add    esp,0Ch
        1002A B808000000      mov    eax,8
        1002F C3              ret
        10030 8D4C2404        lea    ecx,[esp+4] *)


      (* LE: IDAX.EXE X1.EXE *)
      (* 0.05 *)
      (* auch 0.76.1 *)
      if bytesuche(lx_cs_puffer.d[0],#$bf'UPX#'#$be'alibiWATCOM'#$06) then
        ausschrift_upx_version(lx_cs_puffer,lx_cs_puffer,$156-4,0,255,'watcom/le');

      if bytesuche(lx_cs_puffer.d[0],#$bf'UPX#'#$be'alibiWATCOM'#$57) then
        ausschrift_upx_version(lx_cs_puffer,lx_cs_puffer,$156-4,0,255,'watcom/le');

      (* 0.81 *)
      if bytesuche(lx_cs_puffer.d[0],#$bf'alibiWATCOM'#$06#$1e#$07#$57) then
        ausschrift_upx_version(lx_cs_puffer,lx_cs_puffer,$156-4,81,255,'watcom/le');

      if bytesuche(lx_cs_puffer.d[0],#$8b#$44#$24#$04#$36#$a3'????'#$68'????'#$e8'????'#$83#$ec#$fc) then
        (* 8B442404        mov    eax,[esp+4]
           36A368120500    mov    ss:[51268h],eax
           68C08E0100      push   18EC0h
           E8AC1C0100      call   2F470h
           83ECFC          sub    esp,0FFFFFFFCh
           E9E41C0100      jmp    2F4B0h              *)
        ausschrift('XDS Modula-2',compiler);

      if bytesuche(lx_cs_puffer.d[0],#$8b#$7c#$24#$0c#$2a#$c0#$83#$c9#$ff#$f2#$ae#$3a#$07#$75#$fa#$47#$57) then
        (*ausschrift('OBERON ??? / ???',compiler);*)
        ausschrift('HOPE Oberon / David C. Morrill',compiler);

      (* WATCOM LE *)
      if bytesuche(lx_cs_puffer.d[0],#$fc#$b8'WATCOM')
      or bytesuche(lx_cs_puffer.d[0],#$fd#$b8'WATCOM') then
        repeat
          w2:=0;
          w1:=Length(#$fc#$b8'WATCOM');
          if bytesuche(lx_cs_puffer.d[w1],#$e8#$00#$00#$00#$00#$58) then
            begin
              Inc(w1,5+1); (* -m , step.exe *)
              Inc(w2);
            end;
          if bytesuche(lx_cs_puffer.d[w1],#$06#$1e) then
            begin (* push es; push ds; pop ds *)
              Inc(w1,3); (* -m, step.exe *)
              Inc(w2);
              if bytesuche(lx_cs_puffer.d[w1],#$e8#$00#$00#$00#$00#$58) then
                begin
                  Inc(w1,5+1); (* le -m e *)
                  Inc(w2);
                  ausschrift('32LiTE / OleGPro [0.03a -m]',packer_exe);
                  Break;
                end;
            end;
          if bytesuche(lx_cs_puffer.d[w1],#$8d#$b0'????'#$8d#$b8'????'#$05) then
            begin
              ausschrift('32LiTE / OleGPro [0.02d -m]',packer_exe);
              Break;
            end;
          if bytesuche(lx_cs_puffer.d[w1],#$66#$bb) then
            Inc(w1,2+2)                         (* mov bx,$???? *)
          else
            if bytesuche(lx_cs_puffer.d[w1],#$33#$db) then
              begin
                Inc(w1,2); (* xor (e)bx,(e)bx *)
                while lx_cs_puffer.d[w1]=$43 do
                  Inc(w1); (* inc ebx *)
              end
            else
              Break;

          if bytesuche(lx_cs_puffer.d[w1],#$66#$b9) then
            Inc(w1,1+1+2) (* mov cx,$???? *)
          else
            if lx_cs_puffer.d[w1]=$b9 then
              Inc(w1,1+4) (* mov ecx,$???????? *)
            else
              Break;


        if not bytesuche(lx_cs_puffer.d[w1],#$66#$b8#$01#$05#$cd#$31) then
          Break;

        if lx_cs_puffer.d[12]=$56 then
          ausschrift('32LiTE / OleGPro [0.01?]',packer_exe)
        else (* $06 *)
          ausschrift('32LiTE / OleGPro [0.02d]',packer_exe);

        until true;


      (*$IfNDef ENDVERSION*)
      if not hersteller_gefunden then
        begin
          ausschrift('cs:eip='+puffer_zu_zk_l(lx_cs_puffer.d[0],70),signatur);
          ausschrift('ds:000='+puffer_zu_zk_l(lx_ds_puffer.d[0],70),signatur);
        end;
      (*$EndIf*)

    untersuche_lx_le_code_fertig:

      hersteller_gefunden:=hersteller_gefunden_sicherung;
      herstellersuche:=hersteller_suche_sicherung;

    end;

  (* weiter unten die db-Variante *)
  procedure msw_versionsinfo_resource_sb(const start,laenge:dateigroessetyp);
    var
      o                 :longint;
      l                 :word_norm;
      z                 :string;
      p                 :puffertyp;
      sichtbar          :boolean;
      sprach_zaehler    :word_norm;
    begin
      (*o:=$6c;*)
      o:=$48;
      sichtbar:=true;
      sprach_zaehler:=0;
      repeat

        Inc(o,2);
        l:=x_word__datei_lesen(start+o);
        Inc(o,2);

        z:=datei_lesen__zu_zk_e(start+o,#0,80);
        (*$IfDef DEBUG*)
        ausschrift(z,normal);
        (*$EndIf*)
        Inc(o,(Length(z)+1+3) and $fffffffc);

        if (Length(z)=Length('040904E4'))
        and (Pos('040',z)=1)
         then
          begin
            sichtbar:=(sprach_zaehler=0)
                   or ((textz_xexe__sprache^='D') and (z[4]='7')) (* 040704E4 *)
                   or ((textz_xexe__sprache^='E') and (z[4]='9'));(* 040904E4 *)
            Inc(sprach_zaehler);
          end;

        if sichtbar and (   (z='FileDescription')
                         or (z='Description')
                         or (z='Comments'))
        (*$IfDef DEBUG*)
        or true
        (*$EndIf*)
         then
          begin
            z:=datei_lesen__zu_zk_e(start+o,#0,l);
            if z<>'' then
              ausschrift(in_doppelten_anfuerungszeichen(z),beschreibung);
          end;

        o:=(o+l+3) and $fffffffc;

      until o>=laenge;

    end;

  function integer_oder_res_name(const i:word_norm):string;
    var
      rnamen:puffertyp;
    begin
      if (i and $8000)=0 then
        begin
          datei_lesen(rnamen,x_exe_basis+x_exe_ofs+n_exe_kopf.resource_table_offset+i,256);
          integer_oder_res_name:=puffer_zu_zk_pstr(rnamen.d[0]);
        end
      else
        integer_oder_res_name:='';
    end;


   procedure suche_winzip_tabelle(const von,bis:dateigroessetyp);
     var
       mnc01sfx02       :dateigroessetyp;
       nmc_puffer       :puffertyp;
     begin
       mnc01sfx02:=datei_pos_suche(von,bis,'NMC'#$01'sfx'#$02);
       if mnc01sfx02=nicht_gefunden then Exit;

       datei_lesen(nmc_puffer,mnc01sfx02,$14);
       merke_position(x_exe_basis+longint_z(@nmc_puffer.d[$10])^,datentyp_winzip);
       merke_position(x_exe_basis+longint_z(@nmc_puffer.d[$0c])^,datentyp_unbekannt);
     end;


  (***********************************************************************)
  (***********************************************************************)
  (***********************************************************************)
  (***********************************************************************)
  (***********************************************************************)
  (***********************************************************************)

  var
    hersteller_anfang   :longint;
    bdsap_start         :longint;
    bdsap_suchen        :boolean;
    resource_zaehler    :longint;
    resource_laenge     :longint;
    z1,z2               :longint;
    resource_segment    :word_norm;
    suche_nmc01sfx02_noetig:boolean;
    resource_zeile_ne   :string;
    packexe_patch       :boolean;

  procedure resource_zeile_berechnen_ne;
    var
      entpackt_name     :string;
    begin
      msw_resource__exezk(
            res_typ_id                 and $7fff,
            word_z(@namenpuffer.d[6])^ and $7fff,
            integer_oder_res_name(res_typ_id),
            integer_oder_res_name(word_z(@namenpuffer.d[6])^),
            resource_laenge,entpackt_name);
      resource_zeile_ne:=exezk;

      befehl_schnitt(x_exe_basis+l0,f2,entpackt_name);
    end;

  procedure resource_position_ausgeben_ne;
    begin
      if not schon_angezeigt then
        begin
          ausschrift(resource_zeile_ne,musik_bild);
          schon_angezeigt:=true;
        end;
    end;

  function berechne_x_exe_ende1:dateigroessetyp;
    var
      zaehler,l1:longint;
      x_exe_ende:dateigroessetyp;
    begin
      anzahl_object_map_table:=0;

      (* LPTOOL.EXE 2.00 *)
      x_exe_ende:=l_exe_kopf.data_pages_offset;
      if x_exe_ende<x_exe_ofs+l_exe_kopf.imported_procedures_name_table_offset then
        begin
          x_exe_ende:=x_exe_ofs+l_exe_kopf.imported_procedures_name_table_offset;
        end;

      rle_kompression:=falsch;
      lzw_kompression:=falsch;

      for zaehler:=1 to l_exe_kopf.object_table_entrys do
        begin
          datei_lesen(namenpuffer,x_exe_basis+x_exe_ofs+l_exe_kopf.offset_of_object_table+(zaehler-1)*$18,$18);
          Inc(anzahl_object_map_table,longint_z(@namenpuffer.d[$10])^);
        end;


      for zaehler:=1 to anzahl_object_map_table do
        begin
          datei_lesen(namenpuffer,x_exe_basis+x_exe_ofs+l_exe_kopf.object_page_map_table_offset+(zaehler-1)*8,8);

          (* ausschrift('Kompression='+str(namenpuffer.d[6],0)+' : '
             +str(word_z(@namenpuffer.d[$04])^,0),signatur); *)

          case namenpuffer.d[6] of
           1:rle_kompression:=true;
           5:lzw_kompression:=true;
          end;

          if namenpuffer.d[6] in [0,1,5] (* valid,exepack:1,exepack:2 *) then
            begin
              (* NICHT relativ zu x_exe_ofs *)
              l1:=l_exe_kopf.data_pages_offset
                 +longint_z(@namenpuffer.d[0])^ shl l_exe_kopf.page_shift_count
                 +word_z(@namenpuffer.d[$04])^;

              if (x_exe_ende<l1) and (word_z(@namenpuffer.d[$04])^>0) then
                x_exe_ende:=l1;

              (*ausschrift(strx(zaehler,8)+' : '+hex_longint(l1)+' / '+hex_longint(x_exe_ende),normal);*)
            end;
        end;

      berechne_x_exe_ende1:=x_exe_ende;
    end; (* berechne_x_exe_ende1 *)

  var
    w1                  :word_norm;

  begin
    x_exe_ende:=einzel_laenge;
    icon1_zaehler:=0;
    font1_zaehler:=0;
    suche_nmc01sfx02_noetig:=falsch;

    datei_lesen(nexepuffer,x_exe_basis+x_exe_ofs,200);
    with n_exe_kopf do
      xx_sig:=puffer_zu_zk_l(exe_sig,2);

    (* DOS32 *)
    if bytesuche(nexepuffer.d,'Adam')
    or bytesuche(nexepuffer.d,'DLL ')
     then
      adam_dos32(nexepuffer,einzel_laenge);


    (*   €€€€€€  €€      €€  €€      €€  €€      €€  €€€€€€  €€€€€€
         €€  €€  €€€€  €€€€  €€      €€  €€      €€    €€    €€
         €€€€€€  €€  €€  €€  €€  €€  €€  €€      €€    €€    €€€€€€
         €€      €€      €€  €€€€  €€€€  €€      €€    €€    €€
         €€      €€      €€  €€      €€  €€€€€€  €€    €€    €€€€€€
                                                                 *)
    if bytesuche(nexepuffer.d,'PMW1') then
      pmwlite(nexepuffer,einzel_laenge);

    (*   €€      €€  €€€€€€
           €€  €€    €€
             €€      €€€€€€
           €€  €€    €€
         €€      €€  €€€€€€ *)
    if xx_sig='XE' then
      begin
        xpack_le(nexepuffer);
        x_exe_ende:=x_exe_ofs+einzel_laenge;
      end;


    (*
         €€      €€    €€€€€€€€
         €€€€    €€    €€
         €€  €€  €€    €€€€€€€€
         €€    €€€€    €€
         €€      €€    €€€€€€€€

                                                                 *)

    if (xx_sig='NE') or (xx_sig='NF') then
      with n_exe_kopf do
        begin

          ausschrift(textz_Erweiterte^+' EXE "'+xx_sig+textz_xexe__ab^+strx_oder_hexDGT(0+x_exe_basis+x_exe_ofs),signatur);

          case target_os of
            $00:exezk:=textz_Zielsystem_unbekannt^;
            $01:exezk:=textz_Zielsystem_OS2^;
            $02:exezk:=textz_Zielsystem_Windows^+', Version'
                      +version_x_y(excpectedwindowsversion[1],excpectedwindowsversion[0]);
            $03:exezk:=textz_Zielsystem_MS_DOS_4x^;
            $04:exezk:=textz_Zielsystem_Windows_386^;
            $05:exezk:=textz_Zielsystem_Borland_Operating_System_Services^;
(*          $09:exezk:=textz_Zielsystem_PocketPC_2002_^; - windows ce? *)
            $81:exezk:=textz_Zielsystem_Phar_Lap_DOS_Extender_286_OS2^;
            $82:exezk:=textz_Zielsystem_Phar_Lap_DOS_Extender_286_Windows^;
          else
            exezk:=textz_Zielbetriebssystem_Nr^+str0(target_os);
          end;

          case application_flags and (1+2+4) of
            1:exezk_anhaengen(textz_klammer_Vollbild_klammer^);
            2:exezk_anhaengen(textz_klammer_PM_kompatibel_klammer^);
            3:exezk_anhaengen(' [P.M.]');
          end;

          if (application_flags and bit07)<>0 then
            exezk_anhaengen(textz_klammer_Bibliothek_Treiber_klammer^);

          if (application_flags and bit05)<>0 then
            exezk_anhaengen(textz_klammer_Fehler_klammer^);

          ausschrift(exezk,signatur);

          if ((einzel_laenge=$040) and (n_exe_kopf.non_resident_name_offset=$00001935))
          or ((einzel_laenge=$500) and (n_exe_kopf.non_resident_name_offset=$00001c35))
           then
            ausschrift('FoolTeu / G†bor Keve',packer_exe);


          (* SHRINKER.EXE (3.3) *)
          if  (x_exe_ofs=0)
          and (x_exe_basis>1500)
          and (n_exe_kopf.non_resident_name_offset>0)
           then
            begin

              if  (n_exe_kopf.non_resident_name_offset>x_exe_basis)
              and (n_exe_kopf.non_resident_name_offset<
                      longint(x_word__datei_lesen(x_exe_basis+x_exe_ofs+n_exe_kopf.segtab_ofs))
                  shl n_exe_kopf.file_alignment_size_shift_count)
               then
                begin
                  x_exe_ofs:=x_exe_basis;
                  x_exe_basis:=0;
                end;
            end;

          selbstlader:=false;
          if target_os=$02 then (* Windows *)
            if (application_flags and bit03)>0 then
              begin
                selbstlader:=true;
              (*n_exe_kopf.cs:=0;
                n_exe_kopf.ip:=0;*)
                n_exe_kopf.cs:=1;
                n_exe_kopf.ip:=0;
              end;

          if not selbstlader then
            begin
              rle_kompression:=falsch;
              for zaehler:=1 to n_exe_kopf.segment_count do
                begin
                  datei_lesen(namenpuffer,x_exe_basis+x_exe_ofs+n_exe_kopf.segtab_ofs+(zaehler-1)*$8,8);
                  (* segmentattribute *)
                  if (namenpuffer.d[4] and $08)<>0 then
                    rle_kompression:=true;
                end;

              if rle_kompression then
                begin
                  (* FDISK.COM (Warp 4.0 FP 10) *)
                  ausschrift('RLE-'+textz_xexe__komprimiert^+' [/EXEPACK] ',packer_exe);
                  (*goto untersuche_ne_code_fertig;*)
                end;
            end;


          (*Stimmt nicht! (Alignment 1 ist mîglich (0)
            if n_exe_kopf.file_alignment_size_shift_count=0 then n_exe_kopf.file_alignment_size_shift_count:=9;*)
          file_aligment:=1 shl n_exe_kopf.file_alignment_size_shift_count;

          hersteller_gefunden_sicherung:=hersteller_gefunden;
          hersteller_suche_sicherung:=herstellersuche;
          hersteller_gefunden:=falsch;
          herstellersuche:=1;

          if (n_exe_kopf.cs=0) or (n_exe_kopf.cs>n_exe_kopf.segment_count) then
            goto untersuche_ne_code_fertig;


          (* CODE laden *)
          cs_ofs:=longint(x_word__datei_lesen(x_exe_basis+x_exe_ofs+n_exe_kopf.segtab_ofs+(n_exe_kopf.cs-1)*8))
                  shl n_exe_kopf.file_alignment_size_shift_count;

          lade_ne(ds_puffer      ,n_exe_kopf.auto_data_segment_index,0);
          lade_ne(xexe_codepuffer,n_exe_kopf.cs,n_exe_kopf.ip);
          if selbstlader then
            begin
              n_exe_kopf.ip:=word_z(@xexe_codepuffer.d[$4])^;
              (*if n_exe_kopf.ip=$ffff then ??? - PKLITE 2.01 *)
              lade_ne(xexe_codepuffer,n_exe_kopf.cs,n_exe_kopf.ip);
            end;



          (*$IfDef ERWEITERUNGSDATEI*)
          suche_erweiterungen(xexe_codepuffer);
          (*$EndIf*)

          (*$IfDef GTDATA*)
          suche_gtdata(gt_ne_0j,xexe_codepuffer.d[0]);
          (*$EndIf*)

          if bytesuche(xexe_codepuffer.d[0],#$9a'????'#$55#$8b#$ec#$9a'????'#$05#$c0#$ff#$83#$d2#$ff
            +#$a3'??'#$89#$16'??'#$2b#$c0#$9a) then (* steuerlotse, compiler 1991-1993? *)
            ausschrift('GFA-Basic / GFA Systemtechnik GmbH [?4.30 WIN]',compiler);

          if bytesuche(xexe_codepuffer.d[0],#$9a'????'#$9a'????'#$9a'????'#$55#$8b#$ec#$b0#$00#$a2'??'
            +#$b0#$01#$a2'??'#$2b#$c0#$a2'??'#$b8'??'#$99#$bb'??'#$9a) then
            ausschrift('GFA-Basic / GFA Systemtechnik GmbH [?<M_SPEC.EXE>]',compiler);

          if bytesuche(xexe_codepuffer.d[0],#$fc#$a3'??'#$89#$1e'??'#$c7#$06'????'#$e3#$17#$33#$c9#$51
              +#$1e#$9a'????'#$91#$e3) then
            ausschrift('Basic / MS [?]',compiler);

          if bytesuche(xexe_codepuffer.d[0],#$9a#$ff#$ff#$00#$00) then
            {if (puffer_anzahl_suche(xexe_codepuffer,#$55#$89#$e5,100)>=1) then}
              (* DPMI und Windows *)
              begin
                case m_word(linker_version) of
                  $050a:exezk:='C++';                  (* TASKMGR NWDOS 7.15 *)
                  $0601:exezk:='Pascal [7.1˙˙DELPHI]'; (* KEYGEN.EXE *)
                else
                  exezk:='??? '{'L='+hex_word(m_word(nexepuffer.d<<[2]))};
                end;
                ausschrift('Borland '+exezk+linker,compiler);
              end
  {          else (* kein richtiges Beispiel gefunden *)
              begin
                ausschrift('MS Basic',compiler); (* FONTER *)
              end};

          if bytesuche(xexe_codepuffer.d[0],#$20'??'#$a1'??'#$5c#$f9) then
            ausschrift('Rosenthal Winlite',packer_exe); {?}

          if bytesuche(xexe_codepuffer.d[0],#$1e#$ba'??'#$8e#$da#$8b#$0e'??'#$8b#$36) then
            ausschrift('Topspeed Modula 2 / Clarion',compiler);

          if bytesuche(xexe_codepuffer.d[0],#$33#$ed#$55#$9a#$ff#$ff#$00#$00#$0b#$c0#$74) then
            ausschrift('MS C/BASIC/..',compiler); (* _MSTEST.EXE *)

          if bytesuche(xexe_codepuffer.d[0],#$89#$3e'??'#$56#$57#$1e#$51#$06#$56) then
            ausschrift('Borland C++'+linker,compiler); (* STACKFM.DLL *)

          if bytesuche(xexe_codepuffer.d[0],#$53#$51#$06#$33#$c0#$50) then
            ausschrift('Borland C++'+linker,compiler); (* INSTALLW.EXE zu macsee *)

          if bytesuche(xexe_codepuffer.d[0],#$eb#$0a'CGINIT????'#$53#$51#$06#$33#$c0#$50#$9a) then
            ausschrift('Borland C++'+linker,compiler); (* drhard16.exe - code guard? *)

          if bytesuche(xexe_codepuffer.d[0],#$06#$60#$c8#$04#$00#$00#$0e#$68'?'#$00) then
            (* 007        1.0d *)
            (* PrivateEXE 2.0a *)
            (* PrivateEXE 2.2  *)
            ausschrift('007,PrivateEXE / Midstream [1.0d,2.0a,2.2]',packer_exe);

          if bytesuche(xexe_codepuffer.d[0],#$8c#$d8#$90#$45#$55#$8b#$ec#$1E#$8e#$d8) then
            ausschrift('MS '+textz_exe__Laufzeitbibliothek^,compiler); (* MSDETSTF.DLL *)

          if bytesuche(xexe_codepuffer.d[0],#$eb'?WATCOM')
          or bytesuche(xexe_codepuffer.d[0],#$eb'?Open WATCOM')
          or bytesuche(xexe_codepuffer.d[0],#$eb'?Open Watcom') then
            begin
              (* Watcom fÅr Win16: WTOMB2CD.EXE *)
              ausschrift_watcom(xexe_codepuffer,2,140);
            end;

          if bytesuche(xexe_codepuffer.d[0],#$8c#$d8#$90#$45#$55#$89#$e5#$1e#$8e#$d8#$57#$1e
              +#$51#$06#$56#$e3#$0e#$31#$c0#$1e#$50) then
            ausschrift('Watcom (DLL)',compiler);


          (* MS C *)
          (* OS/2 ANSI.EXE,.. MS RTL *)
          if bytesuche(xexe_codepuffer.d[0],#$fc#$a3'??'#$89#$1e'??'#$49#$89#$0e'??'#$bb'??'#$8c#$1f)
          (* IOMEGA PROTECT.EXE *)
          or bytesuche(xexe_codepuffer.d[0],#$fc#$89#$26'??'#$89#$26'??'#$8c#$1e'??'#$49#$89#$0e'??'#$a3'??'#$89#$1e)
          (* \MPTN\DLL\TCPMRI.DLL (1990) *)
          or bytesuche(xexe_codepuffer.d[0],#$55#$8b#$ec#$1e#$68'??'#$1e#$68'??'#$9a'????'#$8e#$06'??'#$26#$a1)
           then
            begin
              w1:=8;
              while (ds_puffer.d[w1]=0) and (w1<20) do
                Inc(w1);
              if w1<20 then
                begin
                  exezk:=puffer_zu_zk_e(ds_puffer.d[w1],#0,56);
                  if Pos('opyri',exezk)<>0 then
                    ausschrift(exezk,compiler)
                  else (* PKZIPSFX *)
                    ausschrift('MS C',compiler);
                end;
            end;

          (* OS/2 FDISK.COM: ZORTECH *)
          if bytesuche(xexe_codepuffer.d[0],#$89#$26'??'#$49#$89#$0e'??'#$89#$0e'??'#$a3'??'#$a3'??'#$89#$1e) then
            begin
              (* DS:0='NULL POINTER...'#0 *)
              hersteller_anfang:=puffer_pos_suche(ds_puffer,#$00,200);
              if hersteller_anfang<>nicht_gefunden then
                ausschrift(puffer_zu_zk_e(ds_puffer.d[hersteller_anfang+1],#$00,120),compiler);
            end;

          (* ARJ/2 2.62 1,3,4 *)
          if bytesuche(xexe_codepuffer.d[0],#$06#$1e#$60#$68'??'#$68'??'#$68'??'#$68'??'#$9a'????'#$1e#$68)
          (* ARJ/2 2.62 2 *)
          or bytesuche(xexe_codepuffer.d[0],#$b4#$30#$9a'????'#$ba'??'#$8e#$da#$89#$16'??'#$a3'??'#$1e#$68'??'#$1e#$68'??'#$9a)
           then
            ausschrift('Borland C++ 1991',compiler);

          if bytesuche(xexe_codepuffer.d[0],#$cc#$55#$8b#$ec#$1e#$56#$57#$b8#$ff#$ff#$3d#$00#$10#$74) then
            (* Selbstlader *)
            ausschrift('PackWin / Yellow Rose Workgroup [1.0]',packer_exe);

          if bytesuche(xexe_codepuffer.d[0],#$eb#$13#$90#$e8#$13#$06#$33#$c0#$8e#$46#$08) then
            (* Selbstlader *)
            ausschrift('PackWin / Yellow Rose Workgroup [2.0]',packer_exe);

          if bytesuche(xexe_codepuffer.d[0],#$55#$8b#$ec#$1e#$56#$57#$2e#$a1'?'#$00#$3d#$00#$10#$75) then
            (* Selbstlader *)
            (* OPTLOADER /SLR,SYMANTEC *)
            begin
              (* ab #$0a kommt nur noch 'alle rechte reserviert ...' *)
              ausschrift(puffer_zu_zk_e(xexe_codepuffer.d[$16],(*#0*)#$0a,(*200*)70),packer_exe);
            end;

          if bytesuche(xexe_codepuffer.d[0],#$55#$8b#$ec#$1e#$56#$57#$ff#$76#$08#$ff#$76#$06#$e8'??'#$8e#$46#$08) then
            (* Selbstlader *)
            (* Beispiel: SHREDDER95 1.0 *)
            ausschrift('Shrinker / Assembler Software Manufacturers Inc [3.3/4]',packer_exe);

          if bytesuche(xexe_codepuffer.d[0],#$55#$8b#$ec#$1e#$56#$57#$b8#$ff#$ff#$3d#$00#$10#$74#$0b#$ff#$76#$08) then
            (* Selbstlader *)
            (* Beispiel: CC32e403.o~~ *)
            ausschrift('BLINKER / Assembler Software Manufacturers Inc [? ¯]',packer_exe);


          if bytesuche(file_load_crc,'TNT') then
            (* Selbstlader, aber problematisch *)
            ausschrift('PKLite [2.01]',packer_exe);


          (*$IfNDef ENDVERSION*)
          if hersteller_gefunden then
            goto untersuche_ne_code_fertig;


          if not hersteller_gefunden then
            begin
              Dec(herstellersuche);
              ausschrift('cs:eip='+puffer_zu_zk_l(xexe_codepuffer.d[0],70),signatur);
              ausschrift('ds:000='+puffer_zu_zk_l(ds_puffer      .d[0],70),signatur);
              Inc(herstellersuche);
            end;
          (*$EndIf*)

       untersuche_ne_code_fertig:

          if (not hersteller_gefunden) and selbstlader then
            ausschrift(textz_xexe__selfload^,packer_exe);

          hersteller_gefunden:=hersteller_gefunden_sicherung;
          herstellersuche:=hersteller_suche_sicherung;

          (* <>0 : *.DLL mit Resourcen (ICO), ohne Code *)
          if n_exe_kopf.non_resident_name_offset<>0 then
            begin
              datei_lesen(namenpuffer,x_exe_basis
                                     +n_exe_kopf.non_resident_name_offset,256);

              exezk:=puffer_zu_zk_pstr(namenpuffer.d[0]);
              if exezk<>'' then
                begin
                  ausschrift_modulbeschreibung(exezk);
                  if Pos('WinZip',exezk)<>0 then
                    suche_nmc01sfx02_noetig:=wahr;
                end;

            end;

          (* Berechnung Ende NE *********************************************)

          if (n_exe_kopf.segtab_ofs>0) and (n_exe_kopf.segment_count>0) then
            begin
              x_exe_ende:=0;
              ne_relokationen:=false;

              for zaehler:=1 to n_exe_kopf.segment_count do
                begin
                  datei_lesen(namenpuffer,x_exe_basis
                                         +x_exe_ofs
                                         +n_exe_kopf.segtab_ofs
                                         +(zaehler-1)*8,8);

                  f2:=longint(word_z(@namenpuffer.d[0])^) shl n_exe_kopf.file_alignment_size_shift_count;
                  if f2<>0 then
                    begin
                      if word_z(@namenpuffer.d[2])^=0 then
                        IncDGT(f2,$10000)
                      else
                        IncDGT(f2,word_z(@namenpuffer.d[2])^);
                      if x_exe_ende<f2 then
                        begin
                          x_exe_ende:=f2;
                          ne_relokationen:=(word_z(@namenpuffer.d[4])^ and bit08)>0;
                        end;
                    end;

                end;

              if ne_relokationen then
                IncDGT(x_exe_ende,longint(x_word__datei_lesen(x_exe_basis+x_exe_ende))*8+2);
            end;

          Dec(herstellersuche);
          (* Resource? *)
          resource_summe:=0;
          if n_exe_kopf.resource_table_offset>0 then
            begin

              if  (n_exe_kopf.resident_name_table_offset>0)
              and (n_exe_kopf.resource_table_offset+n_exe_kopf.resource_table_entries*4
                  =n_exe_kopf.resident_name_table_offset)
               then
                begin (* OS/2 NE Resource *)
                  (* OS/2 ANSI.EXE keine Resource: *)
                  (* Resourcen als normale Objekte *)
                  if n_exe_kopf.resource_table_entries>0 then
                    begin
                      (* nur fÅr resource_anzeigen *)
                      resource_position:=x_exe_basis+x_exe_ofs+n_exe_kopf.resource_table_offset;

                      for zaehler:=1 to n_exe_kopf.resource_table_entries do
                        begin

                          resource_segment:=n_exe_kopf.segment_count
                                           -n_exe_kopf.resource_table_entries
                                           +zaehler;

                          (* logische LÑnge aus dem Segmenttabelleneintrag entnehmen *)
                          resource_laenge:=x_word__datei_lesen(
                            x_exe_basis
                           +x_exe_ofs
                           +n_exe_kopf.segtab_ofs
                           +(resource_segment-1)*8
                           +6); (* 2:image 6:alloc *)
                          if resource_anzeigen then
                            begin
                              datei_lesen(namenpuffer,resource_position,4);
                              IncDGT(resource_position,4);
                              os2_resource_ausschrift(word_z(@namenpuffer.d[0])^,word_z(@namenpuffer.d[2])^,resource_laenge);
                            end;

                          (* Pointer 1 *)
                          if ico_anzeige
                          and (word_z(@namenpuffer.d[0])^=$0001) and (icon1_zaehler=0) then
                            if resource_laenge<=SizeOf(q_entpackt_puffer_speicher) then
                              begin

                                z1:=0;
                                while z1<resource_laenge do
                                  begin
                                    z2:=resource_laenge-z1;
                                    if z2>SizeOf(namenpuffer.d) then
                                      z2:=SizeOf(namenpuffer.d);

                                    lade_ne(namenpuffer,resource_segment,z1);
                                    Move(namenpuffer.d,q_entpackt_puffer_speicher[z1],z2);
                                    Inc(z1,z2);
                                  end;

                                quelle_kopie:=quelle;
                                quelle.sorte:=q_entpackt_puffer;
                                quelle.entpackt_laenge:=resource_laenge;
                                os2_ico(0,absatz);
                                quelle:=quelle_kopie;

                                icon1_zaehler:=1;
                              end;

                          IncDGT(resource_summe,resource_laenge); (* +8 Byte wenn in .RES *)
                        end;
                      ausschrift(leer_filter(strxDGT(resource_summe,11))+textz_xexe__byte_resource1^
                        +str0(n_exe_kopf.resource_table_entries)+textz_xexe__byte_resource2^,compiler);
                    end;

                end
              else (* nicht OS/2 NE Resource *)
                begin
                  resource_zaehler:=0;
                  resource_position:=x_exe_basis+x_exe_ofs+n_exe_kopf.resource_table_offset;
                  resource_alignment:=1 shl x_word__datei_lesen(resource_position);
                  IncDGT(resource_position,2);
                  repeat
                    datei_lesen(namenpuffer,resource_position,2+2+4);
                    IncDGT(resource_position,2+2+4);
                    (* "0000" -> Ende? *)
                    res_typ_id:=word_z(@namenpuffer.d[0])^;
                    if res_typ_id=$0000 then break;
                    anzahl_resource_dieses_types:=word_z(@namenpuffer.d[2])^;
                    for zaehler:=1 to anzahl_resource_dieses_types do
                      begin
                        Inc(resource_zaehler);
                        datei_lesen(namenpuffer,resource_position,12);

                        IncDGT(resource_position,12);
                        resource_laenge:=word_z(@namenpuffer.d[2])^*resource_alignment; (* INTERR: LÑnge in Byte ??? *)
                        IncDGT(resource_summe,resource_laenge);


                        if  (word_z(@namenpuffer.d[0])^>0)
                        and (word_z(@namenpuffer.d[2])^>0)
                         then
                          begin
                            l0:=longint(word_z(@namenpuffer.d[0])^)*resource_alignment;
                            f2:=longint(word_z(@namenpuffer.d[2])^)*resource_alignment;

                            schon_angezeigt:=false;
                            resource_zeile_berechnen_ne;

                            if resource_anzeigen then
                              resource_position_ausgeben_ne;

                            (* ICON 1 *)
                            if ico_anzeige
                            and (res_typ_id=$8003) and (icon1_zaehler=0) then
                              windows_ico1(x_exe_basis+l0,resource_laenge,true,1);

                            if res_typ_id=$8010 then
                              msw_versionsinfo_resource_sb(x_exe_basis+l0,f2);

                            if  (res_typ_id=$8000+1024)
                            and (integer_oder_res_name(word_z(@namenpuffer.d[6])^)='MYRESOURCE') then
                              begin
                                resource_position_ausgeben_ne;
                                myresource_1024_installshield(x_exe_basis+l0,f2,false);
                              end;

                            if res_typ_id=$8000+8 then
                              begin
                                resource_position_ausgeben_ne;
                                font_windows(x_exe_basis+l0,f2);
                              end;


                            IncDGT(f2,l0);

                            if x_exe_ende<f2 then
                              begin
                                (* DATENF~1.EXE Resourcenalign=$100 aber letzte Resource nur $56 Byte *)
                                if  (resource_alignment>1)
                                and (x_exe_ofs+einzel_laenge<f2)
                                and (x_exe_ofs+einzel_laenge>longint(word_z(@namenpuffer.d[0])^)*resource_alignment) then
                                  f2:=x_exe_ofs+einzel_laenge;

                                x_exe_ende:=f2;
                              end;
                          end;
                      end;
                  until false;

                  if resource_summe>0 then
                    (*ausschrift(strx(resource_summe,0)+textz_xexe__byte_resource^,compiler);*)
                    ausschrift(leer_filter(strxDGT(resource_summe,11))+textz_xexe__byte_resource1^
                      +str0(resource_zaehler)+textz_xexe__byte_resource2^,compiler);
                end;

            end; (* Resourceofs>0 *)
          Inc(herstellersuche);


          if (n_exe_kopf.segtab_ofs>0) and (n_exe_kopf.segment_count>0) then
            begin
              (* Auf volle Seiten runden: C:\BP\BIN\BP.EXE *)
              x_exe_fuellnullen(1 shl n_exe_kopf.file_alignment_size_shift_count);

              if x_exe_ende>0 then
                einzel_laenge:=x_exe_ende-x_exe_ofs;

            end;


          if suche_nmc01sfx02_noetig then
            suche_winzip_tabelle(x_exe_ofs,x_exe_ofs+einzel_laenge);

        end; (* NE/NF *)


    (*************************************************************)

    (*
         €€€€€€    €€€€€€€€
         €€  €€    €€
         €€€€€€    €€€€€€€€
         €€        €€
         €€        €€€€€€€€
                                                                 *)


    if (xx_sig='PE')
     then
      begin
        ausschrift(textz_Erweiterte^+' [32] EXE "'+xx_sig+textz_xexe__ab^+strx_oder_hexDGT(0+x_exe_basis+x_exe_ofs),signatur);
        coff(x_exe_basis,x_exe_ofs+4,x_exe_ende);

        x_exe_fuellnullen(4096);

        if x_exe_ende<>0 then
          einzel_laenge:=x_exe_ende-x_exe_ofs;

      end;

    (*************************************************************)

    (*
         €€      €€€€€€
         €€      €€
         €€      €€
         €€      €€
         €€€€€€  €€€€€€
                                                                 *)

    if (xx_sig='LC') then
      begin
        if bytesuche(nexepuffer.d[2],#$00#$00) then (* byte_order / word_order *)
          begin
            ausschrift(textz_Erweiterte^+' [32] EXE "LC'+textz_xexe__ab^+strx_oder_hexDGT(0+x_exe_basis+x_exe_ofs),signatur);
            ausschrift('SC/32A / Supernar Systems',packer_exe);
          end;

        if nexepuffer.d[2]=ord('1') then (* POWERQEST PARTIOTION MAGIC DEMO 4 *)
          begin
            ausschrift(textz_Erweiterte^+' [32] EXE "'+puffer_zu_zk_l(nexepuffer.d[0],4)+textz_xexe__ab^
              +strx_oder_hexDGT(0+x_exe_basis+x_exe_ofs),signatur);
            ausschrift('? / ? (inflate 1.1.2 / Mark Adler)',packer_exe);
          end;
      end;

    (*************************************************************)

    (*
         €€      €€      €€        €€      €€€€€€
         €€        €€  €€          €€      €€
         €€          €€            €€      €€€€€€
         €€        €€  €€          €€      €€
         €€€€€€  €€      €€        €€€€€€  €€€€€€
                                                                 *)

    if (xx_sig='LE')
    or (xx_sig='LX')
     then
      begin
        bdsap_suchen:=false;
        (* wenn 'MZ'+$3c nichts eingetragen ist .. *)
        (* z.B. LSXPOWER.EXE *)
        if  (x_exe_ofs=0)
        and (x_exe_basis>1500) then
          begin
            (* vom "Dateianfang" ist mindestens erreicht? *)
            if (l_exe_kopf.data_pages_offset>x_exe_basis) then
              begin
                x_exe_ofs:=x_exe_basis;
                x_exe_basis:=0;
              end;
          end;

        (* DOS4GW "PRO" hat den DOS4GW-Vorspann, dann Watcom-DOS, dann 32-Bit *)
        (* Lîsung: DOS4GW ausbauen *)
        if (xx_sig='LE') and (x_exe_basis>0) and (x_exe_basis<1000000) then
          if datei_pos_suche(0,MinDGT(x_exe_basis,4096),'DOS/4G')<>nicht_gefunden then
            befehl_schnitt(x_exe_basis,dateilaenge-x_exe_basis,erzeuge_neuen_dateinamen('.COM'));



        x_exe_ende:=0;

        ausschrift(textz_Erweiterte^+' [32] EXE "'+xx_sig+textz_xexe__ab^+strx_oder_hexDGT(0+x_exe_basis+x_exe_ofs),signatur);

        case nexepuffer.d[$0A] of
          $00:exezk:=textz_Zielsystem_unbekannt^;
          $01:exezk:=textz_Zielsystem_OS2^;
          $02:exezk:=textz_Zielsystem_Windows^;
          $03:exezk:=textz_Zielsystem_MS_DOS_4x^;
          $04:exezk:=textz_Zielsystem_Windows_386^;
          $05:exezk:=textz_Zielsystem_Borland_Operating_System_Services^;
          $2c:exezk:=textz_Zielsystem_Phar_Lap_DOS_Extender_286_OS2^;
        else
          exezk:=textz_Zielbetriebssystem_Nr^+str0(nexepuffer.d[$0a]);
        end;

        packexe_patch:=false;
        case nexepuffer.d[$08] of
          $01:exezk_anhaengen(' [80286+]');
          $02:exezk_anhaengen(' [80386+]');
          $03:exezk_anhaengen(' [80486+]');
          $04:exezk_anhaengen(' [80586+]');
          $20:exezk_anhaengen(' [Intel i860 (N10)]');
          $21:exezk_anhaengen(' [Intel "N11"]');
          $40:exezk_anhaengen(' [MIPS Mark I (R2000, R3000)]');
          $41:exezk_anhaengen(' [MIPS Mark II (R6000)]');
          $42:exezk_anhaengen(' [MIPS Mark III (R4000)]');

        else
          if  bytesuche(nexepuffer.d[$08],#$eb#$7f) and (nexepuffer.d[$89]=$e9) then
            begin
              exezk_anhaengen(' [CPU=?,packexe/Andrew Belov]');
              packexe_patch:=true;
              (* Position+Grî·e der letzten Seite->Position der nonresident name table *)
              l_exe_kopf.non_resident_name_offset:=DGT_zu_longint(berechne_x_exe_ende1);
            end
          else
            exezk_anhaengen(' [CPU='+str0(nexepuffer.d[$08])+'???]');
        end;



        api_info:=longint_z(@nexepuffer.d[$10])^;

        (* case (api_info and (bit08+bit09+bit10)) div bit08 of*)
        case nexepuffer.d[$11] and (bit02+bit01+bit00) of
          1:exezk_anhaengen(textz_klammer_Vollbild_klammer^);
          2:exezk_anhaengen(textz_klammer_PM_kompatibel_klammer^);
          3:exezk_anhaengen(textz_klammer_PM_klammer^);
        end;

        case (api_info shr 15) and (bit02+bit01+bit00) of
           0:; (* Programm                                              $00000000 *)
           1,  (* DLL                                                   $00008000 *)
        (* 2:     ???                                                   $00010000 *)
           3:exezk_anhaengen(textz_klammer_Bibliothek_klammer^);     (* $00018000 Protected memory *)
           4:exezk_anhaengen(textz_klammer_PHYS_DEV_klammer^);       (* $00020000 *)
           5,(* Warp 4, VP 2.0 *)                                    (* $00028000 *)
           6:(* INTERRUPT LIST *)                                    (* $00030000 *)
             exezk_anhaengen(textz_klammer_VIRT_DEV_klammer^);
           7:exezk_anhaengen('[VXD Windows 386?]'); (* xfse.zip *)
        else
            exezk_anhaengen('[¯ MT='+hex_longint(api_info)+']');
        end;

        ausschrift(exezk,signatur);

        (* die meisten 0 oder 2.0 oder 2.2
        if longint_z(@nexepuffer.d[$0c])^<>0 then
          ausschrift('Version: '+str(word_z(@nexepuffer.d[$0c+2])^,0)+'.'+str(word_z(@nexepuffer.d[$0c])^,0),signatur);*)


        lx_ende_nonres_name:=0;

        if  (l_exe_kopf.non_resident_name_offset>0)
        and (l_exe_kopf.non_resident_name_offset<dateilaenge)
        and (l_exe_kopf.non_resident_name_length>0)
         then
          begin
            datei_lesen(namenpuffer,x_exe_basis+l_exe_kopf.non_resident_name_offset,256);

            lx_ende_nonres_name:=l_exe_kopf.non_resident_name_offset
                                +l_exe_kopf.non_resident_name_length;

            if namenpuffer.d[0]>0 then
              if bytesuche(namenpuffer.d[namenpuffer.d[0]+1],#$00#$00) then (* Index 0 ... Beschreibung *)
                begin
                  ausschrift_modulbeschreibung(puffer_zu_zk_pstr(namenpuffer.d[0]));
                  (*ausschrift('"'+puffer_zu_zk_pstr(namenpuffer.d[0])+'"',beschreibung);*)
                  if puffer_gefunden(namenpuffer,'Boot Disk Selfextractor') then
                    bdsap_suchen:=true;
                end;
          end;


        if (xx_sig='LX') and langformat (* and (api_info and (bit15+bit16+bit17)=0)*) then
          begin
            x_exe_ende:=berechne_x_exe_ende1;

            if x_exe_ende<lx_ende_nonres_name then
              x_exe_ende:=lx_ende_nonres_name;

            if x_exe_ende<l_exe_kopf.non_resident_name_offset
                         +l_exe_kopf.non_resident_name_length then
              x_exe_ende:=l_exe_kopf.non_resident_name_offset
                         +l_exe_kopf.non_resident_name_length;


            if rle_kompression or lzw_kompression then
              begin
                if rle_kompression then ausschrift('RLE-'+textz_xexe__komprimiert^+' [/EXEPACK:1] ',packer_exe);
                if lzw_kompression then ausschrift('LZ-' +textz_xexe__komprimiert^+' [/EXEPACK:2] ',packer_exe);
              end;

            if (l_exe_kopf.page_size=4096) {and (api_info and (bit15+bit16+bit17)=0)}
            and (l_exe_kopf.cs_obj<>0)
             then
              untersuche_lx_le_code('LX'='LX');

            if l_exe_kopf.debug_info_laenge<>0 then
              begin
                if l_exe_kopf.debug_info_laenge>4 then
                  begin
                    ausschrift(strx(l_exe_kopf.debug_info_laenge,0)+textz_xexe__byte_debuginfo^,compiler);
                    untersuche_debuginfo(x_exe_basis+l_exe_kopf.debug_info_ofs,l_exe_kopf.debug_info_laenge);
                  end;
                if x_exe_ende<l_exe_kopf.debug_info_ofs
                             +l_exe_kopf.debug_info_laenge then
                  x_exe_ende:=l_exe_kopf.debug_info_ofs
                             +l_exe_kopf.debug_info_laenge;


              end;

            if x_exe_ende<>0 then
              einzel_laenge:=x_exe_ende-x_exe_ofs;

            if packexe_patch then
              merke_position(x_exe_ende,datentyp_packexe);

            (* Resourcen *)
            with l_exe_kopf do
              if xx_sig='LX' then
                if resource_table_entries<>0 then
                  resource_lx(x_exe_basis+x_exe_ofs+resource_table_offset,resource_table_entries,
                    bytesuche__datei_lesen(x_exe_basis+x_exe_ofs+resident_name_offset,#$0b'STUBINSTALL'));

          end;

        if (xx_sig='LE') and langformat {and ((api_info and (bit15+bit16+bit17))=0)} then
          begin
            anzahl_object_map_table:=0;
            x_exe_ende:=l_exe_kopf.data_pages_offset;

            for zaehler:=1 to l_exe_kopf.object_table_entrys do
              IncDGT(x_exe_ende,x_longint__datei_lesen(x_exe_basis
                              +x_exe_ofs+l_exe_kopf.offset_of_object_table+(zaehler-1)*$18
                              +$10)*l_exe_kopf.page_size);

            (* LE: "bytes on last page" *)
            IF l_exe_kopf.page_shift_count<>0 then
              DecDGT(x_exe_ende,l_exe_kopf.page_size-l_exe_kopf.page_shift_count);

            if x_exe_ende<l_exe_kopf.non_resident_name_offset
                         +l_exe_kopf.non_resident_name_length then
              x_exe_ende:=l_exe_kopf.non_resident_name_offset
                         +l_exe_kopf.non_resident_name_length;


            if (l_exe_kopf.page_size=4096) and (api_info and (bit15+bit16+bit17)=0) then
              untersuche_lx_le_code('LX'='LE');

            if l_exe_kopf.debug_info_laenge<>0 then
              begin
                if l_exe_kopf.debug_info_laenge>4 then
                  begin
                    ausschrift(strx(l_exe_kopf.debug_info_laenge,0)+textz_xexe__byte_debuginfo^,compiler);
                    untersuche_debuginfo(x_exe_basis+l_exe_kopf.debug_info_ofs,l_exe_kopf.debug_info_laenge);
                  end;

                if x_exe_ende<l_exe_kopf.debug_info_ofs
                             +l_exe_kopf.debug_info_laenge then
                  x_exe_ende:=l_exe_kopf.debug_info_ofs
                             +l_exe_kopf.debug_info_laenge;

              end;

            (* Resource nicht extra: bereits als normale Seiten berechnet *)

            (* VXD VERSIONINFO *)
            if  (l_exe_kopf.offset_versioninfo_vxd<>0)
            and (l_exe_kopf.target_operating_system=$04) (* MSW LE *)
             then
              begin
                vxd_laenge:=x_longint__datei_lesen(x_exe_basis+l_exe_kopf.offset_versioninfo_vxd+8);
                if  (x_exe_ende<=l_exe_kopf.offset_versioninfo_vxd)
                and (vxd_laenge>  100)
                and (vxd_laenge<10000)
                 then
                  x_exe_ende:=l_exe_kopf.offset_versioninfo_vxd
                             +x_longint__datei_lesen(x_exe_basis+l_exe_kopf.offset_versioninfo_vxd+8)
                             +12;
              end;

            if x_exe_ende<>0 then
              einzel_laenge:=x_exe_ende-x_exe_ofs;

          end;

      end;


    x_exe_vorhanden:=false;
    x_exe_basis:=0;
    x_exe_ofs:=0;
  end;


var
  vorgegebene_laenge_des_resourcebereiches:longint;

procedure coff(const coff_basis,coff_ofs:dateigroessetyp;var coff_ende:dateigroessetyp);
  (* coff_ende=logische lÑnge mit coff_ofs *)
  label
    weiter_pe;
  var
    di_puffer,
    coff_puffer,
    coff_puffer2        :puffertyp;
    anzahl_obj,
    obj_nummer          :word_norm;
    code_start          :longint;
    coff_ende_test      :longint;
    perules_bits        :longint;
    o                   :dateigroessetyp;
    eip_pos             :longint;
    imagebase           :longint;
    sprung_zaehler      :word_norm;
    pelocknt_code_zaehler:word_norm;

    resource_summe      :dateigroessetyp;
    resource_zaehler    :longint;
    resource_fehler     :longint;
    resource_ende       :dateigroessetyp;
    versionsinfo_zaehler:longint;
    icon1_zaehler       :byte;

    l1                  :longint;

    write_executable    :boolean;

  function object_bit(const adr_:longint):longint;
    var
      op                :puffertyp;
      obj_zaehler       :longint;
    begin
      for obj_zaehler:=1 to anzahl_obj do
        begin
          datei_lesen(op,o+word_z(@di_puffer.d[$10])^+$14+(obj_zaehler-1)*$28,$28);

          if  (adr_>=longint_z(@op.d[$0c])^)
          and (adr_< longint_z(@op.d[$0c])^+longint_z(@op.d[$10])^) then
            begin
              object_bit:=longint_z(@op.d[$24])^;
              Exit;
            end;
        end;
      object_bit:=0;
    end;

  function berechne_datei_position(const adr_:longint):dateigroessetyp;
    var
      op                :puffertyp;
      obj_zaehler       :longint;
    begin
      for obj_zaehler:=1 to anzahl_obj do
        begin
          datei_lesen(op,o+word_z(@di_puffer.d[$10])^+$14+(obj_zaehler-1)*$28,$28);

          if  (adr_>=longint_z(@op.d[$0c])^)
          and (adr_< longint_z(@op.d[$0c])^+longint_z(@op.d[$10])^) then
            begin
              berechne_datei_position:=
                          coff_basis
                         +longint_z(@op.d[$14])^
                         -longint_z(@op.d[$0c])^
                         +adr_;
              Exit;
            end;
        end;

      berechne_datei_position:=-1;
      Inc(resource_fehler);

    end; (* berechne_datei_position *)

  procedure lade_code(const eip_:longint;var pp:puffertyp);
    var
      dp                :dateigroessetyp;
    begin
      dp:=berechne_datei_position(eip_);
      if dp=-1 then
        FillChar(pp,SizeOf(pp),0)
      else
        datei_lesen(pp,dp,512);
    end; (* lade_code *)

  procedure lade_daten(const adr_:longint;var pp:puffertyp;const l:word_norm);
    var
      dp                :dateigroessetyp;
    begin
      dp:=berechne_datei_position(adr_);
      if dp=-1 then
        FillChar(pp,SizeOf(pp),0)
      else
        datei_lesen(pp,dp,l);
    end; (* lade_daten *)

  procedure msw_versionsinfo_resource_db(const start,laenge:dateigroessetyp);
    var
      o                 :dateigroessetyp;
      l                 :word_norm;
      z                 :string;
      p                 :puffertyp;
      nicht_binaer      :boolean;
    (*kein_db_inhalt    :boolean;*)
    begin
      (*o:=$98;*)
      o:=$5c;
      (*kein_db_inhalt:=false;*)
      repeat

        IncDGT(o,2);
        l:=x_word__datei_lesen(start+o);
        IncDGT(o,2);

        nicht_binaer:=(byte__datei_lesen(start+o)=1);
        IncDGT(o,2);

        z:=uc16_datei_lesen__zu_zk_e(start+o,#0,80);
        IncDGT(o,2*Length(z)+1+3);
        o:=AndDGT(o,-4);

        (*$IfDef DEBUG*)
        ausschrift(z,normal);
        (*$EndIf*)

        if (z='FileDescription')
        or (z='Description')
        or (z='Comments')
        (*$IfDef DEBUG*)
        or true
        (*$EndIf*)
         then
          begin

            if byte__datei_lesen(start+o+1)<>0 then
            (*
            if not kein_db_inhalt then
              if (byte__datei_lesen(start+o+1)<>0) then ( * WISE  SETUP * )
                kein_db_inhalt:=true;
            if kein_db_inhalt then*)
              z:=     datei_lesen__zu_zk_e(start+o,#0,l)
            else
              z:=uc16_datei_lesen__zu_zk_e(start+o,#0,l);

            if z<>'' then
              ausschrift(in_doppelten_anfuerungszeichen(z),beschreibung);
          end;

        if l<>0 then
          if nicht_binaer then
            IncDGT(o,l*2+3)
          else
            IncDGT(o,l  +3);

        o:=AndDGT(o,-4);

      until o>=laenge;

    end; (* msw_versionsinfo_resource_db *)


  procedure pe_resourcen4(const o:longint;const typ:string;const name_:string{(*};sprache:longint{*)}); (* alles bekannt *)
    var
      resource_eintrag  :puffertyp;
      oe                :dateigroessetyp;
      reofs             :dateigroessetyp;
      relae             :dateigroessetyp;
      zk                :string;
      f1                :dateigroessetyp;
      schon_angezeigt   :boolean;

    procedure resource_position_ausgeben; (* Die Sprache wird nicht angezeigt *)
      var
        zk              :string;
        typ_ord         :longint;
        kontrolle       :integer_norm;
        ergebnisname    :string;
      begin

        if not schon_angezeigt then
          begin
            Val(typ,typ_ord,kontrolle);
            if (kontrolle=0) then
              begin
                zk:=textz_xexe__res_TYP^+windows_resourcetyp_namen(typ_ord);
                ergebnisname:=windows_resourcetyp_namen(typ_ord);
              end
            else
              begin
                zk:=textz_xexe__res_TYP^+typ;
                ergebnisname:=typ;
              end;


            ergebnisname:=trenne_pfad_ab(dateiname)+'.'+ergebnisname+'.'+name_;
            (*if sprache<>0 then
              ergebnisname:=ergebnisname+'.'+Str0(sprache);*)
            if sprache and (1 shl 10-1)<>0 then
              ergebnisname:=ergebnisname+'.'+win32_languagecode(sprache);

            leerzeichenerweiterung(zk,20);
            zk:=zk+textz_xexe__res_Name^+name_;
            leerzeichenerweiterung(zk,20+20);
            ausschrift(zk
              +textz_xexe__res_posi^+str9_oder_hex(DGT_zu_longint(reofs))
              +textz_xexe__res_laenge^+str9_oder_hex(DGT_zu_longint(relae)),musik_bild);
            {besser mit Punkt...}

            befehl_schnitt(reofs,relae,ergebnisname);
            schon_angezeigt:=true;
          end;

      end; (* resource_position_ausgeben *)

    begin (* pe_resourcen4 *)
      schon_angezeigt:=false;
      oe:=berechne_datei_position(o);
      datei_lesen(resource_eintrag,oe,3*4);
      resource_ende:=MaxDGT(resource_ende,oe+4*4);

      (* 0: DATA RVA
         4: SIZE
         8: CODEPAGE *)
      reofs:=berechne_datei_position(longint_z(@resource_eintrag.d[0])^);
      relae:=                        longint_z(@resource_eintrag.d[4])^;

      resource_ende:=MaxDGT(resource_ende,reofs+relae);

      if resource_anzeigen then
        resource_position_ausgeben;

      (*        1       CURSOR
                2       BITMAP
                3       ICON
                4       MENU
                5       DIALOG
                6       STRING
                7       FONTDIR
                8       FONT
                9       ACCELERATORS
               10       RCDATA
               11       MESSAGETABLE
               12       GROUP_CURSOR
               13       ?
               14       GROUP_ICON
               15       ?
               16       VERSION
               17       ?
               18       ?
               19       ?
               20       ?
               21       Animated cursor
               22       Animated icon           *)

      if (reofs<>-1) then
        begin

          (* icon *)
          if ((typ='3') and ((name_='1') or resource_anzeigen))
          (*or ((typ='1') and resource_anzeigen)*)
           then
            if ico_anzeige
            and (icon1_zaehler=0)
            or ((textz_xexe__sprache^='D') and (sprache=$0407))
            or ((textz_xexe__sprache^='E') and (sprache=$0409))
            or resource_anzeigen
            (*$IfDef DEBUG*)
            (*or true*)
            (*$EndIf*)
             then
              begin
                windows_ico1(reofs,relae,true,1);
                icon1_zaehler:=1;
              end;

          if typ='10' then
            begin
              datei_lesen(resource_eintrag,reofs,$20);

              if name_='101' then (* WISE:EXE in der EXE .. *)
                if bytesuche(resource_eintrag.d[0],'MZ????'#$00#$00#$04#$00) (* PE+PE *)
                or bytesuche(resource_eintrag.d[0],'MZ??'#$03#$00#$03#$00#$20#$00) (* PE+NE *)
                 then
                  begin
                    resource_position_ausgeben;
                    f1:=vorgegebene_laenge_des_resourcebereiches-reofs
                       +berechne_datei_position(longint_z(@di_puffer.d[$88-4])^);
                    ausschrift('WISE SETUP EXE->EXE ('+strxDGT(f1,11)+'?)',packer_dat);
                    befehl_schnitt(reofs,f1,erzeuge_neuen_dateinamen('.WISE.EXE'));
                  end;

              if bytesuche(resource_eintrag.d[0],'MSCF') then
                begin
                  resource_position_ausgeben;
                  mscf(reofs,relae);
                end;
            end; (* Typ='10' *)


          if typ='16' then
            begin
              if (versionsinfo_zaehler=0)
              or ((textz_xexe__sprache^='D') and (sprache=$0407))
              or ((textz_xexe__sprache^='E') and (sprache=$0409))
              (*$IfDef DEBUG*)
              or true
              (*$EndIf*)
               then
                msw_versionsinfo_resource_db(reofs,relae);
              Inc(versionsinfo_zaehler);
            end;

          if typ='99' then (* CEXE 1.0a *)
            begin
              resource_position_ausgeben;
              datei_lesen(resource_eintrag,reofs,$20);

              if bytesuche(resource_eintrag.d[0],'SZDD') then
                begin
                  compress_ms(resource_eintrag,reofs,relae,'');
                end;
            end;

          if (typ='1024') and (name_='MYRESOURCE') then
            begin
              resource_position_ausgeben;
              myresource_1024_installshield(reofs,relae,false);
            end;

          if (typ='FILE') and (relae>=$10) then
            begin
              datei_lesen(resource_eintrag,reofs,$20);
              if longint_z(@resource_eintrag.d[0])^+8=relae then
                begin (* netscape *)
                  resource_position_ausgeben;
                  n6setup_gepackte_datei(reofs,relae,name_);
                end
              else
              if bytesuche(resource_eintrag.d[0],'MZ') then
                begin (* wsupdate *)
                  resource_position_ausgeben;
                  ausschrift_x('EXE/DLL/..',packer_dat,absatz);
                end
            end;

          if (typ='BINARY') and (name_='ARCHIVE') then
            begin
              resource_position_ausgeben;
              rzt_realnetworks(reofs,relae);
            end;

          (* DLGDiag.exe: 1,4M gepacketes Diskettenabbild *)
          if (relae>25000) and (typ='10'{'RC Data'}) then
            resource_position_ausgeben;

          if (typ='RCFILE') (* cd6012.exe: touchstone CardServices *)
          or (typ='BINARY') (* AOL 2003.03D \install\aol\setup.exe 36MB *)
           then
            begin
              resource_position_ausgeben;
              datei_lesen(resource_eintrag,reofs,$20);
              if bytesuche(resource_eintrag.d[0],'MZ') then
                ausschrift_x('EXE/DLL/..',packer_dat,absatz);
            end;

          if typ='CUSTOM' then (* I-Worm.Gibe.b 2003.03.24 *)
            begin
              datei_lesen(resource_eintrag,reofs,$20);
              if bytesuche(resource_eintrag.d[0],'SZDD') then
                begin
                  resource_position_ausgeben;
                  compress_ms(resource_eintrag,reofs,relae,'');
                end;
            end;

          if typ='RAWDATA' then
            begin
              resource_position_ausgeben;
              ashampoo_rawdata(reofs,relae);
            end;

          if typ='DEFLATEDATA' then (* WinImage / Gilles Vollant 4.0 *)
            begin
              resource_position_ausgeben;
              befehl_e_infla(reofs,relae,name_);
            end;

          (* nur sinnvol wenn auch zugreifbar *)
          IncDGT(resource_summe,AndDGT(relae+3,-4)); (* auf 32 Bit ausgerichtet *)
        end;

      (* ZÑhler muss auch die Fehler enthalten *)
      Inc(resource_zaehler);

    end; (* pe_resourcen4 *)

  function rzk(const o,pchar_oder_id:longint):string;
    var
      od                :dateigroessetyp;
      np                :puffertyp;
    begin
      if (pchar_oder_id and $80000000)<>0 then
        begin
          od:=berechne_datei_position(o+pchar_oder_id-$80000000);
          datei_lesen(np,od,512);
          rzk:=uc16_puffer_zu_zk_e(np.d[2],#0,np.d[0]);
          resource_ende:=MaxDGT(resource_ende,od+np.d[0]*2+2);
        end
      else
        rzk:=str0(pchar_oder_id);
    end; (* rzk *)

  procedure pe_resourcen3(const o0,o:longint;const typ:string;const name_:string); (* nach Sprache *)
    var
      anzahl_namen      :longint;
      anzahl_id         :longint;
      o_dir             :dateigroessetyp;
      res_dirp3         :puffertyp;

    begin
      o_dir:=berechne_datei_position(o);
      if (o_dir<0) or (o_dir>analyseoff+einzel_laenge) then
        begin
          Inc(resource_fehler);
          Exit;
        end;
      datei_lesen(res_dirp3,o_dir,$10);
      IncDGT(o_dir,$10);

      anzahl_namen:=word_z(@res_dirp3.d[$c])^;
      anzahl_id   :=word_z(@res_dirp3.d[$e])^;

      while anzahl_namen>0 do
        begin
          datei_lesen(res_dirp3,o_dir,2*4);

          if (res_dirp3.d[4+3] and $80)<>0 then
            (*Fehler*)
          else
            pe_resourcen4(   o0+longint_z(@res_dirp3.d[4])^          ,typ,name_,longint_z(@res_dirp3.d[0])^);

          IncDGT(o_dir,2*4);
          Dec(anzahl_namen);
        end;

      while anzahl_id>0 do
        begin
          datei_lesen(res_dirp3,o_dir,2*4);

          if (res_dirp3.d[4+3] and $80)<>0 then
            (*Fehler*)
          else
            pe_resourcen4(   o0+longint_z(@res_dirp3.d[4])^          ,typ,name_,longint_z(@res_dirp3.d[0])^);

          IncDGT(o_dir,2*4);
          Dec(anzahl_id);
        end;
    end; (* pe_resourcen3 *)

  procedure pe_resourcen2(const o0,o:longint;const typ:string); (* nach Name *)
    var
      anzahl_namen      :longint;
      anzahl_id         :longint;
      o_dir             :dateigroessetyp;
      res_dirp2         :puffertyp;

      alt_zk ,neu_zk    :string;
      alt_int,neu_int   :longint;

    begin
      o_dir:=berechne_datei_position(o);
      if (o_dir<0) or (o_dir>analyseoff+einzel_laenge) then
        begin
          Inc(resource_fehler);
          Exit;
        end;
      datei_lesen(res_dirp2,o_dir,$10);
      IncDGT(o_dir,$10);

      anzahl_namen:=word_z(@res_dirp2.d[$c])^;
      anzahl_id   :=word_z(@res_dirp2.d[$e])^;

      if (anzahl_namen>$00ffffff) or (anzahl_id>$00ffffff)
      or ((anzahl_namen+anzahl_id)*2*4>vorgegebene_laenge_des_resourcebereiches)
       then
        begin
          Inc(resource_fehler);
          anzahl_namen:=0;
          anzahl_id   :=0;
        end;

      alt_zk:='';

      while anzahl_namen>0 do
        begin
          datei_lesen(res_dirp2,o_dir,2*4);

          neu_zk:=rzk(o0,longint_z(@res_dirp2.d[0])^);
          if neu_zk<alt_zk then Break;

          if (res_dirp2.d[4+3] and $80)<>0 then
            pe_resourcen3(o0,o0+longint_z(@res_dirp2.d[4])^-$80000000,typ,neu_zk)
          else
            pe_resourcen4(   o0+longint_z(@res_dirp2.d[4])^          ,typ,neu_zk,0);

          alt_zk:=neu_zk;

          IncDGT(o_dir,2*4);
          Dec(anzahl_namen);
        end;

      alt_int:=0;

      while anzahl_id>0 do
        begin
          datei_lesen(res_dirp2,o_dir,2*4);

          neu_int:=longint_z(@res_dirp2.d[0])^;
          if neu_int<alt_int then Break;

          if (res_dirp2.d[4+3] and $80)<>0 then
            pe_resourcen3(o0,o0+longint_z(@res_dirp2.d[4])^-$80000000,typ,rzk(o0,neu_int))
          else
            pe_resourcen4(   o0+longint_z(@res_dirp2.d[4])^          ,typ,rzk(o0,neu_int),0);

          alt_int:=neu_int;

          IncDGT(o_dir,2*4);
          Dec(anzahl_id);
        end;

    end; (* pe_resourcen2 *)

  procedure pe_resourcen1(const o:longint); (* nach Typ *)
    var
      anzahl_namen      :longint;
      anzahl_id         :longint;
      o_dir             :dateigroessetyp;
      o_dir0            :dateigroessetyp;
      res_dirp1         :puffertyp;

      alt_zk ,neu_zk    :string;
      alt_int,neu_int   :longint;

    label
      resource_fehler_zeigen;

    begin
      Dec(herstellersuche);

      versionsinfo_zaehler:=0;
      icon1_zaehler:=0;
      o_dir0:=berechne_datei_position(o);
      if (o_dir0<0) or (o_dir0>analyseoff+einzel_laenge) then
        begin
          Inc(resource_fehler);
          goto resource_fehler_zeigen;
        end;

      o_dir:=o_dir0;
      datei_lesen(res_dirp1,o_dir,$10);
      IncDGT(o_dir,$10);

      resource_summe  :=0;
      resource_zaehler:=0;
      resource_fehler :=0;
      resource_ende   :=0;

      anzahl_namen:=word_z(@res_dirp1.d[$c])^;
      anzahl_id   :=word_z(@res_dirp1.d[$e])^;

      if (anzahl_namen>$00ffffff) or (anzahl_id>$00ffffff)
      or ((anzahl_namen+anzahl_id)*2*4>vorgegebene_laenge_des_resourcebereiches)
       then
        begin
          Inc(resource_fehler);
          anzahl_namen:=0;
          anzahl_id   :=0;
        end;

      alt_zk:='';

      while anzahl_namen>0 do
        begin
          datei_lesen(res_dirp1,o_dir,2*4);

          neu_zk:=rzk(o,longint_z(@res_dirp1.d[0])^);
          if neu_zk<alt_zk then Break;

          if (res_dirp1.d[4+3] and $80)<>0 then
            pe_resourcen2(o,o+longint_z(@res_dirp1.d[4])^-$80000000,neu_zk)
          else
            pe_resourcen4(  o+longint_z(@res_dirp1.d[4])^          ,neu_zk,'',0);

          alt_zk:=neu_zk;

          IncDGT(o_dir,2*4);
          Dec(anzahl_namen);
        end;

      alt_int:=0;

      while anzahl_id>0 do
        begin
          datei_lesen(res_dirp1,o_dir,2*4);

          neu_int:=longint_z(@res_dirp1.d[0])^;
          if neu_int<alt_int then Break;

          if (res_dirp1.d[4+3] and $80)<>0 then
            pe_resourcen2(o,o+longint_z(@res_dirp1.d[4])^-$80000000,rzk(o,neu_int))
          else
            pe_resourcen4(  o+longint_z(@res_dirp1.d[4])^          ,rzk(o,neu_int),'',0);

          alt_int:=neu_int;

          IncDGT(o_dir,2*4);
          Dec(anzahl_id);
        end;

  resource_fehler_zeigen:

      if resource_zaehler>0 then
        begin
          archiv_summe_wenn_noetig;(* n6setup.exe *)

          ausschrift(leer_filter(strxDGT(resource_summe,11))+textz_xexe__byte_resource1^
            +str0(resource_zaehler)+textz_xexe__byte_resource2^,compiler);

          (*ausschrift(hex_longint(resource_summe)+' summe',dat_fehler);
          ausschrift(hex_longint(vermutete_laenge)+' vermultiche LéNGE ',dat_fehler);
          ausschrift(hex_longint(resource_ende-o_dir0)+' ende res',dat_fehler);*)
        end;


      (* z.B. aspack 2.001 hat einen durch die Kompression zerstîrten Resourcebaum *)
      if resource_fehler<>0 then
        ausschrift(str0(resource_fehler)+textz_fehler_im_resource_baum^,dat_fehler);

      if resource_zaehler>0 then
        if AndDGT(resource_ende+4096-1-o_dir0,-4096)<vorgegebene_laenge_des_resourcebereiches then
          ausschrift(leer_filter(strxDGT(vorgegebene_laenge_des_resourcebereiches-(resource_ende-o_dir0),11))
            +textz_byte_resource_nicht_erreichbar^,dat_fehler);

      Inc(herstellersuche);
    end; (* pe_resourcen1 *)

  procedure ausschrift_aspack(const v:string);
    begin
      ausschrift('ASPack / Alexey Solodovnikov ['+v+']',packer_exe);
    end;

  procedure ausschrift_asprotect(const v:string);
    begin
      ausschrift('ASProtect / Alexey Solodovnikov ['+v+']',packer_exe);
    end;

  var
    w1                  :word_norm;

  begin (* coff *)

    o:=coff_basis+coff_ofs;
    datei_lesen(di_puffer,o,512);

    (* OS2IMAGE\DEBUG\SYMBOLS\BASENL\FD7000EX.SYM mu· hier als nicht COFF-Format erkannt werden *)

    with di_puffer do
      (* rewerse word lo/hi gleich *)
      if (* Fehler bei uharc.exe: ((d[$12] and $80)<>(d[$12+1] and $80)) *) false
      (* Anzahl EintrÑge in der Objekttabelle *)
      or (word_z(@d[2])^<=0) or (word_z(@d[2])^>=100)
      (* NT HDR SIZE *)
      or (word_z(@d[$10])^>4096-$14)
      (* Image Base (wenn vorhanden) *)
      or ( (word_z(@d[$10])^+$14>=$30+4) and ((longint_z(@d[$30])^ and $ffff)<>0) )
       then
        begin
          coff_ende:=0;
          Exit;
        end;

    exezk:=coff_prozessor(word_z(@di_puffer.d[0])^);
    ausschrift('Common Object File Format - ('+exezk+')',signatur);

    w1:=$14+di_puffer.d[$10];
    if w1>92 then
      begin

        case di_puffer.d[92-4] of
          $00:exezk:=textz_dien__Zielsystem^+textz_dien__unbekannt^;
          $01:exezk:=''(* ausschrift('Zielsystem "native"'signatur) *);
          $02:exezk:=textz_dien__Zielsystem^+'Windows GUI';
          $03:exezk:=textz_dien__Zielsystem^+'Windows Text';
          $05:exezk:=textz_dien__Zielsystem^+'OS/2';
          $07:exezk:=textz_dien__Zielsystem^+'Posix Text';
       (* $1c:exezk:=textz_dien__Zielsystem^+'Santa Cruz Operation'; ( * rtssco(314).zip *)
       (* $2e:exezk:=textz_dien__Zielsystem^+'GO32 / DJ Delorie'; *)
        else
              exezk:=textz_dien__Zielsystem^+textz_dien__Nr_punkt^+str0(di_puffer.d[$5c-4]);
        end;
      end
    else
      exezk:=''; (* SCO,GO32,.., ohne den NT/ROM header $10b/$107 *)

    (*if (word_z(@di_puffer.d[$12])^ and bit13)<>0 then*)
    if (di_puffer.d[$12+1] and bit05)<>0 then
      exezk_anhaengen(textz_klammer_Bibliothek_klammer^);

    exezk:=leer_filter(exezk);
    if exezk<>'' then
      ausschrift(exezk,signatur);

    code_start:=-1;
    coff_ende:=0;

    anzahl_obj:=word_z(@di_puffer.d[2    ])^;
    eip_pos:=longint_z(@di_puffer.d[$28-4])^;
    imagebase:=longint_z(@di_puffer.d[$34-4])^;

    (* "Description" *)
    if word_z(@di_puffer.d[$10])^>=$a0 then
      if (longint_z(@di_puffer.d[$ac])^<>0) and (longint_z(@di_puffer.d[$b0])^<>0) then
        begin
          lade_code(longint_z(@di_puffer.d[$ac])^,coff_puffer);
          l1:=longint_z(@di_puffer.d[$b0])^;
          if l1>255 then l1:=255;
          ausschrift_modulbeschreibung(puffer_zu_zk_e(coff_puffer.d[0],#0,l1));
        end;

    if not langformat then exit;

    (*$IfNDef ENDVERSION*)
    (* ausschrift('Name.... PhysSize. PhysOffs.',beschreibung); *)
    (*$EndIf*)

    write_executable:=false;

    for obj_nummer:=1 to anzahl_obj do
      begin
        datei_lesen(coff_puffer,o+word_z(@di_puffer.d[$10])^+$14+(obj_nummer-1)*$28,$28);

        (* write+executable? *)
        if ((coff_puffer.d[$24+3] and $a0)=$a0)
        and (not bytesuche(coff_puffer.d[0],'.idata')) (* readcd.exe *)
        and (not bytesuche(coff_puffer.d[0],'INIT')) (* adv01w2k.dll *)
         then
          write_executable:=true;

        if bytesuche(coff_puffer.d[0],'.data'#0) then (* Gentee Installer *)
          begin
            datei_lesen(coff_puffer2,coff_basis+longint_z(@coff_puffer.d[$14])^,80);

            if bytesuche(coff_puffer2.d[0],'Gentee') then
              ausschrift(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(coff_puffer2.d[0],#0,80)),packer_dat);
          end;

        if bytesuche(coff_puffer.d[$14],'aRJsfX') then
          begin
            ausschrift('ARJSFX-COFF BUG!',dat_fehler);
            FillChar(coff_puffer.d[$14],4,0);
          end;

        if bytesuche(coff_puffer.d[0],'.seau'#$00) then
          longint_z(@coff_puffer.d[$10])^:=$0; (* LÑnge 0 simulieren -> Overlay *)

        (* ZORK1.EXE/ZORK3.EXE enthalten MSCF *)
        if bytesuche(coff_puffer.d[0],'_cabinet') then
          begin
            (*longint_z(@coff_puffer.d[$10])^:=$3a; ( * LÑnge des AnfangmÅlls *)
            longint_z(@coff_puffer.d[$10])^:=$c; (* der MÅll ist SCG1 *)
          end;

        if bytesuche(coff_puffer.d[0],'actdlvry') then
          begin
            (* tsfx312b.exe *)
            (* 'AD01 .... <ZIP-Archiv> *)
            longint_z(@coff_puffer.d[$10])^:=$c;
          end;

        if bytesuche(coff_puffer.d[0],'.WISE'#$00#$00#$00) then
          wise_pw_msi(coff_basis+longint_z(@coff_puffer.d[$14])^,longint_z(@coff_puffer.d[$10])^);

        if bytesuche(coff_puffer.d[0],'.pdata'#$00#$00) then
          pdata(coff_basis+longint_z(@coff_puffer.d[$14])^,longint_z(@coff_puffer.d[$10])^);

        coff_ende_test:=longint_z(@coff_puffer.d[$14])^+longint_z(@coff_puffer.d[$10])^;
        if  (coff_ende<coff_ende_test)
        and (longint_z(@coff_puffer.d[$14])^>0)
         then
          if bytesuche(coff_puffer.d[0],'_winzip_') then
            merke_position(coff_basis+longint_z(@coff_puffer.d[$14])^,datentyp_winzip)
          else
            coff_ende:=coff_ende_test;


        (*$IfNDef ENDVERSION*)
        (* ausschrift(puffer_zu_zk_l(coff_puffer.d[0],8)
          +' '+hex_longint(longint_z(@coff_puffer.d[$10])^)
          +' '+hex_longint(longint_z(@coff_puffer.d[$14])^),beschreibung); *)
        (*$EndIf*)

        if  (eip_pos>=longint_z(@coff_puffer.d[$0c])^)
        and (eip_pos< longint_z(@coff_puffer.d[$0c])^+longint_z(@coff_puffer.d[$10])^) then
          begin
            code_start:=longint_z(@coff_puffer.d[$14])^
                       -longint_z(@coff_puffer.d[$0c])^
                       +eip_pos;
          end;
      end;

    (* "Security" *)
    if word_z(@di_puffer.d[$10])^>=$9c-$14 then
      if (longint_z(@di_puffer.d[$94])^<>0) and (longint_z(@di_puffer.d[$98])^<>0)
      and (coff_ende<=longint_z(@di_puffer.d[$94])^) then
        begin
          merke_position(coff_basis+longint_z(@di_puffer.d[$94])^,datentyp_unbekannt);
          merke_position(coff_basis+longint_z(@di_puffer.d[$94])^+longint_z(@di_puffer.d[$98])^,datentyp_unbekannt)
        end;



    (* CIH ... *)
    if (code_start<0)
    and (imagebase>eip_pos) (* image base >eip *)
     then
      begin
        code_start:=eip_pos;
      end;

    if code_start<0 then exit;

    datei_lesen(coff_puffer,coff_basis+code_start,512);

    (* PERULES.TXT: PELCK2B2 *)
    if di_puffer.d[$10]>=$e0 then
      begin
        perules_bits:=longint_z(@di_puffer.d[$f4-4])^;
        if (perules_bits and $ff)=0 then
          perules_bits:=0;
      end
    else
      perules_bits:=0;

    herstellersuche:=1; (*******************************************)

    (*$IfDef ERWEITERUNGSDATEI*)
    suche_erweiterungen(coff_puffer);
    (*$EndIf*)

    (*$IfDef GTDATA*)
    suche_gtdata(gt_ext_pe,coff_puffer.d[0]);
    suche_gtdata(gt_pe_0j ,coff_puffer.d[0]);
    (*$EndIf*)


    if bytesuche(coff_puffer.d[0],#$60#$e8#$00#$00#$00#$00'ANAKIN'#$5d) then
      begin
        ausschrift('PE-Shield / Stefan Esser [0.2]',packer_exe);
        perules_bits:=(perules_bits-1) and (not $40000000)
      end;

    if bytesuche(coff_puffer.d[0],#$60#$e8'?'#$00#$00#$00#$0d#$0a#$0d#$0a) then
      begin
        w1:=1+1+4+coff_puffer.d[1+1];
        exezk:='0.?? ¯';
        if bytesuche(coff_puffer.d[w1],#$5d#$83#$ed#$06#$eb#$02) then
          exezk:='0.25';
        ausschrift('PE-Shield / Stefan Esser ['+exezk+']',packer_exe);
        perules_bits:=(perules_bits-1) and (not $40000000)
      end;

    if bytesuche(coff_puffer.d[0],#$60#$e8#$00#$00#$00#$00#$5d#$83#$ed#$06#$80#$bd#$e0) then
      (* ANAKiN *)
      ausschrift('PE-PACK / Stefan Esser [0.99]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$60#$e8#$00#$00#$00#$00#$5d#$83#$ed#$06#$80#$bd#$e8) then
      ausschrift('PE-PACK / Stefan Esser [0.99<TIRAMKEY>]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$b9'????'#$b8'????'#$e8'???'#$00#$e8'???'#$00) then
      ausschrift('Virtual Pascal / vpascal.com'(*fPrint UK*),compiler);

    if bytesuche(coff_puffer.d[0],#$55#$89#$e5#$83#$ec#$08#$c7#$04#$24'?'#$00#$00#$00
      +#$ff#$15'????'#$e8'????'#$89#$ec#$31#$c0#$5d#$c3) then
      (* vermutlich unsichere Erkennung *)
      ausschrift('MinGW32',compiler);

    if bytesuche(coff_puffer.d[0],#$55#$89#$e5#$83#$ec#$08#$83#$c4#$f4#$6a'?'#$a1'????'#$ff#$d0#$e8) then
      (* awbm2tiff.exe *)
      ausschrift('MinGW32',compiler);

    if bytesuche(coff_puffer.d[0],#$55#$89#$e5#$83#$ec#$10#$56#$53#$8b#$5d#$0c#$83#$fb#$01#$75#$05#$e8'????'#$8b#$45#$10) then
      (* libjpeg6b.dll *)
      ausschrift('MinGW32 [dll]',compiler);

    if bytesuche(coff_puffer.d[0],#$b9'????'#$e8'???'#$00) then
      begin
        lade_code(eip_pos+longint_z(@coff_puffer.d[1+4+1])^+1+4+1+4,coff_puffer2);

        (* SECURIT2.DLL *)
        if (    bytesuche(coff_puffer2.d[0],#$83#$7c#$24#$0c#$01#$72'?'#$77)
            and bytesuche(coff_puffer2.d[coff_puffer2.d[8]+9],#$83#$7c#$24))
        (* +mov b [???],1 *)
        or (    bytesuche(coff_puffer2.d[0],#$c6#$05'????'#$01#$83#$7c#$24#$0c#$01#$72'?'#$77)
            and bytesuche(coff_puffer2.d[coff_puffer2.d[8+7]+8+7+1],#$83#$7c#$24))
         then
          ausschrift('Virtual Pascal / vpascal.com [DLL]',compiler);
        (*goto untersuche_coff_code_fertig;*)
      end;

    if bytesuche(coff_puffer.d[0],#$8b#$44#$24#$08#$83#$e8#$00#$74'?'#$48#$75) then
      ausschrift('Intel C/C++',compiler);

    if bytesuche(coff_puffer.d[0],#$ff#$74#$24#$0c#$ff#$74#$24#$0c#$ff#$74#$24#$0c#$e8'????'#$c2#$0c#$00) then
      (* Flash06007900.OCX: Intel(R) C++ Compiler for 32-bit applications, Version 6.0 *)
      ausschrift('Intel C/C++',compiler);

    if bytesuche(coff_puffer.d[1],#$4c#$01)
    and (word_z(@di_puffer.d[2])^=word_z(@coff_puffer.d[2+1])^)
     then
       (* 1.04 *)
       ausschrift('DJP / L†szl¢ Moln†r [1.0? -s]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$1e#$07#$68'????'#$68'????'#$68'????'#$e8#$2f#$00#$00#$00#$83) then
      ausschrift('DJP / L†szl¢ Moln†r [1.04]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$1e#$07#$be'????'#$bf'????'#$fc#$31#$c0#$31#$db#$ac) then
      (* ZIP22X *)
      ausschrift('DJP / L†szl¢ Moln†r [1.05]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$e9'??'#$00#$00'$Id: djp') then
      (* 1.06,1.07 stubless *)
      begin
        (* MLP107B.* *)
        case coff_puffer.d[1] of
          $ae:exezk:='1.06';
          $ac:exezk:='1.07';
        else
              exezk:='1.0? ¯';
        end;
        ausschrift('DJP / L†szl¢ Moln†r ['+exezk+']',packer_exe);
        (* ausschrift(puffer_zu_zk_e(coff_puffer.d[$a],'$',128),beschreibung);*)
      end;

    if bytesuche(coff_puffer.d[0],#$1e#$07#$be'????'#$bf'????'#$fc#$31#$db#$83) then
      (* 0.05 *)
      ausschrift_upx_version(coff_puffer,coff_puffer,0,005,005,'djgpp2/coff')
    else
    if bytesuche(coff_puffer.d[0],#$1e#$07#$be'????'#$bf'????'#$57#$31#$db#$83) then
      ausschrift_upx_version(coff_puffer,coff_puffer,$14e-4,0,255,'djgpp2/coff')
    else
    (* 0.81 *)
    if bytesuche(coff_puffer.d[0],#$1e#$07#$be'????'#$bf'????'#$57#$83#$cd#$ff#$eb#$0f#$90) then
      ausschrift_upx_version(coff_puffer,coff_puffer,$14e-4,81,255,'djgpp2/coff')
    else
    (* 0.84 *)
    if bytesuche(coff_puffer.d[0],#$1e#$07#$be'????'#$bf'????'#$57#$83#$cd#$ff#$eb#$10#$90) then
      ausschrift_upx_version(coff_puffer,coff_puffer,$14e-4,84,255,'djgpp2/coff')
    else
    (* 0.92 *)
    if bytesuche(coff_puffer.d[0],#$1e#$07#$be'????'#$bf'????'#$57#$83#$cd#$ff#$eb#$0d#$90) then
      ausschrift_upx_version(coff_puffer,coff_puffer,$14e-4,092,255,'djgpp2/coff')
    else
    (* 0.99 *)
    if bytesuche(coff_puffer.d[0],#$1e#$07#$be'????'#$bf'????'#$57#$83#$cd#$ff#$eb#$0a#$8a#$06) then
      ausschrift_upx_version(coff_puffer,coff_puffer,$10a,099,255,'djgpp2/coff')
    else
    if bytesuche(coff_puffer.d[0],#$1e#$07#$be'????'#$bf'????'#$57#$83#$cd#$ff#$eb#$0b#$90#$8a#$06#$46) then
      ausschrift_upx_version(coff_puffer,coff_puffer,$10f,120,255,'djgpp2/coff')
    else
    (* cyg.exe - "2000" *)
    if bytesuche(coff_puffer.d[0],#$1e#$07#$be'????'#$bf'????'#$57#$83#$cd#$ff#$eb) then
      if bytesuche(coff_puffer.d[$10+2+coff_puffer.d[$10+1]],#$8b#$1e#$83#$ee#$fc#$11#$db) then
        ausschrift_upx_version(coff_puffer,coff_puffer,$ff,0,255,'djgpp2/coff');



    (* 0.6x *)
    if bytesuche(coff_puffer.d[0],#$60#$e8#$00#$00#$00#$00#$58#$83#$e8'?'#$50#$8d#$b8'????'#$57)
    (* 0.72 *)
    or bytesuche(coff_puffer.d[0],#$60#$e8#$00#$00#$00#$00#$83#$cd#$ff#$31#$db#$5e#$8d#$be'????'#$57#$66#$81#$87)
     then
      begin
        datei_lesen(coff_puffer2,coff_basis+coff_ofs+$f4+anzahl_obj*$28,512);
        ausschrift_upx_version(coff_puffer,coff_puffer2,$185,50,255,'win32,rtm32/pe');
      end;

    (* 0.81 *)
    (* Versionsnummer vor Programmbereich gespeichert *)
    if bytesuche(coff_puffer.d[0],#$60#$be'????'#$8d#$be'???'#$ff#$57#$83#$cd#$ff#$eb{#$10#$90})
    or bytesuche(coff_puffer.d[0],#$60#$be'????'#$8d#$be'???'#$ff#$57#$33#$ed#$4d#$eb{#$10#$90})
    or bytesuche(coff_puffer.d[0],#$60#$be'????'#$8d#$be'???'#$ff
         +#$c7#$87'????????'#$57#$83#$cd#$ff#$eb#$0e#$90) (* komischer Fall 0.81: CODEWIZ.EXE sftlocx30.zip *)
       (* I-Worm.Tanatos.b (1.24) *)
    or bytesuche(coff_puffer.d[0],#$60#$be'????'#$8d#$be'???'#$ff#$57#$83#$cd#$ff#$e9{7a#$01#$00#$00})
     then
      begin
        datei_lesen(coff_puffer2,coff_basis+coff_ofs+$f4+anzahl_obj*$28,512);
        ausschrift_upx_version(coff_puffer,coff_puffer2,$185,80,255,'win32,rtm32/pe');
      end;

    (* DLL Vorspann *)
    if bytesuche(coff_puffer.d[0],#$80#$7c#$24#$08#$01#$0f#$85'??'#$00#$00) then
      begin
        if bytesuche(coff_puffer.d[11],#$60#$e8#$00#$00#$00#$00#$58#$83#$e8'?'#$50#$8d#$b8'????'#$57)
        or bytesuche(coff_puffer.d[11],#$60#$e8#$00#$00#$00#$00#$83#$cd#$ff#$31#$db#$5e#$8d#$be'????'#$57#$66#$81#$87)
        or bytesuche(coff_puffer.d[11],#$60#$be'????'#$8d#$be'????'#$57) (* 0.76.1 KERNEL32.WDL *)
         then
          begin
            datei_lesen(coff_puffer2,coff_basis+coff_ofs+$f4+anzahl_obj*$28,512);
            ausschrift_upx_version(coff_puffer,coff_puffer2,$185,50,255,'win32,rtm32/pe dll');
          end;
      end;

    if bytesuche(coff_puffer.d[0],#$fc#$8b#$35'????'#$83#$ee#$40#$6a#$40#$68'????'
       +#$56#$6a#$00#$ff#$15'????'#$50#$5f#$8d#$a8'????'#$b9'????'#$87#$f1#$56#$51) then
      ausschrift('PackLite(HackStop/Win32) / Ralph Roth [1.00] <1>',packer_exe);

    if bytesuche(coff_puffer.d[0],#$fc#$8b#$35'????'#$83#$ee#$40#$6a#$40#$68'????'
       +#$56#$6a#$00#$ff#$15'????'#$8b#$f8#$8d#$a8'????'#$b9'????'#$87#$f1#$56#$51) then
      ausschrift('PackLite(HackStop/Win32) / Ralph Roth [1.00] <2>',packer_exe);


    if bytesuche(coff_puffer.d[0],#$a3'????'#$89#$35'????'#$89#$3d'????'#$89#$1d'????'#$89#$2d'????'#$83#$fa#$00#$74'?'
       +#$66#$8c#$e9#$66#$8c#$d8) then
      (* top1168.zip\CJPEG.EXE *)
      ausschrift('DJGPP [?1.12m2]',compiler);

    if bytesuche(coff_puffer.d[0],#$1e#$07#$f6#$05'????'#$01#$75) then
      ausschrift('DJGPP',compiler);



    if bytesuche(coff_puffer.d[0],#$55#$89#$e5#$83#$ec#$14#$6a'?'#$ff#$15'????'#$e8'????'#$89#$ec#$31#$c0#$5d#$c3) then
      ausschrift('Dev-C++',compiler); (* md5sum.exe *)

    if bytesuche(coff_puffer.d[0],#$53#$55#$8b#$e8#$33#$db#$eb'?'#$0d) then
      ausschrift('WWPACK32 / Rafal Wierzbicki '+textz_exe__und^+' Piotr Warezak [1.01,.]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$60#$66#$9c#$bb'????'#$80#$b3'?????'#$4b#$83#$fb#$ff
      +#$75#$f3#$66#$9d#$61#$b8'????'#$ff#$e0) then
      ausschrift('LameCrpyt / lazarus [1.00 alpha]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$e8#$00#$00#$00#$00#$58#$83#$e8#$05#$53#$51#$56#$57) then
      (* EXE-Liste 1998.01.03 *)
      ausschrift('PECRYPT / random [0.3·]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$e8#$00#$00#$00#$00#$5b#$83#$eb#$05#$56#$57#$55#$89#$a3) then
      (* EXE-Liste 1998.01.03 *)
      ausschrift('PE-CRYPT32 / random & acpizer [0.9·8 "1.13"]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$e8#$00#$00#$00#$00#$5b#$83#$eb#$05#$eb#$04'RND!') then
      ausschrift('PE-CRYPT32 / random & acpizer [1.0,1.01,1.02]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$eb#$03':M:') then
      ausschrift('.BJFnt / Marquis de SoirÇe [1.3]',packer_exe);

    (* spÑter: polymorph
    if bytesuche(coff_puffer.d[0],#$eb#$03#$cd#$20#$eb#$eb) then
      begin
        ausschrift('PELOCKnt / Marquis de SoirÇe [2.01]',packer_exe);
        perules_bits:=(perules_bits-1) and (not $10000000)
      end; *)

    if bytesuche(coff_puffer.d[0],#$e9'????'+'????'+'WATCOM C')
      (* Watcom c/c++32 1995 *)
    or bytesuche(coff_puffer.d[0],#$e9'????'+'????'+'Watcom C')
      (* geraten *)
    or bytesuche(coff_puffer.d[0],#$e9'????'+'????'+'Open WATCOM C')
      (* geraten *)
    or bytesuche(coff_puffer.d[0],#$e9'????'+'????'+'Open Watcom C') then
      (* Open Watcom C/C++32 Run-Time system. Portions Copyright (c) Sybase, Inc. 1988-2002. *)
      ausschrift_watcom(coff_puffer,9,140);


{    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$83#$c4#$f4#$53#$b8'????'#$e8) then
      ausschrift('Borland Pascal [?.?]',compiler);}

    if bytesuche(coff_puffer.d[0],#$a1'????'#$c1#$e0#$02#$a3'????'#$57#$51#$33#$c0#$bf) then
      ausschrift('Borland C++ 1995',compiler);

    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$83#$c4#$b4#$b8'????'#$e8'????'#$e8'????'#$8d#$40) then
      (* DLL: spep10.deu *)
      (* mit "portions copyr" 1983,97 *)
      begin
        ausschrift('Delphi 2,3,.. / Borland <3>',compiler);
        goto weiter_pe;
      end;

    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$83#$c4#$b4#$b8'????'#$e8) then
      begin (* Sasami2000_CBTHook.dll *)
        datei_lesen(coff_puffer2,coff_basis+code_start+11+5+longint_z(@coff_puffer.d[11+1])^,512);
        if bytesuche(coff_puffer2.d[0],#$ba'????'#$83#$7d#$0c#$01#$75) then
          begin
            ausschrift('Delphi 2,3,.. / Borland <dll,1999>',compiler);
            goto weiter_pe;
          end;

      end;

    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$83#$c4#$f0#$a1'????'#$c6#$00#$01#$b8'????'#$e8) then
      begin (* fdc.exe aus fd.zip " File DETECT! v1.00 Build 120 MajestiC *)
        datei_lesen(coff_puffer2,coff_basis+code_start+19+5+longint_z(@coff_puffer.d[19+1])^,512);
        if bytesuche(coff_puffer2.d[0],#$53#$8b#$d8#$33#$c0#$a3'????'#$6a#$00#$e8) then
          begin
            ausschrift('Delphi / Inprise [? ¯]',compiler);
            goto weiter_pe;
          end;
      end;

    if bytesuche(coff_puffer.d[0],#$c6#$05'????'#$01#$e8'????'#$c6#$05'????'#$00#$e8'????'#$55#$89#$e5) then
      begin
        datei_lesen(coff_puffer2,coff_basis+code_start+7+5+longint_z(@coff_puffer.d[7+1])^,512);
        if bytesuche(coff_puffer2.d[0],#$55#$89#$e5#$c6#$05'????'#$00#$e8'????'#$55#$31#$ed) then
          ausschrift('FreePascal',compiler); (* ?1.00? space_250.zip\space.exe *)
      end;

    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$6a#$ff#$68'????'#$68'????'#$64) then
      ausschrift('VC++ / MS',compiler);

    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$56#$57#$bf#$01#$00#$00#$00#$8b#$75#$0c#$3b#$f7) then
      (* NAVEX32.DLL *)
      ausschrift('VC++ / MS',compiler);

    if bytesuche(coff_puffer.d[0],#$53#$55#$56#$8b#$74#$24#$14#$85#$f6#$57#$b8#$01#$00#$00#$00) then
      (* NPSCC32.DLL,SETMAP.DLL *)
      ausschrift('VC++ / MS',compiler);

    if bytesuche(coff_puffer.d[0],#$53#$b8#$01#$00#$00#$00#$8b#$5c#$24#$0c#$56#$57#$85#$db#$55#$75) then
      (* SHRINK32.DLL (3.4) *)
      ausschrift('VC++ / MS',compiler);

    {if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$83#$ec'?'#$#$53#$56) then
      ausschrift('C?/ MS',compiler);}

    if bytesuche(coff_puffer.d[0],#$64#$a1#$00#$00#$00#$00#$55#$8b#$ec#$6a#$ff#$68'????'#$68'????'#$50) then
      (* EXESCAN: 2.0 *)
      ausschrift('VC++ / MS',compiler);

    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$53#$8b#$5d#$08#$56#$8b#$75#$0c#$57#$8b#$7d#$10#$85#$f6#$75) then
      (* sqeez4: CxArj40.dll,... fi.exe sagt 6.0 *)
      ausschrift('VC++ / MS [6.0?]',compiler);

    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$53#$8b#$5d#$08#$56#$8b#$75#$0c
       +#$85#$f6#$57#$8b#$7d#$10#$75#$09#$83#$3d'????'#$00#$eb'?'#$83#$fe#$01) then
      (* sacred: ascaron.scripting.dll  fi.exe sagt 7.0 *)
      ausschrift('VC++ / MS [7.0?]',compiler);

    if bytesuche(coff_puffer.d[0],#$6a#$18#$68'????'#$e8'????'
      +#$bf'????'#$8b#$c7#$e8'????'#$89#$65#$e8#$8b#$f4#$89#$3e#$56#$ff#$15) then
      (* PEWaterMark.exe; fii sagt 7.10 *)
      ausschrift('VC++ / MS [7.10?]',compiler);

    if bytesuche(coff_puffer.d[0],#$83#$3d'????'#$00#$55#$8b#$ec#$56#$57#$75) then
      begin
        case coff_puffer.d[2] of
          $f8:exezk:='[3.20]';
          $ac:exezk:='[3.3]';
          $b4:exezk:='[3.4]';
        else
              exezk:='[3.?]';
        end;
        ausschrift('Shrinker '+exezk,packer_exe);
      end;

    if bytesuche(coff_puffer.d[0],#$66#$9c#$60#$e8#$ca#$00#$00#$00) then
      ausschrift('Petite / Ian Luck [1.2]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$b8#$00'???'#$66#$9c#$60#$50#$8d#$88) then
      ausschrift('Petite / Ian Luck [1.3a]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$b8#$00'???'#$66#$9c#$60#$50#$8b#$d8) then
      ausschrift('Petite / Ian Luck [1.4]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$b8#$00'???'#$66#$9c#$60#$50#$8d#$90) then
      ausschrift('Petite / Ian Luck [2.0]',packer_exe);

    (*
    if bytesuche(coff_puffer.d[0],#$b8#$00'???'        +#$68'???'#$00+#$64#$ff#$35#$00#$00#$00#$00+#$64#$89#$25#$00#$00#$00#$00
         +#$66#$9c+#$60+#$50+#$33#$db)
    or bytesuche(coff_puffer.d[0],#$b8#$00'???'+#$6a'?'+#$68'???'#$00+#$64#$ff#$35#$00#$00#$00#$00+#$64#$89#$25#$00#$00#$00#$00
         +#$66#$9c+#$60+#$50+#$8b#$d8)
     then
      ausschrift('Petite / Ian Luck [2.1,2.2]',packer_exe);*)


    if bytesuche(coff_puffer.d[0],#$b8#$00'???') then
      begin
        w1:=5;
        if bytesuche(coff_puffer.d[w1],#$6a'?') then
          Inc(w1,2);
        if bytesuche(coff_puffer.d[w1],#$68'???'#$00
                                       +#$64#$ff#$35#$00#$00#$00#$00
                                       +#$64#$89#$25#$00#$00#$00#$00
                                       +#$66#$9c
                                       +#$60
                                       +#$50) then
          begin
            Inc(w1,5+7+7+2+1+1);
            if bytesuche(coff_puffer.d[w1],#$33#$db)
            or bytesuche(coff_puffer.d[w1],#$8b#$d8)
            or bytesuche(coff_puffer.d[w1],#$68#$00#$00) (* winace *)
             then
              begin
                ausschrift('Petite / Ian Luck [2.1,2.2]',packer_exe);
                befehl_petite2122;
              end;
          end;
      end;

    if bytesuche(coff_puffer.d[0],#$53#$51#$52#$56#$57#$55#$e8#$00#$00#$00#$00#$5d#$8b#$cd#$81#$ed) then
      ausschrift('PCPEC / The+Q, Plushmm & MrNop [alpha]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$83#$3d'????'#$00#$0f#$84#$08#$00#$00#$00#$a1'????'#$ff#$e0) then
      ausschrift('Gleam / Zhang De Hua [1.01]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$83#$ec'?'#$53#$56#$57#$e8#$00#$00#$00#$00#$8b#$04#$24#$5a) then
      ausschrift('CodeSafe / Zhang De Hua [3.1]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$53#$e8#$00#$00#$00#$00#$5b#$8b#$c3#$2d#$06'???'#$50#$81#$eb#$06) then
      ausschrift('PrivateEXE / Midstream [2.0a]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$53#$e8#$00#$00#$00#$00#$5b#$8b#$c3#$2d'????'#$50#$81#$eb) then
      (* 007        1.0d *)
      (* PrivateEXE 2.2  *)
      ausschrift('007,PrivateEXE / Midstream [1.0d,2.2]',packer_exe);


    if bytesuche(coff_puffer.d[0],#$60#$e8#$00#$00#$00#$00#$5d#$81#$ed) then
      begin
        if      longint_z(@coff_puffer.d[9])^=$00442ad2 then
          exezk:='1.01b'
        else if longint_z(@coff_puffer.d[9])^=$00437896 then
          exezk:='1.02b'
        else if longint_z(@coff_puffer.d[9])^=$00444ace then
          exezk:='1.03b?'(*'1.0?? ¯'*)
        else if longint_z(@coff_puffer.d[9])^=$00444a0a then
          exezk:='1.08.3'
        else if longint_z(@coff_puffer.d[9])^=$00444a16 then
          exezk:='1.08.3p' (* sagt fi zu wrbp2001.exe *)
        else
          exezk:='1.? ¯';
        ausschrift_aspack(exezk);
      end;


    if bytesuche(coff_puffer.d[0],#$60#$e8'??'#$00#$00#$eb) then
      begin
        datei_lesen(coff_puffer2,coff_basis+code_start+1+5+longint_z(@coff_puffer.d[1+1])^,512);
        if bytesuche(coff_puffer2.d[0],#$8b#$2c#$24#$81#$ed) then
          begin
            {
            case coff_puffer.d[7] of
              $41:exezk:='1.084'; (* atrans *)
              $4c:exezk:='2.000'; (* automan,order *)
              $33:exezk:='2.1';   (* sfark.exe *)
            else  exezk:='¯ 1.084..2.000 ?'
            end;}
            datei_lesen(coff_puffer2,coff_basis+code_start+1+5+2+coff_puffer.d[6+1],512);
            case word_z(@coff_puffer2.d[1])^ of
              $2908:exezk:='1.084'; (* atrans.exe *)
              $39a4:exezk:='2.000'; (* automan.exe,order.exe *)
              $2970:exezk:='2.001'; (* acrypt.exe *)
              $297c:exezk:='2.001'; (* nopopup.exe *)
              $2994:exezk:='2.001'; (* ccrypt.exe *)
              $3930:exezk:='2.1'  ; (* setup.exe,seau___.exe *)
              $393c:exezk:='2.1'  ; (* sfark.exe,sfarkl.dll *)
            else    exezk:='?';
            end;
            ausschrift_aspack(exezk);
          end;
      end;


    if bytesuche(coff_puffer.d[0],#$60#$e8#$01#$00#$00#$00#$90#$5d#$81#$ed'???'#$00#$bb'???'#$00#$03#$dd#$2b#$9d) then
      begin
        if longint_z(@coff_puffer.d[10])^=$0045afbf then
          ausschrift_asprotect('1.00') (* fi: spuica.exe *)
        else
          begin
            if longint_z(@coff_puffer.d[10])^=$0045151a then
              exezk:='1.08.04'
            else if longint_z(@coff_puffer.d[10])^=$0044c5f3 then
              exezk:='2.000' (* nur mit ASPACK.EXE getestet *)
            else if longint_z(@coff_puffer.d[10])^=$0044FE17 then
              exezk:='2.001' (* nur mit ASPACK.EXE getestet *)
            else if longint_z(@coff_puffer.d[10])^=$0044FDCF then
              exezk:='2.001 2000.04.01' (* nur mit ASPACK.EXE getestet *)
            else
              exezk:='2.?? ¯';
            ausschrift_aspack(exezk);
          end;
      end;

    if bytesuche(coff_puffer.d[0],#$60#$e9#$3d#$04#$00#$00)
    and (Lo(code_start)=$01)
     then
      ausschrift_aspack('2.11');

    if bytesuche(coff_puffer.d[0],#$60#$e8#$02#$00#$00#$00#$eb#$09#$5d#$55#$81#$ed'????'#$c3#$e9) then
      begin
        ausschrift_aspack('2.11c'); (* opera 6.0, fi sagt 2.11c *)
      end;


    if bytesuche(coff_puffer.d[0],#$53#$51#$52#$56#$57#$55#$e8#$00#$00#$00#$00#$5d#$8b#$f5#$81#$ed'????'
       +#$2b#$b5'????'#$83#$ee) then
      ausschrift('PEpsi / xOANINO [0.01]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$c7#$05'????????'#$e9'????????WATC') then
      ausschrift(puffer_zu_zk_e(coff_puffer.d[19],'All',140),compiler);

    if bytesuche(coff_puffer.d[0],#$68'???'#$00#$e8'?'#$ff#$ff#$ff#$00#$00)
    and (coff_puffer.d[6] in [$ee..$f0])
     then
      begin
        lade_code(longint_z(@coff_puffer.d[1])^-longint_z(@di_puffer.d[$30])^,coff_puffer2);
        (* "VB5!" *)
        ausschrift(puffer_zu_zk_l(coff_puffer2.d[0],3),compiler);
      end;

    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$68'????'#$64#$ff#$35#$00#$00#$00#$00#$64#$89#$25#$00#$00#$00#$00#$e8) then
          (* MNOTEB04: OS/2+Win32 EXE *)
          (* push   ebp
             mov    ebp,esp
             push   1B570h
             push   DWord Ptr fs:[0]
             mov    fs:[0],esp
             call   1AB76h
             call   1B300h                *)
        ausschrift('IBM VisulalAge C',compiler);

    if bytesuche(coff_puffer.d[0],#$55#$57#$56#$52#$51#$53#$e8#$00#$00#$00#$00#$5d#$8b#$d5#$81#$ed'??'#$40#$00#$be) then
      ausschrift('PE-Lock / Ding Boy',packer_exe); (* 0.07 *)

    if bytesuche(coff_puffer.d[0],#$55#$57#$56#$52#$51#$53#$66#$81#$c3#$eb#$02#$eb#$fc#$66#$81) then
      ausschrift('DBPE / Ding Boy [1.0]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$68'???'#$00#$68'???'#$00#$68#$00#$00#$00#$00#$e8'???'#$00#$e9'???'#$ff) then
      ausschrift('PKLITE32 / PKWare [1.1]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$55#$50#$e8#$00#$00#$00#$00#$5d#$eb#$01'?'#$60#$e8#$03) then
      (* 2.10 DEMO *)
      ausschrift('PC Guard / Blagoje Ceklic [2.10,2.20]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$9c#$55#$e8#$82#$00#$00#$00#$87#$d5#$5d#$60#$87#$d5) then
      ausschrift('PhrozenCrew PE Shrinker / Virogen [0.14]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$9c#$60#$bd'????'#$01#$ad'????'#$8d#$b5'????'#$ad#$0b) then
      ausschrift('PhrozenCrew PE Shrinker / Virogen [0.29]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$9c#$60#$bd'????'#$01#$ad'????'#$ff#$b5'????'#$6a) then
      (* 0.60 Beta *)
      ausschrift('PhrozenCrew PE Shrinker / Virogen [0.45,0.60,0.71]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$55#$57#$51#$53#$e8#$00#$00#$00#$00#$5d#$8b#$c5#$81#$ed'???'#$00
         +#$2b#$85'???'#$00#$83#$e8#$09#$89#$85) then
      begin
        if word_z(@coff_puffer.d[$12+2])^=$337c then
          exezk:='C1'
        else if word_z(@coff_puffer.d[$12+2])^=$34bc then
          exezk:='C2'
        else
          exezk:='?.? ¯';
        ausschrift('SPEC / hayras ['+exezk+']',packer_exe);
      end;

    if bytesuche(coff_puffer.d[0],'[SPEC]'#$e8#$00#$00#$00#$00#$5d#$8b#$c5#$81#$ed'???'#$00
         +#$2b#$85'???'#$00#$83#$e8#$0b#$89#$85) then
      begin
        if word_z(@coff_puffer.d[$14+2])^=$2689 then (* mit Odin $00AD2689 statt $0040.... *)
          exezk:='C3'
        else
          exezk:='?.? ¯';
        ausschrift('SPEC / hayras ['+exezk+']',packer_exe);
      end;

    if bytesuche(coff_puffer.d[0],#$52#$31#$c0#$e8#$ff#$ff#$ff#$ff#$c7#$5e#$83#$ee#$0f#$05#$a0#$00#$00#$00#$59
      +#$e9#$01#$00#$00#$00) then
      ausschrift('aPatch / Jõrgen Ibsen',compiler); (* +packer_dat +packer_exe *)

    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$64#$8b#$15#$00#$00#$00#$00#$6a#$ff#$68'????'#$68'????'
      +#$52#$64#$89#$25#$00#$00#$00#$00#$83#$ec) then
      (* Digital Mars Compiler Version 8.38n *)
      (* Digital Mars D Compiler v0.82 *)
      ausschrift('Digital Mars / Walter Bright',compiler);


    (* UN_PENYC.ZIP *)
    if bytesuche(coff_puffer.d[0],#$60#$e8#$00#$00#$00#$00#$5d#$b9'????'#$80#$31'?'#$41#$81#$f9'????'#$7c#$f4) then
      ausschrift('PE-Nightmare / Freddy K [1.3]',packer_exe);



    repeat
      w1:=0;
      if coff_puffer.d[w1]=$60 then
        begin
          Inc(w1); (* 0.03a -coff *)
        end;
      if bytesuche(coff_puffer.d[w1],#$66#$bb) then
        Inc(w1,2+2)                         (* mov bx,$???? *)
      else
        if bytesuche(coff_puffer.d[w1],#$33#$db) then
          begin
            Inc(w1,2); (* xor bx,bx *)
            while coff_puffer.d[w1]=$43 do
              Inc(w1); (* inc ebx *)
          end
        else
          Break;

      if bytesuche(coff_puffer.d[w1],#$66#$b9) then
        Inc(w1,1+1+2) (* mov cx,$???? *)
      else
        if coff_puffer.d[w1]=$b9 then
          Inc(w1,1+4) (* mov ecx,$???????? *)
        else
          Break;


      if bytesuche(coff_puffer.d[w1],#$66#$b8#$01#$05#$cd#$31#$73#$04#$b4#$4c#$cd) then
        (* coff (E2PART.EXE) *)
        (* coff (UPX.EXE (ausgepackt)) *)
        ausschrift('32LiTE / OleGPro [0.02d]',packer_exe);

    until true;

    if bytesuche(coff_puffer.d[0],#$60#$fc#$06#$1e#$07#$be'????'#$bf'????'#$b2#$80#$a4#$e8'????'#$73#$f8) then
      (* -m -coff *)
      ausschrift('32LiTE / OleGPro [0.03a -m]',packer_exe);


    if bytesuche(coff_puffer.d[0],#$60#$06#$fc#$1e#$07#$33#$db#$66#$b9'??'#$66#$b8#$01#$05#$cd#$31) then
      (* LE.EXE -PE *)
      ausschrift('32LiTE / OleGPro [0.02d]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$60#$06#$fc#$1e#$07#$be'????'#$bf'????'#$57#$b2#$80#$a4#$e8) then
      (* -m -pe *)
      ausschrift('32LiTE / OleGPro [0.03a -m]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$eb#$06#$68'????'#$c3#$9c#$60#$bd'????'#$b9#$02) then
      ausschrift('PECompact / Jeremy Collake [0.92]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$eb#$06#$68'????'#$c3#$9c#$60#$e8) then
      begin
        exezk:='?.? ¯';

        if bytesuche(coff_puffer.d[$b],#$00#$00#$00#$00#$5d#$55#$5b#$81) then
          exezk:='0.971';

        if bytesuche(coff_puffer.d[$b],#$00#$00#$00#$00#$8b#$c4#$83#$c0#$04#$8b#$e0) then
          exezk:='0.976';

        if bytesuche(coff_puffer.d[$b],#$02#$00#$00#$00#$33#$c0#$8b#$c4#$83#$c0) then
          case coff_puffer.d[$1e] of
            $42:        exezk:='0.9761';
            $a0:        exezk:='0.977';
            $43,(*DLL*)
            $d1:(*EXE*) exezk:='0.9784';

            $49:(*EXE*) exezk:='0.9781';
            $28:(*EXE/DLL*)exezk:='1.10';
            $0f:(*EXE*) exezk:='1.24';
            $3f:        exezk:='1.67';
          end;

        ausschrift('PECompact / Jeremy Collake ['+exezk+']',packer_exe);
      end;

    if bytesuche(coff_puffer.d[0],#$b8'????'#$50#$64#$ff#$35#$00#$00#$00#$00#$64#$89#$25#$00#$00#$00#$00) then
      begin (* PECompact2 *)
        exezk:=puffer_zu_zk_e(coff_puffer.d[$18],#0,255);
        ausschrift(exezk+' / Jeremy Collake [2.??]',packer_exe);
      end;

    if bytesuche(coff_puffer.d[0],#$55#$57#$56#$52#$51#$53#$e8#$00#$00#$00#$00#$5d#$8b#$d5#$81#$ed'??'#$40#$00#$2b) then
      begin
        if coff_puffer.d[$10]=$97 then
          exezk:='[1.13]'
        else
          exezk:='[1.?? ¯]';
        ausschrift('PE-EXE Encrypter / Stone '+exezk,packer_exe);
      end;

    if bytesuche(coff_puffer.d[0],#$53#$51#$52#$56#$57#$55#$e8#$00#$00#$00#$00#$5d#$81#$ed#$42#$00#$02#$00#$ff#$95) then
      (* STNPEPAK *)
      ausschrift('PEPACK / Stone [2.0]',packer_exe);

    (*                                                                                            #$A#$30#$40#$00 *)
    if bytesuche(coff_puffer.d[0],#$53#$51#$52#$56#$57#$55#$e8#$00#$00#$00#$00#$5d#$8b#$d5#$81#$ed'????'#$2b#$95) then
      ausschrift('PE Diminisher / Teraphy [0.1]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$55#$8d#$44#$24#$f8#$33#$db#$64#$87#$03#$e8#$00#$00#$00#$00) then
      ausschrift('Win95.CIH',virus);

    if bytesuche(coff_puffer.d[0],#$68#$00#$78#$00#$00#$6a#$40#$e8#$d6#$08) then
      (* AVP sagt I-Worm.Happy *)
      (* TB  sagt W32/Ska.A.Worm {1} *)
      (* selbst zugeschiickt bekommen: 2000.01.20 *)
      ausschrift('Ska / Spanska "Happy99"',virus);

    if bytesuche(coff_puffer.d[0],#$55#$e8#$00#$00#$00#$00#$5d#$83#$ed#$06#$8b#$c5#$55#$60#$89#$ad) then
      ausschrift('Crunch / BitArts [1.0]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$33#$c0#$8b#$b8'????'#$8b#$90'????'#$85#$ff#$74) then
      ausschrift('WinKript / WinWare [1.0]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$60#$9c#$8d#$50#$12#$2b#$c9#$b1#$1e#$8a#$02#$34) then
      ausschrift('NFO / bart^CrackPl [1.0]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$3b#$c0#$74#$02#$81#$83#$55#$3b#$c0#$74#$02#$81#$83#$53#$3b#$c9#$74#$01) then
      ausschrift('exe32pack / SteeBytes [1.37,1.38]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$3b'?'#$74#$02#$81'?'#$55#$3b'?'#$74#$02#$81'?'#$53#$3b'?'#$74#$01) then
      begin
        if bytesuche(coff_puffer.d[0],#$3b#$d2#$74#$02#$81#$84#$55#$3b#$ed#$74#$02#$81#$86#$53#$3b#$c0#$74#$01) then
          ausschrift('exe32pack / SteeBytes [1.40]',packer_exe)
        else
        if bytesuche(coff_puffer.d[0],#$3b#$db#$74#$02#$81#$80#$55#$3b#$f6#$74#$02#$81#$83#$53#$3b#$ed#$74#$01) then
          ausschrift('exe32pack / SteeBytes [1.41]',packer_exe)
        else
          ausschrift('exe32pack / SteeBytes [1.4?]',packer_exe);
      end;

    if bytesuche(coff_puffer.d[0],#$66#$8b#$c0#$8d#$24#$24#$eb#$01#$eb#$60#$eb#$01#$eb#$9c#$e8#$00#$00#$00#$00
        +#$5e#$83#$c6) (* 0.41 *)
    or bytesuche(coff_puffer.d[0],#$c1#$ee#$00#$66#$8b#$c9#$eb#$01#$eb#$60#$eb#$01#$eb#$9c#$e8#$00#$00#$00#$00
        +#$5e#$83#$c6) (* sonst *) then
      begin
        case coff_puffer.d[$16] of
          $50:exezk:='0.41';
          $52:exezk:='0.42';
          $5e:exezk:='0.51';
        else  exezk:='0.??¯';
        end;
        ausschrift('tElock / tHE EGOiSTE ['+exezk+']',packer_exe);
      end;

    if bytesuche(coff_puffer.d[0],#$eb#$02#$cd#$20#$eb#$02#$62#$62#$68#$98#$18#$e3#$1a#$eb#$01) then
      ausschrift('FSG / dulek;bart [1.2?]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$be'????'#$ad#$93#$ad#$97#$ad#$56#$96#$b2#$80#$a4#$b6#$80#$ff#$13#$73#$f9) then
      ausschrift('FSG / dulek;bart [1.33]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$bb'????'#$bf'????'#$be'????'#$53#$e8#$0a#$00#$00#$00#$02#$d2#$75#$05) then
      ausschrift('FSG / dulek;bart [1.0?]',packer_exe); (* FVProtect.exe *)


    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$83#$ec#$44#$56#$ff#$15'????'
      +#$8b#$f0#$8a#$06#$3c#$22#$75#$14#$8a#$46#$01#$46#$84#$c0#$74#$04) then
      ausschrift('wextract / Microsoft',packer_dat);


    (* DLL *)
    (* APLIB.DLL *)
    if bytesuche(coff_puffer.d[0],#$b8#$01#$00#$00#$00#$c2#$0c#$00) then
      goto weiter_pe;
    (* JCALG1.DLL -> DELPHI *)
    if bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$33#$c0#$40#$c9#$c2#$0c#$00) then
      goto weiter_pe;


    (*********************************************************************)

    if (not hersteller_gefunden)
    (* push ebp
       mov ebp,esp
       call system.init *)
    and bytesuche(coff_puffer.d[0],#$55#$8b#$ec#$e8'???'#$00)
     then
      begin
        lade_code(eip_pos+longint_z(@coff_puffer.d[4])^+3+5,coff_puffer2);
        (* push ebp
           mov ebp,esp
           mov [?],es
           push ds
           pop es *)
        if bytesuche(coff_puffer2.d[0],#$55#$8b#$ec#$8c#$05'????'#$1e#$07) then
          (* 0.1 BETA 4, WDOSX *)
          ausschrift('Pascal Pro / Khachko Iggor [0.1]',compiler);
      end;


    if bytesuche(coff_puffer.d[0],#$50#$50#$53#$51#$52#$56#$57#$fc#$e8#$00#$00#$00#$00#$5f#$81#$ef#$0d#$00#$00#$00
      +#$8b#$87'????'#$89#$87'????'#$8b#$74#$24'?'#$81#$e6#$00#$f0#$ff#$ff#$66#$81#$3e'MZ') then
      ausschrift('Win32.Xorala',virus); (* wurm *)

    if bytesuche(coff_puffer.d[0],#$eb#$00#$53#$eb#$02#$83#$3d#$51#$eb#$02#$ff) then
      ausschrift('Codecrypt / defiler [0.12]',packer_exe);
    if bytesuche(coff_puffer.d[0],#$e9#$33#$02#$00#$00#$eb#$02#$83#$3d#$58#$eb#$02#$ff) then
      ausschrift('Codecrypt / defiler [0.14]',packer_exe);
    if bytesuche(coff_puffer.d[0],#$e9#$31#$03#$00#$00#$eb#$02#$83#$3d#$58#$eb#$02#$ff) then
      ausschrift('Codecrypt / defiler [0.15]',packer_exe);
    if bytesuche(coff_puffer.d[0],#$eb#$02#$83#$3d#$eb#$02#$c7#$c5#$eb#$02#$0f#$c7) then
      ausschrift('Codecrypt / defiler [0.163]',packer_exe);

    if bytesuche(coff_puffer.d[0],#$64#$a1#$00#$00#$00#$00#$55#$89#$e5#$6a#$ff#$68'????'#$68) then
      ausschrift('lcc-win32 / Jacob Navia',compiler);

    if bytesuche(coff_puffer.d[0],#$e8'????'#$31#$ed#$55#$89#$e5) then
      begin
        lade_code(eip_pos+longint_z(@coff_puffer.d[1])^+5,coff_puffer2);
        if bytesuche(coff_puffer2.d[0],#$66#$c7#$05'????'#$00#$01#$c6#$05'????'#$00#$e8) then
          ausschrift('Stony Brook Modula 2',compiler);
      end;


    if  (not hersteller_gefunden)
    and (coff_puffer.d[0] in [$e9,
                              $eb,
                              $74,
                              $75,    (* ASPACK 1.05b *)
                              $90,    (* ASPACK 1.061B *)
                              $55,    (* DELPHI X *)
                              $60,    (* ASPACK MAXFORMAT.EXE *)
                              $68     (* ASPACK? BackupWiz.exe *)
                                 ]) then
      begin
        sprung_zaehler:=0;
        pelocknt_code_zaehler:=0;
        while (sprung_zaehler<100) do
          begin
            lade_code(eip_pos,coff_puffer);
            if coff_puffer.g=0 then
              Break;
            Inc(sprung_zaehler);

            case coff_puffer.d[0] of
              $eb:
                begin
                  if bytesuche(coff_puffer.d[0],#$eb'?fb:C++HOOK') then
                    begin (* wrar**.exe\Formats\*.fmt *)
                      (* Borland C++ - Copyright 1999 Inprise Corporation *)
                      ausschrift('Borland C++ / Inprise',compiler);
                      Break;
                    end;
                  Inc(eip_pos,shortint(coff_puffer.d[1]+2));
                end;
              $e8,
              $e9:
                begin
                  if bytesuche(coff_puffer.d[0],#$e8#$02#$00#$00#$00#$e8#$00#$e8#$00#$00#$00#$00#$5e#$2b#$c9#$58
                    +#$74#$02#$cd#$20) then
                    begin
                      ausschrift('tElock / tHE EGOiSTE [0.?? (>0.98)]',packer_exe);
                      Break;
                    end;

                  if bytesuche(coff_puffer.d[0],#$e8'????'#$6a#$00#$e8'????'#$89#$05'????'#$e8'????'#$89#$05'????'#$c7#$05)
                   then
                    begin
                      ausschrift('Delphi 2,3,.. / Borland <1>',compiler); (* ohne "portions copyr" *)
                      Break;
                    end;

                  Inc(eip_pos,longint_z(@coff_puffer.d[1])^+5); (* longint *)
                end;

              $1e:
                begin
                  Inc(eip_pos);
                  pelocknt_code_zaehler:=pelocknt_code_zaehler or bit00;
                end;
              $9c:
                begin
                  Inc(eip_pos);
                  pelocknt_code_zaehler:=pelocknt_code_zaehler or bit01;
                end;
              $60:
                begin
                  if bytesuche(coff_puffer.d[0],#$60#$f9#$e8#$02#$00#$00#$00#$e8#$00#$e8#$00#$00#$00#$00#$5e#$2b#$c9#$58) then
                    begin
                      ausschrift('tElock / tHE EGOiSTE [0.98]',packer_exe);
                      Break;
                    end;

                  if bytesuche(coff_puffer.d[0],#$60#$e8#$01#$00#$00#$00'?'#$83#$c4#$04+
                     #$e8#$01#$00#$00#$00'?'#$5d#$81#$ed'????'#$e8) then
                    begin
                      ausschrift('PEX / bart [0.99]',packer_exe); (* aplib *)
                      Break;
                    end;

                  if bytesuche(coff_puffer.d[0],#$60#$e8#$00#$00#$00#$00#$5d#$83#$ed#$06#$80#$bd#$3e) then
                    begin
                      ausschrift('PE-PACK / Stefan Esser [1.00]',packer_exe);
                      Break;
                    end;

                  if bytesuche(coff_puffer.d[0],#$60#$e8#$00#$00#$00#$00#$5d#$81#$ed'???'#$00#$b8'???'#$00#$03#$c5) then
                    begin
                      if longint_z(@coff_puffer.d[9])^=$004398ae{!} then
                        exezk:='1.05b'
                      else if longint_z(@coff_puffer.d[9])^=$0043a8ea then
                        exezk:='1.061b'
                      else if longint_z(@coff_puffer.d[9])^=$0043d93e then
                        exezk:='1.07b'
                      else
                        exezk:='?.? ¯';
                      ausschrift_aspack(exezk);
                      Break;
                    end;

                  if bytesuche(coff_puffer.d[0],#$60#$e8#$03#$00#$00#$00'?'#$eb#$04#$5d#$45#$55#$c3) then
                    begin
                      if bytesuche(coff_puffer.d[$21],#$83#$7d#$25#$00) then
                        begin
                          (* sqeez, BackupWiz.exe *)
                          (*
                          if bytesuche(coff_puffer.d[$56],#$e8) then
                            exezk:='1.23.b'
                          else
                          if bytesuche(coff_puffer.d[$56],#$66) then
                            exezk:='1.23.a,c'
                          else
                            exezk:='1.23? ¯'+hex(coff_puffer.d[$56]);*)
                          exezk:='1.21,123.{abc}';
                        end
                      else
                      if bytesuche(coff_puffer.d[$21],#$83#$bd#$22#$04) then
                        (* seau100/110/111.exe *)
                        exezk:='2.12'   (* nach fi.exe *)
                      else
                        exezk:='?.? ¯';

                      ausschrift_asprotect(exezk);
                      Break;
                    end;

                  if bytesuche(coff_puffer.d[0],#$60#$eb#$0a#$5d#$eb#$02#$ff) then
                    begin
                      ausschrift_aspack('1.08');
                      Break;
                    end;

                  if bytesuche(coff_puffer.d[0],#$60#$e9'??'#$00#$00#$e9#$02#$01#$01#$01) then
                    begin
                      ausschrift_asprotect('1.1b');
                      Break;
                    end;

                  if bytesuche(coff_puffer.d[0],#$60#$e8#$1b#$00#$00#$00#$e9#$fc#$8d#$b5) then
                    begin
                      ausschrift_asprotect('1.2');
                      Break;
                    end;

                  Inc(eip_pos);
                  pelocknt_code_zaehler:=pelocknt_code_zaehler or bit02;
                end;
              $58:
                begin
                  if  bytesuche(coff_puffer.d[0],#$58#$40#$50#$c3)
                  and (pelocknt_code_zaehler=bit00+bit01+bit02)
                   then
                    begin
                      ausschrift('PELOCKnt / Marquis de SoirÇe [2.0x]',packer_exe);
                      perules_bits:=(perules_bits-1) and (not $10000000);
                      Break;
                    end;

                   Inc(eip_pos);
                end; (* $58 *)
              $52:
                begin
                  if bytesuche(coff_puffer.d[0],#$52#$51#$55#$57#$64#$67#$a1#$30#$00) then
                    begin
                      ausschrift('PE-PROTECT / Christoph Gabler [0.9]',packer_exe);
                      break;
                    end;

                  Inc(eip_pos);
                end;
              $74: (* PE-PACK 1.00 *)
                if bytesuche(coff_puffer.d[0],#$74#$00#$e9) then
                  Inc(eip_pos,longint_z(@coff_puffer.d[3])^+7);
              $75: (* ASPACK 1.05b *)
                if bytesuche(coff_puffer.d[0],#$75#$00#$e9)
                or bytesuche(coff_puffer.d[0],#$75#$01#$90) (* ASPACK 1.08 *)
                 then
                  Inc(eip_pos,coff_puffer.d[1]+2);

              $55: (* DELPHI X EMULATION *)
                if bytesuche(coff_puffer.d[0],#$55#$8b#$ec) then
                  (* PUSH EBP
                     MOV EBP,ESP *)
                  Inc(eip_pos,3);
              $83: (* DELPHI X EMULATION *)
                begin
                  if bytesuche(coff_puffer.d[0],#$83#$c4) then
                    (* ADD ESP,-XX *)
                    Inc(eip_pos,3);

                  if bytesuche(coff_puffer.d[0],#$83#$7d#$0c#$01#$75) then
                    (* cmp d [ebp+$c],1 *)
                    (* jne ... *)
                    Inc(eip_pos,4+2);
                end;
              $81: (* DELPHI X EMULATION *)
                begin
                  if bytesuche(coff_puffer.d[0],#$81#$2c#$24'??'#$00#$00#$ff#$64#$24#$04) then
                    begin
                      (* fi.exe: spuica.exe *)
                      ausschrift('tElock / tHE EGOiSTE [0.71b2]',packer_exe);
                      Break;
                    end;
                  if bytesuche(coff_puffer.d[0],#$81#$c4'???'#$ff) then
                    (* ADD ESP,-XXXXXXXX *)
                    Inc(eip_pos,6);
                end;
              $53: (* DELPHI X EMULATION *)
                begin
                  (* PUSH EBX *)
                  Inc(eip_pos);
                end;
              $56: (* DELPHI X EMULATION *)
                begin
                  (* PUSH ESI *)
                  Inc(eip_pos);
                end;
              $57: (* DELPHI X EMULATION *)
                begin
                  (* PUSH EDI *)
                  Inc(eip_pos);
                end;
              $33: (* DELPHI X EMULATION *)
                begin
                  (* XOR EAX,EAX *)
                  if bytesuche(coff_puffer.d[0],#$33#$c0) then
                    Inc(eip_pos,2);
                end;
              $89: (* DELPHI X EMULATION *)
                begin
                  (* MOV [EBP][-.....],EAX *)
                  if bytesuche(coff_puffer.d[0],#$89#$85'???'#$ff) then
                    Inc(eip_pos,6);
                  if bytesuche(coff_puffer.d[0],#$89#$45) then (* kurze Variante: AUTORUN.EXE VIAG INTERCOM CD *)
                    Inc(eip_pos,3);
                end;
              $a1: (* DELPHI X EMULATION *)
                begin
                  (* MOV EAX,[..] *)
                  Inc(eip_pos,5);
                end;
              $c6: (* DELPHI X EMULATION *)
                begin
                  if bytesuche(coff_puffer.d[0],#$c6#$00) then
                    (* MOV B [EAX],.. *)
                    Inc(eip_pos,3);

                  if bytesuche(coff_puffer.d[0],#$c6#$05) then
                    (* mov b [$aabbccdd],$ee *)
                    Inc(eip_pos,2+4+1); (* spep10.deu *)
                end;
              $b8: (* DELPHI X EMULATION *)
                begin
                  (* MOV EAX,x *)
                  Inc(eip_pos,5);
                end;
              $50: (* DELPHI X EMULATION *)
                begin
                  if bytesuche(coff_puffer.d[0],#$50#$6a#$00#$e8'????'#$ba'????'#$52#$89#$05'????'#$89#$42#$04
                     +#$e8'????'#$5a#$58)          (* "normal" *)
                  or bytesuche(coff_puffer.d[0],#$50#$6a#$00#$e8'????'#$ba'????'#$52#$89#$05'????'#$89#$42#$04
                     +#$c7#$42'?'#$00#$00#$00#$00) (* RESGRAB.EXE *)
                   then
                    begin
                      (* mit "portions copyr" (1983,97)*)
                      ausschrift('Delphi 2,3,.. / Borland <2>',compiler);
                      Break;
                    end;

                  Inc(eip_pos); (* SPEP10.DEU *)

                end;
              $90: (* ASPACK 1.061B NOP *)
                Inc(eip_pos);

              $bd:
                begin
                  if bytesuche(coff_puffer.d[0],#$bd#$69#$57#$f1#$84#$b9#$99#$08#$1c#$aa#$e9#$14#00) then
                    begin
                      ausschrift('Win95.Marburg.a',virus);
                      Break;
                    end;
                end;

              $ba:  (* DELPHI X EMULATION *)
                Inc(eip_pos,1+4);

              $8b:
                begin
                  if bytesuche(coff_puffer.d[0],#$8b#$2c#$24#$81#$ed'????'#$c3#$8b#$44#$24#$10#$81#$ec'????'
                      +#$8d#$4c#$24#$04#$50#$e8'????'#$8b#$8c) then
                    begin
                      (* MAXFORMAT.EXE , XACE.EXE *)
                      case coff_puffer.d[$56] of
                        $e8:exezk:='2.1'; (* seau___.exe , sagt fi.exe *)
                        $ef:exezk:='2.001'; (* wace ccrypt.exe , sagt fi.exe *)
                      else  exezk:='2.??? ¯';
                      end;
                      ausschrift_aspack(exezk);
                      Break;
                    end;
                  Break;
                end;
              $68:
                begin
                  if bytesuche(coff_puffer.d[0],#$68'????'#$64#$ff#$35#$00#$00#$00#$00#$64#$89#$25#$00#$00#$00#$00
                     +#$be'????'#$e9'????'#$e8) then
                    begin
                      ausschrift('ZCode / Giuliano Bertoletti',packer_exe); (* 1.01 beta*)
                      Break;
                    end;

                  if bytesuche(coff_puffer.d[0],#$68'????'#$e8#$01#$00#$00#$00#$c3#$c3) then
                    begin
                      (* aspack.. *)
                      eip_pos:=longint_z(@coff_puffer.d[1])^-imagebase;
                    end
                  else
                  if bytesuche(coff_puffer.d[0],#$68'????'#$c3) then
                    begin
                      (* asprotect 1.2 bei ZipSplitter.exe *)
                      eip_pos:=longint_z(@coff_puffer.d[1])^-imagebase;
                    end
                  else
                    Break;
                end;
              $5d:
                begin
                  if bytesuche(coff_puffer.d[0],#$5d#$83#$ed#$06#$eb#$02'??'#$8d#$b5'??'#$00#$00
                    +#$ba'??'#$00#$00#$8a#$3c#$16) then
                    begin
                      ausschrift('PE-SHiELD / ANAKiN [0.25]',packer_exe);
                      Break;
                    end;

                  Break;
                end;
              $f8,$f9,$fc,$fd:
                begin
                  (* telock bei AMisc.dll *)
                  Inc(eip_pos);
                end;
            else

              Break;
            end;
          end;

        (*$IfNDef ENDVERSION*)
        if sprung_zaehler>=100 then
          begin
            herstellersuche:=0;
            ausschrift('TYP_XEXE:POLYMORPH COFF hat nichts gefunden!',dat_fehler);
            ausschrift('EIP='+hex_longint(eip_pos),signatur);
            ausschrift('MEM[EIP]='+hex(coff_puffer.d[0])+' '+hex(coff_puffer.d[1]),signatur);
            herstellersuche:=1;
          end;
        (*$EndIf*)
      end;
    (**************************************************)

  weiter_pe:

    if  ((perules_bits and $ff)>0) then
      begin
        herstellersuche:=0;
        if (perules_bits and $10000000)>0 then
          ausschrift('+ PELOCKnt',signatur);
        if (perules_bits and $20000000)>0 then
          ausschrift('+ PE-Crypt',signatur);
        if (perules_bits and $40000000)>0 then
          ausschrift('+ PEShield',signatur);
        if (perules_bits and $01000000)>0 then
          ausschrift('+ Shrinker',signatur);
        if (perules_bits and $02000000)>0 then
          ausschrift('+ WWpack32',signatur);
        ausschrift('= '+str0((perules_bits and $ff)),signatur);
        herstellersuche:=1;
      end;

    if langformat
    and (word_z(@di_puffer.d[$14-4])^>=$8c-4+4-$18)
    and (word_z(@di_puffer.d[$18-4])^=$010b)
     then
      if  (longint_z(@di_puffer.d[$88-4])^<>0) (* RESOURCE TABLE RVA *)
      and (longint_z(@di_puffer.d[$8c-4])^<>0) (* TOTAL RESOURCE DATA SIZE *)
       then
        begin
          herstellersuche:=0;
          vorgegebene_laenge_des_resourcebereiches:=longint_z(@di_puffer.d[$8c-4])^;
          pe_resourcen1(longint_z(@di_puffer.d[$88-4])^);
          herstellersuche:=1;
        end;

    if (not hersteller_gefunden) then
      begin
        if write_executable then
          ausschrift(textz_vermutlich_gepackt_geschuetzt^,packer_exe)
        else
        if eip_pos<>0 then
          if not Odd(object_bit(eip_pos) shr 29) then (* $20000000=executable *)
            ausschrift(textz_vermutlich_gepackt_geschuetzt^,packer_exe)
      end;


  end; (* coff *)

procedure x_exe_stub_fehler;
  begin
    if x_exe_vorhanden
    and (analyseoff+einzel_laenge>x_exe_basis+x_exe_ofs) then
      begin
        einzel_laenge:=x_exe_basis+x_exe_ofs-analyseoff;
      end;
  end;

procedure beos_information;
  var
    p:puffertyp;
    o:dateigroessetyp;
    a:longint;
  begin
    o:=datei_pos_suche(analyseoff+einzel_laenge,analyseoff-MinDGT(einzel_laenge,1000),'application/x-vnd');
    if o=nicht_gefunden then Exit;
    datei_lesen(p,o,512);
    ausschrift(puffer_zu_zk_e(p.d[0],#0,255),beschreibung);
    IncDGT(o,puffer_pos_suche(p,#0,512)+1);
    while o<analyseoff+einzel_laenge do
      begin
        (* "SMIM",L4(2),L4(1),P˝Str("BEOS:TYPE"       ) L8(-1),L8($8f1ae4) *)
        (* "VPPA",L4(1),L4(1),P˝Str("BEOS:APP_VERSION") L8(-1)             *)
        datei_lesen(p,o,512);
        exezk:=puffer_zu_zk_l(p.d[0],4)+' '+puffer_zu_zk_e(p.d[$e],#0,Min(word_z(@p.d[$c])^,255))+':';
        IncDGT(o,4+4+4+2+word_z(@p.d[$c])^);
        a:=longint_z(@p.d[$4])^;
        while (a>0) and (o<analyseoff+einzel_laenge) do
          begin
            datei_lesen(p,o,8);
            if bytesuche(p.d[0],#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff) then
              exezk_anhaengen(' (-1)')
            else
              begin
                exezk_anhaengen(' (');
                if longint_z(@p.d[4])^<>0 then
                  exezk_anhaengen(hex_longint(longint_z(@p.d[4])^))
                else
                  exezk_anhaengen('$');
                exezk_anhaengen(Copy(hex_longint(longint_z(@p.d[0])^),2,255));
                exezk_anhaengen(')');
              end;
            Dec(a);
            IncDGT(o,8);
          end;
        ausschrift_x(exezk,beschreibung,absatz);
      end;
  end;


procedure elf_386(const p:puffertyp);
  type
    word32=z31;
    Elf32_Ehdr_type=
      packed record
        magic0123         :array[0..3] of char;
        file_class        :byte;
        data_encoding     :byte;
        file_version      :byte;
        padding           :array[$07..$0f] of byte;
        e_type            :smallword;
        e_machine         :smallword;
        e_version         :word32;
        e_entry           :word32;                (* entrypoint                                     *)
        e_phoff           :word32;                (* program header offset                          *)
        e_shoff           :word32;                (* sections header offset                         *)
        e_flags           :word32;
        e_ehsize          :smallword;             (* elf header size in bytes                       *)
        e_phentsize       :smallword;             (* size of an entry in the program header array   *)
        e_phnum           :smallword;             (* 0..e_phnum-1 of entrys                         *)
        e_shentsize       :smallword;             (* size of an entry in sections header array      *)
        e_shnum           :smallword;             (* 0..e_shnum-1 of entrys                         *)
        e_shstrndx        :smallword;             (* index of string section header                 *)
      end;
    z_Elf32_Ehdr_type=^Elf32_Ehdr_type;

    program_header_type=
      packed record
        p_type            :word32;
        p_offset          :word32;
        p_vaddr           :word32;
        p_paddr           :word32;
        p_filesz          :word32;
        p_memsz           :word32;
        p_flags           :word32;
        p_align           :word32;
      end;
    z_program_header_type=^program_header_type;

    sektion_header_type=
      packed record
        sh_name           :word32;
        sh_type           :word32;
        sh_flags          :word32;
        sh_addr           :word32;
        sh_offset         :word32;
        sh_size           :word32;
        sh_link           :word32;
        sh_info           :word32;
        sh_addralign      :word32;
        sh_entsize        :word32;
      end;
    z_sektion_header_type=^sektion_header_type;

  var
    elf_code_puffer,
    ph_puffer,
    sh_puffer                   :puffertyp;
    z,w1                        :word_norm;
    o                           :dateigroessetyp;
    el                          :dateigroessetyp;
  begin
    with z_Elf32_Ehdr_type(@p.d)^ do
      begin
        if (e_phoff=0) or (e_phentsize=0) or (e_phnum=0) then
          Exit;

        el:=e_phoff+e_phnum*e_phentsize;
        o:=0;

        for z:=0 to e_phnum-1 do
          begin
            datei_lesen(ph_puffer,analyseoff+e_phoff+z*e_phentsize,SizeOf(program_header_type));
            with z_program_header_type(@ph_puffer.d)^ do
              begin
                if (p_vaddr<=e_entry) and (p_vaddr+p_filesz>=e_entry)
                and (p_type=1) (* PT_LOAD *)
                 then
                  o:=analyseoff+p_offset+(e_entry-p_vaddr);

                el:=MaxDGT(el,p_offset+p_filesz);
              end;
          end;

        if (e_shoff<>0) and (e_shentsize<>0) and (e_shnum<>0) then
          begin
            el:=MaxDGT(el,e_shoff+e_shnum*e_shentsize);
            for z:=0 to e_shnum-1 do
              begin
                datei_lesen(sh_puffer,analyseoff+e_shoff+z*e_shentsize,SizeOf(sektion_header_type));
                with z_sektion_header_type(@sh_puffer.d)^ do
                  if sh_type<>8(*SHT_NOBITS*) then
                    el:=MaxDGT(el,sh_offset+sh_size);
              end;
          end;

        if o=0 then exit;

        einzel_laenge:=el;

        datei_lesen(elf_code_puffer,o,512);
        (*$IfNDef ENDVERSION*)
        ausschrift('eip_o='+strx_oder_hexDGT(o),signatur);
        (*$EndIf*)

        if bytesuche(elf_code_puffer.d[0],#$b9'????'#$b8'???'#$00#$e8'????'#$e8) then
          (* Jîrg Pleumann, V.K. PE2ELF *)
          begin
            ausschrift('Virtual Pascal / vpascal.com'(*fPrint UK*),compiler);
            if e_ehsize=SizeOf(Elf32_Ehdr_type) then
              if bytesuche(p.d[e_ehsize],#13#10'----') then
                begin
                  w1:=puffer_pos_suche(p,'----'#13#10,e_ehsize+200);
                  if w1<>nicht_gefunden then
                    ausschrift_modulbeschreibung(datei_lesen__zu_zk_e(analyseoff+w1+Length('----'#13#10),#13#10,255));
                end;
          end;

        if bytesuche(elf_code_puffer.d[0],#$31#$ed#$58#$89#$e1#$8d#$54#$81#$04)
           (* 0.94 *)
        or bytesuche(elf_code_puffer.d[0],#$31#$ed#$5e#$8d#$44#$b4#$04#$89#$e2#$56#$83#$e4#$f8#$50#$52#$e8)
           (* 0.70,0.81 *)
         then
          begin
            ausschrift('UPX / Markus F.X.J. Oberhumer & L†szl¢ Moln†r',packer_exe); (* EXE? *)
            (*with z_program_header_type(@ph_puffer.d)^ do
              einzel_laenge:=p_offset+p_filesz;*)
          end;

        if bytesuche(elf_code_puffer.d[0],#$59#$89#$e3#$89#$c8#$40#$c1#$e0#$02#$01#$e0#$83#$e4#$f8#$a3'????'
            +#$89#$0d'????'#$89#$1d'????'#$9b#$db#$e3#$9b) then
          ausschrift('FreePascal',compiler);

        if bytesuche(elf_code_puffer.d[0],#$31#$ed#$5e#$89#$e1#$83#$e4'?'#$50#$54#$52#$68'????'#$68'????'#$51#$56#$68'????'
             +#$e8'????'#$f4) then
          ausschrift('gcc',compiler);

      end;
  end;

function coff_prozessor(const n:word_norm):string;
  begin
    case n of
      $014c:coff_prozessor:='Intel 80386';
      $014d:coff_prozessor:='Intel 80486';
      $014e:coff_prozessor:='Intel 80586';
      $0166:coff_prozessor:='MIPS R4000';
      $0184:coff_prozessor:='DEC Alpha';
      $01a2:coff_prozessor:='SH3'; (* arjfolder *)
      $01c0:coff_prozessor:='ARM'; (* pcketrar.exe: 00000rar.001 *)
      $01df:coff_prozessor:='RISC System/6000';
      $01f0:coff_prozessor:='PowerPC';
      $0268:coff_prozessor:='Motorola 68000';
      $0290:coff_prozessor:='PA-RISC';
    else
            coff_prozessor:=textz_dien__unbekannte_Zielprozessor^+' ('+hex_word(n)+')¯';
    end;
  end;

procedure pruefe_coff(const p:puffertyp;const intel_richtung:boolean);

  function y_word(const p):smallword;
    begin
      if intel_richtung then
        y_word:=word_z(@p)^
      else
        y_word:=m_word(p);
    end;

  function y_longint(const p):longint;
    begin
      if intel_richtung then
        y_longint:=longint_z(@p)^
      else
        y_longint:=m_longint(p);
    end;

  var
    kopf_laenge:word_norm;

  begin
    kopf_laenge:=$14+y_word(p.d[$10]);
    (* rewerse word lo/hi gleich? *)
    if ((p.d[$12] and $80)<>(p.d[$12+1] and $80)) then Exit;
    (* Pa·t die CPU-Kennung dazu? *)
    (* if intel_richtung<>Odd(p.d[$12] shr 7) then Exit;  ( * stimmt bei SCO nicht *)
(*    if (y_longint(p.d[8])>0) and (p.d[8]<einzel_laenge) then ( * symbol table.. * )
      einzel_laenge:=y_longint(p.d[8]); *)
    ausschrift('Common Object File Format - ('+coff_prozessor(y_word(p.d[$00]))+')',signatur);
    ausschrift('Objekte: '+str0(y_word(p.d[$02])),normal);
    ausschrift('Flags: '+hex_word(y_word(p.d[$12])),normal);
    if kopf_laenge>=$18 then
    ausschrift('Version: '+str0(p.d[$16])+'.'+str0(p.d[$17]),compiler);
    if kopf_laenge>=$3e then
    ausschrift('OS: '+str0(p.d[$3c])+'.'+str0(p.d[$3d]),normal);
  end;


end.

