.. -*- coding: utf-8; mode: rst -*-
.. include:: ../oracle_refs.txt

.. _oracle_dbms:

=================
Oracle DBMS Setup
=================

.. _Oracle Preinstallation RPM (19c):
   https://docs.oracle.com/en/database/oracle/oracle-database/19/cwlin/about-the-oracle-preinstallation-rpm.html#GUID-C15A642B-534D-4E4A-BDE8-6DC7772AA9C8

.. _Installing the Oracle Preinstallation RPM: https://docs.oracle.com/en/database/oracle/oracle-database/19/ladbi/installing-the-oracle-preinstallation-rpm-from-unbreakable-linux-network.html#GUID-555F704E-BD48-4E0E-AC9D-038596601194

.. _Installing Oracle Database Using RPM Packages: https://docs.oracle.com/en/database/oracle/oracle-database/19/ladbi/installing-oracle-database-using-rpm-packages.html#GUID-5AF74AC1-510E-4EB0-9BCA-B096C42C6A76

Folgend wird die (im Okt. 2019) aktuelle Oracle DB Version 19c_ installiert.
Zuvor muss das `Oracle Preinstallation RPM (19c)`_ installiert werden::

  sudo yum install oracle-database-preinstall-19c.x86_64
  ...
  reboot

.. note::

   Der Reboot wurde hier durchgeführt, weil das *Oracle Preinstallation RPM*
   u.A. einen Kernel Parameter ändert.

In dem Ordner ``/var/log/oracle-database-preinstall-19c/backup/`` liegen (nach
Datum sortiert) die Sicherungen die das *Oracle Preinstallation RPM* angelegt
hat.  Dort liegt auch das LOG zu den Änderungen (weitere Hinweise siehe auch
`Installing the Oracle Preinstallation RPM`_).  Als nächstes kann dann das DBMS
installiert werden (`Installing Oracle Database Using RPM Packages`_).


RPM Installation
================

.. _RPM Paket für 19c: https://www.oracle.com/database/technologies/oracle-database-software-downloads.html#19c

.. _oracle-database-ee-19c-1.0-1.x86_64.rpm: https://download.oracle.com/otn/linux/oracle19c/190000/oracle-database-ee-19c-1.0-1.x86_64.rpm

.. sidebar:: https://www.oracle.com/downloads/

   Über den Link gelangt man zu den Download-Seiten des DBMS.

Wir haben uns bereits oben für die Version 19c_ entschieden und benötigen nun
das `RPM Paket für 19c`_ (oracle-database-ee-19c-1.0-1.x86_64.rpm_).  Nachdem
die Datei vollständig heruntergeladen wurde kann das Paket installiert
werden.

.. code-block::
   :class: clear-both

   [user@localhost ~]$ cd ~/Downloads
   [user@localhost ~]$ sudo yum -y localinstall oracle-database-ee-19c-1.0-1.x86_64.rpm
   ...
   [user@localhost ~]$ sudo passwd oracle

Bei der Installation des RPM wurde auch der Systembenutzer ``oracle`` angelegt,
mit dem man die Oracle Administration vornimmt.  Für diesen Benutzer wird noch
das Passwort gesetzt.

.. _ORCLCDB:

Datenbank ``ORCLCDB``
=====================

.. _Creating and Configuring an Oracle Database:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/ladbi/running-rpm-packages-to-install-oracle-database.html

Einrichten der exemplarischen DB Instanz **ORCLCDB** (`Creating and Configuring an Oracle Database`_)::

  [user@localhost ~]$ sudo /etc/init.d/oracledb_ORCLCDB-19c configure
  ... dauert etwas länger
  Erstellen der Datenbank abgeschlossen ...
  Datenbankinformationen:
  Globaler Datenbankname:ORCLCDB
  System-ID (SID):ORCLCDB

  Database configuration completed successfully. The passwords were auto generated,
  you must change them by connecting to the database using 'sqlplus / as sysdba'
  as the oracle user.

