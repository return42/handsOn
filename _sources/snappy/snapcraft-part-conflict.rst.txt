.. include:: ../snappy_refs.txt

.. _snapcraft-part-conflict:

====================
konfligierende Parts
====================

Die `snap Parts`_ sind wiederverwendbare Komponenten, beim Bau kann es zu
Konflikten kommen. Hier im Beispiel wird ``parts.gnu-bash`` hinzugefügt, dessen
*info-dir* mit dem von ``parts.gnu-hello`` in Konflikt steht. Dazu Folgendes in
die ``.yaml`` Datei einfügen:

.. code-block:: yaml

  apps:
    [..]
    bash:
      command: bash

  parts:
    [..]
    gnu-bash:
      source: http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz
      plugin: autotools

Und danach den Build neu starten:

.. code-block:: bash

  ~/hello$ snapcraft prime
  Parts 'gnu-bash' and 'gnu-hello' have the following file
  paths in common which have different contents:
  share/info/dir
  [..]

Die Fehlermeldung meint: ``gnu-hello`` und ``gnu-bash`` legen ihre info-Dateien
im selben Ordner ab, was einen Konflikt darstellt. Diesen kann man lösen, indem
man Beispielsweise den Konfgurationsschalter ``--infodir=`` bei den *autotools*
bzw. beim *configure* des ``gnu-bash`` anwendet:

.. code-block:: yaml

    gnu-bash:
      source: http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz
      plugin: autotools
      configflags: ["--infodir=/var/bash/info"]

Der Build des ``gnu-bash`` ist jetzt nicht mehr aktuell::

  ~/hello$ snapcraft prime
  Skipping pull gnu-hello (already ran)
  Skipping build gnu-hello (already ran)
  Skipping pull gnu-bash (already ran)
  The 'build' step of 'gnu-bash' is out of date:
  The 'configflags' part property appears to have changed.
  In order to continue, please clean that part's 'build' step by \
  running: snapcraft clean gnu-bash -s build

Um nur den Build abzuräumen:

.. code-block:: bash

  ~/hello$ snapcraft clean gnu-bash -s build
  [..]
  ~/hello$ snapcraft prime
  [..]
  Staging gnu-bash 
  Staging gnu-hello 
  Priming gnu-bash 
  Priming gnu-hello 
  ~/hello$ sudo -H snap try --devmode prime/

