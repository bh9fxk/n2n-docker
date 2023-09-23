FROM alpine:latest AS build-env

RUN apk update && apk upgrade 
RUN apk add --no-cache git bash autoconf automake gcc make musl-dev pkgconfig linux-headers
WORKDIR /opt
RUN git clone https://github.com/ntop/n2n.git

WORKDIR /opt/n2n
RUN git switch -c 3.0
RUN ./autogen.sh && ./configure && make && make install


FROM alpine:latest
RUN apk update && apk upgrade --no-cache 
#&& apk add openssl zstd-libs linux-headers --no-cache

COPY --from=build-env /usr/sbin/edge /usr/sbin/

CMD ["/usr/sbin/edge","/etc/edge.conf"]
