
FROM b2safe/server:icat
LABEL maintainer="Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

#################
# USER root
ENV RESOURCES_DIR /opt/irods_res
ENV MAINRES_DIR $RESOURCES_DIR/main
ENV REPLICA_DIR $RESOURCES_DIR/replicas
RUN mkdir -p $MAINRES_DIR $REPLICA_DIR
ENV MAINRES myResc
ENV REPLICARES replicaResc

# ENV HANDLECONF /myconfig
# RUN echo "# HANDLE CONFIGURATION" > $HANDLECONF

#################
# Install dependencies for EUDAT python scripts
RUN apt-get update && apt-get install -y \
    python-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*
# python-dev build-essential libxml2-dev libxslt1-dev libz-dev \

RUN pip2 install --upgrade pip \
    b2handle==1.1.1 httplib2==0.10.3 queuelib==1.4.2 dweepy \
    simplejson lxml defusedxml

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

#  Prepare install script
ENV B2SAFE_HOME /opt/eudat/b2safe
ENV B2SAFE_CONFIG /tmp/myb2safe.conf
ADD config.ini $B2SAFE_CONFIG

# Save resources and eudat configurations
VOLUME /opt

USER root
WORKDIR /opt
# WORKDIR /tmp
