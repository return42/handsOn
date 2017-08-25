=================================================
CDB Komponenten
=================================================

.. _darmarIT: http://www.darmarit.de
.. _`setup.py`: https://docs.python.org/2/distutils/setupscript.html
.. _bisect: https://en.wikipedia.org/wiki/Bisection_(software_engineering)
.. _`get git started`: https://return42.github.io/handsOn/git-slide/index.html
.. _git: https:/git-scm.com/
.. _SVN: https://subversion.apache.org/
.. _Protokolle: https://git-scm.com/book/id/v2/Git-on-the-Server-The-Protocols
.. _`git URLs`: https://www.kernel.org/pub/software/scm/git/docs/git-clone.html#URLS
.. _git-send-email: https://git-scm.com/docs/git-send-email
.. _FQN: https://en.wikipedia.org/wiki/Fully_qualified_name
.. _git-bundle: https://git-scm.com/docs/git-bundle
.. _git-send-email: https://git-scm.com/docs/git-send-email
.. _git-merge: https://git-scm.com/docs/git-merge
.. _`Merge Strategien`: https://git-scm.com/docs/git-merge#_merge_strategies
.. _`Git Attributen`: https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes#Merge-Strategies
.. _`.gitattributes`: https://git-scm.com/docs/gitattributes
.. _`Contact Software GmbH`: https://www.contact-software.com/

.. raw:: html

   <aside id="logo" style="height:8vh; width:8vw; position:absolute; bottom:2vh; left:2vw; ">
     <a href="http://www.darmarit.de">
       <img src="_static/darmarIT_logo_512.png">
     </a>
   </aside>

.. revealjs:: CDB Komponenten

   Komponenten Architektur & verteilte Entwicklung

   mit CIM DATABASE / CONTACT Elements

   .. rv_small::

      compiled by darmarIT_

      *Hit '?' to see keyboard shortcuts*


.. revealjs:: Themen

   - :ref:`CDB Pakete <cdb_pakete_intro>`
   - :ref:`Struktur Kundenpaket <struktur_kundenpaket>`
   - :ref:`Voraussetzungen <voraussetzungen>` + *repair* :ref:`Schema
     <schema_repair>` & :ref:`Konfiguration <config_repair>`
   - :ref:`Updates & Konflikte <updates_und_konflikte>`
   - :ref:`Transport einer Änderung <transport_aenderung>`: Code & Config
     :ref:`Merge-Schaubild <merge_graph>`
   - :ref:`CDB & SCM-System <cdb_und_scm>`
   - :ref:`Merge Strategien <merge_strategien>`
   - :ref:`Lieferantenanbindung <lieferantenanbindung>`: :ref:`Beauftragung
     <aenderung_beauftragen>` & :ref:`Auslieferung <aenderung_ausliefern>`
   - :ref:`Entwicklungszweige mergen <merge_dev_branches>`
     


.. _cdb_pakete_intro:

.. revealjs:: CDB Pakete
   :title-heading: h3

   Hersteller-Pakete in ``site-packages``

   Änderungen nur durch Hersteller-Updates

   Beispiel: keine eignen Änderungen an ``cs.`` Paketen

   Kunden-Paket ``cust.plm`` darf nicht im Python-Pfad (``site-packages``) liegen.

.. revealjs:: Namensräume, Pakete & Ebenen
   :title-heading: h3

   - Ebene 3 -- ``cust.``   pflegt der *Customer*

   - Ebene 2 -- ``tpm.``    pflegt der *Third Party Maker*

   - Ebene 1 -- ``cs.``     pflegt die *Contact Software GmbH*

   Dependency-Direction: 3 darf 2 oder auch 1 anpassen

   ``cust.`` --> ``tpm`` --> ``cs.``

   .. rv_small::

        Namensräume sind was anderes als Pakete. Ein Namensraum beinhaltet
        i.d.R. mehrere Pakete -- z.B. die Pakete ``cs.base`` und ``cs.vp`` im
        Namensraum ``cs``. Die CDB-Module in einem Paket gehören aber alle zum
        Namensraum des Pakets -- z.B. das CDB-Modul ``cs.calender`` aus dem
        Paket ``cs.base``. Der Hersteller pflegt seinen Namensraum und schnürrt
        die Pakete.

