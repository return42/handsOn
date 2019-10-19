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

.. sidebar:: Tipp

   Der SQL-Developer muss nicht zwingend installiert werden, es reicht der
   Aufruf ``sqldeveloper.sh`` aus dem ZIP.

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

.. _SQL_CREATE_USER:

Schema anlegen (``CREATE USER``)
================================

Bei einer CDB_ muss das Präfix ``c##`` im Namen des DB-Users (des Schemas)
verwendet werden, bei einer PDB_ ist das nicht erforderlich.  Die CDBs sind seit
Oracle 12 in einer *Standard Installation* (:ref:`CDB & PDB`).  Im folgenden
Beispiel wird ein DB-Benutzer (ein Schema) mit dem Namen ``foo`` und mit
Passwort ``bar`` eingerichtet (Anmeldung als sysdba).

.. code-block:: sql

   CREATE USER c##foo IDENTIFIED BY bar
     DEFAULT TABLESPACE users
     TEMPORARY TABLESPACE temp
     QUOTA UNLIMITED ON users
     CONTAINER = ALL
     PROFILE default;

Gewähren von Rechten auf dem Schema ``c##foo``.

.. code-block:: sql

   GRANT CONNECT
     , CREATE TABLE, CREATE VIEW, CREATE SEQUENCE
     , CREATE SYNONYM, CREATE CLUSTER, CREATE DATABASE LINK
     , ALTER SESSION, CREATE TRIGGER, CREATE PROCEDURE
       TO c##foo;

Anlegen eines Schemas in einer PDB:

.. code-block:: sql

   ALTER SESSION SET container=ORCLPDB;

   CREATE USER foo IDENTIFIED BY bar
     DEFAULT TABLESPACE users
     TEMPORARY TABLESPACE temp
     QUOTA UNLIMITED ON users
     PROFILE default;

   GRANT CONNECT
     , CREATE TABLE, CREATE VIEW, CREATE SEQUENCE
     , CREATE SYNONYM, CREATE CLUSTER, CREATE DATABASE LINK
     , ALTER SESSION, CREATE TRIGGER, CREATE PROCEDURE
     TO foo;

   GRANT read, write
        ON DIRECTORY oracle_impexp
	TO foo;

Schema löschen
==============

.. code-block:: sql

   DROP USER c##foo CASCADE;

Löschen eines Schemas in einer PDB:

.. code-block:: sql

   ALTER SESSION SET container=ORCLPDB;
   DROP USER foo CASCADE;


.. _determin_version_from_dump:

Aus welcher Oracle Version wurde der DUMP erzeugt?
==================================================

::

    $ strings my_dump_file.dmp | head -n 5
    "SYS"."SYS_EXPORT_SCHEMA_01"
    IBMPC/WIN_NT64-9.1.0
    ...
    AL32UTF8
    11.02.00.00.00

.. _determin_schema_from_dump:

Welches Schema ist im DUMP?
===========================

.. _SHOW:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-original-import-utility.html#GUID-85C63F86-9BD7-40BC-A801-D9E11B8ACA3B

Es gibt keine *direkte* Lösung, aber der **sysdba** kann sich das Schema im DUMP
mit der Option SHOW_ in eine SQL Datei ausgeben lassen:

.. code-block:: sh

   impdp \"/ as sysdba\" \
    directory = DATA_PUMP_DIR \
    dumpfile  = my_dump_file.dmp \
    sqlfile   = my_dump_file.sql

Im ``DATA_PUMP_DIR`` liegt dann die ``my_dump_file.sql`` in der man die CREATE
USER Anweisungen findet::

  $ grep '^\s*CREATE USER' /opt/oracle/admin/ORCLCDB/dpdump/my_dump_file.sql
  CREATE USER "TEST_USER" IDENTIFIED BY VALUES ...

.. _DBMS_STATS:

Statistiken und Optimierung
===========================

.. _Statistiken (Oracle):
   http://wikis.gm.fh-koeln.de/wiki_db/Datenbanken/Statistiken

.. _Optimizer Statistics:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/tgsql/optimizer-statistics.html

.. _Gathering Optimizer Statistics:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/tgsql/gathering-optimizer-statistics.html#GUID-245F23B2-24AF-44D8-9F12-99FD1215E878

.. _DBMS_STATS Procedures for Gathering Optimizer Statistics:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/tgsql/gathering-optimizer-statistics.html#GUID-83F1A4F5-A316-4EAD-9AE6-CB95C1885001

.. _GATHER_SCHEMA_STATS:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/arpls/DBMS_STATS.html#GUID-3B3AE30F-1A34-4BFE-A326-15048F7E904F

.. _GATHER_TABLE_STATS:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/arpls/DBMS_STATS.html#GUID-CA6A56B9-0540-45E9-B1D7-D78769B7714C


.. sidebar:: Verweise

   - `Statistiken (Oracle)`_
   - `Optimizer Statistics`_
   - `Gathering Optimizer Statistics`_
   - `DBMS_STATS Procedures for Gathering Optimizer Statistics`_
   - GATHER_SCHEMA_STATS_
   - GATHER_TABLE_STATS_

Die Optimizer-Statistiken sind eine Sammlung von Daten, die weitere Details
bzw. Informationen über die Datenbank und die Objekte der Datenbank beschreiben.
Damit der Cost-Based-Optimizer (CBO) den effizientesten Ausführungsplan von
einer SQL-Abfrage berechnen und auswählen kann, müssen Informationen über die
Tabelle und Indizes, die in der SQL-Abfrage beteiligt sind, vorhanden sein. Der
Rule-Based-Optimizer (RBO) verwendet dagegen keine Statistiken. `[ref]
<http://wikis.gm.fh-koeln.de/wiki_db/Datenbanken/Statistiken>`__

Die Neuberechnung der Statistiken kann U.A. Abhilfe bei Performanceproblemen
bieten.  Für das gesamte Benutzerschema kann sie wie folgt in *sqlplus*
über eine Prozedur (GATHER_SCHEMA_STATS_) angestoßen werden:

.. code-block:: sql

  exec DBMS_STATS.GATHER_SCHEMA_STATS(
     ownname => NULL
     , no_invalidate => FALSE
     );
