.. -*- coding: utf-8; mode: rst -*-

.. include:: ../devTools_refs.txt
.. include:: ../lxdlxc_refs.txt
.. include:: ../docker_refs.txt

.. _xref_ubuntu_devTools_docker:

================================================================================
Docker
================================================================================

Eine Beschreibung befindet sich im Kapitel :ref:`xref_docker`.  APT Paket(e):

.. sidebar:: UPDATE

   Die Installation von docker.io ist veraltet, besser man liest hier nach wie
   man `docker unter ubuntu installiert
   <https://docs.docker.com/engine/install/ubuntu/>`__

* :deb:`docker.io`
* :deb:`docker-compose`

Mit dem APT Paket :deb:`docker.io` wird die Gruppe `docker` eingerichtet. Damit
ein Benutzer Docker verwenden kann, muss er zu dieser Gruppe hinzgefügt werden::

  $ sudo -H adduser <user-login> docker

Docker selbst läuft als Dienst und wird beim booten automatisch gestartet
(s.a. dockerd_).  Die *Arbeitsdaten* wie z.B. die Images werden unter
``/var/lib/docker`` abgelegt.

Docker Images können über Docker-Hub_ bezogen werden. Ein *hello-world*
Beispiel::

  $ docker run hello-world
  Unable to find image 'hello-world:latest' locally
  latest: Pulling from library/hello-world
  9db2ca6ccae0: Pull complete
  Digest: sha256:4b8ff392a12ed9ea17784bd3c9a8b1fa3299cac44aca35a85c90c5e3c7afacdc
  Status: Downloaded newer image for hello-world:latest

  Hello from Docker!
  ...
