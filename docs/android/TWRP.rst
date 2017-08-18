.. -*- coding: utf-8; mode: rst -*-

.. include:: ../android_refs.txt

.. _twrp_intro:
             
=========================
Team Win Recovery Project
=========================

Team Win Recovery Project (TWRP_) ist ein herstellerunabhängiges
Custom-Recovery-System für Android-Geräte. Das Projekt ist OpenSource und liegt
bei github:

- https://github.com/omnirom/android_bootable_recovery

Da die Hardware der Geräte stark varriiert (z.B. SoC_ & Cellular_) gibt es
diverse Geräte-Speziefische Images. Auf der Seite:

- https://twrp.me/Devices/

kann man die Geräte recherchieren und auf die entsprechende Seite zum Gerät
springen. Auf dieser Seite findet man in kompakter Form ein paar Hinweise und
weitere Links. Ich hab hier beispielsweise ein *Galaxy Tab A 10.1 (wifi)*

.. hint::

   Wer einen Google Konto hat sollte sicherstellen, dass er den `Geräteschutz
   bei Google <https://support.google.com/nexus/answer/6172890?hl=de>`_
   deaktiviert hat, bevor er TWRP oder ein ROM aufspielt!!!

   Man sollte eine (externe) SD-Karte in das Gerät stecken.  Auf dieser Karte
   können dann die Sicherungen erfolgen. Auch wird man Custom-ROMs und andere
   Installationen (z.B. SuperSU) dort ablegen und von dort im Recoery-Mode
   installieren.
   

Galaxy Tab A 6 (2016, 10.1, Wi-Fi)
==================================

- TWRP for Samsung Galaxy Tab A 10.1 WiFi (2016):
  https://twrp.me/devices/samsunggalaxytaba101wifi2016.html
- TWRP gtaxlwifi Image Download: https://eu.dl.twrp.me/gtaxlwifi/

- TWRP: https://github.com/omnirom/android_bootable_recovery (android-6.0)
- Device tree: https://github.com/TeamWin/android_device_samsung_gtaxlwifi (android-6.0)
- Kernel: https://github.com/jcadduono/android_kernel_samsung_exynos7870 (twrp-6.0)
- Support Thread auf xda-developers:
  https://forum.xda-developers.com/galaxy-tab-a/development/recovery-official-twrp-gtaxlwifi-galaxy-t3437666

1. TWRP aufspielen
------------------

Um das TWRP aufzuspielen muss das Gerät entsperrt sein (s.a.
:ref:`android_oem_unlock`). Installation mit Heimdall_::

  heimdall flash --RECOVERY twrp-3.1.1-0-gtaxlwifi.img

Danach im Recovery Mode booten. Jetzt müsste man TWRP sehen, evtl. stellt man
sich jetzt schon mal die Sprache ein. TWRP kann die System Partition 'nur
lesend' einhängen. I.d.R. will man aber die Systempartition verändern, deswegen
muss man in dem initialen Dialog den Regler auf 'Veränderungen zulassen'
schieben. Macht man das nicht wird TWRP u.U. beim nächsten boot vom System
wieder gelöscht (eigentlich kann man dann eh nicht viel machen).

2. Nutzdaten & System sichern
-----------------------------

**Nutzdaten**: Es sollte in jedem Fall eine Sicherung der Daten (Bilder, Videos,
Dokumente, Kontakte, Kalender, 'media' etc.) durchgeführt werden! Diese
*Nutzdaten* liegen bei neueren Geräten in einer verschlüsselten Partition, diese
kann TWRP nicht lesen. Also muss man die Daten im normalen Betrieb sichern.

Zusätzlich sollte eine Sicherung des System mit TWRP angelegt werden. Dazu im
Recoery-Mode booten und über TWRP 'Sichern' (backup) die Partitionen zur
Sicherung auswählen.

Meist wird mman die Sicherung auf eine SD-Karte vornehmen, ich empfehle die
Sicherung von dieser SD-Karte nochmal auf dem PC oder irgendwo anders
hinzukopieren.


3. verschlüsselte Partition formatieren
----------------------------------------

.. hint::

   Spätestens jetzt sollte man eine Sicherung der *Nutzdaten* und des Systems
   haben!!!

Der verschlüsselte 'Interne Storage' muss formatiert werden, dabei gehen die
*Nutzdaten* dann verloren. Dazu im TWRP auf "Löschen" (wipe), dann auf "Daten
formatieren" (format). Da dieser Schritt nicht mehr Rückgängig gemaccht werden
kann muss man expliziet "yes" eintippen.

Dieser Schritt ist nur einmal erforderlich, danach gibt es keine verschlüsselte
Partition mehr und man kann anfangen ein anderes ROM, SuperSU oder sonst was
installieren.


3. TWRP App Installieren
=========================

Nachdem man die verschlüsselte Partition gelöscht (formatiert) hat, kann man
noch die TWRP App installieren. Bzw. das wird man automatisch gefragt, wenn man
einen Neustart wählt.

.. hint::

   Nach dem Installieren eines ROMs wird man auch gefragt ob man die App
   installieren will, dass sollte man aber besser nicht machen, weil dann die
   Checksummen ROMs beim ersten Start nicht mehr stimmen (war bei mir der Fall).
