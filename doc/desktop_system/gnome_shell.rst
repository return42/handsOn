.. -*- coding: utf-8; mode: rst -*-

.. include:: ../desktop_system_refs.txt

.. _xref_gnome_shell:

================================================================================
                               Gnome Shell & GDM
================================================================================

Der `GNOME Shell`_ Support in der Ubuntu Distribution ist seit 15.10 recht gut
(war in der Vergangenheit nicht so), weshalb für eine Installation i.d.R. kein
zusätzliches PPA mehr erforderlich ist. Wer etwas aktuellere Versionen nutzen
möchte kann sich nach wie vor des PPA des GNOME 3 Teams bedienen
(`ppa:gnome3-team/gnome3`_ / :man:`add-apt-repository`).  Die GNOME Shell kann mit
den `Shell Extensions <https://extensions.gnome.org/about/>`_ den Bedürfnissen
weiter angepasst werden.

In dem ``${SCRIPT_FOLDER}`` Ordner befindet sich ein Skript, mit dem die GNOME
Shell installiert werden kann.

.. code-block:: bash

   $ sudo ${SCRIPT_FOLDER}/desktop_system.sh gnomeShell

Das Skript installiert die, für eine GNOME Shell *empfohlenen Pakete* und *Shell
Erweiterungen*. Nachdem die GNOME SHELL installiert ist, kann der `Unity`_
Desktop (sofern er nicht mehr benötigt wird) komplett gelöscht werden.

empfohlene Pakete
=================

* :deb:`ubuntu-gnome-desktop` und :deb:`ubuntu-gnome-wallpapers`

  Meta Pakete für die GNOME-Shell in der Ubuntu Distribution

* :deb:`gnome-tweak-tool`

  Das Paket beinhaltet das `GNOME TweakTool`_ mit dem man den Desktop anpassen
  kann und die `GNOME Shell Extensions`_ verwalten.

* :deb:`gconf-editor`

  Der GNOME Configuration Editor (siehe `gconf-editor Manual`_).

* :deb:`elementary-icon-theme`

  Der Icon Theme aus `elementary OS`_ (s.a. `elementary icons
  <https://launchpad.net/elementaryicons>`_)

* :deb:`gir1.2-gtop-2.0`

  Das Paket beinhaltet die `GObject Introspection`_ zum System-Monitoring. Wird
  von manchen Tools zum System-Monitoring benötigt (z.B. `GNOME Shell
  System-Monitor Applet`_).

* :deb:`gir1.2-networkmanager-1.0`

  Das Paket beinhaltet die `GObject Introspection`_ für den `GNOME
  NetworkManager`_. Wird z.B. von dem `GNOME Shell System-Monitor Applet`_
  benötigt.

* :deb:`tracker-gui`

  Eine GUI für die *Desktopsuche* `GNOME Tracker`_.  Die GUI für die
  *Desktopsuche* wird i.d.R. nicht unbedingt benötigt, da es Integrationen für
  den `GNOME Tracker`_ in den Tools wie z.B. dem Dateimanager und dem Suchmenü
  gibt.

Folgendes müsste ggf. mit ``sodo apt-get install ...`` manuell installiert
werden.

* :deb:`ubuntu-gnome-default-settings`

  Die Ubuntu Defaults für die GNOME-Shell. Darunter auch xul-Erweiterungen, die
  ich z.T. kritisch sehe (s.a. :ref:`xref_ubuntu_remove_pkgs`).

Shell Erweiterungen
===================

Die `GNOME Shell Extensions`_ können vom Anwender über die WEB-Seite
https://extensions.gnome.org/ recherchiert und installiert werden. Für eine
systemweite Installation empfiehlt sich:

* `GNOME Shell System-Monitor Applet`_ (benötigt :deb:`gir1.2-gtop-2.0` und
  :deb:`gir1.2-networkmanager-1.0`).
