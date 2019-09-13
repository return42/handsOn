.. -*- coding: utf-8; mode: rst -*-
.. include:: ../print_scan_refs.txt

.. _ppd_spec:

====================
Die kleine PPD Fibel
====================

In einer `PPD (wiki)`_ Datei werden die Einstellungen eines CUPS-Druckers
gespeichert.  Die über die :ref:`GUI <figure-cups-system-config-printer-gui>`
eingerichteten Drucker entsprechen den ``*.ppd`` Dateien in der CUPS
Konfiguration unter ``/etc/cups``::

  $ ls -la /etc/cups/ppd/*.ppd
  ...
  -rw-r----- 1 root lp   12641 Feb 13 12:26 CNMF620C-Series.ppd
  -rw-r----- 1 root lp   15332 Feb 12 19:22 MF623C-TWF19694.ppd

Nimmt man Änderungen direkt an einer PPD Datei vor, so sollte man den CUPS
Dienst neu starten, damit dieser die neuen Einstellungen übernimmt::

  sudo systemctl restart cups

Werden Änderungen über die :ref:`GUI <figure-cups-system-config-printer-gui>`
vorgenommen, so ist ein Neustart des Dienstes nicht erforderlich.

Mit `CUPS (wiki)`_ kann man für **EINEN physikalischen** Drucker mehrere
unterschiedliche CUPS-Drucker (also PPD Dateien) einrichten.  Aus Sicht des
Anwenders **sind die CUPS-Drucker, die Drucker auf denen er drucken kann**.  Hat
man einen funktionierenden CUPS-Drucker, so kann man davon eine Kopie anlegen
und mit dieser dann erst mal seine Änderungen an der PPD testen.  Man braucht
also sein *funktionierendes* Setup erst mal nicht *anfassen*, wenn man mal was
ausprobieren möchte.

.. hint::

   Beispiele wie sie in Kapitel ":ref:`cups-driverless_HWMargins`" und Kapitel
   ":ref:`cupstestppd`" gegeben sind, machen deutlich, dass es auch heute noch
   ratsam ist, einen Blick auf die PDD Dateien zu werfen und diese ggf. zu
   korrigieren.

Die PPD-Dateien aus den Beispielen *hier* sind im Original folgend einzusehen:

- ``CNMF620C-Series.ppd``: :origin:`CNMF620C Series, driverless (PPD modified)
  <docs/print/CNMF620C-Series.ppd>`
- ``MF623C-TWF19694.ppd``: :origin:`Canon MF620C Series UFRII LT
  <docs/print/MF623C-TWF19694.ppd>`


Herkunft der PPD Dateien
========================

Die PPD-Dateien *entstehen* beim Einrichten des Druckers in der :ref:`GUI
<figure-cups-system-config-printer-gui>`, entweder durch die Auswahl einer PPD
Datei (des Herstellers) oder aber sie werden durch den *driverless* Treiber
erzeugt.  Bei letzterem nutzt der *driverless* Treiber IPP-Everywhere um den
Drucker zu finden.  Ebenfalls über IPP fragt er dann beim Drucker nach seinen
Eigenschaften.  Im Kapitel ":ref:`IPP_intro`" wird ein Beispiel gezeigt, wie die
Eigenschaften des Druckers mit dem :man:`ipptool` Kommando ausgelesen werden
können.  Aus der Antwort vom Drucker (:origin:`MF623Cn-attributes.txt
<docs/print/MF623Cn-attributes.txt>`) baut der *driverless* Treiber dann
eine PPD Datei, die er unter ``/etc/cups/ppd/<printer-name>.ppd`` speichert.
Der ``<printer-name>`` wird einem öfter begegnen, z.B bei Kommandos wie
:man:`lpstat`::

  $ lpstat -p
  Drucker CNMF620C-Series ist im Leerlauf.  Aktiviert seit Di 12 Feb 2019 17:49:37 CET
  Drucker MF623C-TWF19694 ist im Leerlauf.  Aktiviert seit Mi 13 Feb 2019 11:48:19 CET


Aufbau einer PPD-Datei
======================

Schaut man in die PPD Dateien hinein, so sieht man dort Angaben wie z.B.::

  *DefaultPageSize: A4.Fullbleed
  *PageSize A4.Fullbleed/A4: "<</PageSize[595 842]/ImagingBBox null>>setpagedevice"

PPD ist die Abkürzung für *PostScript Printer Description* und wie der Name es
schon erahnen lässt, erfolgt die *Description* des Drucker in einer Sprache die
stark an der PDL `PostScript (wiki)`_ angelehnt ist.  Zu erkennen ist das
beispielsweise an dem ``setpagedevice``, einem Operator aus dem PostScript.

.. hint::

   Auch bei den modernen Image-Druckern (s.a :ref:`IPP_intro`), die kein
   PostScript verstehen, erfolgt das Setup des Druckers im CUPS mit den
   *PostScript Printer Description* (aka PPD) -Dateien.

Die Definition zu solchen Angaben befinden sich hier

- `PPD Spec v4.3`_
- `PPD Datei CUPS PPD Extensions`_.
- `CUPS-Server PPD <http://localhost:631/help/ref-ppdcfile.html>`_

Aber auch schon ohne tiefere Kenntnisse der `PPD Spec v4.3`_ kann man im obigen
Beispiel erahnen, dass Angaben zu Längen z.T. einheitenlos sind, hier das
Beispiel `Page Sizes (hp)`_ mit der Angabe: ``/PageSize[595 842]``

.. hint::

   Längen-Angaben ohne Einheit sind vom Typ DTP-Punkt_ aka *PostScript unit*.
   Der Punkt entspricht ``0,3527mm`` / s.a. Kapitel ":ref:`dtp_pt_mm_inch`".

.. _cupstestppd:

CUPS test PPD
=============

Die von den Herstellern gelieferte PPD Datei oder aber auch die von
`driverless-printing CUPS`_ angelegte PPD Datei kann Fehler enthalten (so
zumindest bei mir) oder auch unvollständig sein.  Die Datei sollte in jedem Fall
geprüft werden, mir ist beispielsweise aufgefallen, dass z.B. die Einträge wie
``*PageSize 3x5/3 x 5":`` vor dem Doppelpunkt noch einen überflüssigen
Anführungsstrich besitzen.::

  $ sudo grep --color '^*[^:]*\":'  /etc/cups/ppd/CNMF620C-Series-driverless.ppd
  ...
  *PageSize 3x5/3 x 5": "<</PageSize[216 360]>>setpagedevice"
  !!! ~~~~~~~~~~~~~~~^~~~~ die Anführungsstriche gehören dort nicht hin !!!

Es ist auch möglich, die PDD Datei zu prüfen, hierzu gibt es das Kommando
``cupstestppd`` was allerdings auch nicht in der Lage ist den obigen Fehler mit
dem Anführungsstrich zu finden::

  $ sudo cupstestppd  /etc/cups/ppd/CNMF620C-Series.ppd
  /etc/cups/ppd/CNMF620C-Series.ppd: PASS
        WARN    Size "A4" should be the Adobe standard name "A4.Fullbleed".
	...

  $ sudo cupstestppd  /etc/cups/ppd/MF623C-TWF19694.ppd
  /etc/cups/ppd/MF623C-TWF19694.ppd: PASS
        WARN    PCFileName longer than 8.3 in violation of PPD spec.
                REF: Pages 61-62, section 5.3.
	...

.. _cups-driverless_HWMargins:

Druckbereich korrigieren
========================

Im Kapitel ":ref:`IPP_intro`" wurde bereits gezeigt, wie mittels IPP die
Eigenschaften vom Drucker ausgelesen werden können.::

  $ ipptool -t -v ipp://MF623Cn.local:80  /usr/share/cups/ipptool/get-printer-attributes.test

Die Ausgabe für den MF623Cn_ ist in der Datei :origin:`MF623Cn-attributes.txt
<docs/print/MF623Cn-attributes.txt>` zu sehen, hier der Ausschnitt zu den
Angaben der Papiergrößen und Druckbereiche, die der Drucker kennt.

.. code-block:: none

  media-default (keyword) = iso_a4_210x297mm
  media-supported (1setOf keyword) =
    custom_min_83x127mm
    , custom_max_215.9x355.6mm
    , iso_a4_210x297mm
    , iso_a5_148x210mm
  ...
  media-size-supported (1setOf collection) =
    {x-dimension=21000 y-dimension=29700}       <--- entspricht A4
    , {x-dimension=14800 y-dimension=21000}     <--- entspricht A4
    , {x-dimension=18200 y-dimension=25700}     <--- entspricht B5
    , ...

Die vollständige Liste der in ``media-supported`` aufgelisteten Werte ist in der
:ref:`Tabelle in Spalte MF623Cn <tabelle_page_size>` eingetragen.  Aus den
Werten der ``media-size-supported`` kalkuliert der generische Treiber
(:ref:`driverless-printing <printer_setup>`) die PPD Datei zu dem Drucker.

.. attention::

   Die Werte für ``media-size-supported`` sind *hundertstel Millimeter* (also 10
   Mikrometer als Einheit). Nicht zu verwechseln mit den einheitenlosen Angaben
   in PPD Dateien, die den DTP-Punkt_ aka *PostScript unit* darstellen.

Schaut man in eine so generierte PPD Datei, so sieht man, dass dabei für den
Drucker z.T. sehr abstruse Rahmen kalkuliert wurden.  Bitte beachten: hier sind
die einheitenlosen Angaben wieder der DTP-Punkt, also umgerechnet ``1pt=0,3527mm``:

.. code-block:: clean

  *HWMargins: "28.346456692913 28.346456692913 28.346456692913 28.346456692913"
  ...
  *ImageableArea A4: "14.173228346457 14.173228346457 581.102362204724 827.716535433071"
  *ImageableArea A5: "14.173228346457 14.173228346457 405.354330708661 581.102362204724"
  *ImageableArea B5: "14.173228346457 14.173228346457 501.732283464567 714.330708661417"

Besser ist es, die Werte für Ränder ganz auf ``0 0`` zu setzen, dass sollte auch
keine Nachteile bereiten wenn der Drucker in Wirklichkeit mit einem umlaufenden
Rahmen von z.B. 5mm ausgestattet ist (:origin:`MF623Cn-attributes.txt
<docs/print/MF623Cn-attributes.txt>`):

.. code-block:: clean

  *HWMargins: "0 0 0 0"
  ...
  *ImageableArea A4: "0 0 595 842"
  *ImageableArea A5: "0 0 420 595"
  *ImageableArea B5: "0 0 516 729"


.. _dtp_pt_mm_inch:

Längen Angaben umrechnen
========================

Längen-Angaben die in :ref:`PPD-Dateien <ppd_spec>` ohne Einheit angegeben
werden sind vom Typ DTP-Punkt_ (aka *PostScript unit*)::

     DIN     A4 :   210mm x 297mm  / 0,3527 mm
     DTP-Punkte :   595   x 842

     PostScript (aka pt, DTP) Point (aka Unit)

        1 pt   = 0,3527 mm
	1 pt   = 0,01   inch

        1 mm   = 2,84   pt
	1 inch = 72,02  pt

	1 inch = 25,4 mm
	1 mm   = 0,04 inch

Der DTP-Punkt_ entspricht ``0,3527mm`` (`DTP Einheiten Umrechner`_). Unten
zu sehen, die :ref:`tabelle_page_size`


.. _tabelle_page_size:

.. flat-table:: Umrechnungstabelle gängiger PageSize Formate
   :stub-columns: 1
   :header-rows: 1

   * - ``<format>.Fullbleed``
     - DTP
     - mm
     - inch
     - MF623Cn

   * - Custom max
     - 612,3 x 1008,22
     - 215,9 x 355,6
     - **8.5 x 14**
     - custom_max_215.9x355.6mm

   * - Custom min
     - 325,33 x 360.08
     - 83 x 127
     - 3,255 x 5
     - custom_min_83x127mm

   * - 8.5x12.5
     - 612 x 900
     - 216 x 317,43
     - 8.5 x 12.5
     - om_officio_215.9x317.5mm

   * - Oficio (Mexico)
     - 612 x 965
     - 216 x 341
     - 8.5 x 13.4
     - na_oficio_8.5x13.4in

   * - A3
     - 842 x 1190
     - 297 x 420
     - 11.69 x 16.53
     - **Übergröße**

   * - A4
     - 595 x 842
     - 210 x 297
     - 8.27 x 11.69
     - iso_a4_210x297mm

   * - A5
     - 420 x 595
     - 148 x 210
     - 5.83 x 8.27
     - iso_a5_148x210mm

   * - A6
     - 297 x 420
     - 105 x 148
     - 4.13 x 5.83
     - **< 8.5 x 14**

   * - B4
     - 729 x 1033
     - 257 x 364
     - 10.126 x 14.342
     - **Übergröße**

   * - B5
     - 516 x 729
     - 182 x 257
     - 7.17 x 10.126
     - jis_b5_182x257mm

   * - EnvC5 (aka C5)
     - 459 x 649
     - 162 x 229
     - 6.38 x 9
     - iso_c5_162x229mm

   * - Photo (10x15cm, 4x6inch)
     - 288 x 432
     - 102 x 152
     - 4 x 6
     - **< 8.5 x 14**

   * - Letter
     - 612 x 792
     - 216 x 279
     - 8.5 x 11
     - na_letter_8.5x11in

   * - Government Letter
     - 576,13 x 720,16
     - 203,2 x 254
     - 8 x 10
     - na_govt-letter_8x10in

   * - `Government Letter PWG <https://en.wikipedia.org/wiki/Paper_size#Variant_loose_sizes>`_
     - 575 x 757
     - 202.85 x 267.05
     - 8 x 10.5
     - **< 8.5 x 14**

   * - Legal
     - 612 x 1008
     - 216 x 356
     - 8.5 x 14
     - na_legal_8.5x14in

   * - Government Legal
     - 576,13 x 936,21
     - 203,2 x 330,2
     - 8 x 13
     - na_govt-legal_8x13in

   * - Foolscap
     - 612,13 x 936,21
     - 215,9 x 330,02
     - 8.5 x 13
     - na_foolscap_8.5x13in

   * - Foolscap (Australia)
     - 583,22 x 957,75
     - 205,7 x 337,8
     - 8.1 x 13.3
     - om_a-foolscap_205.7x337.8mm

   * - Indian Legal
     - 609,58 x 978,17
     - 215 x 345
     - 8.46 x 13.58
     - om_indian-legal_215x345mm

   * - Ledger
     - 792 x 1224
     - 279 x 432
     - 11 x 17
     - **Übergröße**

   * - Statement
     - 396 x 612
     - 140 x 216
     - 5.5 x 8.5
     - na_invoice_5.5x8.5in

   * - Executive
     - 522 x 756
     - 184 x 267
     - 7.25 x 10.5
     - na_executive_7.25x10.5

   * - EnvMonarch
     - 279 x 540
     - 98 x 190
     - 3.875 x 7.5
     - na_monarch_3.875x7.5in

   * - Env10
     - 297 x 684
     - 105 x 241
     - 4,125 x 9.5
     - na_number-10_4.125x9.5in

   * - EnvDL
     - 312 x 624
     - 110 x 220
     - 4.33 x 8.67
     - **< 8.5 x 14**

   * - 3x5
     - 216 x 360
     - 76 x 127
     - 3 x 5
     - **< 8.5 x 14**

   * - 195.09x269.88mm
     - 553 x 765
     - 195 x 270
     - 7.68 x 10.63
     - **< 8.5 x 14**
