
# FROM alpine:edge
FROM alpine:3.7
LABEL maintainer="Paolo D'Onorio De Meo <m.dantonio@cineca.it>"

WORKDIR /tmp
RUN apk update && apk upgrade && apk add \
    bash less vim git \
    curl wget bind-tools \
    jq \
    && rm -rf /var/cache/apk/*

RUN mkdir /docker-entrypoint.d/
COPY ./myscript.sh /usr/local/bin/docker-entrypoint
# ADD myscript.sh /usr/local/bin
RUN chmod +x /usr/local/bin/*
ENTRYPOINT ["docker-entrypoint"]
CMD ["client"]
