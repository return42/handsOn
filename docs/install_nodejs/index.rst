.. -*- coding: utf-8; mode: rst -*-

.. _xref_install_nodejs:

================================================================================
                       Node.js aus dem NodeSource Projekt
================================================================================

Das :deb:`nodejs` Paket des Ubuntu/Debian scheint mir ziemlich veraltet zu sein
(*Ubunut 15.10, in 16.04 wird es etwas besser, ist aber immernoch alt*). Neuere
Entwicklungen bekommt man damit meist nicht zum Laufen oder nur mit großen
Problemen.  Alternativ kann man sich die *binaries* auch auf der Download-Seite
von `Node.js <https://nodejs.org/>`_ runter laden:

  * https://nodejs.org/en/download/

Besser finde ich aber eine Installation über alternative debian Pakete (PPAs
:man:`add-apt-repository`). Eine solche Installation hat den Vorteil, dass sie
bei den Systemupdates ebenfalls aktuell gehalten wird.  Das Verfahren resp. die
apt-sourcen stammen von `NodeSource <https://nodesource.com/>`_:

  * https://github.com/nodesource/distributions#deb


Installation
============

In dem ``${SCRIPT_FOLDER}`` Ordner befindet sich ein Skript, das die folgenden
Schritte durchführt.

.. code-block:: bash

   $ sudo ./scripts/nodejs-dev.sh install nodejs

* Einrichten der Paketquellen von https://deb.nodesource.com/node_4.x
  (:man:`add-apt-repository`)
* Eintragen des public-key von https://deb.nodesource.com/node_4.x
* Apt-Katalog aktualisieren
* Installation des debian Pakets ``nodejs`` aus den neuen Paketquellen

De-Installation
===============

Eine De-Installation des ``nodejs`` Pakets und das Löschen des PPA Eintrags
von NodeSource in den APT-Sourcen ist mit dem folgenden Kommando einfach möglich.

.. code-block:: bash

   $ sudo ./scripts/nodejs-dev.sh remove nodejs



