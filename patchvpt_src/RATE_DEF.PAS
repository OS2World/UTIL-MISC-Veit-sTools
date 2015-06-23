program rate_def;

uses spra_ein;

begin
  sprachtabellenkopf(true,true,false,false);


  sprach_eintrag('Messen_der_Bildwiederholrate_bitte_warten_',
                 'measuring video refrash rate * please wait ...',
                 'Messen der Bildwiederholrate * bitte warten ...',
                 '',
                 '');

  sprach_eintrag('Entweder_sehr_guter_Wert_oder_Fehler_durch_Betriebssystem_oder_Geraete_',
                 'either very good result or error in OS or hardware !',
                 'Entweder sehr guter Wert oder Fehler durch Betriebssystem oder Ger„te !',
                 '',
                 '');

  sprach_eintrag('Sehr_schlechter_Wert_oder_Fehler_',
                 'very bad result or error !',
                 'Sehr schlechter Wert oder Fehler !',
                 '',
                 '');
{
  sprach_eintrag('',
                 '',
                 '',
                 '',
                 '');
}

  schreibe_sprach_datei('rate$$$.001','rate$$$.002','sprach_modul','sprach_start','^string');
end.
