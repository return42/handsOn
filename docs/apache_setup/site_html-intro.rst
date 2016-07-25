.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_site_html-intro:

================================================================================
                                HTML Startseite
================================================================================

In der :ref:`xref_apache2_conf` wurde die Direktive ``DocumentRoot`` (siehe
`Apache Core Features`_) auf ``/var/www/html`` gesetzt. Das ``DocumentRoot`` ist
das Haptverzeichniss, von dem an der Apache *Content* ausliefert. Andere
Resourcen müssen über die ``Alias`` Direktive referenziert werden.  In diesem
Setup wird eine einfache HTML-Startseite installiert.  Diese Startseite stellt
Verweise auf die Anwendungen zur Verfügung, die mit diesem Setup installiert
werden. Die Installation erfolgt nach ``DocumentRoot``.

.. code-block:: bash

   sudo cp -R TEMPLATE/var/www/html /var/www
   sudo a2ensite html-intro

Die Site ``html-intro.conf`` definiert die Directory Resource
``/var/www/html``. Für die Site ist keine :ref:`xref_apache-auth` erforderlich,
was über die Direktive ``Require all granted`` gesetzt wird.  Die ``Allow``,
``Order`` und ``Deny`` Direktiven werden so gesetzt, dass der Zugriff auf diesen
HTML Content von überall aus erlaubt ist (vergleiche
:ref:`xref-allow-directive`). Es werden keine lokalen Options unterstützt, siehe
:ref:`xref-allowoverride-directive`.

.. code-block:: apache

   <Directory /var/www/html>

       Require all granted

       Order deny,allow
       Deny from all
       Allow from all
       AllowOverride None

Da es sich um HTML Content handelt, wird noch das HTTP-Header Feld für den
*Content Type* im Response gesetzt (vergleiche :ref:`xref_global_http_headers`):

.. code-block:: apache

       <IfModule mod_headers.c>
            Header setifempty Content-Type "text/html"
       </IfModule>

   </Directory>

Diese Startseite ist nur *exemplarisch* und kann bei Bedarf auch wieder
deaktiviert werden:

.. code-block:: bash

  sudo a2dissite html-intro
