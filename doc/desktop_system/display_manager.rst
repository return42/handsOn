.. -*- coding: utf-8; mode: rst -*-

.. include:: ../desktop_system_refs.txt

.. _xref_display_manager:

================================================================================
                                Display-Manager
================================================================================

Der `X Display Manager (wiki)`_ ist für den grafischen Anmeldebildschirm
(*greeter*) erforderlich. Die meisten Display-Manager vereinen den *greeter* und
das X-Display, bei anderen wie z.B. `LightDM (ubuntu)`_ wird ein separater
*greeter* benötigt.

Das `XDMC-Protocol (wiki)`_ zur remote-Anmeldung hat heute keine Bedeutung
mehr. Da das XDMCP weder verschlüsselt noch komprimiert, sollte für die
X-Kommunikation besser ein SSL Tunnel (``ssh -X``) verwendet werden.

Es gibt diverse Display Manager -- siehe `Display Manager (ubuntu)`_ -- von
denen aber nur die folgenden aktuell eine *Bedeutung* haben.

LightDM
=======

Mit dem Paket :deb:`LightDM` wird der `LightDM (freedesktop)`_ Display-Manager
installiert, der benötigt noch einen *greeter*, hierfür empfiehlt sich das
Paket :deb:`lightdm-webkit-greeter`.

Sofern der leichte *Medienbruch* zw. Anmeldung und Desktop-Umgebung nicht stört,
kann der `LightDM (ubuntu)`_ Desktop Manager auch als *schlanke* Lösung für
GNOME Shell und :ref:`xref_cinnamon` empfohlen werden.

Mit dem :deb:`lightdm-webkit-greeter` wird das Standard-Theme von Ubuntu
installiert, alternativ kann man sich auch einen eigenen *Theme* erstellen oder
einen der bei github suchen: `LigthDM WebKit Themes bei github
<https://github.com/search?utf8=%E2%9C%93&q=lightdm+webkit+theme&type=Repositories&ref=searchresults>`_.

.. todo::

    In 15.10 funktioniert das lightdm-webkit-greeter Paket nicht so wirklich. Man
    muss es mit *irgendwelchen* anderen Paketen installieren. Welche Pakete das
    sind weiß ich nicht. Ich merke nur, dass es mal funktioniert und mal auch
    nicht.

Nachdem man Ubuntu komplett installiert hat, funktioniert auch der
WebKit-Greeter, räumt man aber etwas auf und löscht die Pakete mit dem
Ubuntu-Schlonz, dann funktioniert der Greeter nicht mehr.

In den LOGs (/var/log/lightdm/) sehe ich, dass da noch was ziemlich buggy zu
sein scheint. Z.B. wird ein LOG-Ordner unter ``/var/log/lightdm/<user-name>``
angelegt. Der *Greeter* selber versucht dann aber unter ``/var/lib/lightdm/``
seine Daten abzulegen, was am Ende scheitert. Mit dem Versuch::

    mkdir -p /var/lib/lightdm
    chown lightdm:lightdm /var/lib/lightdm

Bin ich zwar etwas weiter gekommen, es kommt zu keinem Abbruch mit Fehler mehr,
aber ich sitze immernoch vor einem dunklen Bildschirm. Ich gebe das an dieser
Stelle auf. Mir scheint das Paket einfach nur Buggy zu sein, siehe
:launchpad:`lightdm-webkit-greeter`. In Ubuntu 15.04 wird Version 0.1.2 genutzt,
die ist von 2012. Inzwischen gibt es *volle* Versionsnummern, z.B 1.0.0 vom
Oktober 2015 und 2.0.0 vom Jan. 2016. Davon hat es aber bisher keine Version in
eine Ubuntu-Distro geschafft. Selbst in 16.04 (xenial) ist momentan (03/2016)
noch Version 0.1.2 aus 2012 drin.

* https://launchpad.net/ubuntu/xenial/+source/lightdm-webkit-greeter

Ein Upgrade erscheint ohnehin angebracht, da erst die neuen Versionen GTK 3
verwenden, damit funktioniert vieles nicht, auch die Themes von GitHub sind
meist nur gegen die aktuelleren Versionen getestet.

SDDM
====

Mit dem Paket :deb:`sddm` wird der *Simple Desktop Display Manager*
installiert. `SDDM (github)`_ ist der `KDM (wiki)`_ Nachfolger. Wer eine
`KDE`_ Desktop Umgebung nutzt (z.B. Kubuntu), der sollte `SDDM (wiki)`_ als
Display-Manager verwenden.

GDM
===

Mit dem Paket :deb:`gdm` wird der *GNOME Display Manager* (`GDM`_) installiert.
`GDM (ubuntu)`_ empfiehlt sich, wenn man die GNOME Shell oder
:ref:`xref_cinnamon` verwendet.

chooseDM
========

In dem ``${SCRIPT_FOLDER}`` Ordner befindet sich ein Skript, mit dem ein
Display-Manager ausgewählt werden kann.

.. code-block:: bash

   $ sudo ${SCRIPT_FOLDER}/desktop_system.sh chooseDM
