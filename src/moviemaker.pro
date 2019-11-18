;+
; Name: moviemaker
; Purpose: save delaunay trianulation images in sequence
; Input: moviemake, tt, startf=startf, stopf=stopf, field=field
; History:
; 	created on 8/12/11 by SCK
;-

pro moviemaker, tt, startf=startf, stopf=stopf, field=field, centering=centering

	maxf = max(tt(5,*), min=minf)
	if not keyword_set(startf) then wminf=minf else wminf=startf
	if not keyword_set(stopf) then wmaxf=maxf else wmaxf=stopf

	maxx = max(tt(0,*),min=minx)
	maxy = max(tt(1,*),min=miny)
	mdis = 15
	if not keyword_set(field) then wsize = [minx+mdis,maxx-mdis,miny+mdis,maxy-mdis] else wsize = field

	thisDevice = !d.name
	set_plot,'z'
    device, set_resolution=[520,505]
	;window, 0, xsize=600, ysize=600
    !p.font=-1
    !x.margin=[4,2]
    !y.margin=[2,1]

	for i=wminf,wmaxf do begin
		ptc = tt(*,where(tt(5,*) eq i))
		if n_elements(centering) then i_defdraw, ptc, /tri, field=wsize, symsize=2.0, /centering else i_defdraw, ptc, /tri, field=wsize,symsize=2.0

		s = cgsnapshot(filename='mov/t_'+strtrim(fix(i),2),/png,/nodialog,/dither)
		if (i mod 5) eq 0 then print, strtrim(i,2)+' frame of '+strtrim(fix(wmaxf-wminf),2)
	endfor

	set_plot,thisDevice
end