.. revealjs:: Anpassungen des Customer
   :title-heading: h3

   1. Quellcode in ``cust.``

      Anpassung z.B. durch Verbung aus ``cs.`` und ``tpm.`` oder Signalhandler
      die in ``cs.`` und ``tpm.`` registriert werden.

   2. Konfiguration aus ``cs.`` und ``tpm.`` die der Customer ändern muss

      z.B. Anpassungen an Masken & Tabellen aus ``cs.`` und ``tpm.``

   .. rv_small::

      Die Anpassungen einer Kundeninstallation werden in einem Paket verwaltet
      -- z.B. Paket ``cust.plm`` im Namensraum ``cust``. Die Anpassungen
      beschränken sich aber nicht auf diesen Namensraum, man wird auch
      Konfigurationen in der DB aus ``cs`` und ``tpm`` anpassen wollen.


.. revealjs:: app_conf
   :title-heading: h3

   Master + Historie für jedes CDB-Modul, wird aus der DB aufgebaut, von
   ``cdbpkg`` verwaltet und wird **nicht** im SCM-System versioniert!

   ::

     CADDOK_BASE
       +---app_conf
           +---cs
           |   ...
           |   \---erp
           |       +---current
           |       +---history
           |       \---master
           + ...
           \---cust.plm

   .. rv_small::

      Die Details sind für uns unwichtig, wir müssen nur wissen, dass es diesen
      Ordner gibt und das die ``cdbpkg`` Tools ihn für so eine Art *micro*
      Versionsverwaltung nutzen.

.. _struktur_kundenpaket:

.. revealjs:: Struktur cust.plm Paket (1)

   CDB-Paket mit zwei CDB-Modulen ``cust.plm`` und ``cust.foo``

   ::

      \---cust.plm             # CDB-Paket
          +---cust.plm.egg-info
          |   setup.py         # schauen wir uns gleich an
          |                    #   ansonsten keine weiteren Dateien
          \---cust             # Python Namespace 'from cust import foo'
              | __init__.py    #   ist ein Python (kein CDB) Paket
              |                #   ansonsten keine weiteren Dateien
              +---plm          # Modul 'plm' nicht zwingend erforderlich
              \---foo          # Modul 'foo' schauen wir uns gleich an


   .. rv_small::

      CDB-Paketname ist ``cust.plm``. Die CDB-Module sind Python-Pakete deren
      Namespace ``cust.*`` ist. Typische Namen von CDB-Modulen: ``cust.foo`` oder
      ``cust.bar``. Ein ``cust.plm`` kann, muss es aber nicht geben.


.. revealjs:: Struktur cust.plm Paket (2)

   ::

      \---cust.plm             # CDB-Paket
          +---cust.plm.egg-info
          |   setup.py         # schauen wir uns gleich an
          |                    #   ansonsten keine weiteren Dateien
          \---cust             # Python Namespace 'from cust import foo'
              | __init__.py    #   ist ein Python (kein CDB) Paket
              |                #   ansonsten keine weiteren Dateien
              +---plm          # Modul 'plm' nicht zwingend erforderlich
              \---foo          # Modul 'foo' schauen wir uns gleich an


   .. rv_small::

      Wenn im Namespace ``cust`` mehrere CDB-Module rumliegen -- hier
      z.B. ``cust.foo`` und ``cust.plm`` -- dann müssen diese auch in der
      Paket-Konfig in CDB als Module existieren, Anderes darf hier nicht
      rumliegen! Vergleiche ``cs.base`` Paket, das n-CDB-Module vereint.  Häufig
      ist das Customizing ein CDB-Paket ``cust.plm`` in dem nur ein Modul
      ``cust.plm`` exisitert.


