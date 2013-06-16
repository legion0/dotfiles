function __shortPWD {
	local prefix="..."
	local maxlength=35

	local cwd="$PWD"
	if [[ "$HOME" == ${cwd:0:${#HOME}} ]] ; then
        cwd="~${cwd:${#HOME}}"
    fi

	local prefixlen=${#prefix}
	local truemaxlen=$(($maxlength-$prefixlen-1))
	local currlen=${#cwd}
	if (($currlen<=$maxlength)); then
		echo -n $cwd
		return
	fi

	local newres=""
	local dirname="$cwd"
	local res=${dirname##*/}
	local dirname=${dirname%/*}
	while true; do
		part=${dirname##*/}
		if [[ $part == $dirname ]]; then
			break
		fi
		dirname=${dirname%/*}
		newres="$part/$res"
		if (( ${#newres} > $truemaxlen )); then
			break
		fi
		res=$newres
	done
	echo -n "$prefix/$res"
}

