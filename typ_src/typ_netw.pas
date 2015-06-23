(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_netw;

interface

function netz_test(const laufwerk:char):boolean;
function subst_test(const laufwerk:char):boolean;

implementation

uses
  (*$IfDef VirtualPascal*)
  VpSysLow,
  (*$IfDef DPMI32*)
  dpmi32,
  dpmi32df,
  (*$EndIf*)
  (*$EndIf*)
  typ_var,
  typ_type,
  typ_eiau,
  typ_dat,
  typ_ausg,
  typ_varx,
  typ_spra;

const
  a32=chr(ord('A')-1+32);

type
  drive_flag_table_typ           =array['A'..a32] of byte;
  drive_connect_table_typ        =array['A'..a32] of byte;
  server_namen_tabelle_typ       =array[1..8] of array[1..48] of char;

var
  drive_flag_table_z            :^drive_flag_table_typ;
  drive_connect_table_z         :^drive_connect_table_typ;
  server_namen_tabelle_z        :^server_namen_tabelle_typ;
  installiert                   :boolean;

(*$IfDef DOS*)
function netz_test(const laufwerk:char):boolean;
  begin
    asm
      mov installiert,falsch
      mov ax,$ef01
      int $21
      cmp ax,0
      jnz @hole_drive_flag_table_ende

      mov installiert,wahr

      mov word ptr [drive_flag_table_z+0],si
      mov word ptr [drive_flag_table_z+2],es

      mov ax,$ef02
      int $21
      mov word ptr [drive_connect_table_z+0],si
      mov word ptr [drive_connect_table_z+2],es

      mov ax,$ef04
      int $21
      mov word ptr [server_namen_tabelle_z+0],si
      mov word ptr [server_namen_tabelle_z+2],es

    @hole_drive_flag_table_ende:
    end;

    if installiert then
      begin
        if drive_connect_table_z^[laufwerk]>0 then
          begin
            ausschrift_v(textz_netw__Laufwerk^+laufwerk+':]');
            case drive_flag_table_z^[laufwerk] of
              $00:ausschrift(textz_netw__lw00^,beschreibung);
              $01:ausschrift(textz_netw__lw01^,beschreibung);
              $02:ausschrift(textz_netw__lw02^,beschreibung);
              $80:ausschrift(textz_netw__lw80^,beschreibung);
              $81:ausschrift(textz_netw__lw81^,beschreibung);
              $82:ausschrift(textz_netw__lw82^,beschreibung);
            else
                  ausschrift(textz_netw__lwxx^,beschreibung);
            end;
            ausschrift(textz_netw__Servernummer^+str0(drive_connect_table_z^[laufwerk]),beschreibung);
            ausschrift(textz_netw__Server^+server_namen_tabelle_z^[drive_connect_table_z^[laufwerk]],beschreibung);
            netz_test:=wahr;
          end
        else
          netz_test:=falsch
      end
    else
      netz_test:=falsch;
  end;
(*$EndIf*)

(*$IfDef OS2*)
function netz_test(const laufwerk:char):boolean;
  begin
    {funktion_nicht_implementiert('Novell Netware Test');}
    netz_test:=false;
  end;
(*$EndIf*)

(*$IfDef DPMI*)
function netz_test(const laufwerk:char):boolean;
  begin
    {funktion_nicht_implementiert('Novell Netware Test');}
    netz_test:=false;
  end;
(*$EndIf*)

(*$IfDef DPMI32*)
function netz_test(const laufwerk:char):boolean;
  var
    regs:real_mode_call_structure_typ;
  begin
    netz_test:=falsch;

    with regs do
      begin
        init_register(regs);
        ax_:=$ef01;
        intr_realmode(regs,$21);
        if ax_=0 then
          begin
            drive_flag_table_z:=Ptr(es_ shl 4+si_);

            ax_:=$ef02;
            intr_realmode(regs,$21);
            drive_connect_table_z:=Ptr(es_ shl 4+si_);

            ax_:=$ef04;
            intr_realmode(regs,$21);
            server_namen_tabelle_z:=Ptr(es_ shl 4+si_);

            if drive_connect_table_z^[laufwerk]>0 then
              begin
                ausschrift_v(textz_netw__Laufwerk^+laufwerk+':]');
                case drive_flag_table_z^[laufwerk] of
                  $00:ausschrift(textz_netw__lw00^,beschreibung);
                  $01:ausschrift(textz_netw__lw01^,beschreibung);
                  $02:ausschrift(textz_netw__lw02^,beschreibung);
                  $80:ausschrift(textz_netw__lw80^,beschreibung);
                  $81:ausschrift(textz_netw__lw81^,beschreibung);
                  $82:ausschrift(textz_netw__lw82^,beschreibung);
                else
                      ausschrift(textz_netw__lwxx^,beschreibung);
                end;
                ausschrift(textz_netw__Servernummer^+str0(drive_connect_table_z^[laufwerk]),beschreibung);
                ausschrift(textz_netw__Server^+server_namen_tabelle_z^[drive_connect_table_z^[laufwerk]],beschreibung);
                netz_test:=wahr;
              end;
          end;
      end;
  end;
(*$EndIf*)

(*$IfDef LNX_ODER_W32*)
function netz_test(const laufwerk:char):boolean;
  begin
    {funktion_nicht_implementiert('Novell Netware Test');}
    netz_test:=false;
  end;
(*$EndIf*)

(*$IfDef DOS*)
function subst_test(const laufwerk:char):boolean;
  var
    laufwerk_doppelpunkt:string[4];
    name:string[130];
  begin
    subst_test:=falsch;
    laufwerk_doppelpunkt:=laufwerk+':\'+#0;
    FillChar(name,SizeOf(name),#0);
    asm
      push si
        push ds
          push di
            push es
              lea si,laufwerk_doppelpunkt
              lea di,name
              inc si
              inc di
              mov bx,ss
              mov ds,bx
              mov es,bx
              mov ah,$60
              int $21
              jnc @weiter

              mov byte [di],0

              @weiter:
            pop es
          pop di
        pop ds
      pop si
    end;
    if (name[1]=#0)
    or (upcase(name[1])=upcase(laufwerk))
     then
      exit;

    ausschrift_v(textz_netw__Laufwerk^+laufwerk+':]');
    (* C:\EXTRA\ -> C:\EXTRA, K:\ -> K: *)
    exezk:=puffer_zu_zk_e(name[1],'\'#0,128);
    if exezk[Length(exezk)]='\' then
      Dec(exezk[0]);
    ausschrift(textz_netw__Verweis_auf^+exezk,beschreibung);
    subst_test:=wahr;
  end;
(*$EndIf*)

(*$IfDef OS2*)
function subst_test(const laufwerk:char):boolean;
  begin
    subst_test:=falsch;
  end;
(*$EndIf*)

(*$IfDef DPMI*)
function subst_test(const laufwerk:char):boolean;
  begin
    subst_test:=falsch;
  end;
(*$EndIf*)

(*$IfDef DPMI32*)
function subst_test(const laufwerk:char):boolean;
  var
    eingabe,ausgabe:array[0..260] of char;
  begin
    subst_test:=falsch;
    FillChar(eingabe,SizeOf(eingabe),0);
    FillChar(ausgabe,SizeOf(ausgabe),0);
    eingabe[0]:=laufwerk;
    eingabe[1]:=':';
    eingabe[2]:='\';
    SysFileUNCExpand(ausgabe,eingabe);

    if (ausgabe[0]=#0)
    or (UpCase(ausgabe[0])=UpCase(eingabe[0]))
     then
      exit;

    ausschrift_v(textz_netw__Laufwerk^+laufwerk+':]');
    (* C:\EXTRA\ -> C:\EXTRA, K:\ -> K: *)
    exezk:=puffer_zu_zk_e(ausgabe,'\'#0,SizeOf(ausgabe));
    if exezk[Length(exezk)]='\' then
      Dec(exezk[0]);
    ausschrift(textz_netw__Verweis_auf^+exezk,beschreibung);
    subst_test:=wahr;
  end;
(*$EndIf*)

(*$IfDef LNX_ODER_W32*)
function subst_test(const laufwerk:char):boolean;
  begin
    subst_test:=falsch;
  end;
(*$EndIf*)


end.

