#!/bin/bash

test -n "${_PROMPT_COMMAND__HEADER_GUARD:-}" || _PROMPT_COMMAND__HEADER_GUARD=""
[[ "$_PROMPT_COMMAND__HEADER_GUARD" != "$BASHRC_LAST_SOURCE" ]] || return 0
_PROMPT_COMMAND__HEADER_GUARD="$BASHRC_LAST_SOURCE"


_PROMPT_COMMAND__COMMANDS_ARRAY=()

function __prompt_command() {
  for func in "${_PROMPT_COMMAND__COMMANDS_ARRAY[@]:+"${_PROMPT_COMMAND__COMMANDS_ARRAY[@]}"}"; do
    $func
  done
}

PROMPT_COMMAND="__prompt_command"


function PROMPT_COMMAND::add() {
  _PROMPT_COMMAND__COMMANDS_ARRAY+=("$1")
}

