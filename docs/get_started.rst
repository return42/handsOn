.. -*- coding: utf-8; mode: rst -*-

.. include:: get_started_refs.txt

.. _xref_get_started:

================================================================================
                                  Get Started
================================================================================

.. _xref_install_handson:

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
Ordner eingerichtet.  In dem Ordner werden die Konfigurationen gesichert (siehe
auch :ref:`xref_get_started_concept`).  Am besten man macht das gleich mal als
Erstes und lässt sich dabei noch das Setup anzeigen (info_sh_)::

   ./scripts/info.sh

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
hostSetup_ gesammelt und versioniert.  Der Name des Hosts aus obigen
Beispiel ist ``ryzen``.  Anpassungen für diesen Host werden in der Datei
``./hostSetup/ryzen_setup.sh`` vorgenommen.  Die Versionierung der
Config-Dateien ist Teil des handsOn-Konzepts.

.. _xref_get_started_concept:

================
Konzepte & Tools
================

Das handsOn Konzept bietet einen leichten Einstieg in das Setup (zum Teil)
komplexer Anwendungen.  Es verzichtet auf *große* Tools und besteht im Kern aus:

- Einer Ordnerstruktur_

- Als Autorensystem wird `restructuredText`_ mit `Sphinx`_ genutzt.

- Zur Versionsverwaltung wird `Git`_ genutzt.

- Einem `Tool zum Mergen <MERGE_CMD>`_ von Dateien.



.. _REPO_ROOT:

Ordnerstruktur
==============

::

  handsOn
  ├── .config
  ├── cache
  ├── doc
  ├── hostSetup
  │   ...
  │   ├── <profile>
  │   └── <profile>_setup.sh
  ├── scripts
  │   ├── apache_setup.sh
  │   ...
  │   └── gogs.sh
  └── templates

.. _dot_config:

``.config``
  In der Datei werden nur allgemeine Settings, die nur die handsOn selbst
  betreffen vorgenommen.  Z.B. Angaben dazu wo die Config-Dateien zu finden sind
  oder welche Tools für einen Merge verwendet werden sollen.  Von zentraler
  Bedeutung ist die Variable ``CONFIG`` die den Pfad zum Setup angibt
  (:ref:`xref_handsOn_setup`).

.. _hostSetup:

``hostSetup``
  In dem Ordner werden die Sicherungen der Setups eines HOSTs abgelegt und
  **versioniert**.  Voraussetzung für eine Sicherung ist das Vorhandensein einer
  ``<profile>_setup.sh`` Datei in der angegeben wird, was alles gesichert
  werden soll (CONFIG_setup_sh_).

.. _doc:

``doc``
  In dem Ordner sind die Quelldateien zu *dieser* Dokumentation.

.. _cache:

``cache``
  In dem Ordner werden die Reposetories und Softwarepakete zu den Installationen
  *gecached* (Downloads aus dem Internet)

.. _SCRIPTS:
.. _SCRIPT_FOLDER:

``scripts``
  In dem Ordner sind die Skripte zum Installieren der Dienste & Anwendungen.

  Die Skripte sind i.d.R. Shell-Skripte (`GNU Bash`_).  Warum Shell-Skripte?  Es
  ist die pragmatischste Herangehensweise Anwendungen einzurichten.  Nahezu alle
  Dienste und Anwendungen können letztlich über eine Kommandozeile eingerichtet
  werden und da liegt ein Shell-Skript zur Automatisierung einfach nur nahe.
  Sollten irgendwann mal komplexere Anforderungen an das Skripting gestellt
  werden, werde ich ergänzend `python`_ zum Einsatz bringen.  Das war bisher
  aber nicht erforderlich, da sich die Skripte im allgemeinen recht einfach
  gestalten und mit `GNU Bash`_ am einfachsten implementiert werden konnten.

.. _TEMPLATES:

``templates``
  In dem Ordner sind *Vorlagen* von Konfigurationsdateien, die zu den
  Anwendungen gehören, welche mit den Skripten installiert werden.  Diese
  *Vorlagen* sind erste gute Einstellungen, die man sich aber -- über kurz oder
  lang -- wird anpassen wollen.  Angepasst werden die Dateien im System selbst.
  Hat meine seine Anpassung beendet, nimmt man die im System angepasste Datei in
  seine Liste (``hostSetup/<hostname>_setup.sh``) der zu sichernden
  Konfigurationsdateien mit auf und versioniert sie mit allen anderen
  Anpassungen auf dem Host.


