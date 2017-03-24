.. -*- coding: utf-8; mode: rst -*-

.. _xref_dav_client:

CalDAV und CardDAV Clients
===========================

Radicale unterstützt eine ganze Reihe von DAV-Client Anwendungen. Man sollte
sich in jedem Fall die Doku der Clients anschauen:

* http://radicale.org/user_documentation/#idstarting-the-client

Manche können nur CardDAV, manche nur CalDAV und manche Clients unterstützen
sowohl CardDAV als auch CalDAV. Meist sind die Clients etwas *hakelig* so können
einige z.B. mit Kalendern arbeiten aber keine neuen Kalender anlegen. Das
Gleiche gilt für Adressbücher, manche Clients können keine Adressbücher neu
anlegen, mit bestehenden aber gut arbeiten."

Android Clients
---------------

Auf den Androids empfiehlt es sich DAVdroid zu installieren:

* https://davdroid.bitfire.at

Des weiteren empfiehlt es sich die App OpenTasks zu installieren

* https://github.com/dmfs/opentasks

DAVdroid als auch OpenTask gibt es bei google im Play-store oder aber auch bei
F-Droid (https://f-droid.org). Je nachdem wie viel *Sicherheit* man auf seinem
Smartphone eingerichtet hat, kann es sein, dass man DAVdroid noch explizit die
Berechtigung geben muss auf den Kalender und das Adressbuch auf dem Android
zuzugreifen. Bei mir musste ich unter::

    Einstellungen --> Apps

die beiden Apps raus suchen und dort bei jeder App die Berechtigungen manuell
aktivieren. Nach der Installation von DAVdroid dieses einmal starten. Im
Begrüßungsbildschirm einmal auf das ``+`` Symbol unten rechts klicken um einen
Account einzurichten. Dann auswählen:

    *Mit URL und Benutzername anmelden* ::

        Basis-URL:     https://<hostname>/radicale
        Benutzername:  <user>
        Passwort:      <passwd>

Falls der Server ``<hostname>`` über ein selbst-signiertes Zertifikat verfügt,
muss man dieses mittels Prüfsumme im nächsten Dialog bestätigen. Danach prüft
DAVdroid was alles auf dem Server zur Verfügung steht, am Ende quittiert man
nochmal mit *Account anlegen*. Klickt man in das so eingerichtete Konto, so
bekommt man alle Kalender und Adressbücher auf dem Server angezeigt. Soll eines
oder mehrere dieser Objekte synchronisiert werden, so muss es noch aktivieren
(einmal anklicken).

.. note::

  Bei mir kam mit der ersten Synchronisierung eine Info Box, in der ich nochmal
  bestätigen musste, dass DAVdroid Zugriff auf Kalender, Adressbuch und OpenTask
  bekommen soll. Erst nachdem das alles quittiert war wurde die Synchronisierung
  erfolgreich durchgeführt, bei der ich abermals bestätigen musste, dass
  DAVdroid die erforderlichen Berechtigungen bekommt. Es kann sein, dass das mit
  den Berechtigungen bei mir so ausartet, weil mein Android Setup ziemlich
  paranoid ist. Die erste Synchronisierung kann dann schon ein paar Minuten
  dauern, je nachdem wie viele Kalender- und Adressbucheinträge so synchronisiert
  werden müssen.

Nach Abschluss der Synchronisierung sollte man nun die synchronisierten Adressen
in der *Adressbuch-App* des Androids finden und die synchronisierten Kalender in
der *Kalender-App* des Androids.

Apple Kontakte
--------------

Im Adressbuch (*Kontakte*) des MacOS unter *Accounts* mit dem ``+`` Symbol einen
neuen Account anlegen. Kontakte Version 7.1::

    Accounttyp:      CardDAV
    Benutzername:    <user>
    Kennwort:        <passwd>
    Serveradresse:   <hostname>/radicale/<user>

In der neueren Version 10.0 der *Kontakte* (bei MacOS Sierra dabei) ist noch ein
*vorgeschalteter* Dialog, auf dem man *Anderer Kontakte-Account* auswählen
muss, anschließend::

                     CardDAV
    Accounttyp:      Erweitert
    Benutzername:    <user>
    Kennwort:        <passwd>
    Serveradresse:   <hostname>
    Serverpfad:      /radicale/<user>/
    Port:            443
    SSL verwenden:   Ja

Irgendwie scheint dieser Dialog in Version 10.0 aber *kaputt-gebastelt* zu
sein. Ich musste anschließend den **Serverpfad** ``/radicale/<user>/`` explizit
nochmal unter *Servereinstellungen* eingeben (der fehlte dort, obwohl er oben
mit angegeben wurde).

Beim Einrichten der Accounts (sowohl für *Kalender* als auch für *Kontakte*)
sollte/darf nicht das Protokoll ``https://`` mit angegeben werden, der
*principal* also der Benutzername des Logins sollte/muss aber am Ende angegeben
werden und mit einem Slash ``/`` enden.

Nach dem Anlegen ist der Account bereits aktiviert. Jedoch musste ich bei der
Version 10 mit ``Cmd-Q`` die *Kontakte* Anwendung erst mal beenden und neu
starten, bevor synchronisiert wurde. Nach der Synchronisierung sollten nun die
Adressen und Gruppen in den Kontakten zu sehen sein.


Apple Kalender
--------------

Im *Kalender* des MacOS unter *Accounts* mit dem ``+`` Symbol einen neuen
Account anlegen. Kalender Version 6.0::

    Accounttyp:      CardDAV
    Benutzername:    <user>
    Kennwort:        <passwd>
    Serveradresse:   <hostname>/radicale/<user>

In der neueren Version 9.0 des Kalenders (bei MacOS Sierra dabei) ist noch ein
*vorgeschalteter* Dialog, auf dem man *Anderer CalDAV-Account* auswählen
muss, anschließend::

    Accounttyp:      Erweitert
    Benutzername:    <user>
    Kennwort:        <passwd>
    Serveradresse:   <hostname>
    Serverpfad:      /radicale/<user>/
    Port:            443
    SSL verwenden:   Ja

Nach dem Anlegen ist der Account bereits aktiviert und wird synchronisiert, was
aber u.U. einige Minuten in Anspruch nehmen kann.
