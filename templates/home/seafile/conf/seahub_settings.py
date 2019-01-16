# -*- coding: utf-8 -*-

# Security settings
# =================

SECRET_KEY = "${SEAHUB_SECRET_KEY}"

# For security consideration, please set to match the host/domain of your site, e.g., ALLOWED_HOSTS = ['.example.com'].
# Please refer https://docs.djangoproject.com/en/dev/ref/settings/#allowed-hosts for details.
# ALLOWED_HOSTS = ['.myseafile.com']

# User management options
# =======================

# Enalbe or disalbe registration on web. Default is `False`.
ENABLE_SIGNUP = False

# Activate or deactivate user when registration complete. Default is `True`.
# If set to `False`, new users need to be activated by admin in admin panel.
ACTIVATE_AFTER_REGISTRATION = False

# Whether to send email when a system admin adding a new member. Default is `True`.
SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER = ${SEAFILE_SEND_MAILS}

# Whether to send email when a system admin resetting a user's password. Default is `True`.
SEND_EMAIL_ON_RESETTING_USER_PASSWD = ${SEAFILE_SEND_MAILS}

# Send system admin notify email when user registration is complete. Default is `False`.
NOTIFY_ADMIN_AFTER_REGISTRATION = ${SEAFILE_SEND_MAILS}

# Remember days for login. Default is 7
LOGIN_REMEMBER_DAYS = 7

# Attempt limit before showing a captcha when login.
LOGIN_ATTEMPT_LIMIT = 3

# deactivate user account when login attempts exceed limit
# Since version 5.1.2 or pro 5.1.3
FREEZE_USER_ON_LOGIN_FAILED = False

# mininum length for user's password
USER_PASSWORD_MIN_LENGTH = 6

# LEVEL based on four types of input:
# num, upper letter, lower letter, other symbols
# '3' means password must have at least 3 types of the above.
USER_PASSWORD_STRENGTH_LEVEL = 3

# default False, only check USER_PASSWORD_MIN_LENGTH
# when True, check password strength level, STRONG(or above) is allowed
USER_STRONG_PASSWORD_REQUIRED = False

# Force user to change password when admin add/reset a user.
# Added in 5.1.1, deafults to True.
FORCE_PASSWORD_CHANGE = True

# Age of cookie, in seconds (default: 2 weeks).
SESSION_COOKIE_AGE = 60 * 60 * 24 * 7 * 2

# Whether a user's session cookie expires when the Web browser is closed.
SESSION_EXPIRE_AT_BROWSER_CLOSE = False

# Whether to save the session data on every request. Default is `False`
SESSION_SAVE_EVERY_REQUEST = False

# Whether enable personal wiki and group wiki. Default is `False`
# Since 6.1.0 CE
ENABLE_WIKI = True

# In old version, if you use Single Sign On, the password is not saved in Seafile.
# Users can't use WebDAV because Seafile can't check whether the password is correct.
# Since version 6.3.8, you can enable this option to let user's to specific a password for WebDAV login.
# Users login via SSO can use this password to login in WebDAV.
# Enable the feature. pycryptodome should be installed first.
# sudo pip install pycryptodome==3.7.2
# ENABLE_WEBDAV_SECRET = True

# repo snapshot label feature
# ===========================

# Turn on this option to let users to add a label to a library snapshot. Default is `False`
ENABLE_REPO_SNAPSHOT_LABEL = False

# Library options
# ===============

# Options for libraries
# ---------------------

# mininum length for password of encrypted library
REPO_PASSWORD_MIN_LENGTH = 8

# mininum length for password for share link (since version 4.4)
SHARE_LINK_PASSWORD_MIN_LENGTH = 8

# minimum expire days for share link (since version 6.3.6)
SHARE_LINK_EXPIRE_DAYS_MIN = 3 # default is 0, no limit.

# maximum expire days for share link (since version 6.3.6)
SHARE_LINK_EXPIRE_DAYS_MAX = 8 # default is 0, no limit.

# default expire days for share link (since version 6.3.8)
# only valid when SHARE_LINK_EXPIRE_DAYS_MIN and SHARE_LINK_EXPIRE_DAYS_MAX is configured
# should be greater than or equal to MIN and less than or equal to MAX
SHARE_LINK_EXPIRE_DAYS_DEFAULT = 5

# force user login when view file/folder share link (since version 6.3.6)
SHARE_LINK_LOGIN_REQUIRED = True

# enable water mark when view(not edit) file in web browser (since version 6.3.6)
ENABLE_WATERMARK = True

# Disable sync with any folder. Default is `False`
# NOTE: since version 4.2.4
DISABLE_SYNC_WITH_ANY_FOLDER = True

# Enable or disable library history setting
ENABLE_REPO_HISTORY_SETTING = True

# Enable or disable normal user to create organization libraries
# Since version 5.0.5
ENABLE_USER_CREATE_ORG_REPO = True

# Enable or disable user share library to any group
# Since version 6.2.0
ENABLE_SHARE_TO_ALL_GROUPS = True

# Enable or disable user to clean trash (default is True)
# Since version 6.3.6
ENABLE_USER_CLEAN_TRASH = True

# Options for online file preview
# -------------------------------

