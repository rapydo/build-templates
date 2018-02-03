
# PROXY that accepts challenges
FROM nginx:1.13.7-alpine
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

RUN apk update && \
    apk add vim wget git bash \
    openssl curl netcat-openbsd \
    tini \
    && rm -rf /var/cache/apk/*

WORKDIR /tmp
ENV ACMEDIR /acme
ENV ACMEV "2.7.5"
RUN echo acme && \
    wget https://github.com/Neilpang/acme.sh/archive/${ACMEV}.zip \
    && unzip ${ACMEV}.zip && cd acme.sh-${ACMEV} \
    && ./acme.sh --install --home $ACMEDIR \
    && cd .. && rm -rf *$ACMEV

#######################
RUN mkdir -p /usr/share/nginx/html/.well-known/acme-challenge
RUN chown -R nginx /usr/share/nginx/html

# Set the directory for launching the renewall script
WORKDIR $ACMEDIR
ENV WWWDIR /usr/share/nginx/html

# Save production certificates across multiple run
ENV CERTDIR /etc/letsencrypt/real
ENV CERTKEY ${CERTDIR}/privkey1.pem
ENV CERTCHAIN ${CERTDIR}/fullchain1.pem
RUN mkdir -p $CERTDIR
VOLUME /etc/letsencrypt

# dhparam for better security
ENV DHPARAM /etc/nginx/ssl/dhparam.pem
VOLUME /etc/nginx/ssl

# Configure nginx on basic aspects
# + read configurations in "sites-enabled" dir
COPY nginx.conf /etc/nginx/nginx.conf
COPY letsencrypt.sh /usr/local/bin/updatecertificates
COPY create_self_signed_ssl.sh /usr/local/bin/selfsign
COPY 502.html /usr/share/nginx/html/custom_502.html

###################
# closing entrypoint
RUN mkdir /docker-entrypoint.d
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["/sbin/tini", "docker-entrypoint"]
# ENTRYPOINT ["docker-entrypoint"]
CMD ["proxy"]
