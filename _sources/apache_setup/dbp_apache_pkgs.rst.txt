.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_dbp_apache_pkgs:

================================================================================
                                 Apache Pakete
================================================================================

Zum Setup gehört in erster Linie die Installation des Pakets mit dem Apache
WEB-Servers (:deb:`apache2`).  Neben der Installation des Apache-Pakets
empfiehlt sich die Installation folgender Pakete:

* :deb:`apache2-utils`

  Dieses Paket stellt Tools für die Wartung des Apache Servers zur Verfügung.

* :deb:`libapache2-mod-authnz-external`

  Das Pakete installiert das `Apache mod_authnz_external`_ Modul und
  pwauth(8). Es wird benötigt um eine (sichere) PAM-Authentifizierung zu
  realisieren. Damit können WebDAV und andere WEB-Anwendungen an die Logins und
  Passwörter des Systems (PAM) gebunden werden.

* :deb:`libapache2-modsecurity`

  `ModSecurity`_ ist *Monitoring-Tool* und ein *Filter* der die HTTP-Requests
  nach bekannten Exploits durchsucht. Man könnte es auch als HTTP Firewall
  bezeichnen, eine sogenannte `WAF (wiki)`_.

* :deb:`ssl-cert`:

  Stellt die Pakete für OpenSSL zur Verfügung

* :deb:`openssl-blacklist`

  Eine paar Tools und eine Datenbank zum Prüfen von SSL Schlüsseln. Siehe
  openssl-vulnkey(8) und `Der kleine OpenSSL-Wegweiser (heise)`_ (wird schon
  länger nicht mehr benötigt und ist seit Ubuntu 16.10 auch nicht mehr im APT
  Repository)

Installation der Pakete:

.. code-block:: bash

   sudo -H apt-get install \
                apache2 apache2-doc apache2-utils \
                ssl-cert openssl-blacklist \
                libapache2-mod-authnz-external pwauth \


Das :deb:`apache2` Paket bringt diverse Konfigurationen (Freigaben) und Module
mit sich, die für einen *Schnellstart* recht geeignet sind, die aber nicht so
ganz zur Philosophie *opt-in wird präferiert* passen. Soweit diese
Konfigurationen nicht gewollt sind, werden sie nun abgeschaltet.

.. code-block:: bash

   sudo -H a2dismod  cgi cgid
   sudo -H a2disconf apache2-doc serve-cgi-bin

   cd /etc/apache2/mods-available/

   sudo -H mv alias.conf     alias.conf-disabled
   sudo -H mv dir.conf       dir.conf-disabled
   sudo -H mv wsgi.conf      wsgi.conf-disabled

Nun werden noch die Module aktiviert, die in diesem Setup benötigt werden.

.. code-block:: bash

   sudo -H a2enmod alias authz_host ssl rewrite \
                headers env security2 auth_digest \
                authn_core authnz_external
