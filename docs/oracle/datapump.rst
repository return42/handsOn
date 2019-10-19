.. -*- coding: utf-8; mode: rst -*-
.. include:: ../oracle_refs.txt

.. _oracle_datapump:

===========================
Oracle Data-Pump
===========================

.. _Data-Pump: https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-data-pump.html

.. _Export Parameter:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-original-export-utility.html#GUID-125385E7-A32B-4B52-B1E3-3E3878E0C7B3

.. _Import Parameter:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-original-import-utility.html#GUID-D3F9B4B1-F107-4499-B529-544D233811B5

..  sidebar:: Tipp

    Die einfachste Art einen konsistenten Export einer Datenbank *(eines Oracle
    Benutzers)* herzustellen ist der `Export mit Flashback-Time`_.

Data-Pump_ ist eine Infrastruktur von Oracle zum *bewegen* von Daten aus und in
eine Datenbank.  Es ersetzt die ``exp`` und ``imp`` Kommandos durch ihre
Pendants ``expdp`` und ``impdp``.

- `Export Parameter`_
- `Import Parameter`_

Der Import resp. Export erfolgt in einem Ordner der zuvor in Oracle definiert
wird (dba_directories_).  In einer Standard Installation ist bereits ein Ordner
vorgesehen (``DATA_PUMP_DIR``).

.. code-block:: sql

   SELECT * FROM dba_directories;

=====  =================== ====================================== =============
owner  directory_name      directory_path                         origin_con_id
=====  =================== ====================================== =============
...    ...                 ...                                    ...
SYS    DATA_PUMP_DIR       /opt/oracle/admin/ORCLCDB/dpdump/      1
...    ...                 ...                                    ...
=====  =================== ====================================== =============

Simpler Export
==============

.. sidebar:: Berechtigung in PDB

   In jeder PDB aus der ein DB-User einen Export machen soll, muss dem User das
   Zugriffsrecht auf das Directory für den Export gegeben werden, siehe
   *"GRANT .. ON DIRECTORY .. TO ..;"* in :ref:`dba_directories`.

Ein einfacher Aufruf von ``expdp``, bei dem der Benutzer ``foo`` seine Daten
in dem Ordner ``DATA_PUMP_DIR`` sichert:

.. code-block:: sh

   expdp foo@ORCLPDB \
       directory = DATA_PUMP_DIR \
       schemas   = foo \
       dumpfile  = "foo.dmp" \
       logfile   = "foo.log"


Export mit Flashback-Time
=========================

.. _SCN:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/bradv/glossary.html#GUID-44B5A820-D859-47F5-99CC-56A95AF4BB3E

.. _SYSTIMESTAMP:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/SYSTIMESTAMP.html#GUID-FCED18CE-A875-4D5D-9178-3DE4FA956516

.. _Using Oracle Flashback Technology :
   https://docs.oracle.com/en/database/oracle/oracle-database/19/adfns/flashback.html#GUID-03D1CAAE-D940-444A-8771-B1BC636D105D
.. _FLASHBACK_SCN:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-original-export-utility.html#GUID-B5B5FAA8-4E07-4818-9798-9913869D907F

.. _FLASHBACK_TIME:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-original-export-utility.html#GUID-168AD92D-F31C-43AF-A7A8-DE74732988C5

Über FLASHBACK_SCN_ und FLASHBACK_TIME_ kann ein bestimmter Zeitpunk der DB
exportiert werden.  Die System-Change-Number (SCN_) ist eindeutig und über die
ganze DB hinweg konsistent.  Jede Änderung an der DB erhöht die SCN_

.. code-block:: sql

   SELECT dbms_flashback.get_system_change_number as SCN FROM dual;

           SCN
   -----------
       3518491

Diese Nummer kann einem `Export Parameter`_ namens FLASHBACK_SCN_ übergeben
werden.  Einfacher ist es jedoch wenn Oracle die SCN_ zu einem bestimmten
Zeitpunkt selber ermittelt und wir nur den *Zeitpunkt* angeben müssen (das nennt
sich dann *Flashback-Time*).  Die *aktuelle* Zeit lässt sich mit dem
SYSTIMESTAMP_ angeben:

.. code-block:: sh

   expdp foo@ORCLPDB \
       directory=DATA_PUMP_DIR \
       schemas = foo \
       flashback_time = SYSTIMESTAMP \
       dumpfile = "foo_$(date +%Y.%m.%d-%H.%M.%S).dmp" \
       logfile  = "foo_$(date +%Y.%m.%d-%H.%M.%S).log"


