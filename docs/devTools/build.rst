.. -*- coding: utf-8; mode: rst -*-

.. include:: ../devTools_refs.txt

.. _xref_ubuntu_devTools_build:

================================================================================
                              Software Build (GNU)
================================================================================

Es gibt eine Vielzahl von Buildtools die *hier* nicht installiert werden und auf
die nicht eingegangen werden soll.  In Linux/Unix Software-Projekten wird jedoch
häufig die Tool-Chain des `GNU Build System (wiki)`_ genutzt, weshalb diese
*hier* installiert wird und mit ein paar Sätzen unten stehend kurz erläutert
werden soll.

In den angesprochenen Linux/Unix Software-Projekten sind für den Build-Prozess
neben der Toolchain noch (Standard-) Bibliotheken (z.B. `glibc`_) und deren
`Header Dateien (wiki)`_ erforderlich.  In den Software-Projekten können diese
Abhängigkeiten ganz individuell sein.  Es lässt sich aber auch ein **Subset von
Abhängigkeiten** identifizieren, der häufig benötigt wird.  Neben diesen Subset
an Abhängigkeiten sind die hier vorgestellten Entwickler Pakete eine
willkürliche Auswahl.

* :deb:`build-essential`
* :deb:`linux-headers-generic`

Das :deb:`build-essential` Paket installiert einen minimalen Satz von Tools und
Bibliotheken, der benötigt wird um Software zu kompilieren (s.o.).  Zu diesem
minimalen Satz gehören beispielsweise die

* GNU Compiler Collection (`GCC`_) und die
* GNU C Library (`glibc`_), die Implemntierung der `C standard library (wiki)`_
  von GNU.

In dem :deb:`linux-headers-generic` Paket sind die Linux `Header Dateien
(wiki)`_, auch diese werden des öfteren benötigt und sollten installiert werden.
Viele Linux/Unix Software-Projekte bauen auf dem `GNU Build System (wiki)`_ auf,
das unter Debian/Ubuntu mit den folgenden Paketen installiert werden kann.

* :deb:`autoconf` / :deb:`autotools-dev`

Installiert (u.a.) die Tools :man:`autoscan`, :man:`autoconf` und
:man:`autoheader`.  Diese Tools gehören zur `GNU autoconf`_ Suite mit der
Konfiguratinen erzeugt werden, die es Entwicklern erlauben ihre
Implementierungen *portabel* zu halten, so dass diese auf unterschiedlichen
(z.B. Unix/Linux) Platformen kompiliert werden können.

* :deb:`automake`

`GNU automake`_ ergänzt das Autotool Suite und ermöglicht es, die für den
Build-Prozess zuständigen ``Makefile`` Dateien ebenfalls *portabel* zu halten.
Das Zusammenspiel von Automake und Autoconf wird in dem Prozessbild von
Wikimedia Commons anschaulich dargestellt.

.. _xref-figure-build-256px-Autoconf-automake-process.svg:

.. figure:: build/256px-Autoconf-automake-process.svg.png
   :alt:     Figure (256px-Autoconf-automake-process.svg.png)
   :align:   center
   :target:  https://de.wikipedia.org/wiki/GNU_Build_System#/media/File:Autoconf-automake-process.svg

   Autoconf / Automake Prozessbild (Wikimedia Commons)

Eine kurze, pragmatisches Einführung zu den Autotools gibt das `Autotools
Tutorial for Beginners (markuskimius)`_ oder das Kapitel "Build-Systeme Teil 5:
GNU Autotools" im `magazin.c-plusplus.net`_.

* :deb:`libtool-bin`

Das Paket :deb:`libtool-bin` installiert (u.a.) das Kommando :man:`libtools` das
zu dem GNU Portable Library Tool (kurz: `GNU libtool`_) gehört.  Libtool
unterstützt bei der Erzeugung einer *portablen* (nicht auf eine Platform
begrenzten) `Shared Library (wiki)`_.

* :deb:`gettext`

Das Paket :deb:`gettext` installiert die `GNU gettext`_ Toolchain.  Das
Zusammenspiel der gettext-Tools wird in dem Prozessbild von Wikimedia Commons
anschaulich dargestellt.

.. _xref-figure-build-206px-Gettext.svg:

.. figure:: build/206px-Gettext.svg.png
   :alt:     Figure (206px-Gettext.svg.png)
   :align:   center
   :target:  https://de.wikipedia.org/wiki/GNU_gettext#/media/File:Gettext.svg

   `GNU gettext (wiki)`_ Prozessbild (Wikimedia Commons)

