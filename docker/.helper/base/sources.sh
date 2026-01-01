#!/usr/bin/env bash

set -euo pipefail

function configure_git() {
    # shellcheck source=/dev/null
    source /etc/os-release

    local GIT_CORE_PPA_KEY="A1715D88E1DF1F24"

    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys ${GIT_CORE_PPA_KEY}
    gpg --export ${GIT_CORE_PPA_KEY} | gpg --dearmor -o /usr/share/keyrings/git-core.gpg
}

function configure_sources() {
    configure_git
}

function remove_sources() {
    rm -f /etc/apt/sources.list.d/git-core.list
}