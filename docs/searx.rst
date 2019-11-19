.. -*- coding: utf-8; mode: rst -*-

.. include:: searx_refs.txt
.. include:: apache_setup_refs.txt

.. _xref_searx:

==================
searx Suchmaschine
==================

.. sidebar:: ToDo

   Der Artikel befindet sich noch im Aufbau

Searx_ ist eine kostenlose Internet-Metasuchmaschine, die Ergebnisse von mehr
als 70 Suchdiensten zusammenfasst.  Die Benutzer werden weder verfolgt noch wird
ein Profil von ihnen erstellt.  Es gibt Instanzen im internet (`Public Searx
instances <https://github.com/asciimoo/searx/wiki/Searx-instances>`_),
Alternativ kann man sich auch eine eigene (*self hosted*) Instanz aufsetzen.

Die Installation hier erfolgt hinter der URL ``https://<hostname>/searx`` auf
einem Apache Server und wird u.A.  im Kaptitel 'with apache' in der `Searx Doku
<https://asciimoo.github.io/searx/dev/install/installation.html#with-apache>`_
beschrieben.  Zur Installation existiert ein Script, das alle Setups vornimmt::

   $ ${SCRIPT_FOLDER}/searx.sh install server

Im Einzelnen führt das Skript in etwa folgende Schritte aus:

#. Es werden die erforderlichen Pakete für Apache und Python installiert.  Das
   Paket :deb:`libapache2-mod-uwsgi` installiert uwsgi_ für Apcahe (s.a.
   uWSGI-github_, :deb:`uwsgi` und :deb:`uwsgi-plugin-python3`)::

     sudo -H apt install \
          libapache2-mod-uwsgi uwsgi uwsgi-plugin-python3 \
	  git build-essential libxslt-dev python3-dev python3-babel zlib1g-dev \
          libffi-dev libssl-dev

#. Es wird der Benutzer ``searx`` angelegt.  Sein ``$HOME`` ist ``/home/searx``
   und in diesen Ordner wird alles weitere installiert::

     sudo -H useradd $SEARX_USER -d $SEARX_HOME

#. Es wird ein Clone der Sourcen erstellt (Benutzer ist ``searx`` in
   ``/home/searx`` auf Host ``searx-server``)::

     searx@searx-server:
     $ cd $HOME
     $ git clone https://github.com/asciimoo/searx.git searx-src

#. Es wird eine virtuelle Python Umgebung eingerichtet::

     SEARX_VENV="$HOME/searx-venv"
     $ python3 -m venv ${SEARX_VENV}

#. In der Umgebung werden die für Searx erforderlichen Python Pakete
   installiert::

     $ source ${SEARX_VENV}/bin/activate
     (searx-venv) $ cd $HOME/searx-src
     (searx-venv) $ ./manage.sh update_packages

#. Searx Konfiguration:

   a. Anlegen eines Schlüssels. ::

      (searx-venv) $ cd $HOME/searx-src
      (searx-venv) $ sed -i -e "s/ultrasecretkey/`openssl rand -hex 16`/g" searx/settings.yml

#. Es wird ein rudimentärer Test der Searx-Installation durchgeführt.::

     (searx-venv) $ timeout 300 python3 searx/webapp.py &
     (searx-venv) $ xgd-open http://127.0.0.1:8888/

#. ToDo ..

..
   Apache Site :origin:`/etc/apache2/sites-available/searx.conf
   <templates/etc/apache2/sites-available/searx.conf>`::

     # ToDo ..

   searx.conf aktivieren::

     sudo -H a2ensite -q searx
     sudo -H apachectl configtest
     sudo -H service apache2 force-reload




