#!/usr/bin/env python3

"""
Radicale WSGI file (mod_wsgi and uWSGI compliant).
"""

import logging.config
logging.config.fileConfig('/etc/radicale/logging', disable_existing_loggers=False)

from radicale import application
