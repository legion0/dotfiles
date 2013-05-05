function mkdir2 { mkdir "$1" && cd "$1"; }
function git-dist { echo -ne "A "; git rev-list --left-right $1...$2 | cut -c 1-1 | grep -c \>; echo -ne "B "; git rev-list --left-right $1...$2 | cut -c 1-1 | grep -c \<; }
