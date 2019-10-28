.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt
.. include:: ../android_refs.txt

.. _xref_ssl_ca_remarks:

================================================================================
                     Anmerkungen zu SSL und Zertifikaten
================================================================================

.. sidebar:: https://badssl.com/

  Eine WEB-Seite, auf der man das Verhalten seines WEB-Browsers auf *schlechte*
  SSL Verbindungen testen kann

Die hier vorgestellten Setups benutzen als Transportschicht SSL. Mit SSL wird
dann meist auch ein Zertifikat erforderlich. Meiner Ansicht nach sind
*selbstsignierte* Zertifikate, wie sie die Debian/Ubuntu Distribution (snakeoil)
mit dem Paket :deb:`ssl-cert` einrichten, an sich vollkommend ausreichend.::

   /etc/ssl/certs/ssl-cert-snakeoil.pem

Will man sich sein (snakeoil) Zertifikat mal genauer anschauen, dann kann man
das z.B. mit dem folgenden Kommando.

.. code-block:: bash

   openssl x509 -text -in /etc/ssl/certs/ssl-cert-snakeoil.pem

Im WEB-Browser führen diese selbstsignierten Zertifakte zu einer Warnmeldung
weil sie über keine (der im WEB-Browser vorinstallierten) Zertifizierungstellen
signiert wurden. Im WEB-Browser muss/kann man auf diese Warnung hin das
Zertifakt aktzeptieren, was im Allgemeinen kein Problem darstellen sollte.

.. sidebar:: FFox UPDATE

   Inzwischen ist es im default nicht mehr möglich Ausnahmen zu akzeptieren.  Um
   Ausnahmen weiterhin akzeptieren zu können, muss unter ``crome:config`` (URL)
   folgende Einstellung vorgenommen werden::

     browser.xul.error_pages.expert_bad_cert = false

Betreibt man die WEB-Seite im Internet, dann verunsichern die *Terrorpanik -
Warndialoge* aus dem WEB-Broswer den unbedarften Besucher jedoch schnell. FFox
und andere WEB-Browser haben im *Default* bereits eine Liste von
Zertifizierungsstellen (`CA (wiki)`_) eingebaut (die `Mozilla Included CA
Certificate List`_). Jeder der im Internet eine Seite mit einem *CA
zertifizierten* Zertifikat besucht vertraut darauf, dass die CAs, welche die
*Echtheit* dieser Seite bestätigen auch vertraunswürdig sind.

Sichere Kommunikation basiert also immer auf einem Vertrauen. In dem Fall auf
dem Vertrauen in eine Reihe von CA's, die eine Gruppe (rund um z.B. Mozilla) als
"vertrauenswürdig" eingestuft hat. Es stellt sich die Frage; wem kann man (mehr)
vertrauen? Den zum Teil intransparenten CAs oder kann man gleich dem
selbstsignierten Zertifikat trauen?  Fefe beschreibt das Dilema von Vertrauen
recht gut in seinem Blog `Fefe's Blog / Sun Oct 3 2010`_.

.. note::

   Um es kurz zu machen, Sicherheit ist eine Frage von Vertrauen. Ob man allen
   CAs in den Browsern vertrauen kann ist zumindest hinterfragbar solange die
   Prozesse eines CAs und seine Motivation nicht transparent sind. Die
   `letsencrypt.org`_ mag auch umstritten sein, sie ist aber zumindest
   transparent und wird offen im Netzt diskutiert.  Wer einen (kleinen)
   WEB-Server im Netz betreibt und gerne zertiffiziert werden möchte, der möge
   sich mit der `letsencrypt.org`_ Campange auseinander setzen.

.. _install_certs:

Hinzufügen des Zertifikats eines Remote-Host
=============================================

Es empfiehlt sich die selbst-signierten Zertifikate der Server im **Intranet**
auch auf den Client-Hosts zu registrieren.  Hierzu kann das beiliegende Script
verwendet werden:

.. code-block:: bash

  $ ./scripts/certs install

Im allgemeinen akzeptieren die Programme auf dem Client die so installierten
Zertifikate, aber wie immer gibt es auch hierbei Ausnahmen.

.. note::

   Webbrowser wie Firefox, Chrome etc., als auch der Mailclient Mozilla
   Thunderbird haben ihre eigenen Trust-Center.

Bei solchen Anwendungen liegt die CA Datenbank i.d.R. irgendwo im HOME-Ordner
des Anwenders, meist beim Profil der jeweiligen Anwendung. Das kann seitens der
Administration nicht sinnvoll gehandhabt werden und so muss jeder Benutzer das
Zertifikat des WEB-/Mail- Servers manuell akzeptieren. Leider sind dazu meist
einige zusätzliche Maus-Klicks erforderlich, sobald man den Mail-Account
einrichtet oder die Seite im Intranet aufruft.

Andere Programme die den SSL Stack des Systems benutzen (ssh, git ...) nutzen
die systemweiten CA's und arbeiten auch mit den selbst-signierten problemlos.

Windows
-------

Auf Windows empfehle ich git zu installieren, dann hat man auch gleichzeitig ein
openssl Client. Dazu die Git-Bash öffnen und folgendes eingeben. Dabei die
beiden ``<hostname>`` durch den Namen des Remote-Host ersetzen::

  cd Downloads
  openssl s_client -showcerts -connect <hostname>:443 </dev/null 2>/dev/null | openssl x509 -outform PEM > <hostname>.crt

Sollte sich das Programm nicht benden (bei Win stimmt was mit den PIPEs nicht)
CTRL-C drücken und nachschauen ob es (trotzdem) geklappt hat::

  cat <hostname>.crt

Das ``cat`` sollte das Zertifikat anzeigen. Wenn nicht, muss man sich das
irgendwie anders holen. Danach den Anweisungen unter dem *Link* folgen und dabei
das Zertifikat ``<hostname>.crt`` einspielen.

  * https://technet.microsoft.com/de-de/library/cc754841(v=ws.11).aspx#BKMK_addlocal

.. _android_snakeoil:

Android
-------

Die Installation eines selbst signierten Zertifikats (wie
z.B. ``ssl-cert-snakeoil.pem``) auf einem Android Device wollte mir über das
Benutzerinterface nicht gelingen, am Ende musste zur *Holzhammer* Methode
greifen, die hier kurz beschrieben werden soll.

Für die *Holzhammer* Methode benötigt man die `Android Debug Bridge (adb)`_. Auf
Debian/Ubuntu kann man diese mit dem apt Paketmanager installieren:

.. code-block:: sh

   $ sudo apt-get install android-tools-adb android-tools-fastboot

.. Das fastboot ist nicht unbedingt notwendig, wer aber ein *recovery* Image auf
.. seinem Smartphone installieren will wird es früher oder später auch benötigen
.. (siehe z.B. `All About Recovery Images`_).

Als nächstes muss man das *versteckte* "Entwickler Menü" aktivieren
(:ref:`android_dev_options`).

Wenn man jetzt wieder auf "Einstellungen" wechselt, sieht man in dem Menu ganz
unten als vorletzten Eintrag die "Entwickleroptionen", dort drauf klicken und
in dem folgenden Menü folgendes aktivieren.

* Root-Zugriff: ADB
* Android-Debugging: *ON*

Spätestens jetzt sollte man das Android via USB Kabel an den PC verbinden.
Abhängig vom Desktop System des PC sollte sich dabei ein Dateibrowser öffnen und
man kann sich dort zu einem Ordner Namens ``Download`` durchangeln. In diesen
Ordner werden wir später das Zertifikat auf das Android kopieren. Zuvor müssen
wir jedoch das selbst signierte Zertifikat des Servers aufbereiten (siehe auch
`CAcert: Android Phones & Tablets`_).

Im folgenden gehe ich auf den Linux-Server und bereite das Zertifikat auf:

