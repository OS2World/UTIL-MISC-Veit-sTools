(*$I TYP_COMP.PAS*)

unit typ_spru;

interface

uses
  typ_type;

procedure trace(var tracepuffer:puffertyp);

implementation

uses
  typ_eiau,
  typ_ausg,
  typ_varx,
  typ_spra,
  typ_var;

procedure trace(var tracepuffer:puffertyp);
  var
    gesprungen                  :boolean;
    hersteller_gefunden_org     :boolean;
    anzahl_spruenge             :word_norm;

  type
    code_nah                    =
      packed record
        op                      :byte;
        off                     :shortint;
      end;

    code_nah_386                =
      record
        op1                     :byte;
        op2                     :byte;
        off                     :integer;
      end;

    code_normal                 =
      record
        op                      :byte;
        off                     :word;
      end;

    code_weit                   =
      record
        op                      :byte;
        off                     :word;
        seg                     :word;
      end;

    code_weit_zusammengesetzt   =
      record
        push_cs                 :byte;
        op                      :byte;
        off                     :word;
      end;

  begin
    hersteller_gefunden_org:=hersteller_gefunden;
    anzahl_spruenge:=0;

    repeat
      Inc(anzahl_spruenge);

      if anzahl_spruenge>10 then
        begin
          ausschrift(textz_spru__Sprungverschachtelung_zu_gross_oder_Endlosschleife^,dat_fehler);
          tracepuffer.d[0]:=0;
        end;

      gesprungen:=falsch;

      with tracepuffer do

        case d[$0] of
          $0e: (* AddCode *)
            if d[$1]=$e8 then
              begin
                if signaturen then ausschrift('PUSH CS; CALL XXXX',signatur);
                Inc(codeoff_off,1+1+2+longint(word_z(@d[1+1])^));
                codeoff_off:=codeoff_off and $FFFF;
                gesprungen:=wahr;
              end;
    (* nicht benutzten: doug (exe)
          $0f:
            if code_nah_386.op2 in [$80..$8f] then
              begin
                if signaturen then ausschrift('bedingter rel. Sprung [80386+]',signatur);
                inc(codeoff_off,code_nah_386.off+4);
                codeoff_off:=codeoff_off;
                gesprungen:=wahr;
              end;
          $70..$7f:
            begin
              if signaturen then ausschrift('bedingter rel. kurzer Sprung',signatur);
              inc(codeoff_off,longint(code_nah.off+2));
              codeoff_off:=codeoff_off and $FFFF;
              gesprungen:=wahr;
            end; *)

          $90:
            begin
              (* DEEPCRYPT *)
              if tracepuffer.d[$1]=$e9 then
                begin
                  if signaturen then ausschrift('NOP ; JMP XXXX',signatur);
                  codeoff_off:=word(codeoff_off+1+word_z(@tracepuffer.d[$2])^+3);
                  gesprungen:=wahr;
                end;
            end;

          $b8:  (* MOV AX,XXXX *) (* bei DS-CRP *)
            begin
              if bytesuche(tracepuffer.d[3],#$50#$c3) then
                begin
                  if signaturen then ausschrift('MOV AX,XXXX ; PUSH AX ; RET',signatur);
                  codeoff_off:=word_z(@d[$1])^;
                  gesprungen:=wahr;
                end;
              if bytesuche(tracepuffer.d[3],#$ff#$e0) then
                begin
                  if signaturen then ausschrift('MOV AX,XXXX ; JMP AX',signatur);
                  codeoff_off:=word_z(@d[$1])^;
                  gesprungen:=wahr;
                end;
            end;

          $b9:  (* MOV CX,XXXX *)
            begin
              if bytesuche(tracepuffer.d[3],#$51#$c3) then
                begin
                  if signaturen then ausschrift('MOV CX,XXXX ; PUSH CX ; RET',signatur);
                  codeoff_off:=word_z(@d[$1])^;
                  gesprungen:=wahr;
                end;
              if bytesuche(d[3],#$ff#$e1) then
                begin
                  if signaturen then ausschrift('MOV CX,XXXX ; JMP CX',signatur);
                  codeoff_off:=word_z(@d[$1])^;
                  gesprungen:=wahr;
                end;
            end;

          $ba:  (* MOV DX,XXXX *)
            begin
              if bytesuche(d[3],#$52#$c3) then
                begin
                  if signaturen then ausschrift('MOV DX,XXXX ; PUSH DX ; RET',signatur);
                  codeoff_off:=word_z(@d[$1])^;
                  gesprungen:=wahr;
                end;
              if bytesuche(d[3],#$ff#$e2) then
                begin
                  if signaturen then ausschrift('MOV DX,XXXX ; JMP DX',signatur);
                  codeoff_off:=word_z(@d[$1])^;
                  gesprungen:=wahr;
                end;
            end;

          $bb:  (* MOV BX,XXXX *)
            begin
              if bytesuche(d[3],#$53#$c3) then
                begin
                  if signaturen then ausschrift('MOV BX,XXXX ; PUSH BX ; RET',signatur);
                  codeoff_off:=word_z(@d[$1])^;
                  gesprungen:=wahr;
                end;
              if bytesuche(d[3],#$ff#$e3) then
                begin
                  if signaturen then ausschrift('MOV BX,XXXX ; JMP BX',signatur);
                  codeoff_off:=word_z(@d[$1])^;
                  gesprungen:=wahr;
                end;
            end;

          $e9,$e8:(* JMP XXXX / CALL XXXX *)
            begin
              if signaturen then
                if d[$0]=$e9
                  then ausschrift(textz_spru__rel_Sprung^,signatur)
                  else ausschrift(textz_spru__rel_Ruf^   ,signatur);

              if d[$0]=$e8 then (* Stackinhalt fr Textanzeiger merken *)
                (*$IfDef dateigroessetyp_comp*)
                stack_inhalt:=Round(codeoff_off+3);
                (*$Else*)
                stack_inhalt:=codeoff_off+3;
                (*$EndIf*)

              Inc(codeoff_off,1+2+longint(integer_z(@d[1])^));
              codeoff_off:=codeoff_off and $FFFF;
              gesprungen:=wahr;
            end;

          $eb:(* JMPS XX *)
            begin
              if signaturen then ausschrift(textz_spru__rel_kurzer_Sprung^,signatur);
              Inc(codeoff_off,1+1+longint(shortint(d[1])));
              codeoff_off:=codeoff_off and $FFFF;
              gesprungen:=wahr;
            end;


          $9A,$EA:(* CALL XXXX:XXXX / JMP XXXX:XXXX *)
            begin
              if exe then
                begin
                  if signaturen then
                    if d[$0]=$9A
                      then ausschrift(textz_spru__weiter_Ruf^   ,signatur)
                      else ausschrift(textz_spru__weiter_Sprung^,signatur);
                  (* Annahme : Adresse wird angepaát *)
                  codeoff_off:=word_z(@d[1])^;
                  codeoff_seg:=longint(exe_kopf.kopfgroesse)+longint(word_z(@d[3])^);
                  if word_z(@d[3])^>=$FFF0 then
                    Dec(codeoff_seg,$10000);
                  gesprungen:=wahr;
                end
              else
                begin
                  if (signaturen) or (quelle.sorte<>q_datei) or hersteller_erforderlich then
                    if d[$0]=$9A then
                      ausschrift(textz_spru__absoluter_Sprung_nach^
                        +hex_word(word_z(@d[3])^)+':'+hex_word(word_z(@d[1])^)+'!',dat_fehler)
                    else
                      ausschrift(textz_spru__absoluter_Ruf_von^
                        +hex_word(word_z(@d[3])^)+':'+hex_word(word_z(@d[1])^)+'!',dat_fehler);
                  d[0]:=0;
                end;
            end;

        end; (* case [0] *)



      if gesprungen then
        begin
          if anzahl_spruenge>2 then
            hersteller_erforderlich:=wahr;

          if ((dateilaenge>=analyseoff+codeoff_seg*16+codeoff_off) and (analyseoff+codeoff_seg*16+codeoff_off>0))
          or hersteller_erforderlich
          or (quelle.sorte<>q_datei) then
            datei_lesen(tracepuffer,analyseoff+codeoff_seg*16+codeoff_off,512)
          else
            FillChar(tracepuffer,SizeOf(tracepuffer),0);

        end
      else
        Break;

    until false;

    if (quelle.sorte=q_datei) and exe then
      ds_off:=longint(exe_kopf.kopfgroesse)*16-$100
    else
      ds_off:=-$100;

    hersteller_gefunden:=hersteller_gefunden_org;
  end;

end.

