.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_excursion_IPv4_6:

================================================================================
                     Exkursion: Netzmaske / IPv4 und IPv6
================================================================================

Im IPv4 und IPv6 Adressraum wird im Grunde nur zw. zwei Netzen unterschieden,
dem globalen und dem lokalem Netz. Das gloabale Netz (auch als **global scope**
bezeichnet) ist das *Internet*, das von einem `ISP (wiki)`_ administriert und
geroutet wird. Das lokale Netz (auch als **link-local** Netz bezeichnet) ist das
Netz, das vom *eigenem Netz-Admin* administriert und geroutet wird. Im
einfachsten Fall ist der *eigene Netz-Admin* die Plaste-Box, die an dem
DSL-Anschluss an der Wand hängt.

Will man nun den Zugriff auf eine Web-Site des Apache
(:ref:`xref-allow-directive`) oder das Routing in einem Netzwerk konfigurieren,
so nimmt man eine `Netzmaske (wiki)`_ zur Hand um Teilbereiche des Netzes in
eine *Klammer* zu fassen, anderen Falls müsste man jede IP-Adresse des Netzes
einzeln betrachten. Eine Klammerung in Teilbereiche setzt voraus, dass die
Adressen in einem Netz in irgendeiner Form strukturiert sind. Die gröbste
Strukturierung ist die Unterscheidung des *global scope* zum *link-lokal* Netz.
Das ist im IPv6 so, wie es schon im IPv4 war, nur mit dem Unterschied, dass IPv6
differenziertere Unterscheidungen zulässt, über einen größeren Adressraum
verfügt und besondere Features hat, die es im IPv4 nicht gibt.

.. _xref_excursion_IPv4_Mask:

IPv4 Netze und Masken
=====================

Die *link-lokal* Adressen sind nicht irgendwelche zufällig gewählten Adressen,
hierfür verwendt man dafür vorgesehene *Nummernbereiche*.  Im IPv4 werden
`private Adressbereiche (wiki)`_ in der `RFC 1918: IPv4 Private Address Space`_
definiert, hier ein Auszug:

* IPv4 *privates* Class-A Subnetz: ``10.0.0.0/8`` (``255.0.0.0``)
* IPv4 *privates* Class-B Subnetz: ``192.168.0.0/16`` (``255.255.0.0``)
* IPv4 *privates* Class-C Subnetz: ``192.168.0.0/24`` (``255.255.255.0``)
* IPv4 localhost:                  ``127.0.0.0/8`` (``255.0.0.0``)

Klassisch wird eine Netzwerkmaske mit ihren dezimalen Werten notiert,
z.B. ``255.255.255.0``. Die Notation der Netzmaske mit Kürzeln wie ``/8``,
``/16`` oder ``24`` erweist sich aber als praktischer, sie stammt aus dem
`CIDR`_. Eine Netzmaske identifiziert das IP-*Präfix* (also den Adressbereich)
eines *Netzes*. In der `Netzmaske (wiki)`_ ``127.0.0.0/8`` aus dem obigen
Beispiel ist ``127.`` der Adressbereich des `localhost (wiki)`_.

Die Netzmaske ``192.168.0.0/16`` entspricht dem historischen *private Class-B
Netz* des IPv4, das aus max. 256 privaten (*Class-C*) Netzen mit jeweils 256
Adressen bestehen kann (total 65536 Adressen).  Die Netzmaske in den einzelnen
*Class-C* Netzen wäre ``/24`` und reicht von ``192.168.0.0/24`` bis
``192.168.255.0/24``. Ein solches *Class-B* Netz würde für Unternehmen mittlerer
Größe mit nicht mehr als ca. 65.000 Devices noch passen. Es mag sich auch noch
für den Verbund (z.B. via VPN) von weniger als 256 kleinen Büros mit nicht mehr
als 253 Devices *in dem größten der kleinen Büros* eignen. Für größere
Unternehmen mit mehreren Standorten müsste man schon ein *Class-A* Verbund
wählen in dem (bis zu 256) *Class-B* Netze (mit je max. 65.000 Devices)
angeordnet sein könnten / siehe hierzu :ref:`xref_excursion_NAT`.

