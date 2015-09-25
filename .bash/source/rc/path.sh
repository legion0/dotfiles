function __add_to_path() {
	local var_name='PATH'
	[ $# -eq 2 ] && var_name="$2"
	local var_val=''
	eval var_val="\$$var_name"
	if [ -d "$1" ] && [[ "$var_val" != *"$1"* ]]; then
		if [[ "$var_val" != *":"* ]]; then
			eval export $var_name="$1"
		else
			eval export $var_name="$var_val:$1"
		fi
	fi
}


__add_to_path "${HOME}/info" INFOPATH
__add_to_path "${HOME}/man" MANPATH

__add_to_path "$HOME/bin"
__add_to_path "/usr/local/go/bin"
__add_to_path "/usr/local/heroku/bin"

