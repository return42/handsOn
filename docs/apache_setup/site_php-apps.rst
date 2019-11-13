.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_site_phpapps:

================================================================================
                                PHP Anwendungen
================================================================================

Es wird eine Konfiguration eingerichtet, über welche es möglich ist PHP
Anwendungen zu betreiben. Eine kleines *HelloWorld* Beispiel wird ebenfalls mit
installiert.

Installation
============

.. code-block:: bash

   $ ${SCRIPT_FOLDER}/apache_setup.sh installPHP

Mit dem Kommando ``installPHP`` werden die folgenden Schritte ausgeführt.

* Es werden die erforderlichen Pakete für PHP (:deb:`php`,
  :deb:`libapache2-mod-php`) und PHP-sqlite (:deb:`php-sqlite3`) installiert.

* Es wird der Ordner ``/var/www/phpApps`` eingerichtet, in dem PHP Anwendungen
  abgelegt werden können (:ref:`xref_php_apps_conf`).

.. code-block:: bash

   $ apt-get install php php-sqlite libapache2-mod-php
   $ sudo -H mkdir /var/www/phpApps

   $ sudo -H a2ensite php-apps
   $ sudo -H service apache2 reload

* Es wird eine Test-Seite ( https://localhost/hello.php ) eingrichtet
  (:ref:`xref_php_apps_hello_php`).

.. code-block:: bash

   $ sudo -H ap2ensite hello_php
   $ sudo -H service apache2 reload

De-Installation
===============

.. code-block:: bash

   $ ${SCRIPT_FOLDER}/apache_setup.sh deinstallPHP

Anmerkungen
===========

* `PHP Sicherheitshinweise`_
* `PHP Laufzeiteinstellungen`_

Mit dem Paket :deb:`libapache2-mod-php` wird das ``php`` Modul installiert,
siehe dazu auch: `PHP Debian GNU/Linux-Installationshinweise
<http://php.net/manual/de/install.unix.debian.php>`_. Zu der Installation
gehören die INI-Dateien::

   /etc/php/7.0
   ├── apache2
   │   ├── conf.d
   ...............
   │   │   └── 20-sqlite3.ini -> ../../mods-available/sqlite3.ini
   │   └── php.ini
   ├── cli
   │   ├── conf.d
   ...............
   │   │   └── 20-sqlite3.ini -> ../../mods-available/sqlite3.ini
   │   └── php.ini
   └── mods-available
       ...........
       └── sqlite3.ini

In der Datei ``/etc/php/7.0/apache2/php.ini`` kann die PHP Laufzeitumgebung der
Apache Prozesse eingestellt werden (`PHP Laufzeiteinstellungen`_).

In der Datei ``/etc/apache2/mods-available/php7.0.conf`` ist die default
Konfiguration des PHP-Moduls zu finden:

.. code-block:: apache

   <FilesMatch ".+\.ph(p[345]?|t|tml)$">
       SetHandler application/x-httpd-php
   </FilesMatch>
   <FilesMatch ".+\.phps$">
       SetHandler application/x-httpd-php-source
       # Deny access to raw php sources by default
       # To re-enable it's recommended to enable access to the files
       # only in specific virtual host or directory
       Require all denied
   </FilesMatch>
   # Deny access to files without filename (e.g. '.php')
   <FilesMatch "^\.ph(p[345]?|t|tml|ps)$">
       Require all denied
   </FilesMatch>

   <IfModule mod_userdir.c>
       <Directory /home/*/public_html>
           php_admin_flag engine Off
       </Directory>
   </IfModule>


.. _xref_php_apps_conf:

php-apps.conf
=============

Die folgende ``php-apps.conf`` Site, richtet eine Umgebung ein, in der
PHP-Anwendungen betrieben werden können.

.. code-block:: apache

   <IfModule mod_php7.c>
       <Directory /var/www/phpApps/>
           ...
           php_value open_basedir /var/www/phpApps/
           ...
       </Directory>
    </IfModule>

Mit ``php_value`` können die INI-Werte gesetzt werden, z.B. das `open_basedir
<http://php.net/manual/de/ini.core.php#ini.open-basedir>`_. Eine Auflistung
aller Optionen findet sich in der `Liste der php.ini-Direktiven
<http://php.net/manual/de/ini.list.php>`_.

.. _xref_php_apps_hello_php:

PHP-Test Anwendung
===================

Die Test-Site sollte nur in einer Entwickler-Umgebung installiert werden. Sie
besteht aus nur einer Datei ``/var/www/phpApps/helloWorld/index.php``.

.. code-block:: php

   <?php phpinfo(); ?>

Das ``hello.php`` Skript sollte in keinem Fall im Internet aktiviert werden, da
es mit dem darin enthaltenen ``phpinfo()`` zu viel über den Server *verrät* und
einem potentiellen Angreifer evtl. schon erste Hinweise für ein geeignetes
Angriffszenario gibt.

Die Installation erfolgte in den ``/var/www/phpApps`` Ordner. Für den bereits
oben in der :ref:`xref_php_apps_conf` die allgemeinen PHP Direktiven gesetzt
wurden. Die ``hello_php`` Site definiert nur noch den Alias, damit die Site
unter der URL https://localhost/hello.php angeboten wird.

.. code-block:: apache

   <IfModule mod_php7.c>
       Alias /hello.php /var/www/phpApps/helloWorld/index.php
   </IfModule>


