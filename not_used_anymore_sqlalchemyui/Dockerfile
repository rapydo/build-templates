FROM hardware/adminer:latest
LABEL maintainer="Paolo D'Onorio De Meo <m.dantonio@cineca.it>"

WORKDIR /adminer
RUN cp index.php main.php
COPY snippet.php index.php
