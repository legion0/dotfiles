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

    echo "Linking: path-manager"
    stow --dotfiles path_manager

    source "${HOME}/.bashrc.d/path_manager.sh" || {
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

    echo "Linking: git_ps1"
    stow --dotfiles git_ps1

    echo "Linking: wait_pid"
    stow --dotfiles wait_pid

    echo "Linking: pwd_short"
    stow --dotfiles pwd_short

    echo "Linking: inputrc"
    stow --dotfiles inputrc

    echo "Linking: tmux_conf"
    stow --dotfiles tmux_conf

    echo "Linking: vimrc"
    stow --dotfiles vimrc

    echo "Linking: ps1_manager"
    stow --dotfiles ps1_manager

    echo "Linking: preexec"
    stow --dotfiles preexec

    echo "Linking: profile"
    if [[ -e "${HOME}/.profile" ]] && [[ ! -L "${HOME}/.profile" ]]; then
        [[ ! -e "${HOME}/.profile.bkp" ]] || {
            echo 1>&2 "ERROR: ${HOME}/.profile.bkp already exists, failed to backup current profile, aborting install"
            exit 1
        }
        mv "${HOME}/.profile" "${HOME}/.profile.bkp"
    fi
    stow --dotfiles profile

    for f in *.local; do
        if [[ -d "${f}" ]]; then
            echo "Linking: ${f}"
            stow --dotfiles "${f}"
        fi
    done

    echo "Done - please restart your shell for changes to take effect"
}

__apt_updated=false

function _update_apt() {
    if ! __apt_updated; then
        echo "Updating apt-get"
        sudo apt-get update
        __apt_updated=true
    fi
}

function apt_install() {
    echo "Installing: ${2}"
    _update_apt
    sudo apt-get install "${1}"
}

main "$@"
