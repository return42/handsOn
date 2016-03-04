.. -*- coding: utf-8; mode: rst -*-

.. include:: ../devTools_refs.txt

.. _xref_ubuntu_devTools_python:

================================================================================
                                     python
================================================================================

Es gibt derzeit zwei Versionen des Interpreters; Python 2 und Python 3, wobei in
Python 3 ziemlich aufgeräumt wurde.  Oberflächlich betrachtet sind die beiden
Versionen bis auf wenige *keywords* syntaktisch gleich.  Schaut man genauer hin,
merkt man aber schnell, dass sich ziemlich viel an den Datentypen und
Operationen geändert hat (siehe `What’s New in Python`_ 3).

Um es abzukürzen, jede Portierung auf Python 3 ist mit Aufwänden verbunden,
weshalb es immernoch diverse (produktive) Instanzen gibt, die auf Python 2
nicht verzichten können und die *nicht-aufwärtskompatibel* weiter entwickelt
werden.  Es ist schwer einen Kunden davon zu überzeugen, dass er für eine
Aufwärtskompatibilität zusätzliches Geld investieren soll, wenn er diese *heute*
(noch) gar nicht braucht.

Open Source Projekte sind da meist schon *weiter*, eine Python 2/3 kompatible
Implementierung wird fast schon als *Standard* erwartet.  Ob es dem Fortschritt
dienlich ist immer abwärtskompatibel zu sein, ist dabei diskutabel.  Ab einem
bestimmten Punkt muss man seinen Kunden (im Interesse des Kunden selbst) auch
dazu bewegen der Weiterentwicklung zu folgen.  Nur sollte das dann auch so
*smooth* wie irgend möglich für ihn sein.

Ein anderes Bsp. dazu: Endlich Windows XP abzulegen, war auch in den Unternehmen
ein längst überfälliger Schritt, der von vielen Unternehmen verschoben wurde,
bis sie von MS dazu gezwungen wurden. Es ist nicht einfach den richtigen Punkt
für einen Wechsel zu finden. Sobald man merkt, dass die eigene Version einen
dran hindert aktuell verfügbare Entwicklungen zu integrieren sollte man zum
ersten mal drüber nachdenken, bevor man weiter unüberlegt in die alte
Infrastruktur investiert und unnötige Verrenkungen macht, die man mit einer
neuen Version galant umgehen könnte. Diese langfristige Perspektive ist bei
Unternehmen, die zu einem zügigen *Return of Investment* gezwungen sind nicht
immer gegeben und genau hier muss man als Berater seine Aufgabe sehen um den
besten Kompromiss finden.

Mit Bezug auf Python: Werkzeuge, Strategien und Erfahrungen für eine Python 2
nach 3 Migration gibt es inzwischen genügend und nach 8 Jahren parallen Supports
sollte man da wirklich mal drüber nachdenken.

* `Porting Python 2 Code to Python 3`_
* `Python 3 Q & A`_

Doch nun aber zurück zu Python und den Debian Paketen.  Der `python`_
Interpreter ist auf den `Debian-Derivate (wiki)`_ bereits auf jeder
OS-Installation enthalten, da er (wie der Perl Interpreter) Teil des Debian
Ökosystems ist (`Debian python`_).

Es gibt verschiedene Implementierungen des Python Interpreters, wobei `CPython`_
die Referenzimplementierung ist. Wenn man sich Python von python.org oder von
Debian installiert, dann installiert man sich einen `CPython`_
Inperpreter. `CPython`_ ist der *Standard* Inperpreter, auf andere
Implementierungen will ich nicht mehr eingehen.

Debian nutzt Python 2 als Standard-Interpreter, es ist i.d.R. aber auch immer
der Python 3 Interpreter installiert.  Gleiches gilt für die ggf. schon
vorinstallierten Python Module, die Python 3 Versionen müssen bei Bedarf
z.T. noch nachinstalliert werden, was aber auch kein wirkliches Problem ist und
im Rahmen der Paketverwaltung ohnehin ohne weiteres zutun erfolgt.

