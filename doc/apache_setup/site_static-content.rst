.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_static-content:

================================================================================
                      Static Content (static-content.conf)
================================================================================

Die Site ``static-content.conf`` stellt *statische* Resourcen bereit. Statische
Resourcen sind Dateien oder Ordnerstruturen die über HTTP freigegeben werden
sollen. I.d.R. wird hier der unveränderliche Content abgelegt, den die *Sites*
(nach-) laden. Das sind z.B. die statischen Javascript Bibliotheken für den
Betrieb einer Site oder aber auch Ordnerstrukturen, wie z.B. HTML Dokumente.

.. code-block:: bash

   sudo a2ensite static-content

Die Installation dieser *Static-Site* wird empfohlen, da auch noch weitere
Setups (z.B. :ref:`xref_site_expimp` oder :ref:`xref_site_webshare`) von diesem
Static Content profitieren. Jedoch wird nicht empfohlen, eine solche
Konfiguration, die SSI (:ref:`xref_server_side_include`) verwendet ohne weiteres
im Internet zu betreiben.

.. _xref_static_content_chrome:

``chrome`` Resource
===================

Die *chrome* Resource hat zur Aufgabe statischen Content, der zur Anzeige von
WEB-Sites wie dem *Autoindex* erforderlich ist, bereit zu stellen. In dem
*chrome* Ordner befinden sich beispielsweise die Icons zu den Dateitypen, die
das Feature ":ref:`xref_autoindex_directories`" in seinen generierten HTML
Dokumenten referenziert. Die Resource definiert sich wie unten stehend.

.. code-block:: apache

    Alias /chrome /var/www/chrome

    <Directory /var/www/chrome>

        Require all granted
        Allow from all

        AllowOverride None

        Options +Indexes +FollowSymLinks +IncludesNOEXEC

        HeaderName /chrome/header.shtml
        ReadmeName /chrome/footer.shtml

        AddType text/html .shtml
        AddHandler server-parsed .shtml

        <IfModule mod_headers.c>
            Header always set X-Robots-Tag "none"
        </IfModule>

    </Directory>


Da dieser statische Content nur der *Gestalltung* dient, ist hierfür keine
:ref:`xref_apache-auth` erforderlich, was über die Direktive ``Require all
granted`` gesetzt wird. Es macht auch keinen Sinn, wenn eine Suchmaschine diese
*Gestalltungselemente* indiziert, was mit dem ``X-Robots-Tag "none"``
konfiguriert wird (s.a. :ref:`xref_global_http_headers`).  Mittels ``Allow from
all`` wird der Zugriff aus jedem Netz erlaubt. Um den Zugriff einzuschränken
muss das ``all`` der :ref:`xref-allow-directive` durch entsprechende Netzmasken
oder IPs ersetzt werden.

* HeaderName / ReadmeName: :ref:`xref_autoindex_directories` /
  :ref:`xref_server_side_include`

* AddType / AddHandler :  :ref:`xref_server_side_include`

* Options: :ref:`xref_options_indexes`

.. _xref-allias-directive:

Alias Direktive
===============

Mit der Alias Direktive aus dem `Apache mod_alias`_ Modul kann auf Resourcen
verwiesen werden die nicht im ``DocumentRoot`` Ordner liegen. Die Resource wird
dann unter der entsprechenden URL zur Verfügung gestellt.

.. code-block:: apache

    Alias /chrome /var/www/chrome
    <Directory /var/www/chrome>
       ...

Mit dieser Direktive wird der Content aus dem Ordner ``/var/www/chrome`` unter
der URL https://localhost/chrome referenziert.

.. _xref-allowoverride-directive:

AllowOverride
=============

Mit der `Apache AllowOverride Direktive`_ wird gesetzt, welche Otionen in einer
``.htaccess`` lokal in einem Ordner angepasst werden können. Mit

.. code-block:: apache

   AllowOverride None

darf keine Option überschrieben werden. Andere sinnvolle Werte können
z.B. Anpassungen an der Autorisierung und dem Autoindex sein:

.. code-block:: apache

   AllowOverride AuthConfig Indexes

Hier im Setup werden lokale Anpassungen in ``.htaccess`` Dateien nicht
erforderlich werden, manche Installation einer WEB-Anwendung ist aber auf
*Overerrides* angewiesen.


.. _xref-allow-directive:

Allow-Direktive
===============

In der Allow-Direktive (`Apache Access Control`_ / `Apache mod_acces_compat`_)
können nicht nur IPs bzw. Netzmasken angeben werden, es ist auch möglich Domian-
oder Host-Namen anzugeben. Es sind aber die Netzmasken den *Host-/Domain-Namen*
vorzuziehen, da die Namensauflösung Zeit und Netztraffic in Anspruch nehmen kann
und es nicht auszuschließen ist, dass der `DNS (wiki)`_ -- *den der Apache
benötigt um die IP Adresse in einem Namen aufzulösen* -- Teil eines
Angriffszenarios ist, oder ob er einfach nur *buggy* ist.

