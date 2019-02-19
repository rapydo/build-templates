FROM docker:dind

RUN apk add git python3

RUN pip3 install --upgrade pip

RUN pip3 install --upgrade --no-cache-dir git+https://github.com/rapydo/utils.git@$RAPYDO_VERSION

RUN pip3 install --upgrade --no-cache-dir git+https://github.com/rapydo/http-api.git@$RAPYDO_VERSION