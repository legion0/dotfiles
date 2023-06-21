#!/usr/bin/env bash

readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

function main() {
    set -euo pipefail
    shopt -s nullglob

    [[ "${SCRIPT_DIR}" == "$PWD" ]] || {
        echo "Changing wroking directory to ${SCRIPT_DIR}"
        cd "${SCRIPT_DIR}"
    }

    # which jq &>/dev/null || {
    #     apt_install jq "jq - command-line JSON processor"
    # }

    # which basher &>/dev/null || {
    #     echo "Installing: basher - package manager for shell scripts and functions"
    #     curl -s https://raw.githubusercontent.com/basherpm/basher/master/install.sh | bash
    # }

    which git &>/dev/null || apt_install git "git - distributed version control"

    which stow &>/dev/null || apt_install stow "stow - package manager for shell scripts and functions"
    
    which make &>/dev/null || apt_install build-essential "build-essential - make"

    source "${SCRIPT_DIR}/path_manager/.bashrc.d/path_manager.sh" || {
        echo 2>&1 "ERROR: Failed to source path_manager.sh"
        exit 1
    }

    add_directory_to_path "${HOME}/.local/bin"

    which bpkg &>/dev/null || {
        echo "Installing: bpkg - bash package manager"
        curl -Lo- "https://raw.githubusercontent.com/bpkg/bpkg/master/setup.sh" | bash
    }

    which term &>/dev/null || {
        echo "Installing: term - Terminal fun"
        bpkg install term -g
    }

    [[ ! -f "${SCRIPT_DIR}/bashrc_manager/install.sh" ]] || {
        echo "Installing: bashrc manager - modular bashrc files"
        "${SCRIPT_DIR}/bashrc_manager/install.sh"
    }

    [[ ! -f "${SCRIPT_DIR}/gitconfig/install.sh" ]] || {
        echo "Installing: gitconfig files"
        "${SCRIPT_DIR}/gitconfig/install.sh"
    }

    echo "Linking: path-manager"
    stow --no-folding -t "${HOME}" --dotfiles path_manager

    echo "Linking: my_bashrc"
    stow --no-folding -t "${HOME}" --dotfiles my_bashrc

    echo "Linking: git_ps1"
    stow --no-folding -t "${HOME}" --dotfiles git_ps1

    echo "Linking: wait_pid"
    stow --no-folding -t "${HOME}" --dotfiles wait_pid

    echo "Linking: pwd_short"
    stow --no-folding -t "${HOME}" --dotfiles pwd_short

    echo "Linking: inputrc"
    stow --no-folding -t "${HOME}" --dotfiles inputrc

    echo "Linking: tmux_conf"
    stow --no-folding -t "${HOME}" --dotfiles tmux_conf

    echo "Linking: vimrc"
    stow --no-folding -t "${HOME}" --dotfiles vimrc

    echo "Linking: ps1_manager"
    stow --no-folding -t "${HOME}" --dotfiles ps1_manager

    echo "Linking: preexec"
    stow --no-folding -t "${HOME}" --dotfiles preexec

    echo "Linking: profile"
    local backup_path
    backup_path="${HOME}/.profile.$(date --iso-8601=seconds | tr -dc '0-9').bkp"
    if [[ -e "${HOME}/.profile" ]]; then
        echo "Moving existing ${HOME}/.profile -> ${backup_path}"
        mv "${HOME}/.profile" "${backup_path}"
    fi
    stow --no-folding -t "${HOME}" --dotfiles profile

    echo "Done - please restart your shell for changes to take effect"
}

__apt_updated=false

function _update_apt() {
    if ! __apt_updated; then
        echo "Updating apt"
        sudo apt update
        __apt_updated=true
    fi
}

function apt_install() {
    echo "Installing: ${2}"
    _update_apt
    sudo apt install -y "${1}"
}

main "$@"
