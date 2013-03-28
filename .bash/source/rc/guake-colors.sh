if command -v gconftool-2 2>&1 > /dev/null; then
	gconftool-2 -s -t string /apps/guake/style/font/color "#dcdccc"
	gconftool-2 -s -t string /apps/guake/style/background/color "#000010"
	gconftool-2 -s -t string /apps/guake/style/font/palette "#000010:#9e1828:#aece92:#968a38:#414171:#963c59:#418179:#bebebe:#666666:#cf6171:#c5f779:#fff796:#4186be:#cf9ebe:#71bebe:#ffffff"
fi

