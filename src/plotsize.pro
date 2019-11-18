;+
; Name: plotsize
; Purpose: calculate ysize, xticklen, yticklen
; Date: 12/4/10
; Credit: Sungcheol Kim
;-

function plotsize,m,n,mar=mar,wall=wall,xsize=xsize,ratio=ratio,ticklen=ticklen
	if not keyword_set(mar) then mar = 0.12
	if not keyword_set(wall) then wall = 0.03
	if not keyword_set(xsize) then xsize = 16.
	if not keyword_set(ratio) then ratio = 3./4
	if not keyword_set(ticklen) then ticklen = 0.01

	pssize = fltarr(4)

	a = (1. - mar - m*wall)/m
	b = (1. - mar - n*wall)/n

	pssize[0] = xsize
	pssize[1] = a/b*xsize*ratio
	pssize[2] = ticklen/b
	pssize[3] = ticklen/a

	return, pssize
end
