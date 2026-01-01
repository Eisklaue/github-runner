FROM ubuntu:24.04

LABEL maintainer="Andy Fritz"
LABEL repository="https://github.com/Eisklaue/github-runner"

ARG RUNNER_VERSION="2.330.0"
ARG DEBIAN_FRONTEND="noninteractive"

RUN apt update -y && \
    apt upgrade -y && \ 
    apt install -y --no-install-recommends \
    curl\
    jq \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*