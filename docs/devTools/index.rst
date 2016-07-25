.. -*- coding: utf-8; mode: rst -*-

.. include:: ../devTools_refs.txt

.. _xref_ubuntu_devTools:

================================================================================
                               Entwickler Pakete
================================================================================

Auch als *Nicht-Entwickler* wird man über kurz oder lang einige der *Entwickler
Pakete* benötigen. Spätestens wenn Software installiert wird, die als *Source*
und nicht als *Binary* vorliegt muss diese in irgendeiner Form kompiliert
werden.  Sobald man bei einem Installationsprozess ``make`` eintippen muss, kann
man sich sicher sein, dass ein -- wie auch immer gearteter -- Build-Prozess
damit angestoßen wird, für den auch ein minimaler Satz an Build-Tools benötigt
wird.  Die Build-Tools werden auch `Toolchain (wiki)`_ genannt.

.. toctree::
   :maxdepth: 1

   debian
   build
   python
   edit
   scm
   relationalDB
   devTools_refs


Installation
============

Die in den einzelnen Abschnitten vorgestellten Pakete können mit dem Skript
``ubuntu_install_pkgs.sh`` installiert werden.

.. code-block:: bash

   $ sudo ${SCRIPT_FOLDER}/ubuntu_install_pkgs.sh devTools
