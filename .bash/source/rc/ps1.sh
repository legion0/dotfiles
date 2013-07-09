if [ -e __shortPWD.sh ]; then
	source __shortPWD.sh
fi
ENDCOLOR="\e[00m"
COLOR_RED="\e[31m"
if [[ -z "$PROMPT_FRAME_COLOR" ]]; then
	PROMPT_FRAME_COLOR="\e[34m"
	if [[ "${EUID}" == 0 ]]; then
		PROMPT_FRAME_COLOR="\e[31m"
	else
		PROMPT_FRAME_COLOR="\e[34m"
	fi
fi

# default cygwin
#export PS1="\\[\\e]0;\\w\\a\\]\\n\\[\\e[32m\\]\\u@\\h \\[\\e[33m\\]\\w\\[\\e[0m\\]\\n\\\$ "

function __format_cwd {
	if [[ `type -t "__shortPWD"` == 'function' ]]; then
		echo -n "$(__shortPWD)"
	else
		local cwd="$PWD"
		if [[ "$HOME" == ${cwd:0:${#HOME}} ]] ; then
			cwd="~${cwd:${#HOME}}"
		fi
		echo -n $cwd
	fi
}

PROMPT_START="$PROMPT_FRAME_COLOR\342\224\214\$(ret_code=\$? && [[ \$ret_code != 0 ]] && echo \"\342\224\200[$COLOR_RED\$ret_code$PROMPT_FRAME_COLOR]\")\342\224\200[$ENDCOLOR\t$PROMPT_FRAME_COLOR]\342\224\200[\$(if [[ ${EUID} != 0 ]]; then echo -n \"$ENDCOLOR\u@\h\"; else echo -n \"$COLOR_RED\h\"; fi)$PROMPT_FRAME_COLOR]$ENDCOLOR"
PROMPT_END="\n$PROMPT_FRAME_COLOR\342\224\224\342\224\200[$ENDCOLOR\$(__format_cwd)$PROMPT_FRAME_COLOR]\342\224\200> $ENDCOLOR"

if [[ -e gitprompt.sh ]]; then
	export PROMPT_START="$PROMPT_START"
	export PROMPT_END="$PROMPT_END"
else
	export PS1="$PROMPT_START$PROMPT_END"
fi
