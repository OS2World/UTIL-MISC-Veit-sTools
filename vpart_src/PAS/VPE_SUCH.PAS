var
  lvm_gefunden                  :boolean;

type
  smallword_rec=
    packed record
      l,h                       :byte;
    end;

type
  gefundene_partition_eintrag_typ=
    record
      laufwerk                  :byte;
      dx_register               :word_norm;
      cx_register               :word_norm;
      zylinder                  :word_norm;
      end_zylinder              :word_norm;
      kopf                      :word_norm;
      sektor                    :word_norm;
      lba_sektor                :longint;
      laufwerks_typ             :diskettentyp_typ;
      dateisystem               :byte;
      groesse_in_sektoren       :longint;
      primaer                   :boolean;
      dos_laufwerk              :char;
      os2_laufwerk              :char;
      lvm_laufwerk              :char;
      ibm_bootmanager_name      :string[20];
      ico_name_empfohlen        :string[20];
      titel_empfohlen           :string[betriebssystem_titel_laenge];
      bootsektor_signaturbyte   :byte;
      logische_laufwerksnummer  :byte;
      empfohlen                 :boolean;
      kennung                   :string;
      datentraegername          :string[8+3];
      oemname                   :string[8];
      suspendpartition          :boolean;
      sektoren_je_spur_         :longint;
      anzahl_koepfe_            :longint;
      lvm_plattenname_          :string[20];
      versteckbar               :boolean;
      versteckbar_gewaehlt      :boolean;

      partitionstabelle_cx_reg,
      partitionstabelle_dx_reg  :smallword; (* $0001,$0080 *)
      partitionstabelle_lba     :longint;   (* -1          *)
      partitionstabelle_lvmsekt :byte;      (* +62         *)
      partitionstabelle_eintrag :byte;
      partitionstabelle_anfang  :smallword; (* CX des Startsektors *)
    end;

  laufwerksbuchstabenzuordnung_typ=
    packed record
      u_3c              :longint;
      u_40              :longint;
      laenge            :longint;               (* PartitionslÑnge in Sektoren *)
      start             :longint;               (* Startsektor *)
      u_4c              :smallword;             (* 1 *)
      buchstabe         :array[0..1] of char;   (* 'C' #0 *)
      vol_name          :array[1..20] of char;
      part_name         :array[1..20] of char;
    end;

  lvm_sektor_typ        = (* lezter Sektor in der selben Spur zu jeder Partitionstabelle *)
    packed record
      signatur          :array[0..7] of char;   (* #$02'RMBPMFD' *)
      pruefsumme        :longint;
      plattenseriennummer       :longint;
      startplattenseriennummer  :longint;       (* meist wie plattenseriennummer *)
      u_14              :longint;               (* 0 *)
      zylinder          :longint;
      koepfe            :longint;
      sektoren          :longint;
      plattenname       :array[1..20] of char;
      u_38              :longint;               (* 0 *)
      laufwerksbuchstabenzuordnung:packed array[1..4] of laufwerksbuchstabenzuordnung_typ;
      rest              :array[1..512-$3c-4*SizeOf(laufwerksbuchstabenzuordnung_typ)] of byte
    end;


const
  (*$IFDEF VirtualPascal*)
  begrenzung_gefundene_partitionen=200;
  (*$ELSE*)
  begrenzung_gefundene_partitionen= 50;
  (*$ENDIF*)

var
  gefundene_partitionen_anzahl  :word_norm;
  gefundene_partitionen_tabelle :array[1..begrenzung_gefundene_partitionen] of gefundene_partition_eintrag_typ;

const
  bootmgr_sondernamen_anzahl    :word_norm=0;
var
  bootmgr_sondernamen_tabelle   :array[1..32] of
    record
      anfangs_zylinder          :longint;
      anfangs_kopf              :longint;
      anfangs_sektor            :longint;
      name_des_sektors          :string[8];
    end;

const
  partitionstypen_versteckter_typ:array[1..8] of
    record
      sichtbarer_typ,
      versteckter_typ           :byte;
    end=
  ((sichtbarer_typ:$01;versteckter_typ:$11),
   (sichtbarer_typ:$04;versteckter_typ:$14),
   (sichtbarer_typ:$04;versteckter_typ:$84), (* ? *)
   (sichtbarer_typ:$06;versteckter_typ:$16),
   (sichtbarer_typ:$07;versteckter_typ:$17),
   (sichtbarer_typ:$0b;versteckter_typ:$1b),
   (sichtbarer_typ:$0c;versteckter_typ:$1c),
   (sichtbarer_typ:$0e;versteckter_typ:$1e));

var
  (* Verweis auf den jeweiligen Eintrag in gefundene_partitionen_tabelle *)
  verweis_zu_versteckende_partitionen:array[1..High(ergebnis.zu_versteckende_partitionen)] of word_norm;


(* aus TYP_SEKT.PAS ..*)
function partitionstyp(const t:byte):string;
  begin
    case t of
      $00:partitionstyp:=textz_sekt__frei^;
      $01:partitionstyp:='DOS 12 Bit FAT';
      $02,
      $03:partitionstyp:='XENIX';
      $04:partitionstyp:='DOS 16 Bit FAT';
      $05:partitionstyp:=textz_sekt__erweitert^;
      $06:partitionstyp:='DOS 16 Bit FAT >32 MB';
      $07:partitionstyp:='OS/2 IFS -> HPFS';
      $08,
      $09:partitionstyp:='AIX';
      $0a:partitionstyp:='OS/2 Bootmanager';
      $0b:partitionstyp:='Windows 32 Bit FAT';
      $0c:partitionstyp:='Windows 32 Bit FAT LBA';
      $0e:partitionstyp:='Windows 16 Bit FAT LBA';
      $0f:partitionstyp:='Windows '+textz_sekt__erweitert^+' LBA';
      $10:partitionstyp:='OPUS';
      $11,
      $14,
      $16,
      $17,
      $1b,
      $1c,
      $1e:partitionstyp:=textz_sekt__versteckt^+partitionstyp(t-$10);
      $20:partitionstyp:='OFS1';
      $21:partitionstyp:='FSo2';
      $24:partitionstyp:='NEC MS-DOS 3.x';
      $35:partitionstyp:='LVM';
      $38..$3b
         :partitionstyp:='Theos';
      $3c:partitionstyp:='PQMAGIC Recovery';
      $40:partitionstyp:='VENIX 80286';
      $41:partitionstyp:='Personal RISC Boot';
      $42:partitionstyp:='Secure File System';
      $50:partitionstyp:='OnTrack Disk Manager R';
      $51:partitionstyp:='Novell,OnTrack Disk Manager RW';
      $52:partitionstyp:='CP/M';
      $54:partitionstyp:='OnTrack Disk Manager DDO';
      $56:partitionstyp:='GoldenBow VFeature';
      $61:partitionstyp:='SpeedStor';
      $63:partitionstyp:='Unix SysV/386, 386/ix, Mach, GNU HURD';
      $64:partitionstyp:='Novell NetWare 286';
      $65:partitionstyp:='Novell NetWare (3.11)';
      $67,
      $68,
      $69:partitionstyp:='Novell';
      $70:partitionstyp:='DiskSecure Multi-Boot';
      $75:partitionstyp:='PC/IX';
      $7e:partitionstyp:='F.I.X.';
      $80:partitionstyp:='Minix v1.1 - 1.4a';
      $81:partitionstyp:='Minix v1.4b+, Linux';
      $82:partitionstyp:='Linux '+textz_sekt__Auslagerung^+', Prime, Solaris';
      $83:partitionstyp:='Linux ext2fs';
      $84:partitionstyp:=textz_sekt__versteckt^+'DOS 16 Bit FAT, Suspend';
      $86:partitionstyp:='FAT16 volume/stripe set (Windows NT)';
      $87:partitionstyp:='HPFS Fault-Tolerant mirrored, NTFS volume/stripe set';
      $93:partitionstyp:='Amoeba FS';
      $94:partitionstyp:='Amoeba BAD';
      $a0,
      $a1,
      $aa:partitionstyp:='Phoenix NoteBIOS Power Management';
      $a5:partitionstyp:='FreeBSD, BSD/386';
      $a6:partitionstyp:='OpenBSD';
      $a7:partitionstyp:='NEXTSTEP';
      $a9:partitionstyp:='NetBSD';

      $b7,
      $b8:partitionstyp:='BSDI';
      $c0:partitionstyp:='Novell DOS 7'+textz_mit_Absicherung^;
      $c1,
      $c4,
      $c6:partitionstyp:='DR-DOS 6.0'+textz_mit_Absicherung^+' '+partitionstyp(t-$c0);
      $c7:partitionstyp:='Syrinx Boot';
      $d8:partitionstyp:='CP/M-86';
      $db:partitionstyp:='CP/M, Concurrent DOS, CTOS';
      $e1:partitionstyp:='SpeedStor 12 Bit';
      $e4:partitionstyp:='SpeedStor 16 Bit';
      $f2:partitionstyp:='DOS 3.3+ '+textz_sekt__sekundaer^;
      $fe:partitionstyp:='LANstep, IBM PS/2 IML';
    else
          partitionstyp:=textz_unbekanntes_System_Nr^+Int2Hex(t,2)+' ¯';
    end;

  end; (* partitionstyp *)

procedure sektor_zu_mb(const a:longint;var s:string);
  begin
    if a<=0 then
      s:='     ?'+' MB'
    else
      (* 1..5 MB -> KB *)
      if (a<10000) then
        begin
          Str(a div sektoren_je_kb:6,s);
          s:=s+' KB';
        end
      else
        begin
          Str(a div sektoren_je_mb:6,s);
          s:=s+' MB';
        end;
  end;

procedure  partition_eintragname(i:word_norm;var ergebnis:string);
  begin
    with gefundene_partitionen_tabelle[i] do
      begin
        sektor_zu_mb(groesse_in_sektoren,ergebnis);

        ergebnis:=ergebnis+'  ';

        if laufwerk<$80 then
          ergebnis:=ergebnis+textz_Diskette_^
        else if laufwerk=$ff then
          ergebnis:=ergebnis+textz_CDROM_^
        else
          begin
            if primaer then
              ergebnis:=ergebnis+textz_Primaer_^
            else
              ergebnis:=ergebnis+textz_logisch_^;
            ergebnis:=ergebnis+partitionstyp(dateisystem);
          end;
      end;
  end;

var
  lvm_plattennamen_breite       :word_norm;

procedure partition_eintraghilfe(i:word_norm;var ergebnis:string);
  var
    plattenname                 :string;
    abstand                     :string[5];
    lvm_bm_name                 :string;
  begin
    with gefundene_partitionen_tabelle[i] do
      begin
        if lvm_plattennamen_breite=0 then
          begin
            plattenname:='';
            abstand:='   ';
          end
        else
          begin
            plattenname:=' '+lvm_plattenname_;
            leerzeichenerweiterung(plattenname,lvm_plattennamen_breite);
            abstand:='  ';
          end;

        ergebnis:=textz_Partitionstyp^;
        if (laufwerk<$80) or (laufwerk=$ff) then
          ergebnis:=ergebnis+'= --'
        else
          ergebnis:=ergebnis+'=$'+Int2Hex(dateisystem,2)
                    +abstand
                    +textz_Festplatte__^+Int2Hex(laufwerk,2)
                    +plattenname
                    +abstand
                    +textz_Zylinder_^+Int2Str(zylinder)+textz__bis_^+Int2Str(end_zylinder);

        ergebnis:=ergebnis+^m^j
                  +textz_vermutete_Laufwerksbuchstaben^+':  DOS:'+dos_laufwerk
                                                       +'  OS/2:'+os2_laufwerk
                                                       +'  LVM:'+lvm_laufwerk;

        lvm_bm_name:=ibm_bootmanager_name;
        leerzeichenerweiterung(lvm_bm_name,20);

        ergebnis:=ergebnis+^m^j
                    {+textz_IBM_Bootmanager_Name^+}
                    +'IBM BM/LVM: '+lvm_bm_name;

        ergebnis:=ergebnis+textz__Datentraegername__^+datentraegername;

        ergebnis:=ergebnis+' Format: '+oemname;
    end;
  end;



procedure partition_merken(
            const laufwerk0             :byte;
            const zylinder0,kopf0,sektor0,
                  zylinder1,kopf1,sektor1,
                  anzahl_koepfe,
                  sektoren_je_spur      :longint;
            const primaer0              :boolean;
            const diskettentyp          :diskettentyp_typ;
            const partitionsgroesse     :longint; (* in 512 Byte-Sektoren *)
            const ibm_bootmanager_name0 :string;
            const lvm_buchstabe         :char;
            const lvm_plattenname       :string;
            const partitions_typ        :byte;

            const partitionstabelle_cx_reg_,
                  partitionstabelle_dx_reg_ :smallword; (* $0001,$0080 *)
            const partitionstabelle_lba_    :longint;   (* -1          *)
            const partitionstabelle_lvmsekt_:byte;      (* +62         *)
            const partitionstabelle_eintrag_:byte;      (* 2           *)
            const partitionstabelle_anfang_ :smallword);


  var
    kennung3                    :string[3];

    name                        :string;
    sr                          :searchrec;
    p                           :dirstr;
    n                           :namestr;
    e                           :extstr;
    bootsektor                  :partitionstabellentyp;
    so                          :longint;
    spur                        :word_norm;
    zeichennr                   :byte;
    syswahl                     :string;
    partitions_groesse          :string;
    zaehler                     :byte;
    korrekt                     :boolean;
    liste_bs                    :auswahl_tabelle_typ;
    bsuche                      :word_norm;
  begin
    if gefundene_partitionen_anzahl=High(gefundene_partitionen_tabelle) then
      begin
        (* kein Platz mehr *)
        Write('-');
        Exit;
      end;

    Inc(gefundene_partitionen_anzahl);
    with gefundene_partitionen_tabelle[gefundene_partitionen_anzahl] do
      begin
        partitionstabelle_cx_reg :=partitionstabelle_cx_reg_ ;
        partitionstabelle_dx_reg :=partitionstabelle_dx_reg_ ;
        partitionstabelle_lba    :=partitionstabelle_lba_    ;
        partitionstabelle_lvmsekt:=partitionstabelle_lvmsekt_;
        partitionstabelle_eintrag:=partitionstabelle_eintrag_;
        partitionstabelle_anfang :=partitionstabelle_anfang_;

        oemname:='';
        suspendpartition:=false;
        laufwerk:=laufwerk0;
        dos_laufwerk:='-';
        os2_laufwerk:='-';
        lvm_laufwerk:=lvm_buchstabe;
        lvm_plattenname_:=lvm_plattenname;
        empfohlen:=false;
        smallword_rec(dx_register).l:=laufwerk;
        smallword_rec(dx_register).h:=kopf0;

        if zylinder0>=1024 then
          begin
            smallword_rec(cx_register).l:=sektor0 or $c0;
            smallword_rec(cx_register).h:=$ff;
          end
        else
          begin
            smallword_rec(cx_register).l:=sektor0 or ((zylinder0 shr 8) shl 6);
            smallword_rec(cx_register).h:=zylinder0 and $ff;
          end;

        zylinder:=zylinder0;
        end_zylinder:=zylinder1;
        kopf:=kopf0;
        sektor:=sektor0;

        sektoren_je_spur_:=sektoren_je_spur;
        anzahl_koepfe_:=anzahl_koepfe;

        if (sektoren_je_spur_=0) or (anzahl_koepfe_=0) then
          begin
            sektoren_je_spur_:=63;
            anzahl_koepfe_:=255;
          end;

        kennung:='L=$'+Int2Hex(laufwerk,2)+'_Z='+Int2Str(zylinder)+'_K='+Int2Str(kopf)+'_S='+Int2Str(sektor);

        (* Sektoren bis zum Anfang dieses Zylinders *)
        lba_sektor:=zylinder0*sektoren_je_spur*anzahl_koepfe;
        (* dazu die Anzahl der Sektoren bis zum Anfangskopf *)
        Inc(lba_sektor,kopf0*sektoren_je_spur);

        laufwerks_typ:=diskettentyp;
        dateisystem:=partitions_typ;
        groesse_in_sektoren:=partitionsgroesse;
        primaer:=primaer0;

        ibm_bootmanager_name:=ibm_bootmanager_name0;
        if ibm_bootmanager_name='' then
          for bsuche:=1 to bootmgr_sondernamen_anzahl do
            if  (bootmgr_sondernamen_tabelle[bsuche].anfangs_zylinder=zylinder)
            and (bootmgr_sondernamen_tabelle[bsuche].anfangs_kopf    =kopf    ) then
              ibm_bootmanager_name:=bootmgr_sondernamen_tabelle[bsuche].name_des_sektors;

        ico_name_empfohlen:='';
        titel_empfohlen:=ibm_bootmanager_name;
        bootsektor_signaturbyte:=0;
        logische_laufwerksnummer:=laufwerk;
        datentraegername:='        '+'   ';

        if laufwerk<$80 then
          begin
            titel_empfohlen:=textz_Laufwerk^+' '+Chr(Ord('A')+laufwerk)+':';
            case diskettentyp of
              diskettentyp_13cm:
                ico_name_empfohlen:='lauf13cm';
              diskettentyp_09cm:
                ico_name_empfohlen:='lauf09cm';
              diskettentyp_sonst:
                ico_name_empfohlen:='atapi';
              diskettentyp_festplatte:
                ico_name_empfohlen:='festplat';
            else
                ico_name_empfohlen:='';
            end;
          end;


        if read_phys_sector(laufwerk,
                            zylinder,kopf,sektor,
                            anzahl_koepfe,sektoren_je_spur,
                            sector_typ(bootsektor))<>0 then
          begin (* nicht lesbar .. *)
            Write('?');
            Exit;
          end;

        (* lesbar *)
        Write('.');


        with bootsektor do
          if (sprung_[0] in [$e9,$eb])
          or ((sprung_[0]=$fa) and (sprung_[1]=$eb)) (* Linux Mandrake 7 *)
          or ((name_vpart[3]='I') and (name_vpart[4]='B') and (name_vpart[5]='M')) (* IBM 4.50 JFS *)
           then
            oemname:=name_vpart;

        if (bootsektor.sprung_[0]=$eb) and (not (bootsektor.sprung_[2] in [$90,$00,$20,$ff])) then
          begin
            oemname[0]:=#8;
            Move(bootsektor.sprung[2],oemname[1],8);
          end;

        (* OS/2 BM: 'APJ&WN'#26#0 *)
        while (oemname<>'') and (oemname[Length(oemname)] in [#0..' ',#$f6]) do
          Dec(oemname[0]);

        for zaehler:=1 to Length(oemname) do
          if oemname[zaehler]<' ' then
            oemname[zaehler]:='.';

        bootsektor_signaturbyte:=bootsektor.signaturbyte;
        logische_laufwerksnummer:=bootsektor.reserviert_25;
        if bootsektor_signaturbyte in [$28,$29] then
          datentraegername:=bootsektor.datentraegername;

        if (Pos('FAT32',bootsektor.fat32_sig)=1) and (bootsektor.signaturbyte_fat32=$29) then
          begin
            bootsektor_signaturbyte:=bootsektor.signaturbyte_fat32;
            logische_laufwerksnummer:=bootsektor.reserviert_log_laufnummer_fat32;
            datentraegername:=bootsektor.datentraegername_fat32;
          end;


        if groesse_in_sektoren=0 then
          begin
            groesse_in_sektoren:=bootsektor.anz_sektoren_neu;
            if groesse_in_sektoren=0 then
              groesse_in_sektoren:=bootsektor.anz_sektoren;
          end;



        case partitions_typ of
          $0b,$0c,$0e:
            begin
              ico_name_empfohlen:='windows1';
              titel_empfohlen:='MS Windows';
            end;

          $82:
            begin
              ico_name_empfohlen:='solaris';
              titel_empfohlen:='Solaris';
            end;

          (* auf die Idee, einer Suspendpartition die Nummer
           einer veersteckten FAT-16-Partition zuzuteilen kann
           aber auch nur SystemSoft kommen... *)
          $84:
            if bootsektor.name_vpart='temSoft ' then
              begin
                suspendpartition:=true;
                ico_name_empfohlen:='leer';
                oemname:='SystemSo';
                titel_empfohlen:='Suspend Data File'; (* sinnlos weil nicht startbar *)
              end;

          $a5:
            begin
              ico_name_empfohlen:='bsd';
              titel_empfohlen:='FreeBSD';
            end;

          $a6:
            begin
              ico_name_empfohlen:='bsd';
              titel_empfohlen:='OpenBSD';
            end;

          $a9:
            begin
              ico_name_empfohlen:='bsd';
              titel_empfohlen:='NetBSD';
            end;
        end;

        if laufwerk>=$80 then (* Festplattenpartition *)
          begin
            kennung3:=Copy(bootsektor.name_boot,1,3);

            if kennung3='APJ' then
              begin
                ico_name_empfohlen:='bootman';
                titel_empfohlen:='OS/2 '+textz_Bootmanager^;
              end;

            if (kennung3='ILO')
            or (Copy(bootsektor.name_boot,1,7)='lbaLILO')
             then
              begin
                ico_name_empfohlen:='linux';
                titel_empfohlen:='Linux';
              end;

            if kennung3='IBM' then
              begin
                ico_name_empfohlen:='IBM';
                titel_empfohlen:='IBM DOS';
              end;

            if (Copy(bootsektor.name_boot,1,5)='IBM 2')
            or (Copy(bootsektor.name_boot,1,5)='IBM 4') (* eCS,WSEB *)
            or (kennung3                      ='OS2'  )
             then
              begin
                ico_name_empfohlen:='OS2';
                titel_empfohlen:='IBM OS/2';
              end;

            if kennung3='NWD' then
              begin
                ico_name_empfohlen:='nwdos';
                titel_empfohlen:='Novell Dos 7';
              end;

            if kennung3='DRD' then
              begin
                ico_name_empfohlen:='caldera';
                titel_empfohlen:='DR Dos 7';
              end;

            if kennung3='MSD' then
              begin
                ico_name_empfohlen:='msdos01';
                titel_empfohlen:='Microsoft Dos';
              end;

          end; (* Festplattenpartition *)

      end; (* with *)

  end;

(*******************************************************************)

procedure bootmgr_auslesen(z,k,s,a_k,a_s:longint);
  type
    b_eintrag=
      packed record
        a00             :byte;
        dh_wert         :byte;
        cx_wert         :smallword;
        a04             :byte;
        bname           :array[0..7] of char;
        a0d_a0f         :array[$0d..$0f] of byte;
      end;
  var
    isekt               :sector_typ;
    bsekt               :array[0..31] of b_eintrag absolute isekt;
    zk                  :string[9];

  begin
    if read_phys_sector($80,z,k,s,a_k,a_s,isekt)<>0 then exit;

    for z:=Low(bsekt) to High(bsekt) do
      with bsekt[z] do
        begin
          zk:=Copy(bname,1,8);
          if ohne_steuerzeichen(zk) and (a04=$01) then
            begin

              Inc(bootmgr_sondernamen_anzahl);
              with bootmgr_sondernamen_tabelle[bootmgr_sondernamen_anzahl] do
                begin
                  anfangs_zylinder:=Hi(cx_wert) or (Lo(cx_wert) and $c0) shl 2;
                  anfangs_kopf:=dh_wert;
                  anfangs_sektor:=cx_wert and $3f;
                  name_des_sektors:=zk;
                end;
            end;
        end;


  end;

(*******************************************************************)

procedure festplatte_absuchen(const laufwerk            :byte;
                                    anzahl_koepfe       :longint;
                                    sektoren_je_spur    :longint;
                                    zylinder,
                                    kopf,
                                    sektor              :longint;
                                    tiefe               :word_norm;
                              const lba_relativ         :longint;
                                    lba_anfang_erweitert:longint);
  var
    ptab                        :partitionstabellentyp;
    partinr                     :byte;
    bootmanager_name            :string[20];
    anzahl_zylinder             :longint;
    diskettenlaufwerkstyp       :byte;

    zylinder_neu,
    kopf_neu,
    sektor_neu,
    zylinder_ende,
    kopf_ende,
    sektor_ende                 :longint;

    s1,s2                       :longint;

    lvm_informationen_gefunden  :boolean;

    lvm_sektor                  :lvm_sektor_typ;
    lvm_buchstabe               :char;
    lvm_plattenname             :string;

    cxr,dxr                     :smallword;
    lba                         :longint;

    lvm_informationssektor      :byte; (* 0 wenn kein Eintrag vorhanden, sonst Sektor je Spur-1 *)

  begin
    if tiefe=0 then
      begin
        Write(laufwerk-$80+1,'.'+textz_Festplatte^);
        if get_phys_drive_parameters(laufwerk,anzahl_zylinder,anzahl_koepfe,sektoren_je_spur,diskettenlaufwerkstyp)<>0 then
          begin
            WriteLn(textz___nicht_vorhanden^);
            Exit;
          end;
        Write(' [',anzahl_zylinder,'/',anzahl_koepfe,'/',sektoren_je_spur,'] ');
      end;


    if zylinder>=1024 then
      begin
        cxr:=$ffff;
        dxr:=laufwerk;
        lba:=(zylinder*anzahl_koepfe+kopf)*sektoren_je_spur+sektor-1
      end
    else
      begin
        cxr:=smallword(Lo(zylinder) shl 8 + Hi(zylinder) shl 6 + sektor);
        dxr:=laufwerk + kopf shl 8;
        lba:=-1;
      end;

    if read_phys_sector(laufwerk,
                        zylinder,kopf,sektor,
                        anzahl_koepfe,sektoren_je_spur,
                        sector_typ(ptab))=0 then
      begin
        if tiefe=0 then
          festplattenzahl:=laufwerk-$80+1;

        if (tiefe=0) and (laufwerk=$80) then
          begin
            for partinr:=1 to 4 do
              with ptab.partidaten[partinr] do
                if system_indicator=10 then
                  bootmgr_auslesen(Hi(start_cx) or (Lo(start_cx) and $c0) shl 2,start_dh,4,anzahl_koepfe,sektoren_je_spur);
          end;


        if ptab.ibm_signatur=$AA55 then
          begin

            lvm_informationen_gefunden:=false;
            if read_phys_sector(laufwerk,
                        zylinder,kopf,sektoren_je_spur,
                        anzahl_koepfe,sektoren_je_spur,
                        sector_typ(lvm_sektor))=0 then
              lvm_informationen_gefunden:=(lvm_sektor.signatur=#$02'RMBPMFD');

            for partinr:=1 to 4 do
              with ptab.partidaten[partinr] do
                begin

                  zylinder_neu :=Hi(start_cx) or (Lo(start_cx) and $c0) shl 2;
                  kopf_neu     :=start_dh;
                  sektor_neu   :=Lo(start_cx) and $3f;

                  zylinder_ende:=Hi(ende_cx) or (Lo(ende_cx) and $c0) shl 2;
                  kopf_ende    :=ende_dh;
                  sektor_ende  :=Lo(ende_cx) and $3f;

                  if (zylinder_neu=1023) or (zylinder_ende=1023) then
                    begin
                      if system_indicator in [$05,$0f] then (* Anfang einer erweiterten Partition wird anders berechnet *)
                        s1:=lba_anfang_erweitert+sektoren_davor
                      else
                        s1:=lba_relativ         +sektoren_davor;
                      s2:=s1+anzahl_sektoren-1;

                      sektor_neu:=(s1 mod sektoren_je_spur)+1;
                      s1:=s1 div sektoren_je_spur;
                      kopf_neu:=s1 mod anzahl_koepfe;
                      zylinder_neu:=s1 div anzahl_koepfe;

                      sektor_ende:=(s2 mod sektoren_je_spur)+1;
                      s2:=s2 div sektoren_je_spur;
                      kopf_ende:=s2 mod anzahl_koepfe;
                      zylinder_ende:=s2 div anzahl_koepfe;
                    end;

                  if tiefe=1 then
                    lba_anfang_erweitert:=lba_relativ;

                  lvm_buchstabe:='-';
                  lvm_plattenname:='';
                  lvm_informationssektor:=0; (* nicht LVM-versteckbar *)

                  case system_indicator of
                    $00:;

                    $05,
                    $0f:
                      festplatte_absuchen(laufwerk,
                                          anzahl_koepfe,
                                          sektoren_je_spur,
                                          zylinder_neu,
                                          kopf_neu,
                                          sektor_neu,
                                          tiefe+1,
                                          lba_anfang_erweitert+sektoren_davor,
                                          lba_anfang_erweitert);

                  else
                    if lvm_informationen_gefunden then
                      with lvm_sektor.laufwerksbuchstabenzuordnung[partinr] do
                        begin
                          lvm_gefunden:=true; (* bei LVM bedeuten Namen nicht wie beim alten BM,
                            das die Partition startbar seien mÅ·te *)
                          bootmanager_name:=Copy(part_name,1,20);
                          while (bootmanager_name<>'') and (bootmanager_name[Length(bootmanager_name)] in [#0..' ']) do
                            Dec(bootmanager_name[0]);

                          lvm_buchstabe:=UpCase(buchstabe[0]);
                          if not (lvm_buchstabe in ['A'..'Z']) then
                            lvm_buchstabe:='-';
                          lvm_plattenname:=Copy(lvm_sektor.plattenname,1,20);
                          while (lvm_plattenname<>'') and (lvm_plattenname[Length(lvm_plattenname)] in [#0..' ']) do
                            Dec(lvm_plattenname[0]);

                          if (start<>0) and (laenge<>0) then
                            lvm_informationssektor:=sektoren_je_spur-1;
                        end
                    else (* alter BM *)
                      begin
                        bootmanager_name:='';

                        if  (partinr=1)
                        and (ptab.byte_01=1)
                        and (ptab.bootmanager_name  [8]=#0)
                        and (ptab.bootmanager_zusatz[8]=#0)
                         then
                          begin
                            bootmanager_name:=Copy(ptab.bootmanager_name,1,Pos(#0,ptab.bootmanager_name)-1);
                            if not ohne_steuerzeichen(bootmanager_name) then
                              bootmanager_name:='';
                          end;

                      end; (* alter BM *)

                    partition_merken(
                      laufwerk,
                      zylinder_neu ,kopf_neu ,sektor_neu ,
                      zylinder_ende,kopf_ende,sektor_ende,
                      anzahl_koepfe,
                      sektoren_je_spur,
                      tiefe=0,
                      diskettentyp_festplatte,
                      anzahl_sektoren,
                      bootmanager_name,
                      lvm_buchstabe,
                      lvm_plattenname,
                      system_indicator,

                      cxr,dxr,lba,lvm_informationssektor,partinr,start_cx);
                  end; (* case system_indicator *)

                end; (* with *)

          end (* 55 aa *)
        else
          WriteLn(textz_ist_ungueltig_55aa^)
      end
    else (* nicht lesbar *)
      Write(textz__nicht_lesbar_^);

    if tiefe=0 then
      WriteLn;
  end;


function physikalisches_laufwerk_vorhanden(ab:char):boolean;
  var
     anzahl_diskettenlaufwerke:smallword;
  begin
    anzahl_diskettenlaufwerke:=((word_speicher_lesen($0040,$0010) shr 6) and $3)+1;

    physikalisches_laufwerk_vorhanden:=(Ord(ab)<=Ord('A')+anzahl_diskettenlaufwerke-1);
  end;

procedure laufwerk_ab(const ab:char);
  var
    z,k,s               :longint;
    geraetetyp          :byte;
    d_lauf_typ          :diskettentyp_typ;
    groesse             :longint;

  begin
    Write(textz_Untersuchung_LW^,' ',ab,': ');

    (***************************************************************)

    if  (physikalisches_laufwerk_vorhanden(ab))
    and (get_phys_drive_parameters(Ord(ab)-Ord('A'),z,k,s,geraetetyp)=0)
     then
      begin
        case geraetetyp of
          (*$IFDEF OS2*)
          floppy_type_48_TPI_low_density,
          floppy_type_96_TPI_high_density,
          floppy_type_8_Inch_single_density,
          floppy_type_8_Inch_double_density:
          (*$ENDIF OS2*)
          (*$IFDEF DOS_DPMI32*)
          floppy_type_360,
          floppy_type_1200:
          (*$ENDIF DOS_DPMI32*)
            d_lauf_typ:=diskettentyp_13cm;

          (*$IFDEF OS2*)
          floppy_type_3_5_inch_720KB,
          floppy_type_Other_1440,
          floppy_type_3_5_inch_2880:
          (*$ENDIF OS2*)
          (*$IFDEF DOS_DPMI32*)
          floppy_type_720,
          floppy_type_1440,
          floppy_type_2880_1,
          floppy_type_2880:
          (*$ENDIF DOS_DPMI32*)
            d_lauf_typ:=diskettentyp_09cm;
        else
          (* OS2
          floppy_type_Fixed_disk
          floppy_type_Tape_drive
          floppy_type_RW_optical_disk *)
          (* DOS_DPMI32
          floppy_type_atapi           *)
          d_lauf_typ:=diskettentyp_sonst;
        end;

        if (z>0) and (k>0) and (s>0) then
          Write('[',z,'/',k,'/',s,'] ');
      end
    else
      d_lauf_typ:=diskettentyp_fehler;

    (***************************************************************)

    groesse:=z*k*s;
    if groesse<0 then
      groesse:=0;


    if d_lauf_typ<>diskettentyp_fehler then
      partition_merken(
        Ord(ab)-Ord('A'),
        0,0,1,
        0,0,1,
        k,s,
        true,d_lauf_typ,groesse,'',ab,'',0,
        0,0,0,0,0,0)
    else
      Write(textz___nicht_vorhanden^);

    WriteLn;

    (***************************************************************)
  end;


procedure cdrom_hinzufuegen;
  begin
    if gefundene_partitionen_anzahl=High(gefundene_partitionen_tabelle) then
      begin
        (* kein Platz mehr *)
        Exit;
      end;

    Inc(gefundene_partitionen_anzahl);
    with gefundene_partitionen_tabelle[gefundene_partitionen_anzahl] do
      begin
        oemname:='';
        suspendpartition:=false;
        laufwerk:=$ff;
        dos_laufwerk:='-';
        os2_laufwerk:='-';
        lvm_laufwerk:='-';
        lvm_plattenname_:='';
        empfohlen:=false;
        smallword_rec(dx_register).l:=$ff;
        smallword_rec(dx_register).h:=0;
        smallword_rec(cx_register).l:=0;
        smallword_rec(cx_register).h:=0;
        zylinder:=0;
        end_zylinder:=0;
        kopf:=0;
        sektor:=0;

        kennung:='L=$'+Int2Hex(laufwerk,2)+'_Z='+Int2Str(zylinder)+'_K='+Int2Str(kopf)+'_S='+Int2Str(sektor);

        lba_sektor:=0;
        laufwerks_typ:=diskettentyp_sonst;
        dateisystem:=$ff;
        groesse_in_sektoren:=0;
        primaer:=true;

        ibm_bootmanager_name:='';
        ico_name_empfohlen:='cdrom';
        titel_empfohlen:='CD-ROM';
        bootsektor_signaturbyte:=0;
        logische_laufwerksnummer:=0;
        datentraegername:='        '+'   ';
      end;
  end;

procedure laufwerke_absuchen;
  var
    z,z2                :word_norm;
    dos_lw,os2_lw       :char;
    pri                 :boolean;

    erste_hpfs_gefunden,
    erste_fat32_gefunden,
    erste_ext2_gefunden,
    erste_bsd_gefunden  :boolean;

    schon_erste_primaere_fat:byte;

    tmp_partition       :gefundene_partition_eintrag_typ;

  begin
    lvm_gefunden:=false;

    gefundene_partitionen_anzahl:=0;
    FillChar(gefundene_partitionen_tabelle,SizeOf(gefundene_partitionen_tabelle),0);

    laufwerk_ab('A');
    laufwerk_ab('B');

    for z:=1 to 4 do
      if z<=festplattenzahl+1 then
        festplatte_absuchen(z-1+$80,-1,-1,0,0,1,0,0,0);

    if gefundene_partitionen_anzahl=0 then
      abbruch(textz_keine_partitionen_gefunden^);

    dos_lw:='A';
    os2_lw:='A';
    schon_erste_primaere_fat:=0;

    (* Laufwerksbuchstaben fÅr primÑre Partitionen vergeben *)
    for z:=1 to gefundene_partitionen_anzahl do
      with gefundene_partitionen_tabelle[z] do
        if primaer then
          case laufwerk of
            $00:
              begin
                dos_laufwerk:=dos_lw;Inc(dos_lw);
                os2_laufwerk:=os2_lw;Inc(os2_lw);
              end;
            $01:
              begin
                dos_laufwerk:=dos_lw;Inc(dos_lw);
                os2_laufwerk:=os2_lw;Inc(os2_lw);
              end;
          else
            (* Fesplatten bekommen Laufwerksbuchstaben ab C *)
            if dos_lw<'C' then dos_lw:='C';
            if os2_lw<'C' then os2_lw:='C';

            if dateisystem in [1,4,6] then
              begin
                dos_laufwerk:=dos_lw;Inc(dos_lw);
              end;

            if dateisystem in [1,4,6,7] then
              if (schon_erste_primaere_fat<>laufwerk) or (dateisystem=7) then
                begin
                  os2_laufwerk:=os2_lw;Inc(os2_lw);
                  if dateisystem in [1,4,6] then
                    schon_erste_primaere_fat:=laufwerk; (* nur eine primÑre FAT Partition je Laufwerk *)
                end;

            if dos_lw>'Z' then dos_lw:='Z';
            if os2_lw>'Z' then os2_lw:='Z';
        end;

    (* logische Laufwerke *)
    if dos_lw<'C' then dos_lw:='C';
    if os2_lw<'C' then os2_lw:='C';

    for z:=1 to gefundene_partitionen_anzahl do
      with gefundene_partitionen_tabelle[z] do
        if not primaer then
          begin
            if dateisystem in [1,4,6] then
              begin dos_laufwerk:=dos_lw;Inc(dos_lw); end;
            if dateisystem in [1,4,6,7] then
              begin os2_laufwerk:=os2_lw;Inc(os2_lw); end;

            if dos_lw>'Z' then dos_lw:='Z';
            if os2_lw>'Z' then os2_lw:='Z';
          end;





    (* empfohlene Partitionen:
       Laufwerk A,B und C
       die erste HPFS/FAT32/EXT2/BSD-Partition
       alle Laufwerke mit IBM Bootmanager-Name *)
    for z:=1 to gefundene_partitionen_anzahl do
      with gefundene_partitionen_tabelle[z] do
        if dos_laufwerk in ['A','B','C'] then
          empfohlen:=true;

    erste_hpfs_gefunden:=false;
    erste_fat32_gefunden:=false;
    erste_ext2_gefunden:=false;
    erste_bsd_gefunden:=false;

    for pri:=false to true do
      for z:=1 to gefundene_partitionen_anzahl do
        with gefundene_partitionen_tabelle[z] do
          if laufwerk>=$80 then
            if primaer=pri then
              case dateisystem of
                $07:
                  if not erste_hpfs_gefunden then
                    begin
                      empfohlen:=true;
                      erste_hpfs_gefunden:=true;
                    end;

                $0b,$0c,$0e:
                  if not erste_fat32_gefunden then
                    begin
                      empfohlen:=true;
                      erste_fat32_gefunden:=true;
                    end;

                $83:
                  if not erste_ext2_gefunden then
                    begin
                      empfohlen:=true;
                      erste_ext2_gefunden:=true;
                    end;

                $a5,$a6,$a9:
                  if not erste_bsd_gefunden then
                    begin
                      empfohlen:=true;
                      erste_bsd_gefunden:=true;
                    end;
              end;

    for z:=1 to gefundene_partitionen_anzahl do
      with gefundene_partitionen_tabelle[z] do
        if (not lvm_gefunden) and (ibm_bootmanager_name<>'') then
          empfohlen:=true;


    cdrom_hinzufuegen;


    (* Sortieren .. zum Beispiel fÅr die verwÅrfelte Konfiguration von Jost *)
    for z:=1 to gefundene_partitionen_anzahl-1 do
      for z2:=z to gefundene_partitionen_anzahl do
        if  (gefundene_partitionen_tabelle[z].laufwerk  =gefundene_partitionen_tabelle[z2].laufwerk  )
        and (gefundene_partitionen_tabelle[z].lba_sektor>gefundene_partitionen_tabelle[z2].lba_sektor)
         then
          begin
            tmp_partition                    :=gefundene_partitionen_tabelle[z ];
            gefundene_partitionen_tabelle[z ]:=gefundene_partitionen_tabelle[z2];
            gefundene_partitionen_tabelle[z2]:=tmp_partition                    ;
          end;

    (* Plattennamen mit LVM vergeben ? *)
    lvm_plattennamen_breite:=0;
    for z:=1 to gefundene_partitionen_anzahl do
      with gefundene_partitionen_tabelle[z] do
        if lvm_plattenname_<>'' then
          lvm_plattennamen_breite:=Max(lvm_plattennamen_breite,1+Length(lvm_plattenname_));

    (* markiere alle versteckbaren Partitionen *)
    for z:=1 to gefundene_partitionen_anzahl do
      with gefundene_partitionen_tabelle[z] do
        begin
          versteckbar:=false;
          for z2:=1 to High(partitionstypen_versteckter_typ) do
          with partitionstypen_versteckter_typ[z2] do
            if (dateisystem=sichtbarer_typ)
            or (dateisystem=versteckter_typ) then
              begin
                versteckbar:=true;
                Break;
              end;
          if suspendpartition then
            versteckbar:=false;
        end;

  end;

function suche_partition(const kennung:string):word_norm;
  var
    z:word_norm;
  begin
    for z:=1 to gefundene_partitionen_anzahl do
      if gefundene_partitionen_tabelle[z].kennung=kennung then
        begin
          suche_partition:=z;
          Exit;
        end;

    suche_partition:=0;
  end;


var
  anzahl_versteckbare_partitionen:word_norm;

function versteck_schalter(var element:auswahlliste_eintrag_typ):boolean;far;
  var
    i,z                 :word_norm;
    versteckbar         :boolean;
  begin
    (* Ende-Eintrag *)
    if element.ergebnis='0' then
      begin
        versteck_schalter:=true;
        Exit;
      end;

    (* ein richtiger Eintrag *)
    versteck_schalter:=false;
    i:=suche_partition(element.ergebnis);
    if i=0 then
      RunError(201);

    with gefundene_partitionen_tabelle[i] do
      begin
        if element.wert='+' then
          begin
            versteckbar_gewaehlt:=false;
            Dec(anzahl_versteckbare_partitionen);
            element.titel[1]:='-';
            element.wert:='-';
          end

        else
        if (element.wert='-')
        and (anzahl_versteckbare_partitionen<High(ergebnis.zu_versteckende_partitionen)) then
          begin
            versteckbar_gewaehlt:=true;
            Inc(anzahl_versteckbare_partitionen);
            element.titel[1]:='+';
            element.wert:='+'
          end

        else
          SysBeepEx(100,1);

      end;

  end;

function versteck_lader(var element:auswahlliste_eintrag_typ;var sollwert:string):boolean;far;
  begin
    (* Ende-Eintrag *)
    if element.ergebnis='0' then
      begin
        versteck_lader:=true;
        Exit;
      end;

    (* ein richtiger Eintrag *)
    versteck_lader:=false;

    if sollwert=element.wert then
    else
    if ((sollwert='-') and (element.wert='+'))
    or ((sollwert='+') and (element.wert='-')) then
      versteck_schalter(element)
    else
      SysBeepEx(100,1);

  end;

procedure frage_partitionen_verstecken;
  var
    versteckte_partition        :boolean;
    z,z2                        :word_norm;
    liste_verstecken            :auswahl_tabelle_typ;
    zk,
    hilfstext                   :string;

  begin
    versteckte_partition:=false;
    for z:=1 to gefundene_partitionen_anzahl do
      with gefundene_partitionen_tabelle[z] do
        if (dateisystem in [$11,$14,$16,$17,$1b,$1c,$1e,$84]) and (not suspendpartition) then
          versteckte_partition:=true;

    (* alte Version ohne Verstecken ...
    if versteckte_partition then
      abbruch_oder_weiter(textz_hinweis_versteckte_partitionen_frage^,
                          'VERSTECKTE',
                          textz_hinweis_versteckte_partitionen_hilfe^,
                          'W');*)

    Write(textz_Verstecken_von_Partitionen^,' ');

    antwort:='N';
    if versteckte_partition then
      antwort:='J';
    antwort:=ja_nein_frage(
              textz_Soll_sich_VPart_am_Verstecken_von_Partitionen_beteiligen__^,
              antwort[1],
              'VERSTECKE_CFG',
              textz_verstecken_hilfe^);

    antwort_ausschrift(ja_nein_str(antwort[1]));

    anzahl_versteckbare_partitionen:=0;
    if antwort<>'N' then
      begin
        auswahlliste_neu(liste_verstecken,false);
        auswahlliste_zu_anwahlliste(liste_verstecken,versteck_schalter,versteck_lader);

        anwahlliste_eintrag(
          liste_verstecken,
          textz_Die_Auswahl_stimmt_so^,
          '0',
          '0',
          '',
          '0');

        antwort:=' ';
        for z:=1 to gefundene_partitionen_anzahl do
          with gefundene_partitionen_tabelle[z] do
            begin
              if (antwort=' ') and versteckbar then
                antwort:=kennung;
              versteckbar_gewaehlt:=false;
              partition_eintragname(z,zk);
              partition_eintraghilfe(z,hilfstext);
              if versteckbar then
                anwahlliste_eintrag(liste_verstecken,'- '+zk,' ',kennung,hilfstext,'-')
              else
                anwahlliste_eintrag(liste_verstecken,'  '+zk,' ',kennung,hilfstext,' ');
            end;

        antwort:=auswahlliste_anzeigen(
                   liste_verstecken,
                   antwort,
                   textz_Waehlen_Sie_bis_zu_8_versteckbare_Partitionen^,
                   'VERSTECKE_AW');

        FillChar(ergebnis.zu_versteckende_partitionen,SizeOf(ergebnis.zu_versteckende_partitionen),0);
        FillChar(verweis_zu_versteckende_partitionen,SizeOf(verweis_zu_versteckende_partitionen),0);

        (* Sortiert einordnen - Einsparung von Schreib- und Lesezugriffen *)
        anzahl_versteckbare_partitionen:=0;
        for z:=1 to gefundene_partitionen_anzahl do
          with gefundene_partitionen_tabelle[z] do
            if versteckbar_gewaehlt then
              begin
                Inc(anzahl_versteckbare_partitionen);
                verweis_zu_versteckende_partitionen[anzahl_versteckbare_partitionen]:=z;
                with ergebnis.zu_versteckende_partitionen[anzahl_versteckbare_partitionen] do
                  begin
                    cx_reg:=partitionstabelle_cx_reg;
                    dx_reg:=partitionstabelle_dx_reg;
                    lba    :=partitionstabelle_lba;
                    for z2:=1 to High(partitionstypen_versteckter_typ) do
                      with partitionstypen_versteckter_typ[z2] do
                        if (dateisystem=sichtbarer_typ)
                        or (dateisystem=versteckter_typ) then
                          begin
                            partitionstyp_sichtbar:=sichtbarer_typ;
                            partitionstyp_unsichtbar:=versteckter_typ;
                            Break;
                          end;
                      lvm_informationssektor:=partitionstabelle_lvmsekt;
                      eintrag:=partitionstabelle_eintrag;
                      startsektorzylinder:=partitionstabelle_anfang;
                  end;
              end;


        (* antwort_ausschrift(Int2Str(anzahl_versteckbare_partitionen)); *)
      end; (* Verstecken=J *)


  end;

procedure partitionen_auswaehlen;
  var
    liste_bs,
    liste_verstecken            :auswahl_tabelle_typ;
    z,z2                        :word_norm;
    zz                          :char;
    zk                          :string;
    auswahl_nummer              :word_norm;
    syswahl                     :string;
    ico_name_empfohlen1,
    titel_empfohlen1            :string;
    hilfstext                   :string;
    emfehlung_sekt              :string[1];

  begin

    ergebnis.anzahl_lw:=0; (* leer anfangen *)
    WriteLn;

    while ergebnis.anzahl_lw<High(ergebnis.tabelle) do
      begin
        auswahlliste_neu(liste_bs,false);
        if ergebnis.anzahl_lw>0 then
          auswahlliste_eintrag(
            liste_bs,
            textz_kein_weiterer_Eintrag^,
            '0',
            '0',
            '');

        antwort:=' ';
        for z:=1 to gefundene_partitionen_anzahl do
          with gefundene_partitionen_tabelle[z] do
            begin
              if (antwort=' ') and empfohlen then
                antwort:=kennung;

              partition_eintragname(z,zk);
              partition_eintraghilfe(z,hilfstext);

              auswahlliste_eintrag(liste_bs,zk,' ',kennung,hilfstext);
            end;


        schreibe_log_kommentar('');
        schreibe_log_kommentar(kommentarbalken);
        schreibe_log_kommentar('');
        quelldatei_eintraege_uberspringen:=true;
        antwort:=auswahlliste_anzeigen(
                   liste_bs,
                   antwort,
                   textz_bitte_waehlen_sie_Eintrag_^+Int2Str(ergebnis.anzahl_lw+1)
                  +textz__von_^+Int2Str(High(ergebnis.tabelle))+textz_der_im_menue_erscheinen_soll^,
                   'AUSWAHL');
        quelldatei_eintraege_uberspringen:=false;

        auswahl_nummer:=0;
        for z:=1 to gefundene_partitionen_anzahl do
          with gefundene_partitionen_tabelle[z] do
            if kennung=antwort then
              begin
                auswahl_nummer:=z;
                Break;
              end;

        if auswahl_nummer=0 then
          Break;


        WriteLn(textz_Eintrag_^+Int2Str(ergebnis.anzahl_lw+1),':');
        schreibe_log_kommentar(textz_Eintrag_^+Int2Str(ergebnis.anzahl_lw+1));
        schreibe_log_kommentar('');

        Inc(ergebnis.anzahl_lw);

        (* als einmal ausgewÑhlt *)
        gefundene_partitionen_tabelle[auswahl_nummer].empfohlen:=false;

        (* anderer Startsektor ladbar ? *)
        case gefundene_partitionen_tabelle[auswahl_nummer].dateisystem of
          0,1,4,6,$11,$14,$16: (* auch Diskette,normal FAT,versteckt FAT *)
            begin
              Write(textz___Startsektor________________^);
              auswahlliste_neu(liste_bs,false);
              auswahlliste_eintrag(liste_bs,' 0)  '+textz_den_zur_BOOTZEIT_vorhanden_Bootsektor^           ,'0','0',
                gefundene_partitionen_tabelle[auswahl_nummer].oemname);
              auswahlliste_eintrag(liste_bs,' 1)  OS2BOOT .................. IBM OS/2'                     ,'1','1','');
              auswahlliste_eintrag(liste_bs,' 2)  IBMBIO.COM ............... Novell Dos 7'                 ,'2','2','');
              auswahlliste_eintrag(liste_bs,' 3)  IO.SYS + MSDOS.SYS ....... MS Dos'                       ,'3','3','');
              auswahlliste_eintrag(liste_bs,' 4)  PTSLDR.SYS ............... Phys-Tech-Soft Dos 7'         ,'4','4','');
              auswahlliste_eintrag(liste_bs,' 5)  IBMBIO.COM + IBMDOS.COM .. PC DOS'                       ,'5','5','');
              auswahlliste_eintrag(liste_bs,' 6)  PTSDOS.SYS ............... Phys-Tech-Soft Dos 6'         ,'6','6','');
              auswahlliste_eintrag(liste_bs,' 7)  IO.DOS + MSDOS.DOS ....... MS Dos'                       ,'7','7','');
              auswahlliste_eintrag(liste_bs,' 8)  IO.SYS + MSDOS.SYS ....... MS Windows'                   ,'8','8','');
              auswahlliste_eintrag(liste_bs,' 9)  IBMBIO.600 ............... DR DOS 6        [SYS /DR:600]','9','9','');
              auswahlliste_eintrag(liste_bs,' A)  IBMBIO.700 ............... Novell Dos 7    [SYS /DR:700]','A','A','');
              auswahlliste_eintrag(liste_bs,' B)  IBMBIO.701 ............... Caldera OpenDos [SYS /DR:701]','B','B','');
              auswahlliste_eintrag(liste_bs,' C)  IBMBIO.702 ............... Caldera DR-DOS  [SYS /DR:702]','C','C','');
              auswahlliste_eintrag(liste_bs,' D)  IBMBIO.703 ............... Caldera DR-DOS  [SYS /DR:703]','D','D','');
              auswahlliste_eintrag(liste_bs,' E)  NTLDR .................... MS Windows'                   ,'E','E','');
              auswahlliste_eintrag(liste_bs,' F)  BOOT_ROM.EMU ............. Boot ROM Emulation'           ,'F','F','');

              emfehlung_sekt:='0';
              if (gefundene_partitionen_tabelle[auswahl_nummer].dos_laufwerk='C') and (ziel=fat) and (ziel_laufwerk='C') then
                emfehlung_sekt:='2';

              syswahl:=auswahlliste_anzeigen(
                       liste_bs,
                       emfehlung_sekt,
                       textz_anderen_Startsektor_frage^,
                       'AUSWAHL_SEKT');

              case syswahl[1] of
                '0':
                  begin
                    antwort_ausschrift('normal');
                    ico_name_empfohlen1:=gefundene_partitionen_tabelle[auswahl_nummer].ico_name_empfohlen;
                    titel_empfohlen1   :=gefundene_partitionen_tabelle[auswahl_nummer].titel_empfohlen   ;
                  end;
                '1':
                  begin
                    antwort_ausschrift('OS/2');
                    ico_name_empfohlen1:='os2';
                    titel_empfohlen1   :='OS/2 Warp';
                  end;
                '2':
                  begin
                    antwort_ausschrift('Novell Dos');
                    ico_name_empfohlen1:='nwdos';
                    titel_empfohlen1   :='Novell Dos 7';
                  end;
                '3':
                  begin
                    antwort_ausschrift('MS Dos *.SYS');
                    ico_name_empfohlen1:='msdos01';
                    titel_empfohlen1   :='Microsoft Dos';
                  end;
                '4':
                  begin
                    antwort_ausschrift('PTS Dos 7');
                    ico_name_empfohlen1:='ptsdos';
                    titel_empfohlen1   :='PTS Dos 7';
                  end;
                '5':
                  begin
                    antwort_ausschrift('IBM Dos');
                    ico_name_empfohlen1:='pcdos';
                    titel_empfohlen1   :='IBM Dos';
                  end;
                '6':
                  begin
                    antwort_ausschrift('PTS Dos 6');
                    ico_name_empfohlen1:='ptsdos';
                    titel_empfohlen1   :='PTS Dos 6';
                  end;
                '7':
                  begin
                    antwort_ausschrift('MS Dos *.DOS');
                    ico_name_empfohlen1:='msdos02';
                    titel_empfohlen1   :='Microsoft Dos';
                  end;
                '8':
                  begin
                    antwort_ausschrift('MS Windows');
                    ico_name_empfohlen1:='msdos01';
                    titel_empfohlen1   :='Microsoft Windows';
                  end;
                '9':
                  begin
                    antwort_ausschrift('Novell Dos [.600]');
                    ico_name_empfohlen1:='drdos';
                    titel_empfohlen1   :='DR Dos 6';
                  end;
                'A':
                  begin
                    antwort_ausschrift('Novell Dos [.700]');
                    ico_name_empfohlen1:='nwdos';
                    titel_empfohlen1   :='Novell Dos 7';
                  end;
                'B':
                  begin
                    antwort_ausschrift('Caldera OpenDos [.701]');
                    ico_name_empfohlen1:='caldera';
                    titel_empfohlen1   :='Caldera Dos 7.01';
                  end;
                'C':
                  begin
                    antwort_ausschrift('Caldera DR-DOS [.702]');
                    ico_name_empfohlen1:='caldera';
                    titel_empfohlen1   :='Caldera DR-DOS 7.02';
                  end;
                'D':
                  begin
                    antwort_ausschrift('Caldera DR-DOS [.703]');
                    ico_name_empfohlen1:='caldera';
                    titel_empfohlen1   :='Caldera DR-DOS 7.03';
                  end;
                'E':
                  begin
                    antwort_ausschrift('MS NTLDR');
                    ico_name_empfohlen1:='ntldr';
                    titel_empfohlen1   :='NTLDR';
                  end;
                'F':
                  begin
                    antwort_ausschrift('BOOT ROM');
                    ico_name_empfohlen1:='BOOTROM';
                    titel_empfohlen1   :='BOOT ROM';
                  end;
              else
                RunError(0); (* ::: *)
              end; (* case syswahl *)
            end;
        else
          syswahl:='0';
          ico_name_empfohlen1:=gefundene_partitionen_tabelle[auswahl_nummer].ico_name_empfohlen;
          titel_empfohlen1   :=gefundene_partitionen_tabelle[auswahl_nummer].titel_empfohlen   ;
        end;





        (** Titelabfrage *******************************************)
        Write(textz___Name_______________________^);
        antwort:=eingabe(textz_Wie_soll_der_Eintrag_lauten^,
                         titel_empfohlen1,
                         betriebssystem_titel_laenge,
                         'TITEL',
                         '');
        antwort_ausschrift(antwort);
        leerzeichenerweiterung(antwort,betriebssystem_titel_laenge);
        ergebnis.tabelle[ergebnis.anzahl_lw].name_:=antwort;

        (** Symbolabfrage ******************************************)
        Write(textz___Logo_______________________^);
        klein(ico_name_empfohlen1);
        repeat
          auswahlliste_neu(liste_bs,false);
          for z:=1 to icons^.anzahl do
            auswahlliste_eintrag(
              liste_bs,
              icons^.ico_tab[z].titel,
              UpCase(icons^.ico_tab[z].titel[1]),
              icons^.ico_tab[z].titel,
              textz_mitgeliefertes_Logo__Bitte_sehen_sie_sich_icon_gal_png_an^);

          auswahlliste_eintrag(
            liste_bs,
            textz_PCX_Logo_importieren^,
            ' ',
            'PCX-IMPORT',
            textz_PCX_Logo_importieren_hilfe^);

          antwort:=auswahlliste_anzeigen(liste_bs,ico_name_empfohlen1,textz_Suchen_Sie_ein_Symbol_aus2^,'ICO');
          if antwort='PCX-IMPORT' then
            begin
              antwort:=eingabe(textz_PCX_Logo_dateiname_frage^,
                               '',
                               50,
                               'PCX',
                               '');
              if importiere_pcx_32_32_16_zu_512(antwort,ergebnis.tabelle[ergebnis.anzahl_lw].ico) then
                begin
                  antwort_ausschrift(antwort);
                  Break;
                end
            end
          else
            begin
              for z:=1 to icons^.anzahl do
                if icons^.ico_tab[z].titel=antwort then
                  begin
                    Move(icons^.ico_tab[z].daten,ergebnis.tabelle[ergebnis.anzahl_lw].ico,512);
                    antwort_ausschrift(icons^.ico_tab[z].titel);
                  end;
              Break;
            end;

        until false;


        (** stille Berechnungen ************************************)
        with ergebnis.tabelle[ergebnis.anzahl_lw] do
          begin
            case syswahl[1] of
              'J', 'Y':system_trick:=0;
              '0'..'9':system_trick:=Ord(syswahl[1])-Ord('0');
              'A'..'I':system_trick:=Ord(syswahl[1])-Ord('A')+10;
              (* ::: *)
            end;

            (* 1->F1 .. 9->F9 10->F0 *)
            ergebnis.tabelle[ergebnis.anzahl_lw].taste:=tasten_tab[ergebnis.anzahl_lw];

            boot_hidden_sekt:=gefundene_partitionen_tabelle[auswahl_nummer].lba_sektor;
            cx_reg:=gefundene_partitionen_tabelle[auswahl_nummer].cx_register;
            dx_reg:=gefundene_partitionen_tabelle[auswahl_nummer].dx_register;

            if (gefundene_partitionen_tabelle[auswahl_nummer].zylinder>1023)
            or ((GetEnv('VPART_FORCE_LBA')<>'') and ((dx_reg and $0080)=$0080))
             then
              (* INT 13/42 erforderlich *)
              cx_reg:=$ffff;


            with gefundene_partitionen_tabelle[auswahl_nummer] do
              begin

                if bootsektor_signaturbyte in [$28,$29] then
                  boot_undok_lw:=Lo(dx_reg);

                (* Festplatte *)
                if  (Lo(dx_reg)>=$80)
                (* vom Sektor unterstÅtzt *)
                and (bootsektor_signaturbyte in [$28,$29])
                (* nicht Laufwerk C: *)
                and ((not primaer) or (dos_laufwerk<>'C'))
                (* und auch nicht der IBM Bootmanager *)
                and (dateisystem<>10)
                 then
                  begin
                    Write(textz___Laufwerksbuchstabe_________^);

                    auswahlliste_neu(liste_bs,false);

                    for zz:='A' to '`' do
                      auswahlliste_eintrag(
                        liste_bs,
                        zz+':',
                        zz,
                        zz,
                        textz_vermutete_Laufwerksbuchstaben_^+'  DOS:'+dos_laufwerk
                                                             +'  OS/2:'+os2_laufwerk
                                                             +'  LVM:'+lvm_laufwerk);

                    zk:=ico_name_empfohlen;
                    gross(zk);
                    if (Pos('ECS',zk)<>0) or (Pos('OS2',zk)<>0) then
                      begin
                        if lvm_laufwerk<>'-' then
                          zz:=lvm_laufwerk
                        else
                          zz:=os2_laufwerk;
                      end
                    else
                      if dos_laufwerk<>'-' then
                        zz:=dos_laufwerk
                      else
                        zz:='C'; (* FAT32 *)

                    antwort:=auswahlliste_anzeigen(
                      liste_bs,
                      zz,
                      textz_Waehlen_Sie_den_zu_verwendenden_Laufwerksbuchstaben^,
                      'LAUFWERKSBUCHSTABE');

                    boot_undok_lw:=$80+Ord(UpCase(antwort[1]))-Ord('C');
                    antwort_ausschrift(zz);
                  end;

              end;


            (** TastendrÅcke aufzeichnen ***************************)
            Write(textz__Tastedruecke________________^);
            antwort:=ja_nein_frage(
              textz_frage_tastendruecke1^,
              'N',
              'TASTEN1',
              textz_hilfe_tastendruecke1^);

            if antwort='N' then
              begin
                tastendruecke_anzahl:=0;
                uebergehe_quelle('TASTEN2');
              end
            else
              begin
                tasten_aufzeichnung(
                  tastendruecke_anzahl,
                  tasten8(tastendruecke),
                  textz_Tastenaufzeichnung^,
                  'TASTEN2',
                  textz_bis_zu_8_Tasten_zum_Ende_Alt_NUM_1^);
              end;
            antwort_ausschrift(Int2Str(tastendruecke_anzahl));
            for z:=tastendruecke_anzahl+1 to High(tastendruecke) do
              tastendruecke[z]:=0;

            (*******************************************************)
            (* verstecken *)
            for z:=1 to anzahl_versteckbare_partitionen do
              with ergebnis.zu_versteckende_partitionen[z],
                   gefundene_partitionen_tabelle[verweis_zu_versteckende_partitionen[z]] do
                begin
                  Write(textz_frage_Verstecken_Typ1^,z,textz_frage_Verstecken_Typ2^,' ');

                  auswahlliste_neu(liste_verstecken,true);
                  partition_eintraghilfe(verweis_zu_versteckende_partitionen[z],hilfstext);
                  auswahlliste_eintrag(liste_verstecken,Int2Hex(partitionstyp_unsichtbar,2)
                    +textz_menue__verstecken^         ,'+','+',hilfstext);
                  auswahlliste_eintrag(liste_verstecken,
                     textz_menue__unveraendert_lassen^,'*','*',hilfstext);
                  auswahlliste_eintrag(liste_verstecken,Int2Hex(partitionstyp_sichtbar  ,2)
                    +textz_menue__sichtbar_machen^    ,'-','-',hilfstext);

                  antwort:='+'; (* erstmal verstecken *)
                  if verweis_zu_versteckende_partitionen[z]=auswahl_nummer then
                    antwort:='-'; (* sichtbar, wenn Sie gestartet werden soll *)
                  antwort:=auswahlliste_anzeigen(liste_verstecken,antwort,
                    textz_menue_Verstecken_der_Partition_der_Partition_beim_Start_^,'VERSTECKEN_PT');

                  case antwort[1] of
                    '+':
                      begin
                        laufwerke_verstecken[z]:=1 shl 6;
                        antwort_ausschrift(textz_versteckt_01^);
                      end;

                    '*':
                      begin
                        laufwerke_verstecken[z]:=0 shl 6;
                        antwort_ausschrift(textz_unveraendert^);
                      end;

                    '-':
                      begin
                        laufwerke_verstecken[z]:=2 shl 6;
                        antwort_ausschrift(textz_sichtbar^);
                      end;
                  end;

                  (* LVM-Buchstabe Ñnderbar ? *)
                  if lvm_informationssektor<>0 then
                    begin
                      Write(textz_frage_Verstecken_Typ1^,z,textz_frage_Verstecken_LVM2^,' ');
                      auswahlliste_neu(liste_bs,true);
                      partition_eintraghilfe(verweis_zu_versteckende_partitionen[z],hilfstext);
                      auswahlliste_eintrag(liste_bs,textz_keine_AEnderung_des_LVM_Buchstabens^,'*','*',hilfstext);
                      auswahlliste_eintrag(liste_bs,textz_Laufwerk_nicht_sichtbar^,'-','-',hilfstext);
                      for zz:='C' to 'Z' do
                        auswahlliste_eintrag(liste_bs,textz_Buchstabe_zz_festlegen1^+zz+textz_Buchstabe_zz_festlegen2^,
                          zz,zz,hilfstext);

                      antwort:='*'; (* UnverÑndert *)
                      if lvm_laufwerk in ['C'..'Z'] then
                        antwort:=lvm_laufwerk
                      else if (lvm_laufwerk='-') and (verweis_zu_versteckende_partitionen[z]=auswahl_nummer) then
                        begin
                          (* Die Partition selbst sollte sichtbar sein *)
                          antwort:='C'; (* nicht nachgeprÅft, wird jedoch meisten gewÅnscht sein *)
                          (* Mîglichkeit: suche freien Buchstaben auf bisherigen antorten und sonstigen
                             LVM-Buchstaben auf den Platten *)
                        end;

                      antwort:=auswahlliste_anzeigen(liste_bs,antwort,textz_frage_verstekcen_lvm^,'VERSTECKEN_LVM');

                      case antwort[1] of
                        '*':
                          begin
                            z2:=(0 shl 5);
                            antwort_ausschrift(textz_unveraendert^);
                          end;
                        '-':
                          begin
                            z2:=(1 shl 5);
                            antwort_ausschrift(textz_kein_Buchstabe^);
                          end;
                        'A'..'Z':
                          begin
                            z2:=(1 shl 5) or (Ord(antwort[1])-Ord('@'));
                            antwort_ausschrift(antwort[1]+':');
                          end;
                      end;
                      laufwerke_verstecken[z]:=laufwerke_verstecken[z] or z2;

                    end;

                end;

            (*******************************************************)

          end; (* with *)

        WriteLn;
      end; (* while 1..10 *)

    quelldatei_eintraege_uberspringen:=true;
    schreibe_log_kommentar('');
    schreibe_log_kommentar(kommentarbalken);
    schreibe_log_kommentar('');


    (* Rest mit 0 fÅllen - besser komprimierbar *)
    for z:= ergebnis.anzahl_lw+1 to zeilenzahl do
      FillChar(ergebnis.tabelle[z],SizeOf(ergebnis.tabelle[z]),0);

  end;

procedure vpart_cfg_fat_laufwerke_hinzufuegen(var liste_menu:auswahl_tabelle_typ);
  var
    z                   :word_norm;
    hilfstext           :string;
    lvm_bm_name         :string;
  begin
    for z:=1 to gefundene_partitionen_anzahl do
      with gefundene_partitionen_tabelle[z] do

        if (dos_laufwerk in ['A','B']) then
          auswahlliste_eintrag(liste_menu,textz_datei_auf_diskettenlaufwerk^+dos_laufwerk,'F',
             kennung,textz_gespeichert_in_datei^+dos_laufwerk+':\VPART.CFG')

        else if (end_zylinder<=1023) and (dateisystem in [$01,$04,$06,$11,$14,$16,$84]) and (not suspendpartition) then
         begin
           hilfstext:=textz_gespeichert_in_datei^+'\VPART.CFG '
                       +'   '
                       +textz_Festplatte__^+Int2Hex(laufwerk,2)
                       +'   '
                       +textz_Zylinder_^+Int2Str(zylinder)+textz__bis_^+Int2Str(end_zylinder);

           hilfstext:=hilfstext+^m^j
                     +textz_vermutete_Laufwerksbuchstaben^+':  DOS:'+dos_laufwerk
                                                          +'  OS/2:'+os2_laufwerk
                                                          +'  LVM:'+lvm_laufwerk;

           lvm_bm_name:=ibm_bootmanager_name;
           leerzeichenerweiterung(lvm_bm_name,20);

           hilfstext:=hilfstext+^m^j
                       +'IBM BM/LVM: '+lvm_bm_name;

           hilfstext:=hilfstext+textz__Datentraegername__^+datentraegername;

           hilfstext:=hilfstext+' Format: '+oemname;

           auswahlliste_eintrag(liste_menu,textz_datei_auf_FAT_partition^,'F',
             kennung,hilfstext)
         end;
  end;

procedure merke_ergebnis_fat_cfg(const antwort:string);
  var
    z:word_norm;
  begin

    for z:=1 to gefundene_partitionen_anzahl do
      with gefundene_partitionen_tabelle[z] do
        if kennung=antwort then
          with ergebnis do
            begin
              biostyp:=biostyp_FAT_cfg;

              fat_konfiguration_position_dl:=Lo(dx_register);
              fat_konfiguration_position_log:=lba_sektor;
              fat_konfiguration_sektoren_je_spur:=sektoren_je_spur_;
              fat_konfiguration_anzahl_koepfe:=anzahl_koepfe_;
              Exit;
            end;

    RunError(0); (* wird nicht erreicht *)
  end;

procedure suche_ergebnis_fat_cfg(var vorschlag:string);
  var
    z:word_norm;
  begin
    vorschlag:='';

    with ergebnis do
      for z:=1 to gefundene_partitionen_anzahl do
        with gefundene_partitionen_tabelle[z] do
          if  (fat_konfiguration_position_dl=Lo(dx_register))
          and (fat_konfiguration_position_log=lba_sektor)
          and (fat_konfiguration_sektoren_je_spur=sektoren_je_spur_)
          and (fat_konfiguration_anzahl_koepfe=anzahl_koepfe_)
           then
            begin
              vorschlag:=kennung;
              Exit;
            end;
  end;

