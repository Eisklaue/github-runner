#!/usr/bin/env bash

set -euo pipefail

function install_yq() {
    local DPKG_ARCH YQ_DOWNLOAD_URL

    DPKG_ARCH="$(dpkg --print-architecture)"

    YQ_DOWNLOAD_URL=$(curl -sL -H "Accept: application/vnd.github+json" \
    https://api.github.com/repos/mikefarah/yq/releases/latest \
      | jq ".assets[] | select(.name == \"yq_linux_${DPKG_ARCH}.tar.gz\")" \
      | jq -r '.browser_download_url')

    curl -s "${YQ_DOWNLOAD_URL}" -L -o /tmp/yq.tar.gz
    tar -xzf /tmp/yq.tar.gz -C /tmp
    mv "/tmp/yq_linux_${DPKG_ARCH}" /usr/local/bin/yq

}

function install_base_packages() {

apt install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        gnupg \
        tar \
        unzip \
        zip \
        apt-transport-https \
        dirmngr \
        locales \
        gosu \
        gpg-agent \
        dumb-init \
        libc-bin

install_yq

}

function remove_caches() {
    apt-get clean
    rm -rf /var/lib/apt/lists/*
    rm -rf /tmp/*
    rm -rf /var/tmp/*
}

echo en_US.UTF-8 UTF-8 >> /etc/locale.gen

scripts_dir=$(dirname "$0")
# shellcheck source=/dev/null
source "$scripts_dir/sources.sh"
# shellcheck source=/dev/null
source "$scripts_dir/tools.sh"
# shellcheck source=/dev/null
source "$scripts_dir/config.sh"

apt update
install_base_packages
configure_sources

apt update
groupadd -g "$(docker_group_id)" docker || :
install_tools