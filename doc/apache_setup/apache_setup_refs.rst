.. -*- coding: utf-8; mode: rst -*-

.. _xref_apache_setup_refs:

================================================================================
                                    Verweise
================================================================================

.. todo::

   Weiterführende Themen rund um den Apache WEB-Server:

     * http://xmodulo.com/secure-apache-webserver-ubuntu.html
     * https://httpd.apache.org/docs/current/mod/mod_deflate.html
     * https://httpd.apache.org/docs/current/mod/mod_filter.html
     * https://httpd.apache.org/docs/current/mod/mod_mime.html
     * https://httpd.apache.org/docs/current/mod/mod_ssl.html
     * https://httpd.apache.org/docs/current/mod/mod_status.html
     * https://httpd.apache.org/docs/current/mod/mod_unique_id.html



Apache
======

.. _`Apache Software Foundation`: https://de.wikipedia.org/wiki/Apache_Software_Foundation
.. _`Apache httpd SVN`: http://svn.apache.org/viewvc/httpd/
.. _`Apache Tutorials (netnea.com)`: https://www.netnea.com/cms/apache-tutorials/

* `Apache Software Foundation`_
* `Apache httpd SVN`_
* Qualitativ sehr hochwertige `Apache Tutorials (netnea.com)`_

Apache Konfiguration
====================

.. _`/usr/share/doc/apache2/README.Debian.gz`: https://github.com/dcmorton/apache24-ubuntu/blob/master/debian/apache2.README.Debian

* `/usr/share/doc/apache2/README.Debian.gz`_

.. _`Apache Server-Wide Configuration`: https://httpd.apache.org/docs/current/server-wide.html
.. _`Apache Core Features`: https://httpd.apache.org/docs/current/mod/core.html
.. _`Apache Access Control`: https://httpd.apache.org/docs/current/howto/access.html
.. _`Apache mod_acces_compat`: https://httpd.apache.org/docs/current/mod/mod_access_compat.html
.. _`Apache mod_alias`: https://httpd.apache.org/docs/current/mod/mod_alias.html
.. _`Apache Kontexte (Sections)`: http://httpd.apache.org/docs/current/sections.html
.. _`Apache Options Direktive`: https://httpd.apache.org/docs/current/mod/core.html#options
.. _`Apache AllowOverride Direktive`: https://httpd.apache.org/docs/current/mod/core.html#allowoverride
.. _`Permanent Message Header Field Names (iana)`: http://www.iana.org/assignments/message-headers/message-headers.xml#perm-headers
.. _`Apache mod_headers`: https://httpd.apache.org/docs/current/mod/mod_headers.html
.. _`Apache mod_rewrite`: https://httpd.apache.org/docs/current/rewrite/
.. _`Apache mod_autoindex`: https://httpd.apache.org/docs/current/mod/mod_autoindex.html
.. _`Apache IndexOptions Direktive`: https://httpd.apache.org/docs/current/mod/mod_autoindex.html#indexoptions
.. _`Introduction to SSI`: http://httpd.apache.org/docs/current/howto/ssi.html

* `Apache Server-Wide Configuration`_
* `Apache Core Features`_
* `Apache Access Control`_ & `Apache mod_acces_compat`_
* `Apache mod_alias`_
* `Apache Kontexte (Sections)`_
* `Apache Options Direktive`_
* `Apache AllowOverride Direktive`_
* `Permanent Message Header Field Names (iana)`_ & `Apache mod_headers`_
* `Apache mod_rewrite`_
* `Apache mod_autoindex`_
* `Apache IndexOptions Direktive`_
* `Introduction to SSI`_

.. _`Apache mod_wsgi`: https://github.com/GrahamDumpleton/mod_wsgi
.. _`mod_wsgi RTD`: http://modwsgi.readthedocs.org/en/develop/index.html
.. _`mod_wsgi RTD Konfiguration`: http://modwsgi.readthedocs.org/en/develop/configuration.html
.. _`WSGIApplicationGroup`:  http://modwsgi.readthedocs.org/en/develop/configuration-directives/WSGIApplicationGroup.html
.. _`WSGIPassAuthorization`: http://modwsgi.readthedocs.org/en/develop/configuration-directives/WSGIPassAuthorization.html
.. _`Python Simplified GIL State API`: https://code.google.com/p/modwsgi/wiki/ApplicationIssues#Python_Simplified_GIL_State_API
.. _`Apache-MPM prefork`: https://httpd.apache.org/docs/current/de/mod/prefork.html

