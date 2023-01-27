.. -*- coding: utf-8; mode: rst -*-

.. include:: ../android_refs.txt

.. _android_recovery:

================
Recovery & Flash
================

Mit *Recovery* oder auch *Wiederherstellung* ist das Booten einer Recovery
Partition gemeint. Man kann sich das so vorstellen als würde man ein
*Rettungs-System* von einer CD booten nur mit dem Unterschied, dass es keine CD
gibt. Das Rettungs- (oder auch Recover-) System ist auf einer Partition im
Android Device installiert. Der Speicher im Android Device ist in Partitionen
aufgeteilt. Auf einer Partition liegt das Recovery-Image auf einer anderen das
Android Betriebsystem, das normalerweise gestartet wird (boot). Die Android
Geräte verfügen z.T. über eine ganze Reihe von Partitionen (siehe
z.B. :ref:`SM-T580_PIT` dort findet man auch ``Partition Name: RECOVERY``).
Legt man z.B. eine SD-Karte ein und formatiert die, so hat man mindestens eine
weitere Partition.

Die Ausprägung der Recovery Partition variert und ist nicht für alle Geräte
gleich. Da die Recovery Systeme der Hersteller meist noch nicht mal ein
*Recovery* im Sinne von *Wiederherstellung* anbieten und i.d.R. auch
undokumentiert sind, kann man die meist zu nichts gebrauchen.  Es gibt *freie*
Alternativen wie z.B. das TWRP_ (s.a. :ref:`twrp_intro`), das inzwischen so was
wie der Standard der *Custom-Recovery-Systeme* ist.

- Stock-Recovery: Recovery-System des Herstellers
- Custom-Recovery: alternatives Recovery-System
