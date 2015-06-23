(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

(*$IfDef DOS*)
  (*$IfNDef ENDVERSION*)
    (* $Define SEKT_EINSPAREN*)
  (*$EndIf*)
(*$EndIf*)

unit typ_sekt;

interface

uses
  typ_type;

procedure start_sekt(var   sekt_puffer:puffertyp;
                     const wdh:boolean;
                     const laufwerk:byte;
                     const echter_startsektor:boolean;
                           zylinder,sektoren_je_spur,anzahl_koepfe:word_norm);

implementation

uses
  (*$IfDef ERWEITERUNGSDATEI*)
  typ_erw,
  (*$EndIf*)
  typ_exe1, (* sekt_busch *)
  buschsuc,
  typ_eiau,
  typ_spru,
  typ_dien,
  typ_die2,
  typ_ausg,
  typ_varx,
  typ_spra,
  typ_poem,
  typ_posm,
  typ_var,
  typ_for4;

type
  parti_dat=
    packed record
      boot_indicator    :byte;
      startkopf         :byte;
      startsekt         :byte;
      startspur         :byte;
      systemart         :byte;
      endkopf           :byte;
      endsekt           :byte;
      endspur           :byte;
      sectors_preceding_partition:longint;
      length_of_partition_in_sectors:longint;
    end;

  parti_tab=
    packed record
      xx                :smallword;
      lader             :array[00..$189] of byte;
      byte_01           :byte;
      bootmanager_name  :array[0..8] of char;
      bootmanager_zusatz:array[0..8] of char;
      unbekannt         :array[$19d..$1bd] of byte;
      tab               :array[1..4] of parti_dat;
      sig               :array[1..2] of char;
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
      xx                :smallword;
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
    end;

procedure berechne_zks_aus_lin(var   z,k,s:longint;
                               const l:longint;
                               const sektoren_je_spur,anzahl_koepfe:word_norm);
  var
    ll:longint;
  begin
    ll:=l;
    s:=(ll mod sektoren_je_spur)+1;
    ll:=ll div sektoren_je_spur;
    k:=ll mod anzahl_koepfe;
    z:=ll div anzahl_koepfe;
  end;

procedure erfinde_zylinder_sektoren_je_spur_anzahl_koepfe(
                        var   zylinder,sektoren_je_spur,anzahl_koepfe:word_norm;
                        const sekt_puffer:puffertyp);
  var
    z:word_norm;
    a:longint;
  begin
    if (sektoren_je_spur<>0) and (anzahl_koepfe<>0) then
      Exit;

    if bytesuche(sekt_puffer.d[$1fe],#$55#$aa) then
      with parti_tab(sekt_puffer) do
        begin
          (* Startsektor *)
          if (lader[$0] in [$e9,$eb])
          and (word_z(@lader[$b])^=512) (* Byte je Sektor *)
          and (lader[$d] in [1,2,4,8,16,32,64,128]) (* Sektoren je Kluster *)
          and (word_z(@lader[$18])^ in [8..63]) (* Sektoren je Spur *)
          and (word_z(@lader[$1a])^ in [1..255]) (* Kîpfe *)
           then
            begin
              sektoren_je_spur:=word_z(@lader[$18])^;
              anzahl_koepfe:=word_z(@lader[$1a])^;
              a:=word_z(@lader[$13])^;
              if a=0 then
                a:=longint_z(@lader[$20])^;
              zylinder:=(a div sektoren_je_spur) div anzahl_koepfe;
              Exit;
            end;

          (* Partitionstabelle *)
          if ((   tab[1].boot_indicator
               or tab[2].boot_indicator
               or tab[3].boot_indicator
               or tab[4].boot_indicator) and $7e)=0 then
            begin
              sektoren_je_spur:=max(max(tab[1].endsekt and $3f,
                                        tab[2].endsekt and $3f),
                                    max(tab[3].endsekt and $3f,
                                        tab[4].endsekt and $3f));
              anzahl_koepfe   :=max(max(tab[1].endkopf,
                                        tab[2].endkopf),
                                    max(tab[3].endkopf,
                                        tab[4].endkopf))+1;
              a               :=max(max(tab[1].sectors_preceding_partition+tab[1].length_of_partition_in_sectors,
                                        tab[2].sectors_preceding_partition+tab[2].length_of_partition_in_sectors),
                                    max(tab[3].sectors_preceding_partition+tab[3].length_of_partition_in_sectors,
                                        tab[4].sectors_preceding_partition+tab[4].length_of_partition_in_sectors));

              for z:=1 to 4 do
                if ((tab[z].endsekt   and $3f)<>sektoren_je_spur)
                or ( tab[z].endkopf           <>anzahl_koepfe-1 )
                or ((tab[z].startsekt and $3f)<>1               )
                 then
                  if tab[z].systemart<>0 then
                    anzahl_koepfe:=0;

              if  (sektoren_je_spur<>0) and (anzahl_koepfe<>0) then
                begin
                  zylinder:=(a div sektoren_je_spur) div anzahl_koepfe;
                  Exit;
                end;

            end;
        end;

    sektoren_je_spur:=63;
    anzahl_koepfe:=255;
    zylinder:=(*High(zylinder)*)65000;
  end;

(*$IfDef SEKT_EINSPAREN*)
procedure start_sekt(var   sekt_puffer:puffertyp;
                     const wdh:boolean;
                     const laufwerk:byte;
                     const echter_startsektor:boolean;
                           anzahl_spuren,sektoren_je_spur,anzahl_koepfe:word_norm);
  begin
    if (sekt_puffer.d[$1fe]=$55) and (sekt_puffer.d[$1ff]=$aa) then
      ausschrift('(eingespart)',signatur);
  end;
(*$Else*)


const
  baumzeichen           :array[1..4] of string1=('√','√','√','¿');
  hauptbaumzeichen      :array[1..4] of string1=('≥','≥','≥',' ');

var
  pfad                  :string;
  pfad_zeichenkettenlaenge:word_norm;

  (*$IfNDef VirtualPascal*)
  lvm_sektor_           :puffertyp;
  lvm_sektor            :lvm_sektor_typ absolute lvm_sektor_;
  (*$EndIf*)

procedure partitions_verfolgung(const p1:parti_tab;
                                const laufwerk:byte;
                                      anzahl_spuren,sektoren_je_spur,anzahl_koepfe:word_norm;
                                const anfang_der_erweiterten_partition,relativ_zu,linear_max:longint);

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
        $10,
        $11, (* OS/2 hidden 12 bit fat .. getestet mit OS/2 FDISK 3MB partition *)
        $14,
        $16,
        $17,
        $1b,
        $1c,
        $1e:partitionstyp:=textz_sekt__versteckt^+partitionstyp(t-$10);
        $20:partitionstyp:='OFS1';
        $21:partitionstyp:='FSo2';
        $24:partitionstyp:='NEC MS-DOS 3.x';
        $35:partitionstyp:='LVM -> JFS';
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
        $83:partitionstyp:='Linux';
        $84:partitionstyp:=textz_sekt__versteckt^+'DOS 16 Bit FAT; Systemsoft';
        $86:partitionstyp:='FAT16 volume/stripe set (Windows NT)';
        $87:partitionstyp:='HPFS Fault-Tolerant mirrored, NTFS volume/stripe set';
        $93:partitionstyp:='Amoeba FS';
        $94:partitionstyp:='Amoeba BAD';
        $98:partitionstyp:='Datalight ROM-DOS SuperBoot';
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
            partitionstyp:=textz_unbekanntes_System_Nr^+hex(t)+' ¯';
      end;

    end; (* partitionstyp *)

  const
    start_pfeil         :array[false..true] of string[3]=('ƒƒ','ƒ'#16);
  var
    p2_                 :puffertyp;
    p2                  :parti_tab absolute p2_;
    pn                  :byte;
    groesse             :string;
    lesefehler          :word;
    rek_quelle          :quelle_typ; (* Kopie von quelle, énderung von Sektornummern vermeiden *)
    bm_name             :string[8];
    z,k,s               :longint;
    ze,ke,se            :longint;
    z0,k0,s0            :longint;
    z0e,k0e,s0e         :longint;
    z_lvm,k_lvm,s_lvm   :longint; (* Zylinder/Kopf/Sektor @LVM *)
    lin                 :longint;
    anfang_der_erweiterten_partition2:longint;
    berechnet           :longint;
    lvm_daten_gefunden  :boolean;
    anzahl_benutzter_partitionseintraege:word_norm;
    systemart_lvm       :byte;
    (*$IfDef VirtualPascal*)
    lvm_sektor_         :puffertyp;
    lvm_sektor          :lvm_sektor_typ absolute lvm_sektor_;
    (*$EndIf*)


  begin (* partitions_verfolgung *)

    if stack_knapp then
      begin
        ausschrift('STACK!',dat_fehler);
        Exit;
      end;

    (* LVM-Informationen laden *******************************)
    lvm_daten_gefunden:=false;
    if laufwerk<>255 then
      begin
        rek_quelle:=quelle;
        (* Der Sektor mit den LVM-Informationen ist der letzte Sektor der Spur mit der Partitionstabelle *)

        berechne_zks_aus_lin(z_lvm,k_lvm,s_lvm,relativ_zu,sektoren_je_spur,anzahl_koepfe);
        if bios_sektor_lesen(laufwerk,z_lvm,k_lvm,sektoren_je_spur,sektoren_je_spur,anzahl_koepfe,lvm_sektor_)<>0 then
          FillChar(lvm_sektor,SizeOf(lvm_sektor),0);

        quelle:=rek_quelle;

        if bytesuche(lvm_sektor.signatur,#$02'RMBPMFD') then
          begin
            lvm_daten_gefunden:=true;

            exezk:=pfad;
            leerzeichenerweiterung(exezk,35);
            if relativ_zu=0 (* PrimÑre Partitionstabelle *) then
              ausschrift_x(exezk+textz_sekt__LVM_Platte^   +puffer_zu_zk_e(lvm_sektor.plattenname,#0,20)+'"',
                beschreibung,leer);

            (*if lvm_sektor.zylinder<>? then
              ausschrift('LVM: '...*)
            if lvm_sektor.sektoren<>sektoren_je_spur then
              ausschrift('LVM: '+str0(lvm_sektor.sektoren)+' <-> '+str0(sektoren_je_spur)+'::sektoren/spur',dat_fehler);
            if lvm_sektor.koepfe<>anzahl_koepfe then
              ausschrift('LVM: '+str0(lvm_sektor.koepfe)+' <-> '+str0(anzahl_koepfe)+'::Kîpfe',dat_fehler);



          end;
      end;
    (*********************************************************)

    (* alle 4 EintrÑge durchlaufen *********************************)
    anzahl_benutzter_partitionseintraege:=0;

    for pn:=1 to 4 do
      with parti_tab(p1).tab[pn] do
        begin
          groesse:=pfad
                  +baumzeichen[pn]
                  +start_pfeil[parti_tab(p1).tab[pn].boot_indicator=$80]+str_(pn,1)
                  +': '
                  +partitionstyp(systemart);
          leerzeichenerweiterung(groesse,50);

          if systemart<>0 then Inc(anzahl_benutzter_partitionseintraege);

          with parti_tab(p1).tab[pn] do
            if length_of_partition_in_sectors<>0 then
              begin
                if systemart in [$05,$0f] then
                  groesse:=groesse+' [ '
                else
                  groesse:=groesse+'   ';

                if length_of_partition_in_sectors>9999*2*1024 then
                  groesse:=groesse+r_str(parti_tab(p1).tab[pn].length_of_partition_in_sectors/(2*1024*1024),8,3)+' GB'
                else
                  groesse:=groesse+r_str(parti_tab(p1).tab[pn].length_of_partition_in_sectors/(2*1024     ),8,3)+' MB';

                if systemart in [$05,$0f] then
                  groesse:=groesse+' ]';
              end;

          ausschrift_x(groesse,signatur,absatz);

          if (laufwerk<>255) and (parti_tab(p1).tab[pn].systemart<>0) then
            begin

              z0:=startspur+(startsekt and (bit07+bit06)) shl (8-6);
              k0:=startkopf;
              s0:=startsekt and $3f;

              z0e:=endspur+(endsekt and (bit07+bit06)) shl (8-6);
              k0e:=endkopf;
              s0e:=endsekt and $3f;

              lin:=sectors_preceding_partition;
              if systemart in [$05,$0f] then
                Inc(lin,anfang_der_erweiterten_partition)
              else
                Inc(lin,relativ_zu);

              if lin<relativ_zu+sektoren_je_spur then
                ausschrift_x(textz_sekt__fehler_lin_min^,dat_fehler,leer);

              if lin+length_of_partition_in_sectors-1>linear_max then
                ausschrift_x(textz_sekt__fehler_lin_max^,dat_fehler,leer);

              berechne_zks_aus_lin(z ,k ,s ,lin                                 ,sektoren_je_spur,anzahl_koepfe);
              berechne_zks_aus_lin(ze,ke,se,lin+length_of_partition_in_sectors-1,sektoren_je_spur,anzahl_koepfe);

              (* ich bin mir nicht sicher wie die Werte eingetragen werden wenn
                 die Anfangszylindernummer zu gro· ist (>1023) *)
              if (z0=1023) (* and (k0=?) and (s0=?) *) then
                {z0:=z;}
                begin
                  z0:=z;
                  k0:=k;
                  s0:=s;
                end;

              if (z0e=1023) {and (k0e=anzahl_koepfe-1) and (s0e=sektoren_je_spur)} then
                {z0e:=ze;}
                begin
                  z0e:=ze;
                  k0e:=ke;
                  s0e:=se;
                end;

              if (s0<>1) then
                ausschrift_x(textz_sekt__fehler_in_der_partitionstabelle__sektor1^
                  +'('+str0(s0)+' <-> 1)',dat_fehler,leer);

              if parti_tab(p1).tab[pn].systemart in [$05,$0f] then
                begin
                  if (k0<>0) then
                    ausschrift_x(textz_sekt__fehler_in_der_partitionstabelle__erweiter_kopf0^
                      +'('+str0(k0)+' <-> 0)',dat_fehler,leer);
                end
              else
                if (k0<>0) and (k0<>1) then
                  ausschrift_x(textz_sekt__fehler_in_der_partitionstabelle__kopf0_oder_1^
                    +'('+str0(k0)+' <-> 0,1)',dat_fehler,leer);

              if (s0e<>sektoren_je_spur) then
                ausschrift_x(textz_sekt__fehler_in_der_partitionstabelle__sektor_unvollstaendig^
                  +'('+str0(s0e)+' <-> '+str0(sektoren_je_spur)+')',dat_fehler,leer);

              if (k0e<>anzahl_koepfe-1) then
                ausschrift_x(textz_sekt__fehler_in_der_partitionstabelle__erweiter_kopf_unvollstaendig^
                  +'('+str0(k0e)+' <-> '+str0(anzahl_koepfe-1)+')',dat_fehler,leer);

              if (z0e>=anzahl_spuren) and (anzahl_spuren<>0) then
                ausschrift_x(textz_sekt__fehler_spur_zu_gross^
                  +'('+str0(z0e)+' <-> '+str0(anzahl_spuren-1)+')',dat_fehler,leer);


              if (z0<>z) or (k0<>k) or (s0<>s) then
                ausschrift_x(textz_sekt__fehler_in_der_partitionstabelle1^
                            +'['+str0(z0)+'/'+str0(k0)+'/'+str0(s0)+']'
                            +textz_sekt__fehler_in_der_partitionstabelle2^
                            +'['+str0(z)+'/'+str0(k)+'/'+str0(s)+']!',dat_fehler,leer);

              berechnet:=(longint(z0e-z0)*anzahl_koepfe+longint(k0e-k0))*sektoren_je_spur+s0e-s0+1;
              if (berechnet<>length_of_partition_in_sectors) then
                ausschrift_x(textz_sekt__fehler_in_der_partitionstabelle_a1^
                            +strx(length_of_partition_in_sectors,11)
                            +textz_sekt__fehler_in_der_partitionstabelle_a2^
                            +strx(berechnet,11)+'!',dat_fehler,leer);

              (* noch keine PrÅfung ob sich Partitionen Åberschneiden *)
            end;


          (* LVM-Informationen auswerten ***************************)
          if lvm_daten_gefunden and (not (systemart in [$00,$05,$0f])) then
            with lvm_sektor.laufwerksbuchstabenzuordnung[pn] do
              begin
                exezk:=pfad+hauptbaumzeichen[pn];
                leerzeichenerweiterung(exezk,35);

                ausschrift_x(exezk+textz_sekt__LVM_Partition^+puffer_zu_zk_e(part_name  ,#0,20)+'"',
                  beschreibung,leer);
                ausschrift_x(exezk+textz_sekt__LVM_Laufwerk^ +puffer_zu_zk_e(vol_name   ,#0,20)+'"',
                  beschreibung,leer);
                ausschrift_x(exezk+textz_sekt__Buchstabe^    +puffer_zu_zk_e(buchstabe  ,#0,20)+':',
                  beschreibung,leer);

                if laenge<>berechnet then
                  ausschrift('LVM: '+str0(laenge)+' <-> '+str0(berechnet)+':: Sektoren',dat_fehler);
                if start<>lin then
                  ausschrift('LVM: '+str0(start)+' <-> '+str0(lin)+':: Anfangssektor',dat_fehler);
              end;
          (*********************************************************)


          (* Startsektor laden und untersuchen ... *)
          if (systemart in
           [5,                          (* erweitert                    *)
              7,                        (* OS/2 IFS                     *)
                1,4,6,                  (* FAT                          *)
                      $b,$c,$e,         (* Windows 95                   *)
                               $f,      (* erweitert Neuerfindung MS    *)
                                  $35,  (* LVM                          *)
                                  $84   (* SystemSoft                   *)
                                 ]) then
            begin
              if laufwerk=255 then
                begin
                  lesefehler:=88;
                  FillChar(lvm_sektor,SizeOf(lvm_sektor),0);
                end
              else
                begin
                  rek_quelle:=quelle;
                  lesefehler:=bios_sektor_lesen(laufwerk,z,k,s,sektoren_je_spur,anzahl_koepfe,p2_);
                  quelle:=rek_quelle;
                end;

              if (lesefehler=0) and bytesuche(p2_.d[0],'SystemSoft') then
                begin
                  exezk:=pfad+hauptbaumzeichen[pn];
                  leerzeichenerweiterung(exezk,35);
                  ausschrift_x(exezk+puffer_zu_zk_e(p2_.d[0],#0,$20),beschreibung,leer);
                end
              else if lesefehler=0 then
                begin

                  if anfang_der_erweiterten_partition=0 then
                    anfang_der_erweiterten_partition2:=lin
                  else
                    anfang_der_erweiterten_partition2:=anfang_der_erweiterten_partition;

                  systemart_lvm:=parti_tab(p1).tab[pn].systemart;
                  if (systemart_lvm=$84) and (puffer_zu_zk_l(parti_tab(p2).lader[$36],3)='FAT') then
                    systemart_lvm:=$04;

                  if (systemart_lvm=$35) and (parti_tab(p2).lader[$26] in [$28,$29]) then
                    if (puffer_zu_zk_l(parti_tab(p2).lader[$36],3)='FAT' )
                    or (puffer_zu_zk_l(parti_tab(p2).lader[$36],4)='HPFS')
                    or (puffer_zu_zk_l(parti_tab(p2).lader[$36],3)='JFS' ) then
                      systemart_lvm:=$07;


                  if parti_tab(p1).tab[pn].systemart in [$05,$0f{, $84}] then
                    begin
                      pfad:=pfad+hauptbaumzeichen[pn]+'  ';
                      Inc(pfad_zeichenkettenlaenge,1+Length('  '));
                      partitions_verfolgung(p2,
                         laufwerk,anzahl_spuren,sektoren_je_spur,anzahl_koepfe,
                         anfang_der_erweiterten_partition2,lin,lin+length_of_partition_in_sectors);
                      Dec(pfad_zeichenkettenlaenge,1+Length('  '));
                      SetLength(pfad,pfad_zeichenkettenlaenge);


                      (*$IfNDef VirtualPascal*)
                      (* LVM neu laden *)
                      FillChar(lvm_sektor,SizeOf(lvm_sektor),0);
                      if lvm_daten_gefunden then
                        begin
                          rek_quelle:=quelle;
                          bios_sektor_lesen(laufwerk,z_lvm,k_lvm,sektoren_je_spur,sektoren_je_spur,anzahl_koepfe,lvm_sektor_);
                          quelle:=rek_quelle;
                        end;
                      (*$EndIf*)
                    end
                  else
                    if  (parti_tab(p2).sig=#$55#$aa)
                    and (systemart_lvm<>$84)
                    and (systemart_lvm<>$35)
                     then
                      begin

                        if  (pn=1)
                        and (parti_tab(p1).byte_01=1)
                        and (parti_tab(p1).bootmanager_name  [8]=#0)
                        and (parti_tab(p1).bootmanager_zusatz[8]=#0)
                        and (not lvm_daten_gefunden) (* keine Daten des "alten" BM anzeigen *)
                         then
                          begin
                            bm_name:=puffer_zu_zk_e(parti_tab(p1).bootmanager_name,#0,8);
                            if ist_ohne_steuerzeichen_nicht_so_streng(bm_name) then
                              begin
                                exezk:=pfad+hauptbaumzeichen[pn];
                                leerzeichenerweiterung(exezk,16);
                                ausschrift_x(exezk+' IBM Bootmanager:  Ø'+bm_name+'Æ',beschreibung,leer);
                              end;
                          end;

                        exezk:=pfad+hauptbaumzeichen[pn];
                        leerzeichenerweiterung(exezk,35);



                        if not (parti_tab(p1).tab[pn].systemart in [$0b,$0c,$0e]) then
                          begin
                            if parti_tab(p2).lader[$26] in [$28,$29] then

                              ausschrift_x(exezk
                                +leerzeichenerweiterung_f('Ø'+leer_filter(
                                    puffer_zu_zk_e(parti_tab(p2).lader[$03],#0,  8))+'Æ',1+  8+1)
                                +' '
                                +leerzeichenerweiterung_f('Ø'+leer_filter(
                                    puffer_zu_zk_e(parti_tab(p2).lader[$2b],#0,8+3))+'Æ',1+8+3+1)
                                +' '
                                +leerzeichenerweiterung_f('Ø'+leer_filter(
                                    puffer_zu_zk_e(parti_tab(p2).lader[$36],#0,  8))+'Æ',1+  8+1),beschreibung,leer)

                            else (* DOS < 4 (FAT 12) *)

                              ausschrift_x(exezk
                                +leerzeichenerweiterung_f('Ø'+leer_filter(
                                    puffer_zu_zk_e(parti_tab(p2).lader[$03],#0,  8))+'Æ',1+  8+1)
                                +' (DOS < 4?)',beschreibung,leer)

                          end
                        else (* getestet mit $0b *)
                          ausschrift_x(exezk
                            +leerzeichenerweiterung_f('Ø'+leer_filter(
                                puffer_zu_zk_e(parti_tab(p2).lader[$03],#0,  8))+'Æ',1+  8+1)
                            +' '
                            +leerzeichenerweiterung_f('Ø'+leer_filter(
                                puffer_zu_zk_e(parti_tab(p2).lader[$47],#0,8+3))+'Æ',1+8+3+1)
                            +' '
                            +leerzeichenerweiterung_f('Ø'+leer_filter(
                                puffer_zu_zk_e(parti_tab(p2).lader[$52],#0,  8))+'Æ',1+  8+1),beschreibung,leer);

                      end;
                end
              else
                if laufwerk<255 then
                  ausschrift(textz_Lesefehler^,dat_fehler)
                else
                  ausschrift(textz_nicht_weiterverfolgt^,dat_fehler)

            end (* Systemart in 5..$84 *)
          else
            if (systemart=$0a) and (laufwerk<>255) then
              begin
                rek_quelle:=quelle;
                lesefehler:=bios_sektor_lesen(laufwerk,z,k,s,sektoren_je_spur,anzahl_koepfe,p2_);
                quelle:=rek_quelle;
                exezk:=pfad+hauptbaumzeichen[pn];
                leerzeichenerweiterung(exezk,35);
                if puffer_gefunden(p2_,'I13X') then
                  exezk_anhaengen(textz_sekt__mit_int13x^)
                else
                  exezk_anhaengen(textz_sekt__ohne_int13x^);
                ausschrift_x(exezk,normal,leer);
              end;

        end; (* for 1..4 .. with *)


    if (anzahl_benutzter_partitionseintraege>2)
    and (relativ_zu<>0) (* erweiterte Partitionstabelle *) then
      ausschrift(':: mehr als 2 EintrÑge sind nicht zulÑssig!',dat_fehler);

  end; (* partitions_verfolgung *)




procedure start_sekt(var   sekt_puffer:puffertyp;
                     const wdh:boolean;
                     const laufwerk:byte;
                     const echter_startsektor:boolean;
                           zylinder,sektoren_je_spur,anzahl_koepfe:word_norm);
  var
    sektor_zahl         :longint;
    sektkopf            :longint;
    ibm_ms_dos_zk       :string[40];
    kopie               :puffertyp;
    vpart2start         :byte;
    sekt_tmp_puffer     :puffertyp;
    zeige_disketteninhalt :boolean;


  (*$IfDef DPMIX*)
  function bytesuche_sekt_puffer_0(const s:string):boolean;
    begin
      bytesuche_sekt_puffer_0:=bytesuche(sekt_puffer.d[0],s);
    end;
  (*$EndIf*)

  (*$IfDef DOS_ODER_DPMI*)
  function bytesuche_sekt_puffer_0(const s:string):boolean;assembler;
    asm
      (* umstÑndlich weil sekt_puffer
         nicht in der Parameterliste auftaucht
         oder im datensegment liegt            *)
      mov di,[bp+4]
      les ax,ss:[di+offset sekt_puffer]
      inc ax
      inc ax

      push es
        push ax

          les di,s
          push es
            push di

              call typ_var.bytesuche_far
    end;
  (*$EndIf*)

  (*$IfDef VirtualPascal*)
  function bytesuche_sekt_puffer_0(const s:string):boolean;assembler;(*$Frame+*)(*$Uses NONE*)
    asm
      mov eax,[ebp-4]
      mov eax,[eax+offset sekt_puffer]
      inc eax (* sektpuffer.d *)
      inc eax
      push eax
        push s
          call bytesuche
    end;
  (*$EndIf*)

  (* $IfDef DUMM*)
  function _bytesuche_sekt_puffer_0(const s:string):boolean;
    begin
      _bytesuche_sekt_puffer_0:=bytesuche(sekt_puffer.d[0],s);
    end;
  (* $EndIf*)


  procedure tbavtext;
    var
      w1                  :word_norm;
    begin
      w1:=puffer_pos_suche(sekt_puffer,#$5e#$eb#$f0,$160)+1;
      if w1<>nicht_gefunden then
        begin
          if sekt_puffer.d[w1+3]=$c3 then Inc(w1);
          teletext(sekt_puffer,w1+3,#$00,falsch);
        end;
    end;

  function ibm_ms_dos:string;
    begin
      if ibm_ms_dos_zk='' then
        ibm_ms_dos:=textz_unbekannte_Version_mir_schicken^
      else
        ibm_ms_dos:=copy(ibm_ms_dos_zk,2,255);
    end;

  procedure ausschrift_signatur(const zk:string);
    begin
      ausschrift(zk,signatur);
    end;

  procedure ausschrift_signatur_dos_kern_name(const zk1,zk2:string);
    var
      tmp:string;
    begin
      tmp:=zk1+' ['+ibm_ms_dos+']';
      if zk2<>'' then
        tmp:=tmp+' '+zk2;
      ausschrift(tmp,signatur);
    end;

  procedure ibm_ms_dos_zk_anh(const zk:string);
    begin
      ibm_ms_dos_zk:=ibm_ms_dos_zk+' '+zk;
    end;

  var
    w1,w2               :word_norm;

  procedure erkenne_dateinamen;
    begin
      ibm_ms_dos_zk:='';

      (* nur bei richtigen Sektoren *)
      if bytesuche(sekt_puffer.d[$1fe],#$55#$aa)
      or bytesuche(sekt_puffer.d[$1fe],#$00#$00)
       then
        begin
          if (puffer_pos_suche(sekt_puffer,'OS2BOOT    ',512)<>nicht_gefunden)
          or (puffer_pos_suche(sekt_puffer,'OS2BOOT'#0  ,512)<>nicht_gefunden)
           then
            ibm_ms_dos_zk_anh('OS2BOOT');

          if (puffer_pos_suche(sekt_puffer,'JFSBOOT    ',512)<>nicht_gefunden) then
            ibm_ms_dos_zk_anh('JFSBOOT');

          (* von Memdisk benutzt *)
          if (puffer_pos_suche(sekt_puffer,'MEMBOOT    ',512)<>nicht_gefunden) then
            ibm_ms_dos_zk_anh('MEMBOOT');
          if (puffer_pos_suche(sekt_puffer,'MEMBOOT BIN',512)<>nicht_gefunden) then
            ibm_ms_dos_zk_anh('MEMBOOT.BIN');

          if (puffer_pos_suche(sekt_puffer,'CD2BOOT    ',512)<>nicht_gefunden) then
            ibm_ms_dos_zk_anh('CD2BOOT'); (* Roman Stangl *)
          if puffer_pos_suche(sekt_puffer,'OS2LDR     ',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('OS2LDR');
          if puffer_pos_suche(sekt_puffer,'NTLDR      ',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('NTLDR');
          if puffer_pos_suche(sekt_puffer,'cafio   com',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('CAFIO.COM');
          if puffer_pos_suche(sekt_puffer,'X-DOS   SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('X-DOS.SYS');

          if puffer_pos_suche(sekt_puffer,'PTSBIO  SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('PTSBIO.SYS');
          if puffer_pos_suche(sekt_puffer,'PTSLDR  SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('PTSLDR.SYS');
          if puffer_pos_suche(sekt_puffer,'BOOTWIZ SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('BOOTWIZ.SYS');
          if puffer_pos_suche(sekt_puffer,'PTSDOS  SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('PTSDOS.SYS');

          w1:=puffer_pos_suche(sekt_puffer,'IBMBIO  ???',512);
          if w1<>nicht_gefunden then
            ibm_ms_dos_zk_anh('IBMBIO.'+puffer_zu_zk_l(sekt_puffer.d[w1+8],3));

          if puffer_pos_suche(sekt_puffer,'ibmbio  com',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('IBMBIO.COM');
          if puffer_pos_suche(sekt_puffer,'IO      SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('IO.SYS');
          if puffer_pos_suche(sekt_puffer,'io      sys',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('IO.SYS');
          if puffer_pos_suche(sekt_puffer,'WINBOOT SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('WINBOOT.SYS');
          if puffer_pos_suche(sekt_puffer,'DOSPLUS SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('DOSPLUS.SYS');
          if puffer_pos_suche(sekt_puffer,'IPL     SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('IPL.SYS');
          if puffer_pos_suche(sekt_puffer,'MIO     SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('MIO.SYS(!? ¯)');
          if puffer_pos_suche(sekt_puffer,'DOSBIO  COM',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('DOSBIO.COM(!? ¯)');
          (* SUSE LINUX 5.3 *)
          if puffer_pos_suche(sekt_puffer,'LDLINUX SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('LDLINUX.SYS');
          if puffer_pos_suche(sekt_puffer,'VPART   FAT',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('VPART.FAT');
          if puffer_pos_suche(sekt_puffer,'BOOT_ROMEMU',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('BOOT_ROM.EMU');
          if puffer_pos_suche(sekt_puffer,'LOADER  SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('LOADER.SYS');
          if puffer_pos_suche(sekt_puffer,'SETUPLDRBIN',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('SETUPLDR.BIN');
          if puffer_pos_suche(sekt_puffer,'TBIOS   SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('TBIOS.SYS');
          if puffer_pos_suche(sekt_puffer,'TDOS    SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('TDOS.SYS');

          (* COMPAQ ROMPAQ SP0429 *)
          if puffer_pos_suche(sekt_puffer,'BIO     COM',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('BIO.COM');
          if puffer_pos_suche(sekt_puffer,'DOS     COM',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('DOS.COM');

          if puffer_pos_suche(sekt_puffer,'BOOTMAN SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('BOOTMAN.SYS');

          (* System Commander Delyxe 4.0 A: *)
          if puffer_pos_suche(sekt_puffer,'SCOSW_A SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('SCOSW_A.SYS');

          (* MSTBOOT 4.0 *)
          if puffer_pos_suche(sekt_puffer,'MSTBOOT SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('MSTBOOT.SYS');

          (* Checkit *)
          if puffer_pos_suche(sekt_puffer,'CHLDR   SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('CHLDR.SYS');

          (* RxDOS 6 *)
          if puffer_pos_suche(sekt_puffer,'RXDOSBIOSYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('RXDOSBIO.SYS');

          (* DR DOS 3.4 *)
          if puffer_pos_suche(sekt_puffer,'DRBIOS  SYS',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('DRBIOS.SYS');

          (* BootIt Next Generation / TeraByte Unlimited *)
          if puffer_pos_suche(sekt_puffer,'EMBRL      ',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('EMBRL');

          (* FreeDOS *)
          if (puffer_pos_suche(sekt_puffer,'KERNEL  SYS'#$00    ,512)<>nicht_gefunden)
          or (puffer_pos_suche(sekt_puffer,'KERNEL  SYS'#$55#$aa,512)<>nicht_gefunden) then
            ibm_ms_dos_zk_anh('KERNEL.SYS');

          (* XOSL *)
          if puffer_pos_suche(sekt_puffer,'XOSLLOADXCF',512)<>nicht_gefunden then
            ibm_ms_dos_zk_anh('XOSLLOAD.XCF');

        end;
    end;

  begin (* start_sekt *)
    zeige_disketteninhalt:=false;
    erfinde_zylinder_sektoren_je_spur_anzahl_koepfe(zylinder,sektoren_je_spur,anzahl_koepfe,sekt_puffer);
    (*$IfNDef PROFILER*)
    vpart2start:=sekt_puffer.d[$c];
    if vpart2start=ord('.') then
      vpart2start:=2;

    erkenne_dateinamen;

    (* ecs_101de_cd1.iso hat 510*#0+#$55#$aa *)
    if quelle.sorte=q_datei then
      begin
        w1:=0;
        while (w1<sekt_puffer.g) and (sekt_puffer.d[w1]=0) do Inc(w1);
        if w1>=512-2 then Exit;
      end;



    Dec(herstellersuche);
    if  bytesuche(sekt_puffer.d[510],#$55#$AA)
    and (not(sekt_puffer.d[510-1] in [$55,$AA]))
    (* Palette : 00,55,aa,.. *)
    and (not bytesuche(sekt_puffer.d[0],'GIF8')) (* GIF *)
    and (not bytesuche(sekt_puffer.d[0],'BM'))   (* BMP *)
     then
      begin
        hersteller_erforderlich:=wahr;
        if (sekt_puffer.d[$0B]=$00) and (sekt_puffer.d[$0C]=$02) then
          (* 512 Byte / Sektor -> Sartsektor *)
          begin
            sektor_zahl:=word_z(@sekt_puffer.d[$13])^;
            if sektor_zahl=0 then
              if (sekt_puffer.d[$26] in [$28,$29])
              or bytesuche(sekt_puffer.d[$52],'FAT32') then
                sektor_zahl:=longint_z(@sekt_puffer.d[$20])^;


            exezk:='"'+puffer_zu_zk_l(sekt_puffer.d[3],8)+'"';
            if wdh then exezk:=textz_Startsektor^+exezk;

            sektkopf:=longint(word_z(@sekt_puffer.d[$18])^) (* 18 Sektoren/Spur *)
                     *longint(word_z(@sekt_puffer.d[$1A])^); (* 2 Seiten *)

            (* freebsd-btx-lader hat nur unvollstÑndige Angaben *)
            if sektor_zahl=0 then
              if (sektkopf>=8) and (sektkopf<=2*36) then
                sektor_zahl:=DGT_zu_longint(DivDGT(einzel_laenge,512));

            if sektkopf<>0 then
              exezk_anhaengen(' '+str0((sektor_zahl+sektkopf-1) div sektkopf) +'/' (* Zylinder *)
                              +str0(word_z(@sekt_puffer.d[$1a])^) +'/' (* Kîpfe    *)
                              +str0(word_z(@sekt_puffer.d[$18])^));    (* Sektoren *)
              (* Iomagea ZIP 100: Zylinder 1: Spur 0 ist fÅr dir Partitionstabelle reserviert,
                 es sind also eher 96 als 95 Spuren (95,984375) *)

            if (quelle.sorte=q_datei) and (einzel_laenge>=4*512) then (* Startsektor+2 FAT+Hauptverzeichnis? *)
              begin
                exezk_anhaengen(textz_klammer_Abzugsdatei_klammer^);
                zeige_disketteninhalt:=true;
                if sektkopf<>0 then
                  einzel_laenge:=longint(sektor_zahl)*512;
              end;
            ausschrift_signatur(exezk);
          end
        else
          begin
            if ((sekt_puffer.d[$1be] or sekt_puffer.d[$1ce] or sekt_puffer.d[$1de] or sekt_puffer.d[$1ee]) and $7f)=0 then
              begin
                ausschrift_signatur(textz_Partitionstabelle^);
                partitions_verfolgung(parti_tab(sekt_puffer),laufwerk,zylinder,sektoren_je_spur,anzahl_koepfe,
                  0,0,(longint(zylinder)*sektoren_je_spur)*anzahl_koepfe);
                if (quelle.sorte=q_datei) and (einzel_laenge>512) then
                  begin
                    (* Normalerweise 512 Byte lang, aber bei enca.vhd (~2GiB) nur 511 *)
                    if bytesuche__datei_lesen(analyseoff+AndDGT(einzel_laenge-1,-512),'conectix'#$00) then
                      begin
                        einzel_laenge:=AndDGT(einzel_laenge-1,-512);
                        (* fÅr VPART: Ñndert auf 512 Byte *)
                        merke_position(analyseoff+einzel_laenge,datentyp_unbekannt);
                      end;
                  end;
              end
            else
              ausschrift_signatur(textz_Partitionstabelle_oder_Startsektor^);
          end;
      end
    else
      if echter_startsektor then
        begin
          if sekt_puffer.g=512 then
            ausschrift(textz_kein_gueltiger_Startsektor^,dat_fehler)
          else
            ausschrift_signatur(textz_Sektorgroesse^+str0(sekt_puffer.g)+textz_Byte^);
        end
      else
        if bytesuche(sekt_puffer.d[$36],'FAT') (* checkit hat 00 00 statt 55 aa (wegen virenverdacht?) *)
        and (quelle.sorte=q_datei) and (einzel_laenge>512)
        and (AndDGT(einzel_laenge,512-1)=0) then
          zeige_disketteninhalt:=true;

    inc(herstellersuche);
    if bytesuche(sekt_puffer.d[0],#$eb#$3c#$90'SRD ') then
      ausschrift_signatur('ReSizable RAMDisk / Marko Kohtala');

    if bytesuche(sekt_puffer.d[0],#$eb#$fe#$90'F.') then (* FU_RD *)
      ausschrift_signatur('XMSDSK + EMSDSK / Franck Uberto');

    if bytesuche(sekt_puffer.d[0],#$eb#$29#$90'TDSK') then
      ausschrift_signatur('Turbo Disk / Ciriaco Garcia de Celis');

    if bytesuche(sekt_puffer.d[0],#$e9#$71#$00'xDISK') then
      ausschrift_signatur('xDisk / FM de Monasterio');

    if bytesuche(sekt_puffer.d[0],#$e9#00#$00#$90)
    or bytesuche(sekt_puffer.d[0],#$eb#00#$90)
     then
      ausschrift_signatur(textz_Startsektorkode_fehlt^);

    if bytesuche(sekt_puffer.d[0],#$1f#$8b#$08) and (quelle.sorte in [q_sektor_bios_cxdx,q_sektor_bios_zks])
     then
      ausschrift('GNU-Zip / Jean-loup Gailly ( '+textz_kein_FAT_Format^+' )',packer_dat);

    kopie:=sekt_puffer;

    trace(sekt_puffer);

    (*$IfDef ERWEITERUNGSDATEI*)
    suche_erweiterungen(sekt_puffer);
    (*$EndIf*)

    (*$IfDef VirtualPascal*)
    busch_suche(Ptr(Ofs(sekt_busch))^,sekt_puffer.d[0]);
    (*$Else*)
    busch_suche(Ptr(Seg(sekt_busch),Ofs(sekt_busch))^,sekt_puffer.d[0]);
    (*$EndIf*)


    case sekt_puffer.d[0] of
      $00:
        begin

          (* ea 7b8:105 *)
          if bytesuche_sekt_puffer_0('?'#$05#$01#$b0#$07#$b8#$b0#$07#$8e#$d8#$8e#$d0#$bc#$fe#$ff
             +#$66#$68#$00#$01#$00#$80#$1e#$68'??'#$e8'??'#$0b#$c0#$74) then
            (* IPL06/0B(LBA).BIN *)
            ausschrift_signatur_dos_kern_name('Extended Operating System Loader / Geurt Vos','');


          (* ea 43 00 c0 07 *)
          if bytesuche_sekt_puffer_0('??'#$00#$c0#$07#$fc#$33#$db#$8e#$d3#$bc#$00#$04#$80#$fa#$01#$77#$04
                +#$2e#$88#$57#$24#$8e#$c3#$26#$c5) then
            ausschrift_signatur_dos_kern_name('BootIt Next Generation / TeraByte Unlimited','');

          if bytesuche_sekt_puffer_0('?'#$43#$00#$c0#$07#$33#$c0#$8e#$d0#$bc#$00#$7c#$0e#$1f#$e8#$10#$00) then
            (* Angelika Khellaf *)
            begin
              (* ausschrift_signatur(textz_Hersteller_unbekannt^+', "This diskette ..." ¯'); *)
              (* CNFMT106.LZH *)
              ausschrift_signatur('Con>Format / Sydex');
              contain(sekt_puffer,$9f-$3E);
            end;

          if bytesuche_sekt_puffer_0('???QSYS')
          or bytesuche_sekt_puffer_0('???LESD') then
            ausschrift_signatur('LESDISK / Les Moskowitz ≥ MEMBRAIN / Dennis Lee ≥ PC-Magazine ..');

          if bytesuche_sekt_puffer_0('???AMDISK') then
            ausschrift_signatur('ADJRAM / Gary Cramblitt');

          if bytesuche_sekt_puffer_0('???RAMDRXMS') then
            ausschrift_signatur('Ramdrive / Hyperware [5.0]');

          if bytesuche_sekt_puffer_0('???TF--V') then
            ausschrift_signatur('VGADISK / Tommy Frandsen');

          if bytesuche_sekt_puffer_0('???Nifty') then
            ausschrift_signatur('Nifty James ... RAM Disk Drive ');

          if bytesuche_sekt_puffer_0('?'#$fe#$90'FU  ') then
            ausschrift_signatur('RAM Disk / Franck Uberto');

          if bytesuche_sekt_puffer_0('???VDISK') then
            ausschrift_signatur('VDISK / Vladimir Lanin ≥ ...');

          if bytesuche_sekt_puffer_0('???XPAND') then
            ausschrift_signatur('XPANDISK / M. J. Meffort');

          if bytesuche_sekt_puffer_0(#$00#$54#$4B#$54#$52) then
            (* Technische Krankenkasse *)
            begin
              ausschrift_signatur('K.I.W.I. ['+textz_Hersteller_unbekannt^+'] ¯');
              teletext(sekt_puffer,$5c-$2A,#$00,falsch);
            end;

          if bytesuche_sekt_puffer_0('?'#$05#$00#$C0#$07#$E9#$99) then
            ausschrift('Stoned',virus);

          if bytesuche_sekt_puffer_0('??'#$41#$41#$41#$41#$41#$41) then
            (* D62 RDV 1.20 *)
            ausschrift_signatur('Ramdrive / Microsoft ≥ VDisk / IBM');

          if bytesuche_sekt_puffer_0(#$00#$03#$cd#$b8#$00#$02) then
            ausschrift_signatur('RAMDisk / PTSDOS');

          if (sekt_puffer.g>4) and bytesuche_sekt_puffer_0(#$00#$00#$00#$00#$00#$00) then
            begin
              if bytesuche(sekt_puffer.d[$70-$36],'Copyright 1991: DATA')
                then ausschrift_signatur('Double Density');
              if bytesuche(sekt_puffer.d[$50-$1E],#$E8#$10#$00)
                then ausschrift_signatur('Jumbo [?] '+textz_sekt__leicht_fehlerhaft^);

              if ((kopie.d[$0B]<>$00) or (kopie.d[$0C]<>$02))
              and (quelle.sorte<>q_datei)
              and (quelle.sorte<>q_speicher)
               then
                begin
                  ausschrift_signatur(textz_Partitionstabelle_ohne_Boot_Code^);
                end;

            end;

        end;
      $0E:
        begin
          if bytesuche_sekt_puffer_0(#$0e#$1f#$be'??'#$b4#$0e#$bb#$07#$00#$b9'??'#$8a#$04#$cd#$10) then
            begin
              (* FDISK 7.03 Beta *)
              ausschrift_signatur('FAT32 DRDOS / Caldera [7.03]');
              teletext(kopie,sekt_puffer.d[$03],#0,falsch);
              (* not bootable ... *)
            end;

          if bytesuche_sekt_puffer_0(#$0e#$1f#$33#$c0#$fa#$8e#$d0#$bc#$00#$7c#$fb) then
            begin
              ausschrift_signatur('Trace Mountain Prod');
              teletext(sekt_puffer,sekt_puffer.d[$4a-$3e]-$3e,#0,falsch);
            end;

        end;
      $1E:
        begin
          if bytesuche_sekt_puffer_0(#$1e#$56#$0e#$1f#$b8#$00#$06#$b7#$07) then
            begin
              ausschrift_signatur(textz_Hersteller_unbekannt^+', "Sharewareservice M. Vogt" ¯');
              teletext(sekt_puffer,$58-$1e,#0,falsch);
            end;
        end;
      $2b:
        begin
          if bytesuche_sekt_puffer_0(#$2b#$c0#$8e#$d8#$8e#$c0#$be#$00#$7c) then
            ausschrift_signatur('Ontrack '+textz_Lader^);

        end;

      $33:
        begin
          if bytesuche_sekt_puffer_0(#$33#$c9#$8e#$d1#$bc#$f4#$7b#$8e#$c1#$8e#$d9#$bd#$00#$7c
             +#$88#$4e#$02#$8a#$56#$40#$b4#$08#$cd#$13#$73#$05#$b9#$ff#$ff#$8a#$f1) then
            (* acronis os selector 5: bootcfg: 962b2.sek *)
            ausschrift_signatur_dos_kern_name('Windows 2000 / MS','[FAT32]');

          if bytesuche_sekt_puffer_0(#$33#$c9#$8e#$d1#$bc#$00#$7c#$8b#$ec#$51#$b4#$08#$8a#$56) then
            begin (* FAT12/16 *)
              case sekt_puffer.d[$e] of
                $24:exezk:='6.22'; (* sys.com: $46eb *)
                $40:exezk:='7.10'; (* sys.com: $4aeb *)
              else  exezk:='?¯';
              end;
              ausschrift_signatur_dos_kern_name('Datalight ROM DOS','['+exezk+']');
            end;

          if bytesuche_sekt_puffer_0(#$33#$c9#$8e#$d1#$bc#$00#$7c#$8b#$ec#$51#$8a#$56#$40#$3a#$d1#$7d'?'#$52#$33#$c0) then
            ausschrift_signatur_dos_kern_name('Datalight ROM DOS','[FAT32]');

          if bytesuche_sekt_puffer_0(#$33#$c0#$fa#$8e#$d0#$bc#$00#$7c#$fb) then
            (* xor ax,ax
               cli
               mov ss,ax
               mov sp,7c00
               sti         *)
            begin
              if bytesuche(sekt_puffer.d[$09],#$8c#$c8#$8e#$d8#$e8#$07#$00#$b8) then
                begin
                  ausschrift_signatur('FBX / Fifth Generation Systems [Symantec]');
                  sekt_puffer.d[$63-$36+sekt_puffer.d[$57-$36]]:=0;
                  teletext(sekt_puffer,$63-$36,#0,falsch);
                end;

              if bytesuche(sekt_puffer.d[$09],#$0e#$1f#$0e#$07#$fc#$be#$57#$7c) then
                begin
                  ausschrift_signatur('CLEANBOOT / Dr. Salomon AVT');
                  teletext(sekt_puffer,$7c57-($7c00+$36),#0,falsch);
                end;

              if bytesuche(sekt_puffer.d[$09],#$fc#$8e#$d8#$8b#$f4#$8e#$c0#$bf#$00#$06#$b9#$00#$01#$f3#$a5
                   +#$e9#$00#$8a) then
                (* cld
                   mov ds,ax
                   mov si,sp
                   mov es,ax
                   mov di,0600
                   mov cx,0100
                   repz movsw
                   jmp 0600    *)
                begin

                  if bytesuche(sekt_puffer.d[$1b],#$b4#$10#$b2#$81#$cd#$13) then
                    ausschrift_signatur('DrivePro / Micro House <2>');
                end;

            end;

          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$d0#$bc#$00#$7c#$68#$c0#$07#$1f#$a0#$10#$00#$f7#$26#$16) then
            ausschrift_signatur_dos_kern_name('NTBOOT / MS','');

          if bytesuche_sekt_puffer_0(#$33#$c9#$8e#$d1#$bc'??'#$16#$07#$bd#$78#$00#$c5#$76#$00#$1e#$56) then
            (* Windows 0.98 *)
            ausschrift_signatur_dos_kern_name('Windows 4.1 / MS','');

          if bytesuche_sekt_puffer_0(#$33#$c9#$8e#$d1#$bc#$f0#$7b#$8e#$d9#$b8#$00#$20
              +#$8e#$c0#$fc#$bd#$00#$7c#$38#$4e#$24#$7d#$24) then
            (* pu17-gefundene formatierte Diskette *)
            ausschrift_signatur_dos_kern_name('Windows ?.?¯ / MS','');


          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$d0#$bc#$00#$7c#$bb#$c0#$07) then
            ausschrift_signatur_dos_kern_name('OS/2 / IBM [10.X]','');

          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$d8#$fa#$8e#$d0#$bc#$00#$7c#$fb#$bb#$0a#$00#$b9#$20#$03#$b8#$20#$09) then
            begin
              (* LITFORM.LZH *)
              ausschrift_signatur('Lite Format / Falk Data Systems');
              teletext(kopie,$20,#$00,falsch);
            end;

          if bytesuche_sekt_puffer_0(#$33#$c0#$fa#$8e#$d0#$bc#$f0#$7b#$fb#$b8#$c0#$07) then
            begin
              ausschrift_signatur('No Boot / ??? ¯');
              teletext(sekt_puffer,$60-$3e,'$',falsch);
            end;

          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$d0#$8e#$d8#$8e#$c0#$bc#$00#$7c#$8b) then
            begin
              ausschrift_signatur(textz_Partitionstabelle^+' Tracer / Goldware');
              teletext(sekt_puffer,$ab,#0,falsch);
              teletext(sekt_puffer,$106,#0,falsch);
              teletext(sekt_puffer,$161,#0,falsch);
            end;


          if bytesuche_sekt_puffer_0(#$33#$db#$8e#$d3#$bc#$00#$7c#$bb#$c0#$07) then
            (* ohne INT 3 ABER AUCH OHNE FC *)
            ausschrift_signatur_dos_kern_name('OS/2 / IBM [2+]','<33>');


          if bytesuche_sekt_puffer_0(#$33#$c0#$8e#$d8#$8e#$c0#$8e#$d0#$66#$bc#$00#$18#$00#$00#$b4#$01#$cd#$16
            +#$74#$06#$b4#$00#$cd#$16#$eb#$f4#$b4#$08#$b2#$00#$cd#$13) then
            ausschrift('UnixWare [7.0]',signatur)
        end;
      $5b:
        begin
          if bytesuche_sekt_puffer_0(#$5b#$b4#$0e#$2e#$8a#$07#$3c#$00#$74#$05#$cd#$10) then
            begin
              ausschrift_signatur('"JUMBO" / ? ¯');
              (* STACK: $0153 statt $7d53 *)
              teletext(kopie,stack_inhalt-$100,#$00,falsch);
            end;
        end;
      $5E:
        begin

          if bytesuche_sekt_puffer_0(#$5e#$81#$ee'??'#$0e#$1f#$b8#$60#$00#$8e#$c0#$31#$ff#$b9#$00#$01#$f3#$a5#$06) then
            begin
              ausschrift_signatur('QNX');
              zeige_disketteninhalt:=false;
            end;

          if bytesuche_sekt_puffer_0(#$5e#$83#$c6#$11#$ac#$0a#$c0) then
            begin
              ausschrift_signatur('GeoWorks');
              teletext(sekt_puffer,$52-$41,#$00,falsch);
            end;
        end;
      $5F:
        begin
          if bytesuche_sekt_puffer_0(#$5f#$f7#$00#$f0#$ff#$75#$06#$81#$08#$70) then
            ausschrift('Form    '+textz_Teil^+' 2',virus);
        end;

      $66:
        begin
          if bytesuche_sekt_puffer_0(#$66#$ea#$08#$00#$00#$00#$c0#$07#$8c#$c8#$8e#$d8#$8e#$c0#$8e#$d0
               +#$bc#$00#$7c#$fb#$fc#$be#$31#$00#$ac#$20#$c0#$74#$09#$b4#$0e#$bb#$07#$00#$cd#$10) then
            begin (* knopix 3.4 M:\linux26 Z:\boot\isolinux\linux26 *)
              ausschrift_signatur('<?/linux26>');
              teletext(sekt_puffer,$31,#0,falsch);
            end;
        end;

      $68:
        begin
          if bytesuche_sekt_puffer_0(#$68#$c0#$07#$17#$bc#$f5#$ff#$16#$1f#$1e#$07#$b8#$13#$00#$cd#$10) then
            begin
              ausschrift_signatur('Cool Boot / Suicide Software [1.0]');
              ausschrift(puffer_zu_zk_l(kopie.d[$1d6],kopie.d[$1fc]),beschreibung);
            end;
        end;

      $87:
        begin
          if bytesuche_sekt_puffer_0(#$87#$e4#$30#$00) then
            ausschrift_signatur('TbFence / Thunderbyte "'+tbfence_pw(sekt_puffer)+'" [Speicher]');

          if bytesuche_sekt_puffer_0(#$87#$e4#$fa#$33#$c9#$8e) then
            ausschrift_signatur('TbFence / Thunderbyte');
        end;

      $8C:
        begin
          if bytesuche_sekt_puffer_0(#$8c#$c8#$8e#$d8#$8e#$d0#$bc#$00#$7c#$e8#$00#$00#$5e#$83#$c6'?'#$bb) then
            begin
              (*disk2_vk(kopie,sekt_puffer.d[$f],sekt_puffer.d[$11]);*)
              ausschrift_signatur('Disk2 / Veit Kannegieser');
              poly_emulator(poem_modus_sekt);
            end;

          if bytesuche_sekt_puffer_0(#$8c#$c8#$8e#$d0#$bc#$00#$7c#$8e#$d8#$be'?'#$7c#$e8) then
            begin
              ausschrift_signatur('Track0 / Zhu Zhenyang [3.0]');
              (* fehlerhaft teletext(kopie,word_z(@sekt_puffer.d[$A])^-$7c00,#0,falsch) *)
            end;

          if bytesuche_sekt_puffer_0(#$8c#$c8#$3d#$00#$7c#$74#$08#$be'??'#$e8#$6a#$00#$cd#$20#$fa#$33#$c0) then
            begin
              ausschrift_signatur('FdFormat / Christoph H. HochstÑtter [1.5]');
              w1:=word_z(@sekt_puffer.d[$7a-$42])^-$100-$42;
              if (w1>=0) and ($1f0>=w1) and (sekt_puffer.d[w1]=0) then
                sekt_puffer.d[w1]:=ord(32);
              teletext(sekt_puffer,word_z(@sekt_puffer.d[$7a-$42])^-$100-$42,#$00,falsch);
            end;

          if bytesuche_sekt_puffer_0(#$8c#$c8#$3d#$00#$7c#$74#$02#$cd#$20#$fa#$b8) then
            begin
              ausschrift_signatur('BlitzCopy / Oliver Siebenhaar + Udo Steger [2.0]');
              teletext(kopie,sekt_puffer.d[$22+1],#$00,falsch);
            end;

          if bytesuche_sekt_puffer_0(#$8c#$c8#$8e#$d8#$8e#$c0#$fa#$8e#$d0#$bc#$00#$f0#$fb#$e8) then
            begin
              ausschrift_signatur('QED-Tools + D2Disk / K. Henske & H. P. Winkelmann');
              blocktext(kopie,$20,7,46);
            end;

        end;

      $8e:
        begin


          if  bytesuche_sekt_puffer_0(#$8e#$d8#$8e#$c0#$fc#$b9#$00#$01#$be#$00#$7c#$bf#$00#$80#$f3#$a4#$ea#$5e)
          and bytesuche(sekt_puffer.d[$25],#$ea#$00#$7c#$00#$00#$cd#$19)
           then (* Fesplattenlader *)
            ausschrift('? <KAY19991222> / ? ¯',signatur);

        end;

      $90:
        begin
          if bytesuche_sekt_puffer_0(#$90#$90#$ea#$45#$01#$b0#$07#$8c#$c8#$8e#$d8#$8e#$d0
            +#$bc#$fe#$ff#$e8#$0f#$00#$b8#$00#$80#$8e#$d8#$8e#$d0#$bc) then
            (* IPLS(LBA).BIN *)
            ausschrift_signatur_dos_kern_name('Extended Operating System Loader / Geurt Vos [FAT]','');
        end;


      $b4:
        begin
          if bytesuche_sekt_puffer_0(#$b4#$00#$b0#$02#$cd#$10#$b8#$c0#$07#$8e#$d8) then
            begin
              ausschrift_signatur('Agathe / H. GÅnther');
              teletext(sekt_puffer,$41-$1e,#0,falsch);
            end;

          if bytesuche_sekt_puffer_0(#$b4#$0f#$cd#$10#$50#$53#$b4#$00#$cd#$10) then
            begin
              ausschrift_signatur('PkZip-'+textz_Archivdatentraeger^);
              ansi_anzeige(analyseoff+word_z(@sekt_puffer.d[$4e-$3e])^,#0,
                ftab.f[farblos,hf]+ftab.f[farblos,vf],absatz,wahr,wahr,unendlich,'');
              sekt_puffer.d[0]:=0;(* Thedraw *)
            end;

        end;

      $B8:
        begin
          if bytesuche_sekt_puffer_0(#$b8#$03#$00#$cd#$10#$b8#$01#$13#$bb#$40#$00#$b9#$11#$00#$2b#$d2#$0e#$07#$e8) then
            begin
              ausschrift_signatur('MemDisk / Veit Kannegieser (no bootsector)');
              arbeitszeile:=leerzeile;
              for w1:=1 to sekt_puffer.d[$0c] do
                begin
                  if w1>High(arbeitszeile) then Break;
                  arbeitszeile[w1][1]:=sekt_puffer.d[$15+w1-1];
                  arbeitszeile[w1][2]:=sekt_puffer.d[$09];
                end;
              schreibe_zeile(arbeitszeile);
            end;

          if bytesuche_sekt_puffer_0(#$b8#$00#$80#$8e#$d0#$bc#$00#$01#$0e#$1f#$b4#$03#$2a#$ff#$cd#$10#$bf#$00#$7c
             +#$0a#$d2#$74#$06#$be'??'#$e8'??'#$be'??'#$e8'??'#$16#$07) then
            begin
              (* 2001.10.21 *)
              ausschrift_signatur('VPart / Veit Kannegieser '+textz_Lader^);
              vpart1_anzeige(sekt_puffer);

              datei_lesen(sekt_tmp_puffer,512*(vpart2start-1),512);
              vpart_neu(sekt_tmp_puffer);

              einzel_laenge:=512;
            end;

          if bytesuche_sekt_puffer_0(#$b8#$03#$00#$cd#$10#$bf#$00#$80#$be#$00#$7c#$33#$db#$8e#$c3#$8e#$db#$fa#$8e#$d3) then
            begin
              ausschrift_signatur('BootKill / Ralph Roth'); (*  [1.61], 1.7, 3.x *)
              w1:=puffer_pos_suche(kopie,#$be'??'#$e8'??'#$b9'?'#$00#$33#$db#$b8#$b0#$0a#$cd#$10,400);
              if w1<>nicht_gefunden then
                w1:=word_z(@kopie.d[w1+1])^ and $1ff
              else
                begin
                  w1:=puffer_pos_suche(kopie,#$8d#$36'??'#$e8'??'#$b9'?'#$00#$33#$db#$b8#$b0#$0a#$cd#$10,400);
                  if w1<>nicht_gefunden then
                    w1:=word_z(@kopie.d[w1+2])^ and $1ff
                end;
              if w1<>nicht_gefunden then (* alt: [$42] *)
                teletext(kopie,w1,#0,falsch);
            end;

          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$d8#$8e#$c0#$8e#$d0#$33#$e4#$8b#$0e#$0e#$00#$41) then
            ausschrift_signatur_dos_kern_name('MSTBOOT / Olaf H. Barth [4]','');

          { kein BSP ???
          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$c0#$8e#$d8#$be'??'#$b4#$0e) then
            begin
              ausschrift~('BootThru / Bill Gibson []',signatur);
              teletext(kopie,word_z(@sekt_puffer.d[8])^,#$ff,falsch);
            end;}

          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$c0#$8e#$d8#$be#$2c#$00#$fc#$ac#$3c#$ff) then
            begin
              ausschrift_signatur('Bootctl / Foley Hi-Tech Systems [2.02]');
              teletext(kopie,$2c,#$ff,falsch);
            end;

          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$c0#$8e#$d8#$be'??'#$fc#$b4#$0e#$ac#$3c#$ff) then
            begin
              (* alt: ausschrift~ PD-Service Lage ¯ *)
              ausschrift_signatur('BootThru / Bill Gibson');
              teletext(kopie,word_z(@sekt_puffer.d[8])^,#$ff,falsch);
            end;

          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$c0#$8e#$d8#$be'??'#$b4#$0e#$8a#$04#$3c#$00) then
            begin
              ausschrift_signatur('INVIS-I-Disk / J D O''Donnell & E E Hrivnak');
              teletext(kopie,word_z(@sekt_puffer.d[8])^,#$00,falsch);
            end;


          if bytesuche_sekt_puffer_0(#$b8#$50#$00#$8e#$c0#$2b#$c0#$8e#$d8#$1e#$c5) then
            ausschrift_signatur_dos_kern_name('DOSPLUS / Digital Research [1.2]','');


          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$50#$1f#$bb#$56#$00#$90#$b9#$27#$01) then
            begin
              ausschrift_signatur('Indianapolis 500');
              teletext(sekt_puffer,$56-$2c,#$00,falsch);
            end;

          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$50#$1f#$b8#$00#$0f#$cd#$10#$89#$1e#$f0#$01#$80) then
            begin
              ausschrift_signatur('??? / L. Daxer');
              blocktext(sekt_puffer,$85-$20,9,40);
            end;


          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$50#$1f#$bb#$57#$00#$90) then
            begin
              ausschrift_signatur('Norton BOOT / Peter Norton');
              teletext(sekt_puffer,$57-$2c,#0,falsch);
            end;

          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$d8#$8c#$06#$5a#$00)
          or bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$d8#$8c#$06#$62#$00#$89#$36)
             (* SUSE 4.4.1= KERNEL 2.0.29 *)
          or bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$d8#$8c#$06'?'#$00#$89#$36'?'#$00#$89#$1e) (* SUSE 2.0.33,NICHT FAT *)
           then
            begin
              ausschrift_signatur('Linux "LILO"');
              sekt_puffer.d[0]:=0;{wen betrifft das?}
            end;

          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$d8#$eb) then
            ausschrift_signatur('X-Copy / A. S. I. [Fraktal]');

          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$d8#$8e#$c0#$be) then
            ausschrift_signatur('X-Copy / A. S. I. [Festplatte]');

          if bytesuche_sekt_puffer_0(#$b8#$c0#$07#$8e#$d8#$b8'??'#$8e#$c0) then
            begin
              ausschrift_signatur(textz_Lader_des_Linux_Kerneldekompressors^);
              einzel_laenge:=512;
            end;

          if bytesuche_sekt_puffer_0(#$b8#$00#$06#$b7#$07#$33#$c9#$ba#$4f#$18) then
            begin
              ausschrift_signatur('CoStudio / Michael Lange');
              ansi_anzeige(analyseoff+word_z(@sekt_puffer.d[$7f-$3e])^,#0,
                ftab.f[farblos,hf]+ftab.f[farblos,vf],absatz,wahr,wahr,unendlich,'');
            end;
        end;

      $bb:
        begin
          if bytesuche_sekt_puffer_0(#$bb'??'#$ba'??'#$be#$13#$04#$31#$ff#$8e#$df#$ff#$0c) then
            (* push cs, call ...
               if bytesuche_sekt_puffer_0(#$0e#$e8'??'#$50#$d1#$e8#$fe#$cc#$74#$03#$e9'??'#$53#$51) then*)
            ausschrift('B1 (TBSCAN) ≥ NYB (AVPL)',virus);

          if bytesuche_sekt_puffer_0(#$bb#$c0#$07#$8e#$db#$8e#$c3#$bb#$59) then
            begin
              ausschrift_signatur('BOOPS / Urmas Rahu');
              teletext(sekt_puffer,$59-$33,#0,falsch);
            end;

        end;

      $bd:
        begin
          if bytesuche_sekt_puffer_0(#$bd#$00#$7c#$0e#$17#$8b#$e5#$0e#$1f#$88#$56#$24#$66#$0f#$b7#$46#$0e
            +#$bb#$00#$40#$8b#$7e#$16#$0e#$57#$e8'??'#$66#$58#$f6#$66#$10) then
            ausschrift_signatur_dos_kern_name('MemDisk / Veit Kannegieser [2003.12.05]','');
        end;

      $BE:
        begin
          if bytesuche_sekt_puffer_0(#$be'?'#$7c#$e8#$12#$00#$b4#$01) then
            begin
              ausschrift_signatur('WYTRON ¯');
              teletext(sekt_puffer,$64-$3e,#0,falsch);
            end;
        end;

      $BF:
        begin
          if bytesuche_sekt_puffer_0(#$bf#$00#$80#$be#$00#$7c#$33#$db#$8e#$c3) then
            begin
              ausschrift_signatur('BootKill / Ralph Roth');
              teletext(kopie,kopie.d[$42],#0,falsch);
            end;
        end;

      $C1:
        begin
          if bytesuche_sekt_puffer_0(#$c1#$05#$05) then
            begin
              exezk:='';
              b1:=$e;
              while sekt_puffer.d[b1]>0 do
                begin
                  exezk_anhaengen(chr(sekt_puffer.d[b1]));
                  inc(b1);
                end;
              ausschrift_signatur(textz_Systemabsicherung^+' [$F800] / Novell Dos 7 "'+exezk+'"');
            end;
        end;

      $cc:
        begin
          if bytesuche_sekt_puffer_0(#$cc#$fa#$33#$db#$8e#$d3#$bc#$ff#$7b#$fb#$ba) then
            ausschrift_signatur_dos_kern_name('OS/2 / IBM [2+]','mit INT 3');
        end;

(*    $ea: gibt es nicht: -> $00
        begin

        end; *)

      $f6:
        begin
          if bytesuche_sekt_puffer_0(#$f6#$f6#$f6#$f6) then
            ausschrift_signatur('** '+textz_ungueltig^+'! ** ("ˆˆˆˆ")');
        end;

      $fa:
        begin
          case sekt_puffer.d[1] of
            $0E:(* FA0E *)
              begin
                if bytesuche_sekt_puffer_0(#$fa#$0e#$17#$bc#$00#$7c#$fb#$0e#$1f#$ba) then
                  begin
                    ausschrift_signatur('PTS-Bootman');
                    teletext(sekt_puffer,word_z(@sekt_puffer.d[$15-$b])^-$b,#0,falsch);
                  end;
              end;
            $29:
              begin
                if bytesuche_sekt_puffer_0(#$fa#$29#$c0#$8e#$d0#$bc#$00#$7c#$fb#$0e#$1f) then
                  begin
                    (* sonst Fehler bei XDFCOPY.EXE *)
                    if ibm_ms_dos_zk='' then ibm_ms_dos_zk:=' ';

                    ausschrift_signatur_dos_kern_name('XDF / Backup Tech. ≥ OS2_188 [1.10+] / S. Georgiev Boychev','');

                    if (sekt_puffer.d[$f0]=$0a) and (ibm_ms_dos_zk<>' ') then
                      teletext(sekt_puffer,$140-$51,#0,falsch);
                  end;

              end;
            $2B:(* FA2B *)
              begin
                if bytesuche_sekt_puffer_0(#$fa#$2b#$c0#$8e#$d0#$b8#$00#$7c#$8b#$e0
                  +#$fb#$fc#$2b#$c0#$8e#$d8#$be#$00#$7c#$b8#$60#$00#$8e#$c0#$2b#$ff) then
                  begin
                    case sekt_puffer.d[$34] of
                      $0f:exezk:='[IBMBIO.LDR]';
                      $0c:exezk:='';
                    else
                          exezk:='??? ¯';
                    end;
                    ausschrift_signatur('Novell DOS 7 '+textz_Partitionstabelle^+' '+exezk);
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$2b#$ff#$8e#$d7#$bc#$00#$7c#$fb#$fc#$8e) then
                  ausschrift_signatur('Novell DOS 7 '+textz_Partitionstabelle^);

                if bytesuche_sekt_puffer_0(#$fa#$2b#$c0#$8e#$d0#$8e#$c0#$bc#$00#$7c#$bb#$78) then
                  ausschrift_signatur_dos_kern_name('XTF-Boot / Executive Systems Inc [VER ?.?]','');

              end;
            $31:(* FA31 *)
              begin
                if bytesuche_sekt_puffer_0(#$fa#$31#$c9#$8e#$d1#$89#$cc#$8e#$d9#$8e#$c1#$fb#$fc
                    +#$e8#$00#$00#$5e#$81#$c6#$13#$00#$ac#$08#$c0#$74#$fe#$bb#$07#$00#$b4#$0e) then
                  begin
                    (* SUSE9, \boot\modules[1..5] *)
                    ausschrift_signatur('<?/modules*>');
                    teletext(sekt_puffer,$23,#0,falsch);
                  end;

              end;

            $33:(* FA33 *)
              begin
                if bytesuche_sekt_puffer_0(#$fa#$33#$ff#$8e#$d7#$bc#$00#$7c#$fb#$fc#$8e#$df#$8b#$f4#$b8#$60#$00) then
                  begin
                    ausschrift_signatur('Lader MasterBooter / Nagy Daniel [2.3]');
                    masterbooter_kennwort;
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$33#$db#$8e#$d3#$bc#$00#$09#$fb#$b8#$c0#$07
                  +#$8e#$d8#$8e#$c3#$26#$8b#$0e#$13#$04#$c1#$e1#$06#$8b#$16#$16) then
                  ausschrift_signatur_dos_kern_name('CheckIt Loader / TouchStone [1.2]','');

                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e) then
                  begin

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$8e#$d8#$8e#$c0#$bc#$00#$7c#$fb) then
                      (* cli
                         xor ax,ax
                         mov ss,ax
                         mov ds,ax
                         mov es,ax
                         mov sp,7c00 *)
                      begin
                        if bytesuche(sekt_puffer.d[13],#$fc#$99#$cd#$13#$72'?'#$be'?'#$7d#$43) then
                          ausschrift_signatur('"Vitamin-B" FFORMAT / NHSoft [2.99]');
                      end;

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d8#$8b#$f8#$8e#$d0#$bc#$00#$7c#$8b#$f4#$fb
                      +#$b8#$00#$10#$8e#$c0#$fc#$b9#$00#$01#$f3#$a5#$ea) then
                      ausschrift_signatur('FENES / Morten Jîregensen');




                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$fb) then
                      (* cli
                         xor ax,ax
                         mov ss,ax
                         mov sp,7c00
                         cli         *)
                      begin

                        if bytesuche(sekt_puffer.d[$9],#$8e#$c0#$8e#$d8#$be#$00#$7c#$bf#$00#$7e
                           +#$fc#$b9#$00#$02#$f3#$a4#$be) then
                          ausschrift_signatur('kMBR / Knut Stange Osmundsen [0.36]');

                        (* $4D66A.PAR *)
                        if bytesuche(sekt_puffer.d[$9],#$fc#$8e#$d8#$8b#$f4#$8e#$c0#$bf#$00#$06#$b9#$00#$01#$f3#$a5
                             +#$e9#$00#$8a)
                        (* $4D86A.PAR *)
                        or bytesuche(sekt_puffer.d[$9],#$fc#$8e#$d8#$8e#$c0#$8b#$f4#$bf#$00#$0c#$b9#$00#$01#$f3#$a5
                             +#$e1#$1d#$06)

                        or (bytesuche(sekt_puffer.d[$9],#$fc#$8e#$d8#$8b#$f4#$8e#$c0#$bf#$00#$06#$b9#$00#$01#$f3#$a5
                             +#$ea'?'#$06)
                            and (sekt_puffer.d[$19] in [$1d,   (* $4DE6A.PAR *)
                                                       $5b])) (*  40b92.SEK *)
                         then
                          ausschrift_signatur('DrivePro / Micro House <1>');


                      end;



                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$fb#$8e#$d8#$8e#$c0#$fc#$a1#$4e#$00#$3d) then
                      begin
                        ausschrift_signatur('NVCLEAN / Norman Data Defense Systems [4 BOOT]');
                        teletext(kopie,word_z(@sekt_puffer.d[$96-$5a+1])^-$7c00,#$00,falsch);
                      end;

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8a#$4c#$01) then
                      ausschrift_signatur_dos_kern_name('PTS-DOS 6.X','');

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d8#$8e#$c0#$fc#$b9#$00#$01
                      +#$be#$00#$7c#$bf#$00#$80#$f3#$a5#$ea#$56#$00#$00#$08) then
                      begin
                        if bytesuche(sekt_puffer.d[$18],#$b8#$13#$00#$cd#$10#$b8#$00#$08#$8e#$d8#$8e#$c0) then
                          ausschrift_signatur('VGA-Copy / Mînkemeier [UR 6.23]');
                      end;

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8b#$f4#$50#$1f) then
                      begin
                        (* "BBOOT" *)
                        ausschrift_signatur('Drive B Boot Utility / Yong Chen');
                        if sekt_puffer.d[$6f]=$be then
                          teletext(kopie,word_z(@sekt_puffer.d[$6f+1])^-$100,#$00,falsch);
                      end;

                    (* SWAPBOOT,... JMP 0800:0056 *)
                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d8#$8e#$c0#$fc#$b9#$00#$01#$be#$00#$7c#$bf#$00#$80#$f3#$a5
                        +#$ea'?'#$00#$00#$08) then
                      begin

                        if bytesuche(sekt_puffer.d[$18],#$b9'?'#$00#$be'??'#$e8'??'#$c7#$06) then
                          begin
                            ausschrift_signatur('NOBOOT / c'#39't');
                            teletext(kopie,word_z(@sekt_puffer.d[52+1])^,#0,falsch);
                          end;

                        if bytesuche(sekt_puffer.d[$18],#$b9'?'#$00#$e8'??'#$c7#$06) then
                          begin
                            ausschrift_signatur('Vertspeed (NOBOOT / c'#39't)');
                            teletext(kopie,word_z(@sekt_puffer.d[49+1])^,#0,falsch);
                          end;

                        if bytesuche(sekt_puffer.d[$18],#$be'??'#$e8'??'#$b8) then
                          begin
                            ausschrift_signatur('Swap Boot / Zvi Netiv ≥ VgaCopy / Mînkemeier [4.6..6.x]');
                            w1:=word_z(@sekt_puffer.d[$18+1])^;
                            for w2:=w1 to $1fe do
                              if  (kopie.d[w2]=0)
                              and (kopie.d[w2+1]<>0)
                              and (not bytesuche(kopie.d[w2+1],#$55#$aa)) (* VGACOPY *)
                              and (not bytesuche(kopie.d[w2+1],#$2e#$ac)) (* SWAPBOOT *)
                              and (not bytesuche(kopie.d[w2+1],#$0d#$0a#$0a'Lau')) (* VGACOPY *)
                               then
                                kopie.d[w2]:=ord(' ');
                            teletext(kopie,w1,#$00,falsch);
                          end;

                      end;

                  end
                else (* FA33XXXX, XXXX<>C08E *)
                  begin

                  end;

                (******************************)

                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$7c
                  +#$fb#$cd#$13#$72#$74#$be#$42#$7d#$e8#$91#$00) then
                  begin
                    ausschrift_signatur('DISK-EMU / Carlos Fern†ndez Sanz');
                    ansi_anzeige(analyseoff+word_z(@sekt_puffer.d[$12])^-$7c00,#0,
                      ftab.f[farblos,hf]+ftab.f[farblos,vf],absatz,wahr,wahr,unendlich,'');
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c) then
                  begin

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8b#$f4#$8e#$c0#$8e#$d8#$fb#$fc) then
                      (* CLI
                         XOR AX,AX
                         MOV SS,AX
                         MOV SP,7C00
                         MOV SI,SP
                         MOV ES,AX
                         MOV DS,AX
                         STI
                         CLD *)
                      begin
                        if bytesuche(sekt_puffer.d[$10],#$bf#$00#$06#$b9#$00#$01#$f3#$a5#$ea'?'#$00#$60#$00#$bf#$05#$00) then
                          (* SMARTDEM.ZIP\INSTALL.EXE *)
                          ausschrift_signatur('ZppA, SMART Pro, Power Boot / Bluesky Innovations LLC');

                        if bytesuche(sekt_puffer.d[$10],#$bf#$00#$06#$b9#$00#$01#$f2#$a5#$ea'?'#$06#$00#$00#$be#$be#$07) then
                          (* NDD NU 8.0 *)
                          ausschrift_signatur('NDD / Symantec '+textz_restaurierte_Partitionstabelle^);
                      end;

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8e#$d8#$a3#$7a#$00) then
                      ausschrift_signatur_dos_kern_name('PC-DOS 2.0 <2>','');


                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$b8#$b0#$07#$8e#$d8) then
                      begin
                        ausschrift_signatur('WinImage / Gilles Vollant [FdFormat / Christoph H. HochstÑtter]');
                        teletext(sekt_puffer,$76,#0,falsch);
                      end;


                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$b8#$b0#$07#$50#$50#$1f#$07#$be
                     +#$00#$01#$bf#$00#$03) then
                      begin
                        ausschrift_signatur('FdFormat / Christoph H. HochstÑtter [1.8]');
                        case chr(sekt_puffer.d[$77]) of
                        'F':(* ORIGINAL *);
                        'V':ausschrift_signatur(textz_veraenderter_Text^+' : (VgaCopy / Mînkemeier [4.5])');
                        #13:ausschrift_signatur(textz_veraenderter_Text^+' : (HD-Copy / Oliver Fromme [1.7q,..])');
                        else
                          ausschrift_signatur(textz_veraenderter_Text^);
                        end;
                        teletext(sekt_puffer,word_z(@sekt_puffer.d[$6b-$42])^-$100-$42,#$00,falsch);
                      end;

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8e#$c0#$fc#$fb#$bb#$78) then
                      ausschrift_signatur_dos_kern_name('Quickformat J.Peters [A3-Programme]','');


                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8e#$d8#$8e#$c0#$fb#$be#$1b) then
                      begin
                        ausschrift_signatur('Norton Utils <2:BATTLETEC>');
                        teletext(sekt_puffer,$58-$2A,#0,falsch);
                      end;

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8b#$f4#$50#$07#$50) then
                      begin
                          if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8b#$f4#$50#$07#$50#$1f
                            +#$fb#$fc#$bf#$00#$06#$b9#$00#$01#$f2#$a5#$ea#$87#$06) then
                            (* BMANAG10 *)
                            ausschrift_signatur('O.S. Bootmanager / J.Botargues [1.0]');

                        if puffer_pos_suche(sekt_puffer,#$32#$e4#$cd#$16#$05#$50#$00,500)<>nicht_gefunden then
                          ausschrift_signatur('ZPART / Wolfgang Zitzelsberger "'
                            +chr(sekt_puffer.d[$DA]-$50)
                            +chr(sekt_puffer.d[$DC]-$50)
                            +chr(sekt_puffer.d[$DE]-$50)
                            +chr(sekt_puffer.d[$E0]-$50)+'"')
                        else if bytesuche(sekt_puffer.d[$a0],#$a2#$de) then
                          begin
                            (*ausschrift_signatur('OS-Select / Thomas WolfRAM')
                            if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8b#$f4#$50#$07#$50#$1f#$fc
                              +#$bf#$00#$06#$b9#$00#$01#$f3#$a5#$ea#$1c#$06) then*)
                            ausschrift_signatur('OS Boot Select / Thomas wolfRAM [1.35]');
                            teletext(kopie,sekt_puffer.d[$1c+1],#0,falsch);
                          end
                        else if bytesuche(sekt_puffer.d[$1d],#$be#$be#$07#$b3#$04) then
                          ausschrift_signatur('Fdisk / PC-DOS, MS-DOS / IBM, Microsoft')
                        else if bytesuche(sekt_puffer.d[$1d],#$bf#$05#$00#$b8#$10#$02) then
                          ausschrift_signatur('F0Disk / Dirk A. Handzik')
                        else if bytesuche(sekt_puffer.d[$1d],#$ea#$2a#$00#$60#$00#$80#$3e'??'#$01#$75) then
                          ausschrift_signatur('Boot Menu / Morten Jîregensen')
                        (* else if .. *);
                      end;

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8b#$f4#$50#$07#$50#$1f#$fb#$fc
                      +#$bf#$00#$06#$b9#$00#$01#$f3#$a5#$ea#$25#$06) then
                      ausschrift_signatur('OS Boot Select / Thomas wolfRAM [2.0 B8]');

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8e#$d8#$fb#$be) then
                      begin
                        ausschrift_signatur(textz_sekt__unbekannt^+' "CMAST" ¯');
                        teletext(sekt_puffer,$5d-$36,#0,falsch);
                      end;

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$be#$00#$7c#$8e#$c0#$8e#$d8) then
                      ausschrift_signatur(textz_sekt__unbekannt^+' "GMBR" ¯');

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$b8#$c0#$07#$50#$05#$20#$00) then
                      begin
                        ausschrift_signatur('2M / Ciriaco Garia de Celis [3.0] HD');
                        teletext(sekt_puffer,$190-$75,#0,falsch);
                      end;

                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$b8#$c0#$07#$50#$50#$1f#$07) then
                      begin
                        ausschrift_signatur('2M / Ciriaco Garia de Celis [3.0] DD');
                        teletext(sekt_puffer,$106-$66,#0,falsch);
                      end;


                    if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$8b#$f4#$8e#$d8#$8e#$c0#$fc#$bf#$00#$10)
                     then
                      begin
                       ausschrift_signatur('Super Virtual Disk / Alberd J. Shan [1.10,1.18]');
                       w1:=word_z(@sekt_puffer.d[$70-$3e])^;
                       if (w1>$1000) and (w1<$1200) then
                         teletext(kopie,w1-$1000,#0,falsch);
                      end;

                  end; (* ENDE  FA33C0..... *)


                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$16#$07#$8d#$2e#$03#$7c#$bb#$78#$00) then
                  (* ps/valuepoint *)
                  ausschrift_signatur_dos_kern_name('PC-DOS / IBM ≥ MS-DOS / Microsoft','(PS/Valuepoint)');

                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$16#$07#$bb#$78#$00) then
                  begin
                    (* MDISK: *)
                    case sekt_puffer.d[$15] of
                      $20:exezk:='3.00';
                      $2B:if sekt_puffer.d[$69]=$96 then
                            exezk:='3.20'
                          else
                            exezk:='3.30';
                      $1f:exezk:='3.20';
                      $3E:
                        case sekt_puffer.d[$73-$3e] of
                          $7c:exezk:='4.0X';
                          $79:exezk:='5.0+';
                        else
                          exezk:='4.00+ ¯';
                        end;
                    else
                      exezk:='?.?';
                    end;
                    if bytesuche(kopie.d[$1e5],#$00'     ') then
                      ibm_ms_dos_zk_anh('(Partition Magic)');

                    ausschrift_signatur_dos_kern_name('PC-DOS / IBM ≥ MS-DOS / Microsoft',exezk);
                  end;


                if bytesuche_sekt_puffer_0(#$fa#$33#$eb#$3c#$90) then
                  ausschrift(textz_FEHLER_welches_Programm_erzeugt_solche_MSDOS_Sektoren^,dat_fehler);

                if bytesuche_sekt_puffer_0(#$fa#$33#$ed#$b8#$c0#$07#$8e#$d8#$c4#$1e#$1c#$00) then
                  ausschrift_signatur_dos_kern_name('Compaq','');

                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$8e#$d8#$8e#$c0#$bc#$00#$7c#$fc#$88) then
                  ausschrift_signatur_dos_kern_name('PC-DOS 2.0 <1>','');

                if bytesuche_sekt_puffer_0(#$fa#$33#$c9#$8e#$d1#$bc#$fc#$7b#$16#$07#$bd#$78#$00#$c5#$76#$00) then
                  ausschrift_signatur_dos_kern_name('Windows 4.0 / MS','');

                if bytesuche_sekt_puffer_0(#$fa#$33#$c9#$8e#$d1#$bc#$f8#$7b#$8e#$c1#$bd#$78#$00#$c5#$76#$00) then
                  ausschrift_signatur_dos_kern_name('Windows 4.0 / MS','"FAT32"');

                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$fe#$7b#$fb#$1e) then
                  case sekt_puffer.d[$70-$55] of
                   $b1:ausschrift('Form A  Teil 1',virus);
                   $26:ausschrift('Form C  Teil 1',virus);
                  else
                       ausschrift('Form ['+textz_unbekannte_Version^+']  Teil 1',virus);
                  end;


                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$c0#$8e#$d0#$bc#$00#$7b#$bb#$78) then
                  ausschrift_signatur_dos_kern_name('LDLinux-Lader / H. Peter Anvin',''); (* RedHat Linux Boot *)

                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$8e#$c0#$bc#$00#$7c#$0e#$1f#$be#$00) then
                  begin
                    ausschrift_signatur('MS-Backup / Symantec');
                    teletext(sekt_puffer,$89-$44,#$00,falsch);
                  end;


                if bytesuche_sekt_puffer_0(#$fa#$33#$c9#$8e#$d1#$bc#$00#$7c#$8b#$f4#$fb#$fc) then
                  begin
                    (* FESTPLATTE *)
                    ausschrift_signatur('Tbutil / Thunderbyte AV [Festplatte]');
                    tbavtext;
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d8#$8e#$c0#$fb#$be'??'#$e8) then
                  begin
                    ausschrift_signatur('Fixutils SafeFBR / Padgett Peterson');
                    teletext(kopie,word_z(@sekt_puffer.d[8+1])^-$7c00,#0,false);
                  end;


                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$f0#$7b#$fb#$b8) then
                  begin
                    ausschrift_signatur('Norton Utils');
                    w1:=puffer_pos_suche(sekt_puffer,#$cd'?'#$cd#$19,$a0);
                    if w1<>nicht_gefunden then
                      begin
                        if sekt_puffer.d[w1+4]=$ac then
                          inc(w1,15);
                        teletext(sekt_puffer,w1+4,#0,falsch);
                      end;
                  end;


                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$7c#$fc#$b9) then
                  begin
                    if sekt_puffer.d[$21]=$b4 then
                      ausschrift_signatur('VGABOOT / Stefan Kurtzhals [BGRAF]')
                    else
                      begin
                        ausschrift_signatur('VGABOOT / Stefan Kurtzhals [Text]');
                        blocktext(sekt_puffer,$a2-$3e,8,42);
                      end;
                  end;


                if bytesuche_sekt_puffer_0(#$fa#$33#$db#$8e#$d3#$bc#$ff#$7b#$fb#$ba) then
                  (* die Variante ohne INT 3 *)
                  ausschrift_signatur_dos_kern_name('OS/2 / IBM [2+]','');

                if bytesuche_sekt_puffer_0(#$fa#$33#$c0#$8e#$d0#$bc#$00#$7c#$fb#$b8#$c0#$07#$8e#$d8#$a1#$24#$00) then
                  ausschrift_signatur_dos_kern_name('OS/2 / IBM [HPFS]','');

              end;


            $8C: (* fa 8c *)
              begin
                if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$7c#$fb#$e9) then
                  begin
                    if bytesuche__datei_lesen(analyseoff+codeoff_seg*16+codeoff_off+$d+3+word_z(@sekt_puffer.d[$d+1])^,
                       #$b4#$41#$b2'?'#$bb'??'#$cd#$13#$e8'??'#$72#$05#$ea#$00#$7e#$00#$00#$eb#$fe) then
                      ausschrift_signatur('BootManager PRO / Ralph Kirschner'); (* 2.20 *)
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$8e#$d8#$33#$d2#$8e#$d2#$bc#$00#$7c#$fb
                     +#$b8#$60#$00#$8e#$d8#$8e#$c0#$33#$d2#$8b#$c2#$cd#$13) then
                  ausschrift_signatur_dos_kern_name('PC-DOS 1.1','');

                if bytesuche_sekt_puffer_0(#$fa#$8c#$c9#$8e#$d1#$bc#$f0#$7b#$16#$07#$8b#$ec#$bb#$78#$00#$36#$c5#$37#$1e
                    +#$56#$51#$53#$8d#$7e#$04#$b1#$0c#$57#$fc#$f3#$a4#$06#$1f#$c6#$45#$fd#$0f#$8b#$46#$28
                    +#$88#$45#$f8#$8f#$07#$89#$4f#$02#$8b#$fd#$fb#$33#$c0#$72#$7e#$8b#$4e#$23#$e3#$03) then
                  ausschrift_signatur_dos_kern_name('PC-DOS 7.10','');

                if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$8e#$d8#$e8'??'#$56#$bb#$00#$08#$8e#$c3) then
                  begin
                    ausschrift_signatur('SCAT / Roedy Green * Canadian Mind Products');
                    teletext(kopie,word_z(@sekt_puffer.d[$61+1-$3e])^,#$00,falsch);
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$2e#$01#$06'??'#$33#$c0#$0e#$17#$bc#$00#$7c#$16#$07#$bb) then
                  ausschrift_signatur_dos_kern_name('IBM 4.00 [JAPANESE DISPLAY ADAPTER]','');

                if bytesuche_sekt_puffer_0(#$fa#$8c#$ca#$8e#$da#$8e#$c2#$8e#$d2#$bc#$00#$ff) then
                  begin
                    ausschrift_signatur(textz_Hersteller_unbekannt^+', Sharewarevertriebe ¯');
                    blocktext(sekt_puffer,$a3-$27,9,38);
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$8e#$d0#$bc#$00#$7c#$8e#$d8#$fb#$e8) then
                  begin
                    ausschrift_signatur(textz_Hersteller_unbekannt^+', IOMEGA SHIPDISK ¯');
                    teletext(sekt_puffer,$6a-$40,#0,falsch);
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$ff) then
                  begin
                    ausschrift_signatur('BSMP 1.2 / Bernd E. Schneider');
                    bsmp(sekt_puffer,$97-$3a);
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$8c#$c8#$8e#$d0#$bc#$00#$7c#$8e#$c0#$8a) then
                  ausschrift_signatur_dos_kern_name('PTS-DOS ['+textz_startbar^+']','');

              end;

            $B8:(* FAB8 *)
              begin
                if bytesuche_sekt_puffer_0(#$fa#$b8#$30#$00#$8e#$d0#$bc#$00#$01#$fb#$fc) then
                  begin
                    exezk:='';
                    if (x_longint(sekt_puffer.d[$1b8]) and $fffff000)=$DF5EE000 then
                      begin (* "Bad part-tables!" statt "OS/2 !! SYS01462" *)
                        exezk:=version161616(x_word(sekt_puffer.d[$1b8]) and $fff);
                        Insert('DFSEE ',exezk,3);
                      end;
                    ausschrift_signatur('FDISK OS/2'+exezk);(* OS2 3.0 *)
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$b8#$c0#$07#$8e#$d8#$8e#$d0#$bc#$00#$00#$fb#$fc
                  +#$be#$2c#$00#$ac#$b4#$0e#$33#$db#$cd#$10) then
                  begin
                    ausschrift_signatur('SPFDisk / Shiuh-Pyng Ferng <BOOTSECT>');
                    ansi_anzeige(analyseoff+word_z(@sekt_puffer.d[$e])^,#0,
                      ftab.f[farblos,hf]+ftab.f[farblos,vf],vorne,wahr,wahr,unendlich,'');
                  end;


                if bytesuche_sekt_puffer_0(#$fa#$b8#$00#$00#$8e#$d0#$bc#$00#$7c#$fb) then
                  (* cli
                     mov ax,0000
                     mov ss,ax
                     mov sp,7c00
                     sti *)
                  begin
                    if bytesuche(sekt_puffer.d[$0a],#$b8#$60#$00#$8e#$d8#$33#$c0#$8e#$c0#$be#$00#$76#$bf#$00#$06) then
                      (* mov ax,$0060
                         mov ds,ax
                         xor ax,ax
                         mov es,ax
                         mov si,$7c00-$0600
                         mov di,$0600 *)
                      ausschrift_signatur('XFDisk / Florian Painke [0.8.2]');

                    if bytesuche(sekt_puffer.d[$0a],#$fc#$8e#$d8#$8b#$f4#$8e#$c0#$bf#$00#$06#$b9#$00#$01#$f3#$a5
                         +#$ea#$1e#$06) then
                      (* cld
                         mov ds,ax
                         mov si,sp
                         mov es,ax
                         mov di,0600
                         mov cx,0100
                         repz movsw
                         jmp 0000:061e *)
                      begin
                        (* $4DC6A.PAR *)
                        if bytesuche(sekt_puffer.d[$1e],#$bf#$be#$07#$80#$3d#$80#$74#$2d) then
                          begin
                            ausschrift_signatur('DrivePro / Micro House <3>');
                            Exit; (* nicht VPART *)
                          end;
                        (* $4DA6A.PAR *)
                        if bytesuche(sekt_puffer.d[$1e],#$c6#$06'??'#$1a#$bd'?'#$07#$e8) then
                          begin
                            ausschrift_signatur('DrivePro / Micro House <4>');
                            Exit; (* nicht VPART *)
                          end;
                      end;
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$b8#$00#$80#$8e#$d0#$bc#$00#$80#$b8#$00#$80#$8e#$d8#$bb#$c0#$07
                    +#$8e#$c3#$fb#$66#$bf#$00#$00#$00#$00#$66#$bb#$00#$00#$00#$00#$b8#$1a) then
                  begin
                    ausschrift_signatur('JFSBOOT,isj / Pavel Shtemenko; Eugene Gorbunoff');
                    Exit; (* nicht VPART *)
                  end;


                if  bytesuche_sekt_puffer_0(#$fa#$b8#$00'?'#$8e#$d0#$bc#$00)
                and (sekt_puffer.d[3] in [$80]) {!! alte Versionen? }
                 then
                  (* 04.09.1995 *)
                  begin
                    ausschrift_signatur('VPart / Veit Kannegieser '+textz_Lader^);
                    vpart1_anzeige(sekt_puffer);

                    datei_lesen(sekt_tmp_puffer,512*(vpart2start-1),512);
                    vpart_neu(sekt_tmp_puffer);

                    einzel_laenge:=512;
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$b8#$01#$50#$8e#$d0#$bc#$ff#$ff) then
                  ausschrift_signatur('RBG-BOOT / Veit Kannegieser');

                if bytesuche_sekt_puffer_0(#$fa#$b8#$30#$00#$8e#$d0#$bc#$fc#$00#$fb#$0e#$1f#$bb#$07#$00#$be) then
                  begin
                    if sekt_puffer.d[$10]=$6C then
                      begin
                        ausschrift_signatur('QCopy / Ulrich FeldmÅller [3.1,4.0]');
                        teletext(sekt_puffer,$6c-$36,#0,falsch);
                      end;
                    if sekt_puffer.d[$10]=$76 then
                      begin
                        ausschrift_signatur('PC-Tools , CP-Backup / Central Point');
                        teletext(sekt_puffer,$76-$40,#0,falsch);
                      end;
                  end;


                if bytesuche_sekt_puffer_0(#$fa#$b8#$30#$00#$8e#$d0#$bc#$fc#$00#$fb#$0e#$1f#$be#$6d) then
                  begin
                    ausschrift_signatur('FOCUS-COPY / M. Eckert');
                    ansi_anzeige(analyseoff+word_z(@sekt_puffer.d[$4b-$3e])^-$7c00+2,#0,
                      ftab.f[farblos,hf]+ftab.f[farblos,vf],absatz,wahr,wahr,unendlich,'');
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$b8#$c0#$07#$8e#$d0#$bc#$3e#$00#$fc#$33) then
                  begin
                    ausschrift_signatur('FormatMaster / New-Ware');(* 5.5 *)
                    teletext(sekt_puffer,$AB-$40,#$00,falsch);
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$b8#$c0#$07#$50#$b8#$48#$00#$50#$cb#$0e) then
                  ausschrift_signatur_dos_kern_name('DOS-C 1.0 / Pat Villani [0.9]','');

                if bytesuche_sekt_puffer_0(#$fa#$b8#$c0#$07#$8e#$d0#$bc#$16#$0a#$50#$b8) then
                  ausschrift_signatur_dos_kern_name('DOS-C 1.0 / Pat Villani [0.91]','');

              end;

            $eb: (* FA EB *)
              begin

                if bytesuche_sekt_puffer_0(#$fa#$eb#$06'??????'#$31#$c0#$8e#$d0) then
                  (* BOOTNN-D.ZIP *)
                  begin (* 3.82,4.31,5.86,7.04,7.07 *)
                    ausschrift_signatur('Boot-Manager BOOTMENU,BootStar / IngenieurbÅro Hoyer [3.82..7.07]');
                    bootstar_kennwort;
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$eb#$5c) then
                  if bytesuche(sekt_puffer.d[1+2+$5c],#$31#$c0#$8e#$d0#$bc#$00#$7c#$89#$e6) then
                    begin
                      ausschrift_signatur('Smart Boot Manager / Suzhe; Lonius; ..');
                      sbm_kennwort;
                    end;

                if bytesuche_sekt_puffer_0(#$fa#$eb'AiRBOOT??????????'{#$fb#$fc#$b8#$00#$00#$8e#$d8#$be#$00#$7c}) then
                  begin
                    ausschrift_signatur('AiRBOOT / Martin Kiewitz'); (* 0.27 *)
                    airboot_kennwort;
                  end;
              end;

            $ea: (* FA EA *)
              begin
                if bytesuche_sekt_puffer_0(#$fa#$ea'?'#$7c#$00#$00#$31#$c0#$8e#$d8#$8e#$d0#$bc#$00#$20#$fb#$a0'?'#$7c
                    +#$3c#$ff#$74#$02#$88#$c2#$52#$be) then
                  ausschrift_signatur('GRand Unified Bootloader');
              end;



            $fc:(* FA FC *)
              begin

                if bytesuche_sekt_puffer_0(#$fa#$fc#$b8#$c0#$07#$8e#$d8#$b8#$a0#$07#$8e#$c0#$33#$f6#$33#$ff#$b9#$00#$01
                     +#$f3#$a5#$b8#$a0#$07#$8e#$d8#$ea#$1f#$00#$a0#$07
                     +#$bb#$be#$01#$33#$f6#$80#$3f#$80#$75) then
                  ausschrift_signatur('0vmakfil.exe / SystemSoft');


                if bytesuche_sekt_puffer_0(#$fa#$fc#$8c#$c8#$8e#$d0#$8e#$d8#$bd#$00#$7c#$8d#$66#$e0#$fb#$cd#$12
                  +#$b1#$06#$d3#$e0) then
                  ausschrift_signatur_dos_kern_name('FreeDos [0.7]',''); (* 0.76b command.com *)

                if bytesuche_sekt_puffer_0(#$fa#$fc#$8c#$c8#$8e#$d0#$bd#$00#$7c#$8d#$66#$e0#$fb#$8e#$c0) then
                  ausschrift_signatur_dos_kern_name('FreeDos [0.92]','');

                if bytesuche_sekt_puffer_0(#$fa#$fc#$31#$c0#$8e#$d8#$bd#$00#$7c#$b8#$e0#$1f#$8e#$c0#$89#$ee#$89#$ef) then
                  ausschrift_signatur_dos_kern_name('FreeDos [1.1.33]',''); (* FreeDOS ODIN 0.60 *)

                if bytesuche_sekt_puffer_0(#$fa#$fc#$31#$c0#$8e#$d0#$8e#$d8#$bd#$00#$7c#$8d#$66#$e0#$fb#$cd#$13
                    +#$b8'??'#$8e#$c0#$89) then (* 2002.04..09? *)
                  ausschrift_signatur_dos_kern_name('FreeDos [2]','');

                if bytesuche_sekt_puffer_0(#$fa#$fc#$31#$c0#$8e#$d0#$8e#$d8#$bd#$00#$7c#$8d#$66#$e0#$fb
                    +#$80#$7e#$24#$ff#$75#$03#$88#$56#$24#$b8#$e0#$1f) then (*intel flash bios bz87510a.86a.0093.p22.ib.exe*)
                  ausschrift_signatur_dos_kern_name('FreeDos [1.1.2.7]','');

                if bytesuche_sekt_puffer_0(#$fa#$fc#$8c#$c8#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$be#$05#$8b#$ec#$fb#$bf#$00#$06
                  +#$b9#$00#$01#$f3#$a5#$ea#$1d#$7c#$60#$00#$b9#$04#$00#$bb) then
                  ausschrift_signatur('RxDOS / Api Software MBR [7.2]');

                if bytesuche_sekt_puffer_0(#$fa#$fc#$33#$c0#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$d4#$7b#$8b#$ec#$88#$96#$06#$00
                  +#$bb#$78#$00#$26#$c5#$37#$8d#$be#$0e#$00#$26#$89#$3f#$26#$8c#$57#$02) then
                  ausschrift_signatur_dos_kern_name('RxDOS / Api Software [7.2]',''); (* FAT *)


                if bytesuche_sekt_puffer_0(#$fa#$fc#$31#$c9#$8e#$d1#$bc#$00#$60#$8e#$c1#$b1#$08#$bf'??'#$f3#$a5) then
                  ausschrift_signatur_dos_kern_name('LDLinux-Lader / H. Peter Anvin [1.40]',''); (* SUSE LINUX 5.3 *)

                if bytesuche_sekt_puffer_0(#$fa#$fc#$31#$c0#$8e#$d0#$bc#$e0#$7b#$8e#$c0
                  +#$b9#$08#$00#$89#$e7#$f3#$a5#$8e#$d8#$88#$55#$34#$20#$d2) then
                  ausschrift_signatur_dos_kern_name('LDLinux-Lader / H. Peter Anvin [1.75]',''); (* knoppix 3.1 *)

                if bytesuche_sekt_puffer_0(#$fa#$fc#$31#$c0#$8e#$d0#$bc#$e0#$7b#$8e#$c0
                  +#$b9#$08#$00#$89#$e7#$f3#$a5#$8e#$d8#$88#$55#$34#$bb#$78#$00) then
                  ausschrift_signatur_dos_kern_name('LDLinux-Lader / H. Peter Anvin [2.06]',''); (* SUSE 9 *)


                if bytesuche_sekt_puffer_0(#$fa#$fc#$33#$c0#$8e#$d0#$bc#$00#$7c#$16#$07#$bb#$78) then
                  begin
                    (* DN 1.42 *)
                    ausschrift_signatur('Dos Navigator / RIT Research Labs');
                    teletext(sekt_puffer,$19f-$44,#$00,falsch);
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$fc#$b8#$c0#$07#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$00#$00#$be#$2c#$00#$ac) then
                  begin
                    ausschrift_signatur('EZ-DisKlone Plus / EZX Publishing');
                    ansi_anzeige(analyseoff+$2c,#0,
                      ftab.f[farblos,hf]+ftab.f[farblos,vf],absatz,wahr,wahr,unendlich,'');
                  end;
                if bytesuche_sekt_puffer_0(#$fa#$fc#$33#$c0#$8e#$d0#$bc#$00#$7c#$36#$c5) then
                  ausschrift_signatur_dos_kern_name('PC-Tools / Central Point <1>','');

                if bytesuche_sekt_puffer_0(#$fa#$fc#$33#$c0#$8e#$d0#$bc#$00#$7c#$8e#$d8) then
                  begin
                    ausschrift_signatur('PC-Tools / Central Point <2>');
                    teletext(sekt_puffer,$4f-$40,#0,falsch);
                  end;

                (* LW A: B: *)
                if bytesuche_sekt_puffer_0(#$fa#$fc#$33#$c0#$8e#$d0#$bc#$00#$7c#$8e#$c0) then
                  begin

                    (* 8.07 *)
                    if bytesuche(sekt_puffer.d[$0b],#$bd#$78#$00#$c5#$76#$00#$bf#$00#$78) then
                      begin
                        ausschrift_signatur('Tbutil / Thunderbyte AV ['+textz_Diskette^+']');
                        tbavtext;
                        exit;
                      end;

                    case sekt_puffer.d[$b] of
                    $26:
                      begin
                        ausschrift_signatur('Tbutil / Thunderbyte AV ['+textz_Diskette^+']');
                        tbavtext;
                      end;
                    $8e:
                      begin
                        ausschrift_signatur('Tbutil / Thunderbyte AV ['+textz_Diskette^+' unlock]');
                        tbavtext;
                      end;
                    else
                      ausschrift_signatur('Tbutil / Thunderbyte AV ['+textz_Diskette^+'?]');
                      tbavtext;
                    end;
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$fc#$33#$c0#$8e#$d8#$8e#$d0#$bc#$04#$7c#$b8#$ff#$8e) then
                  ausschrift_signatur('Fastboot / Cyberware [2.13] '+textz_Ermittlung_der_BIOS_Einsprungpunkte^);

                if bytesuche_sekt_puffer_0(#$fa#$fc#$33#$c0#$8e#$d0#$bc#$00#$7c#$8c#$c8#$8e#$d8) then
                  begin
                    ausschrift_signatur('IOMEGA ZIP 100 '+textz_ausschrift^);
                    teletext(sekt_puffer,$92-$52,#0,falsch);
                  end;

                if bytesuche_sekt_puffer_0(#$fa#$fc#$8c#$c8#$8e#$d0#$bc#$00#$7c#$8e#$d8#$8e#$c0) then
                  ausschrift_signatur('IOMEGA '+textz_Partitionstabelle^);

                if bytesuche_sekt_puffer_0(#$fa#$fc#$8c#$c8#$8e#$d8#$8e#$c0#$8e#$d0#$bc#$c6#$7b#$8b#$ec#$88#$96#$12#$00
                    +#$bb#$78#$00#$26#$c5#$37#$8d#$be#$00#$00#$26#$89#$3f) then
                  (* imgcpy10a.zip *)
                  ausschrift_signatur_dos_kern_name('RxDOS / Api Software [6.0]','');

                if bytesuche_sekt_puffer_0(#$fa#$fc#$b8#$00#$7a#$33#$db#$8e#$d3#$8b#$e0#$fb#$56#$55#$8b#$e8) then
                  begin
                    ausschrift_signatur('BOOT2C / Douglas Boling');
                    teletext(sekt_puffer,word_z(@sekt_puffer.d[$68-$44])^-$7a00-$44,#$00,falsch);
                  end;

              end;
          end;
        end;

      $fb:
        begin

          if bytesuche_sekt_puffer_0(#$fb#$bd#$00#$7c#$eb#$04'????'#$fc#$33#$db#$8e#$d3#$8b#$e5
             +#$8e#$c3#$26#$c5#$77#$78#$52#$1e#$56#$8b#$fd) then
            (* acronis os selector 5, bootwiz 964b2.sek *)
            ausschrift_signatur_dos_kern_name('PTS DOS 7.0','');

          if bytesuche_sekt_puffer_0(#$fb#$bd#$00#$7c#$66#$bb'????'#$fc#$8e#$d3#$8b#$e5#$8e#$db#$8e#$c3
             +#$52#$32#$e4#$cd#$13#$84#$d2#$79#$2a#$b4#$41#$bb#$aa#$55#$cd#$13#$72#$0f#$81) then
            (* acronis os selector 5, bootwiz 966b2.sek *)
            ausschrift_signatur_dos_kern_name('PTS DOS 7.0','[FAT32]');


          if bytesuche_sekt_puffer_0(#$fb#$33#$c9#$8e#$d1#$bc#$00#$7c#$8b#$ec#$51#$8a#$56#$24#$3a#$d1#$7d) then
            ausschrift_signatur_dos_kern_name('Datalight ROM DOS','[FAT12/16]');

          if bytesuche_sekt_puffer_0(#$fb#$33#$db#$bd#$00#$7c#$8e#$d3#$8b#$e5) then
            begin
              ausschrift_signatur_dos_kern_name('PTS-DOS 7','');
              ausschrift(puffer_zu_zk_l(sekt_puffer.d[$1ac-$73+2],sekt_puffer.d[$1ac-$73-1]-2),beschreibung);
            end;

          if bytesuche_sekt_puffer_0(#$fb#$fc#$33#$db#$bd#$00#$7c#$8e#$d3#$8b#$e5#$8e
              +#$c3#$26#$c5#$77#$78) then
            (* Installationsdiskette, Version 3.11 *)
            ausschrift_signatur_dos_kern_name('PTS BootWizard <1>','');

          if bytesuche_sekt_puffer_0(#$fb#$fc#$33#$db#$bd#$00#$7c#$8e#$d3#$8b#$e5#$8e
              +#$db#$8e#$c3#$52#$66#$ff#$77#$78#$be) then
            (* 3.11, mit INT $13/AH=$41 *)
            ausschrift_signatur_dos_kern_name('PTS BootWizard <2>','');


          if bytesuche_sekt_puffer_0(#$fb#$fc#$0e#$1f#$be'?'#$7c#$b4#$0e#$bb#$07#$00#$ac) then
            begin
              ausschrift_signatur('FIXBOOT / Frisk Software');
              teletext(kopie,sekt_puffer.d[4+1],#$00,falsch);
            end;
        end;

      $fc:
        begin
          if bytesuche_sekt_puffer_0(#$fc#$29#$c0#$8e#$d8#$bd#$00#$7c#$8e#$d0#$8d#$66#$e0#$cd#$13
               +#$b8'??'#$8e#$c0#$89#$ee#$89#$ef#$b9) then (* 2002.04..09? *)
            ausschrift_signatur_dos_kern_name('FreeDos [2-2540]','');


          if bytesuche_sekt_puffer_0(#$fc#$eb) then
            begin
              codeoff_off:=codeoff_off+1+2+sekt_puffer.d[1+1] and $ffff;
              datei_lesen(sekt_tmp_puffer,analyseoff+codeoff_seg*16+codeoff_off,512);
              if bytesuche(sekt_tmp_puffer.d[0],#$33#$c0#$fa#$8e#$d0#$bc#$00#$04#$fb
                 +#$ea'?'#$00#$c0#$07#$0e#$1f#$be#$04#$00#$e8) then
                (* MBR 1.32 *)
                ausschrift_signatur('BootIt Next Generation / TeraByte Unlimited');
            end;

          if bytesuche_sekt_puffer_0(#$fc#$33#$c0#$50#$50#$1f#$8d#$36#$00#$7c#$07#$8d#$3e#$00#$7e#$b9
               +#$00#$01#$f3#$a5#$8d#$06) then
            begin
              (* 97.212 *)
              ausschrift_signatur('FlopBoot / Dennis Bareis');
              teletext(kopie,word_z(@sekt_puffer.d[$5e-$42])^-$7e00,#$00,falsch);
            end;

          if bytesuche_sekt_puffer_0(#$fc#$33#$db#$8e#$d3#$bc#$00#$7c#$8e#$db#$8e#$c3
             +#$8b#$f4#$bf#$00#$7e#$b9#$00#$01#$f3#$a5#$e9#$00#$02#$be'?'#$7e#$e8) then
            begin
              ausschrift_signatur('MCM / ? ¯');
              mcm_anzeige(kopie,sekt_puffer.d[$1a]);
            end;

          if bytesuche_sekt_puffer_0(#$fc#$b8#$c0#$07#$8e#$d0) then
            ausschrift_signatur_dos_kern_name('X-DOS ¯','');

          if bytesuche_sekt_puffer_0(#$fc#$cd#$12#$2d#$3f#$00#$b1#$06#$d3#$e8#$b1#$0c#$d3#$e0#$fa#$8e#$c0#$8e#$d0
              +#$2b#$e4#$fb#$b9#$00#$01#$be#$00#$7c#$8b#$fc#$0e#$1f#$f3) then
            (* imgcpy10a.zip *)
            ausschrift_signatur_dos_kern_name('Digital Research DOS 3.4','');

          if bytesuche_sekt_puffer_0(#$fc#$33#$c0#$8e#$c0#$fa#$8e#$d0#$bc#$00#$7c#$fb#$8a#$96#$fd#$01
              +#$cd#$13#$bd#$78#$00#$8b#$fc) then
          (* floppy,alt?, Variante mit fetgelegtem DL-Register *)
            ausschrift_signatur_dos_kern_name('DR DOS 5 '+textz_Startsektor^,'');

          if bytesuche_sekt_puffer_0(#$fc#$33#$c0#$8e#$c0#$fa#$8e#$d0#$bc#$00#$7c#$fb#$33#$d2#$cd#$13) then
            ausschrift_signatur_dos_kern_name('Novell DOS 7 '+textz_Startsektor^,'');

          if bytesuche_sekt_puffer_0(#$fc#$33#$c0#$8e#$c0#$fa#$8e#$d0#$bc#$00#$7c#$fb#$cd#$13#$bd#$78#$00) then
            (* 7.03 Beta *)
            ausschrift_signatur_dos_kern_name('Caldera DR-DOS 7 '+textz_Startsektor^,'');

          if bytesuche_sekt_puffer_0(#$fc#$33#$c0#$8e#$c0#$fa#$8e#$d0#$bc#$00#$7c#$fb#$8b#$eb#$8c#$9e) then
            ausschrift_signatur_dos_kern_name('IBMBIO.LDR: '+textz_Lader^+' von','/ DR,Novell,Caldera');

          if bytesuche_sekt_puffer_0(#$fc#$8c#$c8#$8e#$d8#$8e#$c0) then
            if sekt_puffer.d[$a-$3]<>$a3 then (* 3C5X9PD.COM *)
              ausschrift_signatur('Novell DOS 7 , +++ '+textz_Startsektor^);

        end;
      end;


    Dec(herstellersuche);
    if not hersteller_gefunden then
      begin

        if echter_startsektor
        or (    bytesuche(kopie.d[$1fe],#$55#$aa)
            and (not bytesuche(sekt_puffer.d[0],'GIF8')) (* GIF *)
            and (not bytesuche(sekt_puffer.d[0],'BM')))   (* BMP *)
         then
          begin
            (* Kemnung fÅr erhaltenswerten Kode fÅr LVM *)
            if bytesuche(kopie.d[$d5],'I13X') then
              ausschrift('I13X - LVM',signatur);

            poly_emulator(poem_modus_sekt);
          end;

        if puffer_pos_suche(sekt_puffer,#$a1#$13#$04,50)<>nicht_gefunden then
          (* "mov ax,[413]" *)
          (* z.B.: PRTSCR.BOO *)
          ausschrift_signatur(textz_Lesezugriff_auf_BIOS_Speichervariable^);

        if (puffer_pos_suche(sekt_puffer,#$a3#$13#$04,80)<>nicht_gefunden)
          (* "mov [413],ax" *)
          (* z.B.: PRTSCR.BOO *)
         or
           (puffer_pos_suche(sekt_puffer,#$ff#$0e#$13#$04,80)<>nicht_gefunden)
          (* "dec word ptr [413]" *)
          (* z.B. AIRCOP *)
         then
          ausschrift(textz_Schreibzugriff_auf_BIOS_Speichervariable^,virus);
      end;
    Inc(herstellersuche);

    (*$EndIf*)
    if zeige_disketteninhalt then
      begin
        if (not hersteller_gefunden) and hersteller_erforderlich then
          ausschrift_nichts_gefunden(signatur);
        Dec(herstellersuche); (* Unbekannten Startsektor als unbekannt bezeichnen! *)
        disketten_abzugsdatei_fat(zylinder,sektoren_je_spur,anzahl_koepfe);
        Inc(herstellersuche);
      end;
  end; (* start_sekt *)

(*$EndIf SEKT_EINSPAREN*)
end.

