.. -*- coding: utf-8; mode: rst -*-

.. include:: ../ffox_refs.txt
.. include:: ../searx_refs.txt

.. _Filterblase: https://de.wikipedia.org/wiki/Filterblase
.. _WEB-Tracking: https://de.wikipedia.org/wiki/Web_Analytics
.. _pi-hole: https://pi-hole.net/
.. _DNS: https://de.wikipedia.org/wiki/Domain_Name_System
.. _Domain: https://de.wikipedia.org/wiki/Domain_(Internet)


.. _search_engines:

========================
Suchmaschinen & Tracking
========================

.. sidebar:: Warnung -- Startpage

   Bisher wurde hier `Startpage` als "*die bessere google Suchmaschine!*"
   tituliert, inzwischen kann von der Verwendung nur abgeraten werden
   (s.u. Startpage_).  Alternativ empfiehlt es sich eine der :ref:`searX Engines
   <xref_searx>` zur Internetsuche zu verwenden z.B.: `searX@darmarIT`_

Für die ganz Ungeduldigen unter uns:

- Einleitung überspringen und hier starten mit: :ref:`do-not-track`.

- Zu viel Text, intressiert mich alles nicht, was muss ich in meinen FireFox
  installieren?

  1. `uBlock-origin`_ **!!must have!!**
  2. `Google search link fix`_ **!!must have!!**
  3. `Privacy Possum`_
  4. `CanvasBlocker`_
  5. `Decentraleyes`_

- und was kann ich auf dem Android Gerät machen? .. schau :ref:`hier
  <nogoogle_intro>`

Einleitung
==========

Der erste Schritt ins Internet beginnt i.d.R. mit einer Suchmaschine, dort gibt
man seinen Suchbegriff in ein Formular ein und klickt dann auf ein Ergebniss in
der Trefferliste. Oftmals wird das Formular schon durch die URL Leiste (oben) im
Browser ersetzt, das was man dort eintippt wird an die **voreingestellte**
Suchmaschine geschickt und dann wird gleich die Trefferliste angezeit.

Das ist soweit recht komfortabel, aber was macht eigentlich die voreingestellte
Suchmaschine? Der naive Nutzer wird davon ausgehen, dass alle Anwender die den
gleichen Begriff eingeben auch die gleiche Trefferliste erhalten, dem ist aber
nicht so, zumindest nicht solange man Suchmaschinen wie beispielsweise Google
(z.B. voreingestellt in Android, Chrome, Firefox und vielen Apple-Produkten)
oder Bing (voreingestellt in Microsoft Produkten wie dem Internet-Explorer oder
der Kachelansicht) und ähnliche nutzt.

Diese Suchmaschinen versuchen möglichst *gute* Trefferlisten für ihre Anwender
zusammenzustellen, doch was ist *gut*? Die Eigenschaft *gut* kann man durch
*personalisiert* ersetzen, was meint; in der Trefferliste werden solche oder
ähnliche Verweise bevorzugt, auf die der Nutzer der Suchmaschine schon mal
geklickt hat. Wenn man z.B. über mehrere Wochen auf Google zu einem Thema was
gesucht hat, dann weiß Google bei der nächsten Suche schon recht genau in
welcher thematischen Ecke *gute* Treffer zu finden sind kurz:

  *Das hat der Nutzer gestern gesucht und dann angelickt, dann wird es wohl
  heute ähnlich sein müssen.*

Prinzipell ist das ja erst mal nicht *schlecht* und evtl. genau das, was man
auch will. Doch was passiert eigentlich wenn man so was *dauerhaft* macht?  Die
personalisierte Trefferliste zu einer Suche bricht schon mal mit unserer ersten
Annahme, dass *alle* Nutzer die gleiche Trefferliste zum gleichen Begriff
erhalten.

Nimmt man beispielsweise gesellschaftlich relevante Themen (z.B. aktuelle Themen
aus der Politik) und möchte mehr über die pro und contra Standpunkte
recherchieren, so wird die angebotene Trefferliste nicht mehr neutral sein, da
sie sich an dem orientiert, was wir evtl. schon in der Verganheit mal angelickt
haben. Dabei ist der eigentlich Suchbegriff immer weniger relevant; wenn wir
z.B. in der Vergangenheit -- bei ganz anderen Fragestellungen -- bevorzugt in
das politisch linke oder rechte Lager gecklickt haben, so werden wir bei dieser
neuen Sucher bevorzugt Treffer erhalten, die in eben das gleiche Lager
verweisen. Diese auf Personalierung basierende und damt *eingeschränkte* bzw.
*gelenkte* Sicht auf Informationen wird i.d.R. auch als Filterblase_ bezeichnet.

