
###################
# LTS
# FROM ubuntu:16.04
FROM ubuntu:17.04
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

###################
# Preparation
WORKDIR /tmp
RUN apt-get update -qq && apt-get install -y \
        ## normal base
        wget git vim expect lsof sudo \
        ## fix lsb_release missing command in ubuntu 17.04
        # lsb-release \
        ## fix the ssl error for apt-key
        # gnupg-curl \
        ## fix "The method driver /usr/lib/apt/methods/https could not be found"
        apt-transport-https \
        ## fix the plugin error at irods installation time
        libxml2 \
    # update to globus toolkit 6
    && wget https://downloads.globus.org/toolkit/gt6/stable/installers/repo/deb/globus-toolkit-repo_latest_all.deb \
    && dpkg -i *.deb \
    && apt-get update -qq && apt-get install -y \
        ## GSI and Grid FTP dependencies
        globus-proxy-utils \
        globus-gsi-cert-utils-progs globus-simple-ca \
    # clean
    && apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/cache /var/lib/log /tmp/*

###################
# Add repos, download and install
ENV URL https://packages.irods.org

# UBUNTU 16.04
# RUN apt-key adv --fetch-keys $URL/irods-signing-key.asc \
#     # && echo "deb $URL/apt/ $(lsb_release -sc) main" \
#     && echo "deb $URL/apt/ trusty main" \
#         > /etc/apt/sources.list.d/renci-irods.list

# UBUNTU 17.04
RUN wget -qO - $URL/irods-signing-key.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.irods.org/apt/ trusty main" | sudo tee /etc/apt/sources.list.d/renci-irods.list

# Make sure the main irods user is the same id into HTTP API server
ENV IRODS_UNAME irods
ENV IRODS_UID 990
RUN useradd \
    -r -M -d /home/$IRODS_UNAME -s /bin/bash -p ! \
    --uid $IRODS_UID $IRODS_UNAME \
    && mkdir -p /home/$IRODS_UNAME && chown $IRODS_UID /home/$IRODS_UNAME

# ENV IRODS_VERSION 4.2.0
# ENV GSI_VERSION 2.0.0
ENV IRODS_VERSION 4.2.1
ENV GSI_VERSION 2.1.0

RUN apt-get update && apt-get install -y \
        # iCAT
        irods-runtime=$IRODS_VERSION irods-icommands=$IRODS_VERSION \
        irods-server=$IRODS_VERSION \
        # iRODS Plugins (also GSI)
        irods-database-plugin-postgres=$IRODS_VERSION \
        irods-auth-plugin-gsi=$GSI_VERSION \
    # clean
    && apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/cache /var/lib/log /tmp/*

# # Note: USER and GROUP are added automatically by irods install scripts

###################
# OTHER OPERATIONS
ENV TERM xterm-256color

# certificates
ENV CERTDIR /opt/certificates
ENV GRIDCERTDIR /etc/grid-security
ENV CADIR $CERTDIR/simple_ca
RUN mkdir -p $CADIR
COPY add_irods_x509.sh /usr/local/bin/add-irods-X509
COPY switch_gsi_user.sh /usr/local/bin/switch-gsi
RUN echo "alias berods='HOME=/var/lib/irods su -p irods'" >> /root/.bash_aliases

###################
# TODO: move outside into docker-compose
# add certification authorities
ENV B2ACCESS_CAS /tmp/b2access_certificates
COPY b2access_certificates/b2access.ca.dev.pem $B2ACCESS_CAS/
COPY b2access_certificates/b2access.ca.dev.signing_policy $B2ACCESS_CAS/
COPY b2access_certificates/b2access.ca.prod.pem $B2ACCESS_CAS/
COPY b2access_certificates/b2access.ca.prod.signing_policy $B2ACCESS_CAS/

###################
# VOLUMES
VOLUME /etc
VOLUME /var/lib/irods
VOLUME /opt/certificates

###################
# ENTRYPOINT
# if you need to add future commands after irods installation:
# allow custom scripts to be executed at launch time
RUN mkdir /docker-entrypoint.d/
ENTRYPOINT ["docker-entrypoint"]
COPY ./expect_irods.sh /prepare_answers
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint

###################
# WORKDIR /tmp
EXPOSE 1247
CMD ["irods"]

###################
# fix irods id?
# simpleca:x:999:999:User to run the SimpleCA:/var/lib/globus/simple_ca:/bin/nologin
# irods:x:998:998:iRODS Administrator:/var/lib/irods:/bin/bash
