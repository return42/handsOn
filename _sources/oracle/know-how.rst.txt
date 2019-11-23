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

   sudo -H yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
   sudo -H yum update

.. code-block:: none

   $ sudo -H yum repolist

   Geladene Plugins: langpacks, ulninfo
   Repo-ID           Repo-Name:                                                      Status
   epel/x86_64       Extra Packages for Enterprise Linux 7 - x86_64                  13.415
   ol7_UEKR5/x86_64  Latest Unbreakable Enterprise Kernel Release 5 for Oracle Linux    169
   ol7_latest/x86_64 Oracle Linux 7Server Latest (x86_64)                            15.441
   repolist: 29.025



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
