FROM alpine:latest AS build-env

RUN apk update && apk upgrade 
#RUN apk add --no-cache git bash autoconf automake gcc make musl-dev pkgconfig linux-headers
RUN apk add --no-cache git bash gcc musl-dev pkgconfig linux-headers cmake openssl-dev zstd-dev
WORKDIR /opt
RUN git clone https://github.com/ntop/n2n.git -b 3.0-stable

WORKDIR /opt/n2n
RUN ./autogen.sh && ./configure && make

FROM alpine:latest
RUN apk update && apk upgrade --no-cache 
#&& apk add openssl zstd-libs linux-headers --no-cache

COPY --from=build-env /opt/n2n/edge /usr/sbin/

CMD ["/usr/sbin/edge","/etc/edge.conf"]
