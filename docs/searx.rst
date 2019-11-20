.. -*- coding: utf-8; mode: rst -*-

.. include:: searx_refs.txt
.. include:: apache_setup_refs.txt

.. _xref_searx:

==================
searx Suchmaschine
==================

.. sidebar:: install: searX

   Wer keine Instanz selber aufbauen will kann sich aus den Searx-instances_
   welche aussuchen oder die von Kutz nehmen: kuketz-suche.de_

   .. code-block:: bash

      $ sudo -H ./searx.sh install server

searX_ ist eine kostenlose Internet-Metasuchmaschine, die Ergebnisse von mehr
als 70 Suchdiensten zusammenfasst.  Die Benutzer werden weder verfolgt noch wird
ein Profil von ihnen erstellt.  Es gibt Instanzen im internet (`Public searX
instances <https://github.com/asciimoo/searx/wiki/Searx-instances>`_),
Alternativ kann man sich auch eine eigene (*self hosted*) Instanz aufsetzen.

.. _searX-Doku: https://asciimoo.github.io/searx/dev/install/installation.html#with-apache

Die hier gezeigte Installation erfolgt unter der URL ``https://<host>/searx``
auf einem Apache Server und wird u.A. im Kaptitel 'with apache' in der
searX-Doku_ beschrieben.  Zur Installation existiert das Skript ``searx.sh``,
das alle Setups vornimmt.  Das Skript legt folgende Umgebungen fest:

.. code-block:: bash

   SEARX_USER=searx
   SEARX_HOME="/home/$SEARX_USER"
   SEARX_VENV="${SEARX_HOME}/searx-venv"
   SEARX_REPO_FOLDER="${SEARX_HOME}/searx-src"
   SEARX_SETTINGS="${SEARX_REPO_FOLDER}/searx/settings.yml"

   # Apache Settings
   SEARX_APACHE_DOMAIN="$(uname -n)"
   SEARX_APACHE_URL="/searx"
   SEARX_APACHE_SITE=searx

   # uWSGI Settings
   SEARX_UWSGI_APP=searx.ini

Für eine Installation führt das Skript (in etwa) folgende Schritte aus:

#. Es werden die erforderlichen Ubuntu/Debian Pakete für Apache und Python3
   installiert.  Das Paket :deb:`libapache2-mod-uwsgi` installiert uWSGI_ für
   Apache (s.a.  uWSGI-github_, :deb:`uwsgi` und :deb:`uwsgi-plugin-python3`):

   .. code-block:: bash

      sudo -H apt install \
           libapache2-mod-uwsgi uwsgi uwsgi-plugin-python3 \
           git build-essential libxslt-dev python3-dev python3-babel zlib1g-dev \
           libffi-dev libssl-dev

#. Es wird der Benutzer ``searx`` angelegt.  Sein ``$HOME`` ist ``/home/searx``
   und in diesen Ordner wird alles weitere installiert:

   .. code-block:: bash

     sudo -H adduser \
          --disabled-password --gecos 'searX' \
          --home $SEARX_HOME $SEARX_USER

#. Es wird ein Clone der Sourcen erstellt (Benutzer ist ``searx`` in
   ``/home/searx`` auf Host ``searx-server``):

   .. code-block:: bash

     sudo -u searx -i   # searx@searx-server
     $ cd ${SEARX_HOME}
     $ git clone https://github.com/asciimoo/searx.git searx-src

#. Es wird eine virtuelle Python Umgebung eingerichtet:

   .. code-block:: bash

     sudo -u searx -i   # searx@searx-server
     $ python3 -m venv ${SEARX_VENV}

#. In der Umgebung werden die für searX erforderlichen Python Pakete
   installiert:

   .. code-block:: bash

     sudo -u searx -i   # searx@searx-server
     $ source ${SEARX_VENV}/bin/activate
     (searx-venv) $ cd $HOME/searx-src
     (searx-venv) $ ./manage.sh update_packages

#. searX Konfiguration:

   a. Es wird die searX Konfiguration
      :origin:`/home/searx/searx-src/searx/settings.yml
      <templates/home/searx/searx-src/searx/settings.yml>` eingespielt.

   b. Anlegen eines Schlüssels. :

   .. code-block:: bash

      (searx-venv) $ cd $HOME/searx-src
      (searx-venv) $ sed -i -e "s/ultrasecretkey/`openssl rand -hex 16`/g" searx/settings.yml

#. Es wird ein rudimentärer Test der searX-Installation durchgeführt.:

   .. code-block:: bash

     (searx-venv) $ timeout 300 python3 searx/webapp.py &
     (searx-venv) $ xgd-open http://127.0.0.1:8888/

#. Es wird die uWSGI Konfiguration für die :origin:`searx App
   <templates/etc/uwsgi/apps-available/searx.ini>` installiert und aktiviert:

   .. code-block:: bash

     cd /etc/uwsgi/apps-enabled
     sudo -H ln -s ../apps-available/searx.ini

#. Es wird die Apache Site :origin:`/etc/apache2/sites-available/searx.conf
   <templates/etc/apache2/sites-available/searx.conf>` eingerichtet:

   .. code-block:: bash

     sudo -H a2ensite -q searx
     sudo -H apachectl configtest
     sudo -H service apache2 force-reload

#. Es wird die Verfügbarkeit über den Apache Server geprüft:

   .. code-block:: bash

      curl --location --head --insecure https://${SEARX_APACHE_DOMAIN}${SEARX_APACHE_URL}
