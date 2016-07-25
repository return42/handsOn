.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_serverwide_cfg:

================================================================================
                          Serverweite Konfigurationen
================================================================================

Das Basis Konfiguration umfasst:

* Konfiguration der Prozessumgebung der Apache-Serverprozesse.
* Konfiguration der *geöffneten* Ports.
* Serverweit einheitliche Einstellungen.
* Basiseinstellungen zur *Sicherheit* und ein einfaches Zugriffskonzept
* Rewrite um ``http`` Requests auf ``https`` (SSL) umzuleiten, so dass nur
  SSL-Anfragen möglich sind

Abschluss bildet ein einfacher Test der vorgenommenen Settings.

.. _xref_etc_apache2_envvars:

/etc/apache2/envvars
====================

Diese Datei ist ein Shell Skript in dem die Umgebung für :man:`apache2ctl`
eingestellt wird, dazu gehören auch die Benutzer- und Gruppenzugehörigkeit des
Apache WEB-Server Prozesses. Bei der Installation des :deb:`apache2` Pakets wurde
bereits ein Benutzer und eine Gruppe hierfür eingerichtet (``www-data``).

.. code-block:: bash

   export APACHE_RUN_USER=www-data
   export APACHE_RUN_GROUP=www-data

/etc/apache2/ports.conf
=======================

In der Konfigration werden die Ports 80 und 443 konfiguriert auf denen der
Apache Server *lauschen* soll.

.. code-block:: apache

   Listen 80
   <IfModule ssl_module>
       Listen 443
   </IfModule>


.. _xref_apache2_conf:

/etc/apache2/apache2.conf
=========================

In der Konfiguration wird die `Apache Server-Wide Configuration`_ vorgenommen, dazu
gehören beispielsweise ``ServerName``, ``ServerAdmin``, ``DocumentRoot`` (siehe
`Apache Core Features`_).

.. code-block:: apache

   ServerName server.example.com
   ServerAdmin noreply@mailinator.com
   DocumentRoot /var/www/html

Der Benutzer und die Gruppe des Serverprozess werden aus den Umgebungsvariablen
bezogen, die zuvor in der `/etc/apache2/envvars`_ eingerichtet wurden.

.. code-block:: apache

   # These need to be set in /etc/apache2/envvars
   User ${APACHE_RUN_USER}
   Group ${APACHE_RUN_GROUP}

Die ``apache2.conf`` Datei ist die *Hauptdatei* der Apache-Konfiguration, sie
lädt alle weiteren Konfigurationen nach (siehe auch `Apache Core Features`_):

