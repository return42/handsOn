=================================================
get git started
=================================================

.. _git: https://git-scm.com
.. _return42: https://github.com/return42
.. _`Git Aliases`: https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases
.. _`git-config`: https://git-scm.com/docs/git-config.html
.. _`git init`: https://git-scm.com/docs/git-init
.. _`git status`: https://git-scm.com/docs/git-init
.. _`git add`: https://git-scm.com/docs/git-add
.. _`git rm`: https://git-scm.com/docs/git-rm
.. _`git commit`: https://git-scm.com/docs/git-commit
.. _`git show`: https://git-scm.com/docs/git-show
.. _`git log`: https://git-scm.com/docs/git-log
.. _`git merge`: https://git-scm.com/docs/git-merge
.. _`git branch`: https://git-scm.com/docs/git-branch
.. _`git checkout`: https://git-scm.com/docs/git-branch
.. _`git push`: https://git-scm.com/docs/git-push
.. _`git clone`: https://git-scm.com/docs/git-clone
.. _`git fetch`: https://git-scm.com/docs/git-fetch
.. _`git pull`: https://git-scm.com/docs/git-pull
.. _`git remote`: https://git-scm.com/docs/git-remote
.. _`git format-patch`: https://git-scm.com/docs/git-format-patch
.. _`git am`: https://git-scm.com/docs/git-am

.. _`Getting a Git Repository`: https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository
.. _`.gitignore`: https://git-scm.com/docs/gitignore
.. _`.gitignore Vorlagen`: https://github.com/github/gitignore
.. _`GitLab CE`: https://about.gitlab.com

.. _gogs: https://gogs.io
.. _`Pro Git` : https://git-scm.com/book/de/v1
.. _`sphinxjp.themes.revealjs`: https://github.com/return42/sphinxjp.themes.revealjs
.. _`REVEAL.JS`: https://lab.hakim.se/reveal-js
.. _`Sphinx-doc`: https://www.sphinx-doc.org
.. _reST: https://www.sphinx-doc.org/en/stable/rest.html
.. _docutils: http://docutils.sourceforge.net/rst.html
.. _GitHub: https://github.com
.. _`GitLab.com`: https://gitlab.com/explore
.. _Bitbucket: https://bitbucket.org/account/signup
.. _`remote Branches`: https://git-scm.com/book/en/v2/Git-Branching-Remote-Branches
.. _Refspec: https://git-scm.com/book/en/v2/Git-Internals-The-Refspec
   
.. raw:: html

   <aside id="logo" style="height:8vh; width:8vw; position:absolute; bottom:2vh; left:2vw; ">
     <a href="http://www.darmarit.de">
       <img src="_static/darmarIT_logo_512.png">
     </a>
   </aside>

.. revealjs:: get git started
   :title-heading: h2
   :data-transition: linear

   Aufaben des Source-Code-Managments (SCM)

   mit git_ bewältigen

   Eine pragmatische Einarbeitung in git.

   .. rv_small::

      contributed by `return42`_

      *Hit '?' to see keyboard shortcuts / 's' to view speaker notes*

   .. rv_note::

      Dieses kleine Tutorial richtet sich an Entwickler und Administratoren, die
      bisher nicht viel mit Source-Code-Management (SCM) zu tun hatten und sich
      nun mit git vertraut machen wollen.

      Die Aufgaben des SCM sind immer gleich egal ob man git, SVN oder *was auch
      immer* als SCM-System nutzt. Git ist *state-of-the-art* und bietet
      vielseitige Möglichkeiten, die andere Systeme z.T. vermissen lassen.


.. revealjs:: Aufgaben des SCM?
   :title-heading: h3

   .. rst-class:: fragment roll-in

      Kollaboration --> *Konflikterkennung erforderlich*

      Qualitätsicherung -->  *seit wann gibt's den Fehler*

      parallele Weiterentwicklung-->  *feature branch*

      Produktivität --> *jonglieren statt editieren*

      .. figure:: Passing_2jugglers_6balls_Ultimate-Valse_side.gif
         :target: https://commons.wikimedia.org/wiki/File:Passing_2jugglers_6balls_Ultimate-Valse_side.gif

   .. rv_note::

      Einige werden evtl. schon SVN (subversion) kennen. Meine Erfahrung ist
      aber, dass es oftmals nur als *Ablage* genutzt wird / echtes SCM ist was
      anderes. Die Bereitschaft sich mit den Problemen der *parallelen*
      Entwicklung (branch) und dem Lösen von Konflikten (merge)
      auseinanderzusetzen wird beim Auditorium vorausgesetzt, sonst macht das
      alles keinen Sinn und man lässt es besser gleich ganz.

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

   .. rv_note::

      SVN ist von seiner Architektur her für ein verteiltes Arbeiten
      insbesondere in remote-Szenarien (offline) nicht geeigent.

