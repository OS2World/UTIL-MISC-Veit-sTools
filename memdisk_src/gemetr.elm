From oliver.rick@oor2.de Fri May 17 15:33:00 2002
Return-path: <oliver.rick@oor2.de>
Received: from pigeon.Informatik.TU-Cottbus.DE (pigeon [141.43.3.7])
	by su.Informatik.TU-Cottbus.DE (8.9.3/8.9.3/Informatik-19990708) with ESMTP id PAA17662
	for <vk@su.Informatik.TU-Cottbus.DE>; Fri, 17 May 2002 15:33:32 +0200 (MET DST)
Received: from mx0.gmx.net (mx0.gmx.net [213.165.64.100])
	by pigeon.Informatik.TU-Cottbus.DE (8.10.2+Sun/8.10.2) with SMTP id g4HDPZJ28229
	for <vk@informatik.tu-cottbus.de>; Fri, 17 May 2002 15:25:35 +0200 (MEST)
Received: (qmail 7279 invoked by alias); 17 May 2002 13:30:06 -0000
Delivered-To: GMX delivery to veit.kannegieser@gmx.de
Received: (qmail 7249 invoked by uid 0); 17 May 2002 13:30:05 -0000
Received: from mx2.ngi.de (213.191.74.84)
  by mx0.gmx.net (mx009-rz3) with SMTP; 17 May 2002 13:30:05 -0000
Received: (qmail 25298 invoked from network); 17 May 2002 13:30:03 -0000
Received: from unknown (HELO koln-d9b9f7bd.pool.mediaWays.net) ([217.185.247.189]) (envelope-sender <oliver.rick@oor2.de>)
          by 0 (qmail-ldap-1.03) with SMTP
          for <Veit.Kannegieser@gmx.de>; 17 May 2002 13:30:03 -0000
To: Veit.Kannegieser@gmx.de (Veit Kannegieser)
From: oliver.rick@oor2.de (Oliver Rick)
Subject: Re: MemDisk
Date: Fri, 17 May 2002 15:21:30 +0200
In-Reply-To: <200205161659.SAA04290@pu20.Informatik.TU-Cottbus.DE>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: oliver.rick@oor2.de (Oliver Rick)
Reply-To: orick@netcologne.de
X-Mailreader: GoldED/2 3.0.1
User-Agent: VSoup v1.2.9.48Beta [OS/2]
Message-ID: <20020517133006.7271gmx1@mx009-rz3.gmx.net>
X-Resent-By: Forwarder <forwarder@gmx.de>
X-Resent-For: veit.kannegieser@gmx.de
X-Resent-To: vk@Informatik.TU-Cottbus.de
Status: OR

Hallo, Veit!

Am 16.05.02 schrieb Veit Kannegieser an orick@netcologne.de:

> 3200/6400 ist Sektorgroesse/KiB ich weiss also wo ich suchen muss.
> Die Standard-Zylinder werte in MemDisk stehen im Quelltext (100/4/32),
> MemCFG berechnet die Geometrie so, das eine Spur moeglichst gross ist,
> ohne ueber 1024 Zylinder zu kommen und moeglichst bei 32 Sektoren
> je Spur zu bleiben. Ich werde also die Standardwerte auf 400/1/32
> im Quelltext aendern. Ausserdem kommt die Moeglichkeit der Berechnung
> in Abhaengigkeit des vorhandenen Speichers dazu.
> Ich denke ueber eine Formel x+Speichergroesse*y/1024 mit oberen
> und unteren Schranken fuer die Groesse. Der jetzige Fall waere
> also x=6400 y=+-0.

Dem KISS-Prinzip folgend würde ich vorschlagen entweder die alte
Adaptec-Translation mit 16 Köpfen/32 Sektoren (ohne I13X 1 GiB mit exakten
1 MiB/Zylinder) und 4 Zylindern Default (reicht für 1-Disketten-Lösung ohne
OS2CSM-Wizbang mit 30 verschiedene HAB-Treibern, ich kann dann ja 6 oder 7
nehmen, wie es gerade paßt) oder gleich die 255/63 mit einem Zylinder als
Default oder das alte 16/63 Limit, mit dem wären ohne I13X bis 504 MiB
Luft, festzulegen. Ich denke nicht, daß MemDisk bis in KiB flexibel sein
muß.

Ich krieg's einfach nicht gebacken. Ich habe VDISK jetzt 'mal durch eine
"echte" FAT-Partition (1 Zylinder/7,8 MiB groß) ersetzt. Immer noch
SYS1475/2027.
Könnte das in etwa das gleiche Problem sein, daß ich vor ein paar Monaten
mit OS2CSM hatte? Damals hattest Du mir eine modifizierte OS2CSM.D
geschickt. Da wurden Registerinhalte angezeigt und ich sollte irgendwelche
Speicheradressen prüfen. Danach hattest Du irgendeine Anfangsadresse
geändert, und dann klappte alles.

"Mein" OS2BOOT ist jedenfalls mit dem aus Deinen Testdisketten binär
identisch. Es wird als erste Datei ein- und ausgepackt. #%*$@&! Mir fällt
sonst nichts mehr ein ...

   /Olli/
-- 
WarpUpdates Deutschland/International
http://www.warpupdates.mynetcologne.de/

