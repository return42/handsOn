.. -*- coding: utf-8; mode: rst -*-

.. include:: ../apache_setup_refs.txt

.. _xref_excursion_NAT:

================================================================================
                                Exkursion: NAT
================================================================================

Die Aufteilung in die starren -- als *Class-A/B/C* bezeichneten --
Infrastrukturen ist mit der Verbreitung des Internets und den IP Netzen in
Unternehmen lange nicht mehr praxisgerecht. Heute dienen diese Klassifizierungen
meist nur noch als *Orientierungshilfe* bei der Auslegung und Beschreibung von
Infrastrukturen. In größeren Netzen wird man im IPv4 Raum eher eine (*Class-A
ähnliche*) Infratruktur mit *Classless Inter-Domain Routing* (`CIDR`_) vorfinden
und es ist davon auszugehen, dass in fast allen Netzen Verfahren wie `NAT
(wiki)`_ vorzufinden sind.

Mit NAT-Routern können theorehtisch ganze *Class-A* Netze hinter einer einzigen
IP *versteckt* werden, was den Adressbereich der Subnetze erheblich
vergößert. Der NAT-Router fungiert quasi als *Multiplexer* was allerdings auch
Einschränkungen mit sich bringt und damit auch *neue* Anforderungen an die
Netzwerverwaltung stellt.

Der NAT-Router wechselt in den IP Paketen -- die über ihn das (Sub-) Netz
wechseln -- die IP-Absender-Adressen aus. Damit ist die Ende-zu-Ende Verbindung
gebrochen und es können nur *ausgehende* Request geroutet werden (Source-NAT,
SNAT), bei denen der Router die Zieladresse und den Absender aus seinem Subnetz
kennt. Beim ausgehenden Request tauscht der NAT-Router also die IP-Adresse des
Absenders aus und merkt sich das in einer NAT-Tabelle. Wenn der Response auf den
Request kommt schaut der Router in seiner NAT-Tabelle nach, wer der eigentliche
Absender im Subnetz war. Diese Subnetzadresse des Absenders trägt der NAT-Router
nun in das IP-Paket als Empfänger ein um es dann in sein Subnetz zu entlassen.

Einkommende Requests können nicht geroutet werden, da der Absender die
Zieladresse (hinter dem NAT) nicht kennen kann. Er kennt ja nur die *eine*
IP-Adresse, die der NAT-Router nach *draußen* hat. Der NAT-Router empfängt das
Paket von *draußen*, kann selber aber keinen Zielhost in seinem Subnetz dazu
ermitteln, weil es zu dem einkommenden Request keinen Eintrag in seiner
NAT-Tabelle geben kann. Die Konsequenz ist, dass der einkommende Request
geblockt wird. Bei dem NAT Verfahren hat man also auch immer eine (*manchmal
gewollte, manchmal ungewollte*) Firewall mit *eingebaut*.

Um dennoch einen Dienst hinter dem NAT nach *draußen* anbieten zu können hat man
sich Port-Forwarding (Destination NAT, DNAT) ausgedacht. Dabei wird der Router
so konfiguriert, dass er einkommende Requests auf bestimmten Ports an einen ganz
bestimmten Host in seinem Subnetz weiter leitet. Hat man beispielsweise einen
WEB-Server im Subnetzt, der auf die Ports 80 (http) und 443 (https) *lauscht*,
dann kann man den NAT-Router so konfigurieren, dass er alle einkommenden Request
auf diese beiden Ports in seinem Subnetz an den WEB-Host durchreicht.

So kann zumindest *ein* WEB-Server des Subnetzes *nach draußen* angeboten
werden.  Bei *zwei* oder mehr WEB-Servern müsste man noch andere Ports wählen,
dass wären dann aber nicht mehr die *Standard* Ports für http und https die man
von *draußen* sehen würde und der Peer *draußen* müsste nun schon wissen, das er
seinen http (bzw. https) Request an einen ganz anderen Port senden muss.

Bei NAT haben die Peers einer Verbindung immer das Problem, dass sie keine
Ende-zu-Ende Verbindung haben. Die Peers wissen also nicht immer ganz genau wer
der andere Partner ist. Zumindest der Partner *draußen* spricht ja immer mit dem
NAT-Router, der dann das Paket umadressiert. Es ist auch zu erwarten, dass der
Partner *draußen* ebenfalls hinter einem NAT steht. Es werden also i.d.R. immer
alle Adressen umgeschrieben. Dieses Umschreiben der Adressen in den IP Paketen
ähnelt einer *Man-in-the-middle* Attake, weshalb es auch Probleme gibt auf
dieser (IP-) Ebene Verfahren der Absicherung von Peer-to-Peer Verbindungen
umzusetzen. Solche Absicherungen braucht man aber, wenn man *jemanden von
draußen* in sein Subnetz auf der IP Ebene einbinden möchte (IP-Sec).

NAT gibt den Netz-Admins die benötigten IP Adressen und eine verbesserte
Gestaltungsfreiheit, es bleibt aber eine Krücke.  Insbesondere in Unternehmen
und Partnerschaften, die einem ständigen Wechsel unterliegen, wechseln ebenso
schnell die Anforderungen an die IT-Infrastruktur, was so manchen
verantwotungsvollen Netz-Admin von Zeit zu Zeit erhebliches Kopfzerbrechen
bereiten kann.