.. revealjs:: Zentrales SCM
   :title-heading: h3
   :class: fragment

   Entwickler haben lokale **Workspaces**

   Historie liegt auf dem SCM-Server

   .. figure:: zentralisiert-wf.png
      :scale: 100 %
      :target: https://git-scm.com/book/en/v2/Distributed-Git-Distributed-Workflows

   Patches gehen immer in das zentrale Repo

   SCM-System limitiert den Workflow

   .. rv_note::

      Am Ende werden zwar bei jeder Entwicklung alle Änderungen in den *master*
      Zweig auf dem *origin* Repository eingepflegt. Das Problem bei SVN ist
      aber, dass auch die Branches nur auf dem Server liegen können. Alles muss
      gegen diesen EINEN Server laufen.


.. revealjs:: Verteiltes SCM mit Remotes
   :title-heading: h3
   :class: fragment

   Entwickler haben lokal einen **Klon**

   Historie liegt auf jedem Klon vor

   .. figure::  verteilter-wf.png
      :scale: 100 %
      :target: https://git-scm.com/book/en/v2/Distributed-Git-Distributed-Workflows

   Anstelle EINES SCM-Servers gibt es N ``remote``

   Workflow frei wählbar

   .. rv_note::

      Anders als bei SVN, bei dem man nur den EINEN *remote* hat, der
      gleichzeitig *origin* ist, kann man bei git mehrere *remotes* haben. Aber
      auch bei git wird man nur einen *remote* als *origin* haben. Auf dem
      *origin* laufen am Ende alle Entwicklungen zusammen.


.. revealjs:: Installation -- git

   https://git-scm.com/downloads

   * MS-Win: https://git-for-windows.github.io
   * GUIs: https://git-scm.com/downloads/guis
   * Git Extensions: https://gitextensions.github.io/

.. revealjs:: Einrichten -- git-config

   git identifiziert den Benutzer (Committer) über seine eMail-Adresse und
   seinen Namen:

   .. rv_code::
      :class: shell

      $ git config --global user.name "Max Mustermann"
      $ git config --global user.email "max.mustermann@muster.org"


   pedantisch ..

   .. rv_code::
      :class: shell

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

   aufrüschen ..

   .. rv_code::
      :class: shell

      $ git config --global color.ui true

   anpassen ..

   .. rv_code::
      :class: shell

      $ git config --global push.default simple
      $ git config --global core.editor emacsclient

   nachlesen ..

   `git help config <git-config>`_

   .. rv_note::

      Die Hilfe zu git ist sehr ausführlich und immer lesenswert. Man muss auch
      nicht lange suchen sonder gibt einfach nur ``git help ...`` ein. Auf Linux
      kommt dann die man-Page auf Windows wird die HTML Version angezeigt.

.. revealjs:: lokales Arbeiten -- Dateien & Änderungen
   :title-heading: h3

   - im Workspace (WS)
   - im Stage (gibts beim SVN z.B. nicht)
   - im lokalem Repository (beim SVN nur remote)

   .. figure::  lifecycle.png
      :scale: 100 %
      :target: https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository

   .. rv_note::

      Dateien werden am Ende im Repository committet .. vorher bewegen sie sich
      aber im lokalen WS und im Stage (auch Index genannt). Der *Stage* ist
      sozusagen die Vorstufe auf dem Weg ins Repository.

      Wir brauchen uns das Schaubild jetzt noch nicht so genau anschauen, wir
      werden da aber später wieder drauf zurück kommen.

