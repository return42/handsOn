.. -*- coding: utf-8; mode: rst -*-
.. include:: ../oracle_refs.txt

.. _oracle:

==================
Oracle (developer)
==================

.. sidebar:: Info

   Die (im Okt. 2019) aktuelle Oracle DB Version ist 19c.  Die XE gibt es
   aktuell nur in 18c und deren Limit liegt bei 2CPU, 2GB RAM und 12GB *User
   Data* (XE_).  Andere Installationen (ohne Limitierungen) basieren i.d.R. auf
   einer der RHEL-distros_ wozu auch das `Oracle Linux`_ gehört.

   Die hier beschriebenen Oracle Installationen sind lediglich für *Entwickler -
   Zwecke* geeignet.  Die hier gegebenen Beispiele basieren auf der exemplarisch
   angelegten :ref:`ORCLCDB <ORCLCDB>` Instanz.  Sofern nicht anders erwähnt
   wird eine CDB_ verwendet (bitte :ref:`CDB & PDB` lesen).  Backups, Updates
   und andere Anforderungen werden nicht berücksichtigt.  Für die Nutzung in
   *produktiven* Umgebungen werden die entsprechenden Lizenzen von Oracle
   benötigt.



Das `Oracle Datenbanksystem`_ gibt es u.A. in der frei verfügbare Express
Edition (XE_).  Letztere eignet sich aufgrund ihrer Limitierungen nur für
kleinste Entwickler Instanzen und zum experimentieren.  Die XE_ gibt es
i.d.R. als *MSI Paket* für Windows und als RPM Paket für die `Red Hat Enterprise
Linux`_ Distributionen (RHEL-distros_).

Die RPM_ Quellpakete des `Red Hat Enterprise Linux`_ stehen frei zur Verfügung,
jedoch gibt es hierfür keine frei verfügbaren Boot-/Installations- Medien
(*frei* ist lediglich eine 30-Tage *subscription*).  RHEL_ kann (wie z.B. auch
`SUSE Linux Enterprise Server`_) nur über Support-Verträgen bezogen werden und
ist damit eher selten für Entwickler Szenarien geeignet.  Alternativ kann man
als Entwickler eine der RHEL-distros_ wählen.

.. toctree::
   :maxdepth: 2

   linux
   dbms
   datapump
   cdbpdb
   know-how
