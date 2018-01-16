==============================================================================
MEMO: hostSetup
==============================================================================

  In *diesem* Ordner (``./ hostSetup``) werden die Umgebungsvariablen
  für die Skripte und die Sicherungen der Konfigurationen hinterlegt.

Umgebungsvariablen für die Skripte
==================================
  
Die Vor-Einstellungen von z.B. Pfad- oder Hostnamen, die von den
Installations-Skripten benötigt werden, werden in Umgebungsvariablen
übergeben. Für diese Umgebungsvariablen gibt es sinnvolle Defaults.
Aber nicht alle Defaults passen immer auf allen Hosts. Will man
z.B. ein Client Programm auf einem Desktop einrichten, dann muss man
wissen wie der Hostname des Servers ist. Hierfür kann es keinen
sinnvollen Default geben. Um solche Vor-Einstellungen *je Host* setzen
zu können, kann man eine Datei anlegen in der die Umgebungsvariablen
passend zu dem Host gesetzt werden können.

Welche Umgebungsvariablen in dieser Datei gesetzt werden können, ist
in der ``scripts/setup.sh`` beschrieben. Alternativ kann die
``example_setup.sh`` als Vorlage für einen Host genutzt werden::

  $ cp ./hostSetup/example_setup.sh ./hostSetup/$(hostname)_setup.sh

Will man seine ``CONFIG`` wo anders ablegen, z.B. in seinen Backups,
dann empfiehlt sich::

  $ CONFIG=/backup/$(hostname) \
    cp ./hostSetup/example_setup.sh ${CONFIG}_setup.sh


Sicherung der Setups
====================

Beim Einrichten der Anwendungen werden i.d.R. Konfigurationsdateien
(Config-Files) z.B. unter ``/etc`` angelegt. Diese Config-Files können
mit dem Backup-Script gesichert werden::

  $ sudo ./scripts/backup_config.sh

Eine so erstellte Sicherung würde in dem Ordner::

  ./hostSetup/$(hostname)

abgelegt werden. Um die Sicherungen (und die ``$(hostname)_setup.sh``)
wo anders abzulegen, muss man wieder die Umgebungsvariable ``CONFIG``
setzen. Das kann man z.B. beim Aufruf eines Skripts machen::

  $ sudo CONFIG=/backup/$(hostname) ./scripts/backup_config.sh

Voraussetzung für eine Sicherung ist allerdings das Anlegen einer
Setup ``${CONFIG}_setup.sh`` Datei. Also z.B::

  /backup/$(hostname)_setup.sh

Darin wird in den Umgebungsvariablen:

* CONFIG_BACKUP und
* CONFIG_BACKUP_ENCRYPTED

festgelegt, welche Dateien und Ordner zur Konfiguration des Hosts
gehören und somit gesichert werden müssen.

Die in CONFIG_BACKUP_ENCRYPTED gelisteten Pfade werden dabei mit einem
Passwort verschlüsselt. Dies empfiehlt sich z.B. für private Schlüssel
und Config-Files in denen Passwörter im *Klartext* hinterlegt sind.

Verwenden gesicherter Config-Files
==================================

Die Skripte in dem Ordner ``./scripts/`` richten die Anwendungen
ein. Dabei legen sie die erforderlichen Config-Files der Anwendungen
an. Die Vorlagen für solche Config-Files entnehmen die Skripte aus dem
Ordner::

  ./templates/

Hat man eine Sicherung seiner Config-Files angelegt (s.o.) so schauen
die Skripte nach, ob es zu der Datei aus dem Ordner ``./templates/`
eine gleichnamige Datei in der Sicherung gibt.

Wird zu einer Konfiguration eine Sicherung gefunden, so wird diese in
die Installation mit einbezogen.  I.d.R. kann der Anwender dann
auswählen ob er die Standard-Vorlage oder die Sicherung nutzen
will. Meist hat er auch noch die Wahl beide Dateien zusammenzuführen
(merge).

Wie oben beschrieben wird die Sicherung in dem Ordner::

  ./hostSetup/$(hostname)

erwartet. Sollte die Sicherung wo anders abgelegt sein, muss wieder
die ``CONFIG`` Variable beim Aufruf gesetzt werden::

  $ sudo CONFIG=/backup/$(hostname) ./scripts/install_foo.sh

Zusammenfassung
===============

Will man wissen wie die Umgebungsvariablen eingestellt werden, dann
kann man dafür das `info.sh`` Skript verwenden::

  sudo CONFIG=/backup/$(hostname) ./scripts/info.sh

Über die Umgebungsvariable ``CONFIG`` wird festgelegt wo die
Konfiguration und das Setup zu finden ist. Obige Namensgebung
orientierte sich dabei am ``hostname``. Das macht bei Hosts, die sehr
individuell eingerichtet werden (wie z.B. Servern) auch Sinn.

Eine Alternative kann es auch sein, thematisch vorzugehen. So kann man
z.B.  für seine Desktop-PCs oder Laptops -- die alle exakt gleich
eingerichtet werden sollen -- eine einheitliche Konfiguration anlegen,
die man z.B. ``clientpc`` nennt.

Im Ordner ``./hostSetup/`` liegt z.B. die Datei ``clientpc_setup.sh``
wie *ich* sie verwende. Für die *eigenen* Zwecke müsste diese
angepasst werden. Überprüfen kann man das dann am besten mit::

  $ CONFIG=./hostSetup/clientpc ./scripts/info.sh

Versionierung des Setups
========================
  
Es kann auch sehr hilfreich sein, wenn man die die ganzen Setups
versioniert (z.B. mit git). So kann man 


Also z.B. den Ordner anlegen::

  $ mkdir -p /my/repo

Nun das Setup für den Host einrichten:

  $ CONFIG=/my/repo/$(hostname) \
    cp ./hostSetup/example_setup.sh ${CONFIG}_setup.sh

Anpassungen in der ``/my/repo/$(hostname)_setup.sh`` vornehmen.
Anschließend Backup anlegen::

  $ sudo CONFIG=/my/repo/$(hostname) ./scripts/backup_config.sh

Zum Schluss das Git-Reposetory einrichten und den initialen Stand
comitten::
  
  $ cp ./.gitignore /my/repo
  $ cd /my/repo
  $ git init
  $ git add --all
  $ git commit -m "Repo mit den Setup der Hosts (initial)

ACHTUNG::

  Natürlich sollte man ein solches Reposetory niemals auf einem
  *public* Host *pushen*! Auch wenn man sichergestellt hat, dass
  private Schlüssel und Klartext-Passwörter verschlüsselt sind
  (``CONFIG_BACKUP_ENCRYPTED``), so verrät ein solches Setup immernoch
  sehr viel über den Host: welche Software auf ihm läuft, wie diese
  konfiguriert ist und wo sich evtl. Schwachstellen auftun, die man
  ausnutzen könnte.

Protokollierung der Systemeigenschaften
=======================================

Mit dem Skript ``log_sysinfo.sh`` können diverse Infos zum System
ermittelt werden::

  $ sudo CONFIG=/my/repo/$(hostname) ./scripts/backup_config.sh

Obiger Aufruf legt thematisch sortiert Dateien in dem Ordner::

  /my/repo/$(hostname)_sysinfo/

an. Z.B. wird für jede Festplatte eine Protokolldatei mit performance
Messungen und SMART Werten erzeugt und es werden Dateien mit den
Ausgaben zu ``lshw``, ``lsusb``, ``lspci`` und zum X-Display
(``xrander``) angelegt.

Ich versioniere diese Protokolldateien ebenfalls mit, so kann ich
Veränderungen am System über die Zeit beobachten.
