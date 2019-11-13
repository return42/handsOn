.. -*- coding: utf-8; mode: rst -*-

.. include:: ../mozcloud_refs.txt
.. include:: ../apache_setup_refs.txt

.. _xref_mozcloud_fxsync:

================================================================================
                     Sync-1.5 Server mit public accounts
================================================================================

In der ersten Ausbaustuffe sollte man sich den Firefox Sync-1.5 Server auf
seinem Host installieren und die Accountverwaltung über den `Mozilla (public)
Account Server`_ realisieren.

.. _xref_mozcloud_fxsync_install:

Installation
============

In dem ``${SCRIPT_FOLDER}`` Ordner befinden sich Skripte, die alle
erforderlichen Schritte für eine Installation durchführen.

.. code-block:: bash

   $ sudo -H ./scripts/mozcloud_setup.sh installMozCloudEnv
   $ sudo -i -u mozcloud
   mozcloud$ ${SCRIPT_FOLDER}/mozcloud_fxsync.sh installSyncServer

Die oben durchgeführte Installation besteht aus folgenden Schritten:

1. Es müssen die Entwicklerpakete auf dem OS installiert werden. Sie werden
   benötigt um die *virtualenv* Umgebung aufzubauen und die Python Module die
   ggf. compiliert werden müssen zu compilieren (s.u. ``make build``).

.. code-block:: bash

   sudo -H apt-get install python-dev git-core python-virtualenv g++

2. Es muss ein System-Benutzer (``mozcloud``) für die Cloud Dienste angelegt
   werden (siehe :ref:`xref_mozcloud_setup`). Es wird in den Account dieses
   System-Benutzers gewechselt um darin die Installation des Firefox Sync-1.5
   Server durchzuführen.

3. Es wird der Firefox Sync-1.5 Server (unter dem System-Benutzer) eingerichtet
   und es werden die dort angebotenen Tests ausgeführt (checkt, ob Installation
   soweit OK). Siehe `Run your own Firefox Sync-1.5 Server (github)`_.

.. code-block:: bash

   $ sudo -i -u mozcloud
   ...
   mozcloud$ git clone https://github.com/mozilla-services/syncserver
   mozcloud$ cd syncserver
   mozcloud$ make build
   ...
   mozcloud$ make test

Durch das ``make build`` wird *virtaulenv* Umgebung (``~/syncserver/local``)
eingerichtet in der alle erforderlichen Python-Pakete gleich installiert wurden.

Die Konfiguration des Sync-Servers erfolgt in der ``syncserver.ini``. Für einen
ersten Test sollte man dort einstellen.

.. code-block:: ini

   [server:main]
   # ...
   host = localhost
   port = 5000
   # ...
   [syncserver]
   public_url = https://<hostname>/fxSyncServer

   # für gunicorn muss die die public_url wie folgt geändert werden
   #
   # public_url = http://localhost:5000/

   secret = b2ec16d7192d6162ebab5cfc723821e23ce9deab  -
   # ...
   sqluri = sqlite://///home/mozcloud/syncserver/syncserver.db

Die ``[server:main]`` Einträge sind nur für den Test mit dem *gunicorn*
WEB-Server (Entwicklerumgebung) erforderlich.

In der ``public_url`` muss die URL eingestellt werden unter der ein FFox-Browser
den Dienst erreichen kann. In Abschnitt :ref:`xref_apache_site_fxSyncServer`
wird eine Site im Apache eingerichtet, die den Sync-Server unter der URL
``https://<hostname>/fxSyncServer`` bereit stellt.

    Meiner Erfahrung nach sollte der Secret-Key (``secret = ...``) in der
    Konfigurationsdatei unbedingt gesetzt werden. Der Server berechnet auch
    selber einen, wenn man ihn nicht setzt. Dieser hat jedoch den Nachteil, dass
    er flüchtig ist, wass zu Problemen führt. Bei mir gab es eine Fehlermeldung
    im Log des Sync-Servers::

        WARNING:syncstorage:Authentication Failed: invalid hawk id

    Mit der Folge, dass im FFox-Browser die Synchronisierung mit Fehler
    abbricht, zu erkennen an dem kleinen gelben
    *Achtung-Ausrufungszeichen-Dreieck*.

.. _xref_mozcloud_fxsync_dev_test:

Entwickler Test
===============

Für den Entwickler Test wird ein gunicorn Server gestartet, dafür muss die
``public_url`` in der ``syncserver.ini`` auf ``http://localhost:5000/`` gesetzt
werden.

.. code-block:: ini

   [server:main]
   # ...
   host = localhost
   port = 5000
   # ...
   [syncserver]
   public_url = http://localhost:5000/

In dem ``${SCRIPT_FOLDER}`` Ordner befindet sich ein Skript, mit dem ein
debug-Server (gunicorn) gestartet werden kann.

.. code-block:: bash

   $ sudo -i -u mozcloud
   ...
   mozcloud$ ${SCRIPT_FOLDER}/mozcloud_fxsync.sh runSyncServer

