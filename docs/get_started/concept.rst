.. -*- coding: utf-8; mode: rst -*-

.. include:: ../get_started_refs.txt

.. _xref_get_started_concept:

================================================================================
                                Konzepte & Tools
================================================================================

Das handsOn Konzept bietet einen leichten Einstieg in das Setup (zum Teil)
komplexer Anwendungen. Es motiviert zur Versionierung und Dokumentation der
gewählten Setups und unterstützt bei Wartung und Entwicklung von Setups.

Aus eigener Erfahrung bin ich der Überzeugung, dass ein strukturiertes Vorgehen,
ergänzt durch eine brauchbare Dokumentation und eine Versionierung nur selten
*große* Tools benötigt. Im Gegenteil, *allzu intelligente* Tools verbergen nicht
selten das Know-how und engen damit die Bewegungsfreiheit ein. Meiner Ansicht
nach bedarf es meist nicht viel mehr Tools, ausser einer einfachen
Skript-Sprache, einer Versionsverwaltung, einem einfachen Autorensystem und
einem guten Merge Tool, das auch einen `Drei-Wege Merge (wiki)`_ beherscht. Mit
diesen wenigen Tools werden Myriaden von Software Projekten gemanaged und damit
sollte auch ein Setup beherschbar sein.  Dementsprechend ist die handsOn
Sammlung eher ein Konzept, denn eine Sammlung von Tools.

* Als Autorensystem wird `restructuredText`_ mit `Sphinx`_ genutzt.

* Zur Versionsverwaltung wird `Git`_ genutzt.

* Als Merge Tool wird im default der `Emacs`_ genutzt, es kann aber auch jeder
  andere Editor genutzt werden, der ein `Drei-Wege Merge (wiki)`_ beherscht.
  Alternativen zum Emacs finden sich z.B. in den Artikeln auf `Stackoverflow
  (best 3 way merge tool)`_ oder `Wikipedia (File comparision tools /
  features)`_.

Die Skripte zum Einrichten sind allesamt Shell-Skripte (`GNU Bash`_). Warum
Shell-Skripte?  Es ist (IMO) die prakmatischste Herangehensweise Anwendungen
einzurichten. Nahezu alle Dienste und Anwendungen können letztlich über eine
Kommandozeile eingerichtet werden und da liegt ein Shell-Skript zur
Automatisierung einfach nur nahe. Sollten irgendwann mal komplexere Anforderungen
an das Skripting gestellt werden, werde ich ergänzend `python`_ zum Einsatz
bringen. Das war bisher aber nicht erforderlich, da sich die Skripte im
allgemeinen recht einfach gestalten und mit `GNU Bash`_ am einfachsten
implementiert werden konnten.

Das Konzept der handsOn Sammlung drückt sich schon in der strukturierten
*Ablage* der Dateien aus. Die Ordnerstruktur des handsOn Repository baut sich
wie folgt auf::

  handsOn
  ├── cache
  ├── doc
  ├── hostSetup
  │   ...
  │   ├── <hostname>
  │   └── <hostname>_setup.sh
  ├── scripts
  │   ...
  │   ├── common.sh
  │   └── setup.sh
  └── templates

* In dem ``doc`` Ordner sind die Quelldateien zu *dieser* Dokumentation.

* In dem ``cache`` Ordner werden die Softwarepakete (die nicht von APT verwaltet
  werden) und Reposetories *gecached*, die beim Installieren der Anwendungen aus
  dem Internet gezogen werden.

* In dem ``scripts`` Ordner sind die Skripte zum Installieren der Anwendungen.
  In dem Ordner gibt es noch eine ``setup.sh`` Datei, mit der die wichtigsten
  (globalen) Einstellungen zu den handsOn Skripten vorgenommen werden können.

* In dem ``hostSetup`` Ordner werden die Sicherungen der Setups eines HOSTs
  abgelegt und **versioniert**. Voraussetzung für eine Sicherung ist das
  Vorhandensein einer ``<hostname>_setup.sh`` Datei in der anegegeben wird, was
  alles gesichert werden soll. Sofern Einstellungen aus der (globalen)
  ``scripts/setup.sh`` für einen HOST angepasst werden müssen, kann dies auch in
  der ``<hostname>_setup.sh`` erfolgen.

* In dem ``templates`` Ordner sind *Vorlagen* von Konfigurationsdateien, die zu
  den Anwendungen gehören, welche mit den Skripten installiert werden. Diese
  *Vorlagen* sind erste gute Einstellungen, die man sich aber -- über kurz oder
  lang -- wird anpassen wollen. Angepasst werden die Dateien im System
  selbst. Hat meine seine Anpassung beendet, nimmt man die im System angepasste
  Datei in seine Liste (``hostSetup/<hostname>_setup.sh``) der zu sichernden
  Konfigurationsdateien mit auf und versioniert sie mit allen anderen
  Anpassungen auf dem Host.
