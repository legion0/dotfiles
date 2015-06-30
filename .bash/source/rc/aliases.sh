alias h='history | less +G'
alias hgrep='history | grep'

if [ -n "$DISPLAY" ]; then
  # Add an "alert" alias for long running commands.  Use like so:
  #   sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
else
  alias alert=beep
fi

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

  # enable color support of ls and also add handy aliases
  alias ls='ls --color=auto'
  alias ll='ls --color=auto -lh'
  alias la='ls --color=auto -hA'

  # grep aliases and color support
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'

  # enable color support for less
  alias less='less -R'
fi