Der Test dauert ein paar Sekunden, mit ihm wird ein gunicorn Server gestartet
und es wird ein :man:`curl` Kommando abgesetzt. Die Ausgabe des :man:`curl`
Kommandos wird unten noch interpretiert.

Alternativ zu obigem Test mit dem Skript kann der Sync-Server auch in der
Entwicklerumgebung mit dem :man:`make` Target ``serve`` gestartet werden.

.. code-block:: bash

   $ sudo -i -u mozcloud
   ...
   mozcloud$ cd syncserver
   mozcloud$ make serve

In einem zweiten Terminal kann man mit :man:`curl` eine erste Abfrage des
Servers testen.

.. code-block:: bash

   $ curl http://localhost:5000/token/1.0/sync/1.5
   {"status": "error", "errors": [{"location": "body", "name": "", "description": "Unauthorized"}]}

Erhält man obige Ausgabe, so kann man sich zumindest sicher sein, dass der
Dienst läuft und unautorisierte Zugriffe ablehnt ;-) Ein abschließender Test
sollte noch im FireFox WEB-Browser durchgeführt werden (siehe
:ref:`xref_mozcloud_fxsync_FFox_setup`). Danach sollten sich die FFox-Browser
(mit gleichem FFox Account) automatisch synchronisieren.


.. _xref_mozcloud_fxsync_FFox_setup:

FireFox Browser Sync-Setup
==========================

Das Setup in den Firefox Instanzen ist recht einfach, es muss einmal ein Account
angelegt werden und in allen Clients muss der oben eingerichtete Sync-Server als
Tokenserver eingetragen werden. Die Clients *syncen* mit diesem Server, sobald
sie einmal mit dem Account angemeldet wurden.

**public Account anlegen**

Es wird auf dem `Mozilla (public) Account Server`_ ein Account zum Testen
angelegt.  Will man hierfür nicht seine eigene eMail Adresse *verschwenden*, so
reicht es für einen ersten Test aus, sich über den `Mailinator
<http://mailinator.com/>`_ einen Account bei Mozilla zu holen.

  Im `Mozilla (public) Account Server`_ beim Anlegen eines Logins die gewünschte
  eMail Adresse (z.B. dit_un_dat@mailinator.com) angeben -- bitte ``dit_un_dat``
  durch was *Eigenes, Ausgedachtes* ersetzen -- und dann das Postfach
  ``to=dit_un_dat`` beim Mailinator http://mailinator.com/inbox.jsp?to=dit_un_dat
  abrufen.

.. hint::

   Der Mailinator sollte nur für Tests genutzt werden. In keinem Fall sollte
   sich eine *produktive* Instanz über ein solches Konto verifizieren oder gar
   Daten auf die öffentlichen Mozilla Server *syncen*.

**ersten FFox Browser anmelden**

Ein FFox-Browser muss über den zuvor erstellten Account angemeldet werden und in
der ``about:config`` muss der oben eingerichtete Sync-Server (dessen ``public_url``)
eingetragen werden.  Will man den, über :ref:`xref_apache_site_fxSyncServer`
freigegebenen Server nutzen, so eignet sich die SSL Adresse des Intranet-Servers::

    identity.sync.tokenserver.uri :: https://<hostname>/fxSyncServer/token/1.0/sync/1.5

.. hint::

   Wenn man in seinem FFox Client den Token-Server wechselt (also den Eintrag für
   die uri ändert), dann muss man *sync* erst mal *trennen* und neu Anmelden.
   Ansonsten ist der Account nicht auf dem neuen Token-Server bekannt.

.. hint::

   Wer auf seinem Apache ein Self-Signed SSL Certificate (z.B. snake-oil)
   installiert hat, der sollte sich einmal über https://<hostname> das
   Zertifikat in den Firefox holen, resp. das dort *angemaulte* Zertifikat des
   Servers seinem Browser hinzufügen.

   Bei der Firefox App des Android geht man im Grunde analog vor
   (``tokenserver.uri`` eintragen). Da der Sync-Client der FFox App jedoch den
   Java SLL Stack des Android nutzt, hat man i.d.R. Probleme mit einem
   *Self-Signed SSL Certificate*. Wie man auch ein Android dazu bekommt selbst
   signierte Zertifikate zu aktzeptieren, beschreibe ich in dem Abschnitt:
   :ref:`android_snakeoil`.


Will man nur einen Test durchführen, so sollte man hier die gunicorn URL
eintragen. Diese URL ist eine ``http://`` URL, kein SSL::

    identity.sync.tokenserver.uri :: http://localhost:5000/

Will man diese Browser-Einstellung für alle Benutzer eines Systems einrichten,
so kann man in der ``/etc/firefox/syspref.js`` folgende JavaScript Zeile
einfügen.

.. code-block:: javascript

   lockPref(
       "identity.sync.tokenserver.uri"
       , "https://<hostname>/fxSyncServer/token/1.0/sync/1.5"
       );

Nachdem der erste Browser angemeldet ist synchronisiert er seine Bookmarks und
Einstellungen. Was alles synchronisiert werden soll, kann im FFox unter den
*Einstellungen* eingestellt werden:

