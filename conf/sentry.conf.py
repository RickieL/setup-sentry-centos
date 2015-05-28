from sentry.conf.server import *
import os.path
CONF_ROOT = os.path.dirname(__file__)
DATABASES = {
    'default': {
        # You can swap out the engine for MySQL easily by changing this value
        # to ``django.db.backends.mysql`` or to PostgreSQL with
        # ``django.db.backends.postgresql_psycopg2``
        # If you change this, you'll also need to install the appropriate python
        # package: psycopg2 (Postgres) or mysql-python
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'sentry',
        'USER': 'sentry',
        'PASSWORD': 'sentry',
        'HOST': '',
        'PORT': '',
    }
}
SENTRY_USE_BIG_INTS = True
SENTRY_ADMIN_EMAIL = 'liaoyongfu@e.hunantv.com'
SENTRY_REDIS_OPTIONS = {
    'hosts': {
        0: {
            'host': '127.0.0.1',
            'port': 6379,
            'timeout': 3,
        }
    }
}
SENTRY_CACHE = 'sentry.cache.redis.RedisCache'
CELERY_ALWAYS_EAGER = False
BROKER_URL = 'redis://localhost:6379'
SENTRY_RATELIMITER = 'sentry.ratelimits.redis.RedisRateLimiter'
SENTRY_BUFFER = 'sentry.buffer.redis.RedisBuffer'
SENTRY_QUOTAS = 'sentry.quotas.redis.RedisQuota'
SENTRY_TSDB = 'sentry.tsdb.redis.RedisTSDB'
SENTRY_FILESTORE = 'django.core.files.storage.FileSystemStorage'
SENTRY_FILESTORE_OPTIONS = {
    'location': '/tmp/sentry-files',
}
SENTRY_URL_PREFIX = 'http://192.168.198.11:9000'  # No trailing slash!
SENTRY_WEB_HOST = '0.0.0.0'
SENTRY_WEB_PORT = 9000
SENTRY_WEB_OPTIONS = {
    # 'workers': 3,  # the number of gunicorn workers
    # 'secure_scheme_headers': {'X-FORWARDED-PROTO': 'https'},
}
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'xxxx.com'
EMAIL_HOST_PASSWORD = 'xxxx'
EMAIL_HOST_USER = 'xxx@xxxx.com'
EMAIL_PORT = 25
EMAIL_USE_TLS = False
EMAIL_SUBJECT_PREFIX = '[sentry]: '
SERVER_EMAIL = 'xxx@xxxx.com'
MAILGUN_API_KEY = ''
SECRET_KEY = 'p+7v4BKiUSbTNZlG20ipHPDLDjXlz61jVl0rL/SZOnWlQC9ZVUJDeg=='
