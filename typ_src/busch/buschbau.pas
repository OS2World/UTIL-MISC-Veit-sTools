(*   $I TYP_COMP.PAS*)
(*   $Define Debug*)
(*$i+*)
(*&Use32+*)
(*&AlignRec-*)
(*$D+*)
(*$L+*)
(*$R+*)
unit buschbau; (* 19991114 *)

interface

uses
  typ_type;

function bytesuche(const p;const suchfolge:string):boolean;
procedure ausschrift(const zk_:string;const attr_:aus_attribute);
procedure abspeichern(const dateiname:string);

const
  belege_speicher_fuer_namen    :boolean=false;

implementation

(*uses
  memleaks;*)

(*$IFNDEF VIRTUALPASCAL*)
type
  smallword                     =word;
(*$ENDIF*)

type
  sp_typ_typ                    =(sp_typ_sprungfeld,
                                  sp_typ_aeste,
                                  sp_typ_blatt,
                                  sp_typ_blatt_bueschel);

  sp_struktur_z_z_typ           =^sp_struktur_z_typ;

  sp_struktur_z_typ             =^sp_struktur_typ;

  string_z                      =^string;

  feld_element_typ=
    record
      zweig_zeiger              :sp_struktur_z_typ;
      sig                       :string_z;
      datei_offset              :smallword;
    end;

  feld_bueschel_element_typ=
    record
      sig                       :string_z;
      text                      :string_z;
      attr                      :aus_attribute;
    end;

  sp_struktur_typ=
    record
      case sp_typ:sp_typ_typ of

        sp_typ_sprungfeld:
          (offset_tabelle       :array[0..255] of sp_struktur_z_typ;
           datei_offset_tabelle :array[0..255] of smallword;            );

        sp_typ_aeste:
          (anzahl_zweige        :smallword;
           feld                 :array[1..256] of feld_element_typ      );

        sp_typ_blatt:
          (text                 :string_z;
           attr                 :aus_attribute;                         );

        sp_typ_blatt_bueschel:
          (anzahl_zweige_byte   :byte;
           feld_bueschel        :array[1..100] of feld_bueschel_element_typ);

      end;


const
  erwarte_bytesuche             :boolean=true;

  anker                         :sp_struktur_z_typ=nil;
  eingabesumme                  :longint=0;

  element_zaehler               :longint=0;



var
  arbeit                        :sp_struktur_z_typ;

procedure abbruch(const r:byte;const meldung:string);
  begin
    WriteLn(meldung);
    RunError(r);
  end;


