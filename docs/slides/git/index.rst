=================================================
get git started
=================================================

.. revealjs:: get git started
   :title-heading: h2
   :data-transition: linear

   Eine prakmatische Einfürung in git

   .. rv_small::

      contributed by `return42 <http://github.com/return42>`_

      *Hit '?' to see keyboard shortcuts*

.. revealjs:: Wofür SCM?
   :title-heading: h3

   .. rst-class:: fragment roll-in

      Kollaboration --> *Konflikterkennung erforderlich*

      Qualitätsicherung -->  *seit wann gibt's den Fehler*

      parallele Weiterentwicklung-->  *feature branch*

      Produktivität --> *jonglieren statt editieren*

      .. figure:: Passing_2jugglers_6balls_Ultimate-Valse_side.gif
         :target: https://commons.wikimedia.org/wiki/File:Passing_2jugglers_6balls_Ultimate-Valse_side.gif


.. revealjs:: SCM Systeme
   :title-heading: h3

   .. rst-class:: fragment roll-in

      **zentral**

      .. figure:: svn-logo.png
         :scale: 30 %
         :target: https://subversion.apache.org/

      **verteilt**

      .. figure:: git-logo.png
         :scale: 30 %
         :target: https:/git-scm.com/


.. revealjs:: Zentrales SCM
   :title-heading: h3
   :class: fragment

   .. rst-class:: fragment roll-in

      SCM-System bestimmt den Workflow

      Entwickler haben lokale **Workspaces**

      .. figure:: zentralisiert-wf.png
         :scale: 100 %
         :target: https://git-scm.com/book/en/v2/Distributed-Git-Distributed-Workflows

      Historie liegt auf dem SCM-Server

      Patches gehen in das zentrale Repo


.. revealjs:: Verteiltes SCM mit Remotes
   :title-heading: h3
   :class: fragment

   .. rst-class:: fragment roll-in

      Workflow frei wählbar

      Entwickler haben lokal einen **Klon**

      .. figure::  verteilter-wf.png
         :scale: 100 %
         :target: https://git-scm.com/book/en/v2/Distributed-Git-Distributed-Workflows

      Historie liegt auf jedem Klon vor

      Anstelle EINES SCM-Servers gibt es N ``remote``

.. revealjs:: Installation -- git

   https://git-scm.com/downloads

   .. rst-class:: fragment roll-in

      * MS-Win: https://git-for-windows.github.io
      * GUIs: https://git-scm.com/downloads/guis
      * Git Extensions: https://gitextensions.github.io/

.. revealjs:: Einrichten -- git-config

   git identifiziert den Benutzer (Committer) über seine eMail-Adresse und
   seinen Namen:

   .. rv_code::

      $ git config --global user.name "Markus Heiser"
      $ git config --global user.email "markus.heiser@darmarit.de"

   .. rst-class:: fragment roll-in

      pedantisch ..

      .. rv_code::

         $ git config --global --unset credential.helper
         $ git config --global core.autocrlf false
         $ git config --global core.symlinks true

   .. rv_note::

      * Der 'Git Credential Manager for Windows' speichert die Passwörter
        in der 'Anmeldeinformationsverwaltung' des Windows Benutzer.

      * Ich bevorzuge 'Checkout/Checkin as is' .. sprich git soll keine
        Änderungen an den CR/LF machen, wenn es aus-/eincheckt.  Das ist (wenn
        überhaupt) sinnvoll in gemischten Projekten

.. revealjs:: Einrichten -- git-config (optional)

   .. rst-class:: fragment roll-in

      aufrüschen ..

      .. rv_code::

         $ git config --global color.ui true
         $ git config --global alias.st "status"
         $ git config --global alias.unadd "reset HEAD"

      anpassen ..

      .. rv_code::

         $ git config --global push.default simple
         $ git config --global core.editor emacsclient

      nachlesen ..

      `git help config -- <https://git-scm.com/docs/git-config.html>`_

   .. rv_note::

      Die Hilfe zu git ist sehr ausführlich und immer lesenswert. Man muss auch
      nicht lange suchen sonder gibt einfach nur ``git help ...`` ein. Auf Linux
      kommt dann die man-Page auf Windows wird die HTML Version angezeigt.

.. revealjs:: lokales Arbeiten -- Dateien ...
   :title-heading: h3

   .. rv_small::

      * im Workspace (WS)
      * im Stage
      * im Reposetory

   .. rst-class:: fragment roll-in

      .. figure::  lifecycle.png
         :scale: 100 %
         :target: https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository

.. revealjs:: lokales Arbeiten -- Grundlagen
   :title-heading: h3

   .. rst-class:: fragment roll-in

      .. rv_code::

         $ git init
         $ git add .gitignore

      .. rv_code::

         $ git status ...

      .. rv_code::

         $ git add ...

      .. rv_code::

         $ git rm ...

      .. rv_code::

         $ git commit ...

      .. rv_code::

         $ git checkout ...

      .. rv_code::

         $ git log ...

   .. rv_note::

      Es gibt bei weitem mehr Komandos, z.B. ``branch``, ``merge`` etc. aber
      diese sollen für den Anfang erst mal reichen.

