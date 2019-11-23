.. -*- coding: utf-8; mode: rst -*-

.. include:: ../ubuntu_install_pkgs_refs.txt

.. _xref_ubuntu_hwTools:

================================================================================
                              Sensoren / Hardware
================================================================================

Zu den *Hardware-Tools* zählen:

- :man:`powertop` zur Bewertung des Stromverbrachs von Programmen
- :man:`pm-suspend`, :man:`pm-hibernate` etc. für die Power-Save Modi
- :man:`psensor` für die Temparaturüberwachung
- exFAT (:deb:`exfat-utils`) ein Dateisystem das häufig auf SD-Karten verwendet
  wird.

Pakete:

- :deb:`powertop`
- :deb:`lm-sensors`
- :deb:`psensor`
- :deb:`pm-utils`
- :deb:`exfat-fuse`
- :deb:`exfat-utils`

Installation
============

.. code-block:: bash

   $ sudo -H ./scripts/ubuntu_install_pkgs.sh hwTools

