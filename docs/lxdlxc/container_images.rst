.. -*- coding: utf-8; mode: rst -*-

.. include:: ../lxdlxc_refs.txt

.. _container_images:

==================
Container & Images
==================

Dieser Abschnitt beschäftigt sich mit dem Management der Images und der
Container. Mehr zum Thema siehe auch: `LXD 2.0: Image management
<https://insights.ubuntu.com/2016/04/01/lxd-2-0-image-management-512>`_

Auflisten der Container
=======================

::

  $ lxc list

+------+-------+------+------+------+-----------+
| NAME | STATE | IPV4 | IPV6 | TYPE | SNAPSHOTS |
+------+-------+------+------+------+-----------+
| ...  | ...   | ...  | ...  | ...  | ...       |
+------+-------+------+------+------+-----------+

Auflisten der Images
====================

::

  $ lxc image list

+-------+-------------+--------+-------------+------+------+-------------+
| ALIAS | FINGERPRINT | PUBLIC | DESCRIPTION | ARCH | SIZE | UPLOAD DATE |
+-------+-------------+--------+-------------+------+------+-------------+
| ...   | ...         | ...    | ...         | ...  | ...  | ...         |
+-------+-------------+--------+-------------+------+------+-------------+

Auflisten Remote Images
=======================

z.B. von https://images.linuxcontainers.org (s.o)::

  $ lxc image list images:

Den Doppelpunkt am Ende des Remote-Alias ``images:`` darf man nicht vergessen,
er zeigt an, dass man sich auf den Remote bezieht. Als Ausgabe erhält man eine
Tabelle wie die folgende:

+-------------+--------------+-------+-------------+--------+--------+-------------+
| ALIAS       | FINGERPRINT  | PUBLIC| DESCRIPTION | ARCH   | SIZE   | UPLOAD DATE |
+-------------+--------------+-------+-------------+--------+--------+-------------+
| ...         | ...          | ...   | ...         | ...    | ...    | ...         |
+-------------+--------------+-------+-------------+--------+--------+-------------+
| alpine/edge | ed1bb9487366 | yes   | Alpine edge | x86_64 | 1.72MB | Sep 6, 2017 |
+-------------+--------------+-------+-------------+--------+--------+-------------+
| ...         | ...          | ...   | ...         | ...    | ...    | ...         |
+-------------+--------------+-------+-------------+--------+--------+-------------+

Im Folgendem ein paar Beispiele bei denen das ``alpine/edge`` Image mit dem
Fingerprint ``ed1bb9487366`` verwendet wird. Ich habe das Image nur deswegen
ausgewählt, weil es sich mit seiner Größe von nur ca. 2MB schnell kopieren
lässt. Getestet hab ich das System in dem Image jedoch nicht und das Beispiel
hier soll auch keine Empfehlung für dieses Image sein.

Infos zu einem Image
====================

::

  $ lxc image info images:alpine/edge

::

  Fingerprint: ed1bb94873666a03e9af29d76274134ad9566fab8d90dfe7f9d9e8bc2de12313
  Size: 1.72MB
  Architecture: x86_64
  Public: yes
  Timestamps:
      Created: 2017/09/06 00:00 UTC
  ...

Starten eines Containers aus einem Image
========================================

::

  $ lxc launch images:alpine/edge alpine-test
  Creating alpine-test
  Starting alpine-test

und jetzt müsste der Container ``alpine-test`` in der Liste erscheinen::

  $ lxc list

+-------------+---------+---------------------+------+------------+-----------+
|    NAME     |  STATE  |        IPV4         | IPV6 |    TYPE    | SNAPSHOTS |
+-------------+---------+---------------------+------+------------+-----------+
| alpine-test | RUNNING | 10.20.203.71 (eth0) |      | PERSISTENT | 0         |
+-------------+---------+---------------------+------+------------+-----------+

Stoppen eines Containers
========================

::

  $ lxc stop alpine-test

Löschen eines Containers
========================

::

  $ lxc delete alpine-test

Anzeigen der lokalen Images
===========================

Beim Starten des Containers mit ``lxc launch images:alpine/edge`` wurde das
Image mit dem Fingerprint ``ed1bb9487366`` vom Remote ``images:`` geclonet und
in das lokale LXD kopiert.

::

  $ lxc image list

+-------+--------------+--------+-----------------+--------+--------+-----------------------------+
| ALIAS | FINGERPRINT  | PUBLIC | DESCRIPTION     |  ARCH  |  SIZE  |         UPLOAD DATE         |
+-------+--------------+--------+-----------------+--------+--------+-----------------------------+
|       | ed1bb9487366 | no     | Alpine edge ... | x86_64 | 1.72MB | Sep 7, 2017 at 4:03pm (UTC) |
+-------+--------------+--------+-----------------+--------+--------+-----------------------------+

Alias Namen für Images
======================

Ein Image kann über seinen *Fingerprint* adressiert werden, alternativ können
aber auch noch Alias-Namen vergeben werden (Image-Alias)::

  $ lxc image alias create alpine-edge ed1bb9487366

Es können mehrere Alias-Namen vergeben werden. Über welche Alias-Namen ein
``FINGERPRINT`` verfügt kann man sich z.B. mit ``image info`` anzeigen lassen.
Im folgendem Beispiel wird eines der :ref:`Remote Images <lxc_remote_images>`
vom ``ubuntu`` Image-Server mit den `Ubuntu Cloud Images
<https://cloud-images.ubuntu.com/releases>`__ abgefragt::

  $ lxc image info images:ubuntu/artful

::

  Fingerprint: 3fa086e1908dec89f46b9ff34283032419abc3c42c9791be81efa4aa01a29768
  Size: 92.70MB
  Architecture: x86_64
  Public: yes
  Timestamps:
    Created: 2017/09/08 00:00 UTC
    Uploaded: 2017/09/08 00:00 UTC
    Expires: never
    Last used: never
  Properties:
    serial: 20170908_03:49
    description: Ubuntu artful amd64 (20170908_03:49)
    os: Ubuntu
    release: artful
    architecture: amd64
  Aliases:
    - ubuntu/artful/default
    - ubuntu/artful/default/amd64
    - ubuntu/artful
    - ubuntu/artful/amd64
  Auto update: disabled

Es ist auch möglich die Alias-Namen der Images des lokalen Image-Severs
anzuzeigen::

  $ lxc image alias list
  +---------+--------------+-------------+
  |  ALIAS  | FINGERPRINT  | DESCRIPTION |
  +---------+--------------+-------------+
  | ubu1710 | 3fa086e1908d | ubu1710     |
  +---------+--------------+-------------+

Letzteres listet die Alias-Namen des lokalen Image-Servers, für einen Remote ist
die Abfrage analog mit *Name + Doppelpunkt* am Ende::

  $ lxc image alias list ubuntu:


Löschen eines Images
====================

Das zu löschende Image kann über seinen Namen (Image-Alias) oder explizit über
seinen Fingerprint adressiert werden::

  $ lxc image delete ed1bb9487366

.. _lxc_import_image:

Import Image von Remote
=======================

Importieren (pull) eines Image von einem anderem Image-Server::

  $ lxc image copy images:ubuntu/artful local: --alias ubu1710

Anschließend müsste das Image ``ubu1710`` in der Liste der lokalen Images
auftauchen::

  $ lxc image alias list

+---------+--------------+-------------+
|  ALIAS  | FINGERPRINT  | DESCRIPTION |
+---------+--------------+-------------+
| ubu1710 | 3fa086e1908d | ubu1710     |
+---------+--------------+-------------+
