.. -*- coding: utf-8; mode: rst -*-
.. include:: ../print_scan_refs.txt

.. _ppd_spec:

====================
Die kleine PPD Fibel
====================

- `CUPS-Server PPD <http://localhost:631/help/ref-ppdcfile.html>`_

Über eine `PPD (wiki)`_ wird ein CUPS-Drucker in CUPS eingerichtet.  Es ist
möglich **einen physikalischen** Drucker über unterschiedliche CUPS-Drucker
(also PPD Dateien) in **unterschiedlichen Setups** anzubieten.  Aus Sicht des
Anwenders **sind die Setups die Drucker** auf denen er drucken kann.  Die über
die :ref:`GUI <figure-cups-system-config-printer-gui>` eingerichteten Drucker
entsprechen den ``*.ppd`` Dateien in der CUPS Konfiguration unter
``/etc/cups``::

  $ ls -la /etc/cups/ppd/*.ppd
  ...
  -rw-r----- 1 root lp   12641 Feb 13 12:26 CNMF620C-Series.ppd
  -rw-r----- 1 root lp   15332 Feb 12 19:22 MF623C-TWF19694.ppd

Die PPD-Dateien aus den Beispielen *hier* sind im Original folgend einzusehen:

- ``CNMF620C-Series.ppd``: :origin:`CNMF620C Series, driverless (PPD modified)
  <docs/print_scan/CNMF620C-Series.ppd>`
- ``MF623C-TWF19694.ppd``: :origin:`Canon MF620C Series UFRII LT
  <docs/print_scan/MF623C-TWF19694.ppd>`

Die PPD-Dateien *entstehen* beim Einrichten des Druckers in der :ref:`GUI
<figure-cups-system-config-printer-gui>`, entweder durch die Auswahl einer PPD
Datei (des Herstellers), oder aber sie werden durch den *driverless* Treiber
erzeugt.  Bei letzterem nutzt der *driverless* Treiber IPP-Everywhere um den
Drucker zu finden, über IPP fragt er dann beim Drucker nach seinen Eigenschaften.

Im Kapitel ":ref:`IPP_intro`" wird ein Beispiel gezeigt, wie die Eigenschaften des
Druckers mit dem :man:`ipptool` Kommando ausgelesen werden können.  Aus der
Antwort vom Drucker (:origin:`MF623Cn-attributes.txt
<docs/print_scan/MF623Cn-attributes.txt>`) baut der *driverless* Treiber dann
eine PPD Datei, die er unter ``/etc/cups/ppd/<printer-name>.ppd`` speichert.
Der ``<printer-name>`` wird einem öfter begegnen, z.B bei Kommandos wie :man:`lpstat`::

  $ lpstat -p
  Drucker CNMF620C-Series ist im Leerlauf.  Aktiviert seit Di 12 Feb 2019 17:49:37 CET
  Drucker MF623C-TWF19694 ist im Leerlauf.  Aktiviert seit Mi 13 Feb 2019 11:48:19 CET

PPD ist die Abkürzung für *PostScript Printer Description* und wie der Name
schon erahnen lässt, ist die *Description (aka Beschreibung)* des Drucker an der
*Seitenbeschreibungssprache* `PostScript (wiki)`_ orientiert.  Eine
*Seitenbeschreibungssprache* wird im englischen auch `PDL (wiki)`_ genannt.

.. hint::

   Auch bei den modernen Image-Druckern (s.a :ref:`IPP_intro`), die kein
   PostScript verstehen, erfolgt das Setup des Druckers im CUPS mit diesen PPD
   Dateien.  Beispiele wie :ref:`cups-driverless_HWMargins` zeigen auf, dass ein
   Blick auf die PPD Dateien z.T. unumgänglich ist.

Schaut man in die PPD Dateien hinein, so sieht man dort Angaben wie z.B.::

  *DefaultPageSize: A4.Fullbleed
  *PageSize A4.Fullbleed: "<</PageSize[595 842]/ImagingBBox null>>setpagedevice"

Die Definition zu solchen Angaben befinden sich hier: `PPD Datei CUPS PPD
Extensions`_.  Was schon ohne genaue Kenntnisse zu erkennen ist, dass
Längenangaben z.T. einheitenlos sind, hier das Beispiel die `Page Sizes (hp)`_
mit der Angabe: ``/PageSize[595 842]``

.. hint::

   Größen-Angaben ohne Einheit sind vom Typ DTP-Punkt_ (aka *PostScript unit*).
   Der Punkt entspricht ``0,3527mm`` / s.a. :ref:`tabelle_page_size`


Druckbereich
============

Im Kapitel ":ref:`IPP_intro`" wurde bereits gezeigt, wie mittels IPP die Werte
vom Drucker ausgelesen werden können.::

  $ ipptool -t -v ipp://MF623Cn.local:80  /usr/share/cups/ipptool/get-printer-attributes.test

Die Ausgabe für den MF623Cn_ ist in der Datei :origin:`MF623Cn-attributes.txt
<docs/print_scan/MF623Cn-attributes.txt>` zu sehen, hier der Auschnitt zu den
Angaben der Papiergrößen und Druckbereiche, die der Drucker kennt (siehe
:ref:`Tabelle in Spalte MF623Cn <tabelle_page_size>`):

.. code-block:: none

  media-default (keyword) = iso_a4_210x297mm
  media-supported (1setOf keyword) = \
    custom_min_83x127mm              \
    , custom_max_215.9x355.6mm       \
    , iso_a4_210x297mm               \
    , iso_a5_148x210mm               \
  ...

  orientation-requested-default (enum) = portrait
  orientation-requested-supported (1setOf enum) = portrait,landscape
  output-bin-default (keyword) = face-down
  output-bin-supported (keyword) = face-down

.. _cupstestppd:

CUPS test PPD
=============

Die von `driverless-printing CUPS`_ angelegte PPD Datei kann Fehler enthalten
(so zumindest bei mir).  Die Datei sollte in jedem Fall geprüft werden, mir ist
aufgefallen, dass z.B. die Einträge wie ``*PageSize 3x5/3 x 5":`` vor dem
Doppelpunkt noch einen überflüssigen Anführungsstrich besitzen.::

  $ sudo grep --color '^*[^:]*\":'  /etc/cups/ppd/CNMF620C-Series-driverless.ppd
  ...
  *PageSize 3x5/3 x 5": "<</PageSize[216 360]>>setpagedevice"
                     |
		     +--> das "-Zeichen gehört hier nicht hin!


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


Papier-Größen umrechnen
=======================

Größen-Angaben die in :ref:`PPD-Dateien <ppd_spec>` ohne Einheit angegeben
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