.. revealjs:: lokales Arbeiten -- Grundlagen
   :title-heading: h3

   .. rv_code::
      :class: shell

      $ git init
      $ git add ...
      $ git status ...
      $ git add ...
      $ git rm ...
      $ git commit ...
      $ git checkout ...
      $ git log ...
      $ git branch ...
      $ git merge ...

   .. rv_note::

      Es gibt bei weitem mehr Komandos, aber dies sind die wichtigsten wenn man
      lokal mit seinem git arbeitet. Die *remotes* sind am Ende nur *andere*
      Repositories aus denen man sich die Patches holen kann (fetch nennt sich
      das dann).

.. revealjs:: lokales Arbeiten -- git init
   :title-heading: h3

   Am Anfang war nichts ... (`Getting a Git Repository`_, `git init`_)

   .. rv_code::
      :class: shell

      $ mkdir git-teaching
      $ cd git-teaching
      $ git init
      Initialized empty Git repository in git-teaching/.git/

   Die erste Datei: README.txt

   .. rv_code::
      :class: rst

      .. -*- coding: utf-8; mode: rst -*-

      ======
      README
      ======

      Nothing special here, only intended for teaching purposes.

   .. rv_note::

      Meist bekommt man sein Repo via ``clone`` aber auch das wurde mal mit
      ``init`` angelegt.

.. revealjs:: lokales Arbeiten -- `git status
   :title-heading: h3

   .. rv_code::
      :class: shell

      $ git status
      Auf branch master

      Initialaler Commit

      Unversionierte Dateien:
        (benutzen Sie "git add <Datei>...", um die Änderungen\
         zum Commit vorzumerken)

              README.txt
              README.txt~

      nichts zum Commit vorgemerkt, aber es gibt unversionierte
      Dateien (benutzen Sie "git add" zum Versionieren)

   .. rst-class:: fragment roll-in

      `git status`_: aktueller Branch ist ``master``, Stage ist gerade leer,
      vergleiche mit dem `Diagramm <#/8>`__

      .. rv_small::

         besser wir ignorieren ``README.txt~``

   .. rv_note::

      Git macht Annahmen darüber, was man wohl als nächstes machen will und gibt
      dazu Hilfestellung hier z.B. ``git add``

.. revealjs:: Einrichten -- .gitignore
   :title-heading: h3

   ``.gitignore``: Pattern die ignoriert werden `(nachlesen) <.gitignore>`_

   .. rst-class:: fragment roll-in

      .. rv_code::

         *~
         */#*#
         .#*
         *.pyc
         *.pyo

      `.gitignore Vorlagen`_

      .. rv_code::
         :class: shell

         $ git status
         ...
         Untracked files:
           ...
                 .gitignore
                 README.txt

      sieht schon besser aus :)


.. revealjs:: lokales Arbeiten -- git add
   :title-heading: h3

   .. rst-class:: fragment roll-in

      initial fügen wir einfach mal **alles** hinzu `git add`_

      .. rv_code::
         :class: shell

         $ git add --all ./

      mal schauen wie der Status ist ...

      .. rv_code::

         Auf branch master

         Initialaler Commit

         zum Commit vorgemerkte Änderungen:
           (benutzen Sie "git rm --cached <Datei>..."
            zum Entfernen aus der Staging-Area)

                 neue Datei:   .gitignore
                 neue Datei:   README.txt

      schon im Repo? .. nein, nur im Stage `Diagramm <#/8>`__.

   .. rv_note::

      Angenommen wir wollen die README.txt noch nicht drin haben, dann gibt git
      uns hier gleich den richtigen Hinweis, wie wir die Datei wieder
      rausbekommen ... mit 'git rm --cached'


.. revealjs:: lokales Arbeiten -- git rm
   :title-heading: h3

   .. rst-class:: fragment roll-in

      zuviel hinzugefügt? .. nimm es wieder aus dem Stage `git rm`_

      .. rv_code::
         :class: shell

         $ git rm --cached README.txt
         rm 'README.txt'

      Ups, hat er die jetzt etwa gelöscht?!?!

      .. rv_code::
         :class: shell

         $ git status
         ...
         zum Commit vorgemerkte Änderungen:
                 neue Datei:   .gitignore

         Unversionierte Dateien:
                 README.txt

      nein, wurde nur aus dem Stage genommen `Diagramm <#/8>`__