Um die Passwörter in der DB Instanz zu ändern, meldet man sich mit dem
:ref:`oracle_os_login` am System an.  Mit ``sqlplus`` als ``sysdba`` kann man
dann die Passwörter wie folgt ändern.  Die im Beispiel verwendeten Passwörter
``"sys"`` und ``"system"`` sollten gegen sinnvolle ausgetauscht werden!::

  $ . oraenv
  ORACLE_SID = [oracle] ? ORCLCDB
  ...
  $ sqlplus / as sysdba
  ...
  SQL> alter user sys identified by "sys";
  ...
  SQL> alter user system identified by "system";

.. _oracle_os_login:

``oracle`` Benutzer
===================

.. sidebar:: Tipp

   Wenn es nur eine Umgebung gibt, kann man diese auch gleich direkt in der
   ``~oracle/.bashrc`` setzen.  Dazu am Ende folgendes anfügen::

     export ORAENV_ASK=NO
     export ORACLE_SID=ORCLCDB
     source oraenv
     # Alias zum auflisten der SIDs
     alias oraSIDs="grep -o '^[^#]*' /etc/oratab"

Bei der `RPM Installation`_ wurde der Systembenutzer ``oracle`` angelegt.  Ist
man bereits auf dem Rechner angemeldet, kann man in mit ``su`` den Benutzer
wechseln oder sich via ssh mit diesem Account anmelden. ::

  su - oracle

Die Option ``-X`` reicht das Display durch, womit dann auch die graphischen
Tools wie ``dbca`` genutzt werden können. ::

  [user@localhost ~]$ ssh -X oracle@localhost


Auswahl einer Umgebung
======================

.. _Automating Database Startup and Shutdown:
   https://docs.oracle.com/en/database/oracle/oracle-database/19/unxar/stopping-and-starting-oracle-software.html#GUID-CA969105-B62B-4F5B-B35C-8FB64EC93FAA

.. sidebar:: Tipp

   Damit die DB beim Systemstart auch gestartet wird muss in der ``/etc/oratab``
   der Buchstaben ``N`` in ``Y`` gändernt werden::

       ORCLCDB:<..>/19c/dbhome_1:Y

   Die Beschreibung (`Automating Database Startup and Shutdown`_) von Oracle ist
   veraltet.  Die ``/etc/init.d/oracledb_ORCLCDB-19c`` wurde bereits im Kapitel
   ORCLCDB_ vom RPM eingerichtet.  Mit `systemd-sysv-generator`_ braucht man den
   Dienst nur zu aktivieren::

     sudo systemctl enable oracledb_ORCLCDB-19c

Die zur Verfügung stehen Umgebungen sind in der Datei ``/etc/oratab``
konfiguriert::

  grep -o '^[^#]*' /etc/oratab
  ORCLCDB:/opt/oracle/product/19c/dbhome_1:N

.. hlist::

   - ``ORCLCDB`` ist die SID
   - ``/opt/oracle/product/19c/dbhome_1`` ist der Ordner der DB Instanz
   - ``N`` oder ``Y``: *autostart* der DB bei Systemstart

Nach dem Login muss mittels ``oraenv`` erst die DB Umgebung ausgewählt werden::

  [oracle@localhost ~]$ source oraenv
  ORACLE_SID = [oracle] ? ORCLCDB
  The Oracle base has been changed from /home/oracle to /opt/oracle

Danach kann man dann die Tools aufrufen::

  [oracle@localhost ~]$ dbca

Oder man meldet sich mit dem ``sqlplus`` als ``sysdba`` an::

  [oracle@localhost ~]$ sqlplus / as sysdba
  SQL*Plus: Release 19.0.0.0.0 - Production on Fri Oct 11 13:48:23 2019
  Version 19.3.0.0.0
  Copyright (c) 1982, 2019, Oracle.  All rights reserved.
  Verbunden mit:
  Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
  Version 19.3.0.0.0
  SQL>
