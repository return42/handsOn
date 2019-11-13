.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_probe_server:

================================================================================
                             Test des WEB-Servers
================================================================================

Jeder WEB-Client der eine WEB-Anwendung (wie z.B. DAV, WSGI usw.) nutzt ist ein
Test des WEB-Servers. Dementsprechend sollten die LOG-Dateien beobachtet werden,
wenn man eine neue WEB-Anwendung testet:

.. code-block:: bash

   sudo -H tail -f  /var/log/apache2/error.log

Hat man :ref:`xref_mod_security2` aktiviert, sollte man das Audit-Log des
ModSecurity Moduls beobachten:

.. code-block:: bash

   sudo -H tail -f  /var/log/apache2/modsec_audit.log

``curl``
========

Einfache Tests des WEB-Servers können mit :man:`curl` durchgeführt werden.  Eine
Beispielanwendung des :man:`curl` wird in Abschnitt
:ref:`xref_start_your_engines` gezeigt.

.. code-block:: bash

   $ curl --location --verbose --head --insecure http://localhost 2>&1
   * Rebuilt URL to: http://ubuntu1504/
   *   Trying fd00::a00:27ff:fed5:7c85...
   * Connected to ubuntu1504 (fd00::a00:27ff:fed5:7c85) port 80 (#0)
   > HEAD / HTTP/1.1
   > Host: ubuntu1504
   > User-Agent: curl/7.43.0
   > Accept: */*
   ...

``ab``
======

Aus dem :deb:`apache2-utils` Paket steht das :man:`ab` Kommando zur Verfügung,
mit dem *Last-Tests* durchgeführt werden können.::

    *ab* is a tool for benchmarking your Apache Hypertext Transfer Protocol (HTTP)
    server. It is designed to give you an impression of how your current Apache
    installation performs. This especially shows you how many requests per
    second your Apache installation is capable of serving.

Für die Auswertung der ab-Benchmarks empfehlen sich ggf. auch noch die Artikel

* `Apache Bench (ab) timings explained visually`_.
* http://www.bradlanders.com/2013/04/15/apache-bench-and-gnuplot-youre-probably-doing-it-wrong/
* https://gist.github.com/netpoetica/80b9725b204d642be4a0


Nmap
====

Zu Empfehlen ist auch der *Network Mapper* Nmap_, der mit dem Paket :deb:`nmap`
installiert werden kann.








