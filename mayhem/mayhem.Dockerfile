# Build Stage
FROM rustlang/rust:nightly AS builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang curl
RUN cargo install cargo-fuzz

## Add source code to the build stage.
ADD . /gitoxide
WORKDIR /gitoxide
RUN cd git-config && cargo fuzz build --fuzz-dir ./fuzz

# Package Stage
FROM ubuntu:20.04

COPY --from=builder /gitoxide/git-config/fuzz/target/x86_64-unknown-linux-gnu/release/parse /
