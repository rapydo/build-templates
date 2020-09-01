FROM ubuntu:18.04
# ubuntu LTS
# TODO: check if alpine is the way?
# switching make better use of UWSGI: http://j.mp/2rxvp3r
LABEL maintainer="Paolo D'Onorio De Meo"

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

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
    bash less vim curl wget telnet iputils-ping file git jq software-properties-common build-essential nginx gosu \
    python${MYPYTHON_VERSION} \
    python${MYPYTHON_VERSION}-dev \
    python${MYPYTHON_VERSION}-gdbm \
    python3-setuptools python3-pip python3-distutils \
    && ln -sf /usr/bin/python${MYPYTHON_VERSION} /usr/bin/python && ln -sf /usr/bin/python${MYPYTHON_VERSION} /usr/bin/python3 \
    && apt-get autoremove --yes && apt-get clean && rm -rf /var/lib/apt/lists/* \
    # Fix to make add-apt-repository work on python 3.8
    && sed -i 's\#!/usr/bin/python3\#!/usr/bin/python3.6\' /usr/bin/add-apt-repository

###################
# # DEBUG CONFLICTS:
# RUN pip3 install pip-conflict-checker && pipconflictchecker

RUN pip3 install --upgrade --no-cache-dir dumb-init==1.2.2 uwsgitop==0.11 git+https://github.com/rapydo/http-api.git@$RAPYDO_VERSION

ENV APIUSER developer

ENV APIUID $CURRENT_UID
RUN useradd \
    -r -M -d /home/$APIUSER -s /bin/bash -p ! \
    --uid $APIUID $APIUSER \
    && groupmod -og $CURRENT_GID $APIUSER \
    && mkdir -p /home/$APIUSER \
    && chown $APIUID:$CURRENT_GID /home/$APIUSER

###################
# UWSGI
ENV UWSGI_LOGS /var/log/uwsgi
ENV UWSGI_RUN /var/run/uwsgi
ENV MYUWSGI_HOME /tmp/uwsgi
RUN mkdir -p $UWSGI_LOGS $UWSGI_RUN
RUN chown -R www-data:www-data $UWSGI_LOGS $UWSGI_RUN

ENV UWSGI_MASTER ${MYUWSGI_HOME}/uwsgi_starter.ini
COPY uwsgi.ini ${UWSGI_MASTER}
COPY launch_uwsgi.sh /usr/local/bin/myuwsgi
COPY flask_migrate /usr/local/bin/flask_migrate 
RUN chmod +x /usr/local/bin/myuwsgi /usr/local/bin/flask_migrate

COPY nginx_base.conf /etc/nginx/nginx.conf
COPY nginx_uwsgi.conf /etc/nginx/sites-available/default

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

RUN mkdir $CODE_DIR /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./docker-entrypoint-celery.sh /usr/local/bin/docker-entrypoint-celery

WORKDIR $CODE_DIR
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["docker-entrypoint", "rest"]

# TODO: verify if better using tini for entrypoint
# https://github.com/krallin/tini-images
