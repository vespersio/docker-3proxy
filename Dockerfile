FROM alpine:latest as builder
ARG VERSION=0.9.1
RUN apk add --update libc-dev wget gcc make linux-headers && \
    cd / && \
    wget -q  https://github.com/z3APA3A/3proxy/archive/${VERSION}.tar.gz && \
    tar -xf ${VERSION}.tar.gz && \
    cd 3proxy-${VERSION} && \
    make -f Makefile.Linux

FROM alpine:latest
ARG VERSION=0.9.0
WORKDIR /etc/3proxy/
COPY --from=builder /3proxy-${VERSION}/src/3proxy /etc/3proxy/
RUN apk --no-cache --no-progress upgrade && \
    mkdir -p /etc/3proxy/cfg && \
    mkdir -p /etc/3proxy/cfg/traf && \
    chmod -R +x /etc/3proxy/3proxy
COPY ./3proxy.cfg /etc/3proxy/cfg/3proxy.cfg
VOLUME /etc/3proxy/cfg/
EXPOSE 3128:3128/tcp 1080:1080/tcp 8080/tcp
CMD ["./3proxy", "./cfg/3proxy.cfg"]
