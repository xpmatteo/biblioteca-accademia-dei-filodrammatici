function wfo(ssSwf, baseImg, xmlConf, bgColor){
	document.write('<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="100%" height="100%" id="slideShow" align="middle">\n');
	document.write('<param name="allowScriptAccess" value="sameDomain" />\n');
	document.write('<param name="movie" value="' + ssSwf + '?cf=' + xmlConf + '&bs=' + baseImg + '" />\n');
	document.write('<param name="quality" value="best" />\n');
	document.write('<param name="scale" value="noscale" />\n');
	document.write('<param name="bgcolor" value="' + bgColor + '" />\n');
	document.write('<embed src="' + ssSwf + '?cf=' + xmlConf + '&bs=' + baseImg + '" quality="best" scale="noscale" bgcolor="' + bgColor + '" width="100%" height="100%" name="slideShow" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />\n');
	document.write('</object>\n');
}