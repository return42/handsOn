.. -*- coding: utf-8; mode: rst -*-

.. include:: ../lxdlxc_refs.txt

.. _working_with_containers:

=======================
Arbeiten mit Containern
=======================

Mit LXD lassen sich die Images und Container sehr gut managen und Images die
einmal von einem Remote kopiert wurden stehen lokal zur Verfügung solange man
sie nicht explizit löscht. Durch die Bereitstellung öffentlicher Image-Server
lassen sich Systeme mit minimalem Aufwand in die Container installieren und in
Betrieb nehmen. Z.B. das Starten eines Containers aus einem Image das von einem
Remote Image-Server stammt, benötigt nur eine Zeile::

  $ lxc launch images:ubuntu/artful ubu1704

Will man lediglich den Container einrichten und nicht gleich starten, so
reicht::

  $ lxc init images:ubuntu/artful

Zum Vergleich; will man nur (schon mal) das Image in den lokalen Image-Server
kopieren (clonen) ohne einen Container einzurichten, so würde man dies wie folgt
machen (:ref:`lxc_import_image`)::

  $ lxc image copy images:ubuntu/artful local: --alias ubu1710

Zum Starten, Stoppen und Pausieren der Container existieren folgende Kommandos:

-  ``lxc start   [<remote>:]<container> [[<remote>:]<container>...]``
-  ``lxc stop    [<remote>:]<container> [[<remote>:]<container>...]``
-  ``lxc restart [<remote>:]<container> [[<remote>:]<container>...]``
-  ``lxc pause   [<remote>:]<container> [[<remote>:]<container>...]``

Sollte der Container mal auf ein ``stop`` nicht reagieren, kann mit der Option
``--force`` ein Stop des Containers erzwungen werden. Die anderen Kommandos
haben auch Optionen (``lxc <command> --help``).
  

ToDo
====

Dieser Artikel befindet sich noch im Aufbau. Folgende Themen sollten noch
behandelt werden:

- LXC Configuration profiles
  (https://github.com/lxc/lxd/blob/master/doc/configuration.md) 

- Executing commands
- Managing files: Because LXD has direct access to the container’s file system,
  it can directly read and write any file inside the container. This can be very
  useful to pull log files or exchange files with the container.
- Editing a file directory

Hier: https://insights.ubuntu.com/2016/03/22/lxd-2-0-your-first-lxd-container/
steht auch noch was dazu