* `Apache mod_wsgi`_
* `mod_wsgi RTD`_
* `mod_wsgi RTD Konfiguration`_
* `WSGIApplicationGroup`_
* `WSGIPassAuthorization`_
* `Python Simplified GIL State API`_
* `Apache-MPM prefork`_

.. _`WebDAV (wiki)`: https://de.wikipedia.org/wiki/WebDAV
.. _`CalDAV (wiki)`: https://de.wikipedia.org/wiki/CalDAV
.. _`Apache mod_dav`: https://httpd.apache.org/docs/current/mod/mod_dav.html
.. _`Apache mod_dav_fs`: https://httpd.apache.org/docs/current/mod/mod_dav_fs.html

* `WebDAV (wiki)`_
* `Apache mod_dav`_ und `Apache mod_dav_fs`_

Autorisierung & Authentifizierung
=================================

.. _`Authentication and Authorization`: https://httpd.apache.org/docs/current/howto/auth.html

* `Authentication and Authorization`_

.. _`Autorisierung (wiki)`: https://de.wikipedia.org/wiki/Autorisierung

* `Autorisierung (wiki)`_

.. _`Apache mod_authz_host`:  https://httpd.apache.org/docs/current/mod/mod_authz_host.html
.. _`Apache Require Direktive`: https://httpd.apache.org/docs/current/mod/mod_authz_core.html#require
.. _`Apache AuthName Direktive`: https://httpd.apache.org/docs/current/mod/mod_authn_core.html#authname
.. _`Authentifizierung (wiki)`: https://de.wikipedia.org/wiki/Authentifizierung
.. _`HTTP-Authentifizierung (wiki)`: https://de.wikipedia.org/wiki/HTTP-Authentifizierung

* Autorisierung auf Basis *Herkunft* einer Anfrage: `Apache mod_authz_host`_
* Autorisierung auf Basis einer Authentifizierung `Apache Require Direktive`_
* `Apache AuthName Direktive`_
* `Authentifizierung (wiki)`_
* `HTTP-Authentifizierung (wiki)`_

.. _`Apache mod_authnz_external`: https://github.com/phokz/mod-auth-external/tree/master/mod_authnz_external
.. _`pwauth (github)`: https://github.com/phokz/pwauth/tree/master/pwauth
.. _`PAM (wiki)`: https://en.wikipedia.org/wiki/Pluggable_authentication_module
.. _`NSS PAM LDAP`: http://arthurdejong.org/nss-pam-ldapd

* Authentifizierung über `Apache mod_authnz_external`_ und `pwauth (github)`_.
* `PAM (wiki)`_
* `NSS PAM LDAP`_

Hardening & Test
================

.. _`Apache Security Tips`: https://httpd.apache.org/docs/current/misc/security_tips.html
.. _`ModSecurity`: http://modsecurity.org/about.html
.. _`OwnCloud: Serve security related Headers by the web server`: https://doc.owncloud.org/server/8.0/admin_manual/configuration_server/harden_server.html#serve-security-related-headers-by-the-web-server
.. _`WAF (wiki)`: https://de.wikipedia.org/wiki/Web_Application_Firewall
.. _`netfiltering.org`: http://www.netfilter.org
.. _`Nmap`: https://nmap.org/
.. _`Apache Bench (ab) timings explained visually`: https://blog.tom-fitzhenry.me.uk/2014/08/apache-bench-timings-visualised.html

* `Apache Security Tips`_
* `ModSecurity`_
* `OwnCloud: Serve security related Headers by the web server`_
* HTTP Filter: `WAF (wiki)`_
* IP Firewall: `netfiltering.org`_
* `Nmap`_ / "Network Mapper" is a ... utility for network discovery and security auditing.

