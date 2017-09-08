.. -*- coding: utf-8; mode: rst -*-

.. include:: ../lxdlxc_refs.txt

.. _install_lxdlxc:

================
LXD Installation
================

Die gängigen Distributionen stellen LXD_ bereits zur Verfügung (`packages
<https://linuxcontainers.org/lxd/getting-started-cli/#getting-the-packages>`__).
Eine Installation mit dem Paketmanager APT wäre z.B:

.. code-block:: bash

  $ sudo apt install lxd lxd-client

Alternativ besteht die Möglichkeit über die Paketverwaltung :ref:`snap <snap>`
die erforderlichen Pakete zu installieren:

.. code-block:: bash

   $ snap install lxd

Zur Installation gehört noch eine initiales Setup des LXD in dem der
Image-Server als auch z.B. die Eigenschaften des (LXD) Netzwerks eingestellt
werden.

.. code-block:: bash

   $ sudo lxd init

Weitere Hinweise siehe: `LXD 2.0: Installing and configuring LXD
<https://insights.ubuntu.com/2016/03/16/lxd-2-0-installing-and-configuring-lxd-212/>`_
