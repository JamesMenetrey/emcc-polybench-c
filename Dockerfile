FROM ubuntu:18.04

# Configuration static variables
ARG EMSCRIPTEN_VERSION=3.1.46

# Baseline components
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    clang-10 \
    make \
    perl \
    ca-certificates \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create symbolic links for clang
RUN ln -s /usr/bin/clang-10 /usr/bin/clang
RUN ln -s /usr/bin/clang++-10 /usr/bin/clang++

WORKDIR /
RUN git clone https://github.com/emscripten-core/emsdk.git
WORKDIR /emsdk
RUN ./emsdk install ${EMSCRIPTEN_VERSION}
RUN ./emsdk activate ${EMSCRIPTEN_VERSION}
RUN mkdir /.emscripten_cache
RUN chmod 777 /.emscripten_cache

ENTRYPOINT [ "/polybench/build.sh" ]