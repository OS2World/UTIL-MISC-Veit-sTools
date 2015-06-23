program textrein_def;

uses spra_ein;

begin
  sprachtabellenkopf(true,true,false,false);

  sprach_eintrag('Eingabedatei_Ausgabedatei',
                 ' <inputfile> [ <outputfile> ]',
                 ' <Eingabedatei> [ <Ausgabedatei> ]',
                 '',
                 '');

  sprach_eintrag('beide_Namen_sollten_verschieden_sein',
                 'both names should be differ !',
                 'beide Namen sollten verschieden sein !',
                 '',
                 '');

  sprach_eintrag('Ausgabedatei_existiert_schon',
                 'outpufile alredy exist',
                 'Ausgabedatei existiert schon',
                 '',
                 '');

  sprach_eintrag('Fehler',
                 'error ',
                 'Fehler ',
                 '',
                 '');

  sprach_eintrag('beim_OEffnen_der_Eingabedatei',
                 ' on opening inputfile !',
                 ' beim ™ffnen der Eingabedatei !',
                 '',
                 '');

  sprach_eintrag('beim_OEffnen_der_Ausgabedatei',
                 ' on opening outpufile !',
                 ' beim ™ffnen der Ausgabedatei !',
                 '',
                 '');

  sprach_eintrag('ist_keine_Textdatei_Abrruch',
                 'is no textfile -> abort',
                 'ist keine Textdatei->Abrruch',
                 '',
                 '');

  sprach_eintrag('Bearbeite_Zeile',
                 'processing line ',
                 'Bearbeite Zeile ',
                 '',
                 '');

  sprach_eintrag('zu',
                 ' converted to ',
                 ' zu ',
                 '',
                 '');

  sprach_eintrag('Byte_umgewandelt_',
                 ' byte.                          ',
                 ' Byte umgewandelt.              ',
                 '',
                 '');

  sprach_eintrag('Schreibfehler',
                 'write error',
                 'Schreibfehler',
                 '',
                 '');


{
  sprach_eintrag('',
                 '',
                 '',
                 '',
                 '');
}
  schreibe_sprach_datei('TEXT$$$.001','TEXT$$$.002','sprach_modul','sprach_start','^string');
end.
