(*$M 16384,0,0*)
program microid_research_bios_decompressor;

(* 27.04.1998 Veit Kannegieser *)
(* 2002.03.15 mr_895.pci: 64 KB ROM *)
(* 2002.03.17 mr_ev2.bio: 128 KB ROM *)

uses
  dosmem,
  hex,
  dos,
  mkdir2;

type
  word_z                =^word;

var
  dekompressorkern      :pointer;
  quelle,ziel           :pointer;
  position              :word;
  zielverzeichnis       :string;
  d                     :file;
  biossegment_e000,
  biossegment_f000      :word;
  quellsegment          :word;
  laenge_eingepackt,
  laenge_ausgepackt     :word;
  l,i,j                 :longint;

procedure aufruf(quellsegment,laenge,zielsegment:word;var laenge_ausgepackt:word);
  var
    stack_dekompressorkern:pointer;
  begin
    stack_dekompressorkern:=dekompressorkern;
    FillChar(Ptr(zielsegment,0)^,$ffff,0);
    asm
      push ds
        mov cx,laenge
        mov ds,quellsegment
        mov es,zielsegment
        push bp
          cld
          call stack_dekompressorkern
        pop bp
      pop ds
      mov ax,di
      les di,laenge_ausgepackt
      mov es:[di],ax
    end;
  end;

begin
  WriteLn;
  WriteLn('MRDECO * V.K. * 1998.04.27..2002.03.19');

  if (ParamCount<1) or (ParamCount>2) then
    begin
      WriteLn('MRDECO MR_895.PCI UNPACKED\');
      Halt(1);
    end;

  WriteLn(ParamStr(1),'...');

  getdosmem(quelle,$2000);
  getdosmem(ziel  ,$1000);

  biossegment_e000:=Seg(quelle^);
  biossegment_f000:=biossegment_e000+$1000;

  zielverzeichnis:=fexpand(ParamStr(2));
  if not (zielverzeichnis[length(zielverzeichnis)] in ['\','/']) then
    zielverzeichnis:=zielverzeichnis+'\';
  mkdir_verschachtelt(zielverzeichnis);

  Assign(d,ParamStr(1));
  FileMode:=$40;
  Reset(d,1);
  l:=FileSize(d);
  if (l<$10000) or (l>$20000) then
    begin
      WriteLn('ROM Size 64..128 KB !');
      Halt(1);
    end;

  (* L”schen *)
  i:=0;
  repeat
    j:=($20000-l)-i;
    if j=0 then Break;
    if j>$8000 then j:=$8000;
    FillChar(Ptr(biossegment_e000+(i shr 4),(i and $f))^,j,$ff);
    Inc(i,j);
  until false;

  (* ROM laden *)
  i:=$20000-l;
  repeat
    j:=$20000-i;
    if j=0 then Break;
    if j>$8000 then j:=$8000;
    BlockRead(d,Ptr(biossegment_e000+(i shr 4),(i and $f))^,j);
    Inc(i,j);
  until false;

  Close(d);


  Write('Decompressor=$f000:');

  dekompressorkern:=nil;
  position:=0;
  repeat
    if  (Mem[biossegment_f000:position+$00]=$33) (* XOR SI,SI *)
    and (Mem[biossegment_f000:position+$01]=$f6)

    and (Mem[biossegment_f000:position+$02]=$33) (* XOR DI,DI *)
    and (Mem[biossegment_f000:position+$03]=$ff)

    and (Mem[biossegment_f000:position+$04]=$ad) (* LODSW *)

    and (Mem[biossegment_f000:position+$05]=$8b) (* MOV CX,AX *)
    and (Mem[biossegment_f000:position+$06]=$c8)

    and (Mem[biossegment_f000:position+$07]=$05) (* ADD AX,2 *)
    and (Mem[biossegment_f000:position+$08]=$02)
    and (Mem[biossegment_f000:position+$09]=$00)

    and (Mem[biossegment_f000:position+$0a]=$93) (* XCHG AX,BX *)

    and (Mem[biossegment_f000:position+$0b]=$8a) (* MOV DH,[BX] *)
    and (Mem[biossegment_f000:position+$0c]=$37)
     then
      begin
        dekompressorkern:=ptr(biossegment_f000,position);
        WriteLn(hexstr(position,4));
        Break;
      end;

    if position>$8000 then
      begin
        WriteLn('????');
        Halt(1);
      end;

    Inc(position);
  until false;


  (* Suche nach 1. Aufruf des Dekompressors ... *)
  position:=0;
  repeat
    if  (Mem[biossegment_f000:position+$00]=$ba) (* MOV DX,PACK *)

    and (Mem[biossegment_f000:position+$03]=$c1) (* SHR DX,4 *)
    and (Mem[biossegment_f000:position+$04]=$ea)
    and (Mem[biossegment_f000:position+$05]=$04)

    and (Mem[biossegment_f000:position+$06]=$80) (* OR DH,0F0 *)
    and (Mem[biossegment_f000:position+$07]=$ce)
    and (Mem[biossegment_f000:position+$08]=$f0)

    and (Mem[biossegment_f000:position+$09]=$b9) (* MOV CX,PACKLŽNGE *)
     then
      begin
        quellsegment     :=MemW[biossegment_f000:position+$01];
        laenge_eingepackt:=MemW[biossegment_f000:position+$0a];
        Write('f000:',hexstr(quellsegment,4),' [',hexstr(laenge_eingepackt,4),'] -> ');
        aufruf(biossegment_f000+quellsegment div 16,laenge_eingepackt,Seg(ziel^),laenge_ausgepackt);
        WriteLn('[',hexstr(laenge_ausgepackt,4),']');
        Assign(d,zielverzeichnis+'F000'+hexstr(quellsegment,4)+'.MRD');
        Rewrite(d,1);
        BlockWrite(d,ziel^,laenge_ausgepackt);
        Close(d);
      end;

    Inc(position);
  until position>$8000;



  (* Suche nach 2. Aufruf des Dekompressors ... *)
  position:=0;
  repeat
    if  (Mem[biossegment_f000:position+$00]=$e8) (* CALL ... *)

    and (Mem[biossegment_f000:position+$03]=$50) (* PUSH AX *)

    and (Mem[biossegment_f000:position+$04]=$ba) (* MOV DX,SEGMENT_PACK *)

    and (Mem[biossegment_f000:position+$07]=$b9) (* MOV CX,LŽNGE_EINGEPACKT *)

    and (Mem[biossegment_f000:position+$0a]=$e8) (* CALL DECO *)

    and (Mem[biossegment_f000:position+$0d]=$58) (* POP AX *)
     then
      begin
        quellsegment     :=MemW[biossegment_f000:position+$05]-$e000+biossegment_e000;
        laenge_eingepackt:=MemW[biossegment_f000:position+$08];
        Write(hexstr(MemW[biossegment_f000:position+$05],4),':0000 [',hexstr(laenge_eingepackt,4),'] -> ');
        aufruf(quellsegment,laenge_eingepackt,Seg(ziel^),laenge_ausgepackt);
        WriteLn('[',hexstr(laenge_ausgepackt,4),']');
        Assign(d,zielverzeichnis+hexstr(MemW[biossegment_f000:position+$05],4)+'0000.MRD');
        Rewrite(d,1);
        BlockWrite(d,ziel^,laenge_ausgepackt);
        Close(d);
      end;

    Inc(position);
  until position>$8000;

end.
