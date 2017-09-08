
###################
FROM ubuntu:17.04
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

###################
# APT
RUN apt-get update && apt-get install -y \
    bash less vim curl wget telnet git jq \
    python3.6 build-essential libkrb5-dev python3.6-dev \
    libglobus-gssapi-gsi-dev \
    && cd /usr/bin && ln -s python3.6 python \
    && apt-get autoremove && apt-get clean \
    && echo "done"

###################
# PIP

COPY requirements.txt /tmp/
WORKDIR /tmp

RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py && rm *.py

RUN for package in `cat requirements.txt`; do \
    echo "adding: $package"; pip3 install --upgrade --no-cache-dir $package; done
# RUN pip install --upgrade --force-reinstall --no-cache-dir -r /tmp/requirements.txt

###################
# Adding gsi as gssapi available mechanism for RPC
COPY gsi.conf /etc/gss/mech.d/
# main user for launching the apis
ENV APIUSER developer

ENV APIUID 990
RUN useradd \
    -r -M -d /home/$APIUSER -s /bin/bash -p ! \
    --uid $APIUID $APIUSER \
    && mkdir -p /home/$APIUSER && chown $APIUID /home/$APIUSER

ENV CERTDIR /opt/certificates

###################
# UWSGI
# ENV UWSGI_LOGS /var/log/uwsgi
# ENV UWSGI_RUN /var/run/uwsgi
# ENV MYUWSGI_HOME /tmp/uwsgi
# RUN mkdir -p $UWSGI_LOGS
# RUN mkdir -p $UWSGI_RUN
# RUN chown -R www-data:www-data $UWSGI_LOGS $UWSGI_RUN
# COPY nginx_uwsgi.conf /etc/nginx/sites-available/default
# ENV UWSGI_MASTER ${MYUWSGI_HOME}/uwsgi_starter.ini
# COPY uwsgi.ini ${UWSGI_MASTER}
# COPY launch_uwsgi.sh /usr/local/bin/myuwsgi
# RUN chmod +x /usr/local/bin/myuwsgi
# # remove nginx defaults
# RUN rm -rf /etc/nginx/sites-enabled

###################
# variables
ENV PAGER less
ENV TERM=xterm-256color
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV PYTHONIOENCODING="utf-8"
# ENV FLASK_PORT 5000
# ENV JWT_APP_SECRETS /jwts
# EXPOSE $FLASK_PORT

######################
RUN echo "alias dev=\"HOME=/tmp su -p \$APIUSER\"" >> /root/.bash_aliases
RUN echo "#!/bin/bash\\nsu -p \$APIUSER -c 'export HOME=/tmp; cd /code; celery worker -c 1 -A restapi.flask_ext.flask_celery.worker.celery_app -n \${HOSTNAME}@\${VANILLA_PACKAGE}'" > /usr/local/bin/mycelery && chmod +x /usr/local/bin/mycelery
RUN echo "#!/bin/bash\\nsu -p \$APIUSER -c 'export HOME=/tmp; cd /code; flower --port=5555 persistent=True -A restapi.flask_ext.flask_celery.worker.celery_app -n flower_monitor'" > /usr/local/bin/start_flower && chmod +x /usr/local/bin/start_flower

######################

# closing entrypoint

RUN mkdir /code
WORKDIR /code
RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

CMD ["mycelery"]
