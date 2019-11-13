.. -*- coding: utf-8; mode: rst -*-

.. include:: ../nodejs_refs.txt

.. |VER| replace:: 12
.. |VER URL| replace:: https://deb.nodesource.com/node_12.x/
.. |PACKAGES| replace::  ``nodejs``
.. |NPM_PACKAGES| replace:: ``grunt-cli``  ``webpack``  ``webpack-cli``
			    ``lodash``     ``babel``    ``eslint``
			    ``@vue/cli``
.. _install_nodejs:

====================
Installation Node.js
====================

.. sidebar:: install: nodejs

   .. code-block:: bash

      sudo ./nodejs-dev.sh install nodejs

Die *binaries* des Node.js_ stehen auf der `Node.js Download-Seite
<https://nodejs.org/en/download/>`_ zur Verfügung.  Besser eignet sich aber die
in Kapitel `NodeSource: Node.js Binary Distributions`_ beschriebene
Installationsmethode.

Wurden die Pakete ``nodejs`` und ``npm`` aus den normalen Ubuntu Quellen oder
anderweitig bereits installiert, so müssen diese vor einer erneuten Installation
aus einer anderen Quelle zuvor deinstalliert werden.

Paketquellen des Ubuntu/Debian
==============================

Über die Paket Quellen des Ubuntu/Debian kann das Paket :deb:`nodejs`
installiert werden.  In Ubuntu 18.04 ist das beispielsweise Node.js v8.10 und in
Ubuntu 19.04 ist es Node.js v10.15.  Neuere (oder ältere) Versionen können über
alternative Paket-Repositorien installiert werden (siehe `NodeSource: Node.js
Binary Distributions`_).

.. _nodesource.com:

NodeSource: Node.js Binary Distributions
========================================

NodeSource_ bietet Binary-Pakete für die gängigen Linux Distributionen an, so
z.B. für die `Debian and Ubuntu based distributions`_, deren dep-Repository für
Node.js (beispielsweise) v\ |VER| hier zu finden ist:

  |VER URL|

Über dieses Repository wird immer die aktuelle Node.js (beispielsweise) |VER|.x
Version schon beim Systemupdate installiert.  Man kann das Repository mit
:man:`add-apt-repository` hinzufügen und der Schlüssel für das Repository ist
hier zu finden:

  https://deb.nodesource.com/gpgkey/nodesource.gpg.key

In dem ``${SCRIPT_FOLDER}`` Ordner befindet sich ein Skript, das die folgenden
Schritte durchführt:

.. code-block:: bash

   $ sudo ./scripts/nodejs-dev.sh install nodejs

1. Deinstallation ggf. konfligierender Pakete
2. Repository hinzufügen |VER URL|
3. Hinzufügen des Public-Key von https://deb.nodesource.com
4. apt-Katalog aktualisieren
5. Installation der debian Pakete aus den neuen Paketquellen: |PACKAGES|
6. Systeminstallation der npm Pakete (s.a. :ref:`npm_os_install`): |NPM_PACKAGES|

De-Installation des ``nodejs`` Pakets und das Löschen des Reposetory Eintrags
von NodeSource in den APT-Sourcen ist mit dem folgenden Kommando einfach
möglich:

.. code-block:: bash

   $ sudo ./scripts/nodejs-dev.sh remove nodejs

