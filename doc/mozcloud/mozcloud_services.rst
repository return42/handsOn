.. -*- coding: utf-8; mode: rst -*-

.. include:: ../mozcloud_refs.txt

.. _xref_mozcloud_services:

================================================================================
                            Mozilla Cloud Services
================================================================================

Die Mozilla-Cloud Dienste sind eine skallierbare Infrastruktur interoperabler
Dienste, die den eigenen Bedürfnissen entsprechend im (eigenem) Netz aufgebaut
werden können. Eine Übersicht der Dienste findet man in dem Artikel "`Mozilla
Services Documentation`_". Die Sourcen und ein Wiki zu den Cloud-Services stellt
Mozilla ebenfalls bereit (`Mozilla Cloud Wiki`_). Die Links zu den Sourcen und
weiteren Dokumentationen sind in den ":ref:`Verweisen <xref_mozcloud_refs>`" am
Ende des Artikels zu finden.

Will man sich z.B. einen Firefox Sync-1.5 Server im eigenen Netz aufbauen, so
hängt es von einem selber ab, welche Komponenten der Mozilla-Cloud man in seinem
Netz installieren will und in wie weit man auf die Komponenten zurückgreift, die
Mozilla im Internet bereits betreibt. Der Firefox Sync-1.5 Server ist eine
Komponente dieser Infrastruktur. Es ist die Komponente, die Voraussetzung ist um
die zu synchronisierenden Daten im Kontext des Nutzers zu *speichern* und zu
synchronisieren.

* `Run your own Firefox Sync-1.5 Server (github)`_

Der Kontext des Nutzers und alles was da mit dran hängt, also Beispielsweise die
Authentifizierung des Nutzers sind nicht Teil des Firefox Sync-1.5 Servers. Will
man einen eigenen Firefox Sync-1.5 Server betreiben, so kann man diesen in der
einfachsten Ausbaustufe mit dem öffentlichen Account Server von Mozilla
betreiben.

* `Mozilla (public) Account Server`_

Diese Art der Authentifizierung und Benutzerverwaltung ist im allgemeinen auch
recht unkritisch, da zwischen den Komponent Firefox-Browser, Firefox Sync-1.5
Server und dem öffentlichen Account Server für die Authentifizierung im Grunde
nicht mehr als Hash-Values ausgetauscht werden. So werden beispielsweise keine
*klartext* Passwörter ausgetauscht. Eine Eigenschaft einer solchen Infrastruktur
ist aber, dass ein Zugang über das Internet zum öffentlichen Account Server von
Mozilla zur Verfügung stehen muss, auf den allen Komponenten der Infrastruktur
Zugriff haben müssen.

Sowohl der *eigene* Firefox Sync-1.5 Server, als auch die Firefox WEB-Browser
greifen auf den Account Server zu und hinterlassen entsprechende Spuren im
Internet und auf den Servern der öffentlichen Mozilla Cloud.  Will man einen
komplett *isolierten* Sync-Dienst zur Verfügung stellen, so muss man noch einen
*eigenen* Account Server in seiner Infrastruktur einrichten.

* `Run your own Account Server`_

Für die Authentifizierung wird das OAuth2 Protokoll verwendet. Das `OAuth
(wiki)`_ Protokoll wird von allen *großen* Dienstleistern im Internet genutzt,
nachzulesen in dem Artikel `OAuth Provider (wiki)`_. Das `OAuth (wiki)`_
Protokoll ist aber auch nicht ganz unumstritten, da es recht komplex und
(deshalb) oftmals schlecht implementiert ist.

* `Flexible und sichere Internetdienste mit OAuth 2.0 (heise)`_
* `Autorisierungsdienste mit OAuth (heise)`_
* `FxA Inter-Service Authentication and Delegation`_
* `Identity/Firefox Accounts`_


