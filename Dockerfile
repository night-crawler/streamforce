FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt --assume-yes upgrade

ENV RUNTIME_PACKAGES \
    # need it to clone
    ca-certificates \
    # just let it be
    mime-support \
    # libs we need to run
    libshout3 \
    libxml2 \
    libtag1v5 \
    libvorbis0a \
    libvorbisenc2 \
    libvorbisfile3 \
    libogg0 \
    libtag-extras1 \
    libtagc0 \
    # debian stuff we need to compile
    pkg-config \
    gettext \
    # potentially useful stuff
    lame \
    vorbis-tools \
    flac \
    madplay \
    # what a relieve to ping something
    iputils-ping

ENV BUILD_PACKAGES \
    libshout3-dev \
    libxml2-dev \
    libtag1-dev \
    libvorbis-dev \
    libogg-dev \
    libtag-extras-dev \
    libtagc0-dev \
    libiconv-hook-dev \
    automake \
    autoconf \
    automake \
    libtool \
    build-essential \
    check \
    git \
    unzip

RUN apt-get install --no-install-recommends --assume-yes ${RUNTIME_PACKAGES} ${BUILD_PACKAGES} \
 && apt-get autoremove --assume-yes \
 && apt-get autoclean \
 && apt-get clean \
 && update-ca-certificates

WORKDIR /application
ADD . /application

# current development branch
ADD https://github.com/xiph/ezstream/archive/6f8daee288f8f998520d8c222b08833b56103514.zip \
    /application/ezstream.zip

RUN unzip ezstream.zip \
 && cd ezstream-6f8daee288f8f998520d8c222b08833b56103514 \
 && sh autogen.sh \
 && ./configure --enable-examplesdir=/application/samples \
 && make -j4 \
 && make install

RUN cd /application && rm -rf ezstream* \
 && apt-get remove --purge --assume-yes $BUILD_PACKAGES \
 && apt-get autoremove --assume-yes \
 && apt-get autoclean \
 && apt-get clean

RUN adduser --uid 1000 --home /application --disabled-password --gecos "" ezstream && \
    chown -hR ezstream: /application

USER ezstream

ENTRYPOINT ["/usr/local/bin/ezstream", "-c", "/application/configs/prod.xml"]
