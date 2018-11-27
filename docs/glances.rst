.. -*- coding: utf-8; mode: rst -*-
.. _xref_glances:

==============================
Glances: an eye on your system
==============================

Glances_ ist ein Monitoring Tool dass sowohl auf der Kommandozeile als auch über
ein WEB-UI genutzt werden kann.  Es kann einzeln auf einem Host genutzt werden,
aber im Client/Server Betrieb auch im Verbund.

.. _Glances: https://nicolargo.github.io/glances/

Es wird in den Ubuntu/Debian Paketen (APT), angeboten, jedoch ist diese Version
i.d.R. veraltet, weshalb hier eine Installation der WEB-UI als Dienst aus den
`PyPi`_ Paketen vorgenommen wird.

Die hier vorgestellte Installation weist sich durch folgende besondere
Eigenschaften aus:

- Komplette Installation nach ``~glances``.

- Der Glances Server wird hinter einer (Apache-) URL
  ``https://<hostname>/glances`` betrieben.

Zur Installation existiert ein Script, das alle Setups vornimmt::

   $ ${SCRIPT_FOLDER}/glances.sh install server

Zur Wartung und Deinstallation bietet das Script weitere Kommandos an::

   $ ${SCRIPT_FOLDER}/glances.sh --help
   usage:
      glances.sh info
      glances.sh install    [server]
      glances.sh update     [server]
      glances.sh remove     [server]
      glances.sh activate   [server]
      glances.sh deactivate [server]

Im Einzelnen führt das KOmmando ``install server`` in etwa folgende Schritte
aus:

1. Es werden die minimal erforderlichen Systempakete (APT) installiert::

     sudo apt install virtualenv python3 python3-dev

2. Es wird der Benutzer ``$GLANCES_USER`` (``glances``) angelegt. Sein ``$HOME``
   ist ``/home/glances`` und in diesen Ordner wird alles weitere installiert.
   Hierzu gehört die Python-Umgebung (virtualenv in ``~/py3``) in der die Pakete
   ``glances`` und ``bottle`` installiert werden.

3. Die GLances Installation wird mit der Service-Unit_ Datei
   :origin:`/lib/systemd/system/glances.service <templates/lib/systemd/system/glances.service>`
   im systemd_ eingerichtet::

     sudo systemctl enable glances.service
     sudo systemctl restart glances.service

   Die Ersetzungen sind::

     # glances on localhost
     GLANCES_PORT=61208
     GLANCES_BIND=127.0.0.1

     # systemd services
     GLANCES_DESCRIPTION="Glances"
     GLANCES_SYSTEMD_UNIT=/lib/systemd/system/glances.service
     GLANCES_USER=glances
     GLANCES_HOME=/home/${GLANCES_USER}

4. Apache Site :origin:`/etc/apache2/sites-available/glances.conf
   <templates/etc/apache2/sites-available/glances.conf>` mit ProxyPass_
   einrichten. Ersetzungen::

     # Apache Redirect
     GLANCES_APACHE_URL="/glances"
     GLANCES_APACHE_SITE=glances

   Proxy und glances.conf aktivieren::

     sudo a2enmod proxy_http
     sudo a2ensite -q glances
     sudo apachectl configtest
     sudo service apache2 force-reload

Damit ist der Dienst (Glances WEB-UI) eingerichtet, er kann über die URL
https://myhostname/glances erreicht werden.  Die Refresh-Rate kann in Sekunden
angegeben werden (default 10).  Um z.B. alle 3 Sekunden zu aktualisieren::

  --> https://myhostname/glances/3

Die Spalten mit den Prozessen können sortiert werden, dazu mit der Maus auf
z.B. 'CPU' oder 'MEM%' klicken (nicht alle Spalten können sortiert werden).  Es
ist auch möglich eine Steuerung über die Tastatur vorzunehmen, eine Übersicht
gbt es mit der Taste 'h' (dazu mit der Maus vorher einmal in das Browser-Fenster
klicken um es zu aktivieren).

Für die Installation der Sensoren empfiehlt sich die Installation der Hardware
Tools (aber nicht auf einem V-Server)::

  sudo ${SCRIPT_FOLDER}/ubuntu_install_pkgs.sh hwTools