.. _xref_handsOn_setup:

Versionierung des Setups
========================

Im Rahmen der :ref:`Installation <xref_install_handson>` wurde der Ordner
``hostSetup`` angelegt.  In diesem Ordner können die Setups versioniert werden.
Das dieser Ordner für die Setups verwendet werden soll, wurde in der ``.config``
Datei über die Variable ``CONFIG`` festgelegt.::

  CONFIG="${REPO_ROOT}/hostSetup/$(hostname)"
  #CONFIG="${REPO_ROOT}/hostSetup/clientpc"

Dieser Wert kann (natürlich) auch anders belegt werden.  Hat man seine Setups
z.B. unter ``/foo/repo_setups`` liegen und möchte statt eines Host-spezifischen
Setups das ``clientpc`` Profil verwenden::

  CONFIG=/foo/repo_setups/clientpc

In diesem Fall würden *alle* verfügbaren Profile im Ordner ``/foo/my_setups``
abgelegt werden.  Die Versionierung dieses Ordners ist sinnvoll, denn nur über
eine Historie kann man die Änderungen (auch z.B. durch Sytemupdates) tracen.

.. caution::

  Natürlich sollte man ein solches Reposetory niemals auf einem *public* Host
  *pushen*! Auch wenn man sichergestellt hat, dass private Schlüssel und
  Klartext-Passwörter `verschlüsselt <CONFIG_BACKUP_ENCRYPTED>`_ sind, so verrät
  ein solches Setup immernoch sehr viel über den Host; welche Software auf ihm
  läuft, wie diese konfiguriert ist und wo sich evtl. Schwachstellen auftun, die
  man ausnutzen könnte.

Zu jedem Profil gehört eine *Setup* Datei ``<profile>_setup.sh`` in der
Anpassungen für dieses Profil vorgenommen werden können. Um beim letzten
Beispiel zu bleiben::

  /foo/repo_setups/clientpc_setup.sh

I.d.R. wird man seine Profile unterschiedlich differenziert organisieren wollen.
Bei der :ref:`Installation <xref_install_handson>` wurde ein Profil spezifisch
zum Hostnamen eingerichtet. Je nach Bedarf sollte man das anpassen.

.. _xref_backup_config_sh:

Sicherung eine Setups
=====================

Beim Einrichten der Anwendungen werden i.d.R. Konfigurationsdateien z.B. unter
``/etc`` angepasst.  Diese Config-Dateien können mit dem Backup-Script gesichert
werden::

  $ sudo ./scripts/backup_config.sh

.. _CONFIG_BACKUP_ENCRYPTED:
.. _CONFIG_BACKUP:

Eine so erstellte Sicherung würde in dem Ordner abgelegt werden, der über die
Variable ``CONFIG`` definiert wurde (:ref:`xref_handsOn_setup`).  Voraussetzung
einer Sicherung ist das Anlegen der CONFIG_setup_sh_ Datei.  Darin wird in
den Variablen:

- CONFIG_BACKUP_ und
- CONFIG_BACKUP_ENCRYPTED_

festgelegt, welche Dateien und Ordner zur Konfiguration des Host (dem Profil)
gehören und somit gesichert werden müssen.  Dateien werden in der Sicherung für
*alle* lesbar gesichert.  Nur die in CONFIG_BACKUP_ENCRYPTED_ aufgelisteten
Pfade werden mit einem Passwort verschlüsselt.  Dies empfiehlt sich z.B. für
private Schlüssel und Config-Files in denen Passwörter im *Klartext* hinterlegt
sind.

Ob eine Datei oder ein Ordner in die Sicherung und damit in die Versionierung
mit aufgenommen werden soll ist eine Entscheidung, die man selber treffen muss.
Grundsätzlich gilt auch hier *weniger ist mehr*, dennoch sollten alle Config-
Dateien in die Sicherung mit aufgenommen werden, die auch angepasst wurden oder
aus anderen Gründen *getract* werden sollen.  Dateien der Konfiguration, die
ohnehin in unveränderter Form aus dem TEMPLATES_ Ordner übernommen wurden,
brauchen nicht unbedingt gesichert zu werden.  So bekommt man für die
unveränderten Dateien noch die Updates aus dem TEMPLATES_ Ordner mit, wenn man
eine Anwendung neu installiert oder ein Update über die handsOn Skripte macht.

Anwendung gesicherter Config-Dateien
====================================

