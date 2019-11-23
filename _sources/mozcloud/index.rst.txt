.. -*- coding: utf-8; mode: rst -*-

.. include:: ../mozcloud_refs.txt

.. _xref_mozcloud_index:

================================================================================
                             Setup Mozilla Dienste
================================================================================

.. hint::

  Seit der Apache auf WSGI mit Python 3 umgestellt wurde, können die Mozilla
  Dienste nicht mehr betrieben werden, da diese noch nicht Python 3 *compliant*
  sind. WIP: https://github.com/return42/moz-cloud

Die Mozilla-Cloud Dienste sind eine skallierbare Infrastruktur interoperabler
Dienste. Einen Überblick liefert der Abschnitt :ref:`xref_mozcloud_services`.
Der Abschnitt :ref:`xref_mozcloud_setup` beschreibt die Umgebung in dem die
Dienste der Mozilla-Cloud betrieben werden und der Abschnitt
:ref:`xref_mozcloud_fxsync` beschreibt, wie ein einfacher Firefox Sync-1.5
Server eingerichtet werden kann.

.. toctree::
   :maxdepth: 1

   mozcloud_services
   mozcloud_setup
   fxsync_1_5_server
   mozcloud_refs
