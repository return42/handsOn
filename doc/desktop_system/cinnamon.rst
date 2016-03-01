.. -*- coding: utf-8; mode: rst -*-

.. include:: ../desktop_system_refs.txt

.. _xref_cinnamon:

================================================================================
                                Cinnamon Desktop
================================================================================

Das Layout des `Cinnamon`_ Desktop ist mit dem GNOME 2 verwandt, bzw. eine
Weiterentwicklung des Layouts von GNOME 2. Die Code-Basis `Cinnamon (github)`_
ist ein Fork der GNOME-Shell. Es bestehen 4 Arten von *Erweiterungen*:

* Desktop-Themes: Es gibt vorkonfektionierte Desktop *Themen*, die z.T. schon
  installiert sind, andere können aus dem Internet bezogen werden. So z.B. das
  `Void Thema <http://cinnamon-spices.linuxmint.com/themes/view/104>`_, dass
  auch gut mit dem :deb:`elementary-icon-theme` kombiniert werden kann.

* Applets: sind kleine Anwendungen, die in die Fensterleiste(en) installiert
  werden können. Es gibt vorkonfektionierte Applets, die z.T. schon installiert
  sind. So sind z.B. das *Menü* und anderer Bedienelemente in der
  Fensterleiste. Weitere Applets können aus dem Internet bezogen werden. Für das
  Systemmonitoring kann `Multi-Core System Monitor
  <http://cinnamon-spices.linuxmint.com/applets/view/79>`_ empfohlen werden.

* Desklets: sind kleine Anwendungen die auf den Desktop Hintergund gelegt werden
  können. Auch hier gibt es wieder vorkonfektioniertes im Internet.

* Extensions: sind Erweiterungen der Desktop Umgebung. Auch hier können
  vorkonfektionierte Erweiterungen aus dem Internet bezogen werden. Für eine
  differnzierte Fenster-Platzierung empfiehlt sich die Erweiterung `gTile
  <http://cinnamon-spices.linuxmint.com/extensions/view/21>`_.

Alle diese Erweiterungen, Themes, Applets und Desklets können über die
gleichnamigen Tools in den *System-Einstellungen* verwaltet werden. Alle
vorkonfektionierten Erweiterungen werden aus dem Internet von `Cinnamon Spices`_
bezogen.  Man wird jedoch feststellen, dass die Auswahl an `GNOME Shell
Extensions`_ wesentlich größer ist. Dennoch, das *Meiste* was man so braucht,
findet sich auch in den `Cinnamon Spices`_.

Installation
============

In dem ``${SCRIPT_FOLDER}`` Ordner befindet sich ein Skript, mit dem die
Cinnamon Desktop Umgebung installiert werden kann.

.. code-block:: bash

   $ sudo ${SCRIPT_FOLDER}/desktop_system.sh cinnamon

Mit dem oben stehenden Skript wird das Paket :deb:`cinnamon-desktop-environment`
installiert. Das Paket umfasst den Cinnamon Desktop der recht *schlank* ist. Der
Desktop ist eine gute Alternative zur GNOME-Shell, eine Installation neben der
GNOME-Shell kann ich nur empfehlen.

De-Installation
===============

Zur De-Installation eignet sich:

.. code-block:: bash

   $ sudo ${SCRIPT_FOLDER}/desktop_system.sh remove_cinnamon