.. revealjs:: cust.plm setup.py
   :title-heading: h3

   .. rv_code::
      :class: python

      from cdb.comparch.pkgtools import setup
      setup(
          name               = "cust.plm" # package name
          , version          = "1.0.0"    # package version
          # list of required packages
          , install_requires = [
              'cs.platform', 'cs.base', 'cs.workflow' ..]
          # relative path for each documentation
          , docsets          = []
          # list of contained modules (cdb_modules.txt)
          , cdb_modules      = ['cust.plm', 'cust.foo', ..]
          # list of services (class names cdb_services.txt)
          cdb_services       = []
        ],

   .. rv_small::

      Die ``install_requires`` muss vollständig sein! `setup.py`_ gehört zu
      Python, für CDB wurde es um ``cdb_`` Eigenschaften erweitert.


.. revealjs:: Modul cust.foo
   :title-heading: h3

   ::

      \--foo                      # CDB 10.x
         |  module_metadata.json
         |  content_metadata.json # in 15.x unter ./configuration
         |  schema.json           # in 15.x unter ./configuration
         +---patches              # in 15.x unter ./configuration
         +---configuration
         \---resources

   ::

      \--foo                      # CDB 15.x
         |  module_metadata.json
         +---configuration
         \---resources

   .. rv_small::

      Die Struktur hat sich in CDB ELEMENTS leicht geändert, vom Prinzip her
      bleibt es gleich; Konfig Schlonz liegt im Modul und wird im SCM versioniert.
      Ab CDB 15.x nur noch ``configuration``, wir reden ab jetzt nur noch von
      ``configuration``.


.. revealjs:: configuration Ordner vom CDB-Modul cust.foo
   :title-heading: h3

   ::

      \--configuration
         |  content_metadata.json          # Checksumme
         |  schema.json                    # DB Schema
         +---content                       #
         |   |   ausgaben.json             # eigene Meldungstexte
         |   |   browsers.json             # eigene Auswahlbrowser
         |   \---blobs                     # eigene BLOBs
         |           6eccde35-1fa8-...     # --> z.B. Report-Template
         \---patches                       # Anpassungen andere Module
             +---cs.pcs.projects           # --> cs.pcs.projects
             |   |   patches.json          #     patch Konfiguration
             |   \---blobs                 #     patch blobs
             |           12eeddaa-17fa-... #
             +---cs.pcs.cheklists          # --> cs.pcs.checklists
             |       patches.json          #     patch Konfiguration


   .. rv_small::

      Konfigurationen werden als JSON Dateien zum Modul hinterlegt.  Hier zu
      erkennen: ``cust.foo`` hat Meldungstexte, Auswahlbrowser und einen BLOB.
      Desweiteren scheint es die Module ``projects`` und ``checklists`` des
      ``cs.pcs`` Pakets anzupasssen.


.. _voraussetzungen:

.. revealjs:: Voraussetzungen

   Instanz & DB müssen immer zueinander passen.

   DB Schema muss im Data-Dictionary vollständig den Modulen zugeordnet sein.

   Referenzielle Integrität der Konfiguration muss gewährleistet sein.

   Konflikte müssen aufgelöst werden!

   .. rv_small::

      Diese Voraussetzungen müssen erfüllt werden, sonst gibt es Probleme beim
      Transport von Änderungen innerhalb der Komponenten Architektur. D.h. ohne
      diese Voraussetzungen ist eine verteilte Entwicklung nicht oder nur mit
      Fehlern möglich.

.. _schema_repair:

.. revealjs:: schema -- check & repair
   :title-heading: h3

   .. rv_code::
      :class: bash

      $ cdbpkg schema_coverage

   - ``tmp/cdbpkg_schema_coverage-views.csv``
   - ``tmp/cdbpkg_schema_coverage-tables.csv``
   - ``tmp/cdbpkg_schema_coverage-columns.csv``

   Mit Option ``-f`` reparieren, aber vorher *Komponentenarchitektur* lesen!!!

.. _config_repair:

.. revealjs:: config -- check & repair
   :title-heading: h3

   Komandozeile gibt guten Überblick über alles

   .. rv_code::
      :class: bash

      $ cdbpkg check
      ...
      cs.tools.batchoperations
      ------------------------
      masken: name=cdbbop_operation/owner=public/attribut=button_execute
        error: Referenced object does not exist
        reference: Icons
        foreign keys: {u'string1': u'foofoo'}
      ...

   Reparieren einfacher im CDB-Client / je Modul :

   Kontextmenü *Modulkonfigurationsüberprüfung*

