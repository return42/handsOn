.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_debian-apache:

================================================================================
                     Debian's default Apache2 Installation
================================================================================

Eine detallierte Beschreibung der Apache2 Konfigration unter Debian (Ubuntu)
findet sich in der Datei `/usr/share/doc/apache2/README.Debian.gz`_. Sie besteht
aus einer Ordnerstruktur im Ordner ``/etc/apache2/`` und ein paar Tools.

Die WEB-Anwendungen eines HTTP-Servers sind in **Sites** aufgeteilt, die bei
Bedarf aktiviert (*enabled* :man:`a2ensite`) oder auch deaktiviert (*disabled*
:man:`a2dissite`) werden können.  In gleicher Weise werden auch die **Module**
des Apache Servers aktiviert (:man:`a2enmod`) oder deaktiviert
(:man:`a2dismod`). Neben Sites und Modulen gibt es noch **Konfigurationen**, die
sich nicht auf eine Site oder ein Modul beziehen müssen. Meist handelt es sich
dabei um Konfigurationen die ein Konzept umsetzen, z.B. bestimmte
Sicherheitsaspekte, spezielle Logging- oder Statistik- Konzepte. Diese
Konfigurationen können ebenfalls aktiviert (:man:`a2enconf`) oder deaktiviert
(:man:`a2disconf`) werden.

In der Debian Infrastruktur sind für die Ablage dieser Konfigurationen, Module
und Sites die folgenden Ordner vorgesehen.

* ``conf-available``
* ``mods-available``
* ``sites-available``

Zu den Ordner gibt es noch die passenden ``*-enabled`` Ordner. Wird eine
Konfiguration, ein Modul oder eine Site *enabled*, dann wird in dem zugehörigen
``*-enabled`` Ordner ein entsprechender symbolischer Link auf die Konfiguration
angegelgt.

Mit den genannten Toos und der unten gezeigten Ordnerstruktur kann man einen
Apache-WEB-Server sehr gut managen. Dieser *Debian way of (Apache) live*
unterscheidet sich von einer standard Apache Installation (die nicht diese Tools
bereit stellt). In der Debian Installation gibt es deshalb noch einen Wrapper
für das ``apache2`` Binary, das ist das Kommando:

* :man:`apache2ctl`:  Apache HTTP server control interface

Hierbei handelt es sich um einen Wrapper, der sich eignet um den Server zu
administrieren, der aber auch als Ersatz für das :man:`apache2` Kommando
dient. Bei Letzterem zieht der Wrapper einige Informationen aus der Debian
Infrastruktur/Konfiguration, setzt die Umgebung entsprechend und ruft dann das
Kommando ``apache2`` auf, wobei die Argumente 1:1 durchgereicht werden. Für eine
vollständige Beschreibung des Wrappers :man:`apache2ctl` muss das Manual zum
:man:`apache2` Kommando konsultiert werdenxs.

.. _xref_debian_apache_config_tree:

Ordnerstruktur der Debian Apache Installation
=============================================

In der unten stehenden Abbildung der Ordnerstruktur sind die symbolischen Links
vom ``*-enabled`` Ordner zum ``*-available`` Ordner angedeutet
(``{name}.conf``). Beispiel ist der symbolische Link der ``default-ssl.conf``
Site ``sites-enabled/default-ssl.conf -> ../sites-available/default-ssl.conf``.

::

   /etc/apache2/
      │
      ├── apache2.conf             # Main Config für serverweite Einstellungen
      │
      ├── conf-available           # zusätzliche verfügbare Konfigurationen
      │   │
      │   ├── security.conf        # Konfiguration zur Absicherung des WEB-Servers
      │   └── {name}.conf
      │
      ├── conf-enabled             # aktivierte zusätzliche Konfiguration
      │   │                        # Links auf die Dateien im Ordner ../conf-available/
      │   ├── security.conf -----> ../conf-available/security.conf
      │   └── {name}.conf -------> ../conf-available/{name}.conf
      │
      ├── envvars                  # Umgebungsvariablen wie 'group' und 'user'
      │                            # des Serverprozess
      ├── magic                    # magic(5) Pattern
      │
      ├── mods-available           # verfügbare Module mit ihren Basiskonfigurationen
      │   │
      │   ├── *.load
      │   └── {name}.conf
      │
      ├── mods-enabled             # Aktivierte Module
      │   │                        # Links auf die Dateien im Ordner ../mods-available/
      │   ├── *.load ------------> ../mods-available/*.load
      │   └── {name}.conf -------> ../mods-available/{name}.conf
      │
      ├── ports.conf               # Ports und IPs auf die der Server *lauscht*
      │
      ├── sites-available          # verfügbare *Sites*
      │   ├── default-ssl.conf
      │   └── {name}.conf
      │
      └── sites-enabled            # aktivierte *Sites*
          │                        # Links auf Dateien im Ordner ../sites-available
          ├── default-ssl.conf --> ../sites-available/default-ssl.conf
          └── {name}.conf -------> ../sites-available/{name}.conf

