#!/usr/bin/env bash

readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

function main() {
    set -euo pipefail
    shopt -s nullglob

    echo "Linking .gitconfig"
    local backup_path
    backup_path="${HOME}/.gitconfig.$(date --iso-8601=seconds | tr -dc '0-9').bkp"
    if [[ -e "${HOME}/.gitconfig" ]]; then
        echo "Moving existing ${HOME}/.gitconfig -> ${backup_path}"
        mv "${HOME}/.gitconfig" "${backup_path}"
    fi
    echo "Creating link ${HOME}/.gitconfig -> ${SCRIPT_DIR}/.gitconfig"
    ln -s "${SCRIPT_DIR}/.gitconfig" "${HOME}/.gitconfig"

    echo "Copying .gitconfig_local"
    if [[ -e "${HOME}/.gitconfig_local" ]]; then
        echo "${HOME}/.gitconfig_local already exists, skipping"
    else
        echo "Copying ${SCRIPT_DIR}/.gitconfig_local -> ${HOME}/.gitconfig_local"
        cp "${SCRIPT_DIR}/.gitconfig_local" "${HOME}/.gitconfig_local"
    fi
}

main "$@"
