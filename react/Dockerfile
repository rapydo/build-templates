
FROM node:10.9.0-alpine
LABEL maintainer="Paolo <paolo@proofmedia.io>"

RUN apk --no-cache update && \
    apk --no-cache upgrade && apk add \
    bash less vim git \
    dumb-init \
    g++ make bash zlib-dev libpng-dev \
    && rm -rf /var/cache/apk/*
# about npm packages problem in alpine: http://j.mp/2ubNUcd

RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint"]
EXPOSE 5000
WORKDIR /rapydo/
