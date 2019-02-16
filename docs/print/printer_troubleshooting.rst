.. -*- coding: utf-8; mode: rst -*-
.. include:: ../print_scan_refs.txt

.. _print_troubleshooting:

===============
Troubleshooting
===============

Eine einfache und erste, schnelle Hilfe kann der *Troubleshooting Wizard* sein.
Den bekommt man über die ``F1`` Taste im :ref:`system-config-printer
<figure-cups-system-config-printer-gui>`.  Mit dem Tool können
:origin:`troubleshoot.txt <docs/print_scan/troubleshoot.txt>` Dateien erzeugt
werden.  Deren Studium kann z.T. auch mal nützliche Informationen hervorbringen.
Als ein Beispiel sei Commit :commit:`e3b130` gegeben.

Ansonsten kann man auch nochmal den Verweisen folgen:

- `Dissecting and Debugging the CUPS Printing System`_
- `Debugging Printer Problems (ubuntu-wiki)`_
- `How to debug printing problems (fedora wiki)`_
- `Drucker (archlinux wiki)`_ & `CUPS (archlinux)`_ & `CUPS Troubleshooting (archlinux wiki)`_


Kommando :man:`lpinfo` listet die dem CUPS-Server bekannten verfügbaren Geräte oder
Treiber auf::

  $  lpinfo -v
  network beh
  file cups-brf:/
  network ipps
  network socket
  network https
  network ipp
  network http
  network lpd
  network dnssd://Canon%20MF620C%20Series._ipp._tcp.local/?uuid=6d4ff0ce-6b11-11d8-8020-f48139e3ba8e
  network socket://192.168.1.119
  network ipp://MF623Cn.local:80/ipp/print


Kommando :man:`pdfinfo` auf die 7. bis 8. Seite des PDF::

  $ pdfinfo -f 7 -l 8 ~/Downloads/QR-Code-Test.pdf
  Tagged:         no
  UserProperties: no
  Suspects:       no
  Form:           none
  JavaScript:     no
  Pages:          8
  Encrypted:      no
  Page    7 size: 595.28 x 841.89 pts (A4)
  Page    7 rot:  0
  Page    8 size: 595.28 x 841.89 pts (A4)
  Page    8 rot:  0
  File size:      835779 bytes
  Optimized:      no
  PDF version:    1.4

Kommando :man:`lpstat`::

  $ lpstat -p
  Drucker CNMF620C-Series ist im Leerlauf.  Aktiviert seit Mo 11 Feb 2019 14:39:23 CET
  Drucker MF623C-TWF19694 ist im Leerlauf.  Aktiviert seit Mo 11 Feb 2019 14:32:23 CET


CUPS Server debug
=================

Das Debug-LOG zum CUPS Dienst kann über die Kommandozeile aktiviert/de-aktiviert
werden::

  $ cupsctl -U <benutzer> --[no-]debug-logging

oder über die HTML GUI des CUPS: http://localhost:631/admin/ kann mit der Option
:guilabel:`Mehr Informationen zur Fehlersuche speichern` das Debug-LOG
eingeschaltet werden.

.. _figure-cupsd-debug-on:

.. figure:: cupsd-debug-on.png
   :alt:    Figure (cupsd-debug-on.png)
   :target:  http://localhost:631/admin/

   ``localhost:631``: CUPS Server Einstellungen

Die Einstellung wird aktiv, sobald :guilabel:`Einstellung ändern` bestätigt wird.


CUPS Browser debug
==================

Das Debug-LOG des Dienstes ``cups-browsed.service`` kann in der Config-Datei zum
Dienst eingestellt werden::

  /etc/cups/cups-browsed.conf

Mit der folgenden Einstellung::

   # Where should cups-browsed create its debug log file (if "DebugLogging file"
   # is set)?

   LogDir /var/log/cups

   # How should debug logging be done? Into the file
   # /var/log/cups/cups-browsed_log ('file'), to stderr ('stderr'), or
   # not at all ('none')?

   DebugLogging file
   # DebugLogging stderr
   # DebugLogging file stderr
   # DebugLogging none

wird ein Debug-LOG in der Datei ``/var/log/cups/cups-browsed_log`` angelegt,
sobald der Dienst neu gestartet wurde::

  $ sudo systemctl restart cups-browsed


.. _debug_dump_to_file:

Druckausgabe in Datei
=====================

Um die Ausgabe auf den Drucker in eine Datei umzuleiten muss in der Datei
``/etc/cups/cups-files.conf`` die Option *FileDevice Yes* gesetzt werden::

  # Do we allow file: device URIs other than to /dev/null?
  #FileDevice No
  FileDevice Yes

Danach den CUPS Dienst neu starten: ``sudo systemctl restart cups``.  In der
:ref:`GUI <figure-cups-system-config-printer-gui>` sollte der bestehende Drucker
kopiert werden, hier im Beispiel wird der ``MF623C-URF-II-Dump.ppd`` durch eine
Kopie des :ref:`canon_urf` erzeugt.  In den Einstellungen des
``MF623C-URF-II-Dump`` wird die *Geräteadresse* auf ``file:/tmp/printout``
gesetzt.

.. figure:: tmp-printout-device.png

Ein Ausdruck auf den Drucker ``MF623C-URF-II-Dump`` legt die Datei
``/tmp/printout`` an.

Test mit ``cupsfilter``
=======================

- cups-filters_

Mit dem Kommando :man:`cupsfilter` und der Option ``--list-filters`` können die
verwendeten Filter angezeigt werden::

  $ /usr/sbin/cupsfilter --list-filters -m printer/MF623C-TWF19694 ~/Downloads/QR-Code-Test.pdf
  pdftopdf
  pdftops

Mit der Option ``-m printer/MF623C-TWF19694`` wird als Zieldatei-Typ das
Drucker-Setup des ``MF623C-TWF19694`` gewählt.  Der Quelldatei-Typ kann optional
über ``-i MIME/Typ`` angegeben oder automatisch erkannt werden (hier wurde eine
PDF Datei erkannt).

- `cups-filter README`_

Mit dem folgenden Kommando wird *Seite 8* gedruckt (die letzte Seite in dem PDF
Beispiel).  Mit der Option ``-m printer/CNMF620C-Series`` wird als Zieldatei-Typ
das Drucker-Setup des (:ref:`driverless-printing <printer_setup>`)
``CNMF620C-Series`` gewählt .


.. code-block:: bash
   :linenos:

   $ /usr/sbin/cupsfilter -m printer/CNMF620C-Series -p /etc/cups/ppd/CNMF620C-Series.ppd \
        -o page-ranges=8 -o printer-resolution=600 \
        ~/Downloads/QR-Code-Test.pdf  > ~/Downloads/QR-Code-Test-P8-driverles.ps
   DEBUG: argv[0]="cupsfilter"
   DEBUG: argv[1]="1"
   DEBUG: argv[2]="markus"
   DEBUG: argv[3]="QR-Code-Test.pdf"
   DEBUG: argv[4]="1"
   DEBUG: argv[5]="page-ranges=8 printer-resolution=600"
   DEBUG: argv[6]="/home/markus/Downloads/QR-Code-Test.pdf"
   DEBUG: envp[0]="<CFProcessPath>"
   DEBUG: envp[1]="CONTENT_TYPE=application/pdf"
   DEBUG: envp[2]="CUPS_DATADIR=/usr/share/cups"
   DEBUG: envp[3]="CUPS_FONTPATH=/usr/share/cups/fonts"
   DEBUG: envp[4]="CUPS_SERVERBIN=/usr/lib/cups"
   DEBUG: envp[5]="CUPS_SERVERROOT=/etc/cups"
   DEBUG: envp[6]="LANG=de_DE.UTF8"
   DEBUG: envp[7]="PATH=/usr/lib/cups/filter:/usr/bin:/usr/sbin:/bin:/usr/bin"
   DEBUG: envp[8]="PPD=/etc/cups/ppd/CNMF620C-Series.ppd"
   DEBUG: envp[9]="PRINTER_INFO=cupsfilter"
   DEBUG: envp[10]="PRINTER_LOCATION=Unknown"
   DEBUG: envp[11]="PRINTER=cupsfilter"
   DEBUG: envp[12]="RIP_MAX_CACHE=128m"
   DEBUG: envp[13]="USER=markus"
   DEBUG: envp[14]="CHARSET=utf-8"
   DEBUG: envp[15]="FINAL_CONTENT_TYPE=application/vnd.cups-postscript"
   INFO: pdftopdf (PID 10923) started.
   INFO: pdftops (PID 10924) started.
   DEBUG: pdftops - copying to temp print file "/tmp/02aac5c6d6229"
   DEBUG: pdftopdf: No PPD file specified, could not determine whether to log pages or not, so turned off page logging.
   INFO: pdftopdf (PID 10923) exited with no errors.
   DEBUG: Printer make and model:
   DEBUG: Running command line for pstops: pstops 1 markus QR-Code-Test.pdf 1 printer-resolution=600
   DEBUG: Using image rendering resolution 600 dpi
   DEBUG: Running command line for gs: gs -q -dNOPAUSE -dBATCH -dSAFER -dNOMEDIAATTRS -sDEVICE=ps2write -dShowAcroForm -sOUTPUTFILE=%stdout -dLanguageLevel=3 -r600 -dCompressFonts=false -dNoT3CCITT -dNOINTERPOLATE -c 'save pop' -f /tmp/02aac5c6d6229
   DEBUG: Started filter gs (PID 10925)
   DEBUG: Started post-processing (PID 10926)
   DEBUG: Started filter pstops (PID 10927)
   DEBUG: slow_collate=0, slow_duplex=0, slow_order=0
   DEBUG: Before copy_comments - %!PS-Adobe-3.0
   DEBUG: %!PS-Adobe-3.0
   DEBUG: %%BoundingBox: 0 0 596 842
   DEBUG: %%HiResBoundingBox: 0 0 596.00 842.00
   DEBUG: %%Creator: GPL Ghostscript 926 (ps2write)
   DEBUG: %%LanguageLevel: 2
   DEBUG: %%CreationDate: D:20190212122545+01'00'
   DEBUG: %%Pages: 1
   DEBUG: %%EndComments
   DEBUG: Before copy_prolog - %%BeginProlog
   DEBUG: Adding Setup section for option PostScript code
   DEBUG: Before copy_setup - %%BeginSetup
   DEBUG: Before page loop - %%Page: 1 1
   DEBUG: Copying page 1...
   PAGE: 1 1
   DEBUG: pagew = 576.0, pagel = 720.0
   DEBUG: bboxx = 0, bboxy = 0, bboxw = 612, bboxl = 792
   DEBUG: PageLeft = 18.0, PageRight = 594.0
   DEBUG: PageTop = 756.0, PageBottom = 36.0
   DEBUG: PageWidth = 612.0, PageLength = 792.0
   DEBUG: PID 10925 (gs) exited with no errors.
   DEBUG: Wrote 1 pages...
   DEBUG: PID 10926 (Post-processing) exited with no errors.
   DEBUG: PID 10927 (pstops) exited with no errors.
   INFO: pdftops (PID 10924) exited with no errors.

