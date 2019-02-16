.. -*- coding: utf-8; mode: rst -*-
.. include:: ../print_scan_refs.txt

.. _print_cups_ipp:

======================
Drucken mit CUPS & IPP
======================

  ..

    In den letzten Jahren hat sich viel getan. Mit ":ref:`IPP_intro`" aus dem
    Jahr 2015 wird ":ref:`driverless-printing`" erst möglich.  Führendes
    Konsortium ist die Printer Working Group (PWG_).  `CUPS (wiki)`_ und die
    `PPD (wiki)`_ Dateien haben nach wie vor ihre Bedeutung.  Doch wie spielt
    das alles zusammen?  *.. und vor allem, was tun, wenn's mal hakt?*

------

Höchste Zeit sich mal mit dem aktuellen Stand der Technik vertraut zu machen.
Hier im Artikel ist der Proband ein Canon MF623Cn_, ein AllInOne Laserdrucker
der unteren Preisklasse aus dem Jahre 2016.  Anwendung findet der Artikel aber
auf alle IPP fähigen Drucker.  Canon ist bekannt dafür unter Linux Probleme zu
bereiten.  Wir vergleichen die Druck-Ergebnisse von generischem Treiber und
proprietären Canon Treiber und wir schauen uns an, wo es bei den Treibern hakt
und wie man ggf. Abhilfe schaffen kann.

Spezielle Vorkenntnisse zu den genannten Technologien braucht man nicht, aber
mit etwas Sinn fürs *Tüfteln* bekommt man -- nach der Lektüre dieses Artikels --
bistimmt auch noch den bockigsten Drucker zum laufen.


Die Artikel sind so aufgebaut, dass sie *nacheinander* gelesen werden können,
wer lediglich sehen will, wie er einen Drucker über die GUI einrichtet, der kann
aber auch direkt z.B. in das Kapitel ":ref:`printer_setup`" springen.  Der
rechte Zusammenhang erschließt sich aber erst, wenn man auch die Grundlagen
wenigstens grob kennt.

.. toctree::
   :maxdepth: 2

   cups
   ipp
   ppd
   driver
   printer_setup
   printer_troubleshooting

