(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

(*  $D-*)

(* $Define ANZEIGE_LAENGE_EINGEPACKT*)
unit typ_for0;

interface

uses
  typ_type;

var
  (* datumzeit          :longint *)

  laenge_eingepackt64,
  laenge_ausgepackt64   :dateigroessetyp;

  laenge_eingepackt     :longint absolute laenge_eingepackt64;
  laenge_ausgepackt     :longint absolute laenge_ausgepackt64;

  (*$IfDef ANZEIGE_LAENGE_EINGEPACKT*),laenge_eingepackt_zk(*$EndIf*)
  laenge_ausgepackt_zk  :string[11+3];

  verhaeltnis           :dateigroessetyp;
  (* zeit_zk:string[length('JJJJ.MM.TT, SS.MM.SS  ')]; *)
  verhaeltnis_zk        :string[6+1];

  archiv_summe_eingepackt_unbekannt,
  archiv_summe_ausgepackt_unbekannt
                        :boolean;

  form_puffer           :puffertyp;

const
  archiv_anzeige_ohne_prozent:boolean=false;

const
  archiv_summe_eingepackt                 :dateigroessetyp      =0;
  archiv_summe_ausgepackt                 :dateigroessetyp      =0;
  archiv_summen_dateien                   :longint              =0;
  gesamt_archiv_summe_eingepackt_unbekannt:boolean              =falsch;
  gesamt_archiv_summe_ausgepackt_unbekannt:boolean              =falsch;
  gesamt_archiv_summe_eingepackt          :dateigroessetyp      =0;
  gesamt_archiv_summe_ausgepackt          :dateigroessetyp      =0;
  gesamt_archiv_summen_dateien            :longint              =0;
  gesamt_archiv_anzahl                    :longint              =0;


procedure archiv_start_leise;
procedure archiv_start_halb;
procedure archiv_start;
procedure archiv_datei;
procedure archiv_datei64;
procedure archiv_summe_leise;
procedure archiv_summe;
procedure gesamt_archiv_summe;
procedure archiv_datei_ausschrift(const dateiname:string);
procedure archiv_datei_ausschrift_verzeichnis(const verzeichnisname:string);
procedure archiv_datei_ausschrift_label(const volumelabel:string);
procedure archiv_datei_ausschrift_kapitel(const kapitel:string);
procedure exezk_leerzeichen_erweiterung(const wunschlaenge:byte);
procedure exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_grenze(const grenz_laenge:byte);
procedure exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(const rand:word_norm);
procedure exezk_leerzeichen_erweiterung_wie_letzte_zeile;
procedure archiv_summe_wenn_noetig;

implementation

uses
  typ_ausg,
  typ_varx,
  typ_var,
  typ_spra;

var
  leerzeichenereiterung_wert_der_letzten_zeile:word_norm;

procedure archiv_start_leise;
  begin
    Inc(gesamt_archiv_anzahl);
    archiv_summe_eingepackt:=0;
    archiv_summe_ausgepackt:=0;
    archiv_summen_dateien  :=0;
    archiv_summe_eingepackt_unbekannt:=falsch;
    archiv_summe_ausgepackt_unbekannt:=falsch;
    (* datumzeit:=-1; *)
    leerzeichenereiterung_wert_der_letzten_zeile:=8+1+3 +3;
    archiv_anzeige_ohne_prozent:=false;
  end;

procedure archiv_start_halb;
  begin
    ausschrift_x(textz_groesse_prozent_name^,packer_dat,absatz);
    archiv_start_leise;
  end;

procedure archiv_start;
  begin
    ausschrift_x(textz_groesse_prozent_name^,packer_dat,absatz);
    ausschrift_x('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',packer_dat,absatz);
    archiv_start_leise;
  end;

function verhaeltnis_zu_zk3(verhaeltnis:dateigroessetyp):string;
  var
    skale               :word_norm;
    skalef              :longint;
    {$IfNDef VirtualPascal}
    result              :string;
    {$EndIf}
  begin
    if verhaeltnis<0 then
      Result:='  ?'
    else
    (*--if verhaeltnis<=999 then--*)
    if verhaeltnis<=High(Longint) then
      {$IfDef dateigroessetyp_comp}
      Result:=str_(comp_rec(verhaeltnis).l0,3)
      {$Else}
      Result:=str_(verhaeltnis,3)
      {$EndIf}
    else
    if verhaeltnis<=High(Longint){<9E9} then
      begin
        skale:=0;
        skalef:=1;
        while verhaeltnis>9*skalef do
          begin
            skalef:=skalef*10;
            Inc(skale);
          end;
        Result:=str_(
          {$IfDef dateigroessetyp_comp}
          comp_rec(verhaeltnis).l0 div skalef
          {$Else}
          verhaeltnis div skalef
          {$EndIf}
               ,1)+'E'+str_(skale,1);
      end
    else
      Result:='  ?';

    {$IfNDef VirtualPascal}
    verhaeltnis_zu_zk3:=result;
    {$EndIf}
  end;

procedure archiv_datei;
  begin
    laenge_eingepackt64:=laenge_eingepackt;
    laenge_ausgepackt64:=laenge_ausgepackt;
    archiv_datei64;
  end;

procedure archiv_datei64;
(* var
    dt:datetime; *)
  begin
(*  if datumzeit=-1 then
      zeit_zk:=''
    else
      if datumzeit=0 then
        zeit_zk:='????'
      else
        begin
          unpacktime(datumzeit,dt);
          zeit_zk:=str(dt.day,2)
                  +'.' +str(dt.month,2)
                  +'.' +str(dt.year,4)
                  +', '+str(dt.hour,2)
                  +'.' +str(dt.min,2)
                  +'.' +str(dt.sec,2)
                  +'  ';
        end; *)

    archiv_summe_eingepackt_unbekannt:=archiv_summe_eingepackt_unbekannt or (laenge_eingepackt64=-1);
    archiv_summe_ausgepackt_unbekannt:=archiv_summe_ausgepackt_unbekannt or (laenge_ausgepackt64=-1);
    if (laenge_eingepackt64=-1) or (laenge_ausgepackt64=-1)
     then
       begin
         verhaeltnis:=0;
         verhaeltnis_zk:='   ?'+'  ';
       end
    else
      begin
        verhaeltnis:=prozent(laenge_eingepackt64,laenge_ausgepackt64);
        verhaeltnis_zk:=' '+verhaeltnis_zu_zk3(verhaeltnis)+'  ';
      end;

    if archiv_anzeige_ohne_prozent then
      verhaeltnis_zk:='    '+'  ';

    if laenge_ausgepackt64=-1 then
      laenge_ausgepackt_zk:='          ?'
    else
      (*$IfDef dateigroessetyp_comp*)
      laenge_ausgepackt_zk:=comp_strx(laenge_ausgepackt64,11);
      (*$Else dateigroessetyp_comp*)
      laenge_ausgepackt_zk:=strx(laenge_ausgepackt64,11);
      (*$EndIf dateigroessetyp_comp*)

    (*$IfDef ANZEIGE_LAENGE_EINGEPACKT*)
    if laenge_eingepackt64=-1 then
      laenge_eingepackt_zk:='          ?'
    else
      laenge_eingepackt_zk:=strx(laenge_eingepackt64,11);
    (*$EndIf*)

    (*$IfDef dateigroessetyp_comp*)
    archiv_summe_eingepackt:=archiv_summe_eingepackt+laenge_eingepackt64;
    archiv_summe_ausgepackt:=archiv_summe_ausgepackt+laenge_ausgepackt64;
    archiv_summen_dateien:=archiv_summen_dateien+1;
    (*$Else*)
    Inc(archiv_summe_eingepackt,laenge_eingepackt64);
    Inc(archiv_summe_ausgepackt,laenge_ausgepackt64);
    Inc(archiv_summen_dateien);
    (*$EndIf*)
  end;

procedure archiv_summe_leise;
  begin
    Inc(gesamt_archiv_summen_dateien,archiv_summen_dateien);
    if archiv_summe_ausgepackt_unbekannt then
      gesamt_archiv_summe_ausgepackt_unbekannt:=true
    else
      begin
        (*$IfDef dateigroessetyp_comp*)
        gesamt_archiv_summe_ausgepackt:=gesamt_archiv_summe_ausgepackt+archiv_summe_ausgepackt;
        (*$Else*)
        Inc(gesamt_archiv_summe_ausgepackt,archiv_summe_ausgepackt);
        (*$EndIf*)
        if archiv_summe_eingepackt_unbekannt then
          gesamt_archiv_summe_eingepackt_unbekannt:=true
        else
          (*$IfDef dateigroessetyp_comp*)
          gesamt_archiv_summe_eingepackt:=gesamt_archiv_summe_eingepackt+archiv_summe_eingepackt;
          (*$Else*)
          Inc(gesamt_archiv_summe_eingepackt,archiv_summe_eingepackt);
          (*$EndIf*)
      end;

    (* zur Erkennung, ob die šberschrift schon ausgegeben wurde *)
    archiv_summe_eingepackt:=0;
    archiv_summe_ausgepackt:=0;
    archiv_summen_dateien  :=0;
  end;

procedure archiv_summe;
  var
    summe:string;
  begin

    ausschrift_x('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',packer_dat,absatz);

    if archiv_summe_ausgepackt_unbekannt then
      summe:='          ?'+'   ?'
    else
      begin
        (*$IfDef dateigroessetyp_comp*)
        summe:=comp_strx(archiv_summe_ausgepackt,11);
        (*$Else*)
        summe:=strx(archiv_summe_ausgepackt,11);
        (*$EndIf*)
        if archiv_summe_eingepackt_unbekannt then
          summe:=summe+'   ?'
        else
          begin
            verhaeltnis:=prozent(archiv_summe_eingepackt,archiv_summe_ausgepackt);
            summe:=summe+' '+verhaeltnis_zu_zk3(verhaeltnis);
          end
      end;

    ausschrift_x(summe+'  '+strx(archiv_summen_dateien,0)+textz_datei_klammerauf_en_klammerzu^,packer_dat,absatz);

    archiv_summe_leise;
  end;

procedure gesamt_archiv_summe;
  var
    summe:string;
  begin
    if (not langformat) or (gesamt_archiv_anzahl<2) then
      exit;

    if gesamt_archiv_summe_ausgepackt_unbekannt then
      summe:='          ?'+'   ?'
    else
      begin
        (*$IfDef dateigroessetyp_comp*)
        summe:=comp_strx(gesamt_archiv_summe_ausgepackt,11);
        (*$Else*)
        summe:=strx(gesamt_archiv_summe_ausgepackt,11);
        (*$EndIf*)
        if gesamt_archiv_summe_eingepackt_unbekannt then
          summe:=summe+'   ?'
        else
          begin
            verhaeltnis:=prozent(gesamt_archiv_summe_eingepackt,gesamt_archiv_summe_ausgepackt);
            summe:=summe+' '+verhaeltnis_zu_zk3(verhaeltnis);
          end
      end;

    ausschrift_x('',packer_dat,leer);
    ausschrift_x(textz_Summe_prozent^+strx(gesamt_archiv_anzahl,0)+textz_archiv_klammerauf_e_klammerzu^,packer_dat,anstrich);
    ausschrift_x('ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ',packer_dat,leer);
    ausschrift_x(summe+'  '+strx(gesamt_archiv_summen_dateien,0)+textz_datei_klammerauf_en_klammerzu^,packer_dat,leer);

  end;

procedure archiv_datei_ausschrift(const dateiname:string);
  begin
    (*$IfDef ANZEIGE_LAENGE_EINGEPACKT*)
    ausschrift_x(laenge_ausgepackt_zk+laenge_eingepackt_zk+verhaeltnis_zk+dateiname,packer_dat,absatz);
    (*$Else*)
    ausschrift_x(laenge_ausgepackt_zk                     +verhaeltnis_zk+dateiname,packer_dat,absatz);
    (*$EndIf*)
  end;

procedure archiv_datei_ausschrift_verzeichnis(const verzeichnisname:string);
  begin
    (*$IfDef ANZEIGE_LAENGE_EINGEPACKT*)
    ausschrift_x(textz_verzeichnis11^+'          -'+'   -'+'  '+verzeichnisname,packer_dat,absatz);
    (*$Else*)
    ausschrift_x(textz_verzeichnis11^              +'   -'+'  '+verzeichnisname,packer_dat,absatz);
    (*$EndIf*)
  end;

procedure archiv_datei_ausschrift_label(const volumelabel:string);
  begin
    (*$IfDef ANZEIGE_LAENGE_EINGEPACKT*)
    ausschrift_x(textz_form__volumelabel11^+'          -'+'   -'+'  '+volumelabel,packer_dat,absatz);
    (*$Else*)
    ausschrift_x(textz_form__volumelabel11^              +'   -'+'  '+volumelabel,packer_dat,absatz);
    (*$EndIf*)
  end;

procedure archiv_datei_ausschrift_kapitel(const kapitel:string);
  begin
    (*$IfDef ANZEIGE_LAENGE_EINGEPACKT*)
    ausschrift_x(textz_form__kapitel11^+'          -'+'   -'+'  '+kapitel,packer_dat,absatz);
    (*$Else*)
    ausschrift_x(textz_form__kapitel11^              +'   -'+'  '+kapitel,packer_dat,absatz);
    (*$EndIf*)
  end;


procedure exezk_leerzeichen_erweiterung(const wunschlaenge:byte);
  begin
    leerzeichenerweiterung(exezk,wunschlaenge);
  end;

procedure exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_grenze(const grenz_laenge:byte);
  begin
    if (leerzeichenereiterung_wert_der_letzten_zeile>grenz_laenge)
    and (grenz_laenge>0)
     then
      leerzeichenereiterung_wert_der_letzten_zeile:=grenz_laenge;

    if leerzeichenereiterung_wert_der_letzten_zeile<Length(exezk) then
      leerzeichenereiterung_wert_der_letzten_zeile:=Length(exezk)
    else
      leerzeichenerweiterung(exezk,leerzeichenereiterung_wert_der_letzten_zeile);
  end;

procedure exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(const rand:word_norm);
  begin
    exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_grenze(80{}-20-rand);
  end;

procedure exezk_leerzeichen_erweiterung_wie_letzte_zeile;
  begin
    exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_grenze(255);
  end;

procedure archiv_summe_wenn_noetig;
  begin
    if archiv_summen_dateien<>0 then
      archiv_summe;
  end;

end.

