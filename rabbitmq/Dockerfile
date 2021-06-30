FROM rabbitmq:3.8.16-management

COPY --chown=rabbitmq --chmod=740 ./enable-plugins.sh /usr/local/bin/enable-plugins.sh
COPY --chown=rabbitmq --chmod=740  ./check_ssl.sh /usr/local/bin/check_ssl.sh
COPY --chown=rabbitmq --chmod=740  ./reload_certificate.sh /usr/local/bin/reload_certificate

# Adding my own scripts as third line of the original entrypoint to force execution before start

RUN sed -i '3i/usr/local/bin/enable-plugins.sh' /usr/local/bin/docker-entrypoint.sh
RUN sed -i '3i/usr/local/bin/check_ssl.sh' /usr/local/bin/docker-entrypoint.sh

COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc