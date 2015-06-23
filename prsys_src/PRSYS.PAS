program pr_sys;

(*$I+*)
(*$IFDEF VirtualPascal*)
  (*$M 32000*)
  (*$Use32+*)
(*$ELSE*)
  (*$M 8000,200000,200000*)
(*$ENDIF*)

(* 1999.12.07 Veit Kannegieser *)

uses
  prsysspr;

const
  datum='1999.12.07..1999.12.08';

(*$IFNDEF VirtualPascal*)
type
  SmallWord=word;
(*$ENDIF*)

const
  ofs_strategie          =4+2;

type
  smallword_z           =^SmallWord;

  relo_neu_typ          =
    record
      r                 :array[1..32000] of SmallWord;
    end;
  relo_neu_z_typ        =^relo_neu_typ;

  code_puffer_typ       =array[0..65000] of byte;

  prsys_bin_kopf_typ    =
    packed record
      laenge            :SmallWord;
      ofs_ip            :SmallWord;
      ofs_relo_anzahl   :SmallWord;
      ofs_relo_start    :SmallWord;
      code              :array[0..999] of byte;
    end;
  prsys_bin_kopf_z_typ  =^prsys_bin_kopf_typ;

  relo4                 =
    packed record
      o,s               :SmallWord;
    end;

  relo_tab_org_typ      =array[1..16000] of relo4;
  relo_tab_org_z_typ    =^relo_tab_org_typ;

  exe_kopf_typ          =
    packed record
      sig               :array[0..1] of char;
      mod512,
      page512,
      relo_anzahl,
      kopf16groesse,
      minhalde,
      maxhalde,
      _ss,
      _sp,
      pruefsumme,
      _ip,
      _cs,
      relo_position,
      overlaynummer     :smallword;
    end;


(*$IFDEF VirtualPascal*)
(*$OrgName+*)
procedure prsys_bin;external;
(*$L PRSYSB32.OBJ*)
(*$Orgname-*)
(*$ELSE*)
procedure prsys_bin;external;
(*$L PRSYSB16.OBJ*)
(*$ENDIF*)


procedure Fehler(const zk:string);
  begin
    WriteLn;
    WriteLn(zk);
    Halt(1);
  end;

procedure punkt;
  begin
    Write('.');
  end;

var
  d                     :file;
  exe_kopf              :exe_kopf_typ;
  code_puffer           :^code_puffer_typ;
  code_groesse          :longint;
  zu_schreiben          :longint;
  relo_tab_org_z        :relo_tab_org_z_typ;
  z1,z2                 :word;
  relowert              :longint;

begin
  WriteLn('PRSYS * Veit Kannegieser * ',datum);
  if ParamCount<>2 then
    Fehler(textz_hilfe^);

  Assign(d,ParamStr(1));
  FileMode:=$40;
  Reset(d,1);
  BlockRead(d,exe_kopf,SizeOf(exe_kopf));
  Write(FileSize(d),' ');

  punkt;
  with exe_kopf do
    begin
      if (sig<>'MZ') and (sig<>'ZM') then
        Fehler(textz_fehler_keine_exe^);

      code_groesse:=longint(page512)*512-longint(kopf16groesse)*16;
      if mod512<>0 then
        Dec(code_groesse,512-mod512);

      if code_groesse>60000 then
        Fehler(textz_fehler_zu_gross^);

      if relo_anzahl=0 then
        Fehler(textz_fehler_exe2bin^);

      if High(relo_tab_org_z^)<relo_anzahl then
        Fehler(textz_fehler_zu_viele_relo^);

      zu_schreiben:=code_groesse
                   +prsys_bin_kopf_z_typ(@prsys_bin)^.laenge
                   +relo_anzahl*SizeOf(SmallWord);
      if zu_schreiben>60000 then
        Fehler(textz_fehler_ergebnis_zu_gross^);


      (* CODE *)
      GetMem(code_puffer,zu_schreiben);
      Seek(d,longint(kopf16groesse)*16);
      BlockRead(d,code_puffer^,code_groesse);
      punkt;

      (* PRSYS_BIN *)
      with prsys_bin_kopf_z_typ(@prsys_bin)^ do
        begin
          Move(code,code_puffer^[code_groesse],laenge);
          (* IP/Strategie*)
          smallword_z(@code_puffer^[code_groesse+ofs_ip])^
            :=smallword_z(@code_puffer^[ofs_strategie])^-(code_groesse+ofs_ip-1+3);
          smallword_z(@code_puffer^[ofs_strategie])^
            :=code_groesse;
          (* Relokationen-Z„hler *)
          smallword_z(@code_puffer^[code_groesse+ofs_relo_anzahl])^:=relo_anzahl;
          (* Relokation-Datenbereich *)
          smallword_z(@code_puffer^[code_groesse+ofs_relo_start])^:=code_groesse+laenge;

          Inc(code_groesse,laenge);
        end;

      New(relo_tab_org_z);
      Seek(d,relo_position);
      BlockRead(d,relo_tab_org_z^,SizeOf(relo_tab_org_z^[1])*relo_anzahl);
      Close(d);
      punkt;

      (* RELO 4->2 *)
      with relo_neu_z_typ(@code_puffer^[code_groesse])^ do
        for z1:=1 to relo_anzahl do
          begin
            relowert:=longint(relo_tab_org_z^[z1].s)*16+relo_tab_org_z^[z1].o;
            if (relowert<Low(code_puffer^)) or (High(code_puffer^)-1<relowert) then
              Fehler(textz_fehler_relo_ausserhalb_programmbereich^);

            r[z1]:=relowert;
          end;

      Dispose(relo_tab_org_z);
      punkt;

      (* Sortieren .. *)
      with relo_neu_z_typ(@code_puffer^[code_groesse])^ do
        for z1:=1 to relo_anzahl-1 do
          for z2:=z1 to relo_anzahl do
            if r[z1]>r[z2] then
              begin
                relowert:=r[z1];
                r[z1]   :=r[z2];
                r[z2]   :=relowert;
              end;

      (* kompimierbarer machen *)
      with relo_neu_z_typ(@code_puffer^[code_groesse])^ do
        for z1:=relo_anzahl downto 2 do
          Dec(r[z1],r[z1-1]+4);

      Inc(code_groesse,relo_anzahl*SizeOf(SmallWord));
      punkt;

      Assign(d,ParamStr(2));
      FileMode:=$42;
      Rewrite(d,1);
      BlockWrite(d,code_puffer^,code_groesse);
      Close(d);
      FreeMem(code_puffer,zu_schreiben);
      punkt;

    end;

  WriteLn(' -> ',code_groesse);
end.
