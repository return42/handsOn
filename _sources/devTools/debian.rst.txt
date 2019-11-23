.. -*- coding: utf-8; mode: rst -*-

.. include:: ../devTools_refs.txt

.. _xref_ubuntu_devTools-debian:

================================================================================
                                     Debian
================================================================================

Alle `Debian-Derivate (wiki)`_ benutzen die Debian Toolchain der
Paketverwaltung, bei der Software mittels deb-Pakete (``.deb``) installiert
wird, siehe `Debian Paket (wiki)`_.  Dabei gibt es zum einen deb-Pakete in denen
die *Binaries* sind und zum anderen deb-Pakete in denen die *Sourcen* zu einer
Software enthalten sind.  Die *Binary* Pakete sind für jede Hardware speziefisch
kompilierte *Sourcen* (meist 32Bit und 64Bit Varianten).  Die *Source* Pakete
sind immer die gleichen.

Mit einen deb-Paket kann *ein* Programmpaket installiert werden (`Debian
Package`_).  Um *mehrere* Pakete zu verwalten und ein Update-Verfahren
anzubieten wird ein Paketmanager benötigt, siehe auch `Paketverwaltung (wiki)`_.
Als Paketmanager kommt bei den Debian-Derivaten `APT (wiki)`_ zur Anwendung.
Eine Übersicht über die Paketverwaltung von Debian ist in dem `Debian Package
Managment`_ Artikel zu finden.

Ein Paketmanager bezieht seine Pakete aus einem Reposetory.  Bei APT werden die
Reposetories beispielsweise in den Dateien unter ``/etc/apt/sources.list[.d/*]``
registriert.  Zu einer vollständigen Paketverwaltung gehören aber noch weitere
Bestandteile, so bedarf es z.B. einer Konfigurationsverwaltung mit der die
Konfiguration einer Installation gemanaged werden kann.  Bei Debian übernimt
:man:`debconf-devel` die Konfigurationsverwaltung.

Pakete wie :deb:`debconf` oder aber :deb:`apt` brauchen nicht installiert
werden. Da sie Teil des Debian Ökosystems sind, sind sie bereits auf jeder
OS-Installation enthalten.  Ergänzend können noch die folgenden Pakete empfohlen
werden.

* :deb:`devscripts`

Mit dem :deb:`devscripts` werden eine Reihe von Tools installiert, die bei der
Paketerzeugung und Introspektion hilfreich sind.

* :deb:`dkms`

Mit dem :deb:`dkms` werden die Tools für einen dynamischen Support von
Kernelmodulen installiert.  Kernelmodule wie z.B. Treiber die nicht über das
APT-Reposetory bezogen wurden, müssen mit jedem Update des Kernels neu
kompiliert werden. Mit dem *Dynamic Kernel Module Support* `DKMS (archlinux)`_
kann dieser Vorgang automatisiert werden, so dass mit jedem Kernel Update auch
diese Treiber aktualisiert werden. Insbesondere bei Graphik-Treibern, die man
evtl. vom Hersteller installiert hat, wird man es schnell zu schätzen wissen,
dass man auch nach einem Kernel Update (mit Reboot) nicht vor einer *dunklen*
Scheibe sitzten muss ;-)

