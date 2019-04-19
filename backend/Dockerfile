
###################
FROM ubuntu:18.04
# ubuntu LTS
# TODO: check if alpine is the way?
# switching make better use of UWSGI: http://j.mp/2rxvp3r
# FROM python:3.6-alpine # or https://revsys.com/tidbits/optimized-python/
# no 3.7 yet https://hub.docker.com/_/python/ 3.7.0b5
LABEL maintainer="Paolo D'Onorio De Meo"

###################
ARG RAPYDO_VERSION
RUN test -n "$RAPYDO_VERSION"
ARG CURRENT_UID
RUN test -n "$CURRENT_UID"

###################
# ENV MYPYTHON_VERSION 3.7
# NOTE 3.7.0b3 at 01/07/2018 is the latest, let's wait a bit
ENV MYPYTHON_VERSION 3.6
ENV TERM=xterm-256color
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
RUN apt-get update && apt-get install -y \
    bash less vim curl wget telnet git jq \
    build-essential nginx \
    python${MYPYTHON_VERSION} \
    python${MYPYTHON_VERSION}-dev \
    python${MYPYTHON_VERSION}-pip \
    python3-distutils \
    && cd /usr/bin && ln -s python${MYPYTHON_VERSION} python \
    && apt-get autoremove && apt-get clean \
    && echo "setup installed"

###################
COPY requirements.txt /tmp/
WORKDIR /tmp

# # DEBUG CONFLICTS:
# RUN pip install pip-conflict-checker && pipconflictchecker

RUN cat requirements.txt | xargs -n 1 -L 1 pip3 install --trusted-host pypi.python.org --upgrade --no-cache-dir

RUN pip3 install --upgrade --no-cache-dir git+https://github.com/rapydo/utils.git@$RAPYDO_VERSION
RUN pip3 install --upgrade --no-cache-dir git+https://github.com/rapydo/http-api.git@$RAPYDO_VERSION

###################
# # Adding gsi as gssapi available mechanism for PRC
# COPY gsi.conf /etc/gss/mech.d/
# main user for launching the apis
ENV APIUSER developer
# Emulating irods user creation. See http://j.mp/2lGPqlq

ENV APIUID $CURRENT_UID
RUN useradd \
    -r -M -d /home/$APIUSER -s /bin/bash -p ! \
    --uid $APIUID $APIUSER \
    && mkdir -p /home/$APIUSER && chown $APIUID /home/$APIUSER
# RUN useradd -r -M -d /home/$APIUSER -s /bin/bash -p ! $APIUSER
# RUN mkdir -p /home/$APIUSER && chown $APIUSER:$APIUSER /home/$APIUSER

###################
# UWSGI
ENV UWSGI_LOGS /var/log/uwsgi
ENV UWSGI_RUN /var/run/uwsgi
ENV MYUWSGI_HOME /tmp/uwsgi
RUN mkdir -p $UWSGI_LOGS
RUN mkdir -p $UWSGI_RUN
RUN chown -R www-data:www-data $UWSGI_LOGS $UWSGI_RUN

ENV UWSGI_MASTER ${MYUWSGI_HOME}/uwsgi_starter.ini
COPY uwsgi.ini ${UWSGI_MASTER}
COPY launch_uwsgi.sh /usr/local/bin/myuwsgi
RUN chmod +x /usr/local/bin/myuwsgi

# # remove nginx defaults
# RUN rm -rf /etc/nginx/sites-enabled
COPY nginx_base.conf /etc/nginx/nginx.conf
COPY nginx_uwsgi.conf /etc/nginx/sites-available/default

COPY sleep.py /usr/local/bin/pysleeper
COPY tests.sh /usr/local/bin/pyunittests

###################
# variables
ENV PAGER less
ENV PYTHONIOENCODING="utf-8"
ENV FLASK_PORT 5000
ENV JWT_APP_SECRETS /jwts
ENV CODE_DIR /code
ENV CERTDIR /opt/certificates
ENV PYTHONPATH $CODE_DIR
EXPOSE $FLASK_PORT

######################
ENV DEV_SU "HOME=$CODE_DIR su -p \$APIUSER"
RUN echo "alias dev='$DEV_SU'" >> /root/.bash_aliases
RUN echo "Entrylevel" && \
    echo "echo\necho \"Warning: you are now the admin user.\nBecome the '\$APIUSER' user instead with the command:\n# dev\n\n\"" >> /root/.bashrc

###### BACKEND COMMANDS
ENV APIRC /home/$APIUSER/.bashrc
ENV FLASK_CMD "restapi launch"
RUN echo "Developer" && \
    echo "echo\necho 'Launch the REST HTTP-API server with the command:'\necho '# $FLASK_CMD'" >> $APIRC && \
    echo "echo\necho 'Run unittests with:\n# restapi tests\n'\n" >> $APIRC && chown $APIUSER $APIRC

###################
# dumb init
RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb \
    && dpkg -i dumb-init_*.deb \
    && rm *.deb

###################
# closing entrypoint

RUN mkdir $CODE_DIR
WORKDIR $CODE_DIR
RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./docker-entrypoint-celery.sh /usr/local/bin/docker-entrypoint-celery

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint", "rest"]

# TODO: verify if better using tini for entrypoint
# https://github.com/krallin/tini-images
