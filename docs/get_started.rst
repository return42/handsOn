.. -*- coding: utf-8; mode: rst -*-

.. include:: ../get_started_refs.txt
.. include:: ../gogs_refs.txt

.. _xref_get_started:

================================================================================
                                  Get Started
================================================================================

Installation
============

Zur Installation ein Terminal öffnen und folgendes eingeben::

    wget --no-check -O /tmp/bs.sh "https://github.com/return42/handsOn/raw/master/bootstrap.sh" ; bash /tmp/bs.sh

Mit dem Kommando wird das handsOn Repository in dem Ordner installiert, in dem
es ausführt wird.  Es werden die erforderlichen Basispakete über :man:`apt-get`
installiert.  Sollte git_ nicht bereits installiert sein, so versucht das
``bootstrap`` Skript git_ zu installieren, hierfür ist eine *sudo* Berechtigung
auf dem lokalem Host erforderlich.  Alternative zum ``bootstrap`` Skript kann
die Installation auch manuell vorgenommen werden, auch hierbei ist git_
erforderlich.::

   git clone https://github.com/return42/handsOn.git
   sudo handsOn/scripts/ubuntu_install_pkgs.sh base

Bei dem ersten Aufruf eines der Skripte wird eine ``.config`` Datei sowie ein
Ordner eingerichtet, in dem die Konfigurationen gesichert werden (siehe auch
:ref:`xref_get_started_concept`). Am besten man macht das gleich mal als
erstes und lässt sich das Setup gleich mal anzeigen::

   ./scripts/setup.sh info

Die Ausgabe ist dann in etwa:

.. parsed-literal::

  INIT: It seems to be the first time you are using handsOn scripts,
  INIT: a default setup is created right now ...
  INIT:  --> create initial /share/handsOn/.config
  INIT:  --> create version controlled folder to store configurations:
  INIT:       **/share/handsOn/hostSetup**
  INIT:  --> create inital setup from example_setup.sh in
  INIT:       **/share/handsOn/hostSetup/ryzen_setup.sh**
  ...

  handsOn setup
  =============

  loaded /share/handsOn/hostSetup/ryzen_setup.sh

  CONFIG        : /share/handsOn/hostSetup/ryzen
  ORGANIZATION  : myorg
  ...

Hier in dem Beispiel werden die Config-Dateien der Hosts im Ordner
``./hostSetup`` gesammelt und versioniert.  Der Name des Hosts aus obigen
Beispiel ist ``ryzen``.  Anpassungen für diesen Host werden in der Datei
``./hostSetup/ryzen_setup.sh`` vorgenommen. Die Versionierung der Config-Dateien
ist Teil des handsOn-Konzepts.

.. _xref_get_started_concept:

Konzepte & Tools
================

Das handsOn Konzept bietet einen leichten Einstieg in das Setup (zum Teil)
komplexer Anwendungen. Es verzichtet auf *große* Tools und besteht im Kern aus:

- Einer Ordnerstruktur::

    handsOn
    ├── .config
    ├── cache
    ├── doc
    ├── hostSetup
    │   ...
    │   ├── <hostname>
    │   └── <hostname>_setup.sh
    ├── scripts
    │   ├── apache_setup.sh
    │   ...
    │   └── gogs.sh
    └── templates

  + In der ``.config`` Datei werden nur allgemeine Settings, die nur die handsOn
    selbst betreffen vorgenommen. Z.B. Angaben dazu wo die Config-Dateien zu
    finden sind oder welche Tools für einen Merge verwendet werden sollen.

  + In dem ``hostSetup`` Ordner werden die Sicherungen der Setups eines HOSTs
    abgelegt und **versioniert**. Voraussetzung für eine Sicherung ist das
    Vorhandensein einer ``<hostname>_setup.sh`` Datei in der anegegeben wird,
    was alles gesichert werden soll.

  + In dem ``doc`` Ordner sind die Quelldateien zu *dieser* Dokumentation.

  + In dem ``cache`` Ordner werden die Reposetories und Softwarepakete zu den
    Installationen *gecached* (Downloads aus dem Internet)

  + In dem ``scripts`` Ordner sind die Skripte zum Installieren der Dienste &
    Anwendungen.

    Die Skripte sind i.d.R. Shell-Skripte (`GNU Bash`_). Warum Shell-Skripte?
    Es ist die pragmatischste Herangehensweise Anwendungen einzurichten.  Nahezu
    alle Dienste und Anwendungen können letztlich über eine Kommandozeile
    eingerichtet werden und da liegt ein Shell-Skript zur Automatisierung
    einfach nur nahe.  Sollten irgendwann mal komplexere Anforderungen an das
    Skripting gestellt werden, werde ich ergänzend `python`_ zum Einsatz
    bringen.  Das war bisher aber nicht erforderlich, da sich die Skripte im
    allgemeinen recht einfach gestalten und mit `GNU Bash`_ am einfachsten
    implementiert werden konnten.

  + In dem ``templates`` Ordner sind *Vorlagen* von Konfigurationsdateien, die
    zu den Anwendungen gehören, welche mit den Skripten installiert
    werden. Diese *Vorlagen* sind erste gute Einstellungen, die man sich aber --
    über kurz oder lang -- wird anpassen wollen. Angepasst werden die Dateien im
    System selbst. Hat meine seine Anpassung beendet, nimmt man die im System
    angepasste Datei in seine Liste (``hostSetup/<hostname>_setup.sh``) der zu
    sichernden Konfigurationsdateien mit auf und versioniert sie mit allen
    anderen Anpassungen auf dem Host.