.. code-block:: sh

   myPC $ ssh myusername@myserver
   myserver $ cp /etc/ssl/certs/ssl-cert-snakeoil.pem /tmp/myserver_cert.pem
   myserver $ cd /tmp
   myserver $ openssl x509 -inform PEM -subject_hash_old -in  | head -1
   myserver $ openssl x509 -inform PEM -subject_hash_old -in myserver_cert.pem | head -1
   c091000a

Der Wert ``c091000a`` ist ein Hash-Wert des Zertifikates, der bei jedem
Zertifikat anders aussehen wird. Wir verwenden diesen Wert als Dateinamen, indem
wir am Ende noch ein ``.0`` dran hängen. Hier im Beispiel also ``c091000a.0``
mit dem eigeneen Zertifikat also analog ``{hash-value}.0``.

.. code-block:: sh

   $ cat myserver_cert.pem > c091000a.0
   $ openssl x509 -inform PEM -text -in myserver_cert.pem -out /dev/null >> c091000a.0

Nun liegt das aufbereitete Zertifikat auf dem Server unter
``/tmp/{hash-value}.0``.  Von dort muss man es nun in den Download Ordner des
Androids kopieren. Also z.B. erst mal auf den PC kopieren und von dort dann auf
das -- via USB -- angeschlossene Android kopieren. Da hier bei mir alles Linux
ist mache ich das indem ich das Zertifikat erst mal in den HOME Ordner auf dem
PC kopiere und dann mit ``adb`` auf das Android kopiere.

.. code-block:: sh

   myPC $ scp myusername@myserver:/tmp/{hash-value}.0 $HOME

Nachdem man das Zertifikat auf dem PC hat kann man es auch mit dem Datei
Explorer in den Download Ordner des Android kopieren (s.o.). Ich mach das mal
mit der adb, weil sich das einfacher aufschreiben lässt.

.. code-block:: sh

  myPC $ adb push $HOME/c091000a.0 /sdcard/Downloads
  66 KB/s (3721 bytes in 0.054s)

Nachdem man das Zertifikat nun endlich auf dem Android hat, muss man es noch
installieren. Dazu macht man mit dem adb auf dem Android eine shell auf und
wechselt in den root user (su), denn nur der hat die erforderlichen Rechte
(deswegen wurde oben auch "Root-Zugriff: ADB" eingestellt).

.. code-block:: sh

  myPC $ adb shell
  shell@maguro:/ $ su
  root@maguro:/ # su

Die System Zertifikate liegen im ``/system`` Ordner, dieser ist allerdings
read-only gemountet. Um auch darin schreiben zu können wird der Ordner nochmal
mit read/write gemountet. Danach kann dann das Zertifikat in den ``cacerts/``
Ordner kopiert werden und es werden noch die Dateirechte so eingestellt, dass
*jeder* die Datei lesen kann.

.. code-block:: sh

  root@maguro:/ # mount -o remount,rw /system/
  root@maguro:/ # cp /sdcard/Download/c091000a.0  /system/etc/security/cacerts/
  root@maguro:/ # chmod 644 /system/etc/security/cacerts/c091000a.0

Nun muss das Android einmal neu gebootet werden, dazu ganz ausschalten oder
``su`` verlassen und ``reboot`` aufrufen.

.. code-block:: sh

  root@maguro:/ # exit
  shell@maguro:/ $ reboot

Nach dem Reboot findet man das selbst signiertes Zertifikat unter "Einstellungen
> Sicherheit > Vertrauenswürdige Anmeldedaten" im Reiter "System" wieder. Der
Name des Zertifikats trägt dabei i.d.R. den Namen des Host, für das man es
erstellt hat.  Alle Android Apps, welche den SSL (Java) Stack des Androids
benutzen sollten nun ohne Probleme verschlüsselt mit dem selbst signierten
Server kommunizieren können (bei mir war das z.B. Firefox-Sync eines Android
FFox).
