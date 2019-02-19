FROM docker:dind

LABEL maintainer="Mattia D'Antonio"

ARG RAPYDO_VERSION
RUN test -n "$RAPYDO_VERSION"
ARG CURRENT_UID
RUN test -n "$CURRENT_UID"

RUN apk add git python3

RUN pip3 install --upgrade pip

RUN pip3 install --upgrade --no-cache-dir "git+https://github.com/rapydo/utils.git@${RAPYDO_VERSION}"

RUN pip3 install --upgrade --no-cache-dir "git+https://github.com/rapydo/do.git@${RAPYDO_VERSION}"