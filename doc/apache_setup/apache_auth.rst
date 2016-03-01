.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_apache-auth:

================================================================================
                    Autorisierung zum Zugriff auf Resourcen
================================================================================

Der Zugriff auf Resourcen kann beim Apache-Server in vielfältiger Weise
gesteuert und durch Module ergänzt werden. Die grundlegensten Arten der
`Autorisierung (wiki)`_ sind:

* *welcher Remote-Host, darf auf was zugreifen*

  Autorisierung auf Basis der Herkunft einer Anfrage auf die
  Resource. Diese Steuerung wird vom `Apache mod_authz_host`_ Modul zur Verfügung
  gestellt.

* *welche Person / welches Login darf auf was zugreifen*

  Autorisierung auf Basis einer (zurvor erfolgten) `Authentifizierung
  (wiki)`_. Mittels der `Apache Require Direktive`_ kann der Zugriff auf eine
  Resource auf ausgewählte Benutzer und Gruppen geregelt werden.

Die *Herkunft* einer Anfrage wird auf Basis der IP-Adresse der Anfrage
festgestellt. Die (IP-) Adresse ist bereits bei der Anfrage im
Internet-Protokoll gegeben. Für die Authentifizierung ist immer eine Art von
Anmeldevorgang erforderlich (siehe `Authentication and Authorization`_).

Die Autorisierung gehört zu den *sicherheitsrelevantesten* Konfiguration eines
WEB-Servers, sie sollte einem unmissverständlichem und zukunftsfähigen Konzept
folgen.  Das Konzept in *diesem* hier vorgestellten Setup ist sehr einfach
gewählt und gründet auf der :ref:`xref_debian-apache`. Es werden (wieder) die
Grundsätze verfolgt:

* **alles dicht machen**

  Der Zugriff auf alle Resourcen wird für alle Logins und alle IP-Adressen
  gesperrt (wird in der :ref:`xref_conf_security` definiert).

* **expliziete Freigabe**

  Der kontrollierte Zugriff auf **eine** Resource wird in **einer** *Site*
  konfiguriert. Sites definieren

  - die Resource,
  - die Autorisierung und
  - die Art der ggf. erforderlichen Authentifizierung

  Jede *Site* hat eine eigene Konfigurationsdatei (s.a. ``available-sites`` und
  ``enabled-sites`` in :ref:`xref_debian_apache_config_tree`).

.. hint::

  **Authentifizierung** meint den Vorgang, bei dem beispielsweise eine *Person* bei
  der Anmeldung behauptet sie sei Benutzer (*Identität*) ``xyz``. Der Server
  **authentifiziert** die *Identität* des Benutzers nachdem der Benutzer das
  richtige Passwort angeben hat.

  **Autorisierung** klingt so ähnlich, meint aber was völlig Anderes. Autorisieren
  ist das *Einräumen* bestimmter Rechte. Dieses *Einräumen* von Rechten kann und
  wird oftmals auf Basis einer Authentifizierung erfolgen, muss es aber nicht,
  wie man am Beispiel der IP-Adressen basierten Autorisierung des Apache
  WEB-Servers sehen kann.