Die IP-Adresse des Hosts und die Netzmaske des Subnetz in dem er sich befindet
kann mit dem Kommando :man:`ifconfig` ermittelt werden:

.. code-block:: bash

   eth0      Link encap:Ethernet  HWaddr bc:5f:f4:ea:0e:7e
             inet addr:192.168.1.124  Bcast:192.168.1.255  Mask:255.255.255.0
             inet6 addr: fd00::be5f:f4ff:feea:e7e/64 Scope:Global
             inet6 addr: fd00::6d38:6276:ea39:39de/64 Scope:Global
             inet6 addr: fe80::be5f:f4ff:feea:e7e/64 Scope:Link
             UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
   ~~~~
   lo        Link encap:Local Loopback
             inet addr:127.0.0.1  Mask:255.0.0.0
             inet6 addr: ::1/128 Scope:Host
             UP LOOPBACK RUNNING  MTU:65536  Metric:1

Das *Loppback-Device* wird mit ``lo`` bezeichnet, die IPv4 Adresse ist
``127.0.0.1`` und die Netzmaske ist ``255.0.0.0``, was ``127.0.0.0/8``
entspricht.

Mit ``eth0`` wird die *erste* Ethernet-Netzwerkarte gekennzeichnet (*Ethernet
Divice 0* mit `Mac Adresse (wiki)`_ ``bc:5f:f4:ea:0e:7e``) und der *erste* WLAN Adaper
trägt die Bezeichnung ``wlan0`` (oben nicht zu sehen).

Die IPv4 Adresse des ``eth0`` ist ``192.168.1.124`` die Netzmaske ist mit
``255.255.255.0`` angegeben, was ``192.168.1.0/24`` entspricht. Der Host steht
also in einem (kleinen) Subnetz in dem max. 256 IPs zur Verfügung stehen
(0-255). In dem Bereich sind jedoch folgende Nummern schon reserviert:

* Die ``.0`` ist immer die *Subnetzadresse*
* Die ``.255`` ist immer die `Broadcast (wiki)`_ Adresse.
* Auf der Adresse ``.1`` ist meist der Router / das Gateway zu finden mit dem
  dieses Subnetz an ein *höheres* Netz gebunden ist (bei der Plaste-Box zu Hause
  ist das schon das Internet).

In dem historischen IPv4 *Class-C* (Subnetz) wird man *real* also nicht mehr als
253 *Devices* vorfinden resp. unterbringen können.

.. _xref_excursion_IPv6_Mask:

IPv6 Netze und Masken
=====================

Im IPv4 werden die Adressbereiche in der RFC-1918 definiert, im IPv6 gibt es
dafür die `RFC 4291: IPv6 Addressing Architecture`_. Für die *unicast
link-local* Adressen im IPv6 sind folgende Adressbereiche vorgesehen:

* IPv6 localhost:                  ``::1/128``
* IPv6 Link-Lokal Netz:            ``fe80::/10``
* IPv6 Unique-Local Subnetz:       ``fd00::/8``

Bezüglich dem Aufbau einer IPv6-Adresse sei kurz aus einem Artikel des
heise-Verlags zitiert -- `Reservierte und spezielle Adressbereiche im
Internet-Protokoll Version 6 (heise Verlag)`_::

    Die gesamte Adresse umfasst 128 Bit.  Die ersten 64 sind für den
    Subnetz-Präfix reserviert, die verbleibenden 64 Bit bezeichnen den Host.

    Die vollständige Adresse schreibt man hexadezimal und unterteilt die
    Zahlenfolge mit Doppelpunkten in Blöcke je 16 Bit.

    Innerhalb von IPv6-Adressen lässt sich eine Folge von Nullen kürzen und
    durch zwei Doppelpunkte ersetzen. Die Adresse

    * 2001:0DB8:0000:0001:0000:0000:0010:01FF verkürzt sich damit zu
    * 2001:0DB8:0000:0001::0010:01FF.

    Führende Nullen in den 16-Bit-Blöcken können ersatzlos wegfallen, sodass die
    oben genannte Adresse auf

    * 2001:DB8:0:1::10:1FF schrumpft.
    ~~~


