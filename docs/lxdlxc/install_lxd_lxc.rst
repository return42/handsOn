.. -*- coding: utf-8; mode: rst -*-

.. include:: ../lxdlxc_refs.txt

.. _install_lxdlxc:

================
LXD Installation
================

Mit LXD_ hat man Zugriff auf die `LXC/LXD Image Server`_.  Früher hat man LXD
noch über den Paketmanager der Distributionen installiert, inzwischen wird das
nicht mehr empfohlen und geht wohl zum Teil auch gar nicht mehr.  Inzwischen
wird fast nur noch die LXD Installation über snap_ unterstützt.  Um snap_ zu
installieren:

.. code-block:: bash

   $ sudo -H apt install snapd

Über die Paketverwaltung :ref:`snap <snap>` die erforderlichen Pakete
installieren (s.a. `Introduction to LXD projects`_):

.. code-block:: bash

   $ sudo -H snap install lxd

Zur Installation gehört noch eine initiales Setup des LXD in dem der
Image-Server als auch z.B. die Eigenschaften des (LXD) Netzwerks eingestellt
werden.

.. code-block:: bash

   $ sudo -H lxd init --auto

Weitere Hinweise siehe: `snapcraft LXD <https://snapcraft.io/lxd>`_
