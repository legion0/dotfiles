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

function __loas_ps1 {
  local loas_remaining
	loas_remaining="$(prodcertstatus 2>/dev/null | cut -d' ' -f 5)"
  if [[ "$loas_remaining" == "" ]]; then
    echo "LOAS 0h"
  else
    echo "LOAS $loas_remaining"
  fi
}

_DASH="\342\224\200"

PS1="\n$PROMPT_FRAME_COLOR\342\224\214"
# Shell PID
PS1+="["
PS1+="\$BASHPID"
PS1+="]"
# Return code
PS1+="\$(ret_code=\$? && [[ \$ret_code -ne 0 ]] && echo \"$_DASH[$COLOR_RED\$ret_code$PROMPT_FRAME_COLOR]\")"
# Date
PS1+="$_DASH[$ENDCOLOR"
PS1+="\$(date --iso-8601=seconds)"
PS1+="$PROMPT_FRAME_COLOR]"
# User@Host
PS1+="$_DASH[$ENDCOLOR"
PS1+="\$(if [[ ${EUID} -ne 0 ]]; then echo -n \"\u@\h\"; else echo -n \"$COLOR_RED\h\"; fi)"
PS1+="$PROMPT_FRAME_COLOR]"
# Custom Str
PS1+="\$(if [ -n \"\${PS1_CUSTOM_STR}\" ]; then echo -n \"$_DASH[${ENDCOLOR}${COLOR_RED}\${PS1_CUSTOM_STR}${ENDCOLOR}${PROMPT_FRAME_COLOR}]\"; fi)"
if [[ `type -t "__loas_ps1"` == 'function' ]]; then
	PS1+="\$(echo -n \"$_DASH[${ENDCOLOR}\$(__loas_ps1)${ENDCOLOR}${PROMPT_FRAME_COLOR}]\")"
fi
PS1+="\$(if [ -n \"\${__hi_on_prompt}\" ]; then echo -n \"$_DASH[${ENDCOLOR}\${__hi_prompt_color}\${__hi_prompt_text}${ENDCOLOR}${PROMPT_FRAME_COLOR}]\"; fi)"
PS1+="${ENDCOLOR}"

script_dir="$(dirname "$BASH_SOURCE[0]")"

if [ -f "${script_dir}/000.ps1_git.sh" ]; then
	PS1="$PS1\$(ps1_git)"
fi

PS1="$PS1\n$PROMPT_FRAME_COLOR\342\224\224$_DASH[$ENDCOLOR\$(__format_cwd)$PROMPT_FRAME_COLOR]$_DASH>$ENDCOLOR "
export PS1

export PS4="[\$(date +%H:%M:%S)][\$0:\$LINENO]+ "

