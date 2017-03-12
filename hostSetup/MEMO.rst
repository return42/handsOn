==============================================================================
MEMO: hostSetup
==============================================================================

In *diesem* Ordner (``./ hostSetup``) werden die Setups und Sicherungen der
Hosts hinterlegt.  Die Scripte in dem ``./scripts`` Ordner schauen bei der
Installation in *diesem* Ordner nach, ob sie hier Sicherungen der
Konfigurationsdateien finden. Wird zu einer Konfiguration eine Sicherung
gefunden, so wird diese mit in die Installation mit einbezogen.

Im Default ist für den Hostnamen ein Unterordner vorgesehen::

  ./hostSetup/$(hostname)

Will man einen anderen Ordner für die Setups verwenden, so muss man dies bei den
Kommandoaufrufen mit der Umgebungsvariablen `CONFIG`` angeben. Hat man ein
Setup, dass man auf allen Client-Hosts einspielen möchte, so eignet sich z.B.::

  CONFIG=/my/hostSetup/client_host ./info.sh

Alternativ kann in der Datei ``./scripts/setup.sh`` der Wert für ``CONFIG``
eingerichtet werden. Die Vor-Einstellungen für die Installationsscripte werden
aus der Datei::

  source ${CONFIG}_setup.sh

bezogen. Welche Umgebungsvariablen in der ``${CONFIG}_setup.sh`` gesetzt
werden können, ist in der ``setup.sh`` angegeben. Alternativ kann die
``example_setup.sh`` als Vorlage für einen Host genutzt werden::

  $ cp example_setup.sh /my/hostSetup/$(hostname)_setup.sh

Eine Sicherung der Konfigurationsdateien kann mit dem Backup-Script durchgeführt
werden::

  $ sudo ./scripts/backup_config.sh

Eine so erstellte Sicherung würde in dem default Ordner abgelegt werden::

  ./hostSetup/$(hostname)

Alternativ kann (wie oben) der Ordner für die Sicherung in der Kommandozeile mit
angegeben werden. Für die Client Hosts wäre dass dann wieder::

  $ sudo CONFIG=/my/hostSetup/client_host ./scripts/backup_config.sh
