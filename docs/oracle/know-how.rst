.. -*- coding: utf-8; mode: rst -*-
.. include:: ../oracle_refs.txt

.. _oracle_know_how:

===============
Oracle Know-how
===============

EPEL
====

Extra Packages for Enterprise Linux (EPEL_) ist eine Special Interest Group von
Fedora, die eine qualitativ hochwertige Reihe von zusätzlichen Paketen für
Enterprise Linux verwaltet.  EPEL eignet sich für alle RHEL Distributionen:
Red Hat Enterprise Linux, CentOS und Scientific Linux(SL), Oracle Linux (OL).

EPEL-Pakete basieren in der Regel auf ihren Fedora-Pendants konfligieren aber
nicht mit den Paketen in den Basis-Enterprise Linux-Distributionen (es werden
auch keine ersetzt).::

   sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
   sudo yum update

.. code-block:: none

   $ sudo yum repolist

   Geladene Plugins: langpacks, ulninfo
   Repo-ID           Repo-Name:                                                      Status
   epel/x86_64       Extra Packages for Enterprise Linux 7 - x86_64                  13.415
   ol7_UEKR5/x86_64  Latest Unbreakable Enterprise Kernel Release 5 for Oracle Linux    169
   ol7_latest/x86_64 Oracle Linux 7Server Latest (x86_64)                            15.441
   repolist: 29.025


SQL-Developer installieren
==========================

RHEL (RPM)
----------

Der SQL-Developer benötigt ein JDK, ich habe mich für `OpenJDK
<https://openjdk.java.net/>`_ entschieden, weil das bereits in den Paketquellen
des `Oracle Linux`_ mit drin ist::

  sudo yum install java-1.8.0-openjdk-devel

Für den SQL-Developer das RPM Paket runter laden: `SQL Developer Downloads`_ und
installieren::

  $ cd Download
  $ sudo yum localinstall sqldeveloper-*.noarch.rpm

Danach einmal auf der Kommandozeile starten::

  $ sqldeveloper

  Oracle SQL Developer
  Copyright (c) 2005, 2018, Oracle and/or its affiliates. All rights reserved.

  Default JDK not found

  Type the full pathname of a JDK installation (or Ctrl-C to quit), the path
  will be stored in /home/user/.sqldeveloper/19.2.1/product.conf

Hier muss man einmal den Pfad zum JDK eingeben, bei obiger Installation des
OpenJDK wäre das dann::

  /usr/lib/jvm/java-1.8.0-openjdk/

Beim Starten bekommt man die Meldung::

  Problem initializing the JavaFX runtime. This feature
  requires JavaFX.

Die JavaFX Runtime wird eigentlich nur für den Begrüßungsbildschirm benötigt,
deshalb muss das JavaFX nicht unbedingt installiert werden.


Debian
------

.. _sqldeveloper-19.2.1.247.2212-no-jre.zip:
   https://download.oracle.com/otn/java/sqldeveloper/sqldeveloper-19.2.1.247.2212-no-jre.zip

Für Debian gibt es das Tool :man:`make-sqldeveloper-package` mit dem man Debian
Pakete für die Installation bauen kann.  Das Tool benötigt dazu das ZIP des
SQL-Developers.  Über `SQL Developer Downloads`_ das ZIP Paket **Other
Platforms** runter laden (sqldeveloper-19.2.1.247.2212-no-jre.zip_)
und danach die Pakete bauen::

   $ cd ~/Downloads
   $ LANG=C make-sqldeveloper-package -i ../sqldeveloper-19.2.1.247.2212-no-jre.zip

Diese selbst-gebauten Pakete kann man sich dann installieren.  Bei der
Installation wird vom SQL-Developer noch ein JDK erwartet::

   $ sudo apt install default-jdk
   $ sudo dpkg -i libjnidispatch-19.2.1.247.2212_4.2.2+0.5.4-1_amd64.deb
   $ sudo dpkg -i sqldeveloper-19.2.1.247.2212_19.2.1.247.2212+0.5.4-1_all.deb

Initial empfiehlt es sich, den SQL-Developer einmal auf der Kommandozeile zu
starten und falls erforderlich einmal den Pfad zum JDK eingeben.  Bei obiger
Installation des ``default-jdk`` wäre das dann::

  /usr/lib/jvm/java-11-openjdk-amd64


Windows
-------

Über `SQL Developer Downloads`_ das ZIP Paket **Windows 64-bit with JDK 8
included** runter laden: `sqldeveloper-19.2.1.247.2212-x64.zip
<https://download.oracle.com/otn/java/sqldeveloper/sqldeveloper-19.2.1.247.2212-x64.zip>`_.
Das ZIP muss nur ausgepackt werden, darin ist dann ein Executable.


Oracle Benutzer anlegen
=======================

Bei den CDBs muss das Präfix ``c##`` im Namen verwendet werden, bei den PDBs ist
das nicht erforderlich.  Die CDBs sind seit Oracle 12 in der *Standard
Installation*. Benutzer (Schema) ``foo`` mit Passwort ``bar``.

.. code-block:: sql

   CREATE USER c##foo IDENTIFIED BY bar
     DEFAULT TABLESPACE users
     TEMPORARY TABLESPACE temp
     QUOTA UNLIMITED ON users
     CONTAINER = ALL
     PROFILE default;

Gewähren von Rechten auf dem Schema ``foo``.

.. code-block:: sql

   GRANT CONNECT
     , CREATE TABLE, CREATE VIEW, CREATE SEQUENCE
     , CREATE SYNONYM, CREATE CLUSTER, CREATE DATABASE LINK
     , ALTER SESSION, CREATE TRIGGER, CREATE PROCEDURE
       TO foo;


Aus welcher Oracle Version wurde der DUMP erzeugt?
==================================================

::

    $ strings my_dump_file.dmp | head -n 5
    "SYS"."SYS_EXPORT_SCHEMA_01"
    IBMPC/WIN_NT64-9.1.0
    ...
    AL32UTF8
    11.02.00.00.00