.. _updates_und_konflikte:

.. revealjs:: Updates & Konflikte
   :title-heading: h3

   Source-Code
     Konflikte im SCM-System ermitteln & auflösen

   Konfiguration + Schema
     Konflikte in CDB ermitteln & auflösen .. CDB 10.x unter
     *Protokolle* .. CDB 15.x *Modul / Entwicklerübersicht*

   Konflikte in Schema & Konfiguration kann CDB nur erkennen, wenn das DB
   :ref:`Schema <schema_repair>` im Data Dictionary ist und die
   :ref:`Konfigurationen <config_repair>` den Modulen zugeordnet sind --
   siehe :ref:`Voraussetzungen <voraussetzungen>`

.. revealjs:: was sind Updates?
   :title-heading: h3

   DB + ``configuration`` + Source-Code sind *EINS*
     Ändert sich daran was, ist das ein *Update* -- :ref:`Voraussetzungen
     <voraussetzungen>`

   Entwicklung tauscht Patches im SCM-System aus
     ``pull`` eines Patches aus dem SCM-System in das *working directory*
     aktualisiert ``configuration`` und Source-Code (das *Update*). ``cdbpkg
     sync`` spielt Änderung in DB ein

   .. rv_small::

      Konfliktpotential hat also nicht nur ein Update der Anwendungspakete.
      Jede Änderung *die man sich in seine Instanz holt* ist ein Update mit
      Konfliktpotential .. eigentlich logisch: *Neu* seit CDB 10 ist nur, dass
      der DB Content jetzt mit dazu gehört.

.. _transport_aenderung:

.. revealjs:: Transport Source-Code & Konfiguration
   :title-heading: h3

   ::

      \---cust.plm             # CDB-Paket
          ...
          \---cust             # Python Namespace 'from cust import foo'
              ...              # Python Pakete ...
              \--foo           # Python Paket 'foo'
                 |  module_metadata.json
                 +---configuration
                 \---resources

   - **Source-Code**: sind die Python Pakete wie z.B. ``foo``. Diese werden mit
     dem SCM *gemerged*.

   - **Konfiguration**: ist im Ordner ``configuration``. Der Ordner muss mit
     ``cdpkg diff`` und ``cdpkg patch`` *gemerged* werden.

.. _merge_graph:

.. revealjs:: Merge Source-Code & Konfiguration
   :title-heading: h3

   .. figure::  merge_graph.svg
      :scale:   100 %

   Typisches Schaubild für einen *Feature-Branch*, der in den *master* Branch
   gemerged wird. Der *master* Branch kann z.B. **QS** oder **PROD** sein.  Egal
   ob man eine Kopie anlegt oder dazu ein SCM-System, es gibt immer einen
   Branch-Point und einen Merge-Point.  Die Änderungen in der DB können nur mit
   ``cdbpkg`` gemerged werden.


.. revealjs:: Merge und Commit der Konfiguration
   :title-heading: h3

   Diff zur Kopie des **Branch-Point** (Abzweigung) bilden:

   .. rv_code::
      :class: bash

      $ cdbpkg diff cust.plm -p ./branch-point-copy -d ./patch_folder

   **Merge-Point**: Patch in DB des ``PROD``-Systems einspielen:

   .. rv_code::
      :class: bash

      $ cdbpkg patch ./patch_folder/patch_cust.fo_xx_yyyy

   Konflikte in CDB auflösen, anschließend commiten

   .. rv_code::
      :class: bash

      $ cdbpkg build cust.plm               # DB export
      # git add --all .                     # SCM-Commit
      $ git commit -m "merged branch 'foo'" # ..
      $ cdbpkg commit cust.plm              # CDB-Commit

.. _cdb_und_scm:

