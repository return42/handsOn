.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_mod_security2:

================================================================================
                                WAF: ModSecurity
================================================================================

Um den Apache-Server und die auf ihm betriebenen Anwendungen etwas robuster
gegen Angriffe zu machen kann man sich eine `WAF (wiki)`_ installieren. Im
Abschnitt :ref:`xref_dbp_apache_pkgs` wurde bereits das Paket
:deb:`libapache2-modsecurity` mit dem `ModSecurity`_ installiert. In der
Standard-Installation ist die *Application-Firewall* damit aber noch nicht
aktiviert. Zur vollständigen Installation gehört noch die Auswahl der
*Security-Rules* und die Aktivierung des *Blockings* bei Erkennung von
Angriffen (im *default* wird nur gelauscht und protokoliert).

Die Aufrechterhaltung eines gewissen Grads an Sicherheit ist keine einmalige
Aktion. Je nach Gefährdungslage ist dies u.U. eine sehr anspruchsvolle und
kontinuierliche Aufgabe, bei der man immer bereit sein muss Neues zu lernen. Für
geringe Gefährdungslagen reichen meist aber schon einfache solide Konzepte und
regelmäßige Updates. In diesem Sinne soll hier das ModSecurity vorgestellt und
eingerichtet werden.

ModSecurity -- wie auch jede andere Firewall -- basiert mehr oder minder auf
einer vielzahl von Filtern, die auf Requests (und / oder Response) einer
Kommunikation angewendet werden. Die Filter sollen Kriterien liefern, auf deren
Basis eine Bewertung stattfinden kann, ob es sich nun um einen Angriff oder eine
ganz normale Kommunikation handelt. Nicht immer sind die resultierenden
Bewertungen korrekt. Neue Schwachstellen sind in den Filtern nicht hinterlegt
und manche Kommunikation ähnelt evtl. einem Angriff, bei der ein Filter
*matched*.

Letzteres nennt man **False Positive** und es ist davon auszugehen, dass eine
Firewall auch *False Positive* liefert, sonst stimmt irgendwas mit ihr nicht. In
dem Fall, das es keine *False Positive* gibt, ist mit hoher Wahrscheinlichkeit
davon auszugehen, dass die Filter zu schwach sind und die Firewall Lücken
aufweißt.

Die **False Positive** führen am Ende dazu, dass Anwendungen nicht funktionieren
oder Fehler liefern. Die nachträgliche Einführung einer Firewall birgt also auch
immer das Risiko, dass existierende Anwendungen nicht mehr problemlos
laufen. Das ist insbesondere der Fall wenn man *gewachsene* Infrastrukturen
nachträglich mit einer Firewall ausstattet oder die Firewall
austauscht. Leztlich bleibt es eine Abwägung zw. der Gefährdungslage und dem
Schaden, der im *Betrieb* entsteht, weil Filter die Anwendung
blockieren. I.d.R. empfiehlt es sich zugunsten der Sicherheit zu entscheiden und
*Anlaufschwierigkeiten* bei den Anwendungen in kauf zu nehmen. Nicht selten
steigt auch die Qualität der Anwendungen, wenn an der Firewall deutlich wird,
wie fehlerhaft sie programmiert oder eingerichtet wurden.

* `Most Frequent False Positives Triggered by OWASP ModSecurity Core Rules 2.2.X`_


Debian ModSecurity Distribution
===============================

Das ModSecurity Modul in der Debian Distribution besteht aus den Paketen

* :deb:`modsecurity-crs` und
* :deb:`libapache2-mod-security2`.

Die aktuellen Sourcen sind über `ModSecurity (github)`_ verfügbar, auf dem auch
ein Wiki mit den `ModSecurity Direktiven`_ zu finden ist.

Die Konfiguration im Debian Setup ist in etwa wie folgt und besteht aus
folgenden Teilen (Stand 02/2106).

1. Die Konfiguration, die das Modul im Apache einbindet. Bei Debian ist das im
   Default die ``/etc/apache2/mods-available/security2.conf`` Datei.

   Diese Datei bindet alle folgenden Konfigurationen ein, resp. entscheidet
   darüber welche Konfigurationen weiter importiert werden sollen. Ihre Includes
   können beispielsweise wie folgt aussehen.

   .. code-block:: apache

      IncludeOptional /etc/modsecurity/*.conf

2. Unter ``/etc/modsecurity`` liegt bei Debian dann eine
   ``modsecurity.conf-recommended`` Datei, die man *aktivieren* muss (indem man
   die Datei nach ``modsecurity.conf`` umbenennt und anpasst). In dem Ordner
   kann man dann eine weitere Konfiguration anlegen, in der man die Rules aus
   ``/usr/share/modsecurity-crs/activated_rules`` *includen* kann.

3. Die CRS Rules liegen bei Debian im Ordner ``/usr/share/modsecurity-crs/`` und
   dort soll man dann im Unterordner ``./activated_rules`` symbolische Links zu
   den Rules anlegen die man aktivieren möchte (so sieht es die OWASP vor).

Mir persöhnlich gefällt dieses Setup nicht. Es hat für mein Empfinden zu viele
Indirektionen und man muss in Dateien in unterschiedlichsten Ordnern editieren
und noch *irgendwo* symbolische Links setzen. Das ist alles viel zu kompliziert
zu pflegen. Das geht viel *smarter*. Da man eh selber den Link legen und den
apache-Reload ausführen muss, machen diese zusätzlichen Indirektionen in meinen
Augen wenig Sinn. Man vermeidet es zwar Dateien editieren zu müssen, ich selber
empfinde es aber besser, man sichert und versioniert seine Konfigurationen und
kann so auch später seine Änderungen zurückverfolgen -- was bei dem Lösen von
Links prinzipell auch möglich ist (wenn man Links versioniert), aber ein *diff*
ist da schon anschaulicher.

.. epigraph::

   Die Debian Distribution, als auch das unten vorgestellte *einfachere Konzept*
   bedienen sich des `OWASP ModSecurity Core Rule Set (CRS)`_. Die letzte
   Version ist aktuell (Stand 02/2016) 2.2.9. Diese ist auch im Debian
   Paket. Seit dem hat sich in dem *master* Branch in dem `OWASP ModSecurity CRS
   (github)`_ Repository auch nicht viel getan. Kleinere Bugfixes gab es zwar,
   aber die scheinen mir eher marginal. Ich vermute mal, das liegt daran, dass
   die version 3.x noch *begutachtet* wird (s.a. `OWASP ModSecurity Core Rules:
   Comparing 2.2.x and 3.0.0-dev`_).


Ein einfache(re)s Konzept
=========================

Im Folgendem wird ein einfaches und gradliniges Setup aufgestellt, das auf
den aktuellen `OWASP ModSecurity Core Rule Set (CRS)`_ des `The Open Web
Application Security Project (OWASP)`_ aufbaut. Diese Rules können über `OWASP
ModSecurity CRS (github)`_ bezogen und aktuell gehalten werden.

Es werden Sicherheits-Profiele erstellt und diese im ``conf-available`` Ordner
der Debian Installation ablegt. Mit den Kommandos :man:`a2enconf` und
:man:`a2disconf` können diese Profile aktivieren bzw. deaktivieren
werden. Letzteres, das Deaktivieren bzw. das kurzfristige Umschalten
zw. vorbereiteten Profielen, kann bei *Anlaufschwierigkeiten* den Betrieb
sicherstellen bzw. kurzfristig wieder herstellen, bis der *Show-Stopper*
identifiziert und ausgemerzt ist.

Das Setup besteht aus folgenden Schritten:

1. Es wird unter ``/usr/share/owasp-modsecurity-crs`` das git-Repository mit den
   `OWASP ModSecurity CRS (github)`_ Rules geklont.

2. Die default Konfiguration ``/etc/apache2/mods-available/security2.conf`` wird
   deaktiviert.

3. An ihre Stelle tritt die *eigene* Konfiguration im ``conf-available``
   Ordner mit dem Dateinamen ``mod_security2.conf``.

4. In der ``mod_security2.conf`` werden alle *Grundeinstellungen* des
   ModSecurity vorgenommen.

5. Das Rule-Setup wird über *Profile* im ``conf-available`` Ordner vorbereitet
   und mit :man:`a2enconf` und :man:`a2disconf` aktiviert / deaktiviert.

Aufbau der ``mod_security2.conf`` Konfiguration und der Profile im
``conf-available`` Ordner::

  /etc/apache2/
  ├── apache2.conf
  ├── conf-available
  │   ├── apache2-doc.conf
  ... │...
  │   ├── mod_security2.conf
  ... │...
  │   ├── owap_crs_2.2.9_10_minimal.conf
  │   ├── owap_crs_2.2.9_50_additional.conf
  │   ├── owap_crs_2.2.9_90_SecRuleRemove.conf
  ...

Die `Beispiele für Sicherheitsprofile`_ werden weiter unten noch beschrieben.


.. _xref_mod_security2_conf:

Basis Konfiguration ``mod_security2.conf``
==========================================

In diesem Setup wurde die ``/etc/apache2/mods-available/security2.conf``
Konfiguration durch eine ``mod_security2.conf`` Konfigration im
``conf-available`` Ordner ersetzt. In dieser Konfiguration findet das
Basis-Setup des ModSecurity Moduls statt. Dazu gehört z.B. die die Direktieve
``SecRuleEngine On`` mit der die Firewall aktiv blockiert und nicht mehr nur
*lauscht*.

.. code-block:: apache

   # Enable ModSecurity, attaching it to every transaction. Use detection only
   # to start with, because that minimises the chances of post-installation
   # disruption.
   #
   # SecRuleEngine DetectionOnly

   SecRuleEngine On

Mit den Direktiven ``SecRequestBodyLimit`` und ``SecRequestBodyNoFilesLimit``
(siehe `ModSecurity Direktiven`_) werden Limits für Body- und Dateigrößen
eingestellt.

.. code-block:: apache

   SecRequestBodyLimit 13107200
   SecRequestBodyNoFilesLimit 131072

.. hint::

   Diese Einstellungen des ModSecurity stehen ggf. in Konkurenz mit den
   Einstellungen in :ref:`xref_security_limits_timeouts`. Beispielsweise hat die
   Direktive ``SecRequestBodyLimit`` das Pendant ``LimitRequestBody``  im
   :ref:`xref_security_limits_timeouts`.

Die temporären Ordner werden beispielsweise wie folgt engerichtet.

.. code-block:: apache

    SecTmpDir     /tmp/
    SecDataDir    /var/cache/modsecurity
    SecUploadDir  /var/cache/modsecurity/upload/

Die ``/tmp`` und ``cache`` Ordner sind keine gute Wahl, ihre Resoucen können
unter Umständen etwas ausufern, was man auf einer root-Platte nicht so gern
sehen möchte. Hier empfiehlt sich ggf. ein Virtuelles Dateisystem mit ein paar
GB einzurichten (`Building A Linux Filesystem From An Ordinary File`_) und es
dem Benutzer zuzuordnen, unter dem auch der Apache Prozess läuft, siehe
``APACHE_RUN_USER`` in der :ref:`xref_etc_apache2_envvars` Umgebung.

Weitere Einstellungen sind z.B. (vergleiche `ModSecurity Direktiven`_)::

    # FIXME: Im default sind hier Werte von 1.000 eingetragen, bei mir kam es
    # dann aber zu "Execution error - PCRE limits exceeded ". Ich hebe den Wert
    # mal auf 5000 an. Ich hab aber auch kein Gefühl wie hoch man das setzen
    # setzen sollte. Mein Eindruck ist auch, das die SecRules auf SQL-Injection
    # zu viel parsen (evtl. ist das aber für einen guten Schutz auch
    # erforderlich, ich kann es nicht beurteilen). Bei mir brechen die webDav
    # Anwendungen, die am PROPFIND einen XML Content anhängen.
    #
    SecPcreMatchLimit 5000
    SecPcreMatchLimitRecursion 5000
    ...
    # Use a single file for logging. This is much easier to look at, but
    # assumes that you will use the audit log only ocassionally.
    #
    SecAuditLogType Serial
    SecAuditLog /var/log/apache2/modsec_audit.log
    ...
    # Specify your Unicode Code Point.  This mapping is used by the
    # t:urlDecodeUni transformation function to properly map encoded data to
    # your language. Properly setting these directives helps to reduce false
    # positives and negatives.
    #
    SecUnicodeMapFile /etc/modsecurity/unicode.mapping 20127
    ...


Beispiele für Sicherheitsprofile
================================

Beispiele für Profile sind ``owap_crs_2.2.9_10_minimal.conf``,
``owap_crs_2.2.9_50_additional.conf`` oder
``owap_crs_2.2.9_90_SecRuleRemove.conf``. In der
``owap_crs_2.2.9_10_minimal.conf`` wird beispielsweise ein Profil definiert, das
sich aus den *base* und *optional* Rules zusammenstellt.

.. code-block:: apache

   Include /usr/share/owasp-modsecurity-crs/*.conf
   ...
   # base
   ...
   Include /usr/share/owasp-modsecurity-crs/base_rules/modsecurity_crs_20_protocol_violations.conf
   Include /usr/share/owasp-modsecurity-crs/base_rules/modsecurity_crs_21_protocol_anomalies.conf
   ...
   ## Die SecRules für SQL-injection liefern bei mir false-positiv auf alles was
   ## nicht *reines* HTTP und HTML ist.
   # Include /usr/share/owasp-modsecurity-crs/base_rules/modsecurity_crs_41_sql_injection_attacks.conf
   ...
   # optional
   Include /usr/share/owasp-modsecurity-crs/optional_rules/modsecurity_crs_10_ignore_static.conf
   Include /usr/share/owasp-modsecurity-crs/optional_rules/modsecurity_crs_11_avs_traffic.conf
   ...

In der ``owap_crs_2.2.9_90_SecRuleRemove.conf`` werden bekannte False Positiv
wieder aus den *SecRules* herausgenommen.

.. code-block:: apache

   # ID 960017: Host header is a numeric IP address. IPs are mostly used by IP
   # scanners, but they are also used in loopback device and in the leak of a DNS.
   #
   SecRuleRemoveById 960017

   # ID 960010: Request content type is not allowed by policy. Same false-positiv
   # as 960017 with webDav applications.
   #
   SecRuleRemoveById 960010

   # ID 960032: HTTP-Method is not allowed by policy. Limit the allowed methods to
   # GET HEAD POST OPTIONS. This will block webDAV-applications, which use PROPFIND
   # and much more.
   #
   SecRuleRemoveById 960032

   # ID 960015: Request Missing an Accept Header. Will break applications like
   # webDAV, which does not need a Accept-Header.
   #
   SecRuleRemoveById 960015

   # Disabling all RuleIDs which are *gone* in 3.0.0-rc1, they are listet in the
   # *paranoia* IDs:
   #
   #   https://www.owasp.org/index.php/OWASP_ModSec_CRS_Paranoia_Mode#Paranoia_Mode_Candidates
   #

   SecRuleRemoveById  \
       959070 \
       959071 \
       959072 \
       959073 \
       960024 \
       973300 \
       973332 \
       973333 \
       981172 \
       981173 \
       981231 \
       981260

Die oben vorgestellten Profile sind ein *guter Anfang* für eine WAF, der aber
nicht die eigenen Erfahrungen ersetzen kann. Weiterführende Artikel findet man
hier:

* https://www.netnea.com/cms/apache-tutorials/
* https://www.netnea.com/cms/category/security/
* `Apache Sicherheit (ubuntu)`_
* `awesome-security.web`_

