{  $R+}
{&Use32+}
program systemsoft_decoder;

(* 2000.06.11 Veit Kannegieser                                          *)
(* 2000.12.08 stOpen->stOpenRead                                        *)
(* 2004.06.03 55AA,CPU microcode, ISA                                   *)

uses
  Dos,
  Objects,
  {$IfDef VirtualPascal}
  VpUtils,
  {$Else}
  TpUtils,
  {$EndIf}
  Strings;


type
{$IfNDef VirtualPascal}
  smallword             =word;
{$EndIf}
  smallword_z           =^smallword;

const
  datum='2000.06.11..2004.06.03';

var
  d1,d2                 :pBufStream;
  zielverzeichnis,
  zielname              :string;
  kopf                  :
    packed record
      sig_ee_88         :smallword;
      name_             :array[0..7] of char;
      w_0a              :smallword; (* or 10 wenn dd 88 vorhanden ist *)
      laenge_eingepackt :smallword;
      zieloffset        :smallword;
      zielsegment       :smallword;
      pruefsumme        :smallword;
    end;

  zusatzinformationen   :
    packed record
      sig_dd_88         :smallword;
      i                 :array[0..30] of char;
    end;


  anzahl_zusatzinformationen,
  pruefsumme            :smallword;
  z,z2                  :word;

  b0,b1                 :byte;
  start_position        :longint;
  datenstart            :longint;

  entpackt              :array[0..50000-1] of byte;
  laenge                :word;
  uebrig                :word;
  rueckwaerts           :word;
  schreibposition       :word;
  dateizaehler          :word;
  anfang                :array[0..$200-1] of byte;
  quelllaenge           :longint;

label
  nicht_gefunden;

procedure kopiere_byteweise(const quelle,ziel;const anzahl:word);
  {$IfDef VirtualPascal}
  assembler;{&Uses esi,edi,ecx}{&Frame-}
  asm
    mov esi,quelle
    mov edi,ziel
    mov ecx,anzahl
    cld
    rep movsb
  end;
  {$Else}
  assembler;
  asm
    push ds
      lds si,quelle
      les di,ziel
      mov cx,anzahl
      cld
      rep movsb
    pop ds
  end;
  {$EndIf}

function vergleich_anfang0(const zk:string):boolean;
  var
    i                   :word;
  begin
    vergleich_anfang0:=true;
    for i:=1 to Length(zk) do
      if anfang[i-1]<>Ord(zk[i]) then
        begin
          vergleich_anfang0:=false;
          Break;
        end;
  end;

procedure speichere(start_position:longint;const titel:string;const dateierweiterung:string;laenge:longint);
  var
    blocklaenge         :longint;
    jetzt               :word;
  begin
    d1^.Seek(start_position);
    zielname:=Int2Hex(start_position,8)+dateierweiterung;
    WriteLn('þ $',Int2Hex(start_position,8),'  ',titel,' ');
    blocklaenge:=laenge;
    if blocklaenge>=$10000 then
      Write  ('*            $', Int2Hex(blocklaenge,5),' =>', Int2Hex(blocklaenge,5))
    else
      Write  ('*             $',Int2Hex(blocklaenge,4),' => ',Int2Hex(blocklaenge,4));
    d2:=New(pBufStream,Init(zielverzeichnis+zielname,stCreate,8*1024));
    while blocklaenge>0 do
      begin
        jetzt:=SizeOf(entpackt) and -512;
        if jetzt>blocklaenge then
          jetzt:=blocklaenge;
        d1^.Read(entpackt,jetzt);
        d2^.Write(entpackt,jetzt);
        blocklaenge:=blocklaenge-jetzt;
      end;
    d2^.Done;
    WriteLn;

    b0:=0;
    b1:=0;
  end;

