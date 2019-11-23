.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_site_pyapps:

================================================================================
                                WSGI Anwendungen
================================================================================

Es wird eine Konfiguration eingerichtet, über welche es möglich ist WSGI
(Python) Anwendungen zu betreiben. Eine kleines *HelloWorld* Beispiel wird
ebenfalls mit installiert.

Installation
============

.. code-block:: bash

   $ ${SCRIPT_FOLDER}/apache_setup.sh installWSGI

Mit dem Kommando ``installWSGI`` werden die folgenden Schritte ausgeführt.

* Es wird `Apache mod_wsgi`_ installiert (`mod_wsgi RTD`_)

* Es wird der Ordner ``/var/www/pyApps`` eingerichtet, in dem Python WSGI
  Anwendungen abgelegt werden können.

.. code-block:: bash

   $ apt-get install libapache2-mod-wsgi-py3 python-imaging virtualenv
   $ cd /etc/apache2/mods-available/
   $ sudo -H mv wsgi.conf     wsgi.conf-disabled
   $ sudo -H mkdir /var/www/pyApps

* Es wird eine virtuelle Python Umgebung (``pyenv``) in dem Ordner
  ``/var/www/pyApps`` eingerichtet.

* In die virtuelle Python Umgebung werden (via pip) verschiedene Python Module
  vorinstalliert (sollte nicht ohne weiteres ins Internet gestellt werden).

.. code-block:: bash

   $ cd /var/www/pyApps
   $ sudo -H virtualenv "pyenv" --prompt="pyenv"
   $ cd /var/www/pyApps/pyenv
   $ source bin/activate
   $ pip completion --bash | sudo -H tee /etc/bash_completion.d/pip > /dev/null
   $ pip install docutils Jinja2 Pygments Sphinx Flask Werkzeug pylint \
                 pyratemp pyudev psutil sqlalchemy babel simplejson

   $ sudo -H a2ensite py-apps
   $ sudo -H service apache2 reload

* Es wird eine Test-Seite ( https://localhost/hello.py ) eingrichtet.

.. code-block:: bash

   $ sudo -H ap2ensite hello_py
   $ sudo -H service apache2 reload

De-Installation
===============

.. code-block:: bash

   $ ${SCRIPT_FOLDER}/apache_setup.sh deinstallWSGI

Anmerkungen
===========

Das WSGI-Modul war mal ein Projekt auf google-code, ein paar Sachen kann man
immernoch dort nachlesen z.B.

* Simplified GIL State: https://code.google.com/p/modwsgi/wiki/ApplicationIssues#Python_Simplified_GIL_State_API

Inzwischen wird das WSGI-Modul auf github gehostet und weiterentwickelt.  In dem
Github Projekt wird auch vieles aufgeräumt:

* Eine aktuelle Doku gibt es bei *Read The Docs* `mod_wsgi RTD`_
* Das Reposetory bei github ist `Apache mod_wsgi`_
* Hardening Aspekte ????

.. _xref_site_py_apps_conf:

py-apps.conf
============

Die folgende ``py-apps.conf`` Site, richtet eine Umgebung ein, in der
WSGI-Anwendungen betrieben werden können. Die Python-Prozesse laufen in einer
virtuellen-Python Umgebung, die über die Direktive ``WSGIPythonHome`` gesetzt
wird. Es wird mit der Direktive ``WSGIDaemonProcess`` die Prozessgruppe
``pyApps`` eingerichtet. Die ``WSGI....`` Direktieven sind in der `mod_wsgi RTD
Konfiguration`_ beschrieben.

.. code-block:: apache

   <IfModule mod_wsgi.c>

       # Die Prozesse laufen in einer VirtualEnv Umgebung
       WSGIPythonHome  /var/www/pyApps/pyenv

       # Die Prozessgruppe pyApps für diese Python-Anwendungen
       WSGIDaemonProcess pyApps \
           user=www-data group=nogroup \
           processes=2 threads=5 maximum-requests=5
   ...

In der Konfiguration wird eine Prozessgruppe ``pyApps`` eingerichtet, deren
Prozesse unter dem Apache-Account ``www-data`` (und ``nogroup``) laufen. Diese
Prozessgruppe ``pyApps`` wird nun in der Resource ``/var/www/pyApps`` genutzt.

.. code-block:: apache

   ...
       <Directory /var/www/pyApps>
           WSGIProcessGroup pyApps
           WSGIApplicationGroup %{GLOBAL}

       </Directory>

   </IfModule>

.. todo::

   Da ich nicht davon ausgehen kann, dass alle Python Module die eine WSGI
   Anwendungen nutzt auch Thread-safty sind setze ich meine WSGI Anwendungen
   immer in die `WSGIApplicationGroup`_ ``%{GLOBAL}``. Nähers zu dem Thema gibt
   der Beitrag `Python Simplified GIL State API`_.  Ich bin allerdings auch
   immer etwas verunsichert, weil mir nicht ganz klar ist, wie die Anordnung der
   Prozesse und Threads bei ``%{GLOBAL}`` nun genau ist (hängt vermutlich auch
   von anderen Faktoren ab?) und ob es Sinn macht bei ``%{GLOBAL}`` mehr als
   einen Thread zu definieren.


WSGI-Test Anwendung
===================

Die Test-Site sollte nur in einer Entwickler-Umgebung installiert werden. Sie
besteht aus nur einer Datei ``/var/www/pyApps/helloWorld/index.wsgi``.

.. code-block:: python

   import os, sys, urlparse, traceback, pprint, urlparse, pwd

   def application(environ, start_response):

       status = '200 OK'
       o = 'WSGI: It works!  :-)'
       try:
           o += '\nprocess id:        '   + str(os.getpid())
           o += '\nparent process:    '   + str(os.getppid())
           o += '\nuser/group:        '   + "%s/%s (%s/%s)" % (os.getuid(), os.getgid(), os.geteuid(), os.getegid())
           o += '\npwd user:          '   + pprint.pformat(pwd.getpwuid(os.getuid()))
        ...o += '\nWSGI environment:\n'   + pprint.pformat(environ, indent=4)
           o += '\nQuery String:\n'       + pprint.pformat(urlparse.parse_qs(environ['QUERY_STRING']), indent=4)
        ...o += '\nPython version:    '   + pprint.pformat(sys.version)
        ...
       except:
           o += "\n\n" + traceback.format_exc()

       response_headers = [
           ( 'Content-type', 'text/plain')
           , ( 'Content-Length', str(len(o)))
       ]

       start_response(status, response_headers)
       return [o]


Die Installation erfolgte in den ``/var/www/pyApps`` Ordner. Für den bereits
oben in der ``py-apps.conf`` die virtuelle Python Umgebung ``WSGIPythonHome
/var/www/pyApps/pyenv`` und die ``WSGIDaemonProcess pyApps`` definiert
wurden. Die ``hello_py`` Site definiert nur noch den Alias, damit die Site unter
der URL https://localhost/hello.py angeboten wird.

.. code-block:: apache

   <IfModule mod_wsgi.c>
       WSGIScriptAlias /hello.py /var/www/pyApps/helloWorld/index.wsgi
   </IfModule>


