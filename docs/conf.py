# -*- coding: utf-8 -*-
#
# Sphinx documentation build configuration file

import os, sys

from pallets_sphinx_themes import ProjectLink

sys.path.append(os.path.abspath('../utils/site-python'))
from sphinx_build_tools import load_sphinx_config


project   = u'handsOn'
copyright = u'2019 Markus Heiser'
show_authors = True

language  = 'de'
author    = u'Markus Heiser'

source_suffix       = '.rst'
show_authors        = True
master_doc          = 'index'
templates_path      = ['_templates']
exclude_patterns    = ['_build', 'slides']
todo_include_todos  = True
# pygments_style = 'sphinx'

extensions = [
    'sphinx.ext.imgmath'
    , 'sphinx.ext.autodoc'
    , 'sphinx.ext.extlinks'
    #, 'sphinx.ext.autosummary'
    #, 'sphinx.ext.doctest'
    , 'sphinx.ext.todo'
    , 'sphinx.ext.coverage'
    #, 'sphinx.ext.pngmath'
    #, 'sphinx.ext.mathjax'
    , 'sphinx.ext.viewcode'
    , 'sphinx.ext.intersphinx'
    , 'linuxdoc.rstFlatTable'    # Implementation of the 'flat-table' reST-directive.
    , 'linuxdoc.rstKernelDoc'    # Implementation of the 'kernel-doc' reST-directive.
    , 'linuxdoc.kernel_include'  # Implementation of the 'kernel-include' reST-directive.
    , 'linuxdoc.manKernelDoc'    # Implementation of the 'kernel-doc-man' builder
    , 'linuxdoc.cdomain'         # Replacement for the sphinx c-domain.
    , 'linuxdoc.kfigure'         # Sphinx extension which implements scalable image handling.
    , 'sphinx_tabs.tabs'         # https://github.com/djungelorm/sphinx-tabs
    , 'pallets_sphinx_themes'
    , 'sphinxcontrib.programoutput'  # https://github.com/NextThought/sphinxcontrib-programoutput
]

intersphinx_mapping = {}
# usage:    :ref:`comparison manual <python:comparisons>`
intersphinx_mapping['python']  = ('https://docs.python.org/', None)

extlinks = {}
# usage:    :man:`make`
extlinks['man']       = ('http://manpages.ubuntu.com/cgi-bin/search.py?q=%s', '')
#extlinks['man']      = ('http://manpages.ubuntu.com/manpages/' + language + '/%s.html', '')
extlinks['deb']       = ('http://packages.ubuntu.com/%s', '')
#extlinks['rfc']      = ('https://tools.ietf.org/html/rfc%s', 'RFC ')
extlinks['launchpad'] = ('https://launchpad.net/%s/trunk', 'launchpad')
extlinks['origin']    = ('https://github.com/return42/handsOn/blob/master/%s', 'git')
extlinks['commit']    = ('https://github.com/return42/handsOn/commit/%s', '#')
extlinks['apache_mod']  = ('https://httpd.apache.org/docs/current/mod/%s.html', 'Apache ')


html_search_language = 'de'

sys.path.append(os.path.abspath('_themes'))
html_theme           = "custom"
html_logo            = 'darmarIT_logo_128.png'
html_theme_path      = ['_themes']

html_theme_options = {"index_sidebar_logo": True}
# html_context = {
#     "project_links": [
#         ProjectLink("Slide Collection", DOC_URL + '/slides/index.html'),
#         ProjectLink("API", DOC_URL+ '/xxxx-api/xxxx.html'),
#     ]
# }
