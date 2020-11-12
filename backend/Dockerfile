FROM ubuntu:20.04

ARG RAPYDO_VERSION
RUN test -n "$RAPYDO_VERSION"
ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

ENV MYPYTHON_VERSION 3.8
ENV TERM=xterm-256color
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

## preesed tzdata, update package index, upgrade packages and install needed software
RUN echo "tzdata tzdata/Areas select Etc" > /tmp/preseed.txt; \
    echo "tzdata tzdata/Zones/Europe select UTC" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
    tzdata bash less vim curl wget telnet iputils-ping sysstat file git build-essential gosu cron \
    python${MYPYTHON_VERSION} \
    python${MYPYTHON_VERSION}-dev \
    python${MYPYTHON_VERSION}-gdbm \
    python3-setuptools python3-distutils \
    python3-pip \
    && pip3 install --upgrade --no-cache-dir pip==20.2.4 \
    && apt-get remove -y python3-pip \
    && apt-get autoremove --yes && apt-get clean && rm -rf /var/lib/apt/lists/*

# Note: remove --use-feature=2020-resolver once upgraded to pip 20.3

RUN pip3 install --upgrade --no-cache-dir --use-feature=2020-resolver dumb-init==1.2.2 meinheld==1.0.2 gunicorn==20.0.4 git+https://github.com/rapydo/http-api.git@$RAPYDO_VERSION

ENV APIUSER developer

RUN useradd \
    -r -M -d /home/$APIUSER -s /bin/bash -p ! \
    --uid $CURRENT_UID $APIUSER \
    && groupmod -og $CURRENT_GID $APIUSER \
    && mkdir -p /home/$APIUSER \
    && chown $CURRENT_UID:$CURRENT_GID /home/$APIUSER

# GUNICORN
ENV GUNICORN_CONF /tmp/gunicorn_conf.py
COPY gunicorn_conf.py ${GUNICORN_CONF}
COPY launch_gunicorn.sh /usr/local/bin/mygunicorn

# UTILITIES
COPY flask_migrate /usr/local/bin/flask_migrate

RUN chmod +x /usr/local/bin/mygunicorn /usr/local/bin/flask_migrate

# variables
ENV PAGER less
ENV PYTHONIOENCODING="utf-8"
ENV FLASK_PORT 8080
ENV JWT_APP_SECRETS /jwts
ENV CODE_DIR /code
ENV CERTDIR /opt/certificates
ENV PYTHONPATH $CODE_DIR

EXPOSE $FLASK_PORT

#### Make the terminal prettier ####
# generated with http://bashrcgenerator.com/
RUN echo 'export PS1="\\[\\033[38;5;11m\\]\\u\\[$(tput sgr0)\\]\\[\\033[38;5;15m\\]@\\h:\\[$(tput sgr0)\\]\\[\\033[38;5;6m\\][\\w]:\\[$(tput sgr0)\\]\\[\\033[38;5;15m\\] \\[$(tput sgr0)\\]"' >> /etc/bash.bashrc

# closing entrypoint

# RUN mkdir $CODE_DIR /docker-entrypoint.d/
RUN mkdir $CODE_DIR
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./docker-entrypoint-celery.sh /usr/local/bin/docker-entrypoint-celery
COPY ./docker-entrypoint-bot.sh /usr/local/bin/docker-entrypoint-bot

WORKDIR $CODE_DIR
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["docker-entrypoint", "rest"]