Loopback Adresse ``::1``
------------------------

Die Loopback Adresse im IPv6 ist die ``0:0:0:0:0:0:0:1:`` oder etwas kürzer
notiert ``::1`` (siehe `RFC 4291: The Loopback Addresses`_). Anders als im IPv4
ist im IPv6 für das loopback-Device keine ganzes Class-A Netzwerk reserviert
(``127.0.0.8/8``) sondern nur diese *eine* Adresse (``::1/128``).

Apache: Die ``::1`` in einer Apache- :ref:`xref-allow-directive` wie ``Allow from ::1``
ist also das IPv6 Pendant zu der IPv4 *Allow localhost* Direktive ``Allow
127.0.0.0/8``.


Link Local Adressen ``fe80::/10``
----------------------------------

Anders als im IPv4 üblich, vergibt im IPv6 nicht mehr der Router (der `DHCP
(wiki)`_ - Server) die IP-Adresse an die Hosts. Im IPv6 gibt es die `IPv6
Autokonfiguration (wiki)`_, die auch als **Stateless Address Autoconfiguration
(SLAAC)** bezeichnet wird. Das Verfahren der SLAAC wird in `RFC 4862: IPv6
SLAAC`_ definiert.

Mit der SLAAC generieren sich die Hosts eine *link-local* Adresse -- die im
Range ``fe80::/10`` liegen muss -- selber.

  Die `Link Local Adressen (wiki)`_ werden von dem `ISP (wiki)`_ nicht geroutet,
  **sie sind im Internet nicht verfügbar** (daher auch der Namensbestandteil
  *Local*).

Am Beispiel einer Apache Konfiguration: Die ``fe80::/10`` in einer Apache-
:ref:`xref-allow-directive` wie ``Allow from fe80::/10`` ist in etwa das IPv6
Pendant zu einer *private Class-C* Direktive wie ``Allow from 192.168.0.0/24``.

Der Aufbau der `RFC 4291: Link-Local IPv6 Unicast Addresses`_::

   | 10 bits  |         54 bits         |          64 bits           |
   +----------+-------------------------+----------------------------+
   |1111111010|           0             |       interface ID         |
   +----------+-------------------------+----------------------------+

.. _xref_IPv6_unique_local:

Unique Local ``fc00::/7`` faktisch ``fd00::/8``
-----------------------------------------------

Im IPv4 konnte man *Class-C* Netze ``192.168.1.0/24`` zu einem *Class-D* Verbund
``192.168.1.0/16`` maskieren (vergleiche :ref:`xref_excursion_IPv4_Mask`). Das
geht mit den *link-local* Adressen nicht, den jedes Subnetz steht für sich und
trägt den selben Präfix ``fe80::/10``.  Das Pendant zu den privaten
Adressbereichen des IPv4 sind im IPv6 die Adressbereiche des `Unique Local
Unicast (wiki)`_.

  Eine Unique-Local Adresse -- kurz **ULA** -- wird von den ISPs nicht geroutet,
  **sie ist im Internet nicht verfügbar** (daher auch der Namensbestandteil
  *Local*).

Für ULA steht der Adressbereich ``fc00::/7`` zur Verfügung wovon die Null im
achten Bit (*von links gezählt*) jedoch reserviert ist, siehe Format der ULA:
`RFC 4193: Local IPv6 Unicast Addresses`_::


      | 7 bits |1|  40 bits   |  16 bits  |          64 bits           |
      +--------+-+------------+-----------+----------------------------+
      | Prefix |L| Global-ID  | Subnet-ID |        Interface-ID        |

      Prefix            FC00::/7 prefix to identify Local IPv6 unicast
                        addresses.

      L                 Set to 1 if the prefix is locally assigned.
                        Set to 0 may be defined in the future.

