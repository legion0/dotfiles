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

function __reload_bashrc_if_changed() {
	(( "$(stat -c%Y ~/.bashrc)" <= $__BASHRC_MTIME )) || {
		source ~/.bashrc
		__BASHRC_MTIME="$(stat -c%Y ~/.bashrc)"
	}
}
__BASHRC_MTIME="$(stat -c%Y ~/.bashrc)"
#precmd_functions+=(__reload_bashrc_if_changed)

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# disable Ctrl+s terminal suspend
stty -ixon

