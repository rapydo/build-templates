
# FROM ubuntu:17.10
# TODO: check what python do I get by default here

FROM ubuntu:17.04

# TODO: check if possible switching to alpine,
# and make better use of UWSGI:
# FROM python:3.6-alpine
# http://j.mp/2rxvp3r

MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

###################
# APT
RUN apt-get update && apt-get install -y \
    # utils
    bash less vim curl wget telnet git jq \
    # latest python
    python3.6 \
    # build dependencies for gssapi plugin (GSI and irods)
    build-essential libkrb5-dev python3.6-dev \
    libglobus-gssapi-gsi-dev \
    # criptography
    libssl-dev libffi-dev python3.6-dev \
    # nginx internal server for uwsgi
    nginx \
    # make this version the official python for anyone
    && cd /usr/bin && ln -s python3.6 python \
    && apt-get autoremove && apt-get clean \
    && echo "done"

###################
# PIP

COPY requirements.txt /tmp/
WORKDIR /tmp

RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py && rm *.py

# Install in causal order
# RUN pip install --upgrade \
#     --force-reinstall --no-cache-dir -r requirements.txt
# Install following the order found in the file
RUN cat requirements.txt && echo "" && echo INSTALLING && \
    xargs -L 1 pip install --upgrade < requirements.txt
# DEBUG CONFLICTS:
# pip install pip-conflict-checker && pipconflictchecker

###################
# Adding gsi as gssapi available mechanism for RPC
COPY gsi.conf /etc/gss/mech.d/
# main user for launching the apis
ENV APIUSER developer
# Emulating irods user creation. See http://j.mp/2lGPqlq
RUN useradd -r -M -d /home/$APIUSER -s /bin/bash -p ! $APIUSER
RUN mkdir -p /home/$APIUSER && chown $APIUSER:$APIUSER /home/$APIUSER

###################
# UWSGI
ENV UWSGI_LOGS /var/log/uwsgi
ENV UWSGI_RUN /var/run/uwsgi
ENV MYUWSGI_HOME /tmp/uwsgi
RUN mkdir -p $UWSGI_LOGS
RUN mkdir -p $UWSGI_RUN
RUN chown -R www-data:www-data $UWSGI_LOGS $UWSGI_RUN
COPY nginx_uwsgi.conf /etc/nginx/sites-available/default
ENV UWSGI_MASTER ${MYUWSGI_HOME}/uwsgi_starter.ini
COPY uwsgi.ini ${UWSGI_MASTER}
COPY launch_uwsgi.sh /usr/local/bin/myuwsgi
RUN chmod +x /usr/local/bin/myuwsgi
# # remove nginx defaults
# RUN rm -rf /etc/nginx/sites-enabled
COPY sleep.py /usr/local/bin/pysleeper
COPY tests.sh /usr/local/bin/pyunittests

###################
# variables
ENV PAGER less
ENV TERM=xterm-256color
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
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

ENV APIRC /home/$APIUSER/.bashrc
ENV FLASK_CMD "restapi launch"
RUN echo "Developer" && \
    echo "echo\necho 'Launch the REST HTTP-API server with the command:'\necho '# $FLASK_CMD'" >> $APIRC && \
    echo "echo\necho 'Run unittests with:\n# nose2 -F [tests.FOLDER]\n'\n" \
        >> $APIRC && \
    chown $APIUSER $APIRC

###################
# closing entrypoint

RUN mkdir $CODE_DIR
WORKDIR $CODE_DIR
RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]
CMD ["rest"]

# TODO: verify if better using tini for entrypoint
# https://github.com/krallin/tini-images
