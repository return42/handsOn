.. -*- coding: utf-8; mode: rst -*-

.. _xref_radicale_Server:

Radicale Server
===============

Die CalDAV und CardDAV Server Installation (Radicale) erfolgt in eine bestehende
Apache Instanz (siehe :ref:`xref_apache_setup`)

* Radicale: http://radicale.org

Ich habe mich für Radicale entschieden, da es sich auf CalDAV und CardDAV
beschränkt und keine Groupware ist, die mehr Lösungen anbietet als ich
brauche. Weiter lies sich Radicale gut *hinter* dem Apache unter einer Präfix
URL (``radicale``) platzieren:

* ``https://<hostname>/radicale``

Zu dieser Installation gehört auch das WEB-Frontend InfCloud. Mit InfCloud
können Kalender und Adressen angezeigt und bearbeitet werden.  Zur Installation
existiert ein Script, das alle Setups vornimmt::

   $ ${SCRIPT_FOLDER}/radicale.sh install

Es verwendet die beiden folgenden Reposetories:

* https://github.com/return42/Radicale.git
* https://github.com/return42/RadicaleInfCloud

Sharing
-------

Radicale ist ein leichtgewichitiger CalDAV & CardDAV Server, der allerings kein
Sharing von (z.B.) Kalendern über CalDAV vorsieht. Die sogenannten *Vertreter-*
Regelungen die es auch für CalDAV gibt sind im Radicale nicht vorgesehen (wäre
zu ausufernd und nicht alle Clients *sprechen* exakt das gleiche Protokoll).

Unten gezeigte Authentifizierung über den Apache hat den Vorteil (oder auch
Nachteil), dass alle Objekte über die URL *public* lesbar sind (zumindest für
die Benutzer, die ein gültiges Login auf dem Host haben). Der Vorteil ist, dass
so beispielsweise die Kalender anderer Benutzer über die URL als Abbo bereit
gestellt werden können.

Die URL zu einem seiner Kalender kann man über sein Login ermitteln. Über:

  https://<hostname>/raidcale

meldet man sich an und kann die URLs bestehender Kalender sehen oder auch neue
Kalender anlegen. Will man seinem Kollegen den Kalender bereit stellen, muss man
ihm nur diese URL geben, die er als *Abo* in seinen Kalender mit aufnimmt.


Authentifizierung
-----------------

Die Authentifizierung wird vom Apache übernommen::

    WSGIScriptAlias /radicale /var/www/pyApps/radicale.wsgi

    <Location /radicale>

        <IfModule mod_security2.c>
            SecRuleEngine Off
        </IfModule>

        Require valid-user

        Order deny,allow
        Deny from all
        Allow from fd00::/8 192.168.0.0/16 fe80::/10 127.0.0.0/8 ::1

        AuthType Basic
        AuthBasicProvider external
        AuthName "radicale"
        AuthExternal pwauth

    </Location>

Zusammengefasst ergibt sich::

    Basis-URL:     https://<hostname>/radicale
    Benutzername:  <user>
    Passwort:      <passwd>

Der ``user`` ist der Benutzername des Logins (``pwauth``). Benutzername und
Passwort ergeben sich aus den LDAP- und System Benutzern (posix)."

Alternativen
------------

Baikal (http://sabre.io/baikal) ist ein ebenfalls oft genutzter Cal- und CardDAV
Server. Er basiert auf 'sabre/dav' (http://sabre.io) was eine PHP
Implementierung des CardDAV, CalDAV and WebDAV ist (das wird auch von OwnCloud
genutzt). Ich hatte Baikal auch schon mal vor vielen Jahren installiert, dann
wurde das aber zwischenzeitlich *kaputt-gebastelt*. Die Arbeit an der Version 2
wurde wohl ganz eingestellt.  Das alles und der Umstand, dass es sich um eine
PHP Implementierung handelt, läßt mich von Baikal abstand nehmen.

Wer eine Groupware sucht, der sollte sich evtl. folgende Projekte anschauen.

* SOgo: https://sogo.nu

  Es gibt zwei *main* Versionen SOgo 2 und SOgo 3. Die Version 3 hat ein
  WEB-Interface. Beide Versionen nutzen die gleiche Implementierung der SOGo und
  SOPE Protokolle: LDAP, IMAP, SQL, CardDAV, CalDAV, and Microsoft Enterprise
  ActiveSync. Mit letzterem bietet SOgo ein Sync-Protokoll (Microsoft
  ActiveSync) an, dass auch vom Outlook *verstanden* wird (ich hab es aber noch
  nicht getstet).

* Cozy: https://cozy.io

  Die Groupware Lösung Cozy gibt es in zwei Versionen Cozy 2 und Cozy 3. Das
  Backend der Version 2 ist eine NodeJS Implementierung und wird nicht mehr
  weiter entwickelt. Die Version 3 ist eine Go Implementierung und ist nicht
  abwärtskompatibel zur Version 2.  Die Plugins aus der 2er Version können in
  Version 3 nicht genutzt werden. Der Release Plan:

  * https://blog.cozycloud.cc/post/2016/11/21/On-the-road-to-Cozy-version-3

  sieht für Ende Q3 2017 ein erstes Release vor. Mit dem Release sollte man sich
  cozy ggf. nochmal anschauen, vorher lohnt sich das meines Erachtens nach
  aber nicht."
