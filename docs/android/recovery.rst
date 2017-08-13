.. -*- coding: utf-8; mode: rst -*-

.. include:: ../android_refs.txt
   
================
Recovery & Flash
================

Mit 'Recovery' oder auch *Wiederherstellung* ist das Booten einer Recovery
Partition gemeint. Man kann sich das so vorstellen als würde man ein
*Rettungs-System* von einer CD booten nur mit dem Unterschied, dass es keine CD
gibt. Das Rettungs- (oder auch Recover-) System ist auf einer Partition im
Android Device installiert. Der Speicher im Android Device ist in Partitionen
aufgeteilt. Auf einer Partition liegt das Recoery-Image auf einer anderen das
Android Betriebsystem, das normalerweise gestartet wird (boot). Es kann aber
auch noch mehr Partitionen geben. Legt man z.B. eine SD-Karte ein und formatiert
die, hat man mindestens eine weitere Partition.

Die Ausprägung der Recovery Partition variert und ist nicht für alle Geräte
gleich. Da die Recovery Systeme der Hersteller meist noch nicht mal ein
*Recovery* im Sinne von *Wiederherstellung* anbieten und i.d.R. auch
undokumentiert sind, kann man die meist zu nichts gebrauchen.  Es gibt *freie*
Alternativen wie z.B. das TWRP_, das inzwischen so was wie der Standard der
*Custom-Recovery-Systeme* ist.

- Stock-Recovery: Recovery-System des Herstellers
- Custom-Recovery: alternatives Recovery-System

TWRP
====

Team Win Recovery Project (TWRP_) ist ein herstellerunabhängiges
Custom-Recovery-System für Android-Geräte. Das Projekt ist OpenSource und liegt
bei github:

- https://github.com/omnirom/android_bootable_recovery

Da die Gerätehardware stark varriiert (z.B. was den Prozessor anbelangt) gibt es
diverse speziefische Images. Auf der Seite:

- https://twrp.me/Devices/

kann man die Geräte recherchieren und auf die entsprechende Seite zum Gerät
springen. Auf dieser Seite findet man in kompakter Form ein paar Hinweise und
weitere Links. Ich hab hier beispielsweise ein *Galaxy Tab A 10.1 (wifi)* 

Galaxy Tab A (2016, 10.1, Wi-Fi)
--------------------------------

- TWRP Download: https://eu.dl.twrp.me/gtaxlwifi/
- TWRP for Samsung Galaxy Tab A 10.1 WiFi (2016):
  https://twrp.me/devices/samsunggalaxytaba101wifi2016.html
- TWRP: https://github.com/omnirom/android_bootable_recovery (android-6.0)
- Device tree: https://github.com/TeamWin/android_device_samsung_gtaxlwifi (android-6.0)
- Kernel: https://github.com/jcadduono/android_kernel_samsung_exynos7870 (twrp-6.0)
- Support Thread auf xda-developers:
  https://forum.xda-developers.com/galaxy-tab-a/development/recovery-official-twrp-gtaxlwifi-galaxy-t3437666

Installation mit Heimdall_::

  heimdall flash --RECOVERY twrp-3.1.1-0-gtaxlwifi.img


Heimdall
========

Heimdall_ ist eine Open-Source cross-Platform Suite zum flashen der Firmware
(aka ROMs) auf Samsung *mobile* Geräten. Zum Flashen werden PC (auf dem Heimdall
installiert wird) und *mobile* Gerät via USB verbunden.

Die Android Geräte verwenden zum Flashen via USB i.d.R. das Fastboot
Protokoll. Samsung verwendet in seinen Geräten jedoch ein proprietäres von
Samsung entwickeltes Protokoll, dass auch als 'Odin Protokoll' bekannte
Protokoll. Odin_ ist ein Programm zum Flashen der Samsung Geräte. Odin_ gibt es
allerdings nur für Windows, es soll (laut Heimdall) wohl sehr langsam
unzuverlässig laufen, außerdem ist es kein offizielles Programm von Samsung.

Heimdall spricht das gleiche Protokoll hat aber den vorteil, dass es für macOS,
Win und Linux verfügbar ist.

GitHub: https://github.com/Benjamin-Dobell/Heimdall

Man kann die fertig gebaute Heimdall Software auch runterladen, jedoch ist der
zur Verfügung stehende Build nicht immer aktuell, deswegen machtt es Sinn sich
die Software selber zu übersetzen. Zumindest auf Linux ist das recht einfach
möglich:

- Appendix B - Installing Heimdall Suite from Source:
  https://github.com/Benjamin-Dobell/Heimdall/tree/master/Linux

Als erstes muss man sich die Pakete installieren, die für den Build erforderlich
sind:

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

Danach kann der Build Konfiguriert werden:

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

Sofern das 'make' ohne Fehler durchläuft sollte man nun einen 'bin' Ordner haben
in dem die ausführbaren Binaries liegen:

.. code-block:: bash

   $ ls bin
   heimdall  heimdall-frontend

   $ ./bin/heimdall version
   v1.4.2