Faktisch ist das Präfix einer lokalen (*selbstvergebenen*) ULA also immer
``fd00::/8``.

.. hint::

   Die *Denke* im IPv6 ist anders als im IPv4. Man wird IPv6 nur schwer
   verstehen, wenn man sich nicht kurz mit dem Prinzip der `IPv6
   Autokonfiguration (wiki)`_ -- auch *Stateless Address Autoconfiguration*
   (`RFC 4862: IPv6 SLAAC`_) genannt -- vertraut macht.

Prefix Delegation
-----------------

Die *Stateless Address Autoconfiguration* (SLAAC) hat den Vorteil, daß man keine
IP-Adressen mehr konfigurieren muss und mit der Link-Lokal Adresse die bis zum
nächsten Router reicht hat man auch immer das Subnetz maskiert (``fe80::/10``).

Aber man kann diese Subnetze noch nicht als Verbund maskieren. An dieser Stelle
soll nun die *Unique Local* ``fd00::/8`` helfen. Dies ist aber nicht mehr nur
mit SLAAC alleine möglich. Um einen Verbund zu bilden, müssen Präfixe für das
*Unique Lokal Subnetz* vergeben werden, wofür es -- wie schon im IPv4 -- eine
Instanz geben muss. Die Vergabe der Präfixe kann man entweder manuell durch
Vergabe eines festen Präfix auf allen Hosts erreichen oder besser, man hat einen
Router mit einem DHCPv6 Server und Hosts, die `DHCPv6 prefix delegation`_
unterstützen. Bei dem Verfahren vergibt der Router (DHCP-Server) das Präfix mit
den 40Bit für die Global-ID und den 16-Bit für die Subnet-ID (vergleiche
Schaubild :ref:`xref_IPv6_unique_local`).  Z.B.::

  ULA des Routers --> 2001::c225:6ff:fea2:c35c/64 Subnetz
  Präfix --> 2001::c225:6ff/64

Source Address Selection
------------------------

Im IPv6 hat ein Netz-Device wie das ``eth0`` im obigen Beispiel immer mehrere
IP-Adressen. Es gibt immer mindestens eine im *Local-Scope* und eine im
*Global-Scope*. Wenn nun ein IP-Paket über das Device versendet wird, muss eine
Enstcheidung getroffen werden, welche dieser Adressen als *Absender* verwendet
wird. Die Entscheidungsfindung wird als *Source Address Selection* bezeichnet.
Das Verfahren wird in `RFC 3484: Source Address Selection`_ beschrieben, oder
etwas abgekürzt formuliert: der Algorythmus versucht zu ermitteln, was zur
IP-Zieladresse am besten passt. Wenn die Zieladresse ein *Name* und keine
IP-Adresse ist, dann wird die zum Namen gehörende IP-Zieladresse vom DNS
vorgegeben.

Privacy Extensions für SLAAC im IPv6 Global-Scope
-------------------------------------------------

Die `IPv6 Autokonfiguration (wiki)`_ erzeugt eine IPv6-Adresse auf Basis der
MAC-Adresse des Devices. Man kann das auch schon fast mit *bloßem Auge
sehen*. Hier ein kleines Beispiel.::

    $ ifconfig
    eth0      Link encap:Ethernet  Hardware Adresse 00:0c:29:3f:de:f9
              ...
              inet6-Adresse: 2a02:8109:183f:b2cc:20c:29ff:fe3f:def9/64 Scope:Global

In der obigen :man:`ifconfig` Ausgabe ist zu sehen, dass der ``eth0`` eine 64
Bit Maske auf dem *Scope:Global* hat::

    inet6-Adresse: 2a02:8109:183f:b2cc:20c:29ff:fe3f:def9/64 Scope:Global

Schreibt man das mal anders auf, dann sieht man, was für den Interface
Identifier übrig bleibt::

     2a02:8109:183f:b2cc  :  020c:29ff:fe3f:0def9   /64
               ----+----     ---------+---------
                   |                  +--> Interface Identifier
                   +--> 2a02:8109:183f:b2cc::/62 ist das IPv6 Präfix des Routers

