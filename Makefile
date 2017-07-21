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
	@echo  '  docs	- build documentation'
	@echo  '  clean	- remove most generated files'
	@echo  '  rqmts	- info about build requirements'
	@echo  ''
	@$(MAKE) -s -f utils/makefile.include make-help
	@echo  ''
	@$(MAKE) -s -f utils/makefile.sphinx docs-help

PHONY += docs
docs:  sphinx-doc git-slide
	$(call cmd,sphinx,html,docs,docs)

PHONY += git-slide
git-slide:  sphinx-doc
	$(call cmd,sphinx,html,$(SLIDES)/git,$(SLIDES)/git,git-slide)

PHONY += clean
clean: pyclean docs-clean
	$(call cmd,common_clean)

PHONY += rqmts
rqmts: msg-python-exe msg-virtualenv-exe

.PHONY: $(PHONY)