.. revealjs:: lokales Arbeiten -- git commit
   :title-heading: h3

   .. rst-class:: fragment roll-in

      So, jetzt ist der Patch aber fertig!

      Alles was zum Patch gehört liegt im Stage, `git commit`_

      .. rv_code::
         :class: shell

         $ git commit -m "inital boilerplate"
         [master (Basis-Commit) 849c175] inital boilerplate
          1 file changed, 5 insertions(+)
          create mode 100644 .gitignore

      .. rv_code::
         :class: shell

         $ git status
         Auf Branch master
         Unversionierte Dateien:
           (benutzen Sie "git add <Datei>...", um die Änderungen
            zum Commit vorzumerken)

                README.txt

.. revealjs:: lokales Arbeiten -- git show
   :title-heading: h3

   .. rv_small::

      Wie sieht so ein Patch im Repo eigentlich aus? `git show`_

   .. rst-class:: fragment roll-in

      .. rv_code::
         :class: diff

         $ git show
         commit 849c17589476d9451bc55659008cda5ac2aa68cb
         Author: Max Mustermann <max.mustermann@muster.org>
         Date:   Mon Jul 31 14:59:40 2017 +0200

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
      davon aber nur die ersten 6 oder 10 Stellen um ihn eindeutig zu
      referenzieren.

        commit 849c17


.. revealjs:: lokales Arbeiten -- git log
   :title-heading: h3

   .. rst-class:: fragment roll-in

      jetzt mal die README.txt einchecken

      .. rv_code::
         :class: shell

         $ git add README.txt
         $ git commit -m "add README"
         [master 9af1a51] add README
          1 file changed, 7 insertions(+)
          create mode 100644 README.txt

      und mal das Log anschauen `git log`_

.. revealjs:: lokales Arbeiten -- git log
   :title-heading: h3

   .. rv_code::
      :class: shell

      $ git log
      commit 9af1a518a77bc56dc697bee6ba1c356bb0c1b2f8
      Author: Max Mustermann <max.mustermann@muster.org>
      Date:   Mon Jul 31 15:03:40 2017 +0200

          add README

      commit 849c17589476d9451bc55659008cda5ac2aa68cb
      Author: Max Mustermann <max.mustermann@muster.org>
      Date:   Mon Jul 31 14:59:40 2017 +0200

          inital boilerplate

   .. rst-class:: fragment roll-in

      .. rv_small::

         Für die Branches eignen sich Graphen, aber auch das ist recht
         ausführlich. Man hätte da gerne was kompakteres (*two-liner als
         alias*).

      .. rv_code::
         :class: shell

         $ git log --graph


.. revealjs:: Einrichten -- git config / alias
   :title-heading: h3

   .. rst-class:: fragment roll-in

      `Git Aliases`_

      Für faule Leute wie mich ``git st`` & ``git unadd``

      .. rv_code::
         :class: shell

         $ git config --global alias.st "status"
         $ git config --global alias.unadd "reset HEAD"

      Alias 'git graph' als *two-liner*:

      .. rv_code::

         git config --global alias.graph "log --graph --abbrev-commit\
          --decorate --format=format:'%C(bold blue)%h%C(reset)\
          - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)\
         %C(bold yellow)%d%C(reset)%n''\
                   %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'\
          --all"

      .. rv_small::

         Bitte nicht genauer hinschauen, es gibt auch GUIs die so was
         visualisiern können. ;)


   .. rv_note::

      Wer das aber gerne auf der Kommandozeile haben möchte, der findet im Netz
      genügend C&P Beispiele.

      Mit ``--global`` wir die Einstellung im HOME Ordner hinterlegt. Mit
      ``--local`` würde man die Kofiguration im Projekt ablegen.


.. revealjs:: So könnte es im Terminal aussehen
   :title-heading: h3

   .. figure::  cmdline-git-graph.png
      :scale: 100 %


.. revealjs:: lokales Arbeiten -- git branch
   :title-heading: h3

   .. rst-class:: fragment roll-in

      Initial gibt es den master branch

      .. rv_code::

         $ git branch -v
         * master 9af1a51 add README

      feature branch 'hello-world' anlegen `git branch`_

      .. rv_code::

         $ git branch hello-world
         $ git branch -v
           hello-world 9af1a51 add README
         * master      9af1a51 add README

      `git checkout`_ um den branch auszuchecken

      .. rv_code::

         $ git checkout hello-world
         Zu Branch 'hello-world' gewechselt


