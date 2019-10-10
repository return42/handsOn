# -*- coding: utf-8; mode: makefile-gmake -*-

include utils/makefile.include
include utils/makefile.python
include utils/makefile.sphinx

GIT_URL   = https://github.com/return42/handsOn.git
SLIDES    = docs/slides
#PYOBJECTS = xxxx

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
docs: pyrequirements sphinx-doc
	$(call cmd,sphinx,html,docs,docs)

PHONY += docs-live
docs-live: pyrequirements sphinx-live
	$(call cmd,sphinx_autobuild,html,docs,docs)

PHONY += slides
slides: git-slide
	cd $(DOCS_DIST)/slides; zip -r git.zip git

PHONY += git-slide
git-slide: pyrequirements sphinx-doc
	$(call cmd,sphinx,html,$(SLIDES)/git,$(SLIDES)/git,slides/git)

PHONY += clean
clean: pyclean docs-clean
	$(call cmd,common_clean)

PHONY += pyrequirements
pyrequirements: $(PY_ENV)
	$(PY_ENV_BIN)/pip $(PIP_VERBOSE) install -r requirements.txt $(PY_SETUP_EXTRAS)

PHONY += rqmts
rqmts: msg-python-exe msg-virtualenv-exe

.PHONY: $(PHONY)
