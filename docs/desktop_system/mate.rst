.. -*- coding: utf-8; mode: rst -*-

.. include:: ../desktop_system_refs.txt

.. _xref_mate:

================================================================================
                                  Mate Desktop
================================================================================

.. todo::

   Dieser Artikel wurde noch nicht mit Ubuntu 18.04 getestet.

Das Layout des `Mate Desktop`_ stammt vom GNOME 2 und ist ziemlich *vintage*.
Ich kann es eigentlich nicht empfehlen, wer aber unbedingt seinen *guten alten
Desktop* wieder haben will, der wird mit Mate gut bedient sein.

Installation
============

In dem ``${SCRIPT_FOLDER}`` Ordner befindet sich ein Skript, mit dem die Mate
Desktop Umgebung installiert werden kann::

  $ sudo ./scripts/desktop_system.sh install mate

Mit dem oben stehenden Skript wird das Paket :deb:`mate-desktop-environment`
installiert. Das Paket umfasst den Mate Desktop und noch einiges mehr, so
z.B. eine Suite von Standard-Anwendungen (insgesammt ca. 370MB). Man sollte sich
überlegen, ob man das alles braucht und nachdem man seine Tests beendet hat
sollte man eine De-Installation durchführen.

De-Installation
===============

Zur De-Installation eignet sich::

  $ sudo ./scripts/desktop_system.sh remove mate
