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

Thunderbird mit CardBook
------------------------

CardBook ist ein AddOn für den Thunderbird, das das Standard-Adressbuch des
Thunderbird vollständig ersetzen kann. Mit CardBook kann ein CardDAV Adressbuch
auf einem Server synchronisieren (der Kram, der in Thunderbird standard ist,
ist schrottig und auch das SOgo Plugin ist schrottig, beides braucht man nicht
ausprobieren).

* CardBook: https://addons.mozilla.org/en-US/thunderbird/addon/cardbook/?src=api
* CardBook Forum: https://cardbook.6660.eu/

CardBook im AddOn Manager des Thunderbirds suchen und installieren.  Danach über
"Tools --> CardBook" die Adressbuchverwaltung öffnen. Links oben gibt es ein
Menü auf das man klicken muss, damit es sich öffnet, darin "Adressbuch -->
Adressbuch hinzufügen" auswählen.::

  Im Netzwerk

  Art:           CardDAV
  URL:           https://<hostname>/radicale/<user>/<calendar-folder>
  Benutzer Name: <user>
  Passwot:       <passwd>

Mit dem "Überprüfen" Button kann man testen ob ein Connect hergestellt werden
kann. Ich musste danach nochmal das soeben eingerichteten Adressbuch auswählen
und synchronisieren.

Anders als evtl. bei anderen CardDAV Clients -- die mehrere Adressbücher unter
einem Account verwalten können -- müss bei CardBook für jedes Adressbuch auf dem
Server ein, wie oben beschriebener Account eingerichtet werden. Bei dem immer
die vollständige URL des Ordners mit dem Adressbuch angegeben werden muss in
meinem Setup ist das beispielsweise mein 'markus-adressbuch'::

  https://storage/radicale/markus/markus-adressbuch

Ein wünscheswertes Feature wäre eine Sortierung der Adressbücher nicht nach der
Eigenschaft ``CATEGORIES`` sondern nach den vCards für Listen. Dies ist die
übliche Methode zur Gruppierung in MacOS und -- soweit ich weiß -- auch bei den
Google Adressbüchern. Bei DAVDroid kann man das einstellen ob "Gruppen vCards"
oder aber "CATEGORIES" sind. Im Grunde liest CardBook die beiden Felder
``X-ADDRESSBOOKSERVER-KIND`` und ``X-ADDRESSBOOKSERVER-MEMBER`` der vCard-Listen
schon ganz richtig ein und in der Listenansicht sind auch die Mitglieder einer
Gruppe aufgeführt.

Die Möglichkeit zur Gruppierung in der Addressbar (auf der linken Seite des
CardBook) entlang dieser Gruppen ist leider nicht möglich. Der Entwickler
*Philippe* ist dem Feature nicht abgeneigt, hat derzeit aber wohl genung anderes
zu tun, so dass mit einer solchen Gruppierung in naher Zukunft wohl eher nicht
zu rechnen ist.

  Wer aber keine Gruppierung in seinem Adressbuch hat, der wird damit auch keine
  Probleme haben ;)
