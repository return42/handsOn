.. -*- coding: utf-8; mode: rst -*-

.. include:: ../nodejs_refs.txt

.. _xref_vscode:

==================
Visual Studio Code
==================

.. sidebar:: install: vscode

   .. code-block:: bash

      $ sudo ./nodejs-dev.sh install vscode

Visual Studio Code (VSCode_) ist ein freier Quelltext-Editor von Microsoft
(basierend auf ElectronJS_).  Er kann über die `Dowload-Seite
<https://code.visualstudio.com/Download>`_ für die gängigen Plattformen bezogen
werden.  Auf den Ubuntu Systemen ist u.A. ein Version über :ref:`Snap <snap>`
verfügbar, es empfiehlt sich aber die unten beschriebene Installation der VSCode
Paketquellen vorzunehmen, so hat man die Updates des VSCode_ gleich schon mit
dem OS-Update erledigt.

.. admonition:: Telemetry

   Sowohl VSCode_ als auch GitLense_ versenden *Telemetry* Daten
   (z.B. chrash-reports).  Unter :menuselection:`File > Preferences > Settings`
   kann man nach *telemetry* suchen und die entsprechenden Einstellungen
   `deaktivieren
   <https://code.visualstudio.com/docs/supporting/FAQ#_how-to-disable-crash-reporting>`__.
   Damit die Änderungen aktiv werden muss VSCode einmal neu gestartet werden.

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

- Vetur_: Vue tooling for VSCode
- vscode-Python_: Python extension for VSCode
- GitLense_: supercharges the Git capabilities built into VSCode
- vscode-reStructuredText_: reStructuredText Language Support for VSCode
