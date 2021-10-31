#!/usr/bin/env bash

function main() {
    readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    [[ -d "${HOME}/.bashrc.d" ]] || {
        echo "Creating directory: ${HOME}/.bashrc.d"
        mkdir -p "${HOME}/.bashrc.d"
    }

    # Backup the original bashrc file if its not a symlink, we will be sourcing it.

    if [[ -e "${HOME}/.bashrc" ]] && [[ ! -L "${HOME}/.bashrc" ]]; then
        echo "Fould old bashrc file at ${HOME}/.bashrc, attempting backup"
        [[ ! -e "${HOME}/.bashrc.d/0.original_bashrc.sh" ]] || {
            echo 1>&2 "ERROR: ${HOME}/.bashrc.d/0.original_bashrc.sh already exists, failed to backup current bashrc, aborting install"
            exit 1
        }
        echo "Moving  ${HOME}/.bashrc to ${HOME}/.bashrc.d/0.original_bashrc.sh"
        mv "${HOME}/.bashrc" "${HOME}/.bashrc.d/0.original_bashrc.sh"
    fi

    if [[ ! -e "${HOME}/.bashrc" ]] || [[ "$(readlink -f "${HOME}/.bashrc")" != "${SCRIPT_DIR}/bashrc.sh" ]]; then
        echo "Removing old link ${HOME}/.bashrc -> $(readlink -f "${HOME}/.bashrc")"
        rm -f "${HOME}/.bashrc"
        echo "Linking ${HOME}/.bashrc -> ${SCRIPT_DIR}/bashrc.sh"
        ln -s "${SCRIPT_DIR}/bashrc.sh" "${HOME}/.bashrc"
    fi
}

main "$@"
