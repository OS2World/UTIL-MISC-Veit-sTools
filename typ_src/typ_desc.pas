(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_desc;

interface

function suche_index(const pfad:string):boolean;
procedure verwerte_index(const pfad,dateiname_gross,erweiterung_gross:string);
procedure vergiss_index;

implementation

uses
  Dos,                  (* Find*      *)
  typ_type,             (* wahr       *)
  typ_eiau,             (* suchmaske  *)
  typ_var,              (* gross      *)
  typ_varx,             (* datei      *)
  typ_ausg;             (* ausschrift *)

const
  index_gefunden        :boolean=false;
  index_tabelle:
    array[1..12] of
      record
        dateiname       :string[8+1+3];
        existenz        :boolean;
      end=
    ((dateiname:'DESCRIPT.ION';existenz:falsch), (*  1 *)
     (dateiname:'FILES.BBS'   ;existenz:falsch), (*  2 *)
     (dateiname:'INDEX'       ;existenz:falsch), (*  3 *)
     (dateiname:'0INDEX.TXT'  ;existenz:falsch), (*  4 *)
     (dateiname:'00INDEX.TXT' ;existenz:falsch), (*  5 *)
     (dateiname:'0_INDEX.TXT' ;existenz:falsch), (*  6 *)
     (dateiname:'00_INDEX.TXT';existenz:falsch), (*  7 *)
     (dateiname:'0INDEX'      ;existenz:falsch), (*  8 *)
     (dateiname:'00INDEX'     ;existenz:falsch), (*  9 *)
     (dateiname:'0_INDEX'     ;existenz:falsch), (* 10 *)
     (dateiname:'00_INDEX'    ;existenz:falsch), (* 11 *)
     (dateiname:'00_FILES'    ;existenz:falsch));(* 12 *)

  eintrag_DESCRIPT_ION  =1;
  eintrag_FILES_BBS     =2;
  eintrag_INDEX         =3;


function suche_index(const pfad:string):boolean;
  var
    sur                 :searchrec;
    za                  :word_norm;
  begin
    vergiss_index;

    FindFirst(pfad+'0*.*',suchmaske_datei,sur);
    while Dos.DosError=0 do
      begin
        (*$IfDef OS2*)
        sur.name:=gross(sur.name);
        (*$EndIf*)
        if (2<sur.size) and (sur.size<2000*40) then
          for za:=Low(index_tabelle) to High(index_tabelle) do
            if sur.name=index_tabelle[za].dateiname then
              begin
                index_tabelle[za].existenz:=wahr;
                index_gefunden:=wahr;
              end;
        FindNext(sur);
      end;
    (*$IfDef VirtualPascal*)
    FindClose(sur);
    (*$EndIf*)

    FindFirst(pfad+'DESCRIPT.ION',suchmaske_datei,sur);
    if (Dos.DosError=0) and (2<sur.size) and (sur.size<2000*40) then
      begin
        index_tabelle[eintrag_DESCRIPT_ION].existenz:=wahr;
        index_gefunden:=wahr;
      end;
    (*$IfDef VirtualPascal*)
    FindClose(sur);
    (*$EndIf*)

    FindFirst(pfad+'INDEX',suchmaske_datei,sur);
    if (Dos.DosError=0) and (2<sur.size) and (sur.size<2000*40) then
      begin
        index_tabelle[eintrag_INDEX].existenz:=wahr;
        index_gefunden:=wahr;
      end;
    (*$IfDef VirtualPascal*)
    FindClose(sur);
    (*$EndIf*)


    FindFirst(pfad+'FILES.BBS',suchmaske_datei,sur);
    if (Dos.DosError=0) and (2<sur.size) and (sur.size<2000*40) then
      begin
        index_tabelle[eintrag_FILES_BBS].existenz:=wahr;
        index_gefunden:=wahr;
      end;
    (*$IfDef VirtualPascal*)
    FindClose(sur);
    (*$EndIf*)

    suche_index:=index_gefunden;
  end;

procedure verwerte_index(const pfad,dateiname_gross,erweiterung_gross:string);
  var
    za                  :word_norm;
    exezk_gross         :string;
  begin
    if not index_gefunden then Exit;

    for za:=Low(index_tabelle) to High(index_tabelle) do
      if index_tabelle[za].existenz then
        begin
          Assign(datei,pfad+index_tabelle[za].dateiname);
          datei_oeffnen;

          while textdatei_offen do
            begin
              text_lesen(exezk);
              tabexpand(exezk);
              while (exezk<>'') and (exezk[1]=' ') do
                Delete(exezk,1,1);

              if exezk='' then Continue;

              exezk_gross:=gross(exezk);

              if (exezk_gross[1]='"') (* Dateinamen mit Leerzeichen, 4OS2 *)
              and (Pos(dateiname_gross+erweiterung_gross+'"',exezk_gross)=2) then
                exezk:=Copy(exezk,Length(dateiname_gross)+Length(erweiterung_gross)+3,80)

              else
              if Pos(dateiname_gross+erweiterung_gross+' ',exezk_gross)=1 then
                exezk:=Copy(exezk,Length(dateiname_gross)+Length(erweiterung_gross)+1,80)

              else
              if Pos(Copy(dateiname_gross+'        ',1,8)+' '+Copy(erweiterung_gross,2,3)+' ',exezk_gross)=1 then
                exezk:=Copy(exezk,12+1,80)

              else
                exezk:='';

              (* QPV und CPI400B2.EXE / Mattias Paul erzeugen zus„tzliche Eintr„ge *)
              if Pos(#4,exezk)>0 then
                exezk[0]:=Chr(Pos(#4,exezk)-1);

              while (exezk<>'') and (exezk[1] in [' ',#9]) do
                Delete(exezk,1,1);

              if exezk<>'' then
                begin
                  ausschrift(exezk,beschreibung);
                  Break;
                end;
            end;

          datei_schliessen;
        end;
  end;

procedure vergiss_index;
  var
    za:word_norm;
  begin
    for za:=Low(index_tabelle) to High(index_tabelle) do
      index_tabelle[za].existenz:=falsch;

    index_gefunden:=false;
  end;

end.
