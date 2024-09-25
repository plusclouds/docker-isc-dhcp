FROM ubuntu:24.04 AS base
LABEL Maintainer="Harun Baris Bulut <baris.bulut@plusclouds.com>"
LABEL Description="PlusClouds managed version of dhcp service"
ENV DEBIAN_FRONTEND noninteractive

# Preparing the docker image
RUN apt-get clean
RUN apt update
RUN apt upgrade -y

RUN apt install -y software-properties-common nano
RUN apt -y install --no-install-recommends wget gnupg ca-certificates curl -qq

RUN wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -
RUN echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" > openresty.list
RUN cp openresty.list /etc/apt/sources.list.d/
RUN echo "deb http://openresty.org/package/arm64/ubuntu $(lsb_release -sc) main"
RUN apt update
RUN apt install --no-install-recommends openresty -y
RUN apt install openresty-resty -y
RUN apt -y install openresty-opm
RUN opm get pintsized/lua-resty-http

RUN apt install -y isc-dhcp-server

# Pushing the initiation script into docker
COPY ./restart-dhcpd.sh restart-dhcpd.sh
COPY ./start-openresty.sh start-openresty.sh

COPY ./openresty.conf /etc/openresty/nginx.conf

# Exposing
EXPOSE 67/udp
EXPOSE 80/tcp

# Starting the service
CMD ["sh", "restart-dhcpd.sh"]

#Start openresty
CMD ["sh", "start-openresty.sh"]