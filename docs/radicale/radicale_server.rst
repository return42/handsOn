.. -*- coding: utf-8; mode: rst -*-

.. _xref_radicale_Server:

===============
Radicale Server
===============

* Radicale: http://radicale.org

Ich habe mich für Radicale entschieden, da es sich auf CalDAV und CardDAV
beschränkt und keine Groupware ist, die mehr Lösungen anbietet als ich brauche.
Weiter lies sich Radicale gut *hinter* dem Apache unter einer Präfix URL
(``radicale``) platzieren (https://hostname/radicale).  Andere Lösungen siehe
Alternativen_.

.. hint::

   Letztes Release ist v2.x (https://github.com/Kozea/Radicale/releases), der
   **master** Branch wurde inzwischen jedoch stark überarbeitet.  Im Zuge dieser
   Überarbeitung werden z.T. andere Settings benötigt, als sie noch in der
   offiziellen Dokumentation beschrieben werden.  Die hier vorgestellte
   Installation basiert auf dem **master** Branch und verwendet immer die
   *aktuellen* Settings.

Die CalDAV und CardDAV Server Installation (Radicale) erfolgt in eine bestehende
Apache Instanz (siehe :ref:`xref_apache_setup`).  Die hier vorgestellt
Installation verwendet das interne WEB-Frontend von Radicale.  Als Alternative
bietet sich eine vollwertige WEB-Anwendung für Adressbuch und Kalender an.  So
gibt es z.B. für `InfCloud
<https://www.inf-it.com/open-source/clients/infcloud/>`_ eine Integration
`RadicaleInfCloud <https://github.com/Unrud/RadicaleInfCloud>`_), die jedoch
nicht zu den aktuellen Änderungen im **master** Branch passt.


Sharing
=======

Radicale ist ein leichtgewichitiger CalDAV & CardDAV Server, der allerdings kein
echtes Sharing von (z.B.) Kalendern über CalDAV vorsieht.  Die sogenannten
*Vertreter-* Regelungen, die es auch für CalDAV gibt sind im Radicale nicht
vorgesehen (wäre zu ausufernd und nicht alle Clients *sprechen* exakt das
gleiche Protokoll).

Es ist jedoch möglich über Plugins die Zugriffsrechte auf die *Collection* zu
steuern.  In `/etc/radicale/rights`_ ist eine Konfiguration zu sehen, bei der
dezidierte Lese-Berechtigungen vergeben werden. Die URL zu einem seiner Kalender
kann man über sein Login ermitteln.  Bei https://hostname/raidcale anmelden,
dort kann man die URLs bestehender Kalender sehen oder auch neue Kalender
anlegen.  Will man seinem Kollegen den Kalender bereit stellen, muss man ihm nur
diese URL geben, die er als *Abo* in seinen Kalender mit aufnimmt.


radicale.wsgi
=============

Seit commit `54b999 <https://github.com/Kozea/Radicale/commit/54b9995e2>`_ gibt
es den Schlüssel ``[logging]-->config`` nicht mehr::

  [logging]
  # config=/etc/radicale/logging  ... no longer exists

Um das Logging Setup aus `/etc/radicale/logging`_ dennoch zu aktivieren, muss
die Konfiguration (z.B. in der WSGI Datei) geladen werden:

.. code-block:: python

   #!/usr/bin/env python3
   """Radicale WSGI file (mod_wsgi and uWSGI compliant)."""

   import logging.config
   logging.config.fileConfig('/etc/radicale/logging', disable_existing_loggers=False)

   from radicale import application


Authentifizierung
=================

Die Authentifizierung wird in diesem Setup vom Apache übernommen.  In der
`/etc/radicale/config`_ wird dazu als Authentifizierung ``remote_user`` gewählt:

.. code-block:: cfg

   [auth]
   type = remote_user

Die Apache Konfiguration sieht dann in etwa wie folgt aus.  Hier im Beispiel
wird eine Basic-Authentifizierung mit :man:`pwauth` verwendet:

.. code-block:: apache

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

Der ``<user>`` ist der Benutzername des Logins (``pwauth``).  Benutzername und
Passwort ergeben sich aus den LDAP- und System Benutzern (posix)."


/etc/radicale/config
====================

In der exemplarischen Konfiguration unten wird für das Rechte Management das
Plugin ``from_file`` gesetzt, als Konfiguration wird die Datei
`/etc/radicale/rights`_ verwendet.  Damit ist ein detaillierteres
Rechte-Management möglich, wer das nicht braucht, sollte das Plugin
``owner_only`` für das Rechte-Management nutzen.

.. code-block:: cfg

   # -*- mode: conf -*-

   [server]

   # !!! We use WSGI behind apache, so nothing to configure here in the 'server'
   # !!! section

   [auth]

   # Authentication method
   # Value:       none | htpasswd | remote_user | http_x_remote_user
   # remote_user: plugin, that gets the login from the ``REMOTE_USER``
   #              environment variable (for WSGI server)
   type = remote_user

   [rights]

   # Rights backend
   # Value: none | authenticated | owner_only | owner_write | from_file
   type = from_file

   # File for rights management from_file
   file = /etc/radicale/rights

   [storage]

   # Storage backend
   type = multifilesystem

   # Folder for storing local collections, created if not present
   filesystem_folder = /var/www/pyApps/Radicale.data/collections

   [web]

   # Web interface backend
   type = internal

   [logging]

   # Threshold for the logger
   # Value: debug | info | warning | error | critical
   level = info


/etc/radicale/rights
====================

Der Pfad wird in der `/etc/radicale/config`_ gesetzt:

.. code-block:: cfg

   [rights]
   type = from_file
   file = /etc/radicale/rights


Unten ist ein exemplarisches Setup, bei dem dezidierte Lese-Berechtigungen
vergeben werden.  Die Vergabe der **W** und **R** Berechtigungen war
erforderlich um die interne WEB-Seite zum laufen zu bekommen (**master**
Branch).

.. code-block:: cfg

   # -*- mode: conf -*-

   # 1. The user "admin" can read and write any collection.
   [admin]
   user: admin
   collection: .*
   permissions: RWrw

   # 2. Example: dedicated sharing with 3 users
   [user001]
   user: user001
   collection: user002(/.*)?
   permissions: r

   [user002]
   user: user002
   collection: user001(/.*)?|user003(/.*)?
   permissions: r

   [user003]
   user: user003
   collection: user002(/.*)?
   permissions: r

   # 3. Authenticated users can read and write their own collections.
   [owner-write]
   user: .+
   collection: %(login)s(/.*)?
   permissions: RWrw

   # 4. Added 'R' to get WEB interface running
   [read]
   user: .+
   collection: .*
   permissions: R


/etc/radicale/logging
=====================

Das Logging entspricht dem `Configuration file format
<https://docs.python.org/library/logging.config.html#configuration-file-format>`_
des Python Logging.  Hier im Beispiel wird ein *Rotating-Log* in der Datei
``/var/log/radicale/radicale.log`` angelegt.

.. code-block:: cfg

   # -*- mode: conf -*-

   [loggers]
   keys = root

   [logger_root]
   handlers = file

   [handlers]
   keys = file

   [handler_file]
   class = logging.handlers.RotatingFileHandler
   args = ('/var/log/radicale/radicale.log', 'a', 100000, 10)
   formatter = full

   [formatters]
   keys = full

   [formatter_full]
   format = %(asctime)s - [%(thread)x] %(levelname)s: %(message)s


Alternativen
============

Baikal (http://sabre.io/baikal) ist ein ebenfalls oft genutzter Cal- und CardDAV
Server.  Er basiert auf 'sabre/dav' (http://sabre.io) was eine PHP
Implementierung des CardDAV, CalDAV und WebDAV ist (das wird auch von OwnCloud
genutzt).  Ich hatte Baikal auch schon mal vor vielen Jahren installiert, dann
wurde das aber zwischenzeitlich *kaputt-gebastelt*.  Die Arbeit an der Version 2
wurde wohl ganz eingestellt.  Das alles und der Umstand, dass es sich um eine
PHP Implementierung handelt, läßt mich von Baikal abstand nehmen.

Wer eine Groupware sucht, der sollte sich evtl. folgende Projekte anschauen.

* SOgo: https://sogo.nu

  Es gibt drei *main* Versionen SOgo2, Sogo3 und SOgo4.  Ab Version 3 gibt es
  ein WEB-Interface.  Alle Versionen nutzen die gleiche Implementierung der SOGo
  und SOPE Protokolle: LDAP, IMAP, SQL, CardDAV, CalDAV und Microsoft Enterprise
  ActiveSync.  Mit letzterem bietet SOgo ein Sync-Protokoll (Microsoft
  ActiveSync) an, dass auch vom Outlook *verstanden* wird (ich hab es aber noch
  nicht gestet).

* Cozy: https://cozy.io (https://github.com/cozy/cozy-stack )

  Das Cozy hat sich inzwischen stark weiter entwickelt, Erfahrungen hab ich damit
  noch keine, man könnte sich aber bei Gelegenheit mal die `Self-hosted Lösung
  <https://docs.cozy.io/en/tutorials/selfhost-debian/>`_ anschauen.
