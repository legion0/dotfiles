if [ "x$__GIT_PROMPT_DIR" == "x" ]
then
  __GIT_PROMPT_DIR=~/.bash
fi

# Colors
# Reset
ResetColor="\e[m"       # Text Reset

# Regular Colors
Red="\e[31m"          # Red
Yellow="\e[33m"       # Yellow
Blue="\e[34m"         # Blue
WHITE="\e[37m"

# Bold
BGreen="\e[1;32m"       # Green

# High Intensty
IBlack="\e[0;90m"       # Black

# Bold High Intensty
Magenta="\e[1;95m"     # Purple

# Various variables you might want for your PS1 prompt instead
Time12a="\@"
PathShort="\w"

# Default values for the appearance of the prompt. Configure at will.
GIT_PROMPT_PREFIX="["
GIT_PROMPT_SUFFIX="]"
GIT_PROMPT_SEPARATOR=" "
GIT_PROMPT_BRANCH="${Magenta}"
GIT_PROMPT_STAGED="${BGreen}S"
GIT_PROMPT_CONFLICTS="${Red}D"
GIT_PROMPT_CHANGED="${Yellow}M"
GIT_PROMPT_REMOTE=" "
GIT_PROMPT_UNTRACKED="U"
GIT_PROMPT_OTHER="O"
GIT_PROMPT_CLEAN="${BGreen}V"

if [ -e ps1.sh ]; then
	source ps1.sh
fi


function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS
    local gitstatus="${__GIT_PROMPT_DIR}/gitstatus.py"

    _GIT_STATUS=$(python3 $gitstatus)
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
	GIT_OTHER=${__CURRENT_GIT_STATUS[6]}
	GIT_CLEAN=${__CURRENT_GIT_STATUS[7]}
}


function ps1_git() {
	git rev-parse --show-toplevel > /dev/null 2>&1 || return 0

	update_current_git_vars

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
	  if [ "$GIT_OTHER" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_OTHER$GIT_OTHER$ResetColor"
	  fi
	  if [ "$GIT_CLEAN" -eq "1" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CLEAN"
	  fi
	  STATUS="$STATUS$ResetColor$GIT_PROMPT_SUFFIX"

	  echo -ne "$STATUS"
	fi
}

