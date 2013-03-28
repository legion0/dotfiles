ENDCOLOR='\[\e[m\]'
COLOR1="\[\e[32m\]"
COLOR2="\[\e[33m\]"
COLOR3="\[\e[34m\]"
COLOR_RED="\[\e[31m\]"

# default cygwin
#export PS1="\\[\\e]0;\\w\\a\\]\\n\\[\\e[32m\\]\\u@\\h \\[\\e[33m\\]\\w\\[\\e[0m\\]\\n\\\$ "

# with git branch
#export PS1="$COLOR1\u@\h$ENDCOLOR $COLOR2\w$ENDCOLOR$COLOR3$(__git_ps1 " (%s)")$ENDCOLOR\n$ "
#export PS1="($?)\!|$COLOR1\u@\h$ENDCOLOR $COLOR2\w$ENDCOLOR$COLOR3$(__git_ps1 " (%s)")$ENDCOLOR\n$ "

# for git-prompt.sh

function __format_ret {
	r=$?
	if (($r != 0)); then
		echo "$r "
	fi
}

export PROMPT_START="$COLOR_RED\$(__format_ret)$ENDCOLOR$COLOR1\u@\h$ENDCOLOR $COLOR2\$(__shortPWD)$ENDCOLOR"
export PROMPT_END="\n\! $ "
