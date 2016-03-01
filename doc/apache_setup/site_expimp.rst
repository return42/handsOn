.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_site_expimp:

================================================================================
                                 Export/Import
================================================================================

Die Site ``exp-imp.conf`` soll einen Export/Import Ordner über den WEB-Server
bereit stelen. Ein Export/Import eigent sich recht gut, um den Anwendern (einer
geschlossenen Umgebung) Dateien über einen einfachen *public*-Kanal bereit zu
stellen.

Es wird ein Alias (siehe :ref:`xref-allias-directive`) gesetzt.

.. code-block:: apache

    Alias /EXPIMP /share/EXPIMP

    <Directory /share/EXPIMP>

        Require valid-user

        AuthType Basic
        AuthBasicProvider external
        AuthExternal pwauth
        AuthName "ExpImp"
    ...


Der Zugriff soll nur angemeldeten Benutzner möglich sein (s.a.
:ref:`xref_apache-auth`), was über die `Apache Require Direktive`_ ``Require
valid-user`` gesetzt wird.  Zur Benutzeridentifizierung (Anmeldung) wird das
`Apache mod_authnz_external`_ Modul verwendet, dass mit der
:ref:`xref_mod_authnz_external` aktiviert wurde (näheres zum Anmeldevorgang
siehe dort)..

Der Zugriff auf den Import/Export Ordner:

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

        Options +Indexes +FollowSymLinks

        HeaderName /chrome/header.shtml
        ReadmeName /chrome/footer.shtml

        <IfModule mod_headers.c>
            Header always set X-Robots-Tag "none"
        </IfModule>

   </Directory>

.. tip::

   Um schreibend auf den ExpImp-Ordner zuzugreifen, empfiehlt es sich, diesen
   Ordner noch zusätzlich via SMB und/oder WebDAV freizugeben (siehe auch
   :ref:`xref_site_webshare`).