.. revealjs:: branch: hello-world
   :title-heading: h3

   .. rst-class:: fragment roll-in

      .. rv_code::
         :class: python

         #!/usr/bin/env python
         # -*- coding: utf-8; mode: python -*-

         print("hello world")

      Implementierung ``hello-world.py`` testen

      .. rv_code::
         :class: shell

         $ python hello-world.py
         hello world

      und einchecken

      .. rv_code::
         :class: shell

         $ git add hello-world.py
         $ git commit -m "add hello-world script"
         [hello-world 0dd2abe] add hello-world script
          1 file changed, 4 insertions(+)
          create mode 100755 hello-world.py


   .. rv_note::

      Es ist gute Praxis in den ersten beiden Zeilen einen *maschienenlsbaren*
      Kommentar zu hinterlegen. Bei Skripten steht in der ersten Zeile oft noch
      ein *Shebang* Kommentar. Da eine Datei immer nur eine Folge von Bytes ist
      und man eigentlich nicht wissen kann, wie diese Datei kodiert ist (utf-8,
      iso-88591, cp1252 ..) muss man dem Editor ein paar Metadaten an die Hand
      geben. Diese Metadaten stehen dann meist in der zweiten Zeile (falls in
      der ersten ein shebang steht). Gute Editoren werten das 'coding:xyz' aus
      und sehr gute Editoren werten dann auch noch den 'mode: ...' aus und
      schalten in einen Bearbeitungsmodus, der zur Programmiersprache passt.


.. revealjs:: branch: master
   :title-heading: h3

   .. rst-class:: fragment roll-in

      .. rv_code::

         $ git checkout master
         Zu Branch 'master' gewechselt

      Änderungen an der README.txt vornehmen ..

      .. rv_code::

         We created a 'hello-world' branch where one of our
         provider implements an amazing 'hello world' program.

      und einchecken

      .. rv_code::

         $ git add README.txt
         $ git commit -m "add remark about 'hello world' order"
         [master c1ce07c] add remark about 'hello world' order
          1 file changed, 3 insertions(+)

   .. rv_note::

      Wir wechseln in den *master* Branch und arbeiten da auch weiter.  Am Ende
      müssen Feature-Branch und master wieder zusammengführt werden. Dabei kann
      es Konflikte geben und einen solchen Konflikt wollen wir jetzt mal
      vorbereiten.

.. revealjs:: git graph

   .. figure:: git-graph-001.svg


.. revealjs:: branch: hello-world
   :title-heading: h3

   .. rst-class:: fragment roll-in

      .. rv_code::

         $ git checkout hello-world
         Zu Branch 'hello-world' gewechselt

      Die README ist noch die *alte* (logisch)

      .. rv_code::
         :class: rst

         $ cat README.txt
         .. -*- coding: utf-8; mode: rst -*-

         ======
         README
         ======

         Nothing special here, only intended for teaching purposes.

.. revealjs:: branch: hello-world
   :title-heading: h3

   Wir fügen ChangeLog Eintrag zur README hinzu:

   .. rv_code::

      ChangeLog:

      2017-07-31  Max Mustermann <max.mustermann@muster.org>

      * hello-world.py: inital implemented & tested

   .. rst-class:: fragment roll-in

      und im branch (hello-world) einchecken

      .. rv_code::

         $ git add README.txt
         $ git commit -m "hello-world: add changelog"
         [hello-world 8e448cd] hello-world: add changelog
          1 file changed, 6 insertions(+)

   .. rv_note::

      Wir sind wieder zurück im *hello-world* branch und arbeiten da auch
      weiter. Die Änderung an der README aus dem *master* branch ist hier
      natürlich noch nicht drin. Jetzt editieren wir auch mal die README in
      diesem branch. Wenn das nacher im *master* zusammengführt wird, müssten
      wir einen Konflikt bekommen.

