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
FROM debian:12-slim AS build-env
RUN apt-get update && \
apt-get -y install git autoconf automake gcc make musl-dev pkg-config
WORKDIR /opt
RUN git clone https://github.com/ntop/n2n.git -b 3.0-stable

WORKDIR /opt/n2n
RUN git swicht -c 2683f2c2350a6d5765611611e748af25ad2ac98
RUN ./autogen.sh && ./configure && make
RUN ls /opt/n2n

FROM debian:12-slim
COPY --from=build-env /opt/n2n/edge /usr/sbin/

CMD ["/usr/sbin/edge","/etc/edge.conf"]
