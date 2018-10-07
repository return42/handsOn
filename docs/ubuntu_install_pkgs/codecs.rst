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
In den Paketquellen von Ubuntu und Debian wurde das Projekt `libav`_ wieder
durch `FFmpeg`_ ersetzt.


FFmpeg
======

FFmpeg stellt *cross-platform* Tools und Bibliotheken zur Verfügung, mit denen
eine breite Palette an Multimedia-Formaten und Protokollen transcodiert und
bearbeitet werden kann.

Die Implementierungen des `FFmpeg`_ können über die standard Paketquellen von
Ubuntu und Debian nicht installiert werden. (:deb:`ffmpeg`)


libav
=====

Das `libav`_ Projekt ist eine Abspaltung des `FFmpeg`_ Projekts, mit dem Ziel
die Code-Qualität zu verbessern (s.a. `FFmpeg versus Libav
<https://github.com/mpv-player/mpv/wiki/FFmpeg-versus-Libav>`_).

Die Paketverwaltung unter Debian / Ubuntu ist etwas *krude*:

* https://de.wikipedia.org/wiki/FFmpeg#Libav

Kurzum bei Ubuntu und Debian installiert man (Stand 10/2018) am besten das Paket
:deb:`ffmpeg`.


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
(Shockwave) Flash und andere Software mit Sicherheitslücken in dem Paket.  Die
diversen Fonts, die da von Sourceforge runter geladen werden, die stören mich
auch nach wie vor an dem Paket.  Dennoch, wenn man die *Standard* Codecs und
Tools haben will, kann das Paket hilfreich sein. Man muss hald' auch nur die
EULA oder was auch immer akzeptieren::

  sudo apt install ubuntu-restricted-extras


Zusammenfassung
===============

Dieses ganze Durcheinander bei Ubuntu/Debian rund um FFmpeg und libav, ich blick
da nicht mehr wirklich durch.  Es kann gut sein, dass ich das ein oder andere
falsch interpretiere und es kann auch gut sein, dass sich das wieder alles mit
dem nächsten Ubuntu Release ändert.  Am besten man installiert sich nur:

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

   $ sudo ./scripts/ubuntu_install_pkgs.sh codecs
