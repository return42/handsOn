.. -*- coding: utf-8; mode: rst -*-
.. include:: ../print_scan_refs.txt

.. _IPP_intro:

====================
IPP & IPP Everywhere
====================

`IPP (wiki)`_ ist das *Internet Printing Protocol*.  IPP_ ist -- wie der Name
schon sagt -- ein Internet-Protokoll.  *Genauer:* es ist eine Erweiterung des
bekannten HTTP 1.1 Protokolls wie man es von *Internetseiten* kennt und es wird
vom Drucker i.d.R. auf den gleichen Ports `80` (HTTP) und `443` (HTTPS)
angeboten.  Der MF623Cn_ unterstützt IPP und wie alle IPP fähigen Drucker muss
er als *Drucksprache* mindestens ``image/jpeg`` und ``image/pwg-raster``
verstehen (s.a. `IPP Mini Tutorial`_).

.. code-block:: none

   1. There are no longer any "proprietary" printer languages exclusive for a
      printer. IPP-enabled printers MUST support PWG Raster and JPEG as print
      job spooling formats and MUST support PDF as a print job spooling format
      when the printer uses IPP/2.1 and IPP/2.2. (PDF support is optional for a
      printer using IPP/2.0).

   2. IPP-enabled printers are able to respond to queries investigating about
      their capabilities. (Can they print duplex? Can they print in color? Do
      they support stapling? Have they paper with A3 dimensions loaded? How much
      ink do they have left? etc.pp.)

Damit hat man also die Möglichkeit die Eigenschaften des Druckers über IPP_ zu
ermitteln.  Das wollen wir gleich mal machen, aber vorher wollen wir uns nochmal
`IPP Everywhere`_ anschauen, damit können Drucker im Netzwerk *gefunden* werden.

Da es die IPP-Versionen V-2.0, V-2.1 und V-2.2 gibt könnte der Eindruck
entstehen, dass die V-1.1 veraltet ist.  Das ist aber nicht der Fall, die
``2.x`` Versionen adressieren lediglich die Anwendungsbereiche (siehe Kapitel
*Introduce* in `IPP Version 2.0, 2.1, and 2.2`_).  Für die typischen
Büro-Drucker kommt **IPP V2.0** zur Anwendung.

.. note::

   Die Verabschiedung der IPP ``2.x`` Versionen ist aus dem Jahre 2015, also
   noch recht *frisch*!  Es braucht auch immer etwas Zeit, bis so ein Standard
   dann vollständig und ohne Kinderkrankheiten in die (neuen) Geräte und
   Distributionen eingeflossen ist.  Weshalb man mit älteren Druckern und
   älteren Systemen i.d.R. mehr Probleme haben wird.  Das ist auch Stand heute
   (02/2019) noch deutlich *spürbar*.  `IPP Everywhere`_ resp.
   :ref:`driverless-printing` gibt es in Ubuntu seit 17.04.


``ippfind``
===========

Drucker die über IP im Netzwerk bereit stehen, können über Avahi_ gefunden
werden.  `Avahi (git)`_ ist eine freie Implementierung von Zeroconf_, das
Pendant auf macOS ist Bonjour_ von Apple.  Aufgabe dieser Zeroconf Werkzeuge ist
es, Dienste welche im IP-Netz bereit stehen zu finden.  Avahi ist bereits auf
allen Linux Desktops eingerichtet.  Das einzige was man evtl. noch festhalten
kann ist, dass sowohl CUPS als auch IPP sich des Avahi bedienen um Drucker im
Netzwerk automatisch zu finden.

