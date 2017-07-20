.. -*- coding: utf-8; mode: rst -*-

.. _xref_radicale_Server:

Radicale Server
===============

Die CalDAV und CardDAV Server Installation (Radicale) erfolgt in eine bestehende
Apache Instanz (so wie sie vom Script ``${SCRIPT_FOLDER}/apache_setup.sh``
eingerichtet wird).

* Radicale Server: http://radicale.org

Ich habe mich für Radicale entschieden, da es sich auf CalDAV und CardDAV
beschränkt und keine Groupware ist, die mehr Lösungen anbietet als ich
brauche. Weiter lies sich Radicale gut *hinter* dem Apache unter einer Präfix
URL (``radicale``) platzieren:

* ``https://<hostname>/radicale``

Zu dieser Installation gehört auch das WEB-Frontend InfCloud. InfCloud ist ein
sehr einfaches WEB-Frontend. Es kann Kalender und Adressen Anzeigen und
bearbeiten, jedoch kann es keine neuen Kalender oder Adressbücher anlegen
(s.u.). InfCloud ist erreichbar über die URL:

* ``https://<hostname>/infcloud``

Zur Installation existiert ein Script, das alle Setups vornimmt::

   $ ${SCRIPT_FOLDER}/radicale.sh install

Es verwendet die beiden folgenden Reposetories:

* https://github.com/return42/Radicale.git
* https://github.com/return42/RadicaleWeb.git


Authentifizierung
-----------------

Die Authentifizierung wird vom Apache übernommen::

    <Location /radicale>
        ...
        Require valid-user
        AuthType Basic
        AuthBasicProvider external
        AuthName "radicale"
        AuthExternal pwauth
        ...
    </Location>

    <Location /radicale/.web/infcloud>
        Require all granted
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
