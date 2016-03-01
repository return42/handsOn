.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_setup_properties:

================================================================================
                              Merkmale des Setups
================================================================================

Das hier vorgestellte Vorgehen zum Setup eines Apache Servers versucht möglichst
*einfache und griffige* Konzepte umzusetzen. Ganz allgemein könnte man das
Konzept mit folgenden Worten charakterisieren.

* **opt-in wird präferiert**

  Deaktivierung aller *opt-out* Settings die eine Distribution mit sich bringt.
  Es sei denn, es bestehen gute Gründe, wie z.B. Apsekte der Sicherheit, diese
  Optionen -- wie vom Distributor vorgesehen -- beizubehalten.

* **alles dicht machen**

  Der Zugriff auf alle Resourcen wird im *default* erst mal verwehrt

* **expliziete Freigabe**

  Jede Resource, die über den WEB-Server freigegeben werden soll, muss in einer
  eigenen Konfiguration (*Stite*) expliziet freigegeben werden.

Es wird ein möglichst einfaches Vorgehen gewählt, das -- sofern möglich und
angebracht -- die (deb) Pakete aus dem Paketmanger (apt) bezieht.

  Diese Pakete sind nicht immer ganz aktuell und beinhalten u.U. noch *Exploits*
  die bereits bekannt und auch behoben sind. Für einen Server im Internet
  sollten ggf. die original Sourcen verwendet werden, die *tagesaktuell* sind.


Benutzerauthentifizierung
=========================

Die Authentifizierung der WEB-Anwendungen erfolgt -- insofern erforderlich --
über `PAM (wiki)`_ (siehe :ref:`xref_mod_authnz_external`). Nicht Teil dieses
Apache-Setups ist beispielsweise ein `NSS PAM LDAP`_ mit das PAM gegen einen
LDAP Server gebunden werden kann.

  Die Authentifizierung über die Benutzerkonten des OS eignet sich nicht für
  Server die im Internet betrieben werden. Jedoch reicht es um die Aspekte der
  Authentifizierung in einem Apache-Setup exemplarisch zu verdeutlich.


Entwicklertools & Dokumentationen
=================================

Es werden Dokumentation und Werkzeuge wie z.B die Apache Dokumentation oder die
*build-Tools* eingerichtet. Das Setup verletzt damit seine eigene Charactere
leicht und installiert tendenziell mehr Komponenten (zur Wartung/Entwicklung)
als sie erforderlich wären, um den Server im Internet zu betreiben.


Datenbanken
===========

Web-Anwendungen die eine Datenbank (DB) benötigen aber nur von einem kleineren
Nutzerkreis genutzt werden, sollten mit einer `SQLite`_ DB ausreichend
ausgestattet sein. Hier im Setup werden -- sofern es die Anwendung zulässt --
SQLite Datenbanken eingerichtet.

  Für Entwicklerzwecke empfiehlt sich Installation passender (GUI-) DB-Clients.

Weiterführende Hinweise
=======================

Das zu diesem Setup gehörende Skript ``apache_setup.sh`` installiert die
Setup-Dateien aus dem ``TEMPLATE``-Ordner. In den Setup-Dateien aus diesem
Ordner finden sich noch Anmerkungen, die über die Grundlagen -- welche hier im
*handsOn* Erwähnung finden -- hinausgehen.  Auch die Debian/Ubuntu Pakete
installieren bereits Setup-Dateien, die für den Betrieb relevant sind. Auch
darin finden sich viele wertvolle Anmerkungen (*einfach mal alles unter*
``/etc/apache`` *anschauen und ggf. anpassen*).

