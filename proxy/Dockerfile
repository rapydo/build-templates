FROM nginx:1.20.0-alpine
# http://nginx.org/en/CHANGES

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
    apk --no-cache add vim wget git bash openssl curl netcat-openbsd shadow tini

WORKDIR /tmp
ENV ACMEDIR /acme
# You can also upgrade live with /acme/acme.sh --upgrade --home /acme
# Then register the client /acme/acme.sh --register-account
ENV ACMEV "2.8.8"
RUN wget https://github.com/Neilpang/acme.sh/archive/${ACMEV}.zip \
    && unzip ${ACMEV}.zip && cd acme.sh-${ACMEV} \
    && ./acme.sh --install --home $ACMEDIR \
    && ./acme.sh --register-account \
    && cd .. && rm -rf ./*$ACMEV

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

RUN mkdir -p $CERTDIR/$CERTSUBDIR
VOLUME /etc/letsencrypt

# dhparam for better security
ENV DHPARAM /etc/nginx/ssl/dhparam.pem
VOLUME /etc/nginx/ssl

# Configure nginx on basic aspects
# + read configurations in "sites-enabled" dir
COPY nginx.conf /etc/nginx/nginx.conf
COPY confs /etc/nginx/sites-enabled-templates

COPY create_ssl_certificate.sh /usr/local/bin/updatecertificates
COPY maintenance.html /usr/share/nginx/html/maintenance.html
COPY 404.html /usr/share/nginx/html/custom_404.html
COPY 502.html /usr/share/nginx/html/custom_502.html
COPY 504.html /usr/share/nginx/html/custom_504.html
COPY errors.css /usr/share/nginx/html/errors.css
COPY giphy.gif /usr/share/nginx/html/giphy.gif
RUN chmod +r /usr/share/nginx/html/*

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./docker-entrypoint-maintenance.sh /usr/local/bin/docker-entrypoint-maintenanance

RUN groupmod -og $CURRENT_GID nginx && usermod -u $CURRENT_UID nginx

ENTRYPOINT ["/sbin/tini", "/usr/local/bin/docker-entrypoint"]
CMD ["proxy"]

COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/ash /etc/banner.sh' >> ~/.bashrc
