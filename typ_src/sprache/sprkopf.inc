(*$IFDEF SPRDE*)
procedure sprachtabellenkopf_erweitert(const z0:string;b:boolean);
  begin
    spr2_ein.sprachtabellenkopf_erweitert('DE',b);
  end;
  

procedure sprach_eintrag04(const bez,zken,zkde,zk3,zk4:string);
  begin
    spr2_ein.sprach_eintrag04(bez,zkde,'','','');
  end;
(*$ENDIF*)

procedure sprkopf;
  begin
    sprachtabellenkopf_erweitert(
                     +'EN'
                     +'DE'
                     +''
                     +'',
                     false);
  end;

procedure sprkopf2;
  begin
    sprachtabellenkopf_erweitert(
                     +'EN'
                     +'DE'
                     +''
                     +'',
                     true);
  end;
