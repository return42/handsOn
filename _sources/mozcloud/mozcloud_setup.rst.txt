.. -*- coding: utf-8; mode: rst -*-

.. include:: ../mozcloud_refs.txt

.. _xref_mozcloud_setup:

================================================================================
                            Allgemeines zum Setup
================================================================================

Beim Einrichten der Mozilla Dienste, empfiehlt es sich darauf zu achten, die
Dienste stark gegen das OS (auf dem sie installiert werden) zu isolieren.
Motivation sollte sein, die einfache Skallierbarkeit aufrecht zu erhalten und
den Dienst möglichst gut abzusichern bzw. zu isolieren. Letzteres ist um so
wichtiger, wenn man den Dienst *public* ins Internet stellen will.

Die Sourcen und Erläuterungen die von Mozilla zur Verfügung gestellt werden,
richten im einfachsten Setup i.d.R. eine Entwicklerumgebung ein. Zu dieser
Entwicklerumgebung, gehören meist ein kleiner ungesicherter WEB-Server, der auf
gesonderten Ports *lauscht*. Diese Entwicklerumgebungen sind für einen Test der
Installation meist recht hilfreich, sie eignen sich jedoch nicht dafür, ins
Internet gestellt zu werden. Hierfür sollten die Dienste hinter seinem SSL
signierten WEB-Server stehen, den man im Internet betreibt (z.B. hinter seinem
Apache WEB Server wie aus dem Abschnitt :ref:`xref_apache_setup`).

Die Installation und der produktive Betrieb der Dienste sollte unter einen
gesonderten System-Benutzer erfolgen.

* isolierter System-Benutzer für die Cloud Dienste (z.B.): ``mozcloud``
* Installation unter dem Systemaccount (z.B.): ``/home/mozcloud/<servicename>``

Einrichten des System-Benutzers (``mozcloud``):

.. code-block:: bash

   $ sudo -H adduser --system --disabled-password --disabled-login \
                  --shell /bin/bash \
                  --gecos "Mozilla Cloud" \
                  mozcloud

Wechseln zum System-Benutzer:

.. code-block:: bash

   $ sudo -i -u mozcloud

Clonen der Sourcen (z.B. Firefox Sync-1.5 Server) in den Home Ordner des
System-Benutzer:

.. code-block:: bash

   $ cd ~
   $ git clone https://github.com/mozilla-services/syncserver

Hier im Ordner ``/home/mozcloud/<servicename>``, also im HOME-Ordner des
System-Benutzer ``mozcloud`` würde man den Dienst installieren und testen.  Hat
man seine Tests beendet und will die ganze Cloud-Umgebung wieder von seinem
(Entwicklerrechner) eliminieren, dann reicht es aus den System-Benutzer der
Cloud zu löschen.  Bevor der Benutzer entfernt werden kann, müssen alle seine
Prozesse beendet werden. Läuft das WEB-Interface im Apache, muss also die
entsprechende Apache-Site mit der Konfiguration zu diesem Dienst (zu diesem
Account) deaktiviert werden (inkl. apache reload).

.. code-block:: bash

   $ deluser --remove-home mozcloud

.. caution::

  Auf diese Weise wird die gesammte Cloud Installation, sammt aller
  Konfigurationen auf dem Host **UNWIEDERUFLICH** gelöscht.
