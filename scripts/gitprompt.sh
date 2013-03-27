if [ "x$__GIT_PROMPT_DIR" == "x" ]
then
  __GIT_PROMPT_DIR=~/.bash
fi

# Colors
# Reset
ResetColor="\[\e[m\]"       # Text Reset

# Regular Colors
Red="\[\e[31m\]"          # Red
Yellow="\[\e[33m\]"       # Yellow
Blue="\[\e[34m\]"         # Blue
WHITE="\[\e[37m\]"

# Bold
BGreen="\[\e[1;32m\]"       # Green

# High Intensty
IBlack="\[\e[0;90m\]"       # Black

# Bold High Intensty
Magenta="\[\e[1;95m\]"     # Purple

# Various variables you might want for your PS1 prompt instead
Time12a="\@"
PathShort="\w"

# Default values for the appearance of the prompt. Configure at will.
GIT_PROMPT_PREFIX="["
GIT_PROMPT_SUFFIX="]"
GIT_PROMPT_SEPARATOR=" "
GIT_PROMPT_BRANCH="${Magenta}"
GIT_PROMPT_STAGED="${Red}S"
GIT_PROMPT_CONFLICTS="${Red}F"
GIT_PROMPT_CHANGED="${Blue}C"
GIT_PROMPT_REMOTE=" "
GIT_PROMPT_UNTRACKED="U"
GIT_PROMPT_CLEAN="${BGreen}V"

PROMPT_START="($?)\!|$COLOR1\u@\h$ENDCOLOR $COLOR2\w$ENDCOLOR"
PROMPT_END="\n$ "
#PROMPT_START="$Yellow$PathShort$ResetColor"
#PROMPT_END=" \n$WHITE$Time12a$ResetColor $ "


function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS
    local gitstatus="${__GIT_PROMPT_DIR}/gitstatus.py"

    _GIT_STATUS=$(python $gitstatus)
    __CURRENT_GIT_STATUS=($_GIT_STATUS)
	GIT_BRANCH=${__CURRENT_GIT_STATUS[0]}
	GIT_REMOTE=${__CURRENT_GIT_STATUS[1]}
    if [[ "." == "$GIT_REMOTE" ]]; then
		unset GIT_REMOTE
	fi
	GIT_STAGED=${__CURRENT_GIT_STATUS[2]}
	GIT_CONFLICTS=${__CURRENT_GIT_STATUS[3]}
	GIT_CHANGED=${__CURRENT_GIT_STATUS[4]}
	GIT_UNTRACKED=${__CURRENT_GIT_STATUS[5]}
	GIT_CLEAN=${__CURRENT_GIT_STATUS[6]}
}

function setGitPrompt() {
	update_current_git_vars
	set_virtualenv

	if [ -n "$__CURRENT_GIT_STATUS" ]; then
	  STATUS=" $GIT_PROMPT_PREFIX$GIT_PROMPT_BRANCH$GIT_BRANCH$ResetColor"

	  if [ -n "$GIT_REMOTE" ]; then
		  STATUS="$STATUS$GIT_PROMPT_REMOTE$GIT_REMOTE$ResetColor"
	  fi

	  STATUS="$STATUS$GIT_PROMPT_SEPARATOR"
	  if [ "$GIT_STAGED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_STAGED$GIT_STAGED$ResetColor"
	  fi

	  if [ "$GIT_CONFLICTS" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CONFLICTS$GIT_CONFLICTS$ResetColor"
	  fi
	  if [ "$GIT_CHANGED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CHANGED$GIT_CHANGED$ResetColor"
	  fi
	  if [ "$GIT_UNTRACKED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_UNTRACKED$GIT_UNTRACKED$ResetColor"
	  fi
	  if [ "$GIT_CLEAN" -eq "1" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CLEAN"
	  fi
	  STATUS="$STATUS$ResetColor$GIT_PROMPT_SUFFIX"

	  PS1="$PYTHON_VIRTUALENV$PROMPT_START$STATUS$PROMPT_END"
	else
	  PS1="$PROMPT_START$PROMPT_END"
	fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${BLUE}(`basename \"$VIRTUAL_ENV\"`)${ResetColor} "
  fi
}

PROMPT_COMMAND=setGitPrompt
