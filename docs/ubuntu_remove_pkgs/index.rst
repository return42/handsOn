.. -*- coding: utf-8; mode: rst -*-

.. _xref_ubuntu_remove_pkgs:

================================================================================
                           Zweifelhafte Ubuntu Pakete
================================================================================

Die Ubuntu Distribution bringt im Default so einiges an Paketen mit, die man
u.U. nicht auf seinen Hosts installiert haben möchte. In dem ``${SCRIPT_FOLDER}``
Ordner befindet sich ein Skript, das alle hier vorgestellten Schritte
durchführt.

.. code-block:: bash

   $ sudo ./scripts/ubuntu_remove_pkgs.sh

Ubuntu typische Pakete
======================

Es werden die folgenden Pakete entfernt::

   unity-webapps-common
   $(dpkg-query -f '${binary:Package} ' -W 'xul-ext*')
   ureadahead
   whoopsie
   flashplugin-installer
   evolution-data-server-online-accounts

:deb:`unity-webapps-common` / xul-ext*:

   Dieser ganze Unity Kram ist nur buggy. Z.B. die xul-Erweiterungen für den
   Firefox, Die sind schon seit seit 2012 fehlerhaft und man hat auch nur bis
   2015 gebraucht um den Bug zu fixen (3 Jahre hat mich das genervt).

   * https://bugs.launchpad.net/ubuntu/+source/unity-firefox-extension/+bug/1069793

:deb:`ureadahead`:

   Scheint seit 12.04 buggy und müllt das syslog voll. Wird seit 2010 nicht mehr
   gepflegt und aktuell 27 offene Bugs ... wieso hat man so einen Schrott in
   seiner Distro?

   * https://bugs.launchpad.net/ubuntu/+source/ureadahead

:deb:`whoopsie`:

   Der Crash Reporter von Ubuntu :deb:`whoopsie` kann deinstalliert werden. Den
   Ereignissdienst :deb:`zeitgeist` kann man auch ohne den Crash Reporter
   betreiben.

:deb:`flashplugin-installer`:

   Flash ist einfach nur eine Seuche.

:deb:`evolution-data-server-online-accounts`

   Das sind die Bibliotheken und Tools um Google/Microsoft und Yahoo Mail-
   bzw. Kalenderkonten einzrichten. Wer `Evolution
   <https://wiki.gnome.org/Apps/Evolution>`_ nicht nutzt oder keine Onlinekonten
   verwalten muss, der kann dieses Paket deinstallieren.


Kommerzielle Pakete
===================

Es werden die folgenden Pakete entfernt::

 software-center app-install-data

:deb:`software-center`

   Der `Ubuntu Software Center <https://apps.ubuntu.com/>`_. Auf einem Server
   oder einem Desktop in einem Unternehmensumfeld ist ein Shop-System eher
   störend. Wer nicht die Absicht hat Produkte über den Shop zu kaufen, kann
   sich auch auf dem Desktop mit der :man:`synaptic` GUI Programme aus den
   Reposetories installieren. Für die Freunde des Terminals gibt es
   :man:`aptitude`.

:deb:`app-install-data`

   Wozu man das braucht ist mir nicht ganz klar. Ich hab den Eindruck, das Paket
   wird in einer *normalen* Ubunut Instanz nur vom :deb:`software-center`
   genutzt.  Mit 45MB ist die Installation auch nicht eben klein, weshalb ich
   besser drauf verzichte.

Online-Konten-Verwaltung (gnome)
================================

Es werden die folgenden Pakete entfernt::

  $(dpkg-query -f '${binary:Package} ' -W 'account-plugin*')

``account-plugin*``

  Die Pakete mit dem Prefix ``account-plugin*`` werden benötigt, wenn man in
  seinem Gnome die Online-Konten von Facebook, Google und Co. verwalten will.
