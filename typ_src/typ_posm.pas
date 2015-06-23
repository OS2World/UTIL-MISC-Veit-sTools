(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_posm;

interface

uses
  typ_type;

const
  datentyp_unbekannt    =0;
  datentyp_winzip       =1;
  datentyp_wp_cfg       =2; (* Flash 5 *)
  datentyp_wp_directory =3; (* Virtual PC *)
  datentyp_packexe      =4; (* LX ohne richtigen DOS-Anteil *)
  datentyp_mscf_xor     =5; (* 'MRI'#$01 *)
  datentyp_innotek      =6; (* Dateinamentabelle *)
  datentyp_libindex     =7; (* \vp21\lib.*\*.lib - Namensverzeichnis nach den OBJ-Bl”cken *)
  datentyp_epicinst     =8; (* OMF1.EXE (typ_for5) *)
  datentyp_innotek_pstr_zip =9; (* wie datentyp_innotek,neuer *)
  datentyp_w32run_fc    =10; (* Start des W32RUN-Kodes FC=flat code? *)
  datentyp_flashtek     =11; (* wlink.exe *)

procedure loesche_merkpositionen;
procedure merke_position(const o:dateigroessetyp;const datentyp:word_norm);
procedure bestimme_naechste_einzellaenge(const o:dateigroessetyp;var e:dateigroessetyp;var naechster_datentyp:word_norm);

implementation

const
  anzahl_merkpositionen :word_norm=0;

var
  merkpositionen_tabelle:array[1..(*$IfDef VirtualPascal*)1000(*$Else*)20(*$EndIf*)] of
    record
      posi              :dateigroessetyp;
      datentyp          :word_norm
    end;

procedure loesche_merkpositionen;
  begin
    anzahl_merkpositionen:=0;
  end;

function suche_mpt_index(const o:dateigroessetyp):word;
  var
    i0,i1,i2            :word;
  begin

    if (anzahl_merkpositionen=0)
    or (merkpositionen_tabelle[anzahl_merkpositionen].posi<o)
     then
      begin
        suche_mpt_index:=anzahl_merkpositionen+1;
        Exit;
      end;



    (* der zu ersetzende/gr”áere *)
    i0:=1;
    i2:=anzahl_merkpositionen;

    repeat
      i1:=(i0+i2) shr 1;
      if i1<i0 then i1:=i0;


      if (merkpositionen_tabelle[i1].posi=o)
      or (i1=i2)
       then
        begin
          suche_mpt_index:=i1;
          Exit;
        end;

      if (i1+1=i2)
      and (merkpositionen_tabelle[i1].posi<o)
      and (o<=merkpositionen_tabelle[i2].posi)
       then
        begin
          suche_mpt_index:=i2;
          Exit;
        end;

      if merkpositionen_tabelle[i1].posi<o then
        i0:=i1
      else
        i2:=i1;

    until false;
  end;

procedure merke_position(const o:dateigroessetyp;const datentyp:word_norm);
  var
    i,z                 :word;
  begin
    if o<=0 then Exit;

    if anzahl_merkpositionen=High(merkpositionen_tabelle) then Exit;

    i:=suche_mpt_index(o);
    if (i<=anzahl_merkpositionen) then
      if merkpositionen_tabelle[i].posi=o then
        begin
          if merkpositionen_tabelle[i].datentyp=datentyp_unbekannt then
            merkpositionen_tabelle[i].datentyp:=datentyp;
          Exit;
        end;

    Move(merkpositionen_tabelle[i],
         merkpositionen_tabelle[i+1],
         (anzahl_merkpositionen+1-i)*SizeOf(merkpositionen_tabelle[1]));
    Inc(anzahl_merkpositionen);
    merkpositionen_tabelle[i].posi:=o;
    merkpositionen_tabelle[i].datentyp:=datentyp;
  end;

procedure bestimme_naechste_einzellaenge(const o:dateigroessetyp;var e:dateigroessetyp;var naechster_datentyp:word_norm);
  var
    i                   :word;
  begin
    naechster_datentyp:=datentyp_unbekannt;

    if (o<0) or (e<=0) then Exit;

    i:=suche_mpt_index(o);
    if i<=anzahl_merkpositionen then
      if merkpositionen_tabelle[i].posi=o then
        naechster_datentyp:=merkpositionen_tabelle[i].datentyp;

    i:=suche_mpt_index(o+1);
    if i>anzahl_merkpositionen then Exit;

    if o+e>merkpositionen_tabelle[i].posi then
      e:=merkpositionen_tabelle[i].posi-o;

  end;

end.

