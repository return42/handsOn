.. -*- coding: utf-8; mode: rst -*-

================================================================================
                                handsOn Sammlung
================================================================================

Willkommen bei **handsOn**, einer Sammlung von Skripten und Dokumentationen zur
Installation von Anwendungen und Diensten (*kurz:* **Setup**). Die handsOn
bieten fertige Setups und unterstützen bei der Versionierung derselben.  Bitte
``LICENSE.txt`` beachten.

* Dokumentation: http://return42.github.io/handsOn
* Reposetorie:   `github return42/handsOn <https://github.com/return42/handsOn>`_
* Autho e-mail:  *markus.heiser*\ *@*\ *darmarIT.de*


Installation
============

.. code-block:: bash

    wget --no-check -O /tmp/bs.sh "https://github.com/return42/handsOn/raw/master/bootstrap.sh" ; bash /tmp/bs.sh

Mit dem Kommando wird das handsOn Repository in dem Ordner installiert, in dem
das Kommando ausführt wird und es werden die erforderlichen Basispakete über
``apt-get`` installiert. Eine alternative Installation:

.. code-block:: bash

  git clone https://github.com/return42/handsOn.git
  sudo handsOn/scripts/ubuntu_install_pkgs.sh base