Betrachtet man nur den Interface-Identifier und die MAC-Adresse::

       MAC:  00:0c:29:3f:de:f9          --->         000c:293f:def9
       auseinander ziehen:                    000c:29__ : __3f:def9
       was drauf addieren:                  +      00ff : fe00:0000
       Das 7. Bit invertieren:              +  2
                                             ----------------------
                                              020c:29ff : fe3f:def9

Es gibt dafür auch IP-Rechner, mit denen man so was leicht ausrechnen kann (z.B
`MAC address to IPv6 link-local address online converter`_).

Der **Interface-Identifier** in der Global-Scope Adresse ist beim SLAAC also
immer konstant der gleiche (eine Kollision der MAC Adresse im Subnetz ist sehr
unwahrscheinlich und hätte dann auch andere Problem zur Folge).

Mit diesem **Interface-Identifier** und dem IPv6 Präfix des ISP, wird nun jedes
Device durchs Internet geroutet. Anders als beim IPv4, bei dem es noch NAT gab
wird hier im IPv6 keine manipulation an der Absender Adresse vorgenommen. Der
IPv6 Router reicht das Datenpaket mit der IPv6-Absenderadresse 1:1 durch. Auch
wenn der IPv6 Präfix des ISP evtl. alle 24h Stunden wechselt, kann die Hardware
von der die IP Pakete kommen recht gut identifiziert werden.

.. hint::

   Nachdem die MAC Adresse in der IPv6 Adresse abgebildet ist, lässt sie sich
   auch zurückrechnen. Mittels der `OUI Herstellerkennungen (wiki)`_ und
   ggf. noch weiterer Erfahrungswerte in der Vergabe von Nummernbereichen an
   bestimmte Device-Typen, lässt sich die Hardware:

   * immer eindeutig identifizieren und
   * vom Typ her zumindest grob zuordnen.

Da es sich hierbei immer um eine Identifikation auf der IP-Ebene handelt, ist
sie immer möglich. Unabhängig davon, ob verschlüsselte oder unverschlüsselte
Datenpakete ausgetauscht werden. Diese Art der Identifikation ist beim IPv4 mit
NAT nicht möglich, da ist der Blick ins Subnetz (zumindets auf IP Ebene)
verschleiert.

.. hint::

  Die Identifizierung von Nutzern ist auf IP Ebene nur indirekt möglich und
  weniger intressant. Die Nutzer können einfacher an ihrem Verhalten auf der
  Anwendungsebene identifiziert werden.

  Intressanter sind evtl. die *Dinger* aus dem *Internet der Dinge*
  (schrecklicher Begriff). Die über Steuerungen oder Produktionslagen in immer
  mehr Haushalte und Unternehmen Einzug halten.

Diese *Dinge* holen sich nicht selten Inforamtionen wie z.B. die aktuelle
Uhrzeit von einem Uhren-Server aus dem Internet. Wie gesprächig sie darüber
hinaus sind ist immer schwer einzuschätzen und ist wohl nur in den wenigsten
technischen Angaben einer Steuerung zu finden.

Kommunizieren diese *Dinge* mit dem Internet (z.B. Uhr synchronisieren) und
machen sie das mit IPv6 und einer SLAAC-IP, dann hat man vermutlich schon nach
einem Tag ein recht vollständiges Bild von dem was hinter dem Router an Hardware
steht. Einzelne Steuerungen lassen sich ggf. schon Identifizieren, damit ist
dann auch die Liste der bekannten Schwachstellen zu der Hardware/Software
bekannt (z.B. ein exploit in dem Admin Interface eines Devices).

Um dem zu entgehen kann man -- zumindest bei den meisten Betreibsystemen -- die
`IPv6 Privacy Extensions (heise)`_ einschalten. Für die *Dinger* des *Internets
der Dinge* wird man vermutlich weniger Möglichkeiten haben, die MAC Adresse zu
verschleiern (am besten die *Dinger* können erst gar kein IPv6).