begin
  WriteLn('ð SYSODECO * Veit Kannegieser * ',datum);
  dateizaehler:=0;

  if (ParamCount<1) or (ParamCount>2) then
    begin
      WriteLn('usage:     SYSODECO <flash image> [<target directory>]');
      WriteLn('Benutzung: SYSODECO <BIOS-Abbild> [<Zielverzeichnis> ]');
      Halt(1);
    end;

  d1:=New(pBufStream,Init(ParamStr(1),stOpenRead,8*1024));
  zielverzeichnis:=FExpand(ParamStr(2));
  if not (zielverzeichnis[Length(zielverzeichnis)] in ['\','/']) then
    zielverzeichnis:=zielverzeichnis+'\';

  quelllaenge:=d1^.GetSize;
  repeat

    d1^.Read(anfang,SizeOf(anfang));
    start_position:=d1^.GetPos-SizeOf(anfang);

    if d1^.Status<>StOk then
      Break;

    if vergleich_anfang0(#$ee#$88) then
      begin
        d1^.Seek(start_position);

        d1^.Read(kopf,SizeOf(kopf));

        if (not (kopf.name_[0] in ['A'..'Z'       ]))
        or (not (kopf.name_[1] in ['A'..'Z'       ]))
        or (not (kopf.name_[2] in ['A'..'Z',' ',#0]))
         then
          begin
            d1^.Seek(start_position+2);
            goto nicht_gefunden;
          end;

        zielname:=Copy(StrPas(kopf.name_),1,8);
        WriteLn('þ $',Int2Hex(start_position,8),'  ',zielname);

        anzahl_zusatzinformationen:=(kopf.w_0a shr 4) and 7;
        for z:=1 to anzahl_zusatzinformationen do
          begin
            d1^.Read(zusatzinformationen,SizeOf(zusatzinformationen));
            if zusatzinformationen.sig_dd_88=$88dd then
              with zusatzinformationen do
                 begin
                   for z2:=Low(i) to High(i)-1 do
                     if i[z2]=#0 then i[z2]:=' ';
                   i[High(i)]:=#0;
                   WriteLn('ú ',StrPas(@zusatzinformationen.i[0]));
                 end;
          end;

        datenstart:=d1^.GetPos;
        pruefsumme:=0;
        for z:=1 to kopf.laenge_eingepackt do
          begin
            d1^.Read(b0,1);
            Inc(pruefsumme,b0);
          end;

        if pruefsumme<>kopf.pruefsumme then
          begin
            WriteLn('Checksum error, block ignored!'#7);
            goto nicht_gefunden;
          end;

        d1^.Seek(datenstart);


        Inc(dateizaehler);
        while Pos(' ',zielname)<>0 do
          zielname[Pos(' ',zielname)]:='_';
        d2:=New(pBufStream,Init(zielverzeichnis+zielname+'.'+Int2Str(dateizaehler),stCreate,8*1024));

        Write('* $',Int2Hex(kopf.zielsegment,4),':$',Int2Hex(kopf.zieloffset,4),' $',Int2Hex(kopf.laenge_eingepackt,4),' -> ');

        FillChar(entpackt,SizeOf(entpackt),0);
        schreibposition:=0;
        uebrig:=kopf.laenge_eingepackt;

        while uebrig>0 do
          begin

            (*Write('$',Int2Hex(schreibposition,4),^h^h^h^h^h);*)

            if schreibposition>High(entpackt) then
              RunError(1);

            d1^.Read(b0,1);
            Dec(uebrig);
            if b0<=$f then
              begin
                laenge:=b0+1;
                d1^.Read(entpackt[schreibposition],laenge);
                Dec(uebrig,laenge);
                Inc(schreibposition,laenge)
              end
            else
              begin
                d1^.Read(b1,1);
                Dec(uebrig);
                rueckwaerts:=(b0 and $0f) shl 8 + b1;
                if rueckwaerts>schreibposition then
                  RunError(1);
                laenge:=b0 shr 4+1;
                kopiere_byteweise(entpackt[schreibposition-rueckwaerts],entpackt[schreibposition],laenge);
                Inc(schreibposition,laenge)
              end;
          end; (* while *)

        d2^.Write(entpackt[0],schreibposition);
        d2^.Done;
        WriteLn('$',Int2Hex(schreibposition,4));

      nicht_gefunden:

      end (* ee 88 *)
    else
    if vergleich_anfang0(#$55#$aa) then
      speichere(start_position,'ROM header','.ROM',Longint(anfang[2])*512)
    else
    if vergleich_anfang0('ISA') then
      speichere(start_position,'ISA ROM','.ISA',$2000)
    else
    if vergleich_anfang0(#$1e#$06#$8a#$d8#$b7) then
      speichere(start_position,'Battery Management?','.ROM',$800)
    else
    if vergleich_anfang0(#$01#$00#$00#$00)
    and (smallword_z(@anfang[$8])^>=$1990)
    and (smallword_z(@anfang[$8])^<=$2090)
    and (             anfang[$a]  >=$01  )
    and (             anfang[$a]  <=$31  )
    and (             anfang[$b]  >=$01  )
    and (             anfang[$b]  <=$12  ) then
      speichere(start_position,'CPU microcode','.CPU',$800)
    else
    if anfang[0] in [$00,$ff] then
      begin
        laenge:=0;
        while (laenge<SizeOf(anfang)) and (anfang[laenge] in [$00,$ff]) do
          Inc(laenge);
        (* ignorieren *)
        if laenge<>SizeOf(anfang) then
          d1^.Seek(start_position+laenge)
      end
    else
    if quelllaenge-start_position<$4000 then
      speichere(start_position,'Boot block','.ROM',quelllaenge-start_position)
    else
      begin
        {$IfDef VirtualPascal}
        if DebugHook then asm int 3 end;
        {$EndIf}
        speichere(start_position,'unknown -- ask..','.UNK',$1000-(start_position and $fff));
      end;

  until false;

  d1^.Done;


end.

