.. -*- coding: utf-8; mode: rst -*-

.. include:: get_started_refs.txt

.. _xref_get_started:
.. _xref_install_handson:

================================================================================
                                  Get Started
================================================================================

Zur Installation ein Terminal öffnen und folgendes eingeben::

    wget --no-check -O /tmp/bs.sh "https://github.com/return42/handsOn/raw/master/bootstrap.sh" ; bash /tmp/bs.sh

Mit dem Kommando wird das handsOn Repository in dem Ordner installiert, in dem
es ausführt wird.  Es werden die erforderlichen Basispakete über :man:`apt-get`
installiert.  Sollte git_ nicht bereits installiert sein, so versucht das
``bootstrap`` Skript git_ zu installieren, hierfür ist eine *sudo* Berechtigung
auf dem lokalem Host erforderlich.  Alternative zum ``bootstrap`` Skript kann
die Installation auch manuell vorgenommen werden, auch hierbei ist git_
erforderlich.::

   git clone https://github.com/return42/handsOn.git
   sudo handsOn/scripts/ubuntu_install_pkgs.sh base

Bei dem ersten Aufruf eines der Skripte wird eine :term:`.config` Datei sowie ein
Ordner eingerichtet.  In dem Ordner werden die Konfigurationen gesichert (siehe
auch :ref:`xref_handson_concept`).  Am besten man macht das gleich mal als
Erstes und lässt sich dabei noch das Setup anzeigen (:ref:`info.sh <info_sh>`)::

   ./scripts/info.sh

Die Ausgabe ist dann in etwa:

.. parsed-literal::

  INIT: It seems to be the first time you are using handsOn scripts,
  INIT: a default setup is created right now ...
  INIT:  --> create initial /share/handsOn/.config
  INIT:  --> create version controlled folder to store configurations:
  INIT:       **/share/handsOn/hostSetup**
  INIT:  --> create inital setup from example_setup.sh in
  INIT:       **/share/handsOn/hostSetup/ryzen_setup.sh**
  ...

  handsOn setup
  =============

  loaded /share/handsOn/hostSetup/ryzen_setup.sh

  CONFIG        : /share/handsOn/hostSetup/ryzen
  ORGANIZATION  : myorg
  ...
  Tools:

    MERGE_CMD           : **merge2FilesWithEmacs**
    THREE_WAY_MERGE_CMD : **merge3FilesWithEmacs**

.. hint::

   Wenn Sie mit dem Emacs_ nicht klar kommen, dann sollten Sie am besten gleich
   jetzt die Variablen :ref:`MERGE_CMD <MERGE_CMD>` und
   :ref:`THREE_WAY_MERGE_CMD <THREE_WAY_MERGE_CMD>` in der :term:`.config` so
   ändern, dass der Meld_ verwendet wird::

     MERGE_CMD=merge2FilesWithMeld
     THREE_WAY_MERGE_CMD=merge3FilesWithMeld

Hier in dem Beispiel werden die Config-Dateien der Hosts im Ordner
:term:`hostSetup` gesammelt und versioniert.  Der Name des Hosts aus
obigen Beispiel ist ``ryzen``.  Anpassungen für diesen Host werden in der Datei
``./hostSetup/ryzen_setup.sh`` vorgenommen.  Die Versionierung der
Config-Dateien ist Teil des :ref:`handsOn-Konzepts <xref_handson_concept>`.