.. revealjs:: CDB & SCM-System
   :title-heading: h3
   :subtitle-heading: h4

   - Transport des Source-Code über SCM-System.

   - Paket ``cust.plm`` wird im SCM-System versioniert.  Besteht aus
     Source-Code + ``configuration``

   - Abgleich zw. DB & ``configuration`` machen die CDB-Tools

   - CDB-Tools und SCM-System müssen synchron verlaufen (siehe
     :ref:`Merge-Schaubild <merge_graph>`)

   - Einfach mal ins SCM committen ist vorbei!  wer **das** ``pull``\ 't hat
     u.U. ein bisect_ Problem


.. revealjs:: Wahl des SCM-System

   prinzipell geht jedes, populär sind SVN_ & git_

   Verglichen mit SVN ist git beim Branchen und verteiltem Arbeiten wesentlich
   stärker. Z.B. diverse Protokolle_ zum Transport: ``file://``,
   ``http://``, ``ssh://`` usw. / s.a. `git URLs`_, `git-send-email`_

   nicht zu vergessen: SVN ist tot.

   Wir verwenden hier git_ / siehe auch `get git started`_


.. revealjs:: SCM-System einrichten
   :title-heading: h3

   .. rv_code::
      :class: bash

      (prod)$ cd cust.plm
      (prod)$ git init
      (prod)$ git add --all .
      (prod)$ git commit -m 'cust.plm initial'

   Ggf. letzte Änderungen beenden und *festschreiben*

   .. rv_code::
      :class: bash

      (prod)$ cdbpkg build cust.plm
      (prod)$ git add --all .
      (prod)$ git commit -m "add 'cust.foo' to package 'cust.plm'"
      (prod)$ cdbpkg commit cust.plm


.. _merge_strategien:

.. revealjs:: Merge Strategien
   :title-heading: h3

   SCM-Systeme wie git_ verfügen über ausgereifte Merge Strategien zum Mergen
   von **S**\ ource-\ **C**\ ode (*build-in*).

   Merge der CDB-Konfiguration benötigt besondere Strategie.

   Diese Strategie bedarf ``cdbpkg`` Tools, welche die Semantik der
   Konfiguration *kennen* und Checksummen neu berechnen können.


.. _git_merge_strategie:

