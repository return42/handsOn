.. -*- coding: utf-8; mode: rst -*-

.. include:: ../nodejs_refs.txt

.. _xref_vscode:

==================
Visual Studio Code
==================

.. sidebar:: install vscode

   .. code-block:: bash

      $ sudo ./nodejs-dev.sh install vscode

Visual Studio Code (VSCode_) ist ein freier Queltexteditor von Mikrosoft
(basierend auf ElectronJS_).  Er kann über die `Dowload-Seite
<https://code.visualstudio.com/Download>`_ für die gängigen Plattformen bezogen
werden.  Auf den Ubuntu Systemen ist u.A. ein Version über Snap verfügbar, es
empfiehlt sich aber die `Installation VSCode Paketquellen`_ vorzunehmen, so hat
man Updates des VSCode_ gleich schon mit dem OS-Update.

.. _install_vscode:

Installation VSCode Paketquellen
================================

Für debian/Ubuntu bietet Microsoft die `VSCode Paketquellen`_ an.  In dem
Kapitel `Debian and Ubuntu based distributions`_ wird die Installation dieser
Paketquellen beschrieben.  Die Installation besteht im wesentlichen aus den
Schritten:

1. Repository einrichten::

    add-apt-repository \
      "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

2. Public-Key für das Repository einrichten

3. APT Paket ``code`` installieren.

Mit dem ``./scripts/nodejs-dev.sh`` geht es wesentlich einfacher:

.. code-block:: bash

   $ sudo ./scripts/nodejs-dev.sh [install|update|remove] vscode

.. _vscode_plugins:

Plugins
=======

- Vetur_: Vue tooling for VS Code