function bytesuche(const p;const suchfolge:string):boolean;

  function vergleich(const k1,k2;const laenge:word):boolean;
    var
      f1:array[1..255] of byte absolute k1;
      f2:array[1..255] of byte absolute k2;
      z:word;
    begin
      vergleich:=false;
      for z:=1 to laenge do
        if f1[z]<>f2[z] then exit;
      vergleich:=true;
    end;

  function baue_ast(var anfang:sp_struktur_z_typ;const folge:string;const posi:word):sp_struktur_z_typ;
    var
      z1,z2,z3          :word;
      neu               :sp_struktur_z_typ;
      teil1,teil2       :string_z;
    begin
      if posi>Length(folge) then
        begin
          {abbruch(199,}WriteLn('Ende der Suchfolge erreicht! ('+folge+')');
          baue_ast:=nil;
          Exit;
        end;

      if anfang=nil then
        begin
          New(anfang);
          FillChar(anfang^,SizeOf(anfang^),0);
          if posi=1 then
            anfang^.sp_typ:=sp_typ_sprungfeld
          else
            anfang^.sp_typ:=sp_typ_aeste;
        end;

      case anfang^.sp_typ of

         sp_typ_sprungfeld:
            begin
              baue_ast:=baue_ast(anfang^.offset_tabelle[Ord(folge[posi])],folge,posi+1);
              Exit;
            end;

          sp_typ_aeste:
            begin
              for z1:=1 to anfang^.anzahl_zweige do
                if anfang^.feld[z1].sig<>nil then
                  if anfang^.feld[z1].sig^[1]=folge[posi] then
                    begin

                      (* bei Konflikt aufspalten *)
                      z2:=0;
                      repeat
                        Inc(z2);
                        if anfang^.feld[z1].sig^[z2]<>folge[posi+z2-1] then
                          begin
                            (* in 2 neue Teile aufbrechen *)

                            (* z3 ist L�nge des 2. Teiles *)
                            z3:=Length(anfang^.feld[z1].sig^)-(z2-1);

                            (* 1. die z2-1 ersten Zeichen *)
                            GetMem(teil1,1+z2-1);
                            teil1^:=Copy(anfang^.feld[z1].sig^,1,z2-1);
                            (* 2. restlichen Zeichen *)
                            GetMem(teil2,1+z3);
                            teil2^:=Copy(anfang^.feld[z1].sig^,z2-1+1,z3);

                            (* alte Folge freigeben *)
                            FreeMem(anfang^.feld[z1].sig,1+Length(anfang^.feld[z1].sig^));

                            (* der neue 1. Teil kommt anstelle des alten ganzen *)
                            anfang^.feld[z1].sig:=teil1;

                            (* neue Verzweigung erstellen *)
                            New(neu);
                            FillChar(neu^,SizeOf(neu^),0);
                            neu^.sp_typ:=sp_typ_aeste;
                            neu^.anzahl_zweige:=1;

                            (* diese Verzweigung geht erstmal nur mit dem 2. Teil zum alten Ziel *)
                            neu^.feld[1].sig         :=teil2;
                            neu^.feld[1].zweig_zeiger:=anfang^.feld[z1].zweig_zeiger;

                            (* dieses neue Zwischenst�ck einbauen *)
                            anfang^.feld[z1].zweig_zeiger:=neu;
                            Break;
                          end;

                        (* wenn das Ende beider Zeichnketten erreicht ist dann
                           gibt es HIER kein Problem *)
                        (* wenn die Suchfolge im Baum zu kurz war muss dieser
                           Ast weiterverfolgt werden *)
                        if  (z2=Length(anfang^.feld[z1].sig^))
                        and (posi+z2-1<=Length(folge))
                         then
                          Break;

                        (* wenn die einzubauende Zeichkette schon verbraucht ist,
                           (aber im Baum noch mehr erwartet wird)
                           bislang aber alles gleich war, ist die einzubauende Zeichkette eine
                           Verallgemeinerung einer schon vorhandenen Zeichenkette *)
                        if (posi+z2-1=Length(folge))
                        and (z2<Length(anfang^.feld[z1].sig^))
                         then
                          begin
                            {abbruch(199,}WriteLn('eine bessere Suchfolge befindet sich schon im Baum!');
                            (*//Break;
                            //baue_ast:=nil;
                            //Exit;*)
                            baue_ast:=nil;
                            Break;
                          end;

                      until false;
                    end;

              (* jetzt muss jeder Zweig der am Anfang richtig ist vollst�ndig
                 richtig sein (er wurde ja an Problemstellen wenn notwendig abgebrochen) *)
              for z1:=1 to anfang^.anzahl_zweige do
                if anfang^.feld[z1].sig<>nil then
                  if vergleich(anfang^.feld[z1].sig^[1],folge[posi],Length(anfang^.feld[z1].sig^)) then
                    begin
                      baue_ast:=baue_ast(anfang^.feld[z1].zweig_zeiger,folge,posi+Length(anfang^.feld[z1].sig^));
                      Exit;
                    end;

              (* es war nichts dabei -> neu erzeugen *)
              (* es ist sicher das bei 256 verschiedenen Pl�ten noch etwas frei ist weil es
                nur 256 verschiedene Werte f�r das erste Byte gibt *)
              Inc(anfang^.anzahl_zweige);
              with anfang^.feld[anfang^.anzahl_zweige] do
                begin
                  (* z2:=L�nge der Suchfolge *)
                  z2:=Length(folge)-(posi-1);
                  GetMem(sig,1+z2);
                  sig^:=Copy(folge,posi,z2);

                  (* Blatt erzeugen *)
                  New(zweig_zeiger);
                  FillChar(zweig_zeiger^,SizeOf(zweig_zeiger^),0);
                  zweig_zeiger^.sp_typ:=sp_typ_blatt;

                  (* Ergebnis ist Zeiger auf das Blatt *)
                  baue_ast:=zweig_zeiger;
                end;
            end;

          sp_typ_blatt:
            begin
              {abbruch(199,}WriteLn('kein Blatt erwartet: "Verbesserung" der Definition von '+anfang^.text^);
              baue_ast:=nil;
            end;

        else
          abbruch(199,'Unbekannter Blocktyp');
        end;


    end;


  begin
    if not erwarte_bytesuche then
      abbruch(180,'bytesuche nicht erwartet ('+suchfolge+')');

    erwarte_bytesuche:=false;

    Inc(eingabesumme,Length(suchfolge)+1);

    arbeit:=baue_ast(anker,suchfolge,1);

    if Assigned(arbeit) then
      bytesuche:=true
    else
      begin
        bytesuche:=false;
        erwarte_bytesuche:=true;
      end;
  end;

procedure ausschrift(const zk_:string;const attr_:aus_attribute);
(*$IfDef Debug*)
  var
    z                   :word;
(*$EndIf Debug*)
  begin
    Inc(element_zaehler);

(*$IfDef Debug*)
    Write(' ',zk_);
    for z:=Length(zk_)+1+1 to 70 do
      Write(' ');
    for z:=1 to 70 do
      Write(^h);
(*$EndIf Debug*)

    if erwarte_bytesuche then
      abbruch(181,'ausschrift nicht erwartet ('+zk_+')');

    Inc(eingabesumme,Length(zk_)+1+SizeOf(attr_));
    (* mov di,$xxxx / push cs / push di / call $xxxx:$xxxx / or al,al / je @l1 *)
    (* mov di,$xxxx / push cs / push di / push $xx / call [$xxxx] *)
{    Inc(eingabesumme,3+1+1+5+2+2+3+1+1+2+4);}

    if (arbeit^.sp_typ<>sp_typ_blatt)
    or (arbeit^.text<>nil)
     then
      abbruch(184,'Mehrdeutige/mehrfache Suchzeichenkette!');

    with arbeit^ do
      begin

        if belege_speicher_fuer_namen then
          begin
            GetMem(text,1+Length(zk_));
            Move(zk_,text^,1+Length(zk_));
          end
        else (* funktioniert nur wenn nicht konstruierte Zeichenketten �bergeben werden *)
          text:=@zk_;

        attr:=attr_;
      end;

    erwarte_bytesuche:=true;
  end;

procedure abspeichern(const dateiname:string);
  var
    d                   :file;

  (**************************************************************)

  procedure sortieren(var baum:sp_struktur_z_typ;const tiefe:longint);
    var
      z1,z2                     :word;
      tmp                       :feld_element_typ;
      neu                       :sp_struktur_z_typ;
    begin
      with baum^ do
        begin
          case sp_typ of
            sp_typ_sprungfeld:
              for z1:=Low(offset_tabelle) to High(offset_tabelle) do
                if offset_tabelle[z1]<>nil then
                  sortieren(offset_tabelle[z1],tiefe+1);

            sp_typ_aeste:
              begin

                for z1:=1 to anzahl_zweige-1 do
                  for z2:=z1+1 to anzahl_zweige do
                    if feld[z1].sig^>feld[z2].sig^ then
                      begin
                        (* tauschen *)
                        tmp     :=baum^.feld[z1];
                        feld[z1]:=baum^.feld[z2];
                        feld[z2]:=tmp;
                      end;

                for z1:=1 to anzahl_zweige do
                  sortieren(feld[z1].zweig_zeiger,tiefe+1);

                (* Optimieren? *)
                if anzahl_zweige<100 then
                  begin
                    z2:=0;
                    for z1:=1 to anzahl_zweige do
                      if feld[z1].zweig_zeiger^.sp_typ=sp_typ_blatt then
                        Inc(z2);

                    if z2=anzahl_zweige then
                      begin
                        (*Write(z2:3);*)
                        New(neu);
                        FillChar(neu^,SizeOf(neu^),0);
                        neu^.sp_typ:=sp_typ_blatt_bueschel;
                        neu^.anzahl_zweige_byte:=anzahl_zweige;
                        for z1:=1 to anzahl_zweige do
                          begin
                            neu^.feld_bueschel[z1].sig :=feld[z1].sig;
                            neu^.feld_bueschel[z1].text:=feld[z1].zweig_zeiger^.text;
                            neu^.feld_bueschel[z1].attr:=feld[z1].zweig_zeiger^.attr;
                            Dispose(feld[z1].zweig_zeiger);
                          end;
                        DisPose(baum);
                        baum:=neu;

                      end;
                  end;

              end;

            sp_typ_blatt:
              ; (* nur 1 Eintrag *)

            sp_typ_blatt_bueschel:
              ; (* ist schon sortiert, wird niemals erreicht *)
          else
            abbruch(199,'Unbekannter Blocktyp');
          end;
        end;


    end;


  (**************************************************************)

  function berechne_datei_platzbedarf(const baum:sp_struktur_z_typ):word;
    var
      z                 :word;
      laenge            :word;
    begin
      with baum^ do
        begin
          laenge:=SizeOf(sp_typ);

          case sp_typ of
            sp_typ_sprungfeld:
              begin
                Inc(laenge,SizeOf(datei_offset_tabelle));
                for z:=0 to 255 do
                  if offset_tabelle[z]<>nil then
                    begin
                      datei_offset_tabelle[z]:=laenge;
                      Inc(laenge,berechne_datei_platzbedarf(offset_tabelle[z]));
                    end;
              end;

            sp_typ_aeste:
              begin
                Inc(laenge,SizeOf(anzahl_zweige));
                for z:=1 to anzahl_zweige do
                  with feld[z] do
                    Inc(laenge,Length(sig^)+1 + SizeOf(datei_offset));

                for z:=1 to anzahl_zweige do
                  with feld[z] do
                    begin
                      datei_offset:=laenge;
                      Inc(laenge,berechne_datei_platzbedarf(zweig_zeiger));
                    end;
              end;

            sp_typ_blatt:
              begin
                Inc(laenge,Length(text^)+1 + SizeOf(attr));
              end;

            sp_typ_blatt_bueschel:
              begin
                Inc(laenge,SizeOf(anzahl_zweige_byte));
                for z:=1 to anzahl_zweige_byte do
                  with feld_bueschel[z] do
                    begin
                      Inc(laenge,1+Length(sig^));
                      Inc(laenge,1+Length(text^));
                      Inc(laenge,SizeOf(attr));
                    end;
              end;
          else
            abbruch(199,'Unbekannter Blocktyp');
          end;
        end;

      berechne_datei_platzbedarf:=laenge;
    end;

  (**************************************************************)

  procedure speichere(const baum:sp_struktur_z_typ);
    var
      z                 :word;
    begin
      with baum^ do
        begin

          BlockWrite(d,sp_typ,SizeOf(sp_typ));

          case sp_typ of
            sp_typ_sprungfeld:
              begin
                BlockWrite(d,datei_offset_tabelle,SizeOf(datei_offset_tabelle));
                for z:=0 to 255 do
                  if offset_tabelle[z]<>nil then
                    speichere(offset_tabelle[z]);
              end;

            sp_typ_aeste:
              begin

                BlockWrite(d,anzahl_zweige,SizeOf(anzahl_zweige));

                for z:=1 to anzahl_zweige do
                  with feld[z] do
                    begin
                      BlockWrite(d,sig^,Length(sig^)+1);
                      BlockWrite(d,datei_offset,SizeOf(datei_offset));
                    end;

                for z:=1 to anzahl_zweige do
                  with feld[z] do
                    begin
                      speichere(zweig_zeiger);
                    end;
              end;

            sp_typ_blatt:
              begin
                BlockWrite(d,text^,Length(text^)+1);
                BlockWrite(d,attr,SizeOf(attr));
              end;

            sp_typ_blatt_bueschel:
              begin
                BlockWrite(d,anzahl_zweige_byte,SizeOf(anzahl_zweige_byte));
                for z:=1 to anzahl_zweige_byte do
                  with feld_bueschel[z] do
                    begin
                      BlockWrite(d,sig^ ,1+Length(sig^));
                      BlockWrite(d,text^,1+Length(text^));
                      BlockWrite(d,attr ,SizeOf(attr));
                    end;
              end;
          else
            abbruch(199,'Unbekannter Blocktyp');
          end;

        end;


    end;

  (**************************************************************)
  procedure freigeben(var baum:sp_struktur_z_typ);
    var
      z                 :word;
    begin
      with baum^ do
        begin

          case sp_typ of
            sp_typ_sprungfeld:
                for z:=0 to 255 do
                  if offset_tabelle[z]<>nil then
                    freigeben(offset_tabelle[z]);

            sp_typ_aeste:
              for z:=1 to anzahl_zweige do
                begin
                  freigeben(feld[z].zweig_zeiger);
                  FreeMem(feld[z].sig,Length(feld[z].sig^));
                end;

            sp_typ_blatt:
              if belege_speicher_fuer_namen then
                FreeMem(baum^.text,Length(baum^.text^));

            sp_typ_blatt_bueschel:
              begin
                for z:=1 to anzahl_zweige_byte do
                  with feld_bueschel[z] do
                    begin
                      FreeMem(sig ,1+Length(sig^));
                      if belege_speicher_fuer_namen then
                        FreeMem(text,1+Length(text^));
                    end;
              end;

          else
            abbruch(199,'Unbekannter Blocktyp');
          end;

          Dispose(baum);
        end;


    end;

  (**************************************************************)

  begin
    Writeln('Eingabe=',eingabesumme,',',element_zaehler);

    Writeln(dateiname,' ');
    if not erwarte_bytesuche then
      abbruch(182,'ausschrift fehlt noch');

    (* Zusammensetzen von kurzen Zweigen (sp_typ_sprungfeld) *)
    (* zu langen speichersparenden Teilen (sp_typ_aeste) *)

    sortieren(anker,0);

    Writeln('Ausgabe=',berechne_datei_platzbedarf(anker));

    Assign(d,dateiname);
    Rewrite(d,1);

    speichere(anker);

    freigeben(anker);
    anker:=nil;

    Close(d);

    erwarte_bytesuche:=true;
    eingabesumme:=0;
    element_zaehler:=0;

  end;

end.

