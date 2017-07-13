=================================================
get git started
=================================================

.. revealjs:: get git started
   :title-heading: h2
   :data-transition: linear

   Eine prakmatische Einfürung in git

   .. rv_small::

      `return42 <http://github.com/return42>`_

.. revealjs:: Wofür?
   :title-heading: h3

   .. rst-class:: fragment roll-in

      Kollaboration --> *Konfliktbehandlung erforderlich*

      Qualitätsicherung -->  *seit wann gibt's den Fehler*

      parallele Weiterentwicklung-->  *feature branch*

.. revealjs:: Versionsverwaltung
   :title-heading: h3

   .. rst-class:: fragment roll-in

      **zentral**

      .. figure:: svn-logo.png
         :scale: 30 %

      **verteilt**

      .. figure:: git-logo.png
         :scale: 30 %


.. revealjs:: Zentrales SCM
   :title-heading: h3
   :class: fragment

   .. rst-class:: fragment roll-in

      SCM-System bestimmt den Workflow

      Entwickler haben lokale **Workspaces**

      .. figure:: zentralisiert-wf.png
         :scale: 100 %

      Historie liegt auf dem SCM-Server

      Patches gehen in das zentrale Repo


.. revealjs:: Verteiltes SCM
   :title-heading: h3
   :class: fragment

   .. rst-class:: fragment roll-in

      Workflow frei wählbar

      Entwickler haben lokale **Klon**

      .. figure::  verteilter-wf.png
         :scale: 120 %

      Historie liegt auf liegt auf jedem Klon

      Patches gehen zu **remotes**

.. revealjs:: git installieren

   .. rst-class:: fragment roll-in

      * download: https://git-scm.com/downloads
      * MS-Win: https://git-for-windows.github.io
      * GUIs: https://git-scm.com/downloads/guis
      * Git Extensions: https://gitextensions.github.io/

      .. rv_code::

         $ git config --global user.name "Markus Heiser"
         $ git config --global user.email "markus.heiser@darmarit.de"

   .. rv_note::

      Hinweise zur Installation:

      * In git wird alles über die eMail-Adresse und den User-Namen verwaltet, dazu
        bitte:

      * ich bevorzuge "Checkout/Checkin as is" .. sprich git soll keine Änderungen an
        den CR/LF machen, wenn es aus-/eincheckt. Das ist (wenn überhaupt) sinnvoll in
        gemischten Projekten, da sie aber eine reine Win Umgebung haben, brauchen wir
        das nicht .. man kann das später auch wieder einschalten, wenn man merkt, dass
        man es doch haben will.

.. revealjs:: git init
   :title-heading: h3

   .. rv_code::

      $ mkdir myproject
      $ cd myproject
      $ git init

.. revealjs:: git ...
   :title-heading: h3

   .. rv_code::

      $ ...

.. revealjs:: git ...
   :title-heading: h3

   .. rv_code::

      $ ...

.. revealjs:: git ...
   :title-heading: h3

   .. rv_code::

      $ ...


.. revealjs:: online server
   :title-heading: h3

   .. image:: github-octocat.png
      :scale: 20 %

   .. image:: gitlab-logo.png
      :scale: 6 %
      :align: right

   .. image:: bitbucket-logo.png
      :scale: 35 %

   * `GitHub <https://github.com/>`_
   * `GitLab.com <https://gitlab.com/explore>`_
   * `Bitbucket <https://bitbucket.org/account/signup/>`_


.. revealjs:: self hosted
   :title-heading: h3

   *leichtgewicht* `gogs <https://gogs.io>`_

   .. figure:: gogs-logo.jpg
      :scale: 50 %

   *collaboration* `GitLab CE <https://about.gitlab.com>`_

   .. figure:: gitlab-logo.png
      :scale: 10 %

.. revealjs:: Verweise
   :title-heading: h2

   .. rv_small::

      - `git <https://git-scm.com>`_
      - `Pro Git <https://git-scm.com/book/de/v1>`_
      - `sphinxjp.themes.revealjs <https://github.com/tell-k/sphinxjp.themes.revealjs>`_
      - `REVEAL.JS <http://lab.hakim.se/reveal-js>`_
      - `Sphinx-doc <http://www.sphinx-doc.org>`_
      - `reST <http://www.sphinx-doc.org/en/stable/rest.html>`_
      - `docutils <http://docutils.sourceforge.net/rst.html>`_
