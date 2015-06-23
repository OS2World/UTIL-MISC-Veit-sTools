(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_cd;

interface

uses
  typ_var;

function cd_untersuchung(laufwerk:char):boolean;
procedure cd_spur_datei(const sektorgroesse,sektordatenstart:longint);

implementation

uses
  (*$IfDef DPMI32*)
  cdrom,
  (*$EndIf*)
  typ_type,
  typ_eiau,
  typ_dat,
  typ_ausg,
  typ_varx,
  typ_spra,
  typ_for4;

type
  (*cd_puffer_typ =array[0..2047] of char;*)
  str16         =string[16];

procedure interpretiere_cd_puffer(const cd_puffer:cd_puffer_typ);
  procedure cddatum(const d;var res:str16);
    begin
      res:=leer_filter(puffer_zu_zk_l(d,16));
      if Length(res)=Length('JJJJMMTTSSMMSSHH') then
        begin
          (* Insert(',',tmp,15); *)
          Delete(res,15,2);
          Insert('.',res,13);
          Insert('.',res,11);
          Insert(' ',res, 9);
          Insert('.',res, 7);
          Insert('.',res, 5);
        end;
    end;

  var
    datum1,datum2       :str16;

  begin
    if cd_puffer[40]<>' ' then
      ausschrift(textz_cd__Bezeichnung^+leer_filter(puffer_zu_zk_l(cd_puffer[ 40], 32))+'"',beschreibung);

    if cd_puffer[318]<>' ' then
      ausschrift(textz_cd__Herausgeber^+leer_filter(puffer_zu_zk_l(cd_puffer[318],128))+'"',beschreibung);

    if cd_puffer[446]<>' ' then
      ausschrift(textz_cd__Aufzeichnung^+leer_filter(puffer_zu_zk_l(cd_puffer[446],128))+'"',beschreibung)
    else if cd_puffer[$23e]<>' ' then
      (* AOL CD: ADAPTEC *)
      ausschrift(textz_cd__Aufzeichnung^+leer_filter(puffer_zu_zk_l(cd_puffer[$23e],128))+'"',beschreibung);

    (* Datum/Zeit *)
    if cd_puffer[$32d] in ['1','2'] then
      begin
        cddatum(cd_puffer[$32d],datum1);
        exezk:='';
        if cd_puffer[$32d+17] in ['1','2'] then
          begin
            cddatum(cd_puffer[$32d+17],datum2);
            if datum1<>datum2 then
              exezk:='"/"'+datum2;
          end;

        ausschrift(textz_cd__datumzeit^
                  +datum1
                  +exezk
                  +'"',
                  beschreibung);

      end;


    if cd_puffer[$400]>' ' then
      begin
        ausschrift(puffer_zu_zk_e(cd_puffer[$400],#0,32(*?*)),musik_bild);
      end;

  end;

function cd_untersuchung(laufwerk:char):boolean;
  var
    ist_cd              :boolean;
    (*$IfDef DOS*)
    pu_se,pu_of         :word;
    (*$EndIf*)
    cd_puffer           :cd_puffer_typ;
    laufwerk0           :byte;

  function lies_cd(sektor:longint):boolean;
    var
      cd_512_puffer     :puffertyp;
    begin
      lies_cd:=false;
      FillChar(cd_puffer,SizeOf(cd_puffer),$81);
      (*$IfDef OS2*)
      if dos_sektor_lesen(sektor*(2048 div 512),laufwerk0,cd_512_puffer)=0 then
        begin
          Move(cd_512_puffer.d[0],cd_puffer[   0],512);

          fehler:=dos_sektor_lesen(sektor*(2048 div 512)+1,laufwerk0,cd_512_puffer);
          Move(cd_512_puffer.d[0],cd_puffer[ 512],512);

          fehler:=dos_sektor_lesen(sektor*(2048 div 512)+2,laufwerk0,cd_512_puffer);
          Move(cd_512_puffer.d[0],cd_puffer[1024],512);

          fehler:=dos_sektor_lesen(sektor*(2048 div 512)+3,laufwerk0,cd_512_puffer);
          Move(cd_512_puffer.d[0],cd_puffer[1536],512);

          lies_cd:=fehler=0;
        end;
      (*$EndIf OS2*)

      (*$IfDef DPMI32*)
      lies_cd:=(cdrom_read_sector(laufwerk0,sektor,cdrom_sector_type(cd_puffer))=0);
      (*$EndIf DPMI32*)


      if signaturen then
        begin
          Move(cd_puffer[0*512],cd_512_puffer.d,512);
          cd_512_puffer.g:=512;
          signatur_anzeige(textz_CD_Anfangsblock^+'[1/4]',cd_512_puffer);
          Move(cd_puffer[1*512],cd_512_puffer.d,512);
          cd_512_puffer.g:=512;
          signatur_anzeige(textz_CD_Anfangsblock^+'[2/4]',cd_512_puffer);
          Move(cd_puffer[2*512],cd_512_puffer.d,512);
          cd_512_puffer.g:=512;
          signatur_anzeige(textz_CD_Anfangsblock^+'[3/4]',cd_512_puffer);
          Move(cd_puffer[3*512],cd_512_puffer.d,512);
          cd_512_puffer.g:=512;
          signatur_anzeige(textz_CD_Anfangsblock^+'[4/4]',cd_512_puffer);
        end;
    end;

  begin
    ist_cd:=falsch;

    laufwerk:=UpCase(laufwerk);
    if (laufwerk<'A') or (laufwerk>'`') then
      begin
        cd_untersuchung:=ist_cd;
        Exit;
      end;

    laufwerk0:=Ord(laufwerk)-ord('A');

    (*$IfDef DOS*)
    pu_se:=seg(cd_puffer);
    pu_of:=ofs(cd_puffer);
    FillChar(cd_puffer,SizeOf(cd_puffer),$81);
    asm
      mov ax,$1505
      mov cl,laufwerk
      mov ch,0
      sub cl,'A'
      mov dx,0                   (* Sektor Index *)
      mov es,pu_se
      mov bx,pu_of
      push ds                    (* TBNCD ver„ndert DS *)
        push es
          int $2f
        pop es
      pop ds
    end;
    ist_cd:=not ((cd_puffer[0]=#$81) and (cd_puffer[1]=#$81));
    (*$EndIf*)

    (*$IfDef OS2*)
    if ifs_name(laufwerk)='CDFS' then
      if lies_cd($10) then
        ist_cd:=bytesuche(cd_puffer[1],'CD001');
    (*$EndIf*)

    (*$IfDef DPMI32*)
    if cdrom_extenstion_installed then
      if cdrom_is_cd_drive_letter(laufwerk0) then
        if lies_cd($10) then
          ist_cd:=bytesuche(cd_puffer[1],'CD001');
    (*$EndIf*)

    if ist_cd then
      begin
        (*$IfDef OS2*)
        ausschrift_v(textz_cd__eckauf_Laufwerk^+laufwerk+':] [IFS=CDFS]');
        (*$Else*)
        ausschrift_v(textz_cd__eckauf_Laufwerk^+laufwerk+':]');
        (*$EndIf*)



        interpretiere_cd_puffer(cd_puffer);

        lies_cd($11);
        if bytesuche(cd_puffer,#$00'CD001'(*version: #$01 *)) then
          begin
            ausschrift_leerzeile;
            lies_cd(longint_z(@cd_puffer[$47])^);
            cdrom_boot_catalog(0,2048,Addr(cd_puffer));
          end;

      end;
    cd_untersuchung:=ist_cd;
  end;

procedure cd_spur_datei(const sektorgroesse,sektordatenstart:longint);
  var
    cd_puffer:cd_puffer_typ;
    cd_512_puffer:puffertyp;
    o:dateigroessetyp;
    i:word_norm;
  begin
    exezk:='';
    if sektordatenstart>0 then
      begin
        datei_lesen(cd_512_puffer,analyseoff+16*sektorgroesse,512);
        exezk:=', data mode='+str0(cd_512_puffer.d[12+3]);
        if cd_512_puffer.d[12+3]=2 then (* mode2 *)
          (* submode bit 5 *)
          exezk_anhaengen(', form='+str0(((cd_512_puffer.d[12+3+1+2] shr 5) and 1)+1))
      end;
    ausschrift('ISO 9660 image'+exezk+', sector size='+str0(sektorgroesse)+', data begin='+str0(sektordatenstart),packer_dat);


    o:=analyseoff+16*sektorgroesse+sektordatenstart;
    for i:=0 to 3 do
      begin
        Datei_Lesen(cd_512_puffer,o+i*512,512);
        if cd_512_puffer.g<>512 then Exit;
        Move(cd_512_puffer.d,cd_puffer[i*512],512);
      end;

    interpretiere_cd_puffer(cd_puffer);

    if bytesuche(cd_puffer[0],#$01'CD001'#$01) then
      dateisystem_iso9660(sektorgroesse,sektordatenstart); (* typ_for4 *)


    o:=analyseoff+17*sektorgroesse+sektordatenstart;
    datei_lesen(cd_512_puffer,o,512);
    if bytesuche(cd_512_puffer.d[0],#$00'CD001'(*version: #$01 *)) then
      begin
        ausschrift_leerzeile;
        cdrom_boot_catalog(longint_z(@cd_512_puffer.d[$47])^*sektorgroesse+sektordatenstart,sektorgroesse,nil);
      end;
  end;

end.

