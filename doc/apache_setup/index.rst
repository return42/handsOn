.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_apache_setup:

================================================================================
                           Setup Apache2 HTTP Server
================================================================================

Die Aufgabe des HTTP-Server ist es, Inhalte über HTTP auszuliefern. Diese als
Resourcen bezeichneten Inhalte können statische Dateien, ganze Ordnerstrukturen
oder aber auch WEB-Anwendungen sein. Um nicht zwischen statischen Dateien und
WEB-Anwendungen unterscheiden zu müssen wird fortan nur noch von
**WEB-Anwendungen** und **Resourcen** gesprochen. *Am Ende sind ja auch
statische Inhalte eine Anwendung und die Ordner im Dateisystem mit dem
statischen Content sind die Resource*. Als **Site** bezeichnet man die
Konfiguration mit der eine Resource über HTTP ausgeliefert werden soll.

Der Apache HTTP Server ist ein flexiebel einsetzbarer und mittels Module
erweiterbarer WEB-Server. Einige dieser Module werden -- wie der HTTP Server von
der `Apache Software Foundation`_ -- quelloffen (`Apache httpd SVN`_)
entwickelt. Andere Module gehören nicht zur Apach-Source, werden aber ebenfalls
quelloffen im Internet entwickelt (z.B. `Apache mod_authnz_external`_).

So flexibel wie der WEB-Server einsetzbar ist, so steil ist u.U. auch die
Lernkurve, die man nehmen muss, um ein *einfaches und griffiges* Setup für den
Apache WEB-Server aufzustellen. Die :ref:`xref_debian-apache` stellt ein Konzept
dar, auf dem auch dieses Setup aufbaut. Das hier vorgestellte Setup eignet sich
sehr gut für Intranet Anwendungen. Ein geradliniges Setup wie dies hier ist auch
die Grundlage für den sicheren Betrieb eines WEB-Servers im Internet. Auf einige
Sicherheitsaspekte wird auch eingegangen und soweit es den Apache Dienst angeht
werden diese auch umgesetzt.

Zu diesem Setup existiert ein Script, das alle Setups vornimmt:

.. code-block:: bash

   $ ${SCRIPT_FOLDER}/apache_setup.sh install

Das Setup besteht aus den folgenden Abschnitten:

.. toctree::
   :maxdepth: 1

   debian_apache
   setup_properties
   apache_auth
   dbp_apache_pkgs
   serverwide_cfg
   site_static-content
   site_html-intro
   mod_security2
   site_sysdoc
   site_expimp
   site_webshare
   site_py-apps
   site_php-apps
   probe_server
   webdav_clients
   apache_setup_refs

Die *Absicherung eines Hosts*, der ins Internet gestellt wird (auch *härten*
genannt) ist nicht Inhalt des hier vorgestellten Setups. Hier wird nur auf den
HTTP-Dienst des Apache und dessen Absicherung eingegangen.

.. caution::

  Neben den Anwendungen die über den Apache-Server bereit gestellt werden und
  die immer potentielle Schwachstellen mit sich bringen, gibt es auf dem Host --
  den man im Internet betreiben will -- meist noch andere Dienste (SMB, FTP
  usw.)  die ggf. *abgeschaltet*, deinstalliert oder ebenfalls *gehärtet* werden
  müssen. Hosts, die im Internet *stehen* sollten mit einer Firewall
  (Paketfilter) ausgestattet werden, wovon :man:`iptables` und *ipv6tables*
  wohl die bekanntesten Vertreter sind (siehe `netfiltering.org`_).

Nachdem nun geklärt ist, was nicht Inhalt dieses Setups ist, soll auf die
:ref:`xref_debian-apache` eingegangen werden. Diese Infrastruktur ist auch die
Basis des hier vorgestellten Konzepts.


