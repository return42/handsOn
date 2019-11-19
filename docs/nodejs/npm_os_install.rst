.. -*- coding: utf-8; mode: rst -*-

.. include:: ../nodejs_refs.txt

.. _npm_os_install:

================
npm Pakete im OS
================

.. sidebar:: install: global npm Pakete

   .. code-block:: bash

      sudo -H ./nodejs-dev.sh install npm-global

Hat man eine Installation des Node.js über den Paketmanager (z.B. Ubuntu Quellen
oder :ref:`nodesource.com`), so kann man sich die Node.js Pakete (Werkzeuge und
Programme) über npm global (Option ``npm -g``) im System installieren.  Hier ein
Beispiel für die Installation des ``grunt-cli`` Pakets (gruntjs_) aus den npm
Paketquellen:

.. code-block:: bash

   $ sudo -H npm -g install @vue/cli

Hier ein Beispiel zum Anzeigen der im System installierten Node.js Pakete::

  $ npm -g --depth=0 ls
  /usr/lib
  ├── @quasar/cli@1.0.2
  ├── @vue/cli@4.0.5
  ├── eslint@6.6.0
  ├── gradle@1.0.9
  ├── grunt-cli@1.3.2
  ├── npm@6.13.0
  ├── webpack@4.41.2
  └── webpack-cli@3.3.10

Will man wissen, welche Versionen eines Pakets zur Verfügung stehen
(``versions`` plural)::

  $ npm view eslint versions
  [ ...
    '6.4.0', '6.5.0', '6.5.1', '6.6.0'
  ]

Anzeigen der aktuellsten Version (``version`` singular)::

  $ npm view eslint version
  6.6.0

Anzeigen der Pakete mit aktuelleren Versionen::

  $ npm outdated -g --depth=0
  Package  Current  Wanted  Latest  Location
  npm       6.12.0  6.12.1  6.12.1  global

Update der global installierten Pakete::

  $ sudo -H npm update -g
  /usr/bin/npm -> /usr/lib/node_modules/npm/bin/npm-cli.js
  /usr/bin/npx -> /usr/lib/node_modules/npm/bin/npx-cli.js
  + npm@6.12.1
  added 2 packages from 2 contributors, removed 2 packages and updated 12 packages in 3.741s
