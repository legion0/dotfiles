# Avoid duplicate inclusion
[[ "${__MY_BASHRC_VERSION:-}" != "1" ]] && __MY_BASHRC_VERSION="1" || return 0

source "${HOME}/.bashrc.d/preexec.sh" || {
	echo 1>&2 "Missing preexec.sh"
	return 1
}

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=30000  # The number of commands to remember in the command history

# Enable timestamps in bash_history
HISTTIMEFORMAT="[%F %T %z] "

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

HISTIGNORE="?:??:history*:ls:ll:exit:pwd:clear:mount:reset"

# Save history to file after each command
function __history_append() {
	history -a
}
preexec_functions+=(__history_append)

# disable Ctrl+s terminal suspend
stty -ixon
