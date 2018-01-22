.. -*- coding: utf-8; mode: rst -*-

.. include:: ../android_refs.txt
.. include:: ../ffox_refs.txt

.. _nogoogle_intro:
             
===========================
Ein Leben ohne Google Konto
===========================

Android ohne Google Konto, geht das überhaupt? .. Ja.

Das geht sogar ganz gut, zumindest wenn man sich nicht (wie ich damals am
Anfang) jeden *Scheiß* installieren will, wenn man sich auf den Kram beschränkt,
der einem wirklich hilft und nicht nur für weitere Ablenkung sorgt.  Wer
allerdings Cloud- oder andere Dienste von Google nutzen muss oder will, der wird
es schwer haben der Umklammerung von Google zu entgehen.


App Store Alternativen
======================

Um sich Apps zu installieren benötigt man kein Google Account. Alternativen zum
*Google-Play-Store* sind z.B.:

- F-Droid_ / Tipp: Einstellungen -- weitere Paketquellen aktivieren
- `Yalp Store`_ / Tipp: Einstellungen -- Täusche ein anderes Gerät vor

Ich installiere mir immer als erstes F-Droid_ und beziehe die Apps in erster
Linie darüber. Über F-Droid_ kann man sich den `Yalp Store`_
installieren. Sollte man eine App bei F-Droid_ vermissen, dann bekommt man sie
in jedem Fall über den `Yalp Store`_. Der `Yalp Store`_ ist eine App mit der man
Apps aus dem Google-Play-Store installieren kann, ohne das man dazu einen
Google-Account braucht (es nutzt einen Fake-Account).


Paketmanager vs. APK
====================

Play-Store, F-Droid_, `Yalp Store`_ und wie sie alle heißen sind Paketmanager.
Die Aufgabe der Paketmanager ist es zum Einem die Pakete (Apps) aus einem
*Reposetorie* zu installieren und zum Anderem zu aktualisieren (regelmäßig die
Updates einspielen). Das wohl größte *Reposetorie* bietet der Play-Store von
Google und meist sind dort auch immer die aktuelleren Versionen verfügbar als
bei den anderen Anbietern. Es gibt aber auch immer mehr App Entwickler --
insbesondere im OpenSource Bereich -- die keinen Bog mehr auf den
Google-Play-Store und die Umklammerung von Google haben und deshalb auf F-Droid
wechseln. Deshalb kann auch nicht mehr pauschal gesagt werden kann, dass alle
Apps im Play-Store zu bekommen sind.  Teilweise ist es auch so, dass bei solchen
Apps alte Versionen im Play-Store noch rumfliegen (momentan noch eher seltener
der Fall).

Die Aktualisierung der Apps ist in der Regel eine wertvolle Funktion der
Paketmanager, aber manchmal will/braucht man auch nicht jede Aktualiserung einer
App mit der nur wieder mehr Bloatware installiert wird. Kann (oder will) man bei
einer App auf automatiserte Aktualiserungen verzichten, dann kann man sich die
APK_ Pakete (da ist die App drin) direkt installieren.

Ich mache das beispielsweise so mit der Fahrplan App der (lokalen) öffentlichen
Verkehrsbetriebe. Deren App ist (noch) nicht auf F-Droid verfügbar und Updates
gibt es dafür eh nur alle Schaltjahre. Für solche Apps lade ich mir das APK_
direkt runter und installiere es dann:

- `VBN im Playstore <https://play.google.com/store/apps/details?id=de.hafas.android.vbn>`__ und
- `VBN APK über apkpure.com <https://apkpure.com/fahrplaner/de.hafas.android.vbn>`__

Bevor ich so ein APK_ installiere lade ich es erst nochmal zu `virustotal
<https://www.virustotal.com>`_ um es auf Schadsoftware zu prüfen, hier mal das
Ergebnis für die VBN App die von apkpure.com runter geladen wurde:

- https://www.virustotal.com/#/file/ce2504cb7370772272a8084ed755f09f57354ec0cc125a7d7be693afbac81c4c/detection

Eine Prüfung auf Schadsoftware sollte immer erfolgen wenn:

- Man die App oder den Hersteller der App (noch) nicht kennt.
- Der Download von einer Seite erfolgt, bei der man auch nur den kleinsten
  Zweifel hat.

Für apkpure_ und viele andere *Reposetories* gibt es Paketmanager (so wie
beispielsweise das F-Droid), generell würde ich aber empfehlen nicht jeden
Paketmanager einfach zu installieren. Auch hier gibt es schwarze Schafe die in
die APKs Schadsoftware mit rein packen. Ich selber nutze als Paketmanager nur
F-Droid_ und wenn erforderlich den `Yalp Store`_. Bei den beiden ist es aus
*verfahrenstechnischen-Gründen* schon schwerer Schadsoftware unterzubringen.
Grundsätzlich kann aber kein Anbieter -- auch bei den besten Absichten -- zu
100% sicherstellen, dass sich keine Schadsoftware in Apps versteckt oder durch
Hackerangriffe eingeschläußt wird. Auch im Play-Store gibt es immer mal wieder
Schadsoftware (`siehe heise Artikel
<https://www.heise.de/security/meldung/Android-Spyware-drei-Jahre-lang-im-Play-Store-unentdeckt-3691154.html>`__).

- apkpure_
- `APK Mirror`_
- `APK Downloader`_

Software Empfehlungen
=====================

Sofern nicht anders angegeben können die Apps über F-Droid_ bezogen werden.
Evtl. fällt auf, dass in der unten stehenden Liste meist OpenSource Software
bevorzugt wird. OpenSource Software ist nicht `pauschal sicherer
<https://www.heise.de/tipps-tricks/Ist-Open-Source-Software-wirklich-sicherer-3929357.html>`__
als ClosedSource.  Doch es spricht (aus 30 Jahren Erfahrung) vieles dafür, dass
gut gepflegte OpenSource Projekte sicherer und weitaus flexiebler sind als
ClosedSource vom Microsoft, Apple und anderen Software-Häusern.  Sie wissen
nicht ob sie wirklich OpenSource wollen? ... Sie haben es schon lange, ein
Beispiel ist Android selbst, es basiert auf dem Linux Kernel welcher OpenSource
ist. Ein anderes bekanntes Beispiel ist der Internet-Browser FireFox.

- `DNS66 <https://github.com/julian-klode/dns66>`_ / (`F-Droid
  <https://f-droid.org/packages/org.jak_linux.dns66>`__) **!!must have!!**

  DNS basierter Add-Blocker, bei dem man auch seinen eigenen DNS (z.B. pi-hole_)
  eintragen kann. Ein DNS Blocker blockiert Anfragen an Internet-Adressen die
  Werbung oder Schadsoftware verbreiten. Dabei ist es egal ob diese Anfrage aus
  dem WEB-Browser kommt oder versteckt in einer Anwendung erfolgt. Das
  blockieren solcher Adressen sollte die Grundlage eines jeden
  Sicherheitskonzpts sein und eignet sich auch als erster *Kinderschutz*.

- `AFWall+ (Android Firewall +) <https://github.com/ukanth/afwall>`_ / (`F-Droid
  <https://f-droid.org/en/packages/dev.ukanth.ufirewall>`__)

  Eine Internet-Firewall mit der man für jede App separat steuern kann, ob diese
  überhaupt einen Zugriff auf das Internet haben darf. Eignet sich hervoragend
  um Apps (z.B. typische offline Spiele) die eigentlich kein Internet brauchen,
  daran zu hindern ins Internet zu gelangen. Ich benutze es auch um Google-Apps
  (sync etc.) den Internet Zugang zu verwehren (sofern ich die Google-App nicht
  ganz deinstalieren kann).

