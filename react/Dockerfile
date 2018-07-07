
###############
FROM node:8.11.3-alpine
LABEL maintainer="Paolo D'Onorio De Meo <paolo@proofmedia.io>"

# apk add shadow sudo
# RUN usermod -aG sudo $GUEST_USER #NOT WORKING
# sed -e 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' \ -i /etc/sudoers
# edited the sudo file using visudo and uncommented %wheel ALL=(ALL) ALL
# http://web.ist.utl.pt/joao.leao.guerreiro/post/alpinedocker/

RUN apk --no-cache update && \
    apk --no-cache upgrade && apk add \
    bash less vim git \
    g++ make bash zlib-dev libpng-dev \
    && rm -rf /var/cache/apk/*
# about npm packages problem in alpine: http://j.mp/2ubNUcd

# ###############
# # Handle a guest user
# ARG CURRENT_UID
# RUN test -n "$CURRENT_UID"
# ENV GUEST_USER developer
# ENV GUEST_UID $CURRENT_UID
# ENV GUEST_SHELL /bin/bash
# RUN adduser -s $GUEST_SHELL -u $GUEST_UID -D -h /home/$GUEST_USER $GUEST_USER

###############
RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
# ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint"]
EXPOSE 5000
WORKDIR /rapydo/
