.. -*- coding: utf-8; mode: rst -*-

.. include:: ../desktop_system_refs.txt

.. _xref_desktop_system:

================================================================================
                               Desktop Umgebungen
================================================================================

.. toctree::
   :maxdepth: 1

   desktop_system_common
   display_manager
   gnome_shell
   cinnamon
   mate
   elementary
   desktop_system_refs

In dem ``${SCRIPT_FOLDER}`` Ordner befindet sich ein Skript, mit dem die hier
vorgestellten Setups installiert oder auch deinstalliert werden können.

.. code-block:: bash

   $ ./scripts/desktop_system.sh

   ==============
   Desktop System
   ==============

   usage:

   desktop_system.sh [chooseDM]
   desktop_system.sh install [GNOME[-ext|-dconf]]|GNOME3-PPA|elementary|cinnamon|mate|solaar]
   desktop_system.sh remove  [GNOME-ext]]|[unity|GNOME3-PPA|elementary|cinnamon|mate|solaar]

   - GNOME: volle Installation GNOME3-Shell https://wiki.gnome.org/Projects/GnomeShell
   - GNOME-ext: Empfohlene Shell-Extensions https://extensions.gnome.org/
   - GNOME-dconf: Anpassungen GNOME-Defaluts https://wiki.gnome.org/Projects/dconf/SystemAdministrators
   - GNOME3-PPA: PPA für GNOME3, ab ubuntu 18.04 nicht mehr erforderlich
   - elementary: Desktop des elementary-OS https://elementary.io/#desktop-development
   - cinnamon: Alter GNOME-Desktop, der von Linux-Mint weiter entwickelt wird
   - nemo: Installation des Dateibrowsers Nemo
   - mate: Mate-Desktop https://mate-desktop.org/
   - solaar: Linux-Gerätemanager für eine Vielzahl von Logitech-Geräten.


.. hint::

   Wenn eine Desktop-Umgebung installiert wird, dann steht sie meist noch nicht
   in der Auswahl des Display-Managers zur Verfügung. Der Display-Manager muss
   i.d.R. erst neu gestartet werden, damit er seinen Katalog an verfügbaren
   Desktop Umgebungen neu aufbaut. Das kann z.B. auch durch einen Reboot
   erreicht werden.

