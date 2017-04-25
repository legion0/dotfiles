function mkdir2 {
	mkdir "$1" && cd "$1";
}
function git-dist {
	local str=`git rev-list --left-right $1...$2 | cut -c 1-1`;
	str="${str//[^\<\>]}"
	local str2="${str//[^\<]}"
	local total="${#str}"
	local ahead="${#str2}"
	local behind="$(($total - $ahead))"
	echo "A $ahead B $behind";
}

function sleep-minutes() {
	local minutes=$1
	sleep $(($minutes * 60))
}

function sleep-hours() {
	local hours=$1
	sleep $(($hours * 60 * 60))
}

