.. -*- coding: utf-8; mode: rst -*-

.. include:: ../android_refs.txt

.. _android_dev_options:

===========================
Entwickler-Optionen & Modes
===========================

Entwickler-Optionen
===================

Die Androids verfügen über ein Menü mit Entwickler-Optionen, das im Werkszustand
deaktivert ist. Um dieses Menü anzuzeigen geht man i.d.R. wie folgt vor::

  Einstellungen --> Info --> Softwareinformation --> Buildnummer

Anstatt 'Info' kann da auch so was wie 'Über das Telefon' oder 'Info zu Tablet'
stehen, i.d.R. ist der Menüpunkt irgendwo ganz unten in den Einstellungen zu
finden.

Auf den Menüpunkt 'Buildnummer' muss man 7 mal tippen, dann sind die Entwickler-
Optionen aktiviert (ja, einfach sieben mal auf den Eintrag hauen, das ist quasi
das *easter egg* für Entwickler).

Wenn man jetzt wieder auf "Einstellungen" wechselt, sieht man in dem Menu ganz
unten als letzten oder vorletzten Eintrag die "Entwickleroptionen".

Man kann das nur Rückgängig machen, indem man unter::

  Einstellungen --> Apps -->  Alle Apps --> Einstellungen

Ja, die 'Einstellungen' sind auch eine App. Die Menüführung zu der Auflistung
'Alle Apps' kann auch leicht anders sein, hängt vom Android ab.  Hat man die App
'Einstellungen' gefunden und da drauf gedrückt, kann man dort einen Menüpunkt
wie 'Speicher' finden (manchmal gibt es den auch zweimal, dann muss man schauen
welcher der richtige ist). Klickt man da drauf, gibt es einen Button ``Daten
Löschen``. Wenn man da drauf haut, werden die Entwickler-Optionen
deaktiviert. Was noch an *Einstellungen* zurück gesetzt wird, kann ich nicht
sagen, bei mir scheint es sich aber tatsächlich nur auf die Deaktivierung der
Entwickler-Optionen zu beschränken.

.. _android_oem_unlock:

OEM Entsperren (unlock)
=======================

Will man ein Custom-Recovery System auf sein Gerät spielen, so muss man
i.d.R. dazu das Gerät entsperren. In den Entwickler-Optionen gibt es dafür einen
Schalter, der 'OEM unlock' oder eben 'OEM Entspreren' heißt.


.. samsung_download_mode::

Samsung Download & Recovery
===========================

Die Samsung Androids verfügen i.d.R. über einen Download-Boot und eine
Recovery-Boot. Der Download-Boot dient zum flashen der Geräte und mit dem
Recovery-Boot kann man ein Recovery-System starten (s.a. :ref:`android_recovery`
). Um das Gerät im Download - oder Recovery Mode zu booten sind z.T. etwas
kryptische Kombinationen der Volume (up&down & laut&leise) Buttons, des Home
Buttons (der Button in der Mitte) und des Power Buttons erforderlich.

.. hint::

   Man sollte den Download-Mode nur dann aktivieren, wenn man sich vorher
   :ref:`heimdall-intro`, Odin_ oder die `Android Debug Bridge (adb)`_
   installiert hat, denn meist kommt man aus diesem Modus nur wieder raus, wenn
   der Akku leer ist oder man mit einem dieser Tools einen Re-Boot anstößt.  Das
   Starten eines Recovery-Systems ist unkritisch, da man dort meist ein Menü hat
   wo man einen Re-Boot neu anstoßen kann.


Smartphones:

- Gerät komplett abschalten
- Gleichzeitig: Volume Button (Up/Down zusammen) + Power Button
- Es kommt eine Meldung / ein Bildschirm.  Mit dem Volume Up/Down kann man meist
  was auswählen. Z.B Download-Mode oder Recovery-Boot


Tablets:

- Recovery:

  - Gleichzeitig: Home Button + Volume Up (laut) + Power Button
  - Sobald das Logo aufleuchtet wieder alles loslassen
  - Nach ein paar Sekunden kommt das Recovery Menü

- Download:

  - Gleichzeitig: Home Button + Volume *Down* (leise) + Power Button
  - Sobald das Logo aufleuchtet wieder alles loslassen
  - danach erscheint ein Bildschirm mit einer Warnung
  - jetzt Volume *Up* (laut) um in den Download Mode zu aktivieren.
