# Avoid duplicate inclusion
[[ "${__PATH_MANAGER_VERSION:-}" != "1" ]] && __PATH_MANAGER_VERSION="1" || return 0

function add_directory_to_path() {
    IFS=':' read -r -a path_parts <<< "${PATH}"
    local already_in_path=false
    for directory in "${path_parts[@]}"; do
        if [[ "${directory}" == "$1" ]]; then
          already_in_path=true
          break
        fi
    done
	if ${already_in_path}; then
      return
    fi
    if [[ "${PATH:-}" == "" ]]; then
        export PATH="${1}"
    else
        export PATH="${PATH}:${1}"
    fi
}

export -f add_directory_to_path

add_directory_to_path "${HOME}/.local/bin"