# Whether to use pdf.js to view pdf files online. Default is `True`,  you can turn it off.
# NOTE: since version 1.4.
USE_PDFJS = True

# Online preview maximum file size, defaults to 30M.
FILE_PREVIEW_MAX_SIZE = 30 * 1024 * 1024

# Extensions of previewed text files.
# NOTE: since version 6.1.1
TEXT_PREVIEW_EXT = """ac, am, bat, c, cc, cmake, cpp, cs, css, diff, el, h, html,
htm, java, js, json, less, make, org, php, pl, properties, py, rb,
scala, script, sh, sql, txt, text, tex, vi, vim, xhtml, xml, log, csv,
groovy, rst, patch, go"""

# Enable or disable thumbnails
# NOTE: since version 4.0.2
ENABLE_THUMBNAIL = True

# Seafile only generates thumbnails for images smaller than the following size.
# Since version 6.3.8 pro, suport the psd online preview.
THUMBNAIL_IMAGE_SIZE_LIMIT = 30 # MB

# Enable or disable thumbnail for video. ffmpeg and moviepy should be installed first.
# For details, please refer to https://manual.seafile.com/deploy/video_thumbnails.html
# NOTE: since version 6.1
ENABLE_VIDEO_THUMBNAIL = False

# Use the frame at 5 second as thumbnail
THUMBNAIL_VIDEO_FRAME_TIME = 5

# Absolute filesystem path to the directory that will hold thumbnail files.
THUMBNAIL_ROOT = '${SEAFILE_HOME}/seahub-data/thumbnail/thumb/'

# Default size for picture preview. Enlarge this size can improve the preview quality.
# NOTE: since version 6.1.1
THUMBNAIL_SIZE_FOR_ORIGINAL = 1024

# Cloud Mode
# ==========

# Enable cloude mode and hide `Organization` tab.
# CLOUD_MODE = True

# Disable global address book
# ENABLE_GLOBAL_ADDRESSBOOK = False

# External authentication
# =======================

# Enable authentication with ADFS
# Default is False
# Since 6.0.9
# ENABLE_ADFS_LOGIN = True

# Enable authentication wit Kerberos
# Default is False
# ENABLE_KRB5_LOGIN = True

# Enable authentication with Shibboleth
# Default is False
# ENABLE_SHIBBOLETH_LOGIN = True


# Other options
# =============

# Disable settings via Web interface in system admin->settings
# Default is True
# Since 5.1.3
ENABLE_SETTINGS_VIA_WEB = True

# Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# If running in a Windows environment this must be set to the same as your
# system time zone.
TIME_ZONE = '${SEAFILE_TIME_ZONE}'

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
# Default language for sending emails.
LANGUAGE_CODE = 'en'

# Custom language code choice.
LANGUAGES = (
    ('en', 'English'),
    ('de-DE', 'Deutsch')
    # ('zh-cn', '简体中文'),
    # ('zh-tw', '繁體中文'),
)

# Set this to your website/company's name. This is contained in email
# notifications and welcome message when user login for the first time.
SITE_NAME = '${ORGANIZATION}'

# Browser tab's title
SITE_TITLE = 'Private Seafile'

# If you don't want to run seahub website on your site's root path, set this
# option to your preferred path.  e.g. setting it to '/seahub/' would run seahub
# on http://example.com/seahub/.

SITE_ROOT = '${SEAFILE_APACHE_URL}'
HTTP_SERVER_ROOT = 'https://${SEAFILE_SERVER_NAME}${SEAFILE_APACHE_URL}'
FILE_SERVER_ROOT = 'https://${SEAFILE_SERVER_NAME}${SEAFILE_APACHE_URL}/seafhttp'

# Max number of files when user upload file/folder.
# Since version 6.0.4
MAX_NUMBER_OF_FILES_FOR_FILEUPLOAD = 500

# Control the language that send email. Default to user's current language.
# Since version 6.1.1
SHARE_LINK_EMAIL_LANGUAGE = ''

# Interval for browser requests unread notifications
# Since PRO 6.1.4 or CE 6.1.2
UNREAD_NOTIFICATIONS_REQUEST_INTERVAL = 3 * 60 # seconds

# Whether to allow user to delete account, change login password or update basic user
# info on profile page.
# Since PRO 6.3.10
ENABLE_DELETE_ACCOUNT = False
ENABLE_UPDATE_USER_INFO = False
ENABLE_CHANGE_PASSWORD = False

# RESTful API
# ===========

# API throttling related settings. Enlarger the rates if you got 429 response code during API calls.
# REST_FRAMEWORK = {
#     'DEFAULT_THROTTLE_RATES': {
#         'ping': '600/minute',
#         'anon': '5/minute',
#         'user': '300/minute',
#     },
#     'UNICODE_JSON': False,
# }

# Throtting whitelist used to disable throttle for certain IPs.
# e.g. REST_FRAMEWORK_THROTTING_WHITELIST = ['127.0.0.1', '192.168.1.1']
# Please make sure `REMOTE_ADDR` header is configured in Nginx conf according to https://manual.seafile.com/deploy/deploy_with_nginx.html.
REST_FRAMEWORK_THROTTING_WHITELIST = []