Erste Voraussetzung für eine Personalisierug ist das Sammel von Bewegungsdaten
zu einem individuellem Nutzer, was auch als Tracking (WEB-Tracking_) bezeichnet
wird. Tracking beschränkt sich nicht auf die Suchmaschine, es gibt eine vielzahl
von Trackern die auch auf den WEB-Seiten installiert sind, die man besucht
(siehe :ref:`tracking`).

Wer profitiert davon .. wirklich nur der Nutzer? Analytics & WEB-Tracking sind
eine Wissenschaft für sich und ein stark umkämpfter Markt auf dem jeden Tag neue
*kreative* Lösungen gefunden werden. Herrscharen von Entwicklern und Forschern
werden seitens der werbenden Industrie engagiert um diese Verfahren weiter zu
optimieren. Das wir als Benutzer diesen *Zuschnitt* an Angeboten teilweise als
komfortabel empfinden ist eher ein Seiteneffekt um den Nutzer *bei der Stange zu
halten*.  Für den Nutzer selbst wird es immer schwerer hier zu unterscheiden,
welche Inhalte für ihn zugeschnitten wurden und welche Inhalte neutral sind. Der
*Zuschnitt* kann um so schärfer erfolgen, je mehr Informationen über den Nutzer
bekannt sind und jeder Like oder Klick auf Facebook & Co schärft das Profiel des
Nutzers weiter (s. z.B. `Der Facebook-Faktor
<http://gfx.sueddeutsche.de/apps/e502288/www/>`_).

.. _do-not-track:

Do-not-track
============

Als Benutzer von Smart-Phone, -TV, WEB-Browser & Co. wird man dem Tracking
niemals ganz entgehen können, man kann ihn aber auf verscheidenen Ebenen stark
einschränken und der Aufwand dafür ist nicht besonders groß.

Meist bieten die WEB-Browser eine Einstellung "Do not Track" oder ähnlich, das
ist aber nur ein sehr schwacher Schutz, da dieser "Schutz" passiv ist und auf
die Mitwirkung der besuchten WEB-Seiten vertraut. Bei Einigen Anbietern im Netz,
wie dem BSI und dem Online Zugang der Bank mag man darauf noch vertrauen können,
meist darf man aber davon ausgehen, das die Mitwirkung der WEB-Seiten Betreiber
eher schwach ist. Im Folgenden werden *härtere/aktive* Methoden zum Schutz
empfohlen.


Anonyme Suche
-------------

.. sidebar:: `Google search link fix`_

   Will man unbedingt über Google suchen, dann ist man zwar im Tracking, doch
   auch das kann man (etwas) einschränken, im Firefox z.B. mit dem AddOn:
   `Google search link fix`_.

Anonyme Suchmaschinen setzen kein Tracking ein.  Jedoch blenden sie zwecks
Finanzierung gekennzeichnete Werbung ein (s.a. :ref:`add_blocker`).  Die Nähe
solcher Unternehmen zur Werbebranche ist nicht immer unproblematisch.  Genau
genommen weiß man nicht, ob sich das Geschäftsmodel solcher Unternehemen im
Laufe der Jahre nicht doch irgendwann verschiebt.  Der aktuelle Fall von
Startpage (s.u.) zeigt wie sich die Geschäftsmodelle *still und leise ändern*
können.

.. admonition:: searX (aka goggle++)

   Ich empfehle die Verwendung einer :ref:`searX Engine <xref_searx>`, davon
   gibt es reichlich im Netz:

   - `searX@darmarIT`_
   - searX-Instances_


.. _Startpage:

Startpage.com ist dubios
~~~~~~~~~~~~~~~~~~~~~~~~

