#!/usr/bin/env bash

set -euo pipefail

function install_git() {
    ( apt install -y --no-install-recommends git \
    || apt install -t stable -y --no-install-recommends git )
}

function install_git-lfs() {
    local DPKG_ARCH
    DPKG_ARCH="$(dpkg --print-architecture)"
    GIT_LFS_VERSION=$(curl -sL -H "Accept: application/vnd.github+json" \
        https://api.github.com/repos/git-lfs/git-lfs/releases/latest \
        | jq -r '.tag_name' | sed 's/^v//g')

    curl -s "https://github.com/git-lfs/git-lfs/releases/download/v${GIT_LFS_VERSION}/git-lfs-linux-${DPKG_ARCH}-v${GIT_LFS_VERSION}.tar.gz" -L -o /tmp/lfs.tar.gz
    tar -xzf /tmp/lfs.tar.gz -C /tmp
    "/tmp/git-lfs-${GIT_LFS_VERSION}/install.sh"
    rm -rf /tmp/lfs.tar.gz "/tmp/git-lfs-${GIT_LFS_VERSION}"
}


function install_tools() {
    local function_name
    # shellcheck source=/dev/null
    source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
    get_script_packages | while read -r package; do
        function_name="install_${package}"
        if declare -f "${function_name}" > /dev/null; then
        "${function_name}"
        else
        echo "No install script found for package: ${package}"
        exit 1
        fi
    done
}