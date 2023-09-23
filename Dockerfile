FROM alpine:latest AS build-env

RUN apk update && apk upgrade 
RUN apk add build-base openssl-dev zstd-dev git cmake linux-headers automake autoconf bash

WORKDIR /opt
RUN git clone --depth 1 --branch 3.1.1 https://github.com/ntop/n2n.git

WORKDIR /opt/n2n
#RUN git checkout -b 3.1.0
RUN ./autogen.sh && ./configure && make && make install


FROM alpine:latest
RUN apk update && apk upgrade --no-cache 
#&& apk add openssl zstd-libs linux-headers --no-cache

COPY --from=build-env /usr/sbin/edge /usr/sbin/

CMD ["/usr/sbin/edge","/etc/edge.conf"]
