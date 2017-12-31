.. -*- coding: utf-8; mode: rst -*-

.. include:: ../print_scan.txt

.. _scan_linux:

================
Scannen mit SANE
================

Scanner werden auf Linux mit der *Scanner Access Now Easy* (SANE_) Software
eingebunden (SANE-Backend_). Die über SANE eingebundnenen Drucker können über
die Komandozeile (eignet sich für Skripte) oder über ein SANE-Frontend_ (eignet
sich für Desktop Benutzer) angesteuert werden. Am einfachsten zu bedienen
scheint mir :ref:`simple_scan_linux`. Teilweise stellen auch schon die
Anwendungsprogramme selbst ein SANE-Frontend zur Verfügung, wie
z.B. LibreOffice::

  Einfügen -->  Medien --> Scannen

Installation des SANE::

  sudo apt-get install sane sane-utils libsane-extras

Wenn SANE als Dienst laufen soll, muss in der ``/etc/default/saned``
Konfiguration der Schalter ``RUN=yes`` gesetzt werden. Das wird aber nur
empfohlen, wenn *dieser* Rechner auch als Scannserver genutzt werden soll,
dessen sich andere Clients bedienen (er also permanent läuft). I.d.R. braucht
man in einem kleineren Office aber keinen solchen Scanserver.

  
Scanner Treiber
===============

https://wiki.ubuntuusers.de/Scanner/Canon/



.. _simple_scan_linux:
  
Simple Scan
===========

Installation des SANE-Frontends `Simple Scan`_::

  apt-get install -y simple-scan

`Simple Scan`_ ist eine einfache GUI zum Scannen, das in Ubuntu auch das
Standard-Programm zum Scannen ist. Es handelt sich um ein Sane-Frontend. Es kann
den Scan in verschiedenen Formaten speichern u.A. in PDF.  Allerdings ist dieses
PDF nicht *durchsuchbar*, sprich es ist keine Texterkennung implementiert.

Eine einfache Methode um aus solchen PDF-SCANs *durchsuchbare* PDFs zu machen
ist das Programm :ref:`pdfsandwich_linux`.

.. _pdfsandwich_linux:
  
pdfsandwich
===========

Siehe pdfsandwich_