..
   Hier nochmal das gleiche Kommando für den :ref:`canon_urf` Treiber von Canon:

   .. code-block:: bash
      :linenos:

      $ /usr/sbin/cupsfilter -m printer/MF623C-TWF19694 -p /etc/cups/ppd/MF623C-TWF19694.ppd \
	   -o page-ranges=8 -o printer-resolution=600 \
	   ~/Downloads/QR-Code-Test.pdf  > ~/Downloads/QR-Code-Test-P8-URFII.ps

      DEBUG: argv[0]="cupsfilter"
      DEBUG: argv[1]="1"
      DEBUG: argv[2]="markus"
      DEBUG: argv[3]="QR-Code-Test.pdf"
      DEBUG: argv[4]="1"
      DEBUG: argv[5]="page-ranges=8 printer-resolution=600"
      DEBUG: argv[6]="/home/markus/Downloads/QR-Code-Test.pdf"
      DEBUG: envp[0]="<CFProcessPath>"
      DEBUG: envp[1]="CONTENT_TYPE=application/pdf"
      DEBUG: envp[2]="CUPS_DATADIR=/usr/share/cups"
      DEBUG: envp[3]="CUPS_FONTPATH=/usr/share/cups/fonts"
      DEBUG: envp[4]="CUPS_SERVERBIN=/usr/lib/cups"
      DEBUG: envp[5]="CUPS_SERVERROOT=/etc/cups"
      DEBUG: envp[6]="LANG=de_DE.UTF8"
      DEBUG: envp[7]="PATH=/usr/lib/cups/filter:/usr/bin:/usr/sbin:/bin:/usr/bin"
      DEBUG: envp[8]="PPD=/etc/cups/ppd/MF623C-TWF19694.ppd"
      DEBUG: envp[9]="PRINTER_INFO=cupsfilter"
      DEBUG: envp[10]="PRINTER_LOCATION=Unknown"
      DEBUG: envp[11]="PRINTER=cupsfilter"
      DEBUG: envp[12]="RIP_MAX_CACHE=128m"
      DEBUG: envp[13]="USER=markus"
      DEBUG: envp[14]="CHARSET=utf-8"
      DEBUG: envp[15]="FINAL_CONTENT_TYPE=application/vnd.cups-postscript"
      INFO: pdftopdf (PID 11462) started.
      INFO: pdftops (PID 11463) started.
      DEBUG: pdftops - copying to temp print file "/tmp/02cc75c656b15"
      DEBUG: pdftopdf: No PPD file specified, could not determine whether to log pages or not, so turned off page logging.
      INFO: pdftopdf (PID 11462) exited with no errors.
      DEBUG: Printer make and model:
      DEBUG: Running command line for pstops: pstops 1 markus QR-Code-Test.pdf 1 printer-resolution=600
      DEBUG: Using image rendering resolution 600 dpi
      DEBUG: Running command line for gs: gs -q -dNOPAUSE -dBATCH -dSAFER -dNOMEDIAATTRS -sDEVICE=ps2write -dShowAcroForm -sOUTPUTFILE=%stdout -dLanguageLevel=3 -r600 -dCompressFonts=false -dNoT3CCITT -dNOINTERPOLATE -c 'save pop' -f /tmp/02cc75c656b15
      DEBUG: Started filter gs (PID 11464)
      DEBUG: Started post-processing (PID 11465)
      DEBUG: Started filter pstops (PID 11466)
      DEBUG: slow_collate=0, slow_duplex=0, slow_order=0
      DEBUG: Before copy_comments - %!PS-Adobe-3.0
      DEBUG: %!PS-Adobe-3.0
      DEBUG: %%BoundingBox: 0 0 596 842
      DEBUG: %%HiResBoundingBox: 0 0 596.00 842.00
      DEBUG: %%Creator: GPL Ghostscript 926 (ps2write)
      DEBUG: %%LanguageLevel: 2
      DEBUG: %%CreationDate: D:20190212124422+01'00'
      DEBUG: %%Pages: 1
      DEBUG: %%EndComments
      DEBUG: Before copy_prolog - %%BeginProlog
      DEBUG: Adding Setup section for option PostScript code
      DEBUG: Before copy_setup - %%BeginSetup
      DEBUG: Before page loop - %%Page: 1 1
      DEBUG: Copying page 1...
      PAGE: 1 1
      DEBUG: pagew = 576.0, pagel = 720.0
      DEBUG: bboxx = 0, bboxy = 0, bboxw = 612, bboxl = 792
      DEBUG: PageLeft = 18.0, PageRight = 594.0
      DEBUG: PageTop = 756.0, PageBottom = 36.0
      DEBUG: PageWidth = 612.0, PageLength = 792.0
      DEBUG: PID 11464 (gs) exited with no errors.
      DEBUG: Wrote 1 pages...
      DEBUG: PID 11465 (Post-processing) exited with no errors.
      DEBUG: PID 11466 (pstops) exited with no errors.
      INFO: pdftops (PID 11463) exited with no errors.

