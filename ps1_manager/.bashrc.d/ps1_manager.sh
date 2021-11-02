# Avoid duplicate inclusion
[[ "${__PS1_MANAGER_VERSION:-}" != "1" ]] && __PS1_MANAGER_VERSION="1" || return 0

function ps1_manager::print_frame() {
	printf "\001"; term color blue; printf "\002"; printf "${1}"; printf "\001"; term reset; printf "\002"
}

function ps1_manager::build_ps1() {
	export PS1_RET_CODE="$?"
	export PS1_BASHPID="$$"
	[[ "${PROMPT_FRAME_COLOR:-}" != "" ]] || export PROMPT_FRAME_COLOR="blue"

	printf "\n"
	ps1_manager::print_frame "┌"
	[[ ! -e "${HOME}/.ps1.d/ps1.modules.order" ]] || {
		local ps1_part
		local first=true
		mapfile -t modules < "${HOME}/.ps1.d/ps1.modules.order"
		for f in "${modules[@]}"; do
			[[ -e "${HOME}/.ps1.d/${f}" ]] || continue
			ps1_part="$(${HOME}/.ps1.d/${f})"
			if [[ "${ps1_part}" == "lf" ]]; then
				printf "\n"
				ps1_manager::print_frame "└"
			else
				if ${first}; then
					first=false
				else
					ps1_manager::print_frame "─"
				fi
				ps1_manager::print_frame "["
				printf "${ps1_part}"
				ps1_manager::print_frame "]"
			fi
		done
	}
	ps1_manager::print_frame "─>"
}

function ps1_manager::update_ps1_order() {
	(
		shopt -s nullglob
		local new_order
		new_order="$(mktemp)"
		if [[ -e "${HOME}/.ps1.d/ps1.modules.order" ]]; then
			cp "${HOME}/.ps1.d/ps1.modules.order" "${new_order}"
		fi

		# Add new files that are not yet in the order
		for f in "${HOME}/.ps1.d/"*.sh; do
			f="$(basename "${f}")"
			grep "^${f}$" "${new_order}" &>/dev/null || {
				echo "${f}" >> "${new_order}"
			}
		done

		cat "${new_order}" > "${HOME}/.ps1.d/ps1.modules.order"
		rm -f "${new_order}"
	)
}
ps1_manager::update_ps1_order
unset ps1_manager::update_ps1_order

export PS1="\$(ps1_manager::build_ps1)"
