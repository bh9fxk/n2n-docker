FROM alpine:latest AS build-env

RUN apk update && apk upgrade 
#RUN apk add --no-cache git bash autoconf automake gcc make musl-dev pkgconfig linux-headers openssl-dev zstd-dev
RUN apk add --no-cache git bash autoconf automake gcc make pkgconfig linux-headers
WORKDIR /root
RUN git clone https://github.com/ntop/n2n.git -b 3.0-stable

WORKDIR /root/n2n
RUN ./autogen.sh && ./configure && make

FROM alpine:latest
#RUN apk update && apk upgrade --no-cache 
#RUN apk add openssl zstd-libs musl-dev linux-headers --no-cache

COPY --from=build-env /root/n2n/edge /usr/sbin/

CMD ["/usr/sbin/edge","/etc/edge.conf"]
