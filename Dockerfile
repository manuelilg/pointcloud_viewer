FROM ubuntu:xenial

RUN apt update && \
    apt install sudo bash-completion less nano curl git cmake g++ ninja-build libsdl2-dev -y && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://sh.rustup.rs -sSfo install_rust.sh && \
    sh install_rust.sh -y && \
    rm install_rust.sh
ENV PATH "$PATH:/root/.cargo/bin"

RUN git clone https://github.com/googlecartographer/point_cloud_viewer.git
#RUN point_cloud_viewer/ci/install_proto3.sh
RUN curl https://raw.githubusercontent.com/googlecartographer/cartographer/master/scripts/install_proto3.sh | sh

RUN cargo install --vers 1.4.3 protobuf

RUN curl https://storage.googleapis.com/golang/go1.10.3.linux-amd64.tar.gz | tar -C /usr/local -xz
ENV PATH=$PATH:/usr/local/go/bin
RUN cargo install grpcio-compiler

RUN cd point_cloud_viewer && cargo build --release
RUN cd point_cloud_viewer/sdl_viewer && cargo build --release


