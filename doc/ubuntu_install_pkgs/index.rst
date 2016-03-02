.. -*- coding: utf-8; mode: rst -*-

.. include:: ../ubuntu_install_pkgs_refs.txt

.. _xref_ubuntu_install_pkgs:

================================================================================
                                Anwendungspakete
================================================================================

In den Paketquellen des Ubuntus sind alle gängigen Anwendungen bereits enthalten
und können sehr einfach installiert werden. Eine kleine Auswahl dieser
Anwendungspakete soll hier nach Themen sortiert kurz vorgestellt werden.

.. toctree::
   :maxdepth: 1

   multimedia
   codecs
   imgTools
   office
   archTools
   hwTools
   monitoring
   netTools
   devTools
   ubuntu_install_pkgs_refs

In der Regel wird man sich nur einzelne Pakete aus den jweiligen Themengebieten
installieren wollen. Zum *Ausprobieren* der Anwendungen eines Themengebiets
können mit dem Skript ``ubuntu_install_pkgs.sh`` die hier vorgestellten Pakete
zu einem Themengebiet installiert werden.

.. code-block:: bash

   $ sudo ${SCRIPT_FOLDER}/ubuntu_install_pkgs.sh \
       [base|devTools|office|multimedia|codecs|imgTools|archTools|hwTools|monitoring|netTools]


.. hint::

   Das hier ein Softwarepaket vorgestellt wird, ist nicht in jedem Fall mit
   einer Empfehlung gleichzusetzen. Je nach Anforderungen kann eine Empfehlung
   ganz unterschiedlich ausfallen (selber ausprobieren und sehen ob es passt).
