.. -*- coding: utf-8; mode: rst -*-

.. include:: get_started_refs.txt

===================
Motivation & Umfeld
===================

Die Motivation zu den *handsOn* Projekt sind meine z.T. doch recht leidlichen
Erfahrung beim Setup von Systemen.  Die Software, die für Linux bereit steht ist
eigentlich weniger das Problem, ganz im Gegenteil.  Insbesondere die zur
Verfügung stehenden Dienste sind i.d.R. sehr robust und orientieren sich an
Standards.  Jedoch bedarf es meist einigen Know-hows diese zu konfigurieren und
zu orchestrieren.  Die Dokumentation, die man dazu im Internet findet ist nicht
immer hilfreich.  Meist findet man veraltete Dokumente die ohne tiefere Kenntnis
nicht gleich als solche zu erkennen sind.  Ein weiteres Problem sind oft auch
die Distributionen selbst. Zum Teil werden mit Ubuntu, debian & Co. Pakete
ausgeliefert, die hoffnungslos veraltet sind.

Doch das darf keine Anklage der Paket Manager sein, die zw. den Aspekten einer
LTS und der Aktualität der Softwarepakete Entscheidungen treffen müssen.
Weiteres Problem der Paket-Manager ist es, dass sich die Methoden der
Softwareentwicklung und Verteilung in den letzten Jahren fundamental verändert
haben.  Umgebungen wie Python, Ruby, Node.js usw. bieten der Softwareentwicklung
Methoden für kurze Release Zyklen.  Diese Methoden basieren u.A. auf diskreten
Paket-Manager in den jeweiligen Programmierumgebungen, mit denen der Entwickler
einer Software direkt selber entscheiden kann, auf welchen (Unter-) Komponenten
seine Software aufgebaut ist, resp. mit welchen Abhängigkeiten sie installiert
werden muss. Dies sorgt schlussendlich auch für eine höhere Stabilität und
Akzeptanz seiner Anwendung.

Diese Methoden werden von *old-school* Entwicklern z.T. kritisch betrachtet.
Diese Kritik mag in Teilen berechtigt sein, da man in den Umgebungen auch
schnell mal auf eine neue *dependency hell* trifft.  Einige (wenige?) JavaScript
Projekte auf Basis von npm könnten hierfür als negatives Beispiel genannt
werden.  Doch diese Sicht auf das Negative ist zu einseitig.  Im Konsum- als
auch im Unternehmens-Bereich werden kurze time-to-market Zyklen und schnelles
Bugfixing erwartet, gleichzeitig muss die Softwareentwicklung effizienter
werden.  Die Antwort auf diese Anforderungen sind die Paket-Manager der
Entwicklungsumgebungen, die Entwicklung und Deployment enger aneinander rücken.
In diesem veränderten Umfeld müssen die Distributoren ihre Rolle neu definieren
und über kurz oder lang auch ihre Konzepte resp. Paket-Manager anpassen.
Interessant in dem Zusammenhang ist auch der Artikel `Package managers all the
way down <https://lwn.net/Articles/712318/>`__ zu lesen.

Egal wie kritisch man diese aktuellen Veränderungen auf dem Softwaremarkt auch
betrachtet, sie haben in den letzten Jahren zu einer Beschleunigung der
Softwareentwicklung als auch zu einer Stärkung der Open-Source Community
beigetragen.  Für die eher problematischen Auswirkungen auf Distributoren gibt
es aktuell noch keine umfassende Antwort.  :ref:`Snap <snap>` und Container wie
:ref:`xref_docker` resp. :ref:`xref_lxdlxc` können Teil einer Antwort sein und
so findet man auch immer mehr solcher Distributionsformen, die von den
Softwareentwicklern paketiert werden.  Für Stand-Alone Software ist diese
Antwort i.d.R. auch ausreichend, sobald es aber um die Orchestrierung von
Diensten geht, treffen diese Lösungsansätze auf ihre Grenzen.  Für den
Endanwender ergeben sich ebenfalls neue Probleme; Es gibt keine *große*
Distribution mehr die mit ihrem Namen für die Stabilität und Sicherheit bürgen
kann.  Bei jeder Installation einer Software muss neu über die Qualität und
Update-Fähigkeit nachgedacht werden.

Eine Begrifflichkeit rund um dieses Thema ist *devOps*.  Wobei jeder unter
diesem Begriff etwas anderes versteht, einige assoziieren diesen Begriff
fälschlicher Weise mit Tools wie z.B. den oben genannten Containern.  Ich selber
sehe es eher als eine Philosophie deren Methoden sich erst noch in den nächsten
Jahren werden ausprägen müssen. Die strikte Auftrennung von Entwicklung
(**dev**\eleopment) und Administration (*Betrieb* / **Op**\erations) wird man
sukzessive aufgeben müssen.  Die idealen Akteure -- die ich auch als devOps
bezeichnen möchte -- sind devOps mit unterschiedlichen Focus.  Auf der einen
Seite der klassische Entwickler, der sich mit den Aspekten Betrieb und
Auslieferung wird auseinander setzen müssen und auf der Anderen Seite der
klassische Administrator der sich wird intensiver mit den Softwareprojekten wird
beschäftigen müssen.

Kurzum, es gibt keine *fertigen* Antworten. Niemand nimmt uns die Arbeit ab, im
Gegenteil: Egal aus welcher Ecke wir kommen, wir werden unseren Blickwinkel
weiten und unter den aktuell gegebenen Bedingungen individuelle Lösungen finden
müssen.  Auch wenn ich mich selbst eher als Software-Entwickler sehe, die
Auseinandersetzung mit Softwareverteilung und deren Orchestrierung ist
erforderlich und die Ergebnisse meiner Erfahrungen *gieße* ich hier in die
handsOn ein.  Die handsOn sollen mir (und anderen) helfen das dabei aufgebaute
Know-how in Form von Skripten und Dokumenten in möglichst aktueller Form zur
Verfügung zu stellen.

Die handsOn Sammlung wurde unter `Ubuntu (wiki)`_ getestet und die Skripte
sollten mit jeder aktuellen Ubuntu Version lauffähig sein. Langfristiges Ziel
ist es, dass die jeweils aktuelle LTS Version unterstützt wird.

Nicht getestet aber zu erwarten ist, dass die Skripte auch auf allen aktuellen
und gängigen LTS Versionen der Ubuntu-Derivate wie z.B. `lubuntu`_ ohne
Anpassungen laufen (:ref:`xref_debian_derivates_refs`).

Die meisten Installationen der handsOn Sammlung basieren auf den `Advanced
Package Tool (APT)`_ oder installieren aus den Quellen direkt und sollten damit
auch auf `Debian`_ und anderen APT basierten Distributionen funktionieren.

