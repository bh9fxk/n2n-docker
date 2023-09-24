FROM alpine:3.15 AS build-env

RUN apk update && apk upgrade 
#RUN apk add --no-cache git bash autoconf automake gcc make musl-dev pkgconfig linux-headers
RUN apk add --no-cache git bash gcc musl-dev pkgconfig linux-headers cmake openssl-dev zstd-dev
#WORKDIR /opt
#RUN git clone https://github.com/ntop/n2n.git -b 3.0-stable

#WORKDIR /opt/n2n
#RUN ./autogen.sh && ./configure && make
WORKDIR /root
RUN cd /root && \
git clone --depth 1 --branch 3.1.1 https://github.com/ntop/n2n.git && \
cd n2n && mkdir build && cd build
WORKDIR /root/n2n/build
cmake /root/n2n/ "-DN2N_OPTION_USE_OPENSSL=ON" "-DN2N_OPTION_USE_ZSTD=ON" && \
cmake --build . && \
cmake --install .

FROM alpine:3.15
RUN apk update && apk upgrade --no-cache 
#&& apk add openssl zstd-libs linux-headers --no-cache

#COPY --from=build-env /opt/n2n/edge /usr/sbin/
COPY --from=build-env /usr/sbin/edge /usr/sbin/
CMD ["/usr/sbin/edge","/etc/edge.conf"]
