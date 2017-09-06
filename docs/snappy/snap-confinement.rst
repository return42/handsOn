.. -*- coding: utf-8; mode: rst -*-

.. include:: ../snappy_refs.txt

.. _snap-confinement:

========================
Vertrauenswürdige Pakete
========================

In einigen der hier gegebenen Beispiele wurde ein lokales Paket in etwa so
installiert:

.. code-block:: shell

  ~/hello$ sudo snap try --devmode prime/

Der Schalter ``--devmode`` war bisher erforderlich, da bisher immer
``confinement: devmode`` als Policy in der ``snapcraft.yaml`` stand:

.. code-block:: yaml

   confinement: devmode

Mit ``devmode`` als Policy werden diverse Fehler in Warnings gewandelt
(``/var/log/syslog``). In einer *normalen* Distribution des snap-Pakets wird man
hier i.d.R ``confinement: strict`` angeben (s.a. `snap
Confinement`_). Zum Beispiel:

.. code-block:: yaml

    name: hello
    version: '2.10'
    [..]
    grade: devel
    confinement: strict

Mit ``strict`` als Policy und einem anschließendem neuen Build (``snapcraft``)
des snap-Pakets kann der ``prime/`` Ordner nach wie vor im ``try`` Modus
installiert werden:

.. code-block:: shell

   $ sudo snap try prime/

Will man jedoch das lokale snap-Paket *richtig* installieren erhält man eine
Fehlermeldung, dass die Signatur des Pakets nicht verifiziert werden
kann. Anders als bei der Installation aus dem Snap-Store (`uApp Explorer`_) gilt
ein lokales snap-Paket nicht gleichzeitig als *Vertrauenswürdig*:

.. code-block:: shell

   $ sudo snap install hello_2.10_amd64.snap 
   error: cannot find signatures with metadata for snap "hello_2.10_amd64.snap"

Um lokale (nicht signierte) Pakete zu installieren muss die Option
``--dangerous`` angegeben werden:

.. code-block:: shell

   $ sudo snap install hello_2.10_amd64.snap --dangerous