Inzwischen wurde das Unternehmen geschluckt und befindet sich jetzt in den
Händen von ... naja man weiß es nicht so genau.  Was man weiß steht in der
`Presseerklärung
<https://www.startpage.com/blog/company-updates/startpage-and-privacy-one-group/>`_:
*Privacy One Group Ltd and Startpage’s relationship started in January 2019*.
Die Presseerklärung kam allerdings erst im Oktober 2019.  Soviel zur Transparenz
von Startpage.  Privacy One Group Ltd `gehört zu System1 LLC
<https://support.startpage.com/index.php?/Knowledgebase/Article/View/1260/17/who-are-the-owners-of-startpage>`_:
*privacy-focused division that is a separate operating unit of System1 LLC*.
Weiteres kann man über diese Abteilung (das Unternehmen?) nicht in Erfahrung
bringen.  Fragt man sich also, wer ist der Eigentümer System1 LLC?  Ein Werbe-
und Marketinganbieter, der mit dem Auswerten und Verarbeiten von Daten Umsatz
generiert (s.a. `Kuketz
<https://www.kuketz-blog.de/ist-die-suchmaschine-startpage-noch-empfehlenswert/>`__).


.. _add_blocker:

Werbeblocker & Co. im WEB-Browser
---------------------------------

Gute Werbeblocker blockieren nicht nur die Werbung sondern gleich den ganzen
Tracking Kram und WEB-Seiten die als Virenschleuder bekannt sind. Das gelingt
nicht immer zu 100% aber annähernd. Empfehlenswert ist:

- `uBlock-origin`_
- `Privacy Possum`_
- `CanvasBlocker`_

Eine in den letzten Jahren modern gewordene Methode des Trackings besteht darin,
dass Anbieter wie z.B. Google oder Amazon oder .. den Betreibern von WEB-Seiten
gratis anbieten bestimmte Inhalte wie z.B. die Schriftsätze die in der WEB-Seite
verwendet werden zentral zu lagern. Für WEB-Seiten Betreiber hat das den
Vorteil, dass der Trafic auf der eigenen Leitung z.T. erheblich reduziert werden
kann. Das spart dem WEB-Seiten Betreiber Kosten hat für den Nutzer aber den
Nachteil, dass diese Inhalte nun immer bei Google & Co abgeholt werden müssen.
uBlock-origin blockiert das zum Teil, hier kann aber auch das folende AddOn
etwas mehr als uBlock:

- `Decentraleyes`_


DNS Blocker
===========

DNS_ ist quasi das *Telefonbuch* des Internets. Immer wenn man eine Domain_ wie
google.de aufrufen will, muss dieser Name der Domain_ (google.de) in eine IP
Adresse (sozusagen die Telefonnummer) der WEB-Seite aufgelöst werden. Ist das
nicht möglich, kann der Inhalt der Adresse nicht geladen werden.  DNS Blocker
machen sich das zu nutze, sie filtern Domain-Adressen von Trackern raus und
vermitteln dafür keine IP. Der Tracker läuft dann ins *leere* bzw. die Tracker
Software kann erst gar nicht geladen werden. Da Tracker i.d.R. nur an die
WEB-Seiten *geklebt* sind, schränkt das den Betrieb der WEB-Seite i.d.R. nicht
ein.

Für kleinere Heimnetze kann die pi-hole_ als DNS Blocker empfohlen werden, ein
DNS der im eigenen Netz läuft und anhand von regelmäßig aktualisierten
Filterlisten alles rausfiltert was Tracking oder Schadsoftware vermittelt. Dabei
ist es egal, ob Smart-TV oder Smart-Phone oder andere IoT Geräte ins Internet
gehen wollen. DNS Blocking funktioniert für alle Komponenten im eigenen Netz.

Wenn man mit dem Smart-Phone unterwegs ist kann das nicht funktionieren, weil
man dann ja nicht mehr im eigenen Netz ist, sondern über die SIM Karte oder ein
anderes WLAN ins Internet gelangt. Für Smart-Phones empfiehlt sich deshalb die
Installation des:

- `DNS66 <https://github.com/julian-klode/dns66>`_ (s.a. :ref:`nogoogle_intro`)

Der DNS Blocker blockiert Anfragen an Internet-Adressen die Werbung oder
Schadsoftware verbreiten. Dabei ist es egal ob diese Anfrage aus dem WEB-Browser
kommt oder versteckt in einer Anwendung (App) erfolgt. Das blockieren solcher
Adressen sollte die Grundlage eines jeden Sicherheitskonzepts sein und eignet
sich auch als erster *Kinderschutz*.

.. _tracking:

Tracking
========

