FROM rabbitmq:3.8.14-management

COPY --chown=rabbitmq ./enable-plugins.sh /usr/local/bin/enable-plugins.sh
COPY --chown=rabbitmq ./check_ssl.sh /usr/local/bin/check_ssl.sh

RUN chmod +x /usr/local/bin/enable-plugins.sh /usr/local/bin/check_ssl.sh

# Adding my own scripts as third line of the original entrypoint to force execution before start

RUN sed -i '3i/usr/local/bin/enable-plugins.sh' /usr/local/bin/docker-entrypoint.sh
RUN sed -i '3i/usr/local/bin/check_ssl.sh' /usr/local/bin/docker-entrypoint.sh

COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/bash /etc/banner.sh' >> /etc/bash.bashrc