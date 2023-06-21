#!/usr/bin/env bash

# echo "\$(ret_code=\$? && [[ \$ret_code -ne 0 ]] && echo \"$_DASH[$COLOR_RED\$ret_code$PROMPT_FRAME_COLOR]\")"

if [[ "${PS1_RET_CODE}" != "0" ]]; then
	printf "\001"; term color red; printf "\002"
	echo -n "${PS1_RET_CODE:-}"
	printf "\001"; term reset; printf "\002"
else
	echo -n "0"
fi
