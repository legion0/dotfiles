#!/usr/bin/env bash

printf "\001"; term color "${PROMPT_FRAME_COLOR}"; printf "\002"
echo -n "${PS1_BASHPID}"
printf "\001"; term reset; printf "\002"