- Als Autorensystem wird `restructuredText`_ mit `Sphinx`_ genutzt.

- Zur Versionsverwaltung wird `Git`_ genutzt.

- Einem Tool zum Mergen von Dateien

  Als Merge Tool wird im Default der `Emacs`_ genutzt. Will man davon abweichend
  ein anderes Werkzeug nutzen, so kann man in der ``.config`` Datei die
  Variablen dafür setzen::

    # $MERGE_CMD {file_a} {file_b} {merged}
    MERGE_CMD=???

    # $THREE_WAY_MERGE_CMD {mine} {yours} {ancestor} {merged}
    THREE_WAY_MERGE_CMD=???

  Alternativen zum Emacs finden sich z.B. in den Artikeln auf `Stackoverflow
  (best 3 way merge tool)`_ oder `Wikipedia (File comparision tools /
  features)`_. In jedem Fall muss das verwendete Werkzeug ein `Drei-Wege Merge
  (wiki)`_ beherrschen.


.. _xref_get_started_refs:

Verweise
========

Merge
-----

.. _`Drei-Wege Merge (wiki)`: https://en.wikipedia.org/wiki/Merge_%28version_control%29#Three-way_merge
.. _`Stackoverflow (best 3 way merge tool)`: http://stackoverflow.com/questions/572237/whats-the-best-three-way-merge-tool
.. _`Wikipedia (File comparision tools / features)`: https://en.wikipedia.org/wiki/Comparison_of_file_comparison_tools#Compare_features

* `Drei-Wege Merge (wiki)`_
* `Stackoverflow (best 3 way merge tool)`_
* `Wikipedia (File comparision tools / features)`_

Autoring Tools
--------------

.. _`restructuredText`: http://www.sphinx-doc.org/en/stable/rest.html
.. _`Sphinx`: http://www.sphinx-doc.org/en/stable/index.html
.. _`Git`: http://git-scm.com/
.. _`Emacs`: https://www.gnu.org/software/emacs/

* `restructuredText`_
* `Sphinx`_
* `Git`_
* `Emacs`_

Paketmanager
------------

.. _`Advanced Package Tool (APT)`: https://wiki.debian.org/Apt

* `Advanced Package Tool (APT)`_


.. _xref_debian_derivates_refs:

Debian-Derivate
---------------

.. _`Debian Zensus`: https://wiki.debian.org/Derivatives/Census
.. _`Ubuntu (wiki)`: https://de.wikipedia.org/wiki/Ubuntu
.. _`lubuntu`: http://lubuntu.net/
.. _`Debian`: https://www.debian.org/
.. _`LinuxMint`: http://linuxmint.com/
.. _`Xubuntu (wiki)`: https://de.wikipedia.org/wiki/Xubuntu

* `Debian Zensus`_
* `Ubuntu (wiki)`_
* `lubuntu`_
* `Debian`_
* `LinuxMint`_
* `Xubuntu (wiki)`_

Skriptsprachen
--------------

.. _`GNU Bash`: https://www.gnu.org/software/bash/
.. _`python`: https://www.python.org/

* `GNU Bash`_
* `python`_
