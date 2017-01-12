#!/usr/bin/env python
# -*- coding: utf-8; mode: python -*-

#activate_this = '/opt/wwwPython/2.6/bin/activate_this.py'
#execfile(activate_this, dict(__file__=activate_this))

import os, sys, traceback, pprint, pwd

import six
from six.moves.urllib import parse as urllib_parse

def application(environ, start_response):

    status = '200 OK'
    o = 'WSGI: It works!  :-)'
    try:
        o += '\n\n============================================================\n'
        o += '\nprocess id:        '   + str(os.getpid())
        o += '\nparent process:    '   + str(os.getppid())
        o += '\nuser/group:        '   + "%s/%s (%s/%s)" % (os.getuid(), os.getgid(), os.geteuid(), os.getegid())
        o += '\npwd user:          '   + pprint.pformat(pwd.getpwuid(os.getuid()))
        o += '\n\n============================================================\n'
        o += '\nWSGI environment:\n' + pprint.pformat(environ, indent=4)
        o += '\n\n============================================================\n'
        o += '\nQuery String:\n'     + pprint.pformat(urllib_parse.parse_qs(environ['QUERY_STRING']), indent=4)
        o += '\n\n============================================================\n'
        o += '\nPython version:    '   + pprint.pformat(sys.version)
        o += '\nProfiler:          '   + str(sys.getprofile())
        o += '\ndefault encoding:  '   + pprint.pformat(sys.getdefaultencoding())
        o += '\nfilename encoding: '   + pprint.pformat(sys.getfilesystemencoding())
        o += '\nsys.argv:          '   + pprint.pformat(sys.argv)
        o += '\nsys.prefix:        '   + pprint.pformat(sys.prefix)
        o += '\nsys.exec_prefix:   '   + pprint.pformat(sys.exec_prefix)

        _flags = {}
        for x in ['bytes_warning', 'debug', 'division_new', 'division_warning',
                  'dont_write_bytecode', 'hash_randomization',
                  'ignore_environment', 'inspect', 'interactive', 'n_fields',
                  'n_sequence_fields', 'n_unnamed_fields', 'no_site',
                  'no_user_site', 'optimize', 'py3k_warning', 'tabcheck',
                  'unicode', 'verbose' ]:
            _flags[x] = getattr(sys.flags, x, "---")
        o += '\nsys.flags:\n'   + pprint.pformat(_flags, indent=4)

        o += '\n\n============================================================\n'
        o += '\n\nenvironment:\n'      + pprint.pformat(dict(os.environ), indent=4)
        o += '\n\nimport path:\n'      + pprint.pformat(sys.path, indent=4)
        o += '\n\nbuiltins:\n'         + pprint.pformat(sys.builtin_module_names, indent=4)
        o += '\n\nsys.modules:\n'      + pprint.pformat(sys.modules, indent=4)

    except:
        o += "\n\n" + traceback.format_exc()

    o = six.binary_type(o, 'utf-8')
    response_headers = [
        ( 'Content-type', 'text/plain')
        , ( 'Content-Length', str(len(o)))
    ]

    start_response(status, response_headers)
    return [o]
