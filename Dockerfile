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
RUN apt-get -y install software-properties-common wget && \
add-apt-repository universe && \
wget https://packages.ntop.org/apt-stable/22.04/all/apt-ntop-stable.deb && \
apt-get -y install ./apt-ntop-stable.deb

FROM ubuntu:22.04
COPY --from=build-env /usr/sbin/edge /usr/sbin/

CMD ["/usr/sbin/edge","/etc/edge.conf"]