.. revealjs:: git graph
   :title-heading: h3

   .. figure::  git-graph-002.svg

   .. rv_note::

      An diesem Bild können wir mal kurz *inne halten*. Wir sehen, dass der
      master sich weiter entwickelt hat und der feature-branch (hello-world)
      seine eigenen vortschritt hat.

      Ziel ist es ja, das 'feature' jetzt in den 'master' zu bekommen (mergen).

      Dabei wird es u.U. Konflikte geben. In der Grafik nicht zu sehen, aber
      oben bereits erwähnt, erwarten wir ja so einen Konflikt in der README.txt.

.. _git-merge-hello-world:

.. revealjs:: git merge
   :title-heading: h3

   Der *feature* branch ``hello-world`` wird mit dem ``master`` zusammengeführt.

   .. rv_code::

      $ git checkout master
      Zu Branch 'master' gewechselt

   Im ``master`` wird jetzt der Merge durchgeführt `git merge`_

   .. rv_code::

      $ git merge hello-world
      automatischer Merge von README.txt
      KONFLIKT (Inhalt): Merge-Konflikt in README.txt
      Automatischer Merge fehlgeschlagen; beheben Sie die Konflikte
      und committen Sie dann das Ergebnis.

   Konflikte liegen in der Natur paralleler Entwicklung. Das SCM System hilft
   uns diese zu erkennen!


.. revealjs:: git merge
   :title-heading: h3

   .. rv_code::

      $ git status
      Auf Branch master
      Sie haben nicht zusammengeführte Pfade.
        (beheben Sie die Konflikte und führen Sie "git commit" aus)

      zum Commit vorgemerkte Änderungen:

              neue Datei:     hello-world.py

      Nicht zusammengeführte Pfade:
        (benutzen Sie "git add/rm <Datei>...",
         um die Auflösung zu markieren)

              von beiden geändert:    README.txt

   Mit ``hello-world.py`` gab es keine Konflikte, wurde bereits *ge-added*.
   Die ``README.txt`` hatte einen Konflikt.

.. revealjs:: git merge conflict
   :title-heading: h3

   .. rv_code::
      :class: diff

      <<<<<<< HEAD
      We created a 'hello-world' branch where one of our
      provider implements an amazing 'hello world' program.
      =======
      ChangeLog:

      2017-07-31  Max Mustermann <max.mustermann@muster.org>

      * hello-world.py: inital implemented & tested
      >>>>>>> hello-world


   git hat die ``README.txt`` zusammengeführt. Passagen die nicht automatisch
   zusammengeführt werden können sind mit ``<<<<<<<``, ``=======`` und
   ``>>>>>>>`` gekennzeichnet.


.. revealjs:: git merge conflict
   :title-heading: h3

   semantische Zusammenführung!

   der alte Kommentar hat keine Gültigkeit mehr

   .. rv_code::
      :class: diff

      Features:

      * amazing 'hello world' program

      ChangeLog:

      2017-07-31  Max Mustermann <max.mustermann@muster.org>

      * hello-world.py: inital implemented & tested

   er wird durch einen komplett neuen Kommentar ersetzt.

.. revealjs:: git merge conflict
   :title-heading: h3

   ``git diff``

   .. rv_code::
      :class: diff

      @@@ -6,5 -6,8 +6,12 @@@ READM

        Nothing special here, only intended for teaching purposes.

      - We created a 'hello-world' branch where one of our
      - provider implements an amazing 'hello world' program.
      ++Features:
      ++
      ++* amazing 'hello world' program
      ++
      + ChangeLog:
      +
      + 2017-07-31  Max Mustermann <max.mustermann@muster.org>
      +
      + * hello-world.py: inital implemented & tested


.. revealjs:: git merge conflict
   :title-heading: h3

   Implementierung testen ...

   .. rv_code::
      :class: shell

      $ python hello-world.py
      hello world

   und einchecken

   .. rv_code::
      :class: shell

      $ git add README.txt
      $ git commit -m "merge hello-world branch"
      [master f5f3b62] merge hello-world branch

.. _git-graph:

.. revealjs:: git graph
   :title-heading: h3

   .. figure::  git-graph-003.svg
      :scale: 50 %