Wenn der Drucker über WLAN oder LAN angeschlossen ist und eine IP erhalten hat
(hier im Beispiel sei das die URL https://mf623cn/portal_top.html), dann müssten
wir ihn eigentlich über IPP finden können.  Die Implementierung dazu ist das
Kommando :man:`ippfind`::

  $ ippfind
  ipp://MF623Cn.local:80/ipp/print0

Cool, einfacher geht es ja wirklich nicht mehr!

``ipptool get-printer-attributes``
==================================

Nun wollen wir mal schauen welche Eigenschaften der Drucker über das ``ipp://``
Protokoll anbietet resp. anzeigt.  Dazu gibt es das Kommando :man:`ipptool`::

  $ ipptool -t -v \
        ipp://MF623Cn.local:80 \
	| /usr/share/cups/ipptool/get-printer-attributes.test \
	| grep 'document-format-supported\|ipp-versions-supported'

Die Ausgabe für den All-in-One Drucker MF623Cn_ :

.. code-block:: none

    ipp-versions-supported (1setOf keyword) = 2.0,1.1,1.0
    document-format-supported (1setOf mimeMediaType) = image/urf,application/octet-stream,image/jpeg,image/pwg-raster

Der hat also IPP V-2.0 und dazu hieß es ja schon oben im Zitat: *PDF support is
optional for a printer using IPP/2.0*.  Das deckt sich also mit den Annahmen zu
dem Drucker.  Auch die Formate ``image/jpeg`` und ``image/pwg-raster``, wie sie
von IPP 2.0 erwartet werden, bietet der Drucker an.  Mit ``image/urf`` bietet er
noch das Raster-Format von AirPrint_ an.  Die Definitionen zu den IPP Attributen
und Objekten sind bei IANA registriert, eine vollständige Liste gibt es hier:

- `IANA IIP Registration`_ z.B. `RFC8011 <https://tools.ietf.org/html/rfc8011>`_
  mit dem IPP V-1.1.

  - `document-format-supported <https://tools.ietf.org/html/rfc8011#section-5.4.22>`_
  - `ipp-versions-supported  <https://tools.ietf.org/html/rfc8011#section-5.4.14>`_



Einschätzungen zur IPP-Fähigkeit
================================

Die modernen netzwerkfähigen Drucker sollten i.d.R. alle IPP unterstützen, auch
wenn das, wie beim Canon MF623Cn_ in den :ref:`technischen Angaben
<figure-MF623Cn-printer-spec>` nicht explizit angegeben wurde.  I.d.R. kann man
davon ausgehen, dass Beispielsweise alle moderneren `AirPrint Drucker
<https://support.apple.com/en-us/HT201311>`_ IPP unterstützen (moderne HP
i.d.R. auch).  So lange der Hersteller aber keine genauen Angaben macht und der
Drucker auch nicht bei den:

- `IPP Everywhere™ Self-Certified Printers <http://www.pwg.org/dynamo/eveprinters.php>`_

zu finden ist, weiß man über dessen IPP Unterstützung auch nichts was genaues.
Es ist momentan ein kleines Dilemma, dass so wenige, eigentlich IPP fähige
Drucker noch nicht zertifiziert sind -- siehe auch `Mail-Thread zu dem Thema
<https://lists.debian.org/debian-printing/2016/12/msg00160.html>`_.  Der Drucker
MF623Cn_ ist aus Mitte 2016, damit gehört er (vermute ich mal) zu der ersten
Generation, die diesen Standard unterstützt.  Nachfolger wäre der MF631Cn_, der
hat aktuell allerdings auch die gleiche Firmware 3.05::

  printer-firmware-name (nameWithoutLanguage) = IPP
  printer-firmware-string-version (textWithoutLanguage) = 03.05
  printer-firmware-version (octetString) = 0305

Bei der Spezifikation des MF631Cn_ ist u.A. zu lesen: *Drucken von
USB-Speicherstick (JPEG, TIFF, PDF)*. Dass lässt mich vermuten, dass es sich --
im Gegensatz zum MF623Cn_ -- um einen PDF-fähigen Drucker handelt.

Schaut man sich mal die gesamte Ausgabe an (:origin:`MF623Cn-attributes.txt
<docs/print_scan/MF623Cn-attributes.txt>`), dann erkennt man schon die ersten
*Kinderkrankheiten*::

  $ ipptool -t -v ipp://MF623Cn.local:80  /usr/share/cups/ipptool/get-printer-attributes.test
  ..
  printer-resolution-default (resolution) = 300dpi
  printer-resolution-supported (resolution) = 300dpi

Der Drucker behauptet also, dass er lediglich eine Auflösung von 300dpi hat:
`You are fake news! <https://www.youtube.com/watch?v=1IDF-8khS3w>`_.  Der
Drucker wird als 600dpi Drucker beworben und verfügt auch über diese Auflösung.
Diese und diverse andere fehlerhafte IPP-Angaben zu dem Drucker sind auch mit
ein Grund dafür, dass :ref:`driverless-printing` z.T. schlechte Druck-Ergebnisse
liefert (oder evtl. gar nicht funktioniert).

