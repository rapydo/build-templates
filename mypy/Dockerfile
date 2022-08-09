FROM python:3.10.6-alpine3.16

ARG RAPYDO_VERSION
RUN test -n "$RAPYDO_VERSION"

RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache git build-base gcc linux-headers musl-dev libffi-dev openssl-dev geos-dev

RUN pip3 install --no-cache-dir mypy lxml html5lib types-requests types-urllib3 types-python-dateutil types-pytz types-PyYAML pika-stubs celery-types sqlalchemy-stubs git+https://github.com/rapydo/http-api.git@$RAPYDO_VERSION

RUN mypy --version

# Super hack trick!! Since the default command for run --debug is bash
# and bash is not in alpine, let's abuse it to to be used as wrapper for mypy
COPY --chmod=740 run_mypy.sh /usr/local/bin/bash