- `Fennec F-Droid <https://f-droid.org/packages/org.mozilla.fennec_fdroid/>`__

  Eine Variante des FireFox für mobile Geräte. Es gibt auch noch andere
  Varianten, diese hier gefällt mir, weil sie auf ganz viel Schrott verzichtet,
  der i.A. mit in den FireFox einkompiliert wird. Auch die Grundeinstellungen
  zur Sicherheit und Privatsphäre sind hier für mein Empfinden wesentlich
  vernüftiger (endlich mal eine Browser der in den Grundeinstellung keine
  Cookies von Drittanbietern aktzeptiert).

  Folgende Add-ons empfehlen sich zur Wahrung der Privatsphäre und zum Schutz
  vor Schadsoftware (s.a. :ref:`search_engines`):

  1. `uBlock-origin`_ **!!must have!!**
  2. `Google search link fix`_ **!!must have!!**
  3. `CanvasBlocker`_
  4. `Decentraleyes`_

- `K-9 Mail Client <https://k9mail.github.io/>`_ / (`F-Droid
  <https://f-droid.org/en/packages/com.fsck.k9>`__)

  Ein Mail-Client ohne Spyware. Die vorinstallierten Mail-Clients auf den
  Android Geräten sind recht schlicht und u.U. nicht frei von Spyware oder an
  einen Mail-Hoster (wie gmail) gebunden. Gleiches gilt für die Bloatware von
  GMX, WEB.de und anderen Mail-Hostern auch deren Mail-Apps sind nicht
  *frei*. Es gibt auch noch andere *freie* Mail-Clients, K9 scheint mir aber der
  bessere zu sein.
  
- `DAVdroid <https://davdroid.bitfire.at/>`_ / (`F-Droid
  <https://f-droid.org/packages/at.bitfire.davdroid>`__)

  DAVdroid ist eine App um CalDAV/CardDAV (Kalender & Kontakte) mit einem
  DAV-Server zu synchronisieren (s.a. :ref:`xref_radicale_index`).

- `Flym Newsreader <https://github.com/FredJul/Flym>`_ / (`F-Droid
  <https://f-droid.org/packages/net.fred.feedex>`__)

  Ein - wie ich finde - hervoragender Newsreader, mit dem sich die Installation
  diverser News-Apps (Tagesschau-App oder wie auch immer) sicherlich erübrigt.

  - heise-news: https://www.heise.de/newsticker/heise-atom.xml
  - Spiegel: http://www.spiegel.de/schlagzeilen/tops/index.rss
  - taz: http://www.taz.de/!p4608;rss/
  - buten un binnen: https://www.butenunbinnen.de/feed/rss/neuste-inhalte100.xml
  
- `OsmAnd <http://osmand.net/>`_ / (`F-Droid
  <https://f-droid.org/en/packages/net.osmand.plus>`__)

  Eine gelungene App für Landkarten und Navigation. Die Karten kommen aus dem
  OpenStreetMap Projekt. Endlich mal Navigation ohne das man von Google, TomTom
  oder sonst wem verfolgt wird. Das Kartenmaterial ist frei zugänglich und kann
  in verschiedensten Detaildichten auf dem Android gespeichert werden. Eigenet
  sich neben der Auto-Navigation auch recht gut für Rad- & Wander-Touren. UND,
  kaum zu glauben: alles offline möglich! / Danke OpenStreetMap!

- `zapp <https://github.com/cemrich/zapp>`_ / (`F-Droid
  <https://f-droid.org/en/packages/de.christinecoenen.code.zapp>`__)

  Live-TV der deutschen öffentlich-rechtlichen Fernsehsender, einfach zu
  bedienen und schön übersichtlich.

Wofür ich grad selber noch Alternativen suche:  

- `VLC Audio & Video player <http://www.videolan.org/>`_
- `Sky Map <http://sky-map-team.github.io/stardroid/>`_
- `RealCalc Scientific Calculator <http://www.quartic-software.co.uk/>`_
- `CAdroid <http://cadroid.bitfire.at/>`_

