.. -*- coding: utf-8; mode: rst -*-

.. include:: ../get_started_refs.txt

.. _xref_get_started_intro:

================================================================================
                                Target Platform
================================================================================

Primäres Ziel der handsOn Sammlung ist es, das Know-how zu Anwendungen und deren
Setups komprimiert zugänglich und *wartbar* zu machen, nicht aber, eine *fire
and forget* Lösung auf jeder Plattform anzubieten. Sofern eine Platform nicht zu
100% unterstützt wird kann man sich einen Fork der handsOn anlegen und die, für
eine bestimmte Plattform erforderlichen Anpassungen dort hinterlegen.

Die handsOn Sammlung wurde unter `Ubuntu (wiki)`_ getestet und die Skripte
sollten mit jeder aktuellen Ubuntu Version lauffähig sein. Langfristiges Ziel
ist es, dass die jeweils aktuelle LTS Version unterstützt wird, das ist derzeit
aber noch nicht zu 100% der Fall (mit Ubuntu 16.04 wird es nochmal eine Revision
geben).

Nicht getestet aber zu erwarten ist, dass die Installationsskripte auch auf
allen aktuellen und gängigen LTS Versionen der `Ubuntu-Derivate
<https://de.wikipedia.org/wiki/Liste_von_Linux-Distributionen#Ubuntu-Derivate>`_
wie z.B. `lubuntu`_ ohne Anpassungen laufen (:ref:`xref_debian_derivates_refs`).

Die meisten Installationen der handsOn Sammlungen basieren auf den `Advanced
Package Tool (APT)`_ und sollten damit auch auf `Debian`_ und anderen APT
basierten Distributionen funktionieren.  Aufgrund der konservativen Pakete in
`Debian`_ ist jedoch zu erwarten, dass dies nicht immer ohne Anpassungen wird
möglich sein.