ModSecurity & OWASP
===================

.. _`The Open Web Application Security Project (OWASP)`: https://www.owasp.org/index.php/Main_Page
.. _`OWASP ModSecurity Core Rule Set (CRS)`: http://spiderlabs.github.io/owasp-modsecurity-crs/
.. _`OWASP ModSecurity CRS (github)`: https://github.com/SpiderLabs/owasp-modsecurity-crs
.. _`OWASP ModSecurity Core Rules: Comparing 2.2.x and 3.0.0-dev`: https://www.netnea.com/cms/2015/12/20/modsec-crs-2-2-x-vs-3-0-0-dev/
.. _`Most Frequent False Positives Triggered by OWASP ModSecurity Core Rules 2.2.X`: https://www.netnea.com/cms/2016/01/17/most-frequent-false-positives-triggered-by-owasp-modsecurity-core-rules-2-2-x/
.. _`ModSecurity (github)`: https://github.com/SpiderLabs/ModSecurity
.. _`ModSecurity Direktiven`: https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual#Configuration_Directives
.. _`Apache Sicherheit (ubuntu)`: https://wiki.ubuntuusers.de/Apache/Sicherheit/
.. _`awesome-security.web`: https://github.com/sbilly/awesome-security#web

* `The Open Web Application Security Project (OWASP)`_
* `OWASP ModSecurity Core Rule Set (CRS)`_
* `OWASP ModSecurity CRS (github)`_
* `OWASP ModSecurity Core Rules: Comparing 2.2.x and 3.0.0-dev`_
* `Most Frequent False Positives Triggered by OWASP ModSecurity Core Rules 2.2.X`_
* `ModSecurity (github)`_
* `ModSecurity Direktiven`_
* `Apache Sicherheit (ubuntu)`_
* `awesome-security.web`_


Security Layer & Zertifikate
============================

.. _`Mozilla Included CA Certificate List`: https://wiki.mozilla.org/CA:IncludedCAs
.. _`CA (wiki)`: https://de.wikipedia.org/wiki/Zertifizierungsstelle
.. _`Fefe's Blog / Sun Oct 3 2010`: https://blog.fefe.de/?ts=b25933c5
.. _`letsencrypt.org`: https://letsencrypt.org/
.. _`Scope of Blacklists`: https://wiki.debian.org/SSLkeys#Scope_of_the_blacklists
.. _`Der kleine OpenSSL-Wegweiser (heise)`: http://www.heise.de/security/artikel/Der-kleine-OpenSSL-Wegweiser-270076.html

* `Mozilla Included CA Certificate List`_
* `CA (wiki)`_
* `Fefe's Blog / Sun Oct 3 2010`_
* `letsencrypt.org`_
* `Scope of Blacklists`_
* `Der kleine OpenSSL-Wegweiser (heise)`_


Netzwerk Infrastruktur
======================

.. _`Mac Adresse (wiki)`: https://de.wikipedia.org/wiki/MAC-Adresse
.. _`OUI Herstellerkennungen (wiki)`: https://de.wikipedia.org/wiki/MAC-Adresse#Herstellerkennungen

* `Mac Adresse (wiki)`_
* `OUI Herstellerkennungen (wiki)`_

.. _`ISP (wiki)`: https://de.wikipedia.org/wiki/Internetdienstanbieter
.. _`DHCP (wiki)`: https://de.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol
.. _`DNS (wiki)` : https://de.wikipedia.org/wiki/Domain_Name_System
.. _`NAT (wiki)`: https://en.wikipedia.org/wiki/Network_address_translation
.. _`Netzmaske (wiki)`: https://de.wikipedia.org/wiki/Netzmaske
.. _`private Adressbereiche (wiki)`: https://de.wikipedia.org/wiki/Private_IP-Adresse#Adressbereiche
.. _`RFC 1918: IPv4 Private Address Space`: https://tools.ietf.org/html/rfc1918#section-3
.. _`localhost (wiki)`: https://de.wikipedia.org/wiki/Localhost
.. _`CIDR`: https://de.wikipedia.org/wiki/Classless_Inter-Domain_Routing
.. _`Broadcast (wiki)`: https://de.wikipedia.org/wiki/Broadcast

