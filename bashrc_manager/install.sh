#!/usr/bin/env bash

readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

[[ -d "${HOME}/.bashrc.d" ]] || {
    echo "Creating directory: ${HOME}/.bashrc.d"
    mkdir -p "${HOME}/.bashrc.d"
}

# Backup the original bashrc file if its not a symlink, we will be sourcing it.
[[ ! -f "${HOME}/.bashrc" ]] || [[ -f "${HOME}/.bashrc.d/original_bashrc.sh" ]] || {
    echo "Moving  ${HOME}/.bashrc to ${HOME}/.bashrc.d/original_bashrc.sh"
    mv "${HOME}/.bashrc" "${HOME}/.bashrc.d/original_bashrc.sh"
}

rm -f "${HOME}/.bashrc"

# Install the new bashrc as a symlink.
ln "${SCRIPT_DIR}/bashrc.sh" "${HOME}/.bashrc"
