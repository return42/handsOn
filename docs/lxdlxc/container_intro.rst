.. -*- coding: utf-8; mode: rst -*-

.. include:: ../lxdlxc_refs.txt
.. include:: ../docker_refs.txt

.. _container_intro:

Was sind Container?
===================

Container dienen der Virtualisierung auf Betriebssystemebene und sind irgendwas
zw. einer virtuellen-Maschine (VM) und einer `chroot (wiki)`_ Umgebung. Bei der
`Containervirtualisierung (wiki)`_ wird keine Hardware emuliert -- das würde man
korrekter Weise dann VM nennen -- sondern eine isolierte Umgebung (VE) bereit
gestellt, in der Anwendungen laufen. Eine solche Anwendung kann der init-Prozess
sein, dann würde ein ganzes Betriebsystems isoliert angeboten werden oder eben
auch nur eine einzelne Anwendung. Für beides (App & OS) gilt, dass sie den
Kernel des HOST-Systems und die ihm zur Verfügung stehenden Hardware Resourcen
nutzen. Dies ist wiederum genau die Abgrenzung zur VM, bei der wie gesagt die
Hardware emuliert wird auf der dann ein Kernel gestartet wird.

**Resourcen:** Eine `VM (wiki)`_ emuliert die Hardware und der *Emulator* weist
dem Gast-System die System-Ressourcen des Hostsystems zu. Bei den Container
weist der HOST-Kernel dem Container die System-Ressourcen zu. Technische Basis
für die Einteilung der Ressourcen sind die Linux-Kontroll-Groups (aka cgroups_)
und die `Kernel-Namespaces`_. D.h. im Gegensatz zu VMs, bei denen der Emulator
die Ressourcen zuweist, basiert bei Containern die Zuweisung der
System-Ressourcen auf einem Rechtemanagement im Linux-Kernel.

.. note::

   Andere Betriebsysteme als Linux, wie z.B. MacOS oder MS-Windows verfügen in
   ihrem Kernel nicht über die erforderlichen Technologien wie cgroups_ oder
   `Kernel-Namespaces`_, weshalb Container Implementierungen wie Docker_ auf
   diesen Betriebsystemen noch einen Hypervisor_ benötigen in dem letzlich ein
   Linux gestartet wird. Nachteil: es muss erst ein Linux auf diesen Plattformen
   emuliert werden, was i.d.R. zusätzliche Resourcen in Anspruch nimmt.

**Isolierung:** Der Container ist maximal gegen das Hostsystem abgesichert. So
wird beispielsweise seitens des HOST-Kernels ein Container mit einer Benutzer- &
Gruppen- ID (UID & GID) betrieben (ab Linux Kernel 3.12), die auf dem Hostsystem
des HOST-Kernel keine Rechte hat.  Selbst wenn es einem Benutzer im Container
gelingt ``root`` Rechte zu erlangen, so beschränken sich diese nur auf den
Container. Selbst in einem solchen *worst-case* Szenario kann dieser ``root``
aus dem Container keine Manipulation am Hostsystem vornehmen.

Ziel der Linux Container ist es, eine Umgebung bereit zu stellen, die *so weit
wie möglich* einer Standard Linux Installation gleicht, ohne dass dafür ein
seperater Kernel eingerichtet werden muss. Da sie aufgrund ihrer Architektur
sozusagen *bare-metal* laufen -- keine Emulation der Hardware -- sind Container
immer schneller und Ressourcen schonender als jeder Hypervisor einer VM es sein
kann. Man darf aber auch nicht außer Acht lassen, dass die fehlende Hardware
Emulation die Use-Cases für Container wiederum auch einschränkt.

  Zusammengefasst kann man sagen, dass Container gut als auch resourcen-günstig
  *skallieren* aber hald' eben keine echten VMs sind ;) In Verbindung mit der
  :ref:`snap Paketverwaltung <snap>` hat man einen *Werkzeugkasten* zusammen,
  mit dem Aspekte wie *Software-Test* und *Software-Deployment* -- zumindest für
  große Teile der Linux-Derivate/-Distributionen -- einfacher und schneller
  bedient werden können als man das bisher konnte.

Die Idee solcher Container ist an sich nichts Neues.  Es gab bereits 2000 die
FreeBSD-Jails_, diese hatten immer einige Sicherheitslücken und um sie unter
Linux zu nutzen musste der Linux-Kernel gepatched werden.  LXD_ baut auf dem
`Vanilla Kernel <https://wiki.debian.org/vanilla>`_ auf.  Mit den cgroups_ des
Vanilla Kernel und den `Kernel-Namespaces`_ kann LXC den Container robust vom
Hostsystem isolieren.

Wie jede VM braucht auch ein Container ein initiales Image zum starten (der
Begriff *booten* trifft hierbei nur bedingt zu). Die Images als auch die
Container werden vom LXD verwaltet und über einen WEB-Service bereit gestellt
(:ref:`lxc_remote_images`).

Mehr zu LXD siehe auch: `Introduction to LXD projects`_ und `snapcraft LXD`_.