.. revealjs:: lokales Arbeiten -- git init
   :title-heading: h3

   Am Anfang war nichts ... (`Getting a Git Repository <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__)

   .. rv_code::

      $ mkdir myproject
      $ cd myproject
      $ git init
      Initialized empty Git repository in myproject/.git/

   Die erste Datei .. README.txt

   .. rv_code::

      .. -*- coding: utf-8; mode: rst -*-

      ======
      README
      ======

      Nothing special here, only intended for teaching purposes.

   .. rv_note::

      Meist bekommt man sein Repo via ``clone`` aber auch das wurde mal mit
      ``init`` angelegt.


.. revealjs:: lokales Arbeiten -- git status
   :title-heading: h3

   .. rv_code::

      $ git status
      On branch master

      Initial commit

      Untracked files:
        (use "git add [file]..." to include in what will be committed)

	      README.txt
	      README.txt~

      nothing added to commit but untracked files present (use "git add"
      to track)

   .. rst-class:: fragment roll-in

      aktueller Branch ist ``master``

      Stage ist gerade leer, vergleiche mit dem  `Diagramm <#/8>`__

      besser wir ignorieren ``README.txt~``

   .. rv_note::

      git macht Annahmen darüber, was man wohl als nächstes machen will und gibt
      dazu Hilfestellung hier z.B. ``git add``

.. revealjs:: lokales Arbeiten -- .gitignore
   :title-heading: h3

   ``.gitignore``: Pattern die ignoriert werden `(nachlesen) <https://git-scm.com/docs/gitignore>`__

   .. rst-class:: fragment roll-in

      .. rv_code::

         *~
         */#*#
         .#*
         *.pyc
         *.pyo

      Beispiele für `.gitignore <https://github.com/github/gitignore>`__

      .. rv_code::

         $ git status
         ...
         Untracked files:
           ...
	         .gitignore
	         README.txt

      Sieht schon besser aus :)


.. revealjs:: lokales Arbeiten -- git add
   :title-heading: h3

   .. rst-class:: fragment roll-in

      initial fügen wir **alles** hinzu ..

      .. rv_code::

         $ git add --all ./

      mal schauen wie der Status ist ...

      .. rv_code::

         On branch master

         Initial commit

         Changes to be committed:
           (use "git rm --cached [file]..." to unstage)

	         new file:   .gitignore
	         new file:   README.txt

      schon im Repo? .. nein, nur im Stage `Diagramm <#/8>`__.

   .. rv_note::

      Angenommen wir wollen die README.txt noch nicht drin haben, dann gibt git uns
      hier gleich den richtigen Hinweis, wie wir die Datei wieder rausbekommen ...

.. revealjs:: lokales Arbeiten -- git rm
   :title-heading: h3

   .. rst-class:: fragment roll-in

      zuviel hinzugefügt? .. nimm es wieder aus dem Stage:

      .. rv_code::

         $ git rm --cached README.txt
         rm 'README.txt'

      Ups, hat er die jetzt etwa gelöscht?!?!

      .. rv_code::

         $ git status
         ...
         Changes to be committed:
	         new file:   .gitignore

         Untracked files:
	         README.txt

      nein, wurde nur aus dem Stage genommen `Diagramm <#/8>`__

.. revealjs:: lokales Arbeiten -- git commit
   :title-heading: h3

   .. rst-class:: fragment roll-in

      So, jetzt ist der Patch aber fertig!

      Alles was zum Patch gehört liegt im Stage.

      .. rv_code::

         $ git commit -m "inital boilerplate"
         [master (root-commit) a69b20f] inital boilerplate
          1 file changed, 5 insertions(+)
          create mode 100644 .gitignore

      .. rv_code::

         $ git status
         On branch master
         Untracked files:
           (use "git add [file]..." to include in what will be committed)

	         README.txt

.. revealjs:: lokales Arbeiten -- git show
   :title-heading: h3

   .. rv_small::

      Wie sieht so ein Patch im Repo eigentlich aus?

   .. rst-class:: fragment roll-in

      .. rv_code::

         $ git show HEAD
         commit a69b20f5f64a371e035cfa1bcfcf8c4841b7b336
         Author: Markus Heiser &lt;markus.heiser@darmarit.de>
         Date:   Sun Jul 16 18:22:34 2017 +0200

             inital boilerplate

         diff --git a/.gitignore b/.gitignore
         new file mode 100644
         index 0000000..68c190d
         --- /dev/null
         +++ b/.gitignore
         @@ -0,0 +1,5 @@
         +*~
         +*/#*#
         +.#*
         +*.pyc
         +*.pyo

   .. rv_note::

      Anders als bei SVN & Co. gibt es keine fortlaufende Nummer. Ein commit
      wird an seinem SHA-1 Hash Value identifiziert. Üblicherweise braucht man
      davon aber nur die ersten 6 oder 10 Stellen um ihn zu eindeutig zu
      referenzieren.

        commit a69b20f


.. revealjs:: git ...
   :title-heading: h3

   .. rv_code::

      $ ...


.. revealjs:: online server
   :title-heading: h3

   .. image:: github-octocat.png
      :scale: 19 %

   .. image:: gitlab-logo.png
      :scale: 6 %
      :align: right

   .. image:: bitbucket-logo.png
      :scale: 40 %

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
      :scale: 8 %

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
