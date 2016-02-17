# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

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
if [[ "${PROMPT_COMMAND}" != *" __history_append;"* ]]; then
	PROMPT_COMMAND="${PROMPT_COMMAND} __history_append;"
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# disable Ctrl+s terminal suspend
stty -ixon
