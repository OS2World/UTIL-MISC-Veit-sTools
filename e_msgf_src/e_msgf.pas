(*$I+*)
program msg_entpacker;

(* 2001.02.09 Veit Kannegieser *)


(* Doku zum Quellformat: "Tools Reference"/DDK *)
(* Post von Yuri Prokushev *)

uses
  Dos,
  Objects,
  Strings,
  VpUtils;

const
  version               ='2005.05.10';

type
  smallword_z           =^smallword;
  longint_z             =^longint;

  mkmsgf_kopf           =
    packed record
      kennung           :array[1..8] of char;
      sys3              :array[1..3] of char;
      anzahl_nachrichten:smallword;
      anfangsnummer     :smallword;
      bis64k            :boolean;
      version           :smallword;
      index_anfang      :smallword;
      beschreibung      :smallword;
      verweis_msg       :longint;
    end;


  beschreibungsblock    =
    packed record
      zeichenlaenge     :byte;
      u01               :array[1..2] of byte;
      sprachfamilie     :smallword;
      untersprache      :smallword;
      anzahl_cs         :smallword;
      cs                :array[1..16] of smallword;
      msg_name_mkmsgf   :array[0..260] of char;
    end;

  verweis_kopf          =
    packed record
      blocklaenge       :smallword; (* ohne diesen Kopf *)
      anzahl            :smallword;
    end;

var
  quelle                :file;
  p                     :pByteArray;
  l                     :longint;
  ausgabe               :pBufStream;
  parameterdatei        :Text;
  index_,zaehler        :longint;
  position,laenge       :longint;

  pfad                  :DirStr;
  name_                 :NameStr;
  erweiterung           :ExtStr;

  dateiname_txt,
  dateiname_msg         :string;

procedure BlockWrite(const p:pointer;const l:longint);
  begin
    ausgabe^.Write(p^,l);
    if ausgabe^.Status<>stOK then RunError(ausgabe^.Status);
  end;

procedure BlockWrite_zk(const s:string);
  begin
    BlockWrite(@s[1],Length(s));
  end;

procedure BlockWrite_zk_U(const s:string);
  const
    umbruch             :array[1..2] of char=^m^j;
  begin
    BlockWrite(@s[1],Length(s));
    BlockWrite(@umbruch,Length(umbruch));
  end;

procedure msg_informationen(const pos:longint;const hauptdatei:boolean);
  var
    l_zk,
    cs_zk,
    dn_msg,
    dn_txt              :string;
  begin
    with beschreibungsblock(p^[pos]) do
      begin

        if hauptdatei then
          begin
            dn_txt:=dateiname_txt;
            (* msg-Name kann anders sein, hat dafÅr aber exakte Gro·/Keinschreibung,
               und erlaubt bit-gleiche Dateien wieder zu erstellen.. *)
          (*dn_msg:=dateiname_msg;*)
            dn_msg:=StrPas(msg_name_mkmsgf);
          end
        else
          begin
            dn_txt:=name_+'.txt'+Int2Str(cs[1]); (* geraten.. *)
            dn_msg:=StrPas(msg_name_mkmsgf);
          end;

        while Length(dn_txt)<Length('12345678.txtCCCC') do dn_txt:=dn_txt+' ';
        while Length(dn_msg)<Length('12345678.msg'    ) do dn_msg:=dn_msg+' ';

        (* OSO001.txt949 oso001.msg  /L 18,1  /P 949 /P 934  /v /d 133,254 *)

        l_zk:=' /L '+Int2Str(sprachfamilie)+','+Int2Str(untersprache);
        while Length(l_zk)<Length(' /L 18,1') do Insert(' ',l_zk,4);

        BlockWrite_zk_U(';'+l_zk);
        Write(parameterdatei,dn_txt,' ',dn_msg,' '+l_zk);

        cs_zk:='';
        for zaehler:=1 to anzahl_cs do
          cs_zk:=cs_zk+' /P '+Int2Str(cs[zaehler]);
        BlockWrite_zk_U(';'+cs_zk);

        Write(parameterdatei,cs_zk);
        for zaehler:=anzahl_cs+1 to 2 do (* Leerzeichen einfÅgen, damit die Spalten erhalten bleiben *)
          Write(parameterdatei,'       ');

        Write(parameterdatei,' /V');

        (* 1:SBCS 2:DBCS *)
        case zeichenlaenge of
          1:;
          2:Write(parameterdatei,' /D 133,254'); (* fÅr Korea geraten, scheint nicht gespeichert zu werden *)
        else
          WriteLn('Warning: unknown character size (',zeichenlaenge,' bytes)!');
        end;

        WriteLn(parameterdatei);

        if not hauptdatei then
          WriteLn('Notice: the message file has an link to additional file "',msg_name_mkmsgf,'"..');

      end;


  end; (* msg_informationen *)

