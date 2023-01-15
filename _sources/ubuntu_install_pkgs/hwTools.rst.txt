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
- exFAT_ (:deb:`exfat-utils`) ein Dateisystem das häufig auf SD-Karten verwendet
  wird.

Pakete:

- :deb:`powertop`
- :deb:`lm-sensors`
- :deb:`psensor`
- :deb:`pm-utils`
- :deb:`exfatprogs`


exFAT
=====

.. _deb_debian_and_exfat: https://sven.stormbind.net/blog/posts/deb_debian_and_exfat/
.. _exfat-file-system:
    https://www.kernel.org/doc/html/latest/process/maintainers.html#exfat-file-system
.. _exFAT (wiki): https://de.wikipedia.org/wiki/File_Allocation_Table#exFAT
.. _FUSE: https://www.kernel.org/doc/html/latest/filesystems/fuse.html

Seit Linux Kernel Version 5.7 ist das `exFAT (wiki)`_ Dateisystem bereits im
`Kernel <exfat-file-system>`_ implementiert und es ist nicht mehr nötig den
FUSE_ Treiber (:deb:`exfat-fuse`) dafür zu installieren.  Neben dem Treiber für
das Dateisystem gab es noch das Paket mit den Werkzeugen dafür
(:deb:`exfat-utils`). Diese Werkzeuge sind für die exFAT Implementierung im
Kernelm andere und das neue Paket dafür ist :deb:`exfatprogs` `[ref]
<deb_debian_and_exfat>`_.


Installation
============

.. code-block:: bash

   $ sudo -H ./scripts/ubuntu_install_pkgs.sh hwTools
