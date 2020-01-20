
# PROXY that accepts ACME challenges for letsencrypt
FROM nginx:1.17.6-alpine
LABEL maintainer="Paolo D'Onorio De Meo <m.dantonio@cineca.it>"

###################
ARG RAPYDO_VERSION
RUN test -n "$RAPYDO_VERSION" && \
    mkdir -p /etc/rapydo && echo $RAPYDO_VERSION > /etc/rapydo/release

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"

ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

###################
RUN apk --no-cache update && \
    apk --no-cache add vim wget git bash openssl curl netcat-openbsd tini

WORKDIR /tmp
ENV ACMEDIR /acme
# You can also upgrade live with /acme/acme.sh --upgrade --home /acme
# Then register the client /acme/acme.sh --register-account
ENV ACMEV "2.8.3"
RUN wget https://github.com/Neilpang/acme.sh/archive/${ACMEV}.zip \
    && unzip ${ACMEV}.zip && cd acme.sh-${ACMEV} \
    && /acme.sh --install --home $ACMEDIR \
    && ./acme.sh --register-account \
    && cd .. && rm -rf *$ACMEV

#######################
RUN mkdir -p /usr/share/nginx/html/.well-known/acme-challenge
RUN chown -R nginx /usr/share/nginx/html

# Set the directory for launching the renewall script
WORKDIR $ACMEDIR
ENV WWWDIR /usr/share/nginx/html

# Save production certificates across multiple run
ENV CERTDIR /etc/letsencrypt
ENV CERTSUBDIR real
ENV CERTKEYFILE $CERTSUBDIR/privkey1.pem
ENV CERTCHAINFILE $CERTSUBDIR/fullchain1.pem

ENV CERTKEY ${CERTDIR}/${CERTKEYFILE}
ENV CERTCHAIN ${CERTDIR}/${CERTCHAINFILE}

RUN mkdir -p $CERTDIR
RUN mkdir -p $CERTDIR/$CERTSUBDIR
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
# COPY rocket.conf /etc/nginx/sites-enabled/production
# COPY rancher.conf /etc/nginx/sites-enabled/production

###################
# closing entrypoint
RUN mkdir /docker-entrypoint.d
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["/sbin/tini", "docker-entrypoint"]
# ENTRYPOINT ["docker-entrypoint"]
CMD ["proxy"]
