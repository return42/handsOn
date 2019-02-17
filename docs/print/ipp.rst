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

IPP gibt es schon sehr lange, den ersten Entwurf (Proposal) gab es 1996 von
Novell und Xerorx und 1999 wurde IPP 1.0 verabschiedet.  Alle bekannten
Drucker-Protokolle wie sie von HP, Microsoft oder Apple (Airprint_) erdacht
wurden basieren mehr oder minder auf dem (alten) IPP.  Inzwischen wird IPP von
der PWG_ voran getrieben.  Die 2.x Versionen des IPP gibt es (erst) seit 2015.

Da es die IPP-Versionen V-2.0, V-2.1 und V-2.2 gibt könnte der Eindruck
entstehen, dass die V-1.1 veraltet ist.  Das ist aber nicht der Fall, die
``2.x`` Versionen adressieren lediglich die Anwendungsbereiche (siehe Kapitel
*Introduce* in `IPP Version 2.0, 2.1, and 2.2`_).  Für die typischen
Büro-Drucker kommt **IPP V2.0** zur Anwendung.

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
(z.B. Hostname `mf623cn <https://mf623cn/portal_top.html>`__), dann müssten wir
ihn eigentlich über IPP finden können.  Die Implementierung dazu ist das
Kommando :man:`ippfind`::

  $ ippfind
  ipp://MF623Cn.local:80/ipp/print

Cool, einfacher geht es ja wirklich nicht mehr!

.. _get-printer-attributes:

``ipptool get-printer-attributes``
==================================

Nun wollen wir mal schauen welche Eigenschaften der Drucker über das ``ipp://``
Protokoll anbietet.  Dazu gibt es das Kommando :man:`ipptool`, dem man ein
*printer testfile* übergibt::

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


IPP Kinderkrankheiten
=====================

Schaut man sich mal die gesamte Ausgabe des :ref:`get-printer-attributes` an
(:origin:`MF623Cn-attributes.txt <docs/print_scan/MF623Cn-attributes.txt>`),
dann erkennt man schon die ersten *Kinderkrankheiten*::

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

.. note::

   Die Verabschiedung der IPP ``2.x`` Versionen ist aus dem Jahre 2015, also
   noch recht *frisch*!  Es braucht auch immer etwas Zeit, bis so ein Standard
   dann vollständig und ohne Kinderkrankheiten in die (neuen) Geräte und
   Distributionen eingeflossen ist.  Weshalb man mit älteren Druckern und
   älteren Systemen i.d.R. mehr Probleme haben wird.  Das ist auch Stand heute
   (02/2019) noch deutlich *spürbar*.  `IPP Everywhere`_ resp.
   :ref:`driverless-printing` gibt es in Ubuntu seit 17.04.


Einschätzungen zur IPP-Fähigkeit
================================

Die modernen netzwerkfähigen Drucker sollten i.d.R. alle IPP unterstützen (laut
PWG 98% der aktuell verkauften Drucker).  Auch wenn das, wie bei dem Canon
MF623Cn_ in den :ref:`technischen Angaben <figure-MF623Cn-printer-spec>` nicht
explizit angegeben wird.  I.d.R. kann man davon ausgehen, dass Beispielsweise
alle moderneren `AirPrint Drucker <https://support.apple.com/en-us/HT201311>`_
IPP 2.0 unterstützen (moderne HP i.d.R. auch).  So lange der Hersteller aber
keine genauen Angaben macht und der Drucker auch nicht bei den:

- `IPP Everywhere™ Self-Certified Printers <http://www.pwg.org/dynamo/eveprinters.php>`_

zu finden ist, kann man über dessen IPP Unterstützung nichts genaueres sagen.
Zumindest nicht, solange man es nicht wenigstens mit :man:`ippfind` mal gestetet
hat.  Es ist schon ein kleines Dilemma, dass so wenige (eigentlich IPP fähige
Drucker) bisher zertifiziert sind (s.a.  `Mail Thread
<https://lists.debian.org/debian-printing/2016/12/msg00160.html>`_).  Der
Drucker MF623Cn_ ist aus Mitte 2016, damit gehört er (vermute ich mal) zu der
ersten Generation, die (offiziell) IPP V2.0 unterstützt.  D.h. aber nicht, das
mit IPP V2.0 Canon nun auch seine Drucker neu erfunden hätte.  Wenn man die
diversen Macken dieser Canon-Implementierungen sieht, dann kann man eigentlich
nur zu dem Urteil kommen, dass die Netzwerk-Drucker -- die eh schon IPP 1.0
konnten -- etwas lieblos um IPP V2.0 erweitert wurden.  Das hat man dann in eine
Firmware gegossen, die dann auf jedem Drucker-Modell mehr oder minder gleich
(schlecht) betrieben wird.  Nachfolger des MF623Cn_ wäre der MF631Cn_ aus 2018,
der hat aktuell allerdings auch die gleiche Firmware 3.05::

  printer-firmware-name (nameWithoutLanguage) = IPP
  printer-firmware-string-version (textWithoutLanguage) = 03.05
  printer-firmware-version (octetString) = 0305

Das ist alles nur ein einziger liebloser Klumpen Software, den Canon da auf die
Drucker und Betriebssysteme ballert.  Es ist ein Trauerspiel zu sehen, wie unter
dem eigentlich *großen und beliebten* Namen "Canon" gearbeitet wird.  Aber es
scheint ein Trend der Labels und Marken zu sein, der gute Name wird runter
gewirtschaftet (*Kärcher taugt heute auch nichts mehr*).


Einschätzungen zur PDL-Fähigkeit
================================

Früher war das Drucken mit PostScript (PDL) fähigen Druckern unter Linux
immer möglich.  Diese sind aber i.d.R. in der untersten Preisklasse der
Laserdrucker kaum *zu haben*.  Inzwischen (mit IPP) werden aber Raster-Formate
und PDF bevorzugt und die Bedeutung von PostScript wird durch die Bedeutung von
PDF als `PDL (wiki)`_ ersetzt.

In der Spezifikation des MF631Cn_ ist u.A. zu lesen: *Drucken von USB
Speicherstick (JPEG, TIFF, PDF)*.  Wenn ein Drucker diese Formate *direkt*
drucken kann, dann unterstützt er diese Formate i.d.R. auch als `PDL (wiki)`_.
So konnte der Vorläufer MF623Cn_ noch kein PDF direkt drucken, unterstützt es
also auch nicht als PDL.  Der MF631Cn_ hingegen kann PDF direkt drucken, dann
wird er es auch als PDL unterstützen.
