FROM centos:7

LABEL maintainer="Mattia D'Antonio <m.dantonio@cineca.it>"

###################
ARG RAPYDO_VERSION
RUN test -n "$RAPYDO_VERSION"
ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"
###################

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV TERM=xterm-256color
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN yum install -y \
    bash less vim curl wget telnet iputils git gcc gcc-c++ make epel-release gosu

# Once enabled epel repository we can install any Python 3.x and nginx
RUN yum install -y nginx rh-python36 python36-devel python36-pip \
    && yum clean all -y
    
# RUN ln -s /usr/bin/pip3.6 /bin/pip3 && \
#    ln -s /usr/bin/python3.6 /usr/bin/python3

###################
COPY requirements.txt /tmp/
WORKDIR /tmp

RUN pip3 install --upgrade --no-cache-dir pip dumb-init

# # DEBUG CONFLICTS:
# RUN pip3 install pip-conflict-checker && pipconflictchecker

RUN cat requirements.txt | xargs -n 1 -L 1 pip3 install --trusted-host pypi.python.org --upgrade --no-cache-dir

RUN pip3 install --upgrade --no-cache-dir git+https://github.com/rapydo/http-api.git@$RAPYDO_VERSION

# main user for launching the apis
ENV APIUSER developer

ENV APIUID $CURRENT_UID
RUN useradd \
    -r -M -d /home/$APIUSER -s /bin/bash -p ! \
    --uid $APIUID $APIUSER \
    && groupmod -g $CURRENT_GID $APIUSER \
    && mkdir -p /home/$APIUSER \
    && chown $APIUID:$CURRENT_GID /home/$APIUSER

RUN if [ ! -f /home/$APIUSER/.bashrc ]; then cp /root/.bashrc /home/$APIUSER/.bashrc ; fi

###################
# UWSGI
ENV UWSGI_LOGS /var/log/uwsgi
ENV UWSGI_RUN /var/run/uwsgi
ENV MYUWSGI_HOME /tmp/uwsgi
RUN mkdir -p $UWSGI_LOGS
RUN mkdir -p $UWSGI_RUN

ENV UWSGI_MASTER ${MYUWSGI_HOME}/uwsgi_starter.ini
COPY uwsgi.ini ${UWSGI_MASTER}
COPY launch_uwsgi.sh /usr/local/bin/myuwsgi
COPY flask_migrate /usr/local/bin/flask_migrate 
RUN chmod +x /usr/local/bin/myuwsgi /usr/local/bin/flask_migrate

COPY nginx_base.conf /etc/nginx/nginx.conf
COPY nginx_uwsgi.conf /etc/nginx/sites-enabled/default

COPY sleep.py /usr/local/bin/pysleeper
COPY tests.sh /usr/local/bin/pyunittests

###################
# variables
ENV PAGER less
ENV PYTHONIOENCODING="utf-8"
ENV FLASK_PORT 8080
ENV JWT_APP_SECRETS /jwts
ENV CODE_DIR /code
ENV CERTDIR /opt/certificates
ENV PYTHONPATH $CODE_DIR
EXPOSE $FLASK_PORT

######################
ENV DEV_SU "HOME=$CODE_DIR su -p \$APIUSER"
RUN echo "alias dev='$DEV_SU'" >> /root/.bash_aliases

ENV FLASK_CMD "restapi launch"

#### Make the terminal prettier ####
# generated with http://bashrcgenerator.com/
RUN echo 'export PS1="\\[\\033[38;5;11m\\]\\u\\[$(tput sgr0)\\]\\[\\033[38;5;15m\\]@\\h:\\[$(tput sgr0)\\]\\[\\033[38;5;6m\\][\\w]:\\[$(tput sgr0)\\]\\[\\033[38;5;15m\\] \\[$(tput sgr0)\\]"' >> /etc/bashrc

# closing entrypoint

RUN mkdir $CODE_DIR
WORKDIR $CODE_DIR
RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./docker-entrypoint-celery.sh /usr/local/bin/docker-entrypoint-celery

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["docker-entrypoint", "rest"]

# TODO: verify if better using tini for entrypoint
# https://github.com/krallin/tini-images
