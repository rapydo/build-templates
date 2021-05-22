FROM swaggerapi/swagger-ui:v3.47.1 AS swaggerui

COPY --chmod=+x ./swagger-nginx-prerun.sh /usr/share/nginx/swagger-nginx-prerun.sh

# Use the original nginx.conf as development configuration
RUN mv /etc/nginx/nginx.conf /etc/nginx/adminer-development.conf

# Add a new configuration to be used in production mode
COPY ./production.conf /etc/nginx/adminer-production.conf

# Add swagger prerun.sh as third line of the docker entrypoint
# Note the . to run the instructions in pre-run in the original shell and make the env variables to survive
RUN sed -i '3i. /usr/share/nginx/swagger-nginx-prerun.sh' /docker-entrypoint.sh

COPY banner.sh print_versions.sh /etc/
RUN echo '/bin/ash /etc/banner.sh' >> ~/.bashrc
