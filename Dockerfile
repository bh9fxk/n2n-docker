#FROM alpine:latest AS build-env

#RUN apk update && apk upgrade 
#RUN apk add --no-cache git bash autoconf automake gcc make musl-dev pkgconfig linux-headers
#WORKDIR /opt
#RUN git clone https://github.com/ntop/n2n.git -b 3.0-stable

#WORKDIR /opt/n2n
#RUN ./autogen.sh && ./configure && make && make install


#FROM alpine:latest
#RUN apk update && apk upgrade --no-cache 
#&& apk add openssl zstd-libs linux-headers --no-cache
FROM ubuntu:22.04 AS build-env
RUN apt-get update && \
apt-get -y install wget systemd
RUN wget https://github.com/ntop/n2n/releases/download/3.1.1/n2n_3.1.1_amd64.deb
RUN dpkg -i n2n_3.1.1_amd64.deb
RUN apt-get -y autoremove && apt-get autoclean

FROM ubuntu:22.04
COPY --from=build-env /usr/sbin/nedge /usr/sbin/

CMD ["/usr/sbin/nedge","/etc/edge.conf"]
