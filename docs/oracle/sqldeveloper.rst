.. -*- coding: utf-8; mode: rst -*-
.. include:: ../oracle_refs.txt

.. _sqldeveloper:


=============
SQL-Developer
=============

GUI Setup
=========

Die GUI Schrift kann auf High-DPI Bildschirmen etwas klein und fisselig
aussehen, folgende Einstellungen können helfen:

- ``~/.sqldeveloper/19.2.1/product.conf``

.. code-block:: none

  # awt.useSystemAAFontSettings:
  # https://docs.oracle.com/javase/6/docs/technotes/guides/2d/flags.html#aaFonts
  #
  AddVMOption -Dawt.useSystemAAFontSettings=on

  # https://batsov.com/articles/2010/02/26/enable-aa-in-swing/
  AddVMOption -Dswing.aatext=true

- ``~/.sqldeveloper/system19.2.1.247.2212/o.sqldeveloper/ide.properties``
- ``%APPDATA%\SQL Developer\system19.2.1.247.2212\o.sqldeveloper.\ide.properties``

.. code-block:: none

   # To modify the font size for all look-and-feels in all locales, set
   # the Ide.FontSize property.  For example:
   #
   Ide.FontSize=14

Schriftart im Editor
--------------------

:menuselection:`Extras --> Voreinstellungen`

.. figure:: sqldeveloper-code-editor-setup.png
   :alt: Figure (sqldeveloper-code-editor-setup.png)
   :scale: 80%
   :align: center


RHEL (RPM) Installation
=======================

Der SQL-Developer benötigt ein JDK, ich habe mich für `OpenJDK
<https://openjdk.java.net/>`_ entschieden, weil das bereits in den Paketquellen
des `Oracle Linux`_ mit drin ist::

  sudo -H yum install java-1.8.0-openjdk-devel

Für den SQL-Developer das RPM Paket runter laden: `SQL Developer Downloads`_ und
installieren::

  $ cd Download
  $ sudo -H yum localinstall sqldeveloper-*.noarch.rpm

Danach einmal auf der Kommandozeile starten::

  $ sqldeveloper

  Oracle SQL Developer
  Copyright (c) 2005, 2018, Oracle and/or its affiliates. All rights reserved.

  Default JDK not found

  Type the full pathname of a JDK installation (or Ctrl-C to quit), the path
  will be stored in /home/user/.sqldeveloper/19.2.1/product.conf

Hier muss man einmal den Pfad zum JDK eingeben, bei obiger Installation des
OpenJDK wäre das dann::

  /usr/lib/jvm/java-1.8.0-openjdk/

Beim Starten bekommt man die Meldung::

  Problem initializing the JavaFX runtime. This feature
  requires JavaFX.

Die JavaFX Runtime wird eigentlich nur für den Begrüßungsbildschirm benötigt,
deshalb muss das JavaFX nicht unbedingt installiert werden.


Debian Installation
===================

.. _sqldeveloper-19.2.1.247.2212-no-jre.zip:
   https://download.oracle.com/otn/java/sqldeveloper/sqldeveloper-19.2.1.247.2212-no-jre.zip

.. sidebar:: Tipp

   Der SQL-Developer muss nicht zwingend installiert werden, es reicht der
   Aufruf ``sqldeveloper.sh`` aus dem ZIP.

Für Debian gibt es das Tool :man:`make-sqldeveloper-package` mit dem man Debian
Pakete für die Installation bauen kann.  Das Tool benötigt dazu das ZIP des
SQL-Developers.  Über `SQL Developer Downloads`_ das ZIP Paket **Other
Platforms** runter laden (sqldeveloper-19.2.1.247.2212-no-jre.zip_)
und danach die Pakete bauen::

   $ cd ~/Downloads
   $ LANG=C make-sqldeveloper-package -i ../sqldeveloper-19.2.1.247.2212-no-jre.zip

Diese selbst-gebauten Pakete kann man sich dann installieren.  Bei der
Installation wird vom SQL-Developer noch ein JDK erwartet::

   $ sudo -H apt install default-jdk
   $ sudo -H dpkg -i libjnidispatch-19.2.1.247.2212_4.2.2+0.5.4-1_amd64.deb
   $ sudo -H dpkg -i sqldeveloper-19.2.1.247.2212_19.2.1.247.2212+0.5.4-1_all.deb

Initial empfiehlt es sich, den SQL-Developer einmal auf der Kommandozeile zu
starten und falls erforderlich einmal den Pfad zum JDK eingeben.  Bei obiger
Installation des ``default-jdk`` wäre das dann::

  /usr/lib/jvm/java-11-openjdk-amd64


Windows Installation
====================

Über `SQL Developer Downloads`_ das ZIP Paket **Windows 64-bit with JDK 8
included** runter laden: `sqldeveloper-19.2.1.247.2212-x64.zip
<https://download.oracle.com/otn/java/sqldeveloper/sqldeveloper-19.2.1.247.2212-x64.zip>`_.
Das ZIP muss nur ausgepackt werden, darin ist dann ein Executable.
