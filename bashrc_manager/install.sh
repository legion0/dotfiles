#!/usr/bin/env bash

function main() {
    readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    [[ -d "${HOME}/.bashrc.d" ]] || {
        echo "Creating directory: ${HOME}/.bashrc.d"
        mkdir -p "${HOME}/.bashrc.d"
    }

    # Backup the original bashrc file if its not a symlink, we will be sourcing it.

    local backup_path
    backup_path="${HOME}/.bashrc.$(date --iso-8601=seconds | tr -dc '0-9').bkp"
    if [[ -e "${HOME}/.bashrc" ]]; then
        echo "Moving existing ${HOME}/.bashrc -> ${backup_path}"
        mv "${HOME}/.bashrc" "${backup_path}"
    fi

    echo "Linking ${HOME}/.bashrc -> ${SCRIPT_DIR}/bashrc.sh"
    ln -s "${SCRIPT_DIR}/bashrc.sh" "${HOME}/.bashrc"
}

main "$@"
