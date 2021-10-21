
which fzf &>/dev/null || return 0

fuzzy_history_complete() {
#  READLINE_LINE="$(cat ~/.bash_history | sed 's/[ \t]*$//' | sort -u | fzf --query="$READLINE_LINE")"
  READLINE_LINE="$(cat ~/.bash_history | grep -v '^#[0-9]\+$' | sed 's/[ \t]*$//' | fzf --query="$READLINE_LINE" --tac --no-sort)"
  READLINE_POINT=${#READLINE_LINE}
}

bind -x '"\C-e" : fuzzy_history_complete'