.. revealjs:: remotes -- Grundlagen
   :title-heading: h3

   Mit git_ können Remotes verfolgt werden (*track*).

   .. rst-class:: fragment roll-in
   
      `remote Branches`_ (u. Tags) werden in das lokale Repository geklont.

      Arbeiten mit remote Branches ist analog den lokalen Branches.

      Es sind nur wenige zusätzliche Komandos erforderlich.

      .. rv_code::
         :class: shell

         $ git clone  ..
         $ git remote ..
         $ git fetch  ..
         $ git pull   ..
         $ git push   ..

 
.. revealjs:: remotes -- git clone
   :title-heading: h3

   Meist beginnt es mit dem ersten Klonen `git clone`_

   .. rst-class:: fragment roll-in

      .. rv_code::
         :class: shell

         $git clone https://github.com/return42/git-teaching.git

      .. rv_code::
         :class: shell

         Klone nach 'git-teaching' ...
         remote: Counting objects: 18, done.
         remote: Compressing objects: 100% (12/12), done.
         remote: Total 18 (delta 4), reused 18 (delta 4), pack-reused 0
         Entpacke Objekte: 100% (18/18), Fertig.
         Prüfe Konnektivität ... Fertig.

      was hat ``git clone`` alles gemacht?
      
.. revealjs:: remotes -- Grundlagen
   :title-heading: h3

   .. rv_code::
      :class: shell

      $ tree -L 1 -at git-teaching/
      git-teaching/           # working tree
         ├── .git             # repository
         ├── .gitignore       
         ├── hello-world.py
         └── README.txt

   - Repo wurde nach ``./git-teaching/.git`` geklont und 
   - es wurde der Working-Tree ``git-teaching`` ausgecheckt

.. revealjs:: remotes -- Grundlagen
   :title-heading: h3

   .. rv_code::
      :class: shell

      $ git branch -vva
      * master                f5f3b62 [origin/master] merge hello-world
        remotes/origin/HEAD   -> origin/master
        remotes/origin/master f5f3b62 merge hello-world branch

   - lokaler Branch ``master`` wurde angelegt, er ist
   - ein Klon des Remote Branch ``origin/master``
   - der lokale ``master`` folgt (tracking) dem ``[origin/master]``

   .. rv_code::
      :class: shell

      $ git status
      Auf Branch master
      Ihr Branch ist auf dem selben Stand wie 'origin/master'.
      nichts zu committen, Arbeitsverzeichnis unverändert

.. revealjs:: remotes -- Grundlagen
   :title-heading: h3

   Der Alias-Name für das Original der Klon-Kopie ist ``origin``

   .. rv_code::
      :class: shell

      $ git remote -v
      origin    https://github.com/return42/git-teaching.git (fetch)
      origin    https://github.com/return42/git-teaching.git (push)

   Die URL des ``origin`` ist https://github.com/return42/git-teaching.git

   Sie wird zum *hochladen* (``push``) und zum *runterladen* (``fetch``)
   verwendet.

