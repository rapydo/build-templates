FROM docker:dind

LABEL maintainer="Mattia D'Antonio"

ARG RAPYDO_VERSION
RUN test -n "$RAPYDO_VERSION"
ARG CURRENT_UID
RUN test -n "$CURRENT_UID"

RUN apk add git python3 

# These are needed to install cffi
# cffi is a dependency of bcrypt
# bcrypt is a dependency of paramiko
# paramiko is a dependency of docker[ssh] / docker-compose
# Previous versions do not required that, so let's try to
# remove in a near future with next versions
# libssl-dev is required by cryptography
RUN apk add python3-dev libc-dev libffi-dev openssl-dev gcc make 

RUN pip3 install --upgrade pip

RUN pip3 install --upgrade --no-cache-dir "git+https://github.com/rapydo/do.git@${RAPYDO_VERSION}"