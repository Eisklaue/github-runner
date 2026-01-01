#!/usr/bin/env bash

set -euo pipefail

function config_yml() {
    echo "$(dirname "${BASH_SOURCE[0]}")/config.yml"
}

function user_id() {
    yq '.user.id' "$(config_yml)"
}

function group_id() {
    yq '.user.group-id' "$(config_yml)"
}

function docker_group_id() {
    yq '.user.docker-group-id' "$(config_yml)"
}

function get_script_packages() {
   yq '.install[] | select(.source == "script") | .packages[]' "$(config_yml)"
}