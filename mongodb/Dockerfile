FROM mongo:5.0.0

ARG CURRENT_UID
RUN test -n "$CURRENT_UID"
ARG CURRENT_GID
RUN test -n "$CURRENT_GID"

COPY --chown=mongodb --chmod=740 ./init-mongo.sh /docker-entrypoint-initdb.d/init-mongo.sh
COPY --chmod=740 ./fix_user.sh /fix_user.sh

# Adding my own script as third line of the original entrypoint. The script 
# is only executed when the docker entrypoint is run as root to prevent
# permission denied errors.
# Note mkdir is needed because the mongo Dockerfile creates the mongodb user without -m flag, i.e. without creating the home and due to that some commands will raise an exception like this:
# Error saving history file: FileOpenFailed Unable to open() file /home/mongodb/.dbshell: No such file or directory

RUN mkdir -p /home/mongodb \
    && chown -R mongodb:mongodb /home/mongodb \
    && sed -i '3iif [[ $(whoami) == "root" ]]; then /fix_user.sh; fi' /usr/local/bin/docker-entrypoint.sh

COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc

