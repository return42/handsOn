.. -*- coding: utf-8; mode: rst -*-

.. include:: ../print_scan_refs.txt

.. _cups_canon:

==========================
CUPS, IPP & Canon (UFR-II)
==========================

  Wir beschäftigen uns hier mit CUPS und Netzwer-Druckern, also solche, die über
  WLAN oder LAN im Netzwerk zur Verfügung stehen (Scan siehe :ref:`scan_linux`).
  Es geht um generische Druckertreiber, IPP & *driverless printing* am Beispiel
  eines Canon Druckers.  Das Canon Beispiel dient (leider immer noch) als gutes
  Beispiel, um aufzuzeigen wann evtl. ein proprietärer Treiber
  (:ref:`canon_urf`) erforderlich werden kann und wie man den installiert ohne
  sich den ganzen Rotz von Canon im System einzuverleiben.


Die Drucker-Verwaltung unter Linux ist das Common Unix Printer System `CUPS
(wiki)`_ [`git <https://github.com/apple/cups>`_], welche i.d.R. in jedem Linux
Desktop-System bereits vorinstalliert ist.  Auf Server System ist CUPS ggf. noch
nicht installiert, kann aber recht einfach installiert werden::

   sudo apt-get install cups cups-client cups-bsd

CUPS unterstützt 2D (Papier) und ab V2.1 auch 3D Druck (s.a `IPP 3D`_).  Wie das
**S**\ *ystem* in CUP\ **S** bereits andeutet handelt es nicht um einen
*schlichten* Drucker Treiber sondern um ein *Druck-System*, das Dienste rund um
das Thema "Drucken" im Netzwerk bereit stellt.  Die Idee ist, dass man alle
Drucker und Druck-Funktionen in einem Dienst vereint (der Server) und die
Clients (Desktop Systeme, mobile Geräte etc.) über diesen Dienst ihre
Druck-Anforderungen abwickeln, ohne das man auf jedem dieser Geräte einen
Druckertreiber oder eine spezielle Druckfunktion installieren muss.

Im Backend des CUPS, werden die Druckertreiber registriert, da bietet CUPS
z.T. generische Treiber an, die i.d.R. schon sehr gut funktionieren.  Alle
halbwegs modernen Netzwerk-Drucker unterstützen das *Internet Printing Protocol*
(IPP_), welches auch CUPS implementiert.  Das IPP ist ein -- wie der Name schon
sagt -- ein Internet-Protokoll.  *Genauer*: es ist eine Erweiterung des
bekannten HTTP 1.1 Protokolls wie man es für *Internetseiten* kennt und läuft
i.d.R. auf den gleichen Ports `80` (HTTP) und `443` (HTTPS).

Vor dem Backend, also *auf dem Weg hin zu den Druckern* gibt es sogenannte
CUPS-Filter, welche die Druck-Daten der Clients so aufbereiten, dass der Drucker
an den sie gerichtet werden diese verstehen kann.  Hier in diesem Artikel wird
beispielsweise ein Canon Drucker eingerichtet, der bietet zwar das IPP_,
*spricht* aber weder `Postscript (wiki)`_ noch PDF_.  Als Druckersprache kennt
der nur UFR-II:

.. figure:: MF623Cn-printer-spec.png

Was hier in den technischen Angaben des Druckers nicht zu lesen ist: der Drucker
beherrscht auch IPP_ und IPP fähige Drucker als Drucksprache mindestens JPEG
verstehen müssen (s.a.  `What is IPP
<https://github.com/apple/cups/wiki/IPP-(Everywhere)-Mini-Tutorial>`_).

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

Drucker die über IP im Netzwerk bereit stehen, können über Avahi_ gefunden
werden.  `Avahi (git)`_ ist eine freie Implementierung von Zeroconf_, das
Pendant auf macOS ist Bonjour_ von Apple.  Aufgabe dieser Zeroconf Werkzeuge ist
es, Dienste welche im IP-Netz bereit stehen zu finden.  Das praktische an Avahi:
es ist eh schon auf allen Linux Desktops eingerichtet.  Das einzige was man
evtl. noch festhalten kann ist, dass sowohl CUPS als auch IPP sich des Avahi
bedienen um Drucker im Netzwerk automatisch zu finden:

  .. hint::

     IPP ``2.x`` wurde im Jahre 2015 verabschiedet und `IPP Everywhere`_
     resp. *driverless printing* gibt es in Ubuntu seit 17.04.

