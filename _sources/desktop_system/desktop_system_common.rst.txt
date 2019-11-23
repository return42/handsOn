.. -*- coding: utf-8; mode: rst -*-

.. include:: ../desktop_system_refs.txt
.. include:: ../get_started_refs.txt

.. _xref_desktop_system_common:

================================================================================
                       Allgemeines zu Desktop Umgebungen
================================================================================

Die Desktop-Umgebung eines Linux Systems besteht i.d.R. aus zwei Komponenten,
zum einen der Anmeldebildschirm (**Display-Manager**) in dem das Login der
Anwender erfolgt und zum anderen der Desktop (**Window-Manager**) des Anwenders
nach der Anmeldung. Während der `X Display Manager (wiki)`_ -- der
Anmeldebildschirm -- für alle Logins der selbe ist, können die Anwender sich für
einen von ihnen favorisierten `Window Manager (wiki)`_ entscheiden. Die Wahl des
Window-Manager erfolgt durch den Anwender bei der Anmeldung und ist nur durch
die Anzahl der auf dem System installierten Window-Manager begrenzt, es gibt
keine Abhängigkeit zum Display-Manager.

Die `GNOME Shell`_ ist seit Ubuntu 17.10 wieder Standard-Desktop. Dem Voran ging
ein langer Irrweg, hier ein paar Worte und Überlegungen aus der Historie:

  Die Ubuntu Distribution hatte in der Vergangenheit im Standard den
  Window-Manager `Unity (wiki)`_ mit und als Display-Manager wurde `LightDM
  (wiki)`_ eingesetzt.  Die Wahl des Standard-Desktop bei Ubuntu war heiß
  umstritten, einen Rückblick gibt der Blog `Fünf Jahre später: Unity vs. Gnome
  Shell revisited`_ von Dirk Schmidtke. In dem Blog ist auch zu lesen, dass die
  Entwicklung von `Unity`_ eher etwas eingeschlafen ist. Auch die, in dem Blog
  erwähnten Mankos des Unity empfinde ich ähnlich. Ähnlich wie der Blog komme
  ich auch zu der Überzeugung, dass Unity nur was für Benutzer ist, die schon
  immer mit Unity arbeiten. Neue Linux Anwender oder Anwender die ihren
  Window-Manager wechseln möchten werden keinen wirklichen Grund finden, sich
  zugunsten Unity zu entscheiden.

  `Unity`_ gehört zu den modernen Bedienoberflächen, die auf 3D Animierung
  basieren und zum Ziel haben, die Desktop- mit der Tablet- Bedienung zu
  vereinheitlichen. Ob es gelingen wird, die Bedienung von Desktop und Tablet
  vollkommen zu harmonisieren, kann angezweifelt werden. Der Umgang mit Maus &
  Tastatur (im Sitzen vor einem Schreibtisch) auf der einen Seite und der Umgang
  mit einem Touch-Device (auf dem Sofa liegend und wischend) auf der anderen
  Seite ist *von der haptischen Erfahrung her* einfach schon zu unterschiedlich.

  Das die Bedienung nicht so einfach zu harmonisieren ist, wird von einigen
  Anwendern auch so empfunden. Nicht jeder freundet sich gleich mit jeder neuen
  Desktop-Umgebung und ihrer geänderten Benutzerführung an. Dementsprechend
  haben die neuen Bedienkonzepte auch sehr viel Kritik erfahren müssen. Auch wenn
  man -- wie ich -- der Vereinheitlichung von Desktop und Tablet kritisch
  gegenübersteht, so muss man doch auch anerkennen, dass das Bestreben den Content
  von der Präsentationsschicht besser zu abstrahieren richtig und erforderlich
  ist.