.. code-block:: apache

  IncludeOptional mods-enabled/*.load
  IncludeOptional mods-enabled/*.conf
  ...
  Include ports.conf
  ...
  IncludeOptional conf-enabled/*.conf
  IncludeOptional sites-enabled/*.conf

.. _xref_conf_security:

/etc/apache2/conf-available/security.conf
=========================================

Konfiguration zur **Absicherung** des WEB-Servers. Abhänging vom *Anwendungs-
und Gefahrenkontext* sind die Anforderungen und Maßnahmen zur Absicherung ganz
individuell. Die in dieser Datei vorgenommenen Einstellungen relaiseren das in
Abschnitt :ref:`xref_setup_properties` vorgestellte Konzept:

* **alles dicht machen**

Diese Konfiguration muss ggf. angepasst werden. Erste Orientierung können die
`Apache Security Tips`_ geben. Die hier vorzunehmenden Einstellungen sind jedoch
nur die Grundlage zur *Absicherung* eines Apache Servers. In Abschnitt
:ref:`xref_mod_security2` wird der Aspekt der Sicherheit dann noch etwas tiefer
durchdrungen.

Die Konfigurationen in dieser ``security.conf`` finden im globalen Kontext
statt. Hierzu muss man wissen, dass die Apache Konfigurationen -- die
**Direktiven** genannt werden -- entweder auf den gesammten Server (globaler
Kontext) oder auf **Sections** angewendet werden können. Die Sections (Kontexte)
sind z.B. Ordner, also die Pfadnamen auf **Resourcen** aus dem Dateisystem. Es
gibt noch wesentlich mehr Kontexte, siehe `Apache Kontexte (Sections)`_.

Um bei dem Beispiel der Ordner eines Dateisystems zu bleiben: Wird
beispielsweise ein Ordner im Dateisystem als Resource definiert, so erfolgt
dies, indem eine *Directory-Section* (der Kontext) definiert wird. Die
Direktieven, die in diesem Kontext gesetzt werden vererben sich auf alle
Unterordner in dieser Resource. Die Vererbung erfolgt solange, bis ein
Unter-Ordner kommt, für den eine eigene *Directory-Section* definiert
wird. Dieser Kontext ist sozusagen ein Unterabschnitt des übergeordneten Ordners
/ dessen Kontext. Auch in diesem Kontext gelten noch die Direktieven des
übergeordneten Kontext, sie können dann aber angepasst werden. So wird
beispielsweise mit dem :ref:`xref_deny_from_root` Konzept der Root-Ordner als
Kontext eingerichtet der das gesammte Dateisystem einschliesst. Unter dem
Root-Ordner befinden sich bekanntlich alle Resourcen, die auf dem Dateisystem
(in der Root-Umgebung) existieren, auch die WEB-Anwendungen die man auf dem Host
installiert. Durch ein :ref:`xref_deny_from_root` schliesst man somit alle
Zugriffe auf die Resourcen aus dem Dateisystem aus. Zur Installation einer
WEB-Anwendung gehört, dass neben der Resource im Dateisystem noch ein Kontext im
Apache konfiguriertwerden muss. In dem (Unter-) Kontext muss dann der Zugriff
entsprechend der WEB-Anwendung eingeräumt werden, indem Vererbtes
*überschrieben* und/oder angepasst werden muss.

.. _xref_deny_from_root:

Deny from root
--------------

Das in diesem Setup vorgenommene Sicherheits-Konzept verhindert im globalen
Kontext den Zugriff auf das komplette Filesystem (von root an alles).

.. code-block:: apache

    <Directory />

        Require all denied

        Order Deny,Allow
        Deny from all
        AllowOverride None

        Options -ExecCGI -FollowSymLinks -Includes -Indexes
        DirectoryIndex index.htm index.html

    </Directory>

Mit ``Deny from all`` im Kontext des root-Ordners (``<Directory />``) wird der
Zugriff auf *jede* Resource (jeden Pfad) verweigert. Die Direktive ``Require all
denied`` in dem gleichen Kontext verweigert zusätzlich den Zugriff für
authentifizierte Benutzer. Das erscheint hier etwas *doppelt gemoppelt*, macht
aber Sinn, wenn man an die Vererbung (s.o.) denkt. Mit der `Apache Options
Direktive`_ gilt für alle unter root stehenden Ordner:

* Es werden keine CGI Programme ausgeführt
* Es werden keine symbolischen Links verfolgt.
* Die Server Side Includes (SSI) sind deaktiviert
* Der *Autoindex* ist abgeschaltet (:ref:`xref_autoindex_directories`)

Die oben gezeigten Direktieven *vererben* sich auf jede Resource unterhalb des
root-Ordners (also faktisch auf alle Resourcen).  Die WEB-Anwendungen (Sites)
müssen ihre Resourcen expliziet freigeben, dazu gehört auch das Setzen der
Optionen, soweit sie diese benötigen. Weiter unten wird dies beim Einrichten der
Sites dann deutlich.

.. _xref_security_limits_timeouts:

Request & Timeout
-----------------

Vorschläge für Requests und Timeouts:

.. code-block:: apache

   LimitRequestBody 13107200
   Timeout 300
   KeepAlive On
   MaxKeepAliveRequests 100
   KeepAliveTimeout 5

.. hint::

   Diese Einstellungen stehen ggf. in Konkurenz mit ModSecurity. Beispielsweise
   hat die Direktive ``LimitRequestBody`` das Pendant ``SecRequestBodyLimit`` im
   :ref:`xref_mod_security2` (siehe :ref:`xref_mod_security2_conf`).


.. _xref_global_http_headers:

HTTP-Headers
------------

In der ``security.conf`` werden auch die im globalen Kontext gültigen
HTTP-Header Felder definiert, die dem WEB-Browser übergeben werden. Das *Header*
Setup wurde an den Empfehlungen des OwnCloud Projekts angelehnt (*lesenswert*
`OwnCloud: Serve security related Headers by the web server`_). Zum Setzen der
HTTP-Header ist das `Apache mod_headers`_ Modul erforderlich die Registrierung
von Header Feldern erfolgt über die IANA (siehe `Permanent Message Header Field
Names (iana)`_).

.. code-block:: apache

   <IfModule mod_headers.c>

       Header always set Strict-Transport-Security "max-age=15768000; includeSubDomains; preload"
       Header always set X-Frame-Options "SAMEORIGIN"
       # Header always set X-Robots-Tag "none"

       Header set X-Content-Type-Options "nosniff"
       Header set X-XSS-Protection "1; mode=block"

   </IfModule>

Mit dem Feld ``X-Frame-Options: SAMEORIGIN`` wird der Browser angewiesen, die
WEB-Seite nicht in einen *fremden* Frame einzubetten. Mit dem Feld
``X-Robots-Tag: none`` können Suchmaschinen angewiesen werden, die *Seiten*
nicht zu indizieren. Will man, dass google & Co. den Content indizieren, so
sollte man den dieses Feld nicht serverweit, sondern im jeweiligen Kontext
setzen. Die :ref:`xref_static_content_chrome` ist ein Beispiel für einen
Content, der i.d.R nicht von einem *Robot* indiziert werden soll.

.. code-block:: apache

   <Directory /var/www/chrome>
        ...
        <IfModule mod_headers.c>
            Header always set X-Robots-Tag "none"
        </IfModule>
        ...
   </Directory>


.. hint::

   Die Auswertung der Header-Felder wird von den Browsern implementiert. Nicht
   alle WEB-Browser haben die gleichen Implementierungen oder finden zur
   gleichen Bewertung eines Felds. Es steht den Browesern frei ob und wie sie
   ein Header Feld bewerten.


SSL und Rewrite (``http://`` nach ``https://``)
===============================================

In der Datei ``/etc/apache2/sites-available/000-default.conf`` wird der
``<VirtualHost *:80>`` eingerichtet. Sofern ``mod_ssl`` installiert ist, werden
noch die Redirects nach ``https://`` konfiguriert (siehe `Apache mod_rewrite`_).

.. code-block:: apache

   <VirtualHost *:80>

       <IfModule mod_ssl.c>
        RewriteEngine   on
        RewriteRule     ^/(.*)$ https://%{SERVER_NAME}/$1 [L,R]
       </IfModule>
   ...
   </VirtualHost>

In der Datei ``/etc/apache2/sites-available/default-ssl.conf`` wird der Security
Layer (SSL) auf port 443 aktiviert und der Log-Level eingestellt:

.. code-block:: apache

   <IfModule mod_ssl.c>
       <VirtualHost _default_:443>

           LogLevel info ssl:warn
           CustomLog ${APACHE_LOG_DIR}/access.log combined
           ...
           SSLEngine on
           ...
           SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
           SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
           ...
       </VirtualHost>
   </IfModule>

In diesem Setup werden die selbst-signierten (*snakeoil*) Zertifikate verwendet
(siehe auch :ref:`xref_ssl_ca_remarks`).

.. _xref_mod_authnz_external:

/etc/apache2/conf-available/authnz_external.conf
================================================

Mit dem :deb:`libapache2-mod-authnz-external` Paket wurde das `Apache
mod_authnz_external`_ Modul installiert. Mit diesem Modul kann die
Benutzerauthentifizierung an ein externes Tool wie `pwauth (github)`_
durchgereicht werden. In der Standard Installation des
:deb:`libapache2-mod-authnz-external` Pakets ist dass Kommando :man:`pwauth`
vorgesehen, das auch in diesem Setup verwendet wird.

In der ``authnz_external.conf`` werden die folgenden Direktiven gesetzt.

.. code-block:: apache

   AddExternalAuth pwauth /usr/sbin/pwauth
   SetExternalAuthMethod pwauth pipe

Das Tool ``pwauth`` verwendet zur Autorisierung die Benutzer Logins und
Passwörter des Systems (PAM). Zu dem pwauth gehört noch ein PAM Setup
``/etc/pam.d/pwauth``::

  auth       requisite  pam_nologin.so

  # Standard Un*x authentication.
  @include common-auth

  # Standard Un*x account
  @include common-account


Will eine *Site* dieses Verfahren zur Authentifizierung nutzen, so kann sie dies
durch das Setzen der folgenden Direktiven.

.. code-block:: apache

   AuthType Basic
   AuthBasicProvider external
   AuthName "myAuthDomain Top Secret"
   AuthExternal pwauth

Mit der `Apache AuthName Direktive`_ wird die Resource einem Bereich
zugeordnet. Der Bezeichner des Bereichs (*realm*) wird an den WEB-Client gegeben
und dort im Anmeldedialog angezeigt, damit der Benutzer, das für diesen Bereich
richtige Passwort eingeben kann.

.. todo::

   Die Authentifizierung über ``pwauth`` und ``authnz_external`` ist zwar ganz
   praktisch, aber damit ist nur eine *Basic* `HTTP-Authentifizierung (wiki)`_
   möglich. Es sollte nochmal ein alternative Konzept vorgestellt werden
   (Schlagworte LDAP, mod_authn_file or mod_authn_dbm).

.. _xref_start_your_engines:

Gentleman, start your engines!
==============================

Nachdem Änderungen an der Konfiguration vorgenommen wurden, müssen diese in den
Apache-Server geladen werden. Bei so substantiellen Änderungen wie sie hier
vorgenommen wurden, sollte man satt nur den *Reload* zu machen besser einen
*Restart* vornehmen (s.a. :man:`apachectl`).

.. code-block:: bash

  sudo a2ensite 000-default.conf default-ssl.conf
  sudo a2enconf security authnz_external
  sudo service apache2 restart

  # bei kleineren Änderungen reicht ein Reload
  sudo service apache2 reload

Zum Testen des Redirects kann auf der Komandozeile das :man:`curl` Kommando
genutzt werden. Das ``curl`` Kommando eignet sich eigentlich zum Download von
Dateien von einem Server. Wenn man es auf *verbose* schaltet, dann kann man sehr
schön sehen, was Client (in dem Fall ``curl``) und Server (in dem Fall der
Apache-Prozess) so an HTTP Informationen austauschen und wie die ganze
Kommunikation aufgebaut wird. Folgende Optionen des ``curl`` werden verwendent:

* ``--verbose``  *gesprächige* Ausgabe
* ``--location`` folge Redirects
* ``--head``     tausche nur die HTTP-Header aus, der Content wird ignoriert
* ``--insecure`` keine Validierung von Zertifikaten

Der unten stehende Auszug zeigt, wie ``curl`` erst mal via ``http://`` auf Port
80 anfragt (Anfragen habe ein ``>`` als Präfix), dann aber ein ``HTTP 302``
Response vom Server erhält (Einkommendes hat das Präfix ``<``). Der ``302``
Response verweist auf die ``https://`` *Location*.

.. code-block:: none

   $ curl --location --verbose --head --insecure http://localhost 2>&1

   * Rebuilt URL to: http://ubuntu1504/
   *   Trying fd00::a00:27ff:fed5:7c85...
   * Connected to ubuntu1504 (fd00::a00:27ff:fed5:7c85) port 80 (#0)
   > HEAD / HTTP/1.1
   > Host: ubuntu1504
   > User-Agent: curl/7.43.0
   > Accept: */*
   >
   < HTTP/1.1 302 Found
   < Date: Thu, 11 Feb 2016 14:08:50 GMT
   < Server: Apache
   < Strict-Transport-Security: max-age=15768000; includeSubDomains; preload
   < X-Frame-Options: SAMEORIGIN
   < Location: https://ubuntu1504/
   < Content-Type: text/html; charset=iso-8859-1
   ...

