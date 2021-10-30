# Avoid duplicate inclusion
[[ "${__PS1_MANAGER_VERSION:-}" != "1" ]] && __PS1_MANAGER_VERSION="1" || return 0

function __build_ps1() {
	export PS1_RET_CODE="$?"
	export PS1_BASHPID="$$"
	[[ "${PROMPT_FRAME_COLOR:-}" != "" ]] || export PROMPT_FRAME_COLOR="blue"

	printf "\n"
	printf "\001"; term color blue; printf "\002"
	printf "┌"
	[[ ! -d "${HOME}/.ps1.d" ]] || {
		local ps1_part
		local first=true
		for f in "${HOME}/.ps1.d/"*.sh; do
			ps1_part="$(${f})"
			if [[ "${ps1_part}" == "lf" ]]; then
				printf "\n"
				printf "└"
			else
				if ${first}; then
					first=false
				else
					printf "─"
				fi
				printf "["
				printf "\001"; term reset; printf "\002"
				printf "${ps1_part}"
				printf "\001"; term color blue; printf "\002"
				printf "]"
			fi
		done
	}
	printf "─>"
	printf "\001"; term reset; printf "\002"
}

export PS1="\$(__build_ps1)"
