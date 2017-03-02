export PS4='$0:$LINENO+ '
#set -xe
#trap 'echo sleep 100; sleep 100' EXIT


# If not running interactively, don't do anything
[ -n "$PS1" ] || [[ $- == *i* ]] || return

# make less more friendly for non-text input files, see lesspipe(1)
[ ! -x /usr/bin/lesspipe ] || eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi

# set a fancy prompt (non-color, unless we know we "want" color)
#function check_color_support() {
#	if [ "$TERM" == "xterm-color" ]; then
#		return 0
#	fi
#	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#		return 0
#	fi
#}
#if [ check_color_support ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi

# If this is an xterm set the title to user@host:dir
#if [ "$TERM" == "xterm*" -o "$TERM" == "rxvt*" ]; then
#	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /etc/bash_completion ]; then
		source /etc/bash_completion
	fi
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		source /usr/share/bash-completion/bash_completion
	fi
fi

# Extra sources
for f in ~/.bash/source/rc/*.sh; do
  test -f "$f" || continue
  source "$f"
done

# TMUX
if which tmux &>/dev/null && [[ -z "$TMUX" ]]; then
    tmux -u new-session
fi