Tracking ist nicht per se *böse*. Wenn man beispielsweise bei seiner Bank eine
Online Überweisung macht, dann ist das schon sehr wichtig, dass die WEB-Seite
der Bank weiß, wer da grad versucht eine Überweisung durchzuführen. Um nicht
jeden Klick mit einem Login-Passwort bestätigen zu müssen, meldet man sich
einmal an und die WEB-Seite setzt ein Cookie (oder eine andere technische
*Tracking-Lösung*) an dem sie erkennen kann, dass die Überweisung von dem
Anwender kommt, der sich grad zu diesem Konto eingelogt hat (vereinfacht
dargestellt). Wird die Sitzung geschlossen, so sollte die WEB-Seite den Cookie
vergessen (löschen), das ist es was wir erwarten und was bei Banken aus
Sicherheitsgründen auch noch ganz gut funktioniert.

Bewegt man sich im Internet, sei es aktiv in einem WEB-Browser oder weniger
aktiv in einer Anwendung (z.B. App aus dem Smart-Phone, -TV oder ..), die im
Hintergrund Daten mit dem Internet austauscht, so ist das meist nicht der
Fall. Insbesondere nicht, wenn man Inhalte und Anwendungen der großen Anbieter
nutzt. Diese setzen i.d.R. masiv Tracker ein, einer `Studie des Frauenhofer SIT
aus 2014
<https://www.sit.fraunhofer.de/de/track-your-tracker/worum-gehts/in-welchem-umfang-findet-web-tracking-statt/>`__
zu Folge werden nicht selten auf einer WEB-Seite bis zu 50 Tracker eingesetzt.

.. hint::

   Auf der verlinkten Seite des Frauenhofer SIT werden auch 'Schutzmaßnahmen'
   vorgeschlagen, diese sind veraltet und boten schon immer einen nur sehr
   eingeschränkten Tracking-Schutz.

In der Abbildung `Vernetzung besuchter Seiten und deren Tracker`_ sieht man eine
ca. 10 minütige Sitzung von mir, bei der ich wild diverse populäre Seiten nur
kurz angeklickt hab (wurde mit lightbeam_ erstellt). Die runden Punkte sind die
WEB-Seiten, die man eigentlich besucht hat und die dreieckigen Knoten sind
Tracker. Wenn mehrere WEB-Seiten Anbieter die gleichen Tracker verwenden, dann
weiß dieser Tracker was man auf welcher der Seiten besucht hat und wie man sich
dort im einzelnen bewegt hat. Die Graphik ist dabei nicht unbedingt vollständig,
da es zu aufwendig war alle Tracker-Schutzmaßnahmen in unserem Netzwerk
abzuschalten. Sie soll auch nur verdeutlichen, wie schnell (nach 10Min) so ein
Trackernetzwerk aufgebaut ist.

.. _xref-figure-search_engines-tracker_mash_up:

.. figure:: search_engines/tracker_mash_up.png
   :alt:     Figure (tracker_mash_up.png)
   :align:   center
   :class:   rst-figure

   _`Vernetzung besuchter Seiten und deren Tracker`

Um so mehr Tracker eine Seite verwendet, um so schneller und dichter wird das
Netz gespannt. Die Graphik des lightbeam_ ist zwar ganz nett, aber um einen
ersten Eindruck von einer WEB-Seite zu bekommen kann man die Domain_ auch kurz
hier eintippen.

- https://webbkoll.dataskydd.net

Man erschrickt doch manchmal, wie schlecht teilweise WEB-Seiten gemacht sind,
hier z.B. die Auswertung der WEB-Seite der Computer-Zeitschrift CHIP:

- https://webbkoll.dataskydd.net/en/results?url=http%3A%2F%2Fchip.de%2F

Doch es geht noch schlimmer, andere schlechte Beispiele sind `auto.de
<https://webbkoll.dataskydd.net/en/results?url=http%3A%2F%2Fauto.de%2F>`_ oder
`autobild.de
<https://webbkoll.dataskydd.net/en/results?url=http%3A%2F%2Fwww.autobild.de%2F>`_.

Ist das noch seriös? .. die Frage mag sich jeder selber beantworten: Stecken Sie
mal die Adressen Ihrer Bank (müsste immer OK sein) und ihrer Lieblingsseite da
rein um sich enen eigenen Eindruck zu verschaffen.
