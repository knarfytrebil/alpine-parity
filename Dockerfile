FROM alpine:edge

# install dependencies
RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk add --no-cache openssl-dev g++ make curl libusb-dev \
        eudev-dev cargo=0.22.0-r4 git file linux-headers

WORKDIR /build

# show tools
RUN rustc -vV && \
    cargo -V && \
    gcc -v && \
    g++ -v

# download parity v1.9.5-stable
RUN wget https://github.com/paritytech/parity/archive/v1.9.5.tar.gz && \
    tar -xzf v1.9.5.tar.gz && \
    cd /build/parity-1.9.5 && \
    cargo build --release && \
    strip /build/parity-1.9.5/target/release/parity

# clean up
RUN file /build/parity-1.9.5/target/release/parity && \
    apk del make curl linux-headers g++ cargo git file

EXPOSE 8080 8545 8180
ENTRYPOINT ["/build/parity-1.9.5/target/release/parity"]
