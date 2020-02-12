.. -*- coding: utf-8; mode: rst -*-

.. include:: ../lxdlxc_refs.txt

.. _install_lxdlxc:

================
LXD Installation
================

LXD_ ist das Managment System für *LXC Container* und alles was es darum herum
so gibt.  Will man mit Container arbeiten, so installiert man sich erst mal
dieses System.  Mit LXD_ hat man dann beispielsweise Zugriff auf die `LXC/LXD
Image Server`_.

Wenn wir von **LXD** reden, dann meinen wir i.d.R. den Manager für die
Container, wenn wir von **LXC** reden, dann meinen wir i.d.R. die Container
selbst.  Die Begriffe lassen sich aber nicht immer so ganz klar trennen.
Historisch ist alles aus den cgroups_ des Linux Kernel entstanden, die erste
Anwendung waren die Container, im Laufe der Zeit entwickelte sich LXD darum
herum und inzwischen sind LXD und LXC eigentlich kaum noch zu trennen.  Die
nächst höhere Abstraktion ist dann die cloud-init_ die uns hier aber nicht
interessiert, der Fokus dieses Artikels liegt auf den *roots*, den Containern.

Früher hat man LXD noch über den Paketmanager der Distributionen installiert,
inzwischen wird das nicht mehr empfohlen und geht zum Teil auch gar nicht mehr.
Inzwischen können aktuelle Versionen des LXD nur über snap_ installiert werden.
*Fun fakt* Snap selbst installiert Container und das LXD wird (nur noch) in
einem solchen Container ausgeliefert.

Das ganze erinnert ein wenig an Matrjoschka Puppen, das Bild stimmt aber nicht
ganz, da die Container (je nach Konfiguration) auch Zugriff auf Komponenten des
HOST Systems haben können. Aber es zeigt, dass wir mit der Installation von LXD
eigentlich schon die ersten Container Anwendungen nutzen und es zeigt, wie weit
man mit solchen Containern gehen kann.  Als erstes starten wir also mit der
Installation des snap_.  Um snap_ zu installieren:

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

Will man sicher später mal das LXD Setup anschauen, so kann man das mit dem
Kommando ``sudo lxd init --dump``, die Ausgabe entspricht dem YAML Format und
könnte in etwa so aussehen.

.. code-block:: yaml

   config: {}
   networks:
   - name: lxdbr0
     config:
       ipv4.address: 10.246.86.1/24
       ipv4.nat: "true"
       ipv6.address: fd42:8c58:2cd:b73f::1/64
       ipv6.nat: "true"
     description: ""
     managed: true
     type: bridge
   storage_pools:
   - name: default
     config:
       size: 15GB
       source: /var/snap/lxd/common/lxd/disks/default.img
       zfs.pool_name: default
     description: ""
     driver: zfs
   profiles:
   - name: default
     config: {}
     description: Default LXD profile
     devices:
       eth0:
         name: eth0
         nictype: bridged
         parent: lxdbr0
         type: nic
       root:
         path: /
         pool: default
         type: disk

In obiger Ausgabe sehen wir unter ``networks``, dass die IP Adresse des Managers
``10.246.86.1/24`` ist und es sich um ein Class C Netzwerk im Adressraum
``10.0.0.0`` handelt.

Unter ``storage_pools`` sehen wir, dass die LXD *Datenbank* im *default* eine
(maximale) Größe von 15GB hat.  Genau genommen ist diese *Datenbank* das Image
eines `Squash Dateisystems <https://de.wikipedia.org/wiki/SquashFS>`_.

Weiter sieht man, dass es ein *default* Profil gibt.  Aus den Profilen werden
(u.A.) die Container gebaut.  Hier sieht man, das ein solcher Container (intern)
mit einem Netzwerkadapter (``eth0``) ausgestattet wird und ``pool: default`` sagt
uns, dass dieser Container in dem Squash Dateisystem aufgebaut werden würde,
dass wir unter ``storage_pools:`` unter dem Namen ``default`` sehen.
