if [ -e __shortPWD.sh ]; then
	source __shortPWD.sh
fi
ENDCOLOR="\[\e[00m\]"
COLOR_RED="\[\e[31m\]"
if [[ -z "$PROMPT_FRAME_COLOR" ]]; then
	PROMPT_FRAME_COLOR="\[\e[34m\]"
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

if [ -z "$PS1_CUSTOM_STR" ]; then
	export PS1_CUSTOM_STR=""
fi

PS1="$PROMPT_FRAME_COLOR\342\224\214\$(ret_code=\$? && [[ \$ret_code -ne 0 ]] && echo \"\342\224\200[$COLOR_RED\$ret_code$PROMPT_FRAME_COLOR]\")\342\224\200[$ENDCOLOR\t$PROMPT_FRAME_COLOR]\342\224\200[\$(if [[ ${EUID} -ne 0 ]]; then echo -n \"$ENDCOLOR\u@\h\"; else echo -n \"$COLOR_RED\h\"; fi)$PROMPT_FRAME_COLOR]\$(if [ -n \"\${PS1_CUSTOM_STR}\" ]; then echo -n \"\342\224\200[${ENDCOLOR}${COLOR_RED}\${PS1_CUSTOM_STR}${ENDCOLOR}${PROMPT_FRAME_COLOR}]\"; fi)${ENDCOLOR}"

script_dir="$(dirname "$BASH_SOURCE[0]")"

if [ -f "${script_dir}/000.ps1_git.sh" ]; then
	PS1="$PS1\$(ps1_git)"
fi

PS1="$PS1\n$PROMPT_FRAME_COLOR\342\224\224\342\224\200[$ENDCOLOR\$(__format_cwd)$PROMPT_FRAME_COLOR]\342\224\200>$ENDCOLOR "
export PS1

export PS4="[\$(date +%H:%M:%S)][\$0:\$LINENO]+ "