Import
======

.. _FROMUSER:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-original-import-utility.html#GUID-01F8E58D-760A-4E8C-A300-23B6AE651639

.. _TOUSER:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-original-import-utility.html#GUID-98BA8BD2-DBA4-4201-B93B-4AC0AE91A107

.. _REMAP_SCHEMA:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/datapump-import-utility.html#GUID-619809A6-1966-42D6-9ACC-A3E0ADC36523

.. _EXCLUDE:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/datapump-import-utility.html#GUID-DC7668E1-C846-48C5-A0D5-F4659EC119BB

Der Import des Data-Pump_ erfolgt mit dem Kommando ``impdp``.  Die `Import
Parameter`_ namens FROMUSER_ und TOUSER_ ordnen dem Schema aus dem DUMP einen
DB-User zu.  Alternativ kann auch die Option REMAP_SCHEMA_ verwendet werden.
Sofern der DB-User (das Schema) in der DB Instanz noch nicht existiert muss er
angelegt werden, siehe ":ref:`SQL_CREATE_USER`".  Folgend ein Beispiel für einen
Import, bei dem das Schema ``bar`` in den DB-User ``foo`` importiert wird.

.. sidebar:: Verweise

   - :ref:`determin_version_from_dump`
   - :ref:`determin_schema_from_dump`
   - :ref:`DBMS_STATS`


.. code-block:: sh

   impdp foo@ORCLPDB \
       directory    = ORACLE_IMPEXP \
       remap_schema = bar:foo \
       dumpfile     = "bar.dmp" \
       logfile      = "bar2foo-import.log" \
       exclude      = statistics

Sofern man sich den Export in eine neue DB einspielt, kann man die Statistiken
(und ggf. andere Metadaten) beim Export, oder hier beim Import auch ausschließen
(EXCLUDE_): Würde man den Parameter weglassen, so könnte es zu Fehlermeldungen
beim Import der Statistiken kommen: *Objekttyp INDEX_STATISTICS konnte nicht
erstellt werden ...*

.. note::

  Nach dem Import können die Statistiken neu erzeugt werden, siehe DBMS_STAT
  Prozeduren: :ref:`GATHET_xxx_STATS <DBMS_STATS>`.

Falls beim Import Probleme mit dem Festplattenplatz auf der Datenbank auftauchen
kann man u.U. auch erst mal das Archivlog aufräumen:

  .. code-block:: bash

    rman target /
    backup archivelog all;
    delete archivelog all;


.. _dba_directories:

``dba_directories``
===================

.. _CREATE DIRECTORY:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/CREATE-DIRECTORY.html#GUID-8E9C569A-1B06-42C4-9586-0EF83437001A

.. _Understanding Dump, Log, and SQL File Default Locations:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-data-pump-overview.html#GUID-EEB32B50-8A00-40B0-8787-CC2C8BA05DC5

Die Ordner des Data-Pump_ werden (wie alle) in der Tabelle ``dba_directories``
verwaltet und mit `CREATE DIRECTORY`_ angelegt (siehe auch `Understanding Dump,
Log, and SQL File Default Locations`_).  Einrichten eines Ordners auf dem DB
Host::

  oracle@dbhost $ sudo mkdir -p /HOST/share/oracle_impexp
  oracle@dbhost $ sudo chown -R oracle:oinstall /HOST/share/oracle_impexp

Als ``sysdba`` anmelden und den Ordner in der Oracle Instanz einrichten.  Bei
PDBs muss man noch in den Container wechseln und die Zugriffsrechte explizit
für jeden DB-Usern in jedem Container vergeben.

.. code-block:: sql

   ALTER SESSION SET container=ORCLPDB;

   -- create directory object
   CREATE OR REPLACE DIRECTORY oracle_impexp AS '/HOST/share/oracle_impexp';

   -- grant read / write rights to schema
   GRANT read, write ON DIRECTORY oracle_impexp TO foo;

Damit der Benutzer ``c##foo`` auf den Ordner zugreifen kann wurden ihm noch die
dazu erforderlichen Rechte eingeräumt.  Auf welche Ordner ein DB User Zugriff
hat kann er über ermitteln:

.. code-block:: sql

   SELECT * FROM ALL_DIRECTORIES;