Das Projekt `freedesktop.org`_ versucht die Basis für einheitliche Desktop
Umgebungen zu legen, ist dabei aber auch nicht ganz unumstritten. Die Umstellung
von `devfs (wiki)`_ auf `udev (wiki)`_ und dann der Merge des udev nach `systemd
(wiki)`_ hinterlassen bei einigen Benutzern auch Zweifel. Ich kann es in der
Tiefe nicht beurteilen, aber die "Nähe" von der Desktop-Umgebung zum Init-System
(systemd) fühlt sich für mich nicht gut an. Hierin liegt vermutlich auch ein
Hauptkritikpunkt an systemd, dass es sich nicht auf den Init-Prozess beschränkt
sondern alle Funktionen, die irgendwie mal in einem Init-Prozess erforderlich
sein könnten in sich vereinen will.

Ob ein Funktions-Modul besser im Kernel oder im systemd aufgehoben ist, sollte
eine Designfrage sein und mein Eindruck ist, dass systemd auf die Designfragen
zu schnell die immer gleichen Antworten findet (*"forken/mergen" oder "nochmal
neu und irgendwie besser machen"*). Irgendwie auch nachvollziehbar: die Sourcen
in seinem Projekt zu hosten ist aus Entwickler-Sicht manchmal einfacher als
gegen eine versionierte Abstraktion zu implementieren.

  Was mich stört ist schon der Umstand, dass ich anfange über ein Init-System zu
  schreiben, obwohl es hier eigentlich um Desktop-Umgebungen geht.  Evtl. liegt es
  ja auch einfach nur an mir ... Vorangegangene Kritik entspringt meinem
  Eindruck, der sicherlich sehr subjektiv und eingeschränkt ist ;-)

Läßt man sich erst mal auf eine der moderneren Desktop-Umgebungen ein, so wird
man schon nach kurzer Zeit feststellen, dass man sich an die geänderte
Benutzerführung gewöhnt hat und auch schneller auf dem Desktop unterwegs
ist. Die 3D Unterstützung, welche diese Desktops mehr oder weniger benötigen ist
jedoch nicht für jedes Szenario geeignet. Auf einem entfernten Server möchte man
evtl. auch einen (Remote-) Desktop haben, der sich besser durch `Teamviewer`_
oder `VNC (wiki)`_ *tunneln* lässt.

.. hint::

   Die *Remote* Szenarien können auch mit einfachen Mitteln wie ``ssh -X``
   bedient werden, es braucht hierfür kein *Remote-Display* im Sinne von
   `Teamviewer`_ oder `VNC (wiki)`_. Spätestens bei echten *Display-Sharing*
   Anwendungen, wie z.B. bei der Remote-Unterstützung der Anwender an ihrem
   Bildschirm, wird man aber wieder auf `Teamviewer`_, `VNC (wiki)`_ und Co.
   zurückgreifen wollen.

Im Ubuntu/Debian Derivat tummeln sich viele Distributionen, die auf andere
Desktop-Umgebungen zurückgreifen. Zwei Beispiele sind:

* `LinuxMint`_ nutzt den `Cinnamon`_ Desktop-Umgebung
* `Xubuntu (wiki)`_ nutz den schlanken Fenstermanager `Xfce`_.

Jedoch ist es nicht erforderlich die Distribution zu wechseln, wenn man eine
dieser Desktop-Umgebungen nutzen möchte. Da sich alle Distributionen *mehr oder
minder* aus den gleichen oder ähnlich aufgebauten Repositorien bedienen, können
die Desktops in jeder Distribution *mehr oder minder* beliebig ausgetauscht
werden.

Als optisch schlicht, aber dennoch komfortabler und erweiterbare 3D Desktop
Umgebung empfiehlt sich die Kombination von :ref:`xref_gnome_shell`. Für
schlankere Systeme und Szenarien ohne 3D Beschleunigung empfiehlt sich die
Kombination von `LightDM (ubuntu)`_ und dem 2D :ref:`xref_cinnamon`. Sowohl die
GNOME Shell, als auch der Cinnamon-Desktop sind sehr gut mit der Maus, aber auch
nur über Tastatur bedienbar.
