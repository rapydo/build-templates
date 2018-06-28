
###############
FROM node:8.11.3-alpine
LABEL maintainer="Paolo D'Onorio De Meo <paolo@proofmedia.io>"

###############
RUN apk --no-cache update && \
    apk --no-cache upgrade && apk add \
    bash less vim git \
    g++ make bash zlib-dev libpng-dev \
    && rm -rf /var/cache/apk/*
# curl wget bind-tools jq \
# https://github.com/imagemin/pngquant-bin/issues/36#issuecomment-381587705

###############
ENV NODE_PATH /opt/node_modules
WORKDIR /opt
# RUN npm install package-merge

###############
# # FIXME: add a user?
# ARG CURRENT_UID
# RUN test -n "$CURRENT_UID"

###############
RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
# ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint"]

###############
# EXPOSE 8080
EXPOSE 5000
WORKDIR /rapydo/