Für die Entwicklung resp. den Betrieb einiger Software können folgende Pakete
empfohlen werden.  Einige dieser Pakete werden von Installationen benötigt, so
z.B. auch schon von der handsOn Sammlung selber (:ref:`xref_site_pyapps`).

* :deb:`python-argcomplete` / :deb:`python3-argcomplete`

Autovervollständigung für Python Anwendungen auf der Kommandozeile, siehe
`argcomplete (RTD)`_.

* :deb:`python-virtualenv`

Tool um isolierte Python Umgebungen bereit zu stellen, der Namesbestandteil
*virtual* geht etwas zu weit, es wird kein Python *virtualisiert*.  Mit `python
Virtualenv` können jedoch Python Anwendungen sehr gut gegeneinander isoliert
werden, so dass sie ihre *eigenen* Abhängigkeiten in ihre *eigene* Umgebung
installieren können, ohne dass alle Python Anwendungen den selben Satz an
Bibliotheken nutzen müssten oder diese Bibliotheken ins OS installiert werden
müssten.  Ein Beispiel aus der handsOn Sammlung sind die python
:ref:`xref_site_pyapps` eines WEB-Servers, die in ihrer *eigenen* Umgebung
laufen.

* :deb:`pylint`

`Pylint`_ ist ein Python Code-Checker, der Name ist an den statischen
Code-Analysator `Lint (wiki)`_ angelehnt.  Insbesondere bei dynamischen
Interpretersprachen verbessert ein Code-Checker die Code-Qualität und
Produktivität des Entwicklers.

  Ein *must have* für jeden python Entwickler!

`Pylint`_ ist die wirklich gelungene Code-Analyse für Python und geht damit
wesentlich weiter als Style-Cheker wie `pep8 (RTD)`_.  Leider gibt es z.T. auch
Softwareprojekte in denen der `PyLint`_ nur bedingt eingesetzt werden kann.
Meist ist das (proprietäre) Software, die mit ziemlich kruden und generischen
Modellen -- die zwar in Python möglich aber deswegen noch lange nicht immer
sinnvoll sind -- herumjonglieren und Programmiermodelle forcieren, die an
klassischen Konzepten voll vorbei gehen.  Aber auch in solch *kranken*
Umgebungen kann man mit etwas Übung immernoch von einer Code-Analyse zumindest
teilweise profitieren.  Kurzum: Ein `PyLint`_ Prozess ist immer richtig, weshalb
es auch Integrationen in jedes ernstzunehmendes (python-) Entwicklerwerkzeug
gibt (`Editor and IDE Integration <https://docs.pylint.org/ide-integration>`_)

* :deb:`python-pip` / :deb:`python3-pip`

*Pip Installs Python* (kurz: `pip`_) ist der Paketmanager von Python.  Mit ihm
können Python Pakete aus dem Python-Package-Index installiert werden.  Das die
beiden Paketmanager `Debian Package Managment`_ und `pip`_ ein Konfliktpotential
haben wurde z.T. schon im Netzt diskutiert, ich selber bin der Meinung, dass es
keine Konflikte gibt, wenn sich jeder auf seine Rolle konzentriert und die für
ihn richtigen Entscheidungen trifft.

* Der *Debian Package Builder* muss sich entscheiden, welche Anwendung er in
  seine Distribution aufnehmen will.  Dabei sollte es unerheblich sein, ob diese
  in Python, Java, Ruby oder sonst was implementiert ist und ob diese Sprachen
  eigene Package-Manager besitzen.  Er muss seine Pakete und Paketabhängigkeiten
  so bauen, dass alle erforderlichen Teilpakete in seinem Package-Managment in
  den Versionen vorliegen um daraus ein konkretes Release einer Anwendung
  installiern zu können.