Um eine solche Konfiguration strukturiert durchführen zu können müssen die
Grundlagen der Natzmaskierung bekannt sein, die in der
:ref:`xref_excursion_IPv4_6` vermittelt werden. I.d.R. wird man den Zugriff aus
den folgenden Netzen konfigurieren:

* Netzweit                        ``all``

* IPv4 localhost:                 ``127.0.0.0/8``
* IPv4 *privates* Class-A Subnetz ``10.0.0.0/8``
* IPv4 *privates* Class-B Subnetz ``192.168.0.0/16``
* IPv4 *privates* Class-C Subnetz ``192.168.0.0/24``

* IPv6 localhost:                  ``::1``
* IPv6 Link-Lokal Netz:            ``fe80::/10``
* IPv6 Unique-Local Subnetz:       ``fd00::/8``

Die ``Allow``, ``Order`` und ``Deny`` Direktiven wurden bereits im
:ref:`xref_deny_from_root` gesetzt, es wurde *alles dicht gemacht*. Um eine Site
*Netzweit* frei zu geben, muss die Allow-Direktive auf ``all`` gesetzt. werden

.. code-block:: apache

   Allow from all

Um die Site in dem Link-Lokal Netzt frei zu geben eignet sich:

.. code-block:: apache

   Allow from fd00::/8 192.168.0.0/16 fe80::/10 127.0.0.0/8 ::1

Die beiden letzten Beispiele basieren auf den vererbeten ``Order`` und die
``Deny`` Direktieven aus dem :ref:`xref_deny_from_root` Konzept. Die Vererbung
kann oft ein hilfsreiches Gestaltungsmittel sein, bei der Gewährung von
Zugriffsrechten auf eine Site empfiehlt es sich *expliziet* zu sein und auf eine
Vererbung zu verzichten. Man muss dann zwar etwas mehr notieren, aber die
Zugriffkontrolle ist damit zentral an der *Site* angebracht und
unmissverständlich.

.. code-block:: apache

   Order deny,allow
   Deny from all
   Allow from fd00::/8 192.168.0.0/16 fe80::/10 127.0.0.0/8 ::1

.. _xref_autoindex_directories:

Autoindex von Directories
=========================

Zum *Static Content* gehört in diesem Setup noch die Installation des `Apache
mod_autoindex`_ Moduls. Mit diesem Modul wird die Auflistung des Inhalts eines
Ordners (eines *Directory*) in ein HTML Dokument umgewandelt und über HTTP an
den WEB-Browser gegeben. Sozusagen, ein *nur lesender* Dateiexplorer über
HTTP. Mit dem *Autoindex* kann in der Ordnerstruktur einer Resource navigiert
werden. Die :ref:`xref_site_sysdoc` (*sysdoc*) oder der :ref:`xref_site_expimp`
Ordner sind Beispiele für diese Anwendung des *Autoindex*.

Mit dem Autoindex-Modul wird von Debian noch eine Default-Konfiguration
ausgeliefert, die *hier* im Setup jedoch durch eine etwas *verbesserte*
Konfiguration ersetzt wird.

* Default: ``/etc/apache2/mods-available/autoindex.conf``
* Anpassung:  ``/etc/apache2/conf-available/autoindex.conf``

.. code-block:: bash

   sudo mv autoindex.conf autoindex.conf-disabled
   sudo a2enconf autoindex
   sudo a2enmod autoindex

In der ``autoindex.conf`` wird das Setup für die Anzeige der Ordnerinhalte
konfiguriert. Hier ein Auszug:

