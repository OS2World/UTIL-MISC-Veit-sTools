(*$G+,E-,N-,R-,S-*)
(*&Use32+*)
unit luxdatei;
(* V.K. 18.01.1998 *)
(* 2000.12.07 Quelltextversch”nerung, Sprache2, *)
(*            SetFAttr nicht auf offene Dateien anwenden *)

interface

type
  luxus_datei           =
    record
      datei             :file;
      position          :longint;
      laenge            :longint;
      (* offen:boolean; *)
      (* cache:array[0..51] of ... *)
    end;

const
  reaktion_auf_fehler   :(fragen,immer_ignorieren,immer_wiederholen)=fragen;


procedure ld_oeffne   (var ld:luxus_datei;const dateiname:string;const schreiben:boolean);
procedure ld_erzeuge  (var ld:luxus_datei;const dateiname:string);
procedure ld_schliesse(var ld:luxus_datei);
procedure ld_sprung   (var ld:luxus_datei;const o:longint);
function  ld_position (var ld:luxus_datei):longint;
function  ld_laenge   (var ld:luxus_datei):longint;
procedure ld_lies     (var ld:luxus_datei;var p;const l:longint);
procedure ld_schreibe (var ld:luxus_datei;var p;const l:longint);

implementation

uses
  Dos,
  popup,
  tast,
  spr2_aus;

(*$I LUXDAT$$.002*)
(*$I LUXDAT$$.001*)

procedure abbruch(const t:string);
  begin
    Write(t);
    Halt(1);
  end;

procedure esc_test;
  begin
    if frage_ob_taste_vorhanden_erw then
      begin
        hole_taste_erw;
        if taste.ascii=#27 then
          abbruch(textz_Abbruch_durch_den_Benutzer^);
      end;
  end;

procedure ld_oeffne   (var ld:luxus_datei;const dateiname:string;const schreiben:boolean);
  var
    fehler              :word;
  begin
    esc_test;
    with ld do begin
      if schreiben then
        FileMode:=$42
      else
        FileMode:=$40;

      Assign(datei,dateiname);
      (*$I-*)
      if schreiben then
        SetFAttr(datei,0); (* ignorieren *)

      Reset(datei,1);
      (*$i+*)
      fehler:=IOResult;

      if fehler=0 then
        begin
          (*$I-*)
          laenge  :=FileSize(datei);
          position:=0;
          (*$I+*)
          fehler:=IOResult;
        end;

      if fehler<>0 then
        begin
          Write(textz_kann_datei_nicht_oeffen1^,dateiname,textz_kann_datei_nicht_oeffen2^);
          Halt(fehler);
        end;
    end;
  end;

procedure ld_erzeuge  (var ld:luxus_datei;const dateiname:string);
  var
    fehler              :word;
  begin
    esc_test;
    with ld do begin
      FileMode:=$42;
      Assign(datei,dateiname);

      SetFAttr(datei,0); (* ignorieren *)

      (*$I-*)
      Rewrite(datei,1);
      (*$I+*)
      fehler:=IOResult;

      laenge  :=0;
      position:=0;

      if fehler<>0 then
        begin
          Write(textz_kann_datei_nicht_erzeugen1^,dateiname,textz_kann_datei_nicht_erzeugen2^);
          Halt(fehler);
        end;
    end;
  end;

procedure ld_schliesse(var ld:luxus_datei);
  var
    fehler              :word;
  begin
    with ld do
      begin
        (*$I-*)
        Close(datei);
        (*$I+*)
        fehler:=IOResult;
        if fehler<>0 then
          begin
            Write('*LD_SC->');
            RunError(fehler);
          end;
      end;
    esc_test;
  end;

procedure ld_sprung (var ld:luxus_datei;const o:longint);
  var
    fehler              :word;
  begin
    esc_test;
    with ld do
      begin

        if o<0 then
          begin
            Write('*LD_SP(',o,'/0)->');
            RunError(0);
          end;

        if o>laenge then
          begin
            Write('*LD_SP(',o,'/',laenge,')->');
            RunError(0);
          end;

        (*$I-*)
        Seek(datei,o);
        (*$I-*)
        fehler:=IOResult;
        if fehler<>0 then
          begin
            Write('*LD_SP(',o,')->');
            RunError(fehler);
          end;
        ld.position:=o;
      end;
  end;

function  ld_position (var ld:luxus_datei):longint;
  begin
    esc_test;
    ld_position:=ld.position;
  end;

function  ld_laenge   (var ld:luxus_datei):longint;
  begin
    esc_test;
    ld_laenge:=ld.laenge;
  end;

