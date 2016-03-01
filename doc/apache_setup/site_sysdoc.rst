.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_site_sysdoc:

================================================================================
                              System-Dokumentation
================================================================================

Mit der Site Konfiguration ``sysdoc.conf`` wird die System-Dokumentation aus dem
Ordner ``/usr/share/doc`` über den WEB-Server freigegeben. Die Site
``sysdoc.conf`` definiert die Directory Resource ``/usr/share/doc`` und setzt
den Alias ``/sysdoc`` auf diese Resource (vergleiche
:ref:`xref-allias-directive`).  Für die Site ist keine :ref:`xref_apache-auth`
erforderlich, was über die Direktive ``Require all granted`` gesetzt wird.  Die
``Allow``, ``Order`` und ``Deny`` Direktiven werden so gesetzt, dass der Zugriff
auf die sysdoc-resource nur aus dem eigenen Subnetzt möglich ist (vergleiche
:ref:`xref-allow-directive`). Es werden keine lokalen Options unterstützt, siehe
:ref:`xref-allowoverride-directive`.


.. code-block:: apache

   <IfModule mod_autoindex.c>

       Alias /sysdoc /usr/share/doc

       <Directory /usr/share/doc>

           Require all granted

           Order deny,allow
           Deny from all
           Allow from fd00::/8 192.168.0.0/16 fe80::/10 127.0.0.0/8 ::1
           AllowOverride None

In dem Kontext der Resource wird noch der *Autoindex* eingeschaltet, der die
Header/Readme Datei aus dem chrome-Ordner verwenden soll (vergleiche
:ref:`xref_server_side_include`):

.. code-block:: apache

           Options +Indexes +FollowSymLinks

           HeaderName /chrome/header.shtml
           ReadmeName /chrome/footer.shtml

       </Directory>

   </IfModule>

Die sysdoc-Site sollte nur in einer Entwickler-Umgebung installiert werden. Die
sysdoc-Site kann bei Bedarf auch wieder deaktiviert werden:

.. code-block:: bash

  sudo a2dissite sysdoc
