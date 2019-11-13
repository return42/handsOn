.. -*- coding: utf-8; mode: rst -*-

.. include:: ../snappy_refs.txt
  
===============
snapcraft Intro
===============

Installation der snap Infrastruktur (s.a `install snapd`_)::

  sudo -H apt install snapd snapcraft build-essential

Für den Build Prozess der Pakete wird ``snapcraft`` benötigt, die Tools aus dem
apt-Paket ``build-essential`` werden i.d.R. auch gebraucht, wenn man snap-Pakete
bauen will.

Snap erstellen:

.. code-block:: bash

  $ mkdir hello
  $ cd hello
  ~/hello$ snapcraft init
  Created snap/snapcraft.yaml.
  Edit the file to your liking or run `snapcraft` to get started


Laut Doku muss der Snap-Ordner (hier im Beispiel ``hello``) im HOME-Ordner
liegen (warum?).

Beispiel für eine ``snapcraft.yaml``:

.. code-block:: bash

  name: hello
  version: '2.10'
  summary: GNU Hello, the "hello world" snap
  description: |
    GNU hello prints a friendly greeting.
  grade: devel
  confinement: devmode

Snap Buid:

.. code-block:: bash

    $ cd hello
    ~/hello$ snapcraft
    [...]
    Staging gnu-hello
    Priming gnu-hello
    Snapping 'hello' |                                          	 
    Snapped hello_2.10_amd64.snap

    ~/hello$ ls -la
    insgesamt 88
    drwxrwxr-x  6 user user  4096 Sep  6 11:48 .
    drwxr-xr-x 39 user user  4096 Sep  6 11:18 ..
    -rw-r--r--  1 user user 65536 Sep  6 11:48 hello_2.10_amd64.snap
    drwxrwxr-x  3 user user  4096 Sep  6 11:48 parts
    drwxrwxr-x  6 user user  4096 Sep  6 11:48 prime
    drwxrwxr-x  3 user user  4096 Sep  6 11:48 snap
    drwxrwxr-x  4 user user  4096 Sep  6 11:48 stage


Snap Installieren:

.. code-block:: bash

    ~/hello$ sudo -H snap install --devmode hello_2.10_amd64.snap

    hello 2.10 installed

Snaps auflisten:

.. code-block:: bash

    $ snap list
    Name   Version    Rev   Developer  Notes
    core   16-2.27.5  2774  canonical  core
    hello  2.10       x1               devmode

Das snap ``hello`` (Programm) ist installiert, kann aber 'so' noch nicht vom
Benutzer aufgerufen werden. Die Anwendungen aus den *Snaps* sind über
``/snap/bin`` zu erreichen, sofern sie *freigeschaltet* wurden.

Hier ein Beispiel für eine ``apps`` Sektion (``snap/snapcraft.yaml``):

.. code-block:: yaml

    name: hello
    version: '2.10'
    summary: GNU Hello, the "hello world" snap
    description: |
      GNU hello prints a friendly greeting.
    grade: devel
    confinement: devmode

    apps:
      hello:
        command: bin/hello

    parts:
      gnu-hello:
        source: http://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz
        plugin: autotools
 
Es soll die App ``hello`` mit dem Kommando ``bin/hello`` installiert werden.

