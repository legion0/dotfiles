alias h='history | less +G'
alias hgrep='history | grep'
alias timestamp="date +'%Y%m%d_%H%M%S'"

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
