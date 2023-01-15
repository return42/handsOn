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
problemlos gestatten.  Und nicht zu vergessen: Einige der Transcoder
Bibliotheken haben zudem noch Bugs und erhebliche Sicherheitslücken.

Die gängigen *Transcoder-Projekte* sind `libav`_, `FFmpeg`_ und `GStreamer`_.

.. hint::

   In den Paketquellen von Ubuntu und Debian wurde das Projekt `libav`_ wieder
   durch `FFmpeg`_ ersetzt.


FFmpeg
======

FFmpeg stellt *cross-platform* Tools und Bibliotheken zur Verfügung, mit denen
eine breite Palette an Multimedia-Formaten und Protokollen transcodiert und
bearbeitet werden kann.

Die Implementierungen des `FFmpeg`_ können über die standard Paketquellen von
Ubuntu und Debian nicht installiert werden. (:deb:`ffmpeg`)


libavcodec und libav
====================

.. _libavcodec: https://ffmpeg.org/libavcodec.html

Das `libav`_ Projekt war mal eine Abspaltung des `FFmpeg`_ Projekts,
mit dem Ziel die Code-Qualität zu verbessern., das Projekt wurde
allerdings 2018 eingestelt.

Libav sollte nicht mit libavcodec_ verwechselt werden: libavcodec_ ist
eine Codec-Sammlung und Teil des freien FFmpeg-Projektes.

Bei Ubuntu und Debian installiert man am besten die Pakete
:deb:`ffmpeg` und :deb:`libavcodec-extra`.


GStreamer Plugins
=================

`GStreamer`_ ist ein `freedesktop.org`_ Projekt. Es bassiert auf `GObject`_
und ist von daher in vielen GNOME (resp. GTK) Anwendungen der Standard.

- :deb:`gstreamer1.0-plugins-base`
- :deb:`gstreamer1.0-plugins-good`
- :deb:`gstreamer1.0-plugins-bad`
- :deb:`gstreamer1.0-plugins-ugly`


ubuntu-restricted-extras
========================

Häufig findet man in Artikel aus dem Netzt den Hinweis, man möge sich
:deb:`ubuntu-restricted-extras` installieren.  Das Paket
:deb:`ubuntu-restricted-extras` ist ein `Metapaket`_ das alle möglichen
Transkoder-Bibliotheken installiert.  Früher konnte man sich die
:deb:`ubuntu-restricted-extras` nicht wirklich installieren.  Damals war da
(Shockwave) Flash und andere Software mit Sicherheitslücken in dem Paket.

Die Fonts *provided by Microsoft*, die da von Sourceforge runter
geladen werden stören mich auch nach wie vor an dem Paket.  Dennoch,
wenn man die *Standard* Codecs und Tools haben will, kann das Paket
hilfreich sein. Man muss hald' auch nur die EULA oder was auch immer
akzeptieren::

  sudo -H apt install ubuntu-restricted-extras


Zusammenfassung
===============

Am besten man installiert sich nur:

- :deb:`ffmpeg`
- :deb:`gstreamer1.0-plugins-base`.

Braucht man noch zusätzliche Codecs kann man folgendes installieren:

- :deb:`libavcodec-extra`
- :deb:`gstreamer1.0-plugins-good`
- :deb:`gstreamer1.0-plugins-bad`
- :deb:`ubuntu-restricted-extras`


Installation
============

.. code-block:: bash

   $ sudo -H ./scripts/ubuntu_install_pkgs.sh codecs
