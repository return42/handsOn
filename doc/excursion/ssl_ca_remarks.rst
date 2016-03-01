.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_ssl_ca_remarks:

================================================================================
                     Anmerkungen zu SSL und Zertifikaten
================================================================================

Die hier vorgestellten Setups benutzen als Transportschicht SSL. Mit SSL wird
dann meist auch ein Zertifikat erforderlich. Meiner Ansicht nach sind
*selbstsignierte* Zertifikate, wie sie die Debian/Ubuntu Distribution (snakeoil)
mit dem Paket :deb:`ssl-cert` einrichten, an sich vollkommend ausreichend.

   * /etc/ssl/certs/ssl-cert-snakeoil.pem

Will man sich sein (snakeoil) Zertifikat mal genauer anschauen, dann kann man
das z.B. mit dem folgenden Kommando.

.. code-block:: bash

   openssl x509 -text -in /etc/ssl/certs/ssl-cert-snakeoil.pem

Im WEB-Browser führen diese selbstsignierten Zertifakte zu einer Warnmeldung
weil sie über keine (der im WEB-Browser vorinstallierten) Zertifizierungstellen
signiert wurden. Im WEB-Browser muss/kann man auf diese Warnung hin das
Zertifakt aktzeptieren, was im Allgemeinen kein Problem darstellen sollte.

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

Um es kurz zu machen, Sicherheit ist eine Frage von Vertrauen. Ob man allen CAs
in den Browsern vertrauen kann ist zumindest hinterfragbar solange die Prozesse
eines CAs und seine Motivation nicht transparent sind. Die `letsencrypt.org`_
mag auch umstritten sein, sie ist aber zumindest transparent und wird offen im
Netzt diskutiert.  Wer einen (kleinen) WEB-Server im Netz betreibt und gerne
zertiffiziert werden möchte, der möge sich mit der `letsencrypt.org`_ Campange
auseinander setzen.
