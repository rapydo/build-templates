
FROM b2safe/server:icat
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

# #################
# # USER root
# ENV RESOURCES_DIR /opt/irods_res
# ENV MAINRES_DIR $RESOURCES_DIR/main
# ENV REPLICA_DIR $RESOURCES_DIR/replicas
# RUN mkdir -p $MAINRES_DIR $REPLICA_DIR
# #   && chown -R $IRODS_USER:$IRODS_USER $RESOURCES_DIR
# ENV MAINRES myResc
# ENV REPLICARES replicaResc
# ENV HANDLECONF /myconfig
# RUN echo "# HANDLE CONFIGURATION" > $HANDLECONF

# #################
# # Install dependencies for EUDAT python scripts
# RUN apt-get update && apt-get install -y \
#     python-setuptools python-dev build-essential \
#     libxml2-dev libxslt1-dev libz-dev \
#     && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* \
#     && easy_install pip && pip install --upgrade pip \
#     && pip install simplejson httplib2 defusedxml lxml queuelib dweepy

# #################
# RUN yes $IRODS_PASS | passwd $IRODS_USER
# RUN adduser $IRODS_USER sudo

# #################
# Clone eudat repo
USER $IRODS_UNAME
RUN cd /tmp && git clone https://github.com/EUDAT-B2SAFE/B2SAFE-core
WORKDIR /tmp/B2SAFE-core/packaging
# move the deb position to tmp dir
RUN sed -i "8s/\${HOME}/\/tmp/" create_deb_package.sh
RUN ./create_deb_package.sh

ENV B2SAFE_HOME /opt/eudat/b2safe

# #  Prepare install script
# ENV EUDAT_CONFIGF /tmp/eudat.conf
# ADD myeudat.conf $EUDAT_CONFIGF
# ADD install_eudat.sh $EXTRA_INSTALLATION_SCRIPT

USER root
WORKDIR /tmp