* Der Anwendungsentwickler formuliert seine Abhängigkeiten (im Fall Python)
  gegen `PyPI`_, dem Package-Reposetory von pip.  Hat er weitere Abhängigkeiten,
  muss er diese in einer Installationsanleitung benennen.  Ein Beispiel hierfür
  sind die Python Bindings für GLib/GObject/GIO/GTK+ siehe `PyGObject (aka
  PyGI)`_.  Die kann nur der *Package Builder* in seiner Distrubition erfüllen.

* Der *Betreiber* einer Anwendung muss sich entscheiden, ob er seine gewünschte
  Anwendung aus dem *Debian Package Builder* installiert oder ob er die Software
  (in der aktuellsten Version) lieber selber installiert. Beides hat seine Vor-
  und Nachteile.  So werden beispielsweise die Updates über den *Debian Package
  Builder* ohne eigenes zutun bereit gestellt, mit dem Systemupdate ist auch die
  Anwendung aktualisiert.  Entscheidet man sich für die eigene Installation,
  kann man Aktualisierungen schneller *produktiv bringen*, muss sich aber auch
  selber drum kümmern.

Wie bereits erwähnt können Abhängigkeiten in das OS nicht über `PyPi`_ erfüllt
werden, ein Beispiel dafür ist die Anbindung von Python an die `GObject
Introspection`_ die von den von den folgenden ``*gi*`` -Paketen bereit gestellt
wird.

* :deb:`python-gi` / :deb:`python3-gi`

Die Pakete installieren die Python Anbindung (den Abstraktionslayer) an das
Modell der `GObject Introspection`_. Die Introspektion ist eine Abstrakttion die
mit GTK+ 3 eingeführt wurde. Mit dieser Abstraktion müssen keine Wrapper mehr
für eine GObject Bibliothek implementiert werden, sondern nur noch ein
Abstraktionslayer (:deb:`python-gi`) je Sprache. Über die Introspektion hat man
dann in der Sprache zugriff auf sämmtliche im System installierten Bibliotheken,
ein Beispiel dafür ist `WebKitGTK+`_ (API: `PGI Docs WebKit2 4.0`_).

Alternativ gibt es den Abstraktionslayer noch als *Pure Python GObject
Introspection Bindings* (`PGI`_), was aber eher *experimentell* ist. In
produktiven Umgebungen sollte man immer auf die native GI zurückgreifen (beide
sind zueinander API kompatiebel).

Das `Python GTK+ 3 Tutorial`_ gibt eine Einführung in die Anwendungsentwicklung
mit `PyGObject (aka PyGI)`_. Ganz ohne ein Blick auf die Dokumentation der
C-Bibliotheken wird man aber nicht immer zurecht kommen weshalb sich ein
Bookmark des `GTK+ 3 Reference Manual`_ ebenfalls lohnt.

.. hint::

   Die Bezeichnung `Python GTK+ 3 Tutorial`_ sollte nicht mit den PyGTK Bindings
   verwechselt werden.  Das Tutorial beschreibt die `PyGObject (aka PyGI)`_
   Bindings, auch wenn das Tutorial ein "Py..GTK" im Namen trägt, es sollte
   nicht mit PyGTK -- der alten und obsoleten Implementierung -- verwechselt
   werden.

   Die Namensgebungen sind zum Teil etwas babylonisch und im Netzt findet man
   noch häufig Artikel zu der alten Implementierung PyGTK. Zur Orientierung
   sollte man sich merken: Wenn man etwas über *PyGTK* oder *GTK+ 2* liest, dann
   ist das *vintage*, wenn man was über **PyGobject**, **PyGI** oder **GTK 3**
   liest, dann ist das **der heiße Scheiß**.

