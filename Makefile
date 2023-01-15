# -*- coding: utf-8; mode: makefile-gmake -*-

include utils/makefile.include
include utils/makefile.python
include utils/makefile.sphinx

GIT_URL   = git@github.com:return42/handsOn.git
SLIDES    = docs/slides

all: clean pylint pytest build docs

PHONY += help
help:
	@echo  '  docs	    - build documentation'
	@echo  '  docs-live - autobuild HTML documentation while editing'
	@echo  '  clean	    - remove most generated files'
	@echo  '  rqmts	    - info about build requirements'
	@echo  ''
	@$(MAKE) -s -f utils/makefile.include make-help
	@echo  ''
	@$(MAKE) -s -f utils/makefile.sphinx docs-help


PHONY += docs
docs:  pyenv slides
	$(call cmd,sphinx,html,$(DOCS_FOLDER),$(DOCS_FOLDER))

PHONY += docs-live
docs-live: pyenv
	$(call cmd,sphinx_autobuild,html,$(DOCS_FOLDER),$(DOCS_FOLDER))

PHONY += slides
slides: git-slide
	cd $(DOCS_DIST)/slides; zip -r git.zip git

PHONY += git-slide
git-slide: pyenvinstall
	$(call cmd,sphinx,html,$(SLIDES)/git,$(SLIDES)/git,slides/git)

PHONY += clean
clean: pyclean docs-clean
	$(call cmd,common_clean)

PHONY += deploy
deploy: docs-clean gh-pages

.PHONY: $(PHONY)
