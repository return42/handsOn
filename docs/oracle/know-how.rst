.. -*- coding: utf-8; mode: rst -*-
.. include:: ../oracle_refs.txt

.. _oracle_know_how:

===============
Oracle Know-how
===============

Aus welcher Oracle Version wurde mein DUMP erzeugt?
---------------------------------------------------

::

    $ strings my_dump_file.dmp | head -n 5
    "SYS"."SYS_EXPORT_SCHEMA_01"
    IBMPC/WIN_NT64-9.1.0
    ...
    AL32UTF8
    11.02.00.00.00

SQL-Developer
-------------

TODO
