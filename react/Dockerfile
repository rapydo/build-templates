
FROM node:10.12.0-alpine
LABEL maintainer="Paolo <paolo@proofmedia.io>"

RUN apk --no-cache update && \
    apk --no-cache upgrade && apk --no-cache add \
    bash less vim git \
    dumb-init \
    g++ make bash zlib-dev libpng-dev
# about npm packages problem in alpine: http://j.mp/2ubNUcd

# NOTE: yarn will be at the maximum possible release
# related to current node release
# v1.12.1 latest, 1.10.1 is installed

RUN mkdir /docker-entrypoint.d/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker-entrypoint"]
EXPOSE 5000
WORKDIR /rapydo/
