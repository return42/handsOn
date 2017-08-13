.. -*- coding: utf-8; mode: rst -*-

.. include:: ../android_refs.txt

.. _twrp_intro:
             
====
TWRP
====

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

Galaxy Tab A (2016, 10.1, Wi-Fi)
--------------------------------

- TWRP for Samsung Galaxy Tab A 10.1 WiFi (2016):
  https://twrp.me/devices/samsunggalaxytaba101wifi2016.html
- TWRP gtaxlwifi Image Download: https://eu.dl.twrp.me/gtaxlwifi/

- TWRP: https://github.com/omnirom/android_bootable_recovery (android-6.0)
- Device tree: https://github.com/TeamWin/android_device_samsung_gtaxlwifi (android-6.0)
- Kernel: https://github.com/jcadduono/android_kernel_samsung_exynos7870 (twrp-6.0)
- Support Thread auf xda-developers:
  https://forum.xda-developers.com/galaxy-tab-a/development/recovery-official-twrp-gtaxlwifi-galaxy-t3437666

Installation mit Heimdall_::

  heimdall flash --RECOVERY twrp-3.1.1-0-gtaxlwifi.img
