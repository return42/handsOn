.. -*- coding: utf-8; mode: rst -*-

.. include:: ../ubuntu_install_pkgs_refs.txt
.. include:: ../desktop_system_refs.txt

.. _xref_ubuntu_codecs:

================================================================================
                                Codec Pakete
================================================================================

In dieser Rubrik werden keine Anwendungen im eigentlichen Sinne vorgestellt, es
geht vielmehr um Pakete die Tools zur Kodierung / Dekodierung von Datenströmen
und Dateien beinhalten wie sie z.B. von Multimedia Anwendungen benötigt werden.

Man sollte sich nicht einfach alle möglichen Transcoder installieren.  Einige
dieser Transcoder Bibliotheken sind mit Patentrechten belastet oder haben andere
lizenzrechtliche Einschränkungen, die einen freien Einsatz nicht immer
problemlos gestatten. Einige der Transcoder Bibliotheken haben zudem noch Bugs
und erhebliche Sicherheitslücken.

Die gängigen *Transcoder-Projekte* sind `libav`_, `FFmpeg`_ und `GStreamer`_.
In den Paketquellen von Ubuntu und Debian wurde das Proekt `FFmpeg`_ durch
`libav`_ ersetzt. Jedoch herrscht ein wenig Verwirrung zu den Paketen bei Ubuntu
und Debian. Die Pakete :deb:`ffmpeg` und :deb:`libav-tools` installieren beide
die `libav`_ Implementierung (s.u.).

libav
=====

Libav stellt *cross-platform* Tools und Bibliotheken zur Verfügung, mit denen
eine breite Palette an Multimedia-Formaten und Protokollen transcodiert und
bearbeitet werden kann. Das `libav`_ Projekt ist eine Abspaltung des `FFmpeg`_
Projekts, mit dem Ziel die Code-Qualität zu verbessern (s.a. `FFmpeg versus
Libav <https://github.com/mpv-player/mpv/wiki/FFmpeg-versus-Libav>`_).

Die Paketverwaltung unter Debian / Ubuntu ist etwas *krude*:

* :deb:`ffmpeg` und :deb:`libav-tools`:

Das Paket :deb:`ffmpeg` installiert die Implementierungen aus dem `libav`_
Projekt (*Raider heißt jetzt Twix*) und das *transitional* Paket
:deb:`libav-tools` installiert die beiden Pakete :deb:`ffmpeg` und
:deb:`libav-tools-links`.

Bei :deb:`ffmpeg` gibt es nur das Kommando :man:`ffmpeg`, in dem `libav`_
Projekt ist die Kommandozeile etwas anders und es gibt die Kommandos
:man:`avconv`, :man:`avprobe`, :man:`avserver` und :man:`avplay`.

Weil *Raider nun Twix heißt* braucht man dann wieder einen Wrapper der die
``av*`` Kommandos zur Verfügung stellt, diese bekommt man mit dem Paket
:deb:`libav-tools-links`, das in dem *transitional* Paket :deb:`libav-tools`
installiert wird (so hab ich es zumindest verstanden, das ist echt alles
seh verwirrend, siehe meine Zusammenfassung unten).

* :deb:`libavcodec-extra`:

Meta Paket, das eine Reihe von Transcoderbibliotheken für Audio und Video
installiert. Siehe auch :deb:`libavcodec-ffmpeg-extra56`.


FFmpeg
======

Die Implementierungen des `FFmpeg`_ können über die standard Paketquellen von
Ubuntu und Debian nicht mehr installiert werden. Jedoch gibt es das
:man:`ffmpeg` Kommando, wenn man :deb:`libav-tools` installiert (s.o.). Auch die
ganzen Pakete mit den zusätzlichen Transcodern tragen nach wie vor ein
``*ffmpeg*`` im Namen.


GStreamer Plugins
=================

`GStreamer`_ ist ein `freedesktop.org`_ Projekt. Es bassiert auf `GObject`_
und ist von daher in vielen GNOME (resp. GTK) Anwendungen der Standard.

* :deb:`gstreamer1.0-plugins-base`
* :deb:`gstreamer1.0-plugins-good`
* :deb:`gstreamer1.0-plugins-bad`
* :deb:`gstreamer1.0-plugins-ugly`

ubuntu-restricted-extras
========================

Häufig findet man in Artikel aus dem Netzt den Hinweis, man möge sich
:deb:`ubuntu-restricted-extras` installieren.  Das Paket
:deb:`ubuntu-restricted-extras` ist ein `Metapaket`_ das alle möglichen
Transkoder-Bibliotheken installiert. Unter anderem solche die Sicherheitslücken
aufweisen und/oder lizenzrechtlich nur eingeschränkt genutzt werden können. Auch
das Adobe Flash Plugin für den WEB-Browser zählt zu diesen Paketen.

Die Installation des :deb:`ubuntu-restricted-extras` Pakets kann man eigentlich
nicht empfehlen. Wenn man sich das aber unbedingt doch installieren will, sollte
man wenigstens das Adobe Flash-Plugin wieder entfernen.

.. code-block:: bash

   sudo apt-get purge flashplugin-installer


Zusammenfassung
===============

Dieses ganze Durcheinander bei Ubuntu/Debian rund um FFmpeg und libav, ich blick
da nicht mehr wirklich durch. Es kann gut sein, dass ich das ein oder andere
falsch interpretiere und es kann auch gut sein, dass sich das wieder alles mit
dem nächsten Ubuntu Release ändert. Am besten man installiert sich nur:

* :deb:`libav-tools` und
* :deb:`gstreamer1.0-plugins-base`.

Braucht man noch zusätzliche Codecs kann man folgendes installieren:

* :deb:`libavcodec-extra`
* :deb:`gstreamer1.0-plugins-good`
* :deb:`gstreamer1.0-plugins-bad`


Installation
============

.. code-block:: bash

   $ sudo ${SCRIPT_FOLDER}/ubuntu_install_pkgs.sh codecs
