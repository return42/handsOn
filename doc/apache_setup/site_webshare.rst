.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_site_webshare:

================================================================================
                                 Apache WebDAV
================================================================================

Die Site ``webShare.conf`` ist eine exemplarische Anwendung, bei der ein Ordner
aus dem Dateisystem via `WebDAV (wiki)`_ exportiert wird. Anwendungsbeispiele
finden sich im Abschnitt :ref:`xref_webdav_clients`.

.. hint::

   `WebDAV (wiki)`_ und `CalDAV (wiki)`_ dürfen an dieser Stelle nicht
   verwechselt werden.Hier wird (nur) **WebDAV** eingerichtet!

   * `CalDAV (wiki)`_ ist eine *Calendaring Extensions to WebDAV* siehe :rfc:`4791`.

   * Bezüglich einer geeigneten Server Implementierung sollte ggf. `Comparision
     of CalDAV & CardDAV Server (wiki)
     <https://en.wikipedia.org/wiki/Comparison_of_CalDAV_and_CardDAV_implementations#Server_implementations>`_
     konsultiert werden.

Die Konfiguration legt den Ordner ``/share/WEBSHARE`` an und stellt ihn über
https://localhost/WEBSHARE ins Netz. Für die Freigabe wird das `Apache mod_dav`_
Modul und das `Apache mod_dav_fs`_ Modul aktiviert.

.. code-block:: bash

   sudo mkdir -p /share/WEBSHARE
   sudo chown -R www-data:www-data /share/WEBSHARE
   sudo a2enmod dav dav_fs
   sudo a2ensite webShare
   sudo service apache2 reload

Site webShare
=============

Die Site ``webShare.conf`` definiert die Directory Resource ``/share/WEBSHARE``
und setzt den Alias ``/WEBSHARE`` auf diese Resource (vergleiche
:ref:`xref-allias-directive`).

.. code-block:: apache

   Alias /WEBSHARE  /share/WEBSHARE

   <Directory /share/WEBSHARE>

       DAV on
       SSLRequireSSL

       Require valid-user

       AuthType Basic
       AuthBasicProvider external
       AuthName "webShare"
       AuthExternal pwauth
   ...

Der Zugriff soll nur angemeldeten Benutzner möglich sein (s.a.
:ref:`xref_apache-auth`), was über die `Apache Require Direktive`_ ``Require
valid-user`` gesetzt wird.  Zur Benutzeridentifizierung (Anmeldung) wird das
`Apache mod_authnz_external`_ Modul verwendet, dass mit der
:ref:`xref_mod_authnz_external` aktiviert wurde (näheres zum Anmeldevorgang
siehe dort).

Der Zugriff auf den ``WEBSHARE`` Ordner:

* Soll nur aus dem lokalen Netzt möglich sein (:ref:`xref-allow-directive`).
* Es soll keine Anpassung der Optionen durch ``.htaccess`` Dateien möglich sein (:ref:`xref-allowoverride-directive`)
* Es soll der *Autindex* für diese Ordnerstruktur eingeschaltet werden (:ref:`xref_autoindex_directories`).
* Suchmaschinen sollen den Content nicht indizieren (:ref:`xref_global_http_headers`).

.. code-block:: apache

   ...
       Order deny,allow
       Deny from all
       Allow from fd00::/8 192.168.0.0/16 fe80::/10 127.0.0.0/8 ::1
       AllowOverride None
   ...

Mit der oben gezeigten Konfiguration wird das DAV Protokoll aktiviert, es wird
nur verschlüsselt kommuniziert, es ist ein Login erforderlich und es sind nur
Zugriffe aus den Link-Local Netzen gestattet. Navigiert man die Resource mit dem
WEB-Browser an, dann soll ein *Autoindex* angezeigt werden. In dem Kontext der
Resource wird deshalb noch der *Autoindex* eingeschaltet, der die Header/Readme
Datei aus dem chrome-Ordner verwenden soll (vergleiche
:ref:`xref_server_side_include`):

.. code-block:: apache

   ...
        Options +Indexes +FollowSymLinks

        HeaderName /chrome/header.shtml
        ReadmeName /chrome/footer.shtml
   ...

Da dieser Bereich eher *private* ist, soll er auch nicht von einem Robot
gescannt werden (vergleiche :ref:`xref_global_http_headers`)

.. code-block:: apache

   ...
       <IfModule mod_headers.c>
           Header always set X-Robots-Tag "none"
       </IfModule>
   </Directory>

.. todo::

   Die Refresh-Rate sollte noch in den HTTP-Headern eingestellt werden
   können. Mir scheint, das manche Clients diese Refresh-Zeiten verwenden.
   Z.B. Outlook scheint seine Refreshrate zur Veröffentlichung eines Kalenders
   danach einzustellen (die Wiederholrate zum Upload/Update des Kalenders auf
   den Share .. so ganz sicher bin ich mir da aber auch nicht).


Hinweise
=========

Ein webDAV Server sollte besser nur im eigenem Subnet betrieben werden und nicht
ohne weitere Sicherheitsmaßnahmen ins Internet gestellt werden. Eine zusätzliche
Sicherheitsmaßnahme kann z.B. das Einrichten des Apache
:ref:`xref_mod_security2` Moduls sein.  Wobei auch angemerkt werden muss, dass
durch DAV Anwendungen die *False Positive* einer solchen WAF unter umständen
zunehmen können.

Eine Deinstallation der ``webShare``-Site kann mit folgenden Kommandos erreicht
werden:

.. code-block:: bash

   sudo a2dissite webShare
   sudo a2dismod dav dav_fs
   sudo service apache2 reload





