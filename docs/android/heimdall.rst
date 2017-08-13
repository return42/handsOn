.. -*- coding: utf-8; mode: rst -*-

.. include:: ../android_refs.txt

.. _heimdall-intro:

========
Heimdall
========

Heimdall_ ist eine Open-Source cross-Platform Suite zum flashen der Firmware
(aka ROMs) auf Samsung *mobile* Geräten. Zum Flashen werden PC (auf dem Heimdall
installiert wird) und *mobile* Gerät via USB verbunden.

Die Android Geräte verwenden zum Flashen via USB i.d.R. das Fastboot
Protokoll. Samsung verwendet in seinen Geräten jedoch ein proprietäres von
Samsung entwickeltes Protokoll, das auch als *Odin Protokoll* bekannt ist.
Odin_ selbst ist ein Programm zum Flashen der Samsung Geräte. Odin_ gibt es
allerdings nur für Windows, es soll (laut Heimdall) wohl sehr langsam und
unzuverlässig laufen, außerdem ist es kein offizielles Programm von Samsung und
wird nicht von Samsung *suported*.  Heimdall spricht das gleiche Protokoll hat
aber den Vorteil, dass es für macOS, Win und Linux verfügbar ist.

GitHub: https://github.com/Benjamin-Dobell/Heimdall

Man kann die fertig gebaute Heimdall Software auch runterladen, jedoch ist der
zur Verfügung stehende Build nicht immer aktuell, deswegen macht es Sinn sich
die Software selber zu übersetzen. Zumindest auf Linux ist das recht einfach
möglich (s.a `Appendix B - Installing Heimdall Suite from Source
<https://github.com/Benjamin-Dobell/Heimdall/tree/master/Linux>`_). Als erstes
muss man sich die Pakete installieren, die für den Build erforderlich sind:

.. code-block:: bash

   sudo apt-get install build-essential cmake zlib1g-dev \
                qt5-default libusb-1.0-0-dev libgl1-mesa-glx \
                libgl1-mesa-dev git

Dann kann man sich das Reposetory klonen:

.. code-block:: bash

   $ cd ~/Downloads
   $ git clone https://github.com/Benjamin-Dobell/Heimdall.git
   Klone nach 'Heimdall' ...
   ...
   $ cd Heimdall/

Danach kann der Build konfiguriert werden:

.. code-block:: bash

   $ mkdir build
   $ cd build
   $ cmake -DCMAKE_BUILD_TYPE=Release ..
   -- The C compiler identification is GNU 5.4.0
   -- The CXX compiler identification is GNU 5.4.0
   -- Check for working C compiler: /usr/bin/cc
   -- Check for working C compiler: /usr/bin/cc -- works
   -- Detecting C compiler ABI info
   -- Detecting C compiler ABI info - done
   -- Detecting C compile features
   -- Detecting C compile features - done
   -- Check for working CXX compiler: /usr/bin/c++
   -- Check for working CXX compiler: /usr/bin/c++ -- works
   -- Detecting CXX compiler ABI info
   -- Detecting CXX compiler ABI info - done
   -- Detecting CXX compile features
   -- Detecting CXX compile features - done
   -- Found libusb: /usr/lib/x86_64-linux-gnu/libusb-1.0.so
   -- Checking if large (64-bit) file support is available...
   -- Checking if large (64-bit) file support is available - yes
   -- Found ZLIB: /usr/lib/x86_64-linux-gnu/libz.so (found version "1.2.8")
   -- Configuring done
   -- Generating done
   -- Build files have been written to: /share/Heimdall/build

Die Ausgaben des ``cmake`` solten in etwa wie oben aussehen, wenn da Fehler
gemeldet werden, hat man vermutlich eine Bibliothek (eines der oben zuvor
installierten Pakete) noch nicht installiert.

Mit 'make' wird dann der Build erstellt:

.. code-block:: bash

   $ make

Sofern das 'make' ohne Fehler durchläuft sollte man nun einen ``./bin`` Ordner
haben in dem die ausführbaren Binaries liegen:

.. code-block:: bash

   $ ls bin
   heimdall  heimdall-frontend

   $ ./bin/heimdall version
   v1.4.2

Partition Information Table (kurz PIT) Abfrage:

.. code-block:: bash

   $ sudo ./bin/heimdall print-pit  > my_samsung_device_PIT.txt
