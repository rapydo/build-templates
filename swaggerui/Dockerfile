FROM swaggerapi/swagger-ui:v3.36.0 AS swaggerui

COPY ./swagger-nginx-prerun.sh /usr/share/nginx/swagger-nginx-prerun.sh

# Use the original nginx.conf as development configuration
RUN mv /etc/nginx/nginx.conf /etc/nginx/adminer-development.conf

# Add a new configuration to be used in production mode
COPY ./production.conf /etc/nginx/adminer-production.conf

RUN chmod +x /usr/share/nginx/swagger-nginx-prerun.sh

# Add swagger prerun.sh as third line of run.sh
RUN sed -i '3i/usr/share/nginx/swagger-nginx-prerun.sh' /usr/share/nginx/run.sh
