if [ -e __shortPWD.sh ]; then
	source __shortPWD.sh
fi
ENDCOLOR='\[\e[m\]'
COLOR1="\[\e[32m\]"
COLOR2="\[\e[33m\]"
COLOR3="\[\e[34m\]"
COLOR_RED="\[\e[31m\]"

# default cygwin
#export PS1="\\[\\e]0;\\w\\a\\]\\n\\[\\e[32m\\]\\u@\\h \\[\\e[33m\\]\\w\\[\\e[0m\\]\\n\\\$ "

function __format_ret {
	r=$?
	if (($r != 0)); then
		echo " | $COLOR_RED$r$ENDCOLOR"
	fi
}

function __format_cwd {
	if [[ `type -t "__shortPWD"` == 'function' ]]; then
		echo "$(__shortPWD)"
	else
		local cwd="$PWD"
		if [[ "$HOME" == ${cwd:0:${#HOME}} ]] ; then
			cwd="~${cwd:${#HOME}}"
		fi
		echo $cwd
	fi
}
PROMPT_START="\!\$(__format_ret) [$COLOR1\u@\h$ENDCOLOR $COLOR2\$(__format_cwd)$ENDCOLOR]"
PROMPT_END=" $ "

if [[ -e gitprompt.sh ]]; then
	export PROMPT_START="$PROMPT_START"
	export PROMPT_END="$PROMPT_END"
else
	export PS1="$PROMPT_START$PROMPT_END"
fi
