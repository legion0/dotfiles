# Avoid duplicate inclusion
[[ "${__PS1_MANAGER_VERSION:-}" != "1" ]] && __PS1_MANAGER_VERSION="1" || return 0

function __build_ps1() {
	export PS1_RET_CODE="$?"
	export PS1_BASHPID="$$"
	[[ "${PROMPT_FRAME_COLOR:-}" != "" ]] || export PROMPT_FRAME_COLOR="blue"

	printf "\n"
	printf "\001"; term color blue; printf "\002"
	printf "┌"
	[[ ! -e "${HOME}/.ps1.d/ps1.modules.order" ]] || {
		local ps1_part
		local first=true
		mapfile -t modules < "${HOME}/.ps1.d/ps1.modules.order"
		for f in "${modules[@]}"; do
			ps1_part="$(${HOME}/.ps1.d/${f})"
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

function ps1_manager::update_ps1_order() {
	(
		shopt -s nullglob
		local current_files
		current_files="$(mktemp)"
		local new_order
		new_order="$(mktemp)"
		if [[ -e "${HOME}/.ps1.d/ps1.modules.order" ]]; then
			cp "${HOME}/.ps1.d/ps1.modules.order" "${new_order}"
		fi

		# Add new files that are not yet in the order
		for f in "${HOME}/.ps1.d/"*.sh; do
			f="$(basename "${f}")"
			echo "${f}" >> "${current_files}"
			grep "^${f}$" "${new_order}" &>/dev/null || {
				echo "${f}" >> "${new_order}"
			}
		done

		# Intersect new order with existing files to remove missing files
		local final_order
		final_order="$(mktemp)"

		# Truncate deleted files
		# comm -12 "${new_order}" "${current_files}" > "${final_order}"
		while IFS= read -r new_order_file; do
			while IFS= read -r current_file; do
				if [[ "${new_order_file}" == "${current_file}" ]]; then
					echo "${new_order_file}" >> "${final_order}"
				fi
			done < "${current_files}"
		done < "${new_order}"

		cat "${final_order}" > "${HOME}/.ps1.d/ps1.modules.order"
		rm -f "${current_files}" "${new_order}"
	)
}

ps1_manager::update_ps1_order
unset ps1_manager::update_ps1_order

export PS1="\$(__build_ps1)"
