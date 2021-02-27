.. -*- coding: utf-8; mode: rst -*-

.. include:: ../citrix_refs.txt

.. _xref_citrix:

====================
Citrix Workspace App
====================

.. hint::

   **Update 3. Feb. 2020**: Der `Citrix Receiver (wiki)`_ -- aka. *ICA Client*
   -- heißt seit geraumer Zeit *Citrix Workspace App*.

.. _Virtual Desktop Infrastructure:
    https://de.wikipedia.org/wiki/Virtual_Desktop_Infrastructure

Die *Citrix Workspace App* gehört zur Gruppe der `Virtual Desktop
Infrastructure`_ Lösungen.  Die Idee ist es den Desktop eines Mitarbeiters
komplett zu virtualisieren und lokale als auch Remote-Komponenten auf dem
lokalen Desktop zu integrieren.  Der Mitarbeiter arbeitet auf seinem lokalem
Desktop und Apps, die nur Remote zur Verfügung stehen werden in seinen lokalen
Desktop integriert.  Die Idee ist an sich ganz gut und auch unter Schlagwörtern
wie Thin-Client bekannt, sie wirft aber auch neue Fragen auf, da Remote-Apps und
Local-Apps u.U. in unterschiedlichen Subnetzen laufen und der Remote-Host, je
nach Integrationstiefe einen *ändernden* Zugriff auf lokale Komponenten
benötigt, was u.U. ein erhebliches Sicherheitsrisiko (auch für den Client)
darstellen kann.


NEU: Citrix Workspace App
=========================

.. _Prerequisites to install Citrix Workspace app:
   https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/system-requirements.html

.. _Download Seite  Citrix Workspace app for Linux:
   https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html

.. _Citrix Workspace app:
   https://docs.citrix.com/en-us/citrix-workspace-app-for-linux

.. _Feature Matrix:
   https://www.citrix.com/content/dam/citrix/en_us/documents/data-sheet/citrix-workspace-app-feature-matrix.pdf

.. _Citrix Doc-Portal:
    https://docs.citrix.com/

.. sidebar:: Weiterführendes

   - `Citrix Workspace app`_
   - `Prerequisites to install Citrix Workspace app`_
   - `Download Seite Citrix Workspace app for Linux`_
   - `Feature Matrix`_
   - `Citrix Doc-Portal`_

Ein aktuelles Debian Paket kann auf der `Download Seite Citrix Workspace app for
Linux`_ heruntergeladen werden.  Auf das ``.deb`` Paket macht man einen
Doppelklick und installiert das Paket.  *Alter Wein in neuen Schläuchen:* Das
Debian Paket installiert die *Citrix Workspace App* in den Ordner
``/opt/Citrix/ICAClient/`` weshalb wir auf *technischer Ebene* weiterhin vom
*ICA Client* reden werden.

Wie gehabt, wird man auch bei dem neuen *ICA Client* ohne die Zertifikate aus
dem Firefox meist nur Fehlermeldungen bekommen, die darauf hinweisen, dass das
Zertifikat des remote Servers ungültig sei.  Die Lösung ist analog der
Beschreibung `ALT: Citrix Receiver`_, abgesehen von einer kleinen Feinheit: man
beachte das ``*`` im symbolischen Link unten (*Dank geht an Robert!*).

Die Zertifikate aus dem Mozilla werden verlinkt und anschließend in der **Citrix
Workspace App** (aka ``ICAClient``) registriert.::

     sudo -H ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/
     sudo -H /opt/Citrix/ICAClient/util/ctx_rehash

.. warning::

   Im Default ist die Clientlaufwerkzuordnung_ so eingestellt, dass der Remote
   Host die Dateien und Ordner auf dem lokalen PC ändern oder löschen kann
   (Konfiguration_).  Eine ideale Möglichkeit für Viren auch den lokalen PC zu
   infizieren!!!


Konfiguration
=============

.. _Clientlaufwerkzuordnung:
   https://getadmx.com/?Category=Citrix_Receiver&Policy=receiver.Policies.receiver::Policy_EnableDriveMapping&Language=de-de
.. _`Configure`:
   https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/configure-xenapp.html
.. _Server-client content redirection:
   https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/configure-xenapp.html#server-client-content-redirection

.. sidebar:: Weiterführendes

   - Configure_
   - Clientlaufwerkzuordnung_

Die *ICA Client* Konfiguration befindet sich unter Windows in der *Registry*,
auf den Linux PCs ist es etwas einfacher, dort findet man die Konfiguration in
der INI-Datei ``~/.ICAClient/wfclient.ini``.  Die Namen der Schalter sind aber
die gleichen, egal ob nun in der *Registry* oder in der INI-Datei.  Existiert
die Datei beim Anwender noch nicht wird sie aus der Vorlage::

  /opt/Citrix/ICAClient/config/wfclient.template

erzeugt.  Als Admin sollte man die Vorlage entsprechend anpassen.  Etwas
verwirrend ist, dass der Pfad nur ein Link ist, der in einen Ordner in
Abhängigkeit von der *Landessprache* verweist.  Die *Landessprache* wird bei der
Installation ermittelt und hängt von der Umgebungsvariablen ``LANG`` ab, die der
Admin bei der Installation hatte .. warum? .. das fragt man besser Citrix.  Wie
auch immer, es kann also mehrere Vorlagen geben, die man ggf. anpassen möchte::

  /opt/Citrix/ICAClient/nls/<lang>/wfclient.template