Eine vollständige Dokumentation zur Introspektion der gängigen GObject
Bibliotheken liefert die `Python GObject Introspection API Reference`_. Diese
wird automatisch erzeugt, ist immer aktuell und umfasst so ziemlich alle
gängigen GObject Biliotheken. Die Webseite ist aufgrund der Größe etwas langsam,
bei Interesse sollte man sich das git-Repositorie clonen oder das ZIP-File
runter-laden.

* :deb:`python-dev` / :deb:`python3-dev`

Die Pakete installieren die Python Header Dateien.  In Python kann mittels
`ctypes`_ auf Biblitheken zugegriffen werden (`PGI`_ ist ein Beispiel). Der
Zugriff auf C-Funktionen ist aber nicht immer praktikabel, da man die
C-Datentypen in Python zur Laufzeit *kennen* muss, was bei Strukturen schnell
mal daneben gehen kann (Projekte die massiv ctypes verwenden haben nicht selten
Probleme Speicherzugriffsfehler).

Besser ist es, wenn Anbieter von Bibliotheken gleich ein Python-Modul als API
zur C-Bibliothek bereit stellen, das können sie beispielsweise wie in `Extending
Python with C or C++`_ beschrieben. Nicht selten wird dabei noch der *Umweg*
über `SWIG`_ genommen um das Interface von der Zielsprache zu abstrahieren.

Egal, wie man es macht, am Ende braucht man in seinem Interface die Python
Header-Files, in denen die Python Datentypen definiert werden, auf die man
*abbilden* will. Solange man nur *Python-Extensions* aus der Debian Distrubition
nimmt, braucht man das alles nicht.  Sobald man aber Software aus Sourcen
installiert die nach Python wrapt, benötigt man die Header Dateien von Python
für den Build-Prozess.

* :deb:`cython`

Installiert `Cython`_, eine Programmmiersprache die ein *Superset* von Python
ist (Python ist eine Teilmenge von Cython). Der Cython Compiler übersetzt Python
Implementierungen nach C und diese C-Implementierungen werden mittels C-Compiler
in ausführbaren Code übersetzt. Das Prozessbild von Wikimedia Commons
veranschaulicht den Prozess an einem einfachen Beispiel.

.. _xref-figure-python-Cython_CPython_Ext_Module_Workflow:

.. figure:: python/Cython_CPython_Ext_Module_Workflow.png
   :alt:     Figure (Cython_CPython_Ext_Module_Workflow.png)
   :align:   center
   :target:  https://en.wikipedia.org/wiki/Cython#/media/File:Cython_CPython_Ext_Module_Workflow.png

   `Cython (wiki)`_ Prozessbild (Wikimedia Commons)

`Cython`_ benötigt das `CPython`_ Ökosystem (also den Standard Python
Interpreter).  Will man C-Extensions für Python erstellen, ist `Cython`_ eine
gute Alternative zur Implementierung direkt in C, da man in seiner gewohnten
Python Umgebung bleibt und das Interface (s.o.) nicht mehr extra implementieren
muss.

Einfach nur seine ``.py`` Datei durch den Cython Compiler zu jagen ist zwar
möglich, wird aber meist nicht sehr viel an Optimierung bringen. Da man davon
ausgehen kann, dass der `CPython`_ Interpreter, den man im Debian hat, bereits
mit Optimierung durch den C-Compiler gelaufen ist. Um dem C-Compiler Möglichkeit
zur Optimierung zu geben wird man Datentypen definieren müssen und sich des
*Superset* von Cython bedienen müssen. Diese Cython-Dateien werden mit der
Endung ``.pyx`` versehen um sie von normalen Python Dateien ``.py`` zu
differenzieren.

Etwas *off-Topic*, aber um das Bild der Python-Extensions / Optimierung noch zu
ergänzen: weitere Möglichkeiten zur Optimierung der Ausführungsgeschwindigkeit
bietet der JIT Compiler `PyPy`_ (nicht zu verwechseln mit `PyPI`_ dem Package
Reposetory).
