#!/usr/bin/env python
src = "E:\Torrent\Downloads\Django.Unchained.2012.720p.BluRay.x264-SPARKS [PublicHD]\django.unchained.2012.720p.bluray.x264-sparks.srt"
srcEnc = "Windows-1251"
target = "django.unchained.2012.720p.bluray.x264-sparks.utf8.alt.srt"
targetEnc="utf-8-sig"

import codecs

with codecs.open(src, "r", encoding=srcEnc) as f:
	content = f.read()
newContent = content.encode(targetEnc)
with codecs.open(target, "w", encoding=targetEnc) as f:
	f.write(content)