procedure ld_kombi    (var ld:luxus_datei;var p0;l:longint;lesen_oder_schreiben:char);
  var
    p                   :pointer;
    p_r                 :
      packed record
        ofs             :word;
    (*$IFNDEF VirtualPascal*)
        seg             :word;
    (*$ENDIF*)
      end absolute p;

    uebrig,blockgroesse :longint;
    gewuenscht,tat      :word;
    fehler              :word;
    pop_sich            :popup_sicherung_typ;

  begin
    p:=@p0;
    with ld do
      begin

        if lesen_oder_schreiben='L' then
          if position+l>laenge then
            begin
              Write('*LD_LE(',position,'+',l,'/',laenge,')->');
              RunError(0);
            end;

        uebrig:=l;
        (*$IFDEF VirtualPascal*)
        blockgroesse:=uebrig;
        (*$ELSE*)
        with p_r dp
          begin
            Inc(seg,ofs shr 4);
            ofs:=ofs and $f;
          end;
        blockgroesse:=$c000; (* <64K *)
        (*$ENDIF*)

        while uebrig>0 do
          begin
            esc_test;

            if uebrig>blockgroesse then
              gewuenscht:=blockgroesse
            else
              gewuenscht:=uebrig;

            (*$I-*)
            case lesen_oder_schreiben of
              'L':BlockRead (datei,p^,gewuenscht,tat);
              'S':BlockWrite(datei,p^,gewuenscht,tat);
            end;
            (*$I+*)
            fehler:=IOResult;

            if tat=0 then
              begin
                case reaktion_auf_fehler of
                  fragen:
                    begin
                      popup_ein(pop_sich);
                      case lesen_oder_schreiben of
                        'L':write  (textz__Lesefehler_^);
                        'S':write  (textz__Schreibfehler_^);
                      end;
                      if fehler<>0 then Write('(',fehler,')');writeln;
                      writeln;
                      writeln('   '+textz__a_bbrechen^);            (* A/A *)
                      writeln('   '+textz__w_iederholen^);          (* W/R *)
                      writeln('   '+textz__i_gnorieren^);           (* I/I *)
                      writeln('   '+textz__e_wig_probieren^);       (* E/E *)
                      write  ('   '+textz_i_m_mer_ignorieren___^);  (* M/L *)
                      repeat
                        hole_taste_erw;
                        taste.ascii:=upcase(taste.ascii);
                        if taste.ascii='R' then taste.ascii:='W';
                        if taste.ascii='L' then taste.ascii:='M';
                      until taste.ascii in [#27,'A','W','I','E','M'];
                      popup_aus(pop_sich);
                    end;
                  immer_ignorieren:
                    begin
                      esc_test;
                      taste.ascii:='M';
                    end;
                  immer_wiederholen:
                    begin
                      esc_test;
                      taste.ascii:='E';
                    end;
                end;

                if taste.ascii='E' then
                  begin
                    reaktion_auf_fehler:=immer_wiederholen;
                    Write('W');
                  end;

                if taste.ascii='M' then
                  begin
                    reaktion_auf_fehler:=immer_ignorieren;
                    Write('I');
                  end;

                case taste.ascii of
                  #27,'A':abbruch(textz_Abbruch_durch_den_Benutzer^);
                  'W','E':;
                  'I','M':
                      begin
                        tat:=gewuenscht;
                        (*$I-*)
                        Seek(datei,position+tat);
                        (*$I+*)
                        fehler:=IOResult;
                        Break;
                      end;
                end;
              end; (* tat=0 *)


            if tat<>gewuenscht then
              begin
                (*$I-*)
                Seek(datei,position+tat);
                (*$I+*)
                fehler:=IOResult; (* wird ignoriert *)

                blockgroesse:=512; (* in kleineren H„ppchen *)
              end;

            Inc(position,tat);
            Dec(uebrig  ,tat);
            Inc(p_r.ofs ,tat);
            (*$IFNDEF VirtualPascal*)
            Inc(p_r.seg ,p_r.ofs shr 4);
            p_r.ofs:=p_r.ofs and $f;
            (*$ENDIF*)
            if position>laenge then
              laenge:=position;
          end;

      end;
  end;

procedure ld_lies     (var ld:luxus_datei;var p;const l:longint);
  begin
    ld_kombi(ld,p,l,'L');
  end;

procedure ld_schreibe (var ld:luxus_datei;var p;const l:longint);
  begin
    ld_kombi(ld,p,l,'S');
  end;

begin
  setze_sprachzeiger(@sprach_modul,@sprach_start);
end.