Der obige Auszug zeigt auch, dass eine Verbindung über IPv6 hergestellt
wurde. Der Hostname ``ubuntu1504`` wurde vom DNS (hier nicht zu sehen, dass
passiert eine Ebene tiefer in der IP Schicht) in die IPv6 *Unique Local* Adresse
``fd00::a00:27ff:fed5:7c85`` aufgelößt. Diese IPv6 Adresse wird später bei der
Maskierung von Netzwerkadressen relevant werden, wenn Sites auf Basis der Host
IP autorisieren (s.a. :ref:`xref_excursion_IPv4_6`).

Weiter unten in der Ausgabe von ``curl`` ist dann auch zu sehen, wie ``curl``
auf die ``https://`` *Location* wechselt und seine Anfrage (Request) auf Port
443 wiederholt (``Issue another request ...``).

.. code-block:: none

   ...
   * Connection #0 to host ubuntu1504 left intact
   * Issue another request to this URL: 'https://ubuntu1504/'
   * Found bundle for host ubuntu1504: 0x55c61d8a92a0
   *   Trying fd00::a00:27ff:fed5:7c85...
   * Connected to ubuntu1504 (fd00::a00:27ff:fed5:7c85) port 443 (#1)
   ...

**CHECK: Redirect --> OK!**

Im weiteren Auszug (unten) ist auch zu sehen, dass TLS1.2 für die
Verschlüsselung gewählt wird. Man sieht auch, dass das selbstsignierte
Zertifikat, das der Server dem Client gegeben hat und das oben über die
Direktive:

.. code-block:: apache

   SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem

gesetzt wurde, nicht verifiziert wurde, Option ``--insecure``. Bei dieser Option
*SKIPPED* das ``curl`` die Verfikation über einen CA (s.a. Abschnitt
:ref:`xref_ssl_ca_remarks`). Desweiteren folgen dann noch Angaben zu dem
Zertifikat, z.B. das der *CommonName* lediglich aus dem Hostnamen besteht, dass
das Zertifikat noch gültig ist und das es einen öffentlichen RSA Schlüssel
besitzt.

.. code-block:: none

   ...
   * found 187 certificates in /etc/ssl/certs/ca-certificates.crt
   * found 755 certificates in /etc/ssl/certs
   * ALPN, offering http/1.1
   * SSL connection using TLS1.2 / ECDHE_RSA_AES_128_GCM_SHA256
   * 	 server certificate verification SKIPPED
   * 	 server certificate status verification SKIPPED
   * 	 common name: ubuntu1504 (matched)
   * 	 server certificate expiration date OK
   * 	 server certificate activation date OK
   * 	 certificate public key: RSA
   * 	 certificate version: #3
   * 	 subject: CN=ubuntu1504
   * 	 start date: Thu, 11 Feb 2016 14:04:03 GMT
   * 	 expire date: Sun, 08 Feb 2026 14:04:03 GMT
   * 	 issuer: CN=ubuntu1504
   * 	 compression: NULL
   * ALPN, server did not agree to a protocol
   ...

**CHECK: DSSL Setup --> OK!**

Nach den Angaben zur Verschlüsselung und dem Zertifikat ist dann im Weiteren zu
sehen, wie der HTTP-Request aussieht, den ``curl`` nun abschickt (wieder an dem
``>`` zu erkennen).

.. code-block:: none

   ...
   > HEAD / HTTP/1.1
   > Host: ubuntu1504
   > User-Agent: curl/7.43.0
   > Accept: */*scurl
   ...

Am Ende sieht man dann auch die Antwort (den Response) vom Server.

.. code-block:: none

   ...
   < HTTP/1.1 403 Forbidden
   < Date: Thu, 11 Feb 2016 14:08:50 GMT
   < Server: Apache
   < Strict-Transport-Security: max-age=15768000; includeSubDomains; preload
   < X-Frame-Options: SAMEORIGIN
   < Content-Type: text/html; charset=iso-8859-1
   ...

Der Server meldet dem Client, dass der Zugriff auf die URL
``https://ubuntu1504/`` nicht gestattet ist. Das entspricht dem
:ref:`xref_deny_from_root` Konzept von oben.  Erst wenn eine Site eingerichtet
wird und diese dann Resource frei gibt, kann ein Client auf diese zugreifen.

**CHECK: deny from root ... OK!**

An der Antwort des Servers (``<``) ist auch zu sehen, das die HTTP-Header-Felder
``Strict-Transport-Security`` und ``X-Frame-Options`` aus dem globalen Kontext
(vergleiche :ref:`xref_global_http_headers`) gesetzt wurden.

**CHECK: HTTP Header ... OK!**

Wie das Beispiel zeigt, ist es mit einfachen Werkzeug wie ``curl`` bereits
möglich einiges zu testen und über die Komunikation zw. Client und Server zu
erfahren. Zumindest so viel, dass es ausreicht alle in diesem Abschnitt
vorgenommen Einstellungen grob zu überprüfen. Oder anders formuliert, es sind
nicht immer die ganz großen Werkzeuge erforderlich, das Nötigste liegt den
meisten System schon anbei.

