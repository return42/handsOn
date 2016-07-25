# -*- coding: utf-8; mode: makefile-gmake -*-

include utils/makefile.include
include utils/makefile.sphinx

GIT_URL   = https://github.com/return42/handsOn.git
PYOBJECTS = linuxdoc

all: clean docs

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
docs:  sphinx-doc
	$(call cmd,sphinx,html,docs,docs)

PHONY += clean
clean: docs-clean
	$(call cmd,common_clean)

PHONY += help-rqmts
rqmts: msg-sphinx-doc

.PHONY: $(PHONY)

