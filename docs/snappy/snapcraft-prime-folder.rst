.. -*- coding: utf-8; mode: rst -*-

.. include:: ../snappy_refs.txt

.. _snapcraft-prime-folder:

==========================
snapcraft ``prime`` Ordner
==========================

Das ``snapcraft`` führt den *build* des snaps in Stufen aus, die nacheinander
durchlaufen werden:

``pull``
  Download der Quellpakete aller ``parts``

``build``
  Build aller ``parts``

``stage``
  Konsolidierung der installierten Dateien aller ``parts``

``prime``
  Reduzieren auf die benötigten Dateien im Ordner ``prime/``

``snap``
  Erzeugen eines snap aus dem ``prime/`` Ordner

Nachdem das snap erzeugt ist kann man es wieder installieren::

    ~/hello$ snapcraft
    [...]
    Snapped hello_2.10_amd64.snap

    ~/hello$ sudo snap install --devmode hello_2.10_amd64.snap

    hello 2.10 installed

Man kann aber auch den ``/prime`` Ordner mit ``snap`` installieren, was sich
besonders für Entwickler-Szenarien eigent. Der Build kürzt sich damit zu
``snappcraft prime`` ab und mit einem ``snap try`` wird das Paket installiert:

.. code-block:: bash

  ~/hello$ snapcraft prime
  Skipping pull gnu-hello (already ran)a
  Skipping build gnu-hello (already ran)
  Skipping stage gnu-hello (already ran)

  ~/hello$ sudo snap try --devmode prime/
  hello 2.10 mounted from ~/hello/prime

An der letzten Ausgabe ist zu erkennen, dass das snap-Paket ``hello`` aus dem
Ordner ``./hello/prime`` (im HOME des aktuellen Benutzers) installiert wurde.
Dies ist in Entwickler-Szenarien ganz hilfreich: Zum Testen braucht man bei
einer Änderung der snap-Konfiguration (``snap/snapcraft.yaml``) des snap-Pakets
immer nur noch den ``./prime/`` Ordner bauen und installieren:

.. code-block:: bash

    ~/hello$ snapcraft prime
    [...]
    ~/hello$ sudo snap try --devmode prime/

