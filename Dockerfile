FROM alpine:latest as builder
ARG VERSION=0.8.12
RUN apk add --update alpine-sdk wget bash && \
    cd / && \
    wget -q  https://github.com/z3APA3A/3proxy/archive/${VERSION}.tar.gz && \
    tar -xf ${VERSION}.tar.gz && \
    cd 3proxy-${VERSION} && \
    make -f Makefile.Linux
# STEP 2 build a small image
FROM alpine:latest
ARG VERSION=0.8.12
VOLUME ["/etc/3proxy/cfg/"]
WORKDIR /etc/3proxy/
COPY --from=builder /3proxy-${VERSION}/src/3proxy /etc/3proxy/
RUN apk update && \
    apk upgrade && \
    apk add bash && \
    mkdir -p /etc/3proxy/cfg && \
    mkdir -p /etc/3proxy/cfg/traf && \
    chmod -R +x /etc/3proxy/3proxy
COPY ./3proxy.cfg /etc/3proxy/cfg/3proxy.cfg
EXPOSE 3128:3128/tcp 1080:1080/tcp 8080/tcp
CMD ["./3proxy", "./cfg/3proxy.cfg"]
