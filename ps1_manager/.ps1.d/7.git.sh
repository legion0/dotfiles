if [ "x$__GIT_PROMPT_DIR" == "x" ]
then
  __GIT_PROMPT_DIR=~/.bash
fi

# Colors
# Reset
ResetColor="\001\e[m\002"       # Text Reset

# Regular Colors
Red="\001\e[31m\002"          # Red
Yellow="\001\e[33m\002"       # Yellow
Blue="\001\e[34m\002"         # Blue
WHITE="\001\e[37m\002"

# Bold
BGreen="\001\e[1;32m\002"       # Green

# High Intensty
IBlack="\001\e[0;90m\002"       # Black

# Bold High Intensty
Magenta="\001\e[1;95m\002"     # Purple

# Default values for the appearance of the prompt. Configure at will.
GIT_PROMPT_SEPARATOR=" "
GIT_PROMPT_BRANCH="${Magenta}"
GIT_PROMPT_STAGED="${BGreen}S"
GIT_PROMPT_CONFLICTS="${Red}D"
GIT_PROMPT_CHANGED="${Yellow}M"
GIT_PROMPT_REMOTE=" "
GIT_PROMPT_UNTRACKED="U"
GIT_PROMPT_OTHER="O"
GIT_PROMPT_CLEAN="${BGreen}V"

function ps1_git() {
	git rev-parse --show-toplevel > /dev/null 2>&1 || return 0

	unset __CURRENT_GIT_STATUS
	local git_ps1="$(which "git_ps1.py" 2>/dev/null)"
	[[ "${git_ps1}" != "" ]] || {
		echo -n "missing git_ps1.py"
		return 0
	}

	_GIT_STATUS="$(python3 "${git_ps1}")"
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

	if [ -n "$__CURRENT_GIT_STATUS" ]; then
	  STATUS="$GIT_PROMPT_BRANCH$GIT_BRANCH$ResetColor"

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
	  STATUS="$STATUS$ResetColor"

	  echo -ne "$STATUS"
	fi
}

ps1_git
