FROM ubuntu:22.04

ARG RAPYDO_VERSION
RUN test -n "$RAPYDO_VERSION"
ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

# Note: 3.9 is no longer available on 22.04 and is temporary installed from source, restore the package installation
ENV PYTHON_VERSION=3.9
ENV APIUSER=developer
ENV FLASK_PORT=8080
ENV CODE_DIR=/code
ENV CERTDIR=/opt/certificates

ENV TERM=xterm-256color
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
## for apt to be noninteractive
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV PAGER=less
ENV PYTHONIOENCODING="utf-8"
ENV PYTHONPATH="${CODE_DIR}"

## preesed tzdata, update package index, upgrade packages and install needed software

# ############################################################# #
# Temporary fix: python3.9 no longer available for Ubuntu 22.04 #
# ############################################################# #
RUN echo "tzdata tzdata/Areas select Etc" > /tmp/preseed.txt; \
    echo "tzdata tzdata/Zones/Europe select UTC" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt \
    && apt-get update -qq \
    && apt-get install --yes --no-install-recommends \
    tzdata bash file less vim curl wget telnet iputils-ping sysstat git zip unzip build-essential gosu cron ca-certificates libgeos-dev libffi-dev libgdbm-dev libsqlite3-dev libssl-dev zlib1g-dev libbz2-dev liblzma-dev \
    && curl --silent -O https://www.python.org/ftp/python/3.9.12/Python-3.9.12.tgz \
    && tar -xvzf Python-3.9.12.tgz \
    && rm Python-3.9.12.tgz \
    && cd Python-3.9.12 \
    && ./configure --prefix=/opt/python/3.9 --enable-shared --enable-ipv6 LDFLAGS=-Wl,-rpath=/opt/python/3.9/lib,--disable-new-dtags \
    && make \
    && make install \
    && cd .. \
    && rm -rf Python-3.9.12 \
    && ln -sf /opt/python/3.9/bin/python3.9 /usr/bin/python3 \
    && curl --silent https://bootstrap.pypa.io/get-pip.py --output get-pip.py \
    && python3 get-pip.py \
    && rm get-pip.py \
    && ln -sf /opt/python/3.9/bin/pip3.9 /usr/bin/pip3 \
    && apt-get autoremove --yes && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade --no-cache-dir dumb-init==1.2.5 git+https://github.com/rapydo/http-api.git@$RAPYDO_VERSION  \
    && ln -sf /opt/python/3.9/bin/alembic /usr/local/bin/alembic \
    && ln -sf /opt/python/3.9/bin/celery /usr/local/bin/celery \
    && ln -sf /opt/python/3.9/bin/coverage /usr/local/bin/coverage \
    && ln -sf /opt/python/3.9/bin/dumb-init /usr/local/bin/dumb-init \
    && ln -sf /opt/python/3.9/bin/flask /usr/local/bin/flask \
    && ln -sf /opt/python/3.9/bin/gunicorn /usr/local/bin/gunicorn \
    && ln -sf /opt/python/3.9/bin/pytest /usr/local/bin/py.test \
    && ln -sf /opt/python/3.9/bin/restapi /usr/local/bin/restapi
# ############################################################# #
#                      End of temporary fix                     #
# ############################################################# #


# ############################################################# #
#                       Original Version                        #
# ############################################################# #
# Restore this to install python 3.10
# is libbz2-dev also needed here? Added to the modified version for hld and nig
# is liblzma-dev also needed here? Added to the modified version for nig
# RUN echo "tzdata tzdata/Areas select Etc" > /tmp/preseed.txt; \
#     echo "tzdata tzdata/Zones/Europe select UTC" >> /tmp/preseed.txt; \
#     debconf-set-selections /tmp/preseed.txt \
#     && apt-get update -qq \
#     && apt-get install --yes --no-install-recommends \
#     tzdata bash file less vim curl wget telnet iputils-ping sysstat git zip unzip build-essential gosu cron ca-certificates libgeos-dev \
#     python${PYTHON_VERSION} python${PYTHON_VERSION}-dev \
#     python3-gdbm python3-setuptools \
#     && ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python3 \
#     && curl --silent https://bootstrap.pypa.io/get-pip.py --output get-pip.py \
#     && python3 get-pip.py \
#     && rm get-pip.py \
#     && apt-get autoremove --yes && apt-get clean && rm -rf /var/lib/apt/lists/*

# RUN pip3 install --upgrade --no-cache-dir dumb-init==1.2.5 git+https://github.com/rapydo/http-api.git@$RAPYDO_VERSION
# ############################################################# #
#                     End of orginal version                    #
# ############################################################# #

RUN useradd \
    -r -M -d /home/$APIUSER -s /bin/bash -p ! \
    --uid $CURRENT_UID $APIUSER \
    && groupmod -og $CURRENT_GID $APIUSER \
    && mkdir -p /home/$APIUSER \
    && chown $CURRENT_UID:$CURRENT_GID /home/$APIUSER

# GUNICORN
ENV GUNICORN_CONF /tmp/gunicorn_conf.py
COPY gunicorn_conf.py ${GUNICORN_CONF}
COPY --chmod=740 launch_gunicorn.sh /usr/local/bin/mygunicorn

EXPOSE $FLASK_PORT

#### Make the terminal prettier ####
# generated with http://bashrcgenerator.com/
RUN echo 'export PS1="\\[\\033[38;5;11m\\]\\u\\[$(tput sgr0)\\]\\[\\033[38;5;15m\\]@\\h:\\[$(tput sgr0)\\]\\[\\033[38;5;6m\\][\\w]:\\[$(tput sgr0)\\]\\[\\033[38;5;15m\\] \\[$(tput sgr0)\\]"' >> /etc/bash.bashrc

RUN mkdir $CODE_DIR
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./docker-entrypoint-celery.sh /usr/local/bin/docker-entrypoint-celery
COPY ./docker-entrypoint-bot.sh /usr/local/bin/docker-entrypoint-bot

WORKDIR $CODE_DIR
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
STOPSIGNAL SIGINT
CMD ["docker-entrypoint", "rest"]

# UTILITIES
COPY --chmod=740 flask_migrate /usr/local/bin/flask_migrate
COPY --chmod=740 reload-backend.sh /usr/local/bin/reload
COPY --chmod=740 celery-healthcheck.sh /usr/local/bin/celery-healthcheck

RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc
COPY banner.sh print_versions.sh /etc/