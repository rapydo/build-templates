
FROM python:3.6-alpine
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

###################################
RUN apk update && apk upgrade && apk add \
    bash less vim git \
    curl wget bind-tools \
    jq \
    && rm -rf /var/cache/apk/*

# Install jqt/yq
# https://fadado.github.io/jqt/
RUN git clone https://github.com/fadado/jqt.git /tmp/jqt \
    && ln -s /usr/local/bin/python /usr/bin/
ENV PATH $PATH:/tmp/jqt/bin

# Install python packages
COPY requirements.txt /tmp/
WORKDIR /tmp
# Install in causal order
RUN pip install --upgrade \
    --force-reinstall --no-cache-dir -r requirements.txt
# RUN pip --no-cache-dir install --upgrade \
#     pip httpie http-prompt pyyaml \
#     pygments jsoncut \
#     rapydo-utils

###################################
# Handle a guest user
ENV GUEST_USER developer
ENV GUEST_UID 1000
# ENV GUEST_UID 990
ENV GUEST_SHELL /bin/bash
RUN adduser -s $GUEST_SHELL -u $GUEST_UID -D -h /home/$GUEST_USER $GUEST_USER

ENV PAGER less
ENV TERM=xterm-256color
ENV HISTCONTROL ignoreboth:erasedups
ENV CODE_DIR /code

# Use the new user
USER $GUEST_USER
ENV BASHRC /home/$GUEST_USER/.bashrc
RUN echo "Adding welcome message" \
    && echo "reset" > $BASHRC \
    && echo "echo -e 'Hello\\n\\nYou may call the client with:'" >> $BASHRC \
    && echo "echo -e '$ http \$APP_HOST\$APP_PORT/api/status\\n'" >> $BASHRC \
    && echo "echo -e 'There is also available a utility:'" >> $BASHRC \
    && echo "echo -e '$ . $CODE_DIR/client/queryapi [help]\\n'" >> $BASHRC
USER root

###################################
RUN mkdir -p $CODE_DIR/client
COPY client_init.sh $CODE_DIR/client/gettoken
COPY query_api.sh $CODE_DIR/client/queryapi
COPY sleep.py /usr/local/bin/pysleeper

# TODO: use tini?
# RUN apk add --no-cache tini
# # Tini is now available at /sbin/tini
# ENTRYPOINT ["/sbin/tini", "--"]

###################################
RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]
CMD ["client"]

# WORKDIR /home/$GUEST_USER
WORKDIR $CODE_DIR
