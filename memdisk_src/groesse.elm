From oliver.rick@oor2.de Fri May 17 20:17:00 2002
Return-path: <oliver.rick@oor2.de>
Received: from pigeon.Informatik.TU-Cottbus.DE (pigeon [141.43.3.7])
	by su.Informatik.TU-Cottbus.DE (8.9.3/8.9.3/Informatik-19990708) with ESMTP id UAA19370
	for <vk@su.Informatik.TU-Cottbus.DE>; Fri, 17 May 2002 20:16:58 +0200 (MET DST)
Received: from mx0.gmx.net (mx0.gmx.net [213.165.64.100])
	by pigeon.Informatik.TU-Cottbus.DE (8.10.2+Sun/8.10.2) with SMTP id g4HI92J29689
	for <vk@informatik.tu-cottbus.de>; Fri, 17 May 2002 20:09:03 +0200 (MEST)
Received: (qmail 30227 invoked by alias); 17 May 2002 18:13:33 -0000
Delivered-To: GMX delivery to veit.kannegieser@gmx.de
Received: (qmail 30207 invoked by uid 0); 17 May 2002 18:13:32 -0000
Received: from mx2.ngi.de (213.191.74.84)
  by mx0.gmx.net (mx013-rz3) with SMTP; 17 May 2002 18:13:32 -0000
Received: (qmail 21919 invoked from network); 17 May 2002 18:13:31 -0000
Received: from unknown (HELO koln-d9b9f795.pool.mediaWays.net) ([217.185.247.149]) (envelope-sender <oliver.rick@oor2.de>)
          by 0 (qmail-ldap-1.03) with SMTP
          for <Veit.Kannegieser@gmx.de>; 17 May 2002 18:13:31 -0000
To: Veit.Kannegieser@gmx.de (Veit Kannegieser)
From: oliver.rick@oor2.de (Oliver Rick)
Subject: Re: MemDisk
Date: Fri, 17 May 2002 20:11:07 +0200
In-Reply-To: <200205171430.QAA17953@ep.Informatik.TU-Cottbus.DE>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: oliver.rick@oor2.de (Oliver Rick)
Reply-To: orick@netcologne.de
X-Mailreader: GoldED/2 3.0.1
User-Agent: VSoup v1.2.9.48Beta [OS/2]
Message-ID: <20020517181332.30215gmx1@mx013-rz3.gmx.net>
X-Resent-By: Forwarder <forwarder@gmx.de>
X-Resent-For: veit.kannegieser@gmx.de
X-Resent-To: vk@Informatik.TU-Cottbus.de
Status: OR

Hallo, Veit!

Am 17.05.02 schrieb Veit Kannegieser an orick@netcologne.de:

> Bei meinen Versuchen hat LVM die Partition erst ab Zylinder 4 angelegt.
> Ich werde es nochmal probieren, aber generell ist der Verlust der
> ersten Spur am geringsten, wenn die Spuren moeglichst klein sind.

Paßt doch <g>: 4 (Default) bis 1024 Zylinder/16 Köpfe, 32 Sektoren
jeweils fest, Größe auf ein MiB exakt. Die Details über Geometrie, Anzahl
Sektoren brauchst Du dann gar nicht anzeigen, nur die Größe in MiB.

   /Olli/
-- 
WarpUpdates Deutschland/International
http://www.warpupdates.mynetcologne.de/

