{&Use32+}
{$I+}
program gen_menu;

const
  plusverkettung        :array[boolean] of string[1]=(' ','+');
  continue_next_line    :array[boolean] of string[3]=('','  ~');
  leer                  :string[80]='                                                                       ';

  number_of_slots       :integer=4;
  nofiles               :word=0;
  problems              :word=0;

var
  os2,nif,desc          :array[1..1000] of string;
  anzahl,i,j,
  default,none,usernic  :word;
  l,m                   :text;
  zeile                 :string;
  check                 :integer;
  restriction_list_size :word;
  restriction_list      :array[1..1000] of string[8];
  restriction_found     :array[1..1000] of boolean;

procedure lies(var s:string);
  var
    w1:word;
  begin
    w1:=Pos('"',zeile);
    if w1=0 then
      begin
        WriteLn('>',zeile,'<');
        RunError(99);
      end;
    Delete(zeile,1,w1);
    s:=Copy(zeile,1,Pos('"',zeile)-1);
    Delete(zeile,1,Length(s)+Length('"'));
    while (zeile<>'') and (zeile[1] in [' ',#9]) do
      Delete(zeile,1,1);
  end;


procedure upcase_string(var s:string);
  var
    i:word;
  begin
    for i:=1 to Length(s) do
      s[i]:=UpCase(s[i]);
  end;

function usernic_number_filter(const s:string;i,n:word):string;
  begin
    Result:=s;
    if i=usernic then
      while Pos('?',Result)<>0 do
        Result[Pos('?',Result)]:=Chr(Ord('0')+n);
  end;

var
  tmp                   :string;
  shipped               :boolean;

begin
  if not DebugHook then
    if (ParamCount<3) or (ParamCount>4) then
      begin
        WriteLn('GenMenu nic.lst 4 menu_nic.txt [democd.lst]');
        WriteLn('  nic.lst      = driver source list file');
        WriteLn('  4            = number of menu spinbuttons');
        WriteLn('  menu_nic.txt = menu output');
        WriteLn('  democd.lst   = restrict list to drivers only in this list');
        Halt(1);
      end;

  restriction_list_size:=0;
  if ParamCount>=4 then
    begin
      Assign(l,ParamStr(4));
      Reset(l);
      while not Eof(l) do
        begin
          ReadLn(l,zeile);
          for i:=1 to Length(zeile) do if zeile[1]<' ' then zeile[i]:=' ';
          while (zeile<>'') and (zeile[1]=' ') do Delete(zeile,1,Length(' '));
          while (zeile<>'') and (zeile[Length(zeile)]=' ') do Delete(zeile,Length(zeile),Length(' '));
          if zeile='' then Continue;
          if zeile[1] in [';','#','|'] then Continue;
          upcase_string(zeile);
          (* remove path component of filename, if present *)
          repeat
            i:=Pos('\',zeile);
            if i=0 then
              i:=Pos('/',zeile);
            if i=0 then Break;
            Delete(zeile,1,i);
          until false;

          i:=Pos('.NIF',zeile);
          if i=0 then (* ignore any other 'dir /b' items that are not nif files *)
            Continue;

          Delete(zeile,i,255);

          if restriction_list_size>=High(restriction_list) then
            Continue;
          Inc(restriction_list_size);
          restriction_list[restriction_list_size]:=zeile;
          restriction_found[restriction_list_size]:=false;
        end;
      Close(l);
    end; (* ecsdemo.lst *)

  if ParamCount>=1 then
    Assign(l,ParamStr(1))
  else
    Assign(l,'nic.lst');
  Reset(l);

  if ParamCount>=2 then
    Val(ParamStr(2),number_of_slots,check);

  anzahl:=0;
  while not Eof(l) do
    begin
      ReadLn(l,zeile);
      for i:=1 to Length(zeile) do if zeile[1]<' ' then zeile[i]:=' ';
      while (zeile<>'') and (zeile[1]=' ') do Delete(zeile,1,Length(' '));
      while (zeile<>'') and (zeile[Length(zeile)]=' ') do Delete(zeile,Length(zeile),Length(' '));
      if zeile='' then Continue;
      if Pos('?"',zeile)=1 then
        begin
          Inc(nofiles);
          Delete(zeile,1,1);
        end;
      if zeile[1] in [';','#','|'] then Continue;
      if zeile[1] in ['?','!','<','>'] then
        begin
          Inc(problems);
          Continue;
        end;
      Inc(anzahl);
      lies(nif[anzahl]);
      upcase_string(nif[anzahl]);
      lies(os2[anzahl]);
      upcase_string(os2[anzahl]);
      lies(desc[anzahl]);

      (* when not allowed to ship the driver then remove it.. *)
      shipped:=(restriction_list_size=0) (* exception when having no restriction list   *)
            or (nif[anzahl]='')          (* or when having the no-driver entry          *)
            or (nif[anzahl]='USERNIC?'); (* or user defined entry                       *)
      for i:=1 to restriction_list_size do
        if restriction_list[i]=nif[anzahl] then
          begin
            restriction_found[i]:=true;
            shipped:=true;
            Break;
          end;

      if not shipped then
        begin
          Dec(anzahl);
          Continue;
        end;

      (* sort into table alphabeticaly *)
      for i:=anzahl-1 downto 1 do
        if desc[i]<=desc[i+1] then
          Break
        else
          begin
            tmp:=nif[i];
            nif[i]:=nif[i+1];
            nif[i+1]:=tmp;
            tmp:=os2[i];
            os2[i]:=os2[i+1];
            os2[i+1]:=tmp;
            tmp:=desc[i];
            desc[i]:=desc[i+1];
            desc[i+1]:=tmp;
          end;

    end;
  Close(l);

  (* search nullndis *)
  default:=1;
  for i:=1 to anzahl do
    if nif[i]='NULLNDIS' then
      begin
        default:=i;
        Break;
      end;

  none:=1;
  for i:=1 to anzahl do
    if nif[i]='' then
      begin
        none:=i;
        Break;
      end;

  usernic:=-1;
  for i:=1 to anzahl do
    if nif[i]='USERNIC?' then
      begin
        usernic:=i;
        Break;
      end;

  if ParamCount>=3 then
    Assign(m,ParamStr(3))
  else
    Assign(m,'menu_nic.txt');
  Rewrite(m);
  WriteLn(m,'#--- generated by gennmenu begin ---');
  WriteLn(m);

  if restriction_list_size=0 then
    begin
      WriteLn(m,'# this list allows to detects the full list of known drivers');
      WriteLn(m);
      WriteLn(m,'Hidden Boolean OS2CSM_LIMIT_NIC_DETECTION false');
    end
  else
    begin
      WriteLn(m,'# this list restricts the detection to drivers thare are shipped on media');
      WriteLn(m);
      WriteLn(m,'Hidden Boolean OS2CSM_LIMIT_NIC_DETECTION true');
    end;

  WriteLn(m);
  WriteLn(m,'# driver (*.os2) table');
  WriteLn(m);
  WriteLn(m,'Hidden Spinbutton NIC_OS2_List ~');
  for i:=1 to anzahl do
    WriteLn(m,'  ',plusverkettung[i>1],'"',os2[i],'"',Copy(leer,1,8-Length(os2[i])),continue_next_line[{i<anzahl}true]);
  WriteLn(m,'    "',os2[default],'" Delete_at_Menu_Exit');
  WriteLn(m);

  WriteLn(m,'# driver description (*.nif) table');
  WriteLn(m);
  WriteLn(m,'Hidden Spinbutton NIC_NIF_List ~');
  for i:=1 to anzahl do
    WriteLn(m,'  ',plusverkettung[i>1],'"',nif[i],'"',Copy(leer,1,8-Length(nif[i])),continue_next_line[{i<anzahl}true]);
  WriteLn(m,'    "',nif[default],'" Delete_at_Menu_Exit');
  WriteLn(m);

  WriteLn(m,'# driver titles, ',number_of_slots,' slots');
  WriteLn(m);
  for j:=1 to number_of_slots do
    if j=1 then
      begin
        WriteLn(m,'Spinbutton NIC_NIC_List_1 6 ',4+j*4,' L65 ~');
        for i:=1 to anzahl do
          WriteLn(m,'  ',plusverkettung[i>1],'"',usernic_number_filter(desc[i],i,j),'"',Copy(leer,1,70-Length(desc[i])),continue_next_line[{i<anzahl}true]);
        WriteLn(m,'        "',desc[default],'" Delete_at_Menu_Exit');
        WriteLn(m);
      end
    else
      begin
        WriteLn(m,'Spinbutton NIC_NIC_List_',j,' 6 ',4+j*4,' Like NIC_NIC_List_1 ~');
        WriteLn(m,'        "',desc[default],'" Delete_at_Menu_Exit');
        WriteLn(m);
      end;

  WriteLn(m,'# variables used in config.sys');
  WriteLn(m);
  for j:=1 to 1 do
    begin
      WriteLn(m,'Hidden String DETECT_NIF_',j,' 8 "NULLNDIS"');
      WriteLn(m,'Hidden String DETECT_OS2_',j,' 8 "NULLNDIS"');
    end;
  for j:=2 to number_of_slots do
    begin
      WriteLn(m,'Hidden String DETECT_NIF_',j,' 8 ""');
      WriteLn(m,'Hidden String DETECT_OS2_',j,' 8 ""');
    end;
  WriteLn(m);
  WriteLn(m,'# setup default values for spinbuttons');
  WriteLn(m,'# use NIC_NIF_List as an translation table');
  for j:=1 to number_of_slots do
    begin
      WriteLn(m,'BeginStatement Str_Val( DETECT_NIF_',j,' NIC_NIF_List )');
      WriteLn(m,'BeginStatement NIC_NIC_List_',j,' := NIC_NIF_List');
    end;

  WriteLn(m);
  WriteLn(m,'# move non-empty selection up');
  WriteLn(m,'Hidden Boolean NIC_SLOT_EMPTY false');
  for j:=1 to number_of_slots-1 do
    begin
      WriteLn(m,'EndStatement NIC_SLOT_EMPTY := NIC_NIC_List_',j,' = "',desc[none],'"');
      WriteLn(m,'EndStatement if NIC_SLOT_EMPTY then NIC_NIC_List_',j,  ' := NIC_NIC_List_',j+1);
      WriteLn(m,'EndStatement if NIC_SLOT_EMPTY then NIC_NIC_List_',j+1,' := "',desc[none],'"');
    end;
  WriteLn(m);

  WriteLn(m,'# if slot 1 is empty, set it to null driver');
  WriteLn(m,'EndStatement if NIC_NIC_LIST_1 = "',desc[none],'" then NIC_NIC_LIST_1 := "',desc[default],'"');
  WriteLn(m);

  WriteLn(m,'# copy back user selection to .NIF and .OS2 name');
  WriteLn(m,'# use NIC_NIF_List/NIC_OS2_List as translation tables');
  for j:=1 to number_of_slots do
    begin
      WriteLn(m,'EndStatement NIC_NIF_List := NIC_NIC_List_',j);
      WriteLn(m,'EndStatement NIC_OS2_List := NIC_NIC_List_',j);
      WriteLn(m,'EndStatement DETECT_NIF_',j,' := NIC_NIF_List');
      WriteLn(m,'EndStatement DETECT_OS2_',j,' := NIC_OS2_List');
      if usernic<>-1 then
        begin
          WriteLn(m,'EndStatement if DETECT_NIF_',j,' = "',nif[usernic],'" then DETECT_NIF_',j,' := "',usernic_number_filter(nif[usernic],usernic,j),'"');
          WriteLn(m,'EndStatement if DETECT_OS2_',j,' = "',os2[usernic],'" then DETECT_OS2_',j,' := "',usernic_number_filter(os2[usernic],usernic,j),'"');
        end;
    end;
  WriteLn(m);

  WriteLn(m,'#--- generated by gennmenu end ---');
  WriteLn(m);
  Close(m);

  Write('Count: ',anzahl);
  if nofiles>0 then
    Write(', Files not available: ',nofiles);
  if problems>0 then
    Write(', Problems: ',problems);
  WriteLn;

  for i:=1 to restriction_list_size do
    if not restriction_found[i] then
      WriteLn('No reference to item in restriction list: ',restriction_list[i],'.NIF!');
end.