.. revealjs:: remotes -- Grundlagen
   :title-heading: h3

   Zuvor Beschriebenes ist kompakt in der ``.git/config`` zu finden, die ``git
   clone`` automatisch angelegt hat.

   .. rv_code::
      :class: shell

      $ cat .git/config 
      [core]
              repositoryformatversion = 0
              filemode = true
              bare = false
              logallrefupdates = true
      [remote "origin"]
              url = https://github.com/return42/git-teaching.git
              fetch = +refs/heads/*:refs/remotes/origin/*
      [branch "master"]
              remote = origin
              merge = refs/heads/master


.. revealjs:: remotes -- git push
   :title-heading: h3

   .. rv_code::
      :class: shell

      $ git status
      Auf Branch master
      Ihr Branch ist vor 'origin/master' um 1 Commit.
      (benutzen Sie "git push", um lokale Commits zu publizieren)

   Änderungen müssen im lokalem Repository *commited* werden.

   .. rv_code::
      :class: shell

      $ git push origin master:master

   `git push`_: Alias ``origin`` wählt den Remote. Die *refspec*
   ``master:master`` gibt an, dass der lokale ``master`` (links) auf den Remote
   ``master`` (rechts) *gepusht* werden soll. Einfacher:

   .. rv_code::

      $ git push
   
.. revealjs:: remotes -- git fetch & pull
   :title-heading: h3

   Mit `git fetch`_ werden die remote Branches aktualisiert.

   .. rv_code::
      :class: shell

      $ git fetch -v origin master
      Von https://github.com/return42/git-teaching
      * branch            master     -> FETCH_HEAD
      = [aktuell]         master     -> origin/master

   Der Remote ist wieder ``origin``. Die *refspec* ``master`` gibt an,
   dass der Fetch vom remote ``master`` erfolgt.

   Mit `git pull`_ kann man in einem Schritt *fetchen* und den ``FETCH_HEAD``
   gleich in den aktullen (lokalen) Branch *mergen*:

   .. rv_code::
      :class: shell

      $ git pull
   
.. revealjs:: remotes -- git remote
   :title-heading: h3

   Mit `git remote`_ werden die Remotes verwaltet.

   Alias ``origin`` in ``upstream`` umbenennen

   .. rv_code::
      :class: shell

      $ git remote rename origin upstream

   Einbinden eines Forks als ``origin``

   .. rv_code::
      :class: shell

      $ git remote add origin https://githost.intranet/git-teaching.git
   
.. revealjs:: remotes -- git remote
   :title-heading: h3

   Anzeigen der eingetragenen Remotes

   .. rv_code::
      :class: shell

      $ git remote -v 
      origin    https://githost.intranet/git-teaching.git (fetch)
      origin    https://githost.intranet/git-teaching.git (push)
      upstream  https://github.com/return42/git-teaching.git (fetch)
      upstream  https://github.com/return42/git-teaching.git (push)

   Es können beliebig viele Remotes eingebunden werden, über den Alias kann man
   steuern mit welchem Remote man was machen will.

   .. rv_small::

      Obiges Beispiel ist typisch für ein Szenario bei dem der Fork eines
      Projekts im Intranet ``origin`` liegt und das Original des Forks im
      Internet ``upstream`` liegt.  Mit ``git push origin`` können die lokalen
      Branches im Intranet abgelegt werden. Mit ``git push upstream`` können die
      Branches im Internet public gestellt werden.
   
.. revealjs:: online server
   :title-heading: h3

   .. image:: github-octocat.png
      :scale: 19 %
      :target: https://github.com
      
   .. image:: gitlab-logo.png
      :scale: 6 %
      :target: https://about.gitlab.com

   .. image:: bitbucket-logo.png
      :scale: 40 %
      :target: https://bitbucket.org/account/signup

   .. raw:: html

      <p></p>

   `GitLab.com`_  -- GitHub_  -- Bitbucket_


.. revealjs:: self hosted
   :title-heading: h3

   .. image:: gogs-logo.jpg
      :scale: 53 %
      :target: https://gogs.io

   .. image:: gitlab-logo.png
      :scale: 8 %
      :target: https://about.gitlab.com

   .. raw:: html

      <p></p>

   gogs_ *leichtgewicht* -- `GitLab CE`_ *Team & CI*


.. _git-format-git-am:

.. revealjs:: offline Szenarien 

   Patches mit `git format-patch`_ und `git am`_ transportieren.
              
   .. rv_code::
      :class: shell

      host_a$ git format-patch 9af1a51..hello-world \
                  -M -C --output-directory=patches

   .. rv_small::

      Patches von Commit ``9af1a51`` an (Abzweig ``hello-world`` / s.a.
      :ref:`git-graph <git-graph>`), bis zum aktuellen Stand des ``hello-world``
      Branch werden im Ordner ``./patches`` angelegt.

   .. rv_code::
      :class: shell

      host_b$ git checkout master
      host_b$ git am --keep-cr ./patches/*

   .. rv_small::

      Merge der Patches aus Ordner ``./patches`` in den ``master``.  Schalter
      ``--keep-cr`` erhält die CR (`erforderlich bei Windows
      <https://serverfault.com/a/197574>`_). Bei Konflikten muss man diese
      auflösen (wie bereits bei `git-merge <git-merge-hello-world>`_
      erläutert). Manchmal kann auch der Schalter ``--reject`` `hilfreich sein
      <https://git-scm.com/docs/git-apply#git-apply---reject>`_.

.. revealjs:: Danke

.. revealjs::

.. revealjs:: Verweise
   :title-heading: h5

   - git_
   - `Pro Git`_
   - `sphinxjp.themes.revealjs`_
   - `REVEAL.JS`_
   - Sphinx-doc_
   - reST_
   - docutils_
