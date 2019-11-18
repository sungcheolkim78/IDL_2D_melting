; test program 

pro temp
	window, xsize=440, ysize=352
	a = readjpgstack('fg',72,90)

	for i=72,90 do begin
		tvimage,a(250:470,30:206,i-90),/scale
		s=cgsnapshot(/jpeg,filename='crop_'+strtrim(i,2),/nodialog)
	endfor
end

