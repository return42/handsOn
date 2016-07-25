.. -*- coding: utf-8; mode: rst -*-

.. include:: ../get_started_refs.txt

.. _xref_get_started:

================================================================================
                                  Get Started
================================================================================

.. toctree::
   :maxdepth: 1

   platform
   concept
   get_started_refs


Installation
============

.. code-block:: bash

    wget --no-check -O /tmp/bs.sh "https://github.com/return42/handsOn/raw/master/bootstrap.sh" ; bash /tmp/bs.sh

Mit dem Kommando wird das handsOn Repository in dem Ordner installiert, in dem
das Kommando ausführt wird und es werden die erforderlichen Basispakete über
:man:`apt-get` installiert. Eine alternative Installation

.. code-block:: bash

   git clone https://github.com/return42/handsOn.git
   sudo handsOn/scripts/ubuntu_install_pkgs.sh base
