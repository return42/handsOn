.. -*- coding: utf-8; mode: rst -*-

.. include:: ../lxdlxc_refs.txt

.. _lxc_remote_images:

=============
Remote-Images
=============

LXC basiert auf *Images*. Bevor ein Container gestartet werden kann muss ein
Image gewählt werden, das in dem Container ausgeführt wird. Es gibt drei
Möglichkeiten, *Images* zu beziehen bzw. bereit zu stellen:

- Remote ein *Image* von einem der (build-in) Image-Server beziehen
- Ein alternativer Image-Server kann ein entfernter LXD Server sein.
- Manuelles Importieren eines *Image-Tarball*.

Ohne Images kann man mit LXD nichts anfangen ;) und da man am Anfang i.d.R. erst
mal mit einem Remote-Image beginnt, macht es Sinn sich dem Thema *remote-Images*
als erstes zu widmen.

Auflisten der Remotes::

  $ lxc remote list

+-----------------+------------------------------------------+---------------+--------+--------+
|      NAME       |                   URL                    |   PROTOCOL    | PUBLIC | STATIC |
+-----------------+------------------------------------------+---------------+--------+--------+
| images          | https://images.linuxcontainers.org       | simplestreams | YES    | NO     |
+-----------------+------------------------------------------+---------------+--------+--------+
| local (default) | unix://                                  | lxd           | NO     | YES    |
+-----------------+------------------------------------------+---------------+--------+--------+
| ubuntu          | https://cloud-images.ubuntu.com/releases | simplestreams | YES    | YES    |
+-----------------+------------------------------------------+---------------+--------+--------+
| ubuntu-daily    | https://cloud-images.ubuntu.com/daily    | simplestreams | YES    | YES    |
+-----------------+------------------------------------------+---------------+--------+--------+

Das ``lxc remote list`` spuckt eine Tabelle (wie in etwa oben gezeigt) aus. Da
bereits LXD installiert ist findet man in der Tabelle den Eintrag ``local
(default)``. Zu der lokalen LXD Installation gehört mit diesem *local* auch
immer *Image-Server*. Sofern dieser *freigegeben* ist, kann dieser auch von
anderen Installationen als Image-Server genutzt werden (*vice versa*).  Der
Liste können weitere *Remotes** hinzugefügt werden::

  $ lxc remote add images images.linuxcontainers.org

Letzteres trägt beispielsweise den Server-Alias ``images`` mit der URL
https://images.linuxcontainers.org ein. Für das Löschen aus der Tabelle gibt es
dann ein analoges::

  $ lxc remote remove <NAME>

Mehr zu Remote-Image-Server siehe `LXD 2.0: Remote hosts and container migration
<https://insights.ubuntu.com/2016/04/13/lxd-2-0-remote-hosts-and-container-migration-612/>`_.
