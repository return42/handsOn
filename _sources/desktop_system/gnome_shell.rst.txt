.. -*- coding: utf-8; mode: rst -*-
.. include:: ../desktop_system_refs.txt

.. _xref_gnome_shell:

================================================================================
                               Gnome Shell & GDM
================================================================================

Die `GNOME Shell`_ ist seit Ubuntu 17.10 wieder Standard-Desktop. Wer in älteren
LTS Versionen eine möglichst aktuelle `GNOME Shell`_ Installation haben möchte
ist meist gut beraten, sich des PPA, des GNOME 3 Teams zu bedienen
(`ppa:gnome3-team/gnome3`_ / :man:`add-apt-repository`). Die GNOME Shell kann
mit den `Shell Extensions <https://extensions.gnome.org/about/>`_ den
Bedürfnissen weiter angepasst werden.

In dem ``${SCRIPT_FOLDER}`` Ordner befindet sich ein Skript, mit dem die GNOME
Shell installiert werden kann::

  $ sudo -H ./scripts/desktop_system.sh install GNOME

Das Skript installiert die, für eine GNOME Shell *empfohlenen Pakete* und *Shell
Erweiterungen*.  Nachdem die GNOME SHELL installiert ist, kann der `Unity`_
Desktop (sofern er nicht mehr benötigt wird) komplett gelöscht werden. Seit
GNOME wieder der Standard-Desktop ist, gibt es das Unity in dem Sinne nicht
mehr. Die Pakete, die man zu Unity als auch ubuntu zu GNOME findet sind
i.d.R. Anpassungen (z.B. :deb:`ubuntu-desktop`, :deb:`ubuntu-session`) am
Gnome-Standard, damit der wieder so aussieht wie der (alte) Unity-Desktop.  Ich
halte von den :ref:`Irrwegen des Unity nichts <xref_desktop_system_common>` und
empfehle den Klimbim zu deinstallieren.


empfohlene Pakete
=================

* :deb:`vanilla-gnome-desktop`

  Die *richtige*, klassische GNOME-Shell ohne irgendwelche Unity Anpassungen.

* :deb:`gnome-tweak-tool`

  Das Paket beinhaltet das `GNOME TweakTool`_ mit dem man den Desktop anpassen
  kann und die `GNOME Shell Extensions`_ verwaltet.

* :deb:`gconf-editor`

  Der GNOME Configuration Editor (siehe `gconf-editor Manual`_).

* :deb:`elementary-icon-theme`

  Der Icon Theme aus `elementary OS`_ (s.a. `elementary icons
  <https://launchpad.net/elementaryicons>`_). Kann im `GNOME TweakTool`_ kann
  man im Erscheinungsbild *Elementary* für Symbole auswählen.

* :deb:`gir1.2-gtop-2.0`

  Das Paket beinhaltet die `GObject Introspection`_ zum System-Monitoring. Wird
  von manchen Tools zum System-Monitoring benötigt (z.B. `GNOME Shell
  System-Monitor Applet`_).

* :deb:`gir1.2-networkmanager-1.0`

  Das Paket beinhaltet die `GObject Introspection`_ für den `GNOME
  NetworkManager`_. Wird z.B. von dem `GNOME Shell System-Monitor Applet`_
  benötigt.

* :deb:`tracker`, :deb:`tracker-extract` und :deb:`tracker-miner-fs`

  Früher gab es mal die :deb:`tracker-gui` oder ``tracker-needle`` (`Tracker
  <https://wiki.gnome.org/Projects/Tracker/Documentation/GettingStarted>`_).
  Inzwischen gibt es das nicht mehr und die Integration in den GNOME-Desktop als
  auch in den Nautilus hat den Nachteil, dass nur nach Dateinamen gesucht wird.
  Als Ersatz habe ich mir die Shell Extension tracker-search-provider_
  installiert::

    $ sudo -H ./scripts/desktop_system.sh install GNOME-ext

  `GNOME Tracker`_ wird im Allgemeinen über die Desktop-Einstellungen verwaltet,
  dort kann man z.B. einstellen "was" indiziert werden soll. Für weitergehende
  Einstellungen gab es früher mal eine GUI ``tracker-preferences``, die gibt es
  aber auch nicht mehr. `GNOME Tracker`_ kann man in den gsettings einstellen
  (GUI wäre dann dconf), die Settings sind unter ``org.freedesktop.Tracker`` zu
  finden.

  Will man Unter-Ordner aus der Indizierung nehmen, kann man dort eine Datei
  Namens '.trackerignore' anlegen. Mehr gibt es hier:
  https://wiki.gnome.org/Projects/Tracker


Shell Erweiterungen
===================

Die `GNOME Shell Extensions`_ können vom Anwender über die WEB-Seite
https://extensions.gnome.org/ recherchiert und installiert werden. Für eine
systemweite Installation empfiehlt sich:

* `GNOME Shell System-Monitor Applet`_ (benötigt :deb:`gir1.2-gtop-2.0`,
  :deb:`gir1.2-networkmanager-1.0` und :deb:`gir1.2-clutter-1.0`).

* tracker-search-provider_ Eine GNOME-Shell Extension, mit der die
  Such-Ergebnisse aus dem Tracker in der Shell-Übersicht anzeigt werden.
