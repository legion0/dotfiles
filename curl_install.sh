#!/usr/bin/env bash

function main() {
  set -euo pipefail

	[[ ! -d "${HOME}/.dotfiles" ]] || {
		read -p "${HOME}/.dotfiles already exists, remove? (y/n): " remove_old < /dev/tty;
		if [[ "${remove_old}" == "y" ]]; then
			rm -rf "${HOME}/.dotfiles"
		else
			echo 2>&1 "ERROR: ${HOME}/.dotfiles already exists"
			exit 1
		fi
	}

	echo "Cloning dotfiles repo to ${HOME}/.dotfiles"
	read -p "Use ssh(s) or http(h)? (s/h): " origin_type < /dev/tty;
	local repo_path="https://github.com/legion0/dotfiles.git"
	[[ "${origin_type}" == "h" ]] || {
		repo_path="git@github.com:legion0/dotfiles.git"
	}
	
	which git &>/dev/null || apt_install git "git - distributed version control"
	
	git clone "${repo_path}" "${HOME}/.dotfiles"

	echo "Starting local install"
	"${HOME}/.dotfiles/install.sh"
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
