.. -*- coding: utf-8; mode: rst -*-

.. include:: ../ubuntu_install_pkgs_refs.txt

.. _xref_ubuntu_archTools:

================================================================================
                          Archivierung / Komprimierung
================================================================================

Auf Linux ist so ziemlich jeder *Packer* verfügbar, hier eine kleine Auswahl:

* :deb:`file-roller` GUI *archive manager for GNOME*, siehe `GNOME File Roller
  <https://wiki.gnome.org/Apps/FileRoller>`_

* :deb:`tar` *The GNU version of the tar archiving utility*, siehe Manual
  :man:`tar`

* :deb:`zip` und :deb:`unzip` siehe Manual :man:`zip` und :man:`unzip`

* :deb:`gzip` *GNU compression utilities*, siehe Manual :man:`gzip`

* :deb:`rar` und :deb:`unrar` siehe Manual :man:`rar` und :man:`unrar-free`

* :deb:`p7zip-full` 7z und 7za Archiver, siehe Manual :man:`7z` und :man:`7za`

* :deb:`p7zip-rar` *non-free* rar Bibliothek für ``p7zip-rar``

* :deb:`cabextract` *Microsoft Cabinet file unpacker*, siehe Manual :man:`cabextract`

* :deb:`sharutils` siehe Manual :man:`shar`, :man:`unshar`, :man:`uuencode`,
  :man:`uudecode`

* :deb:`uudeview` *Smart multi-file multi-part decoder* siehe Manual :man:`uudeview`

* :deb:`mpack` *pack a file in MIME format* , siehe Manual :man:`mpack`

* :deb:`unace` siehe Manual :man:`unace`

* :deb:`arj` siehe Manual :man:`arj`


Installation
============

.. code-block:: bash

   $ sudo ${SCRIPT_FOLDER}/ubuntu_install_pkgs.sh archTools