* `ISP (wiki)`_
* `DHCP (wiki)`_
* `DNS (wiki)`_
* `NAT (wiki)`_
* `Netzmaske (wiki)`_
* `private Adressbereiche (wiki)`_
* `RFC 1918: IPv4 Private Address Space`_
* `localhost (wiki)`_
* *Classless Inter Domain Routing* `CIDR`_
* `Broadcast (wiki)`_

.. _`IPv6 Autokonfiguration (wiki)`: https://de.wikipedia.org/wiki/IPv6#Autokonfiguration
.. _`RFC 4862: IPv6 SLAAC`: https://tools.ietf.org/html/rfc4862
.. _`MAC address to IPv6 link-local address online converter`: http://ben.akrin.com/?p=1347
.. _`Reservierte und spezielle Adressbereiche im Internet-Protokoll Version 6 (heise Verlag)`: http://www.heise.de/netze/IPv6-Adressen-1386242.html
.. _`RFC 4291: IPv6 Addressing Architecture`: https://tools.ietf.org/html/rfc4291
.. _`RFC 4291: The Loopback Addresses`: https://tools.ietf.org/html/rfc4291#section-2.5.3
.. _`RFC 4291: Link-Local IPv6 Unicast Addresses`: https://tools.ietf.org/html/rfc4291#section-2.5.6
.. _`Link Local Adressen (wiki)`: https://de.wikipedia.org/wiki/IPv6#Link-Local-Adressen
.. _`RFC 4193: Unique Local IPv6 Unicast Addresses`: https://tools.ietf.org/html/rfc4193
.. _`RFC 4193: Local IPv6 Unicast Addresses`: https://tools.ietf.org/html/rfc4193#section-3
.. _`Unique Local Unicast (wiki)` : https://de.wikipedia.org/wiki/IPv6#Unique_Local_Unicast
.. _`DHCPv6 prefix delegation`: https://en.wikipedia.org/wiki/Prefix_delegation
.. _`RFC 3484: Source Address Selection`: https://tools.ietf.org/html/rfc3484#section-5
.. _`IPv6 Privacy Extensions (heise)`:  http://www.heise.de/netze/artikel/IPv6-Privacy-Extensions-einschalten-1204783.html

* `IPv6 Autokonfiguration (wiki)`_
* `RFC 4862: IPv6 SLAAC`_
* `MAC address to IPv6 link-local address online converter`_
* `Reservierte und spezielle Adressbereiche im Internet-Protokoll Version 6 (heise Verlag)`_
* `RFC 4291: IPv6 Addressing Architecture`_
* `RFC 4291: The Loopback Addresses`_
* `RFC 4291: Link-Local IPv6 Unicast Addresses`_
* `Link Local Adressen (wiki)`_
* ULA: `RFC 4193: Unique Local IPv6 Unicast Addresses`_
* Format der ULA: `RFC 4193: Local IPv6 Unicast Addresses`_
* `Unique Local Unicast (wiki)`_
* `DHCPv6 prefix delegation`_
* `RFC 3484: Source Address Selection`_
* `IPv6 Privacy Extensions (heise)`_

PHP
===

.. _`PHP Sicherheitshinweise`: http://php.net/manual/en/security.php
.. _`PHP Laufzeiteinstellungen`: http://php.net/manual/de/configuration.file.php

* `PHP Sicherheitshinweise`_
* `PHP Laufzeiteinstellungen`_

Datenbanken
===========

.. _`DB Browser for SQLite`: https://github.com/sqlitebrowser/sqlitebrowser
.. _`SQLite`: https://www.sqlite.org

* `DB Browser for SQLite`_
* `SQLite`_

Dateisysteme
============

.. _`Building A Linux Filesystem From An Ordinary File`: http://linuxgazette.net/109/chirico.html

* `Building A Linux Filesystem From An Ordinary File`_