.. revealjs:: Merge Strategie (git)
   :title-heading: h3

   git_ unterstützt *alternative* `Merge Strategien`_, mittels `Git Attributen`_
   kann die Strategie individuell gewählt werden.

   Um ``configuration`` **nicht** zu mergen; Strategie ``ours``.

   .. rv_code::
      :class: bash

      # location: cust.plm/.gitattributes
      # CDB 15.x
      cust/*/configuration         merge=ours

   .. *

   Dummy handler ``true`` für ``ours`` registrieren

   .. rv_code::
      :class: bash

      $ git config --local merge.ours.driver true

   .. rv_small::

      In CDB 10.x müssen noch ``patches``, ``schema.json``,
      ``module_metadata.json`` und ``content_metadata.json`` analog gesetzt
      werden (`.gitattributes`_)


.. _lieferantenanbindung:

.. revealjs:: Lieferantenanbindung
   :title-heading: h2

   .. figure::  clone_graph.svg
      :scale:   100 %

   Lieferantenanbindung erfolgt an einem Branch-Point (``foo``). Ob Branch-Point
   vom PROD- oder dem QS-System (aka. ``master``) genommen wird, muss durch die
   Projektplanung entschieden werden.  Die Auslieferung an den Lieferanten ist
   ein *Clone*.

.. revealjs:: Änderung einplanen (master)
   :title-heading: h3

   Initial gibt es den ``master`` branch, darin existiert bereits Modul ``cust.foo``
   im Paket ``cust.plm``. In dem Modul soll nun noch die Klasse ``Foo``
   konfiguriert & implementiert werden.

   .. rv_code::
      :class: bash

      $ git branch -v
      * master 268a44e add 'cust.foo' to package 'cust.plm'

   feature branch 'foo' anlegen

   .. rv_code::
      :class: bash

      $ git branch -v
        foo    268a44e add 'cust.foo' to package 'cust.plm'
      * master 268a44e add 'cust.foo' to package 'cust.plm'

.. _aenderung_beauftragen:
        
.. revealjs:: Änderung beauftragen (clone)
   :title-heading: h3
   :data-background: #332222

   Der Übergabepunkt einer Beauftragung ist der Branch-Point (``foo``). Er muss
   dem Auftragnehmer übergeben werden.

   .. rv_code::

      (dev)$ git clone file:///path/to/prod/cust.plm.git/
      (dev)$ cd cust.plm
      (dev)$ git checkout foo
      Zu Branch 'foo' gewechselt

   Für einen Spiegel beim Auftragnehmer -- ggf. auch mit Nutzdaten -- sind
   i.d.R. weitere Maßnahmen erforderlich.  Meist wird initial die komplette
   Instanz (ohne Storage) ausgeliefert.


.. revealjs:: Spiegel einrichten
   :title-heading: h3
   :data-background: #333344

   Auftragnehmer muss Spiegel-System einrichten.

   .. rv_small::

      Abhängig von den benötigten CDB & *Third-Party* Diensten oder externen
      Anwendungen kann das z.T. sehr Aufwändig bis unmöglich sein.

   Stand aus Branch ``foo`` in den lokalen Spiegel einspielen

   .. rv_code::
      :class: bash

      (dev)$ cdbpkg sync cust.plm
      (dev)$ cdbpkg commit cust.plm

   .. rv_small::

      Das ``commit`` sollte nicht unbedingt erforderlich sein, stellt aber in
      jedem Fall sicher, dass ab **jetzt** lokale Änderungen *aufgezeichnet*
      werden.

.. revealjs:: Änderung implementieren (1)
   :title-heading: h3
   :data-background: #333344

   Die Aufgabe wird in zwei Teil-Aufgaben aufgeteilt. Als erstes richtet der
   Entwickler das DB-Schema für das 'foo' feature ein.

     .. figure:: dd_class_foo_1.png
        :scale: 150 %

     .. figure:: dd_class_foo_2.png
        :scale: 150 %

   In der Entwickler-Übersicht den Dev-Build anstoßen.  Doppel-Klick auf 'Dev
   Patches' zeigt die lokalen Änderungen.

.. revealjs:: Änderung implementieren (1)
   :title-heading: h3
   :data-background: #333344

   Schema soll erster Commit ins SCM werden

   .. rv_code::
      :class: bash

      (dev)$ cdbpkg build cust.plm
      (dev)$ git add --all .
      (dev)$ git commit -m "configured 'foo' schema"

   *Dieser* Teil-Änderung ist nun im SCM-System. Alle weiteren lokalen
   Änderungen sollen relativ zu dem Stand **jetzt** *aufgezeichnet* werden.

   .. rv_code::
      :class: bash

      (dev)$ cdbpkg commit cust.plm

   In der Entwickler-Übersicht ist der Eintrag 'Dev Patches' für die lokalen
   Änderungen nun *verschwunden*.


.. revealjs:: Änderung implementieren (2)
   :title-heading: h3
   :data-background: #333344

   Entwickler erstellt ``cust.plm/cust/foo/__init___.py``

   .. rv_code::
      :class: python

      #!/usr/bin/env python
      # -*- coding: utf-8; mode: python -*-

      from cdb.objects import Object
      class Foo(Object):
          __maps_to__   = "foo"
          __classname__ = "Foo"

   und registriert den Voll qualifizierten Python Namen (FQN_).

   .. figure:: dd_class_foo_2.png
      :scale: 150 %

.. revealjs:: Änderung implementieren (2)
   :title-heading: h3
   :data-background: #333344

   Änderungen sind abgeschlossen, zweiten Commit vorbereiten ..

   .. rv_code::
      :class: bash

      (dev)$ cdbpkg build cust.plm

   In der Entwickler-Übersicht ist wieder der Eintrag 'Dev Patches' zu sehen.
   Doppel-Klick darauf zeigt die lokalen Änderungen.

   .. rv_code::
      :class: bash

      (dev)$ git add --all .
      (dev)$ git commit -m "implemented class 'Foo'"
      (dev)$ cdbpkg commit cust.plm

   Umsetzung der Anforderung ist nun vollständig im SCM-System (Source-Code und
   Konfiguration) und kann ausgeliefert werden.

.. _aenderung_ausliefern:

.. revealjs:: Änderung ausliefern (push)
   :title-heading: h3
   :data-background: #332222

   Auslieferung erfolgt in den Übergabepunkt; Branch ``foo`` des Auftraggebers.

   .. figure::  push_graph.svg
      :scale:   100 %

.. revealjs:: Änderung ausliefern
   :title-heading: h3
   :data-background: #332222
   
   .. rv_code::
      :class: bash

      $ git push origin foo
      ...
      [PATCH 1/2] configured 'foo' schema
      [PATCH 2/2] implemented class 'Foo'

   .. rv_small::

      Die Transportwege für die Übernahme und Auslieferung einer Beauftragung
      können mit git_ individuell gewählt werden (SVN_ schränkt sehr ein). Hier
      wurde ein *online* Szenario beschrieben, die zur Verfügung stehenden
      Protokolle_ wurden schon erwähnt.

   git_ ist -- wie kein anders SCM-System -- für *dezentral* und *offline*
   ausgelegt.  Lösungen für *offline* Szenarien sind z.B. git-send-email_ oder
   git-bundle_ .. um nur zwei zu nennen.


.. revealjs:: Zusammenfassung Lieferantenanbindung

   - Es muss einen reproduzierbaren Übergabepunkt (Gesammtzustand des Systems)
     geben. Hierfür eignet sich ein Branch.

   - Es muss ein Spiegel beim Lieferant aufgebaut werden. I.d.R. wird man nie
     alle Dienste und Funktionen auf dem Spiegel einrichten (zu Aufwendig).

   - Lieferant plant die Implementierung, setzt sie um, testet sie und liefert
     sie wieder an den Übergabepunkt aus.

   Bisher nicht betrachtet, wie bekommt der Auftrageber die Änderung in seinen
   ``master``?

.. _merge_dev_branches:
   
.. revealjs:: Entwicklungszweige mergen

   .. kernel-figure::  git-graph_001.dot

.. revealjs:: Merge ist immer gleich

   .. figure::  merge_graph.svg
      :scale:   100 %

   Der Merge des Branch ``foo`` enspricht genau dem :ref:`Merge-Schaubild
   <merge_graph>`. Es gibt den Branch-Point und im Merge-Point sollen die
   Änderungen aus Source-Code (``git merge``) und Konfiguration (``cdbpkg``) im
   ``master`` Branch zusammengeführt werden.

                       
.. revealjs:: Merge Strategie (cdbpkg diff)
   :title-heading: h3

   Für den ``diff`` wird der Working-tree des Branch-Points benötigt.

   .. rv_code::
      :class: bash

      $ git worktree add /tmp/foo-start 268a44e
      $ git worktree list
        /path/to/cust.plm    3e3838e [foo]
        /tmp/foo-start       268a44e (detached HEAD)

   Der Branch-Point ``268a44e`` wurde aus dem Log entnommen. Die Kopie des
   Branch-Points liegt nun unter ``/tmp/foo-start``.

   ..
      .. rv_small::

         Fürs Scripting kann er auch wie folgt ermittelt werden:

      .. rv_code::
         :class: bash

         $ BRANCH=foo
         $ diff -u <(git rev-list ${BRANCH}) <(git rev-list master) \
                   | tail -2 | head -1

.. revealjs:: Merge Strategie (cdbpkg diff)
   :title-heading: h3

   Branch ``foo`` wird ausgecheckt, jetzt diff zum Branch-Point ermitteln

   .. rv_code::
      :class: bash

      $ git checkout foo
      $ cdbpkg diff cust.plm -p /tmp/foo-start -d /tmp
      Writing changes to directory /tmp/patch_cust.fo_xx_yyyy
      11 changes on cust.foo
       1 changes on cust.plm

   Der Patch liegt jetzt bereit unter ...

   .. rv_code::
      :class: bash

      $ dir /tmp/patch_cust.fo_xx_yyyy

   Die Vorbereitungen sind damit abgeschlossen, der eigentliche Merge
   (SCM-Merge + ``cdbpkg patch``) kann nun beginnen.


.. revealjs:: Merge foo into master
   :title-heading: h3

   SCM-Merge für Source-Code & ``cdbpkg patch`` für Konfiguration

   .. rv_code::
      :class: bash

      $ cd cust.plm
      $ git checkout master
      $ git merge foo                               # SCM-Merge
      $ cdbpkg patch /tmp/patch_cust.fo_xx_yyyy     # CDB-Merge

   Konflikte in CDB auflösen, anschließend commiten

   .. rv_code::
      :class: bash

      $ cdbpkg build cust.plm
      $ git add --all .
      $ git commit -m "merged branch 'foo'"
      $ cdbpkg commit cust.plm

   .. rv_small::

      Konflikte in Sourcen werden vom SCM-System erkannt. Außnahme ist
      ``configuration`` siehe :ref:`Merge Strategie <git_merge_strategie>`.
      Konflikte in Konfiguration werden von CDB erkannt. Letztere werden über
      das Protokoll eingesehen und mit anderen Warnungen in CDB behandelt.


.. revealjs:: Zusammenfassung Merge

   - Source-Code wird vom SCM-System gemerged.

   - ``configuration`` benötigt andere :ref:`Merge Strategie
     <git_merge_strategie>`

   - Um Konfig-Änderungen zu mergen, muss der Start-Punkt reproduzierbar
     sein. **Hierfür eignen sich die Branch-Points.**

   - Der ``master`` war exemplarisch, i.d.R. wird man für den *master* min. zwei
     Branches haben: ``QS`` und ``PROD``

   - Der Transport zw. ``QS`` und ``PROD`` ist wieder vergleichbar, nur mit *anderem*
     Branch-Point und Merge-Point.

     
.. revealjs:: Merge ist immer gleich

   .. figure::  merge_graph.svg
      :scale:   100 %

   Für die Umsetzung eines *Features* (einer Anforderung) gibt es den
   Feature-Branch. Im Merge-Point werden die Änderungen aus Source-Code (``git
   merge``) und Konfiguration (``cdbpkg``) im ``master`` Branch zusammengeführt
   werden.

.. revealjs:: Danke!

.. revealjs::

.. revealjs:: Marken- & Produktnamen
   :title-heading: h5

   .. rv_small::

      CIM DATABASE (CDB) und CONTACT Elements sind Produktenamen der `Contact
      Software GmbH`_.

..
    .. revealjs:: Themes
     :id: themes

     reveal.js comes with a few themes built in:

     .. raw:: html

        <a href="#" onclick="document.getElementById('theme').setAttribute('href','_static/css/theme/beige.css'); return false;">Beige</a> -
        <a href="#" onclick="document.getElementById('theme').setAttribute('href','_static/css/theme/black.css'); return false;">Black</a> -
        <a href="#" onclick="document.getElementById('theme').setAttribute('href','_static/css/theme/blood.css'); return false;">Blood</a> -
        <a href="#" onclick="document.getElementById('theme').setAttribute('href','_static/css/theme/league.css'); return false;">League</a> -
        <a href="#" onclick="document.getElementById('theme').setAttribute('href','_static/css/theme/moon.css'); return false;">Moon</a> -
        <a href="#" onclick="document.getElementById('theme').setAttribute('href','_static/css/theme/night.css'); return false;">Night</a> -
        <a href="#" onclick="document.getElementById('theme').setAttribute('href','_static/css/theme/serif.css'); return false;">Serif</a> -
        <a href="#" onclick="document.getElementById('theme').setAttribute('href','_static/css/theme/simple.css'); return false;">Simple</a> <br>
        <a href="#" onclick="document.getElementById('theme').setAttribute('href','_static/css/theme/sky.css'); return false;">Sky</a> -
        <a href="#" onclick="document.getElementById('theme').setAttribute('href','_static/css/theme/solarized.css'); return false;">Solarized</a>
        <a href="#" onclick="document.getElementById('theme').setAttribute('href','_static/css/theme/white.css'); return false;">White</a> -
