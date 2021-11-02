#!/usr/bin/env bash

readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

function main() {
    set -euo pipefail
    shopt -s nullglob

    echo "Linking .gitconfig"
    if [[ -e "${HOME}/.gitconfig" ]]; then
        if [[ -e "${HOME}/.gitconfig.bkp" ]]; then
            echo 1>&2 "ERROR: ${HOME}/.gitconfig.bkp already exists, failed to backup current gitconfig, aborting install"
            exit 1
        fi
        echo "Moving ${HOME}/.gitconfig -> ${HOME}/.gitconfig.bkp"
        mv "${HOME}/.gitconfig" "${HOME}/.gitconfig.bkp"
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