Hier ein Vorschlag wie man die Werte setzen sollte (Beschreibung der Optionen
siehe unten):

.. code:: ini

   [WFClient]
   ...
   CDMAllowed=Off
   ; CDMReadOnly=On
   CREnabled=False
   CientPrinterQueue=Off
   ClientManagement=Off
   ClientComm=Off

``CDMAllowed``
  Die Clientlaufwerkzuordnung_ erfolgt über die Einstellung ``CDMAllowed``, die
  **im Default auf** ``On``.  **Unbedingt abschalten**:  ``Off``

``CDMReadOnly``
  Dem Remote Host kann alternativ ein *read-only* Recht auf die lokalen Dateien
  gewährt werden.

``ClientManagement``
  Leider kann man bei Citrix oder sonst wo im Internet zu dem Schalter keine
  Beschreibung finden.  Ich hab ihn einfach auf ``Off`` gestellt und konnte bei
  meinen Anwendungen keine Einschränkungen feststellen.

``ClientComm``
  Auch hierzu konnte ich keine Referenz finden, aber wenn ich das recht sehe
  kann damit der Serielle Port an den Remote weitergeleitet werden.  Ich konnte
  keine Einschränkungen bei Abschaltung feststellen.

``CREnabled``
  Schaltet die `Server-client content redirection`_ ein resp. aus.  Damit werden
  dann URLs, die man in der Remote App öffnet lokal geöffnet.  Ob dieses Feature
  genutzt werden kann, legt der Remote-Server fest.  Die Idee dahinter ist es,
  den Content, der auch direkt vom Client im Internet erreicht werden kann auch
  direkt auf dem Client aufzurufen, anstatt alles erst über den Remote laufen zu
  lassen.  Die folgenden URLs (Protokolle) können umgeleitet werden:

  - HTTP (Hypertext Transfer Protocol)
  - HTTPS (Secure Hypertext Transfer Protocol)
  - RTSP (Real Player)
  - RTSPU (Real Player)
  - PNM (Older Real Players)

  Ob das Feature für den Anwender nützlich oder eher verwirrend ist hängt
  sicherlich vom Anwendungsfeld ab: Client und der Server stehen i.d.R. in zwei
  unterschiedlichen Subnetzen und es kann sein, dass bestimmte (WEB) Anwendungen
  dann gar nicht mehr funktionieren.


ALT: Citrix Receiver
====================

.. sidebar:: alt & neu

   Da die Probleme eigentlich die gleichen sind, hier noch der *historische*
   Text dazu.

`Citrix Receiver (wiki)`_ -- aka. ICA Client -- ist der Client zu XenDesktop und
XenApp. Der Client wird für diverse Plattformen bereit gestellt, unter anderem
Windows, Linux und Android.

- Download siehe `Citrix Receiver`_

Der Windows Installer scheint soweit OK, bei Linux gibt es seit gefühlten 100
Jahren immer wieder irgendwelche Probleme, siehe auch `Citrix Receiver
(ubuntu)`_.  Grundsätzlich kann man den Client aber auch unter Linux
installieren und nutzen.  In alten Versionen musste man noch mit den i386 und
amd64 Bibliotheken jonglieren (`Citrix ICA Client HowTo`_), das ist heute nicht
mehr erforderlich.  Inzwischen -- aktuell Ubuntu-18.04 und Citrix-Receiver 13.10
-- scheinen nur ein paar Zertifikate zu fehlen um eine Verbindung aufzubauen.

Ich nutze/installiere lediglich das *Web Receiver only* deb-Paket, aktuell z.B.:

- `icaclientWeb_13.10.0.20_amd64.deb
  <https://www.citrix.com/downloads/citrix-receiver/linux/receiver-for-linux-latest.html>`__

Das Paket kann man via Doppelklick oder eben auch via Kommandozeile
installieren::

  $ sudo -H dpkg -i icaclientWeb_13.10.0.20_amd64.deb

Im Web-Browser baut man dann initial die Verbindung auf und meldet sich an der
XenDesktop Infrastruktur an.  Nach der Anmeldung kann man dann die zur Verfügung
stehenden Apps und Desktops im WEB-Browser anklicken.  Dabei wird eine ``.ica``
Datei runter geladen und im Citrix Receiver geöffnet.  Bei der Installation
wurde der Mime-Type registriert::

 $ xdg-mime query filetype UkFHLlhlbkRlc2t0b3AgSVQtRGV2ZWxvcGVyICRQNDM5.ica
 application/x-ica
 $ xdg-mime query default application/x-ica
 wfica.desktop

Öffnet man eine solche ``.ica`` Datei, dann bekommt man (linux) eine ziemlich
irreführende Fehlermeldung:

.. figure:: citrix-receiver-error-dialog.png

   Irreführende Fehlermeldung bei fehlenden Zertifikaten

Das eigentliche Problem ist aber, dass dem Citrix-Client die gängigen
Zertifikate fehlen.  Diese kann man mit folgenden Zeilen einfach aus der FFox
Installation verlinken.::

  sudo -H ln -s /usr/share/ca-certificates/mozilla/ /opt/Citrix/ICAClient/keystore/cacerts/
  sudo -H c_rehash /opt/Citrix/ICAClient/keystore/cacerts/

Es gibt dazu auch einen Thread im `ubuntu-users
<https://forum.ubuntuusers.de/topic/citrix-receiver-2>`__ Forum.

.. warning::

   Es kann im ungünstigen Fall sein, dass man obigen Schritt wiederholen muss,
   wenn der FFox aktualisiert wird.
