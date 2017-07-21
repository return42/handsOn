# -*- coding: utf-8 -*-
#
# Sphinx documentation build configuration file

import sys
import sphinx_rtd_theme


# General information about the project.
project = u'handsOn'
copyright = u'2017, Markus Heiser'
author = u'Markus Heiser'
# release = u'1'
show_authors = True

language = 'de'
html_search_language = 'de'

source_suffix = '.rst'

extlinks = {
    #'man' : ('http://manpages.ubuntu.com/manpages/' + language + '/%s.html', ' ')
    'man' : ('http://manpages.ubuntu.com/cgi-bin/search.py?q=%s', ' ')
    , 'deb' : ('http://packages.ubuntu.com/xenial/%s', ' ')
    # , 'rfc' : ('https://tools.ietf.org/html/rfc%s', 'RFC ')
    , 'launchpad' : ('https://launchpad.net/%s/trunk', 'launchpad')
    }

intersphinx_mapping = {}
# usage:    :ref:`comparison manual <python:comparisons>`
intersphinx_mapping['python']  = ('https://docs.python.org/', None)

master_doc = 'index'
templates_path = ['_templates']
exclude_patterns = ['_build', 'slides']

extensions = [
    'sphinx.ext.autodoc'
    , 'sphinx.ext.extlinks'
    #, 'sphinx.ext.autosummary'
    #, 'sphinx.ext.doctest'
    , 'sphinx.ext.todo'
    , 'sphinx.ext.coverage'
    #, 'sphinx.ext.pngmath'
    #, 'sphinx.ext.mathjax'
    , 'sphinx.ext.viewcode'
    , 'sphinx.ext.intersphinx'
]


# The name of the Pygments (syntax highlighting) style to use.
# pygments_style = 'sphinx'

# If true, `todo` and `todoList` produce output, else they produce nothing.
todo_include_todos = True

html_theme = "sphinx_rtd_theme"
html_theme_path = [sphinx_rtd_theme.get_html_theme_path()]
html_static_path = ["../utils/sphinx-static"]
html_context = {
    'css_files': [
        '_static/theme_overrides.css',
    ],
}
html_logo = 'darmarIT_logo_128.png'


