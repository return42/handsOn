.. -*- coding: utf-8; mode: rst -*-

.. include:: ../lxdlxc_refs.txt
.. include:: ../docker_refs.txt

.. _xref_docker:

======
Docker
======

Docker_ vereinfacht die Bereitstellung von Anwendungen in Containern.  Es
basiert auf LXC_ besitzt jedoch inzwischen eine eigene API (``libcontainer``).

- :ref:`container_intro`
- :ref:`xref_lxdlxc`

Vergleicht man Docker mit LXC_, so kann man vereinfacht sagen, dass man mit
Docker_ eher Anwendungen *virtualisiert*, während man mit LXC_ eher
Betriebsysteme *virtualisiert*, die allerdings alle den gleichen Kernel
verwenden. Beides sind leichtgewichtige *Virtualisierer*, die keine Hardware
emulieren (VM), sondern *virtuelle Umgebungen* (VE) über ein entsprechendes
Rechte-Management im Kernel gegeneinander isoliert.

Dokumentation: docs.docker_