.. code-block:: apache

   <IfModule mod_autoindex.c>

       IndexOptions FancyIndexing XHTML HTMLTable SuppressHTMLPreamble \
                    VersionSort FoldersFirst DescriptionWidth=* NameWidth=* \
                    Charset=UTF-8
       ...
       AddIconByType (IMG,/chrome/icons/16x16/mimetypes/gnome-mime-image.png) image/*
       AddIconByType (SND,/chrome/icons/16x16/mimetypes/gnome-mime-audio.png) audio/*
       AddIconByType (TXT,/chrome/icons/16x16/mimetypes/gnome-mime-text.png) text/*
       AddIconByType (VID,/chrome/icons/16x16/mimetypes/gnome-mime-video.png) video/*
       ...
       AddDescription "tar (tape) archive" .tar
       AddDescription "GZIP compressed document" .Z .z .gz .zip
       AddDescription "ZIP compressed document" .zip

Die `Apache IndexOptions Direktive`_ wird wie die `Apache Options Direktive`_
vererbt (vergleiche :ref:`xref_options_indexes`).

Die ``IndexOptions`` Direktive steht *hier* in einem globalen Kontext, damit
wird sie auf jede (freigegebene) statische Resource *vererbt*.  Will eine
Autoindex-Site den ``FancyIndex``-Style nicht eingeschaltet haben, dann muss
diese Autoindex-Site ``IndexOptions -FancyIndex`` definieren. Die ``+/-``
Notation wird am Beispiel :ref:`xref_options_indexes` noch genauer erläutert.

In dem obigen Ausschnitt der Konfiguration ist auch zu sehen, dass für die
Dateitypen (Mimetypes) die passenden Icons konfiguriert werden. Diese Icons
werden in der Ordneransicht des Autoindex dann mit angezeigt. Die Icons werden
in dem -- vom Autoindex generierten -- HTML Dokument als ``img``-Tag
eingebunden:

.. code-block:: html

   <img src="/chrome/icons/16x16/mimetypes/gnome-mime-image.png" ... >

.. hint::

   Der Browser wird das Bild unter der URL ``https://myhostname/chrome/``
   nachladen. Hier *schließt sich dann der Kreis* von Autoindex und der
   statischen *chrome* Resource.


.. _xref_options_indexes:

Autoindex aktivieren
====================

Mit der Direktive ``Options +Indexes`` wird der *chrome* Ordner im WEB-Browser
auch *navigierbar* (vergleiche :ref:`xref_static_content_chrome`).

.. code-block:: apache

   Options +Indexes +IncludesNOEXEC +FollowSymLinks

Die `Apache Options Direktive`_ wird vererbt. Bereits im Root Ordner (vergleiche
:ref:`xref_deny_from_root`) wurden die *default* ``Options`` im *globalen*
Dateisystem-Kontext gesetzt. Diese werden auf alle Ordner (und somit auch auf
den *chrome* Ordner) vererbt. Diese *Vererbung* kann *überschrieben* werden oder
mittles des ``+/-`` Präfix an den Optionen spezialisiert werden.

Überschrieben würde sie z.B. mit ``Options Indexes``. Das würde zwar den
Autoindex aktivieren, jedoch hätte man alle Optionen aus dem globalen Kontext
verloren. Da in *diesem* Setup Konzept wie die "der Verbung" zur Anwendung
kommen sollen (*wir wollen die global einheitlich Optionen an einer Stelle
setzen können*) muss die `Apache Options Direktive`_ im Kontext des *chrome*
Ordners spezialisiert werden.

Mit dem ``+`` vor dem ``Options +Indexes`` wird die Option *aditiv* zu den
geerbeten Optionen hinzugefügt. Mit einem ``-`` vor der Option können geerbte
Eigenschaften abgeschaltet werden.  Soll beispielsweise eine Einstellung die aus
dem globalen Kontext geerbt wurde im *chrome* Ordner abgeschaltet werden, so
muss das ``-`` als Präfix verwendet werden (``Options -Opt2Drop``).

.. hint::

  Wenn das ``+/-`` Präfix in einer Resource für eine Option angewendet wird,
  muss es für alle Optionen in dieser Resource angewendet werden. Direktieven
  wie ``Options Indexes`` führen dazu, dass der Autoindex zwar eingeschaltet
  würde, aber gleichzeitig alle geerbten Optionen verloren gehen würden (wegen
  dem fehlenden ``+/-`` vor ``Indexing``). Solche gemischten Notationen führen
  zu verwirrenden Ergebnissen, weshalb man sich in einer Resource immer dafür
  entscheiden sollte die Vererbung zu spezialiseren (nur ``+/-``) oder komplett
  zu verwerfen. Bei Letzterem müssen dann alle Optionen ohne das Präfix notiert
  werden.

.. _xref_server_side_include:

Serverside Includes
===================

Die Generierung der HTML-Seiten mit der Auflistung der Dateien in einem Ordner
ist in diesem Setup mittels Server Side Includes (SSI) relalisiert (siehe
`Introduction to SSI`_).

SSI sind umstritten, sie sollten nur mit Umsicht eingesetzt werden. Dazu gehört,
dass in KEINEM Fall die ``#exec`` -Direktieve verwendet wird!  Hier im Setup
werden SSI nur verwendet, um die Autoindex-Seiten etwas *aufzubrezeln* und es
werden die SSI-Skripte **NUR** im Kontext des Chrome-Ordners aktiviert
(vergleiche :ref:`xref_static_content_chrome`).

.. code-block:: apache

   AddType text/html .shtml
   AddHandler server-parsed .shtml

Im Chrome Ordner gibt es auch nur zwei kleine SSI-Skripte für den *Header* und
die *Readme* des Autoindex. Will ein Autoindex in einem anderen Kontext diese
verwenden, muss er nur die beiden Dateien aus dem Chrome-Ordner setzen.

.. code-block:: apache

   HeaderName /chrome/header.shtml
   ReadmeName /chrome/footer.shtml

Da auch der Chrome Ordner mit dem Autoindex *navigierbar* ist, werden sie auch
im Chrome Ordner gesetzt (vergleiche :ref:`xref_static_content_chrome`).

.. caution::

   Andere Kontexte als der Chrome-Ordner **sollen keine** SSI-Skripte
   aktivieren. Sie benötigen keine ``AddHandler server-parsed .shtml``
   Direktieve.


