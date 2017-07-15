.. -*- coding: utf-8; mode: rst -*-

.. include:: ../get_started_refs.txt

.. _xref_get_started:

================================================================================
                                  Get Started
================================================================================

.. toctree::
   :maxdepth: 1

   platform
   http_services.rst
   concept
   get_started_refs


Installation
============

.. code-block:: bash

    wget --no-check -O /tmp/bs.sh "https://github.com/return42/handsOn/raw/master/bootstrap.sh" ; bash /tmp/bs.sh

Mit dem Kommando wird das handsOn Repository in dem Ordner installiert, in dem
das Kommando ausführt wird und es werden die erforderlichen Basispakete über
:man:`apt-get` installiert. Sollte 'git' nicht bereits installiert sein, so
versucht das ``bootstrap`` Skript 'git' zu installieren, hierfür ist eine *sudo*
Berechtigung auf dem lokalem Host erforderlich.

Alternative zum ``bootstrap`` Skript kann die Installation auch
manuell vorgenommen werden, auch hierbei ist 'git' erforderlich.

.. code-block:: bash

   git clone https://github.com/return42/handsOn.git
   sudo handsOn/scripts/ubuntu_install_pkgs.sh base

Vor der Ersten Verwendung der Skripte (``./scripts``) empfiehlt es
sich noch die Datei::

  hostSetup/README.rst

zu lesen. Soll ein Server mit HTTP-Diensten eingerichet werden,
empfiehlt sich noch ein Blick auf :ref:`xref_http_services`.
