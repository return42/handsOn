.. -*- coding: utf-8; mode: rst -*-

.. _Node.js: https://nodejs.org/
.. _NodeSource: https://nodesource.com
.. _`Debian and Ubuntu based distributions`: https://github.com/nodesource/distributions#deb
.. _gruntjs: https://gruntjs.com/

.. |VER| replace:: 12
.. |VER URL| replace:: https://deb.nodesource.com/node_12.x/
.. |PACKAGES| replace::  ``nodejs``
.. |NPM_PACKAGES| replace:: ``grunt-cli``

.. _xref_install_nodejs:

================================================================================
Node.js & nmp
================================================================================

Die *binaries* des Node.js_ stehen auf der `Download-Seite
<https://nodejs.org/en/download/>`_ von Node.js_ zur Verfügung.  Über die Paket
Quellen des Ubuntu/Debian kann das Paket :deb:`nodejs` installiert werden.  In
Ubuntu 18.04 ist das beispielsweise Node.js v8.10 und in Ubuntu 19.04 ist es
Node.js v10.15.  Neuere (oder ältere) Versionen können über alternative
Paket-Repositories installiert werden (siehe `NodeSource Node.js Binary
Distributions`_).

.. _nodesource.com:

NodeSource Node.js Binary Distributions
=======================================

.. sidebar:: nodejs und npm

   Vor der Installation aus der *NodeSource Node.js Binary Distribution*
   empfiehlt es sich die Pakete ``nodejs`` und ``npm`` zu deinstallieren (falls
   sie aus den normalen Ubuntu Quellen schon mal installiert wurden).

NodeSource_ bietet Binary-Pakete für die gängigen Linux Distributionen an, so
z.B. für die `Debian and Ubuntu based distributions`_, deren dep-Repository für
Node.js (beispielsweise) v|VER| hier zu finden ist:

  |VER URL|

Über dieses Repository wird immer die aktuelle Node.js (beispielsweise) |VER|.x
Version schon beim Systemupdate installiert.  Man kann das Repository mit
:man:`add-apt-repository` hinzufügen und der Schlüssel für das Repository ist
hier zu finden:

  https://deb.nodesource.com/gpgkey/nodesource.gpg.key

In dem ``${SCRIPT_FOLDER}`` Ordner befindet sich ein Skript, das die folgenden
Schritte durchführt:

.. code-block:: bash

   $ sudo ./scripts/node_source.sh install

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

   $ sudo ./scripts/install_nodejs.sh deinstall

.. _npm_os_install:

npm Pakete im OS
================

Hat man eine Installation des Node.js über den Paketmanager (z.B. Ubuntu Quellen
oder :ref:`nodesource.com`), so kann man sich die Node.js Pakete (Werkzeuge und
Programme) über npm global (Option ``npm -g``) im System installieren.  Hier ein
Beispiel für die Installation des ``grunt-cli`` Pakets (gruntjs_) aus den npm
Paketquellen:

.. code-block:: bash

   $ sudo npm -g install grunt-cli

Hier ein Beispiel zum Anzeigen der im System installierten Node.js Pakete::

  $ npm -g --depth=0 ls
  /usr/lib
  ├── grunt-cli@1.3.2
  └── npm@6.12.0

Will man wissen, welche Versionen eines Pakets zur Verfügung stehen
(``versions`` plural)::

  $ npm view grunt-cli versions 
  [ ...
    '1.3.0',  '1.3.1',  '1.3.2'
  ]

Anzeigen der aktuellsten Version (``version`` singular)::

  $ npm view grunt-cli version
  1.3.2

Anzeigen der Pakete mit aktuelleren Versionen::

  $ npm outdated -g --depth=0
  Package  Current  Wanted  Latest  Location
  npm       6.12.0  6.12.1  6.12.1  global

Update der global installierten Pakete::

  $ sudo npm update -g
  /usr/bin/npm -> /usr/lib/node_modules/npm/bin/npm-cli.js
  /usr/bin/npx -> /usr/lib/node_modules/npm/bin/npx-cli.js
  + npm@6.12.1
  added 2 packages from 2 contributors, removed 2 packages and updated 12 packages in 3.741s
