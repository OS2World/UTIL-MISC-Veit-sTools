(*$G+,N+,E-*)
program i41;

(* Anzeige der Festplatteninformationen des Int 41 *)
(* 2000.07.24 Veit Kannegieser *)

type
  festplattendaten	=
    record
      anzahl_zylinder	:word;
      anzahl_koepfe	:byte;
      xt1		:word;
      precomp2		:word;
      ecc3		:byte;
      steuerinformation	:byte;
      xttimeout4	:byte;
      xtformattimeout5	:byte;
      xttimeout6	:byte;
      park_zylinder	:word;
      sektoren_je_spur	:byte;
      reseriert7	:byte;
    end;

  festplattentabelle    =array[1..4] of festplattendaten;

var
  int41                 :^festplattentabelle absolute $0000:$41*4;
  z                     :word;
  g                     :double;

begin
  WriteLn('INT $41 :');
  Writeln(' # Zylinder  K”pfe Sektoren/Spur  Parkzylinder  Gr”áe (MB)');
  WriteLn(' # Cylinders heads sectors/track  landing zone  size  (MB)');

  for z:=Low(int41^) to High(int41^) do
    with int41^[z] do
      begin
        Write(z:2);
        if sektoren_je_spur=0 then
          WriteLn(' ---')
        else
          begin
            Write  (anzahl_zylinder:10,anzahl_koepfe:6,sektoren_je_spur:14,
                    park_zylinder:14);

            g:=anzahl_zylinder;
	    g:=g*anzahl_koepfe*sektoren_je_spur/(2*1024);
            WriteLn(g:12:3);
          end;
      end;
end.
