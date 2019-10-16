.. -*- coding: utf-8; mode: rst -*-

.. include:: ../citrix_refs.txt

.. _xref_citrix:

===============
Citrix-Receiver
===============

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

  $ sudo dpkg -i icaclientWeb_13.10.0.20_amd64.deb

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

  sudo ln -s /usr/share/ca-certificates/mozilla/ /opt/Citrix/ICAClient/keystore/cacerts/
  sudo c_rehash /opt/Citrix/ICAClient/keystore/cacerts/

Es gibt dazu auch einen Thread im `ubuntu-users
<https://forum.ubuntuusers.de/topic/citrix-receiver-2>`__ Forum.

.. warning::

   Es kann im ungünstigen Fall sein, dass man obigen Schritt wiederholen muss,
   wenn der FFox aktualisiert wird.