* about:preferences?entrypoint=menupanel#sync

**Weitere FFox Instanzen anmelden**

In allen weiteren FFox Instanzen, die an der Synchronisierung teilnehmen sollen,
muss wieder der FFox-Browser über den zuvor erstellten Account angemeldet werden
und in der ``about:config`` muss der oben eingerichtete Sync-Server (dessen
``public_url``) eingetragen werden (siehe oben beim *ersten FFox Browser*).


.. _xref_apache_site_fxSyncServer:

Site fxSyncServer.conf
======================

Der Firefox Sync-1.5 Server ist eine WSGI Anwendung und kann hinter jeden WSGI
fähigen WEB-Server gelegt werden. Folgend wird eine kleine Konfiguration
vorgestellt, mit der man den Dienst in seinen (bereits SSL verschlüsselten)
Apache Server verlegt.

Es wird davon ausgegangen, das bereits `Apache mod_wsgi`_ installiert ist
(`mod_wsgi RTD`_). Eine exemplarische Installation ist in dem Abschnitt
:ref:`xref_site_pyapps` des Artikels :ref:`xref_apache_setup` zu finden.

In dem ``${SCRIPT_FOLDER}`` Ordner befindet sich ein Skript, mit dem die
Installation durchgeführt werden kann.

.. code-block:: bash

   $ sudo -H ./scripts/mozcloud.sh installApacheSite

Die oben durchgeführte Installation besteht aus einer *Site*, die in der Datei

* ``/etc/apache2/sites-available/fxSyncServer.conf`` angelegt wurde.

.. code-block:: apache

   <IfModule mod_wsgi.c>

       WSGIDaemonProcess fxSyncServer \
         user=mozcloud group=nogroup \
         processes=2 threads=5 \
         python-path=/home/mozcloud/syncserver/local/lib/python2.7/site-packages/

       WSGIScriptAlias /fxSyncServer \
         /home/mozcloud/syncserver/syncserver.wsgi
   ...

In der Konfiguration wird eine Prozessgruppe ``fxSyncServer`` eingerichtet,
deren Prozesse unter dem Account ``mozcloud`` (und nogroup) laufen. Es wird ein
Alias auf die ``syncserver.wsgi`` Datei, das WSGI Interface gelegt
(s.a. :ref:`xref-allias-directive`).

Die eben eingerichtete Prozessgruppe ``fxSyncServer`` wird nun in der Resource
``/home/mozcloud/syncserver`` genutzt. Die Resource wird eingerichtet und im
Subnetz verfügbar gemacht, Zugriffe aus dem Internet sollen nicht möglich sein
(s.a. :ref:`xref-allow-directive`).

.. code-block:: apache

   ...
       <Directory /home/mozcloud/syncserver>

           Require all granted

           # Die Seiten sind nur im Subnetz verfügbar, nicht von *draußen*
           Order deny,allow
           Deny from all
           Allow from fd00::/8 192.168.0.0/16 fe80::/10 127.0.0.0/8 ::1
           AllowOverride None
   ...

Nun wird in der Resource die Prozessgruppe ``fxSyncServer`` genutzt.  Hierbei
ist zu darauf zu achten, dass sich der Sync-Server selber authentifiziert -- die
Authentifizierung wird beim FFox Sync-Server nicht vom Apache gemacht.  Damit
der Sync-Server authentifizieren kann, benötigt er die HTTP Authorization Header
aus dem *Request*, siehe auch `HTTP-Headerfelder (wiki)`_. Der Apache wird mit
``WSGIPassAuthorization On`` angewiesen diese Header Felder an die
WSGI-Anwendung durchzureichen. Für Anwendungen die vom Apache authentifiziert
werden, sollte `WSGIPassAuthorization`_ auf ``Off`` gesetzt werden.

.. code-block:: apache

   ...
           WSGIApplicationGroup %{GLOBAL}
           WSGIProcessGroup fxSyncServer
           WSGIPassAuthorization On
   ...

Da es sich um einen Sync-Dienst handelt, sollen die Robots nicht versuchen
diesen zu indizieren.

.. code-block:: apache

   ...
           <IfModule mod_headers.c>
               Header always set X-Robots-Tag "none"
           </IfModule>

       </Directory>

   </IfModule>

.. hint::

  Die ``WSGI....`` Direktieven sind in der `mod_wsgi RTD Konfiguration`_
  beschrieben, siehe auch :ref:`xref_site_py_apps_conf`.

Der WSGI Sync-Server wird im Apache unter der URL:

* ``https://<myhost>/fxSyncServer``

bereit gestellt. Der Port ist der Standard ``https:`` Port 443 und nicht mehr
5000 wie in der Test-Instanz.

Die ``identity.sync.tokenserver.uri`` in den FFox Browsern muss entsprechend
gesetz werden (siehe :ref:`xref_mozcloud_fxsync_FFox_setup`).

.. code-block:: javascript

   lockPref(
       "identity.sync.tokenserver.uri"
       , "https://<hostname>/fxSyncServer/token/1.0/sync/1.5"
       );





