.. -*- coding: utf-8; mode: rst -*-
.. include:: ../oracle_refs.txt

.. _oracle_cdbpdb:

.. _CDB & PDB:

=========
CDB & PDB
=========

.. sidebar:: Info

   Siehe auch `Common Tasks when Managing CDB and Pluggable PDB
   <https://access.redhat.com/documentation/en-us/reference_architectures/2017/html/deploying_oracle_database_12c_release_2_on_red_hat_enterprise_linux_7/common_tasks_when_managing_container_database_cdb_and_pluggable_databases_pdb>`__.

Seit Oracle 12 sind die DB-Instanzen mandantenfähig.  In einer
Container-Datenbank (CDB_) können keine, eine oder mehrere Plugin-Database
(PDB_) angelegt werden.

.. code-block:: sql

   SHOW pdbs

.. code-block:: none

   CON_ID CON_NAME   OPEN MODE  RESTRICTED
   ------ ---------- ---------- ----------
        2 PDB$SEED   READ ONLY  NO
        3 ORCLPDB1   MOUNTED
        4 ORCLPDB    READ WRITE NO

Hier im Beispiel gibt es eine Vorlage-PDB (PDB$SEED), eine inaktive (ORCLPDB1)
und eine aktive Datenbank (ORCLPDB).  Als z.B. ``sysdba`` kann man zw. den
Containern wechseln.

.. code-block:: sql

   ALTER SESSION SET container=ORCLPDB;

Der aktuelle Container ist:

.. code-block:: sql

   SELECT
     SYS_CONTEXT('USERENV', 'CON_NAME') AS CUR_CONTAINER
   FROM DUAL;

.. code-block:: none

   CUR_CONTAINER
   -------------
   ORCLPDB

Manage PDBs
===========

.. sidebar:: Info

   Für Änderungen an dem Setup der PDB sollte man sich mit sqlplus als sysdba
   anmelden.

   Der Status einer PDB kann mit ``SAVE STATE`` für den nächsten
   Reboot eingestellt werden.

Öffnen einer PDB (sysdba):

.. code-block:: none

   SQL> alter pluggable database ORCLPDB open;

   SQL> show pdbs

   CON_ID CON_NAME        OPEN MODE  RESTRICTED
   ------ --------------- ---------- ----------
        2 PDB$SEED        READ ONLY  NO
        3 ORCLPDB1        MOUNTED
        4 ORCLPDB         READ WRITE NO

Status des PDB für nächsten Reboot sichern (sysdba):

.. code-block:: sql

   ALTER pluggable DATABASE ORCLPDB SAVE STATE;

   -- anzeigen der saved-states ...
   SELECT con_name, state
     FROM dba_pdb_saved_states;

.. code-block:: none

   CON_NAME   CON_NAME
   ---------- ----------
   ORCLPDB    OPEN

Und einmal testen:

.. code-block:: sql

   SQL> shutdown immediate;

.. code-block:: none

   Datenbank geschlossen.
   Datenbank dismounted.
   ORACLE-Instanz heruntergefahren.

.. code-block:: sql

   SQL> startup

.. code-block:: none

   ORACLE-Instanz hochgefahren.
   Total System Global Area 1543500872 bytes
   Fixed Size                  9135176 bytes
   Variable Size            1073741824 bytes
   Database Buffers          452984832 bytes
   Redo Buffers                7639040 bytes
   Datenbank mounted.
   Datenbank geoffnet.

.. code-block:: sql

   -- anzeigen der saved-states ...
   SELECT con_name, state
     FROM dba_pdb_saved_states;

.. code-block:: none

   CON_NAME   CON_NAME
   ---------- ----------
   ORCLPDB    OPEN


PDB tnsnames.ora
================

.. sidebar:: Info

   Sofern in der ``tnsnames.ora`` kein Eintrag für die PDB existiert kann man
   folgenden Connector verwenden::

     foo@dbhost:1521/orclpdb

Für die PDBs sollten entsprechen Einträge in der :ref:`tnsnames.ora` vorgenommen
werden:

.. code-block::

   ORCLPDB =
     (DESCRIPTION =
        (ADDRESS =
	  (PROTOCOL = TCP)
	  (HOST     = 192.168.1.110)
	  (PORT     = 1521))
        (CONNECT_DATA =
          (SERVER       = DEDICATED)
          (SERVICE_NAME = ORCLPDB))
      )