Wenn der Drucker über WLAN oder LAN angeschlossen ist und eine IP erhalten hat
(https://mf623cn/portal_top.html), dann müssten wir ihn eigentlich über IPP
finden können.  Die Implementierung dazu ist das Kommando :man:`ippfind`::

  $ ippfind
  ipp://MF623Cn.local:80/ipp/print

Cool, einfacher geht es ja wirklich nicht mehr!  Nun wollen wir mal schauen
welche Eigenschaften der Drucker über das ``ipp://`` Protokoll anbietet
resp. anzeigt.  Dazu gibt es das Kommando :man:`ipptool`::

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

Da es die IPP-Versionen V-2.0, V-2.1 und V-2.2 gibt könnte der Eindruck
entstehen, dass die V-1.1 veraltet ist.  Das ist aber nicht der Fall, die
``2.x`` Versionen adressieren lediglich die Anwendungsbereiche (siehe Kapitel
*Introduce* in `IPP Version 2.0, 2.1, and 2.2`_).  Für die typischen
Büro-Drucker kommt IPP V2.0 zur Anwendung.

.. note::

   Die Verabschiedung der IPP ``2.x`` Versionen ist aus dem Jahre 2015, also
   noch recht *frisch*!  Es braucht auch immer etwas Zeit, bis so ein Standard
   dann vollständig und ohne Kinderkrankheiten in die (neuen) Geräte und
   Distributionen eingeflossen ist.

Der Drucker MF623Cn_ ist aus Mitte 2016, damit gehört (vermute ich mal) zu der
ersten Generation, die diesen Standard unterstützt.  Nachfolger wäre der
MF631Cn_, der hat aktuell allerdings auch die gleiche Firmware 3.05::

  printer-firmware-name (nameWithoutLanguage) = IPP
  printer-firmware-string-version (textWithoutLanguage) = 03.05
  printer-firmware-version (octetString) = 0305

Bei der Spezifikation des MF631Cn_ ist u.A. zu lesen: *Drucken von
USB-Speicherstick (JPEG, TIFF, PDF)*. Dass lässt mich vermuten, dass es sich --
im Gegensatz zum MF623Cn_ -- um einen PDF-fähigen Drucker handelt.

Schaut man sich mal die gesamte Ausgabe an (:download:`MF623Cn-attributes.txt`),
dann wird sieht man schon die ersten *Kinderkrankheiten*::

  $ ipptool -t -v ipp://MF623Cn.local:80  /usr/share/cups/ipptool/get-printer-attributes.test
  ..
  printer-resolution-default (resolution) = 300dpi
  printer-resolution-supported (resolution) = 300dpi

Der Drucker behauptet also, dass er eine Auflösung von 300dpi hat, was man wohl
eher als `You are fake news!  <https://www.youtube.com/watch?v=1IDF-8khS3w>`_
einstufen kann.  Der Drucker wird als 600dpi Drucker beworben und verfügt auch
über diese Auflösung.  Diese und diverse andere fehlerhafte IPP-Angaben zu dem
Drucker sind auch mit ein Grund dafür, dass driverless-printing_ z.T. schlechte
Druck-Ergebnisse liefert (oder evtl. gar nicht funktioniert).

In einer Standard Installation des Ubuntu (18.04) resp. Debian Desktop Systems
(mit CUPS) müsste einem der Drucker bereits im Setup unter "Geräte" angeboten
werden.  Alternativ kann man dort auch auf *"Zusätzliche Druckereinstellungen"*
drücken, womit dem das Programm ``system-config-printer`` gestartet wird.  In
dem Fenster kann man *"Hinzufügen"* klicken und über einen geführten Dialog den
Drucker einrichten.  Hier beim MF623Cn wurde der Drucker mit dem Treiber::

  "CNMF620C Series, driverless"

eingerichtet.  Zu sehen im GNOME-Setup unter *Geräte/Drucker* und über einen
Klick auf *Zahnrad / Drucker-Details*.  Den *driverless* Drucker sollte man mal
testen.  Mit einem modernen PDF-fähigen Drucker (``application/pdf``) von einem
Hersteller, der IPP beherrscht wird man vermutlich schon respektable Erzeugnisse
anfertigen können.

Beim MF623Cn gibt es allerdings noch einige Kinderkrankheiten.  In solchen
Fällen gibt es zwei Möglichkeiten.

 1. man installiert sich den **proprietären** Druckertreiber des Herstellers
    (sofern für Linux vorhanden) und schaut sich Druck-Ergebnisse damit an.

 2. Man steigt etwas tiefer in die Materie CUPS_ (-Filter) und ggf. IPP_ ein und
    richtet sich eine eigene `PPD (wiki)`_ ein.

Mit CUPS_ kann man für den physikalisch gleichen Drucker mehrere unabhängige
Drucker-Setups einrichten, so kann man beispielsweise ein bestehendes Setup auch
kopieren und dann verändern.  Diese Drucker-Setups sind aus Sicht der Programme
voneinander unabhängige Drucker.  Man braucht also sein *funktionierendes* Setup
erst mal nicht *anfassen*, wenn man mal was ausprobieren möchte.


CUPS-Filter
===========

ToDo

- `CUPS-Server PPD <http://localhost:631/help/ref-ppdcfile.html>`_
- AirPrint Drucker: https://support.apple.com/en-us/HT201311
- Thread zu IPP: https://lists.debian.org/debian-printing/2016/12/msg00160.html


.. _canon_urf:

MF-620C Serie URF-II
====================

Die moderneren Canon Drucker unterstützen Ultra Fast Renderer (UFR) welches man
sich über einen **proprietären** Treiber auch auf dem PC installieren kann.  Die
Linux Treiber für die Drucker der MF620C Serie gibt es bei Canon:

- https://support-asia.canon-asia.com/contents/ASIA/EN/0100924010.html

Dort sind auch Installationsanleitungen gegeben, diesen sollte man **nicht**
folgen: **Die Linux Pakete von Canon sind schon immer dafür bekannt, diversen
Schrott zu installieren**.  Das gilt sowohl für die Druck- als auch für die
SCAN- Funktionen.  Es empfiehlt sich von daher nur die nötigsten Sachen (die
binären Treiber und die PPDs) aus dem Treiber-Download zu installieren und das
ist auch ganz einfach: In den ``linux-UFRII-drv-v{xxx}-uken.tar.gz`` Archiven gibt
es zwei, max. drei Pakete die man installieren muss, mehr bitte nicht:

- ``cndrvcups-common_{4.10}-1_amd64.deb``
- ``cndrvcups-ufr2-uk_{3.70}-1_amd64.deb``
- ``cndrvcups-utility_{1.10}-1_amd64.deb`` (funktioniert i.d.R nicht)

Die ``.tar.gz`` Datei im Download-Ordner auspacken (über rechte Maustaste *"Hier
entpacken"*).  In dem dann angelegten Ordner muss man sich etwas nach unten
*durchklickern*: ``64-bit_Driver/Debian``.  Dort sieht man dann auch schon die
`Debian Pakte <https://de.wikipedia.org/wiki/Debian_Package_Manager>`_ mit der
Dateiendung ``.deb``.  Diese kann man mit eine *Doppelklick* einfach
installieren.

Leider ist die Installation damit nicht erledigt, da Canon seit jeher unfähig
ist, echte 64-bit Bibliotheken zu compilieren: in den mit ``amd64``
gekennzeichneten Paketen ist der *UFRII-Closed-Source-Treiber* in Form von
32-Bit Bibliotheken enthalten, die wiederum auf anderen 32-Bit Bibliotheken des
Betriebssystems aufbauen.  Welche aber auf dem (eigenen) 64-Bit Betriebssystem
i.d.R. nicht zu erwarten sind.

Normalerweise kann der Paket-Ersteller solche Abhängigkeiten in den ``.deb``
beschreiben und dann würde der Paket-Manager darauf reagieren können, aber auch
dazu ist Canon als Paket-Ersteller seit jeher dazu nicht in der Lage.  Mit dem
Effekt, dass der Anwender mal wieder Blutdruck bekommt, weil *Drucken nicht
funktioniert*, es aber er auch keine hilfreichen Fehlermeldungen gibt.

Diese Abhängigkeiten zu den 32-Bit Bibliotheken müssen wir manuell installieren
(i.d.R. muss man das auch, wenn man die Installation-Anweisungen von Canon
befolgen würde).  Man installiert daher zuerst die benötigten 32-Bit
Bibliotheken::

  sudo apt-get install lib32stdc++6 libxml2:i386

Bei moderneren Druckern, sollte der Drucker nun automatisch gefunden und
eingebunden werden.  Falls das bei dem eigenen Drucker noch nicht klappt, sollte
man mit dem :ref:`printer_setup` fortfahren.



.. _printer_setup:

Netzwerk-Drucker Setup
======================

Im GNOME Setup unter "Geräte" kann man den Drucker einrichten, i.d.R. wir der
Drucker im Netz gefunden, allerdings wählt GNOME (resp CUPS) die **driverless**
PPA, bei mir (Ubuntu 18.04 und MF623Cn Drucker) war das::

  "CNMF620C Series, driverless"

Über den Button *"Zusätzliche Druckereinstellungen"* kann man bestehende Setups
ändern oder auch weitere Setups einrichten.  Die GUI (``system-config-printer``)
ist die Druckerverwaltung des CUPS, alternativ kann man diese auch im WEB
Browser unter http://localhost:631/printers über HTML Formulare vornehmen.

Über die HTML GUI können nur bestimmte Benutzer die Drucker verwalten. Nur die,
die zur Gruppe lpadmin gehören::

   $ members lpadmin
   cups-pk-helper <benutzername>

Die GNOME GUI's nutzen zum Teil den Benutzer ``cups-pk-helper`` aus dem
gleichnamigen APT-Paket .. allerdings auch nicht immer, weshalb man sich selbst
am besten noch zu der Gruppe ``lpadmin`` hinzufügt::

  $ sudo gpasswd -a <benutzername> <gruppe>

Auch wenn es immer eine HTML-GUI gibt, am übersichtlichsten ist die GNOME GUI.

.. figure:: system-config-printer.png

Über *Hinzufügen --> Netzwerkdrucker* den Drucker suchen lassen und dann als
Verbindung ``ipp/print`` auswählen (sicherstellen, dass oben die Geräteadresse
mit ``ipp://`` beginnt).

.. figure:: system-config-printer-NEW.png

Nun muss man einen eindeutigen Druckernamen vergeben, diesen wird man später
nicht mehr ändern können.  Ich verwende hierfür die genaue Typ-Bezeichnung plus
die Seriennummer (``MF623C-TWF19694`)`.  Als Beschreibung wähle ich "Farb-Laser
A4 einseitig" und bei Ort gebe ich das Büro an (z.B. "Büro Markus").

Danach kann man auf "Vorwärts" drücken, dann kommt ein Dialog "Treiber wird
gesucht", das kann einen Moment dauern. Ddanach wird man gefragt, ob man eine
Testseite drucken möchte.  Das würde auch funktionieren, aber den Dialog bricht
man dennoch erst mal ab und schaut sich die *Eigenschaften* des soeben
eingerichteten Druckers an.

Hat man den **proprietären** Treiber :ref:`canon_urf` eingerichtet, so kann man
den jetzt auch für diesen Drucker nutzen.  Unter *Marke und Model* ist bei mir
z.B. zu sehen::

   CNMF620C Series, driverless, cups-filters 1.20.2

Über den *"Ändern"* Button erscheint dann der "Treiber ändern" Dialog, da mal
eben kurz warten, dann wird eine Auswahl angeboten:

.. figure:: system-config-driver-model.png

Dann den **proprietären** Treiber :ref:`canon_urf` auswählen.

.. figure:: system-config-driver-type.png

Da man den **proprietären** Treiber einrichtet, sollte man auch dessen `PPD
(wiki)`_ Datei (erst mal) unverändert übernehmen.

.. figure:: system-config-ppd-settings.png

.. hint::

   Bei den Canon Installationen klappt das evtl. nicht immer mit der PPD, das
   ist daran zu erkennen, dass nach obigen Vorgehen bei "Marke und Modell""
   immer noch ``CNMF620C Series, driverless, cups-filters 1.20.2`` (also
   **drivless**) steht.

In solchen Fällen hat man noch die Möglichkeit, die PPD direkt zuzuweisen.  Das
geht über das GNOME Setup (wieder unter "Geräte""), dort klickt man auf das
*Zahnrad / Drucker-Details*.

.. figure:: system-config-install-PPD.png

Über den Button *"PPD-Datei installieren ..."* kann man direkt eine PPD Datei
auswählen.  Bei der Installation des **proprietären** Treiber :ref:`canon_urf`
wurden die PPD Datei unter dem Pfad::

  /usr/share/cups/model/CNCUPSMF620CZK.ppd

installiert.  Da liegen auch noch ein Haufen anderer Dateien rum, was darin
begründet ist, dass Canon mit dem Paket ``cndrvcups-ufr2-uk_{3.70}-1_amd64.deb``
alle seine URF Modelle abdeckt (was aber auch vollkommen OK ist, man darf sich
nur nicht den ganzen anderen Rotz über deren *Installer* installieren lassen).
Die Dateinamen setzen sich zusammen aus::

  CN CUPS MF620C ZK.ppd
  -+      -----+
   |           +--> Modell
   +--> Canon

Wenn man die richtige PPD Datei ausgewählt hat, dann steht bei dem Modell::

  Canon MF620C UFRII LT

Falls sich dennoch Fragen ergeben, am besten hier schauen:

- https://wiki.debian.org/PrinterDriver/Canon/UFR-II

Troubleshooting
===============

XXXXXXXXXXXXXXXXXXXXXXXXX FIXME XXXXXXXXXXXXXXXXXXXXXXXXXXX

- https://wiki.archlinux.org/index.php/CUPS/Troubleshooting
- https://fedoraproject.org/wiki/How_to_debug_printing_problems









