FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]  
RUN apt-get update
RUN apt-get -y install curl build-essential libssl-dev vim wget python3.6 pkg-config libglib2.0 libpixman-1-dev
WORKDIR /root
RUN  curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN source ~/.cargo/env

ENV PATH ~/.cargo/bin:${PATH}

RUN rustup target add riscv32imac-unknown-none-elf
ENV OPENSSL_LIB_DIR /usr/lib/x86_64-linux-gnu/
ENV OPENSSL_INCLUDE_DIR /usr/include/openssl/
RUN cargo install cargo-generate
RUN cargo install cargo-binutils
RUN rustup component add llvm-tools-preview

#gdb
WORKDIR /root
RUN wget -c https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.1.0-2019.01.0-x86_64-linux-ubuntu14.tar.gz
RUN tar xvzf riscv64-unknown-elf-gcc-8.1.0-2019.01.0-x86_64-linux-ubuntu14.tar.gz -C /usr/src
ENV PATH /usr/src/riscv64-unknown-elf-gcc-8.1.0-2019.01.0-x86_64-linux-ubuntu14/bin:$PATH

#qemu
WORKDIR /root
RUN wget https://download.qemu.org/qemu-4.2.0.tar.xz
RUN tar xvJf qemu-4.2.0.tar.xz -C ./
WORKDIR qemu-4.2.0
RUN pwd
RUN ls -al
RUN ./configure --target-list=riscv32-softmmu --python=/usr/bin/python3.6
RUN make install