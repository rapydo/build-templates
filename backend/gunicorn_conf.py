# -*- coding: utf-8 -*-

# Special thanks to https://github.com/tiangolo/meinheld-gunicorn-docker
import multiprocessing
import os

bind_env = os.getenv("BIND", None)
if bind_env:
    use_bind = bind_env
else:
    host = os.getenv("HOST", "0.0.0.0")
    port = os.getenv("PORT", "8080")
    use_bind = "{host}:{port}".format(host=host, port=port)

gunicorn_workers = os.getenv("GUNICORN_WORKERS", None)
if gunicorn_workers:
    gunicorn_workers = int(gunicorn_workers)
else:
    workers_per_core = float(os.getenv("GUNICORN_WORKERS_PER_CORE", "1"))
    cores = multiprocessing.cpu_count()
    gunicorn_workers = int(workers_per_core * cores)

assert gunicorn_workers > 0

# Gunicorn config variables
loglevel = os.getenv("LOG_LEVEL", "info")
workers = gunicorn_workers
bind = use_bind
keepalive = 120
errorlog = "-"
