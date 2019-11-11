.. -*- coding: utf-8; mode: rst -*-

.. include:: ../nodejs_refs.txt

.. _npm_os_install:

================
npm Pakete im OS
================

.. sidebar:: ./scripts/nodejs-dev.sh 

   Ein Skript, das die globale NodeJS Instalation komplett aktualisiert:

   .. code-block:: bash

      sudo ./nodejs-dev.sh update nodejs

Hat man eine Installation des Node.js über den Paketmanager (z.B. Ubuntu Quellen
oder :ref:`nodesource.com`), so kann man sich die Node.js Pakete (Werkzeuge und
Programme) über npm global (Option ``npm -g``) im System installieren.  Hier ein
Beispiel für die Installation des ``grunt-cli`` Pakets (gruntjs_) aus den npm
Paketquellen:

.. code-block:: bash

   $ sudo npm -g install @vue/cli

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