Die Skripte in dem Ordner SCRIPTS_ richten die Anwendungen ein. Dabei
legen sie die erforderlichen Config-Dateien der Anwendungen an.  Die Vorlagen
für solche Config-Dateien entnehmen die Skripte aus dem Ordner TEMPLATES_

Hat man eine Sicherung seiner Config-Dateien im Profil angelegt (CONFIG_BACKUP_)
so schauen die Skripte nach, ob es zu der Datei aus dem Ordner TEMPLATES_ eine
gleichnamige Datei in der Sicherung gibt.  Wird zu einer Konfiguration eine
Sicherung gefunden, so wird diese in die Installation mit einbezogen.
I.d.R. kann der Anwender dann auswählen ob er die Standard-Vorlage oder die
Sicherung nutzen will.  Meist hat er auch noch die Wahl beide Dateien
zusammenzuführen (MERGE_CMD_).


.. _CONFIG_setup_sh:

``${CONFIG}_setup.sh``
======================

In der Datei werden alle Anpassungen des Profils definiert.  Sie wird in dem
Ordner hostSetup_ angelegt, also z.B::

  /foo/repo_setups/<profile>_setup.sh

Die wichtigsten Variablen sind die zur Sicherung:

- CONFIG_BACKUP_
- CONFIG_BACKUP_ENCRYPTED_

Es können aber auch alle anderen Variablen des Setups angepasst werden, siehe
`hostSetup/example_setup.sh`_.

.. _info_sh:

Will man wissen wie die Umgebungsvariablen eingestellt sind, dann kann man
dafür das ``info.sh`` Skript verwenden::

  ./scripts/info.sh


.. _CONFIG_sysinfo_sh:
.. _backup_config_sh:

``${CONFIG}_sysinfo``
=====================

Mit dem Skript ``log_sysinfo.sh`` können diverse Infos zum System protokolliert
werden::

  ./scripts/backup_config.sh

Obiger Aufruf legt thematisch sortiert Dateien in dem Ordner hostSetup_
(``${CONFIG}_sysinfo``) an.  Z.B. wird für jede Festplatte eine Protokolldatei mit
performance Messungen und SMART Werten erzeugt und es werden Dateien mit den
Ausgaben zu ``lshw``, ``lsusb``, ``lspci`` und zum X-Display (``xrander``)
angelegt.

  *Ich versioniere diese Protokolldateien ebenfalls mit, so kann ich
  Veränderungen am System über die Zeit beobachten, z.B. die Degression der
  SMART Werte.*

.. _MERGE_CMD:
.. _THREE_WAY_MERGE_CMD:

Merge Tool
----------

Als Merge Tool wird im Default der `Emacs`_ genutzt.  Will man davon abweichend
ein anderes Werkzeug nutzen, so kann man in der dot_config_ Datei die Variablen
dafür setzen::

  # $MERGE_CMD {file_a} {file_b} {merged}
  MERGE_CMD=???

  # $THREE_WAY_MERGE_CMD {mine} {yours} {ancestor} {merged}
  THREE_WAY_MERGE_CMD=???

Alternativen zum Emacs finden sich z.B. in den Artikeln auf `Stackoverflow
(best 3 way merge tool)`_ oder `Wikipedia (File comparision tools /
features)`_. In jedem Fall muss das verwendete Werkzeug ein `Drei-Wege Merge
(wiki)`_ beherrschen.

.. _DIFF_CMD:

Diff Tool
---------

Im Default wird ``colordiff`` verwendet, wenn das nicht vorhanden ist, wird
``diff`` verwendet.  Will man davon abweichend ein anderes Werkzeug nutzen, so
kann man in der dot_config_ Datei die Variablen dafür setzen::

  # $DIFF_CMD {file_a} {file_b}
  DIFF_CMD=??


.. _xref_get_started_refs:

Allgemeine Verweise
===================

Merge
-----

* `Drei-Wege Merge (wiki)`_
* `Stackoverflow (best 3 way merge tool)`_
* `Wikipedia (File comparision tools / features)`_

Autoring Tools
--------------

* `restructuredText`_
* `Sphinx`_
* `Git`_
* `Emacs`_

Paketmanager
------------

* `Advanced Package Tool (APT)`_


.. _xref_debian_derivates_refs:

Debian-Derivate
---------------

* `Debian Zensus`_
* `Ubuntu (wiki)`_
* `lubuntu`_
* `Debian`_
* `LinuxMint`_
* `Xubuntu (wiki)`_

Skriptsprachen
--------------

* `GNU Bash`_
* `python`_
