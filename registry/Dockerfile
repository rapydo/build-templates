FROM registry:2.7.1

# apache2-utils adds htpasswd
RUN apk --no-cache update && apk --no-cache add openssl apache2-utils

COPY --chmod=5 ./set_security.sh /set_security.sh

# Adding my own script as 4th line of the original entrypoint
RUN sed -i '4iash /set_security.sh' /entrypoint.sh

COPY --chmod=740 reload-registry.sh /usr/local/bin/reload
