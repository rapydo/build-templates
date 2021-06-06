FROM registry:2.7.1

RUN apk --no-cache update && apk --no-cache add openssl

COPY --chmod=5 ./create_certificate.sh /create_certificate.sh

# Adding my own script as 4th line of the original entrypoint
RUN sed -i '4iash /create_certificate.sh' /entrypoint.sh
