.. -*- coding: utf-8; mode: rst -*-

.. include:: ../devTools_refs.txt

.. _xref_ubuntu_devTools_edit:

================================================================================
                            Edit, Diff, Merge & Co.
================================================================================

Für das Arbeiten mit Sourcen (und dem handsOn Konfigurationen / siehe
:ref:`xref_handson_concept`) ist ein minimaler Satz an Werkzeugen
erforderlich.  Dazu gehören mindestens ein Editor, ein Tool zum *Durchsuchen*
von Ordnern und Dateien (nach Mustern) sowie ein diff- und ein patch-Tool.

* :deb:`emacs`

Man muss nicht den Emacs nehmen, es gibt *gefühlt* hundert andere Editoren, aber
der `GNU Emacs`_ passt einfach super in das Linux / GNU Ökosystem und kann
ansonsten auch nur empfohlen werden.

* :deb:`colordiff`
* :deb:`diff`

Für das Anzeigen von Unterschieden in Dateien und Ordnerstrukturen eigent sich
:man:`diff` oder das *farbige* :man:`colordiff`.

* :deb:`patch`

Die mit :man:`diff` erzeugten Differenzen können mit :man:`patch` wieder
eingespielt werden, siehe auch `Patch (wiki)`_.

* :deb:`grep`

Mit den `GNU grep`_ können `reguläre Ausdrücke (wiki)`_ in einzelnen Dateien
(:man:`grep`) oder in ganzen Ordnerstukturen (:man:`rgrep`) gesucht werden.

* :deb:`findutils`

In dem :deb:`findutils` sind die Tools :man:`find` und :man:`xargs` enthalten,
mit denen Dateien oder Ordner gesucht werden können (find) und auf die dann
Kommandos angewendet werden können (xargs).