begin
  WriteLn('E_MSGF * V.K. * 2001.02.09..'+version);

  if (not (ParamCount in [1,2,3]))
  or (ParamStr(1)='/?')
  or (ParamStr(1)='-?')
   then
    begin
      WriteLn('E_MSGF OSO001[.MSG] [OSO001[.TXT] [OSO001[.INP]]]');
      Halt(1);
    end;

  FSplit(ParamStr(1),pfad,name_,erweiterung);

  if erweiterung='' then
    erweiterung:='.msg';

  dateiname_msg:=name_+erweiterung;

  FileMode:=$40;
  Assign(quelle,pfad+name_+erweiterung);
  Reset(quelle,1);
  l:=FileSize(quelle);
  GetMem(p,l);
  BlockRead(quelle,p^,l);
  Close(quelle);

  if ParamCount>=2 then
    FSplit(ParamStr(2),pfad,name_,erweiterung)
  else
    erweiterung:='';

  if erweiterung='' then
    erweiterung:='.txt';

  dateiname_txt:=name_+erweiterung;
  ausgabe:=New(pBufStream,Init(pfad+dateiname_txt,stCreate,32*1024));
  if ausgabe^.Status<>stOK then
    RunError(ausgabe^.Status);

  if ParamCount>=3 then
    FSplit(ParamStr(3),pfad,name_,erweiterung)
  else
    erweiterung:='';

  if erweiterung='' then
    erweiterung:='.inp';

  Assign(parameterdatei,pfad+name_+erweiterung);
  Rewrite(parameterdatei);

  with mkmsgf_kopf(p^[0]) do
    begin

      if kennung<>#$ff'MKMSGF'#$00 then
        begin
          WriteLn('"'+kennung+'"<>"'#$ff'MKMSGF'#$00'"');
          Halt(1);
        end;


      BlockWrite_zk_U('; E_MSGF * V.K.');
      if beschreibung>0 then (* nicht in Version 0 *)
        begin

          msg_informationen(beschreibung,true);

          if (verweis_msg>0) and (verweis_msg+SizeOf(verweis_kopf)<=l) then
            with verweis_kopf(p^[verweis_msg]) do
              for zaehler:=1 to anzahl do
                msg_informationen(verweis_msg+SizeOf(verweis_kopf)+blocklaenge*(zaehler-1),false);

        end
      else
        (* keine Landesinformationen.. *)
        (* OSO001.txt oso001.msg /v *)
        WriteLn(parameterdatei,dateiname_txt,' ',dateiname_msg,' /v');



      BlockWrite_zk_U(sys3);


      index_:=index_anfang;
      if index_=0 then (* version=0... *)
        index_:=$1f;
      (*************************************************************)
      for zaehler:=0 to anzahl_nachrichten-1 do
        begin

          if bis64k then
            begin
              position:=smallword_z(@p^[index_])^;
              if zaehler=anzahl_nachrichten-1 then
                laenge:=l-position
              else
                laenge:=smallword_z(@p^[index_+2])^-position;
              Inc(index_,2);
            end
          else
            begin
              position:=longint_z(@p^[index_])^;
              if zaehler=anzahl_nachrichten-1 then
                laenge:=l-position
              else
                laenge:=longint_z(@p^[index_+4])^-position;
              Inc(index_,4);
            end;

          (* Wenn Verweis auf 437-Variante enthalten ist, dann
             sollen diese Daten nicht in der letzten Meldung enhalten sein! *)
          if zaehler=anzahl_nachrichten-1 then
            if (verweis_msg>position) and (verweis_msg+4<=l) then
              laenge:=verweis_msg-position;

          (* ^Z am Dateiende unterdrÅcken *)
          if zaehler=anzahl_nachrichten-1 then
            while laenge>1 do
              if p^[position+laenge-1] in [0..6,11,12,14..31] then
                Dec(laenge)
              else
                Break;

          if laenge<1 then
            begin
              WriteLn('Error: Message ',sys3+Int2StrZ(anfangsnummer+zaehler,4),' has no message type!');
              Halt(1);
            end;

          if not (Chr(p^[position]) in ['E','H','I','P','W','?']) then
            begin
              WriteLn('Warning: ',sys3+Int2StrZ(anfangsnummer+zaehler,4),' has invalid message type "',Chr(p^[position]),'"!');
            end;

          BlockWrite_zk(sys3+Int2StrZ(anfangsnummer+zaehler,4)+Chr(p^[position])+':');

          Inc(position);
          Dec(laenge);

          (* ein Leerzeichen am Anfang wird verschluckt ... *)
          if laenge<2 then
            BlockWrite_zk(' ') (* %0 folgt *)
          else (* kein Leerzeichen am Zeilenende anhÑngen *)
            if (p^[position]<>13) or (p^[position+1]<>10) then
              BlockWrite_zk(' ');

          if laenge>0 then
            BlockWrite(@p^[position],laenge);

          (* wenn die Nachricht nicht mit Zeilenumbruch endet, '%0'+Zeilenumbruch anhÑngen *)
          if laenge<2 then (* kein Platz fÅr Zeilenumbruch *)
            BlockWrite_zk_U('%0')
          else (* prÅfen *)
            if (p^[position+laenge-2]<>13) or (p^[position+laenge-2+1]<>10) then
              BlockWrite_zk_U('%0');
        end;
      (*************************************************************)

    end; (* with kopf *)

  ausgabe^.Done;
  Dispose(p);
  Close(parameterdatei);

end.

