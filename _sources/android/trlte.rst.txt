.. -*- coding: utf-8; mode: rst -*-

.. _trlte:

========================================
Samsung Galaxy Note 4 SM-N910F ``trlte``
========================================

Spec: `SM-N910F <https://www.phonemore.com/specs/samsung/galaxy-note-4/sm-n910f/>`__

Chipset
  32bit: Qualcomm Snapdragon 805 APQ8084 Pro (28nm)

CPU:
  Quad-core,1 processor:
  4x 2.7GHz Krait 450 (Quad-core)

GPU graphical controller:
  Qualcomm Adreno 420

#. Auf dem PC :ref:`heimdall-intro` installieren
#. TWRP und Custom-ROM runterladen

   - TWRP: https://dl.twrp.me/trlte/
   - Custom ROM: `[ROM][UNOFFICIAL][11] LineageOS 18.1 [tblte][trlte][trlteduos] <https://forum.xda-developers.com/t/rom-unofficial-11-lineageos-18-1-tblte-trlte-trlteduos.4067663/>`

#. Deckel von der Rückwand entfernen, damit der Akku später bei BEadrf schnell
   entfernt werden kann.
#. Gerät in den :ref:`Download-Mode <samsung_download_mode>` versetzen
   (Gleichzeitig: Home Button + Volume Up (laut) + Power Button)
#. USB Kabel am PC anschließen
#. Überprüfen ob Heimdall das Gerät *sehen* kann::

     $ heimdall detect

#. Neues Recovery-System (TWRP) auf das Gerät flashen::

     $ heimdall flash --no-reeboot --RECOVERY twrp-3.7.0_9-0-trlte.img
     heimdall v1.4.2
     ...
     Initialising connection...
     ...
     Session begun.
     Downloading device's PIT file...
     PIT file download successful.
     Uploading RECOVERY
     100%
     RECOVERY upload successful
     Ending session...
     Releasing device interface...

   Ziel der ``--no-reeboot`` Option war es nicht gleich in den Re-Boot des
   Stock-Recovery zu fallen, das würde nämlich sofort wieder unser soeben
   aufgespieltes TWRP mit dem Recovery-System aus dem Stock-ROM flashen.

#. Wenn nun die Batterie entfernt wird schaltet sich das Gerät ab und dann muss
   es im Recovery-Mode des soeben installierten TWRP gestartet werden (Home
   Button + Volume Up + Power Button).

#. In dem TWRP kann man dann die Partitionen des Stock-ROM *Wipen* (endgültig
   löschen) und das Gerät ist endlich *befreit* und es wird das TRWP nicht mehr
   überschrieben.

#. USB Kabel wiede anschließen und das Custom-ROM auf das Gerät kopieren (auf
   die SD-Karte, wenn vorhanden).

#. Im TWRP "INSTALL" wählen, das soeben aufgespielte Image (CROM) auswählen und
   installieren.

