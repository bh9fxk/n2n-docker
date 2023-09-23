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
FROM debian:12 AS build-env
RUN apt-get update && \
apt-get -y install git autoconf automake gcc make musl-dev pkgconfig
WORKDIR /opt
RUN git clone https://github.com/ntop/n2n.git -b 3.0-stable

WORKDIR /opt/n2n
RUN ./autogen.sh && ./configure && make

FROM debian:12
COPY --from=build-env /usr/sbin/nedge /usr/sbin/

CMD ["/usr/sbin/nedge","/etc/edge.conf"]
