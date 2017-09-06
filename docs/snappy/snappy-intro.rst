.. -*- coding: utf-8; mode: rst -*-

.. include:: ../snappy_refs.txt

===============================================================================
snap Intro
===============================================================================

Ein Paket wird ``snap`` genannt und es wird mit dem gleichnamigen Kommando
installiert oder aber auch de-installiert. Aus einer Konfigurations-Datei
``snapcraft.yaml`` baut das ``snapcraft`` Kommando ein Paket (``snap``).

``snap``
  Kommando zur Wartung der Snappy_ Infrastruktur (z.B. snap-Pakete installieren
  oder deinstallieren). Benötigt in der Regel *sudo*-Rechte.

``snapcraft``
  Kommando zum Bauen von snap-Paketen.

``snapcraft.yaml``
  Konfigurations-Datei eines snap-Pakets

Die Anwendungen der snap-Pakete nutzen die gleiche root Umgebung (``/``) und die
gleichen Resourcen (z.B. IP) wie das restliche OS. Die Pakete die über ``snap``
installiert werden liegen jedoch **nicht** im *normalen* OS (z.B. nicht in
``/usr/bin`` sondern in ``/snap/bin``).  Für die snap-Pakete gibt es eine eigene
Infrastruktur in die ein snap-Pakte sammt seinen Abhängigkeiten installiert
wird. Die Installation von snap-Paketen ist in dieser Infrastruktur
weitestgehends vom OS entkoppelt.
