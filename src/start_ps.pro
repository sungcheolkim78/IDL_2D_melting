;+
; Name: start_ps
; Purpose: set up for multi graph of ps print
;
;- 

function start_ps, m, n, xsize=xsize, mar=mar, wall=wall, ratio=ratio, ticklen=ticklen, filename=filename

	if not keyword_set(xsize) then begin
		if m gt 1 then xsize=16.
		if m eq 1 then xsize=8.
	endif
	if not keyword_set(mar) then mar = 0.13
	if not keyword_set(wall) then wall = 0.03
	if not keyword_set(ratio) then begin
		ratio = 4./5
		if m eq 1 then ratio = 1/1.1618
		;if m eq 1 and n gt 1 then ratio = 1.618 ; golden ratio
	endif
	if not keyword_set(ticklen) then ticklen = 0.01
	if not keyword_set(filename) then filename = 'gdl.ps'

	psinfo = {xsize: 8., ysize: 1., xticklen:0., yticklen:0., pos: fltarr(m*n,4), filename:filename}
	pssize = plotsize(m, n, mar=mar, wall=wall, xsize=xsize, ratio=ratio, ticklen=ticklen)
	psinfo.xsize = pssize[0]
	psinfo.ysize = pssize[1]
	psinfo.xticklen = pssize[2]
	psinfo.yticklen = pssize[3]

	; find position
	a = (1. - mar - m*wall)/float(m)
	b = (1. - mar - n*wall)/float(n)

	for i=0,n-1 do begin
		for j =0,m-1 do begin
			ii = n-1-i
			psinfo.pos[i*m+j,*] = [mar+float(j)*a+float(j)*wall, $
				mar+float(ii)*b+float(ii)*wall, $
				mar+float(j)*a+float(j)*wall+a, $
				mar+float(ii)*b+float(ii)*wall+b]
		endfor
	endfor

	set_plot,'ps'
	device, /encapsul,/color,bits_per_pixel=8
	device, xsize = psinfo.xsize, ysize = psinfo.ysize, file=psinfo.filename

	print,'Writing to: '+psinfo.filename

	!p.font=1 ; use truetype font
	!p.thick=0.5
	!x.thick=0.5
	!y.thick=0.5

	return, psinfo

end
