;+
; Name: burgerarr
; Purpose: calculate burger vector array for one frame
; Input: burgerarr, ptc
;-

function burgerarr, ptc, verbose=verbose, con=con
on_error,2

if not keyword_set(con) then triangulate, ptc(0,*), ptc(1,*), conn=con

nff = n_elements(ptc(0,*))
burgerarray = fltarr(2,nff)

for j = 0, nff-1 do burgerarray[*,j] = burger(j, ptc, -1, con=con)

if keyword_set(verbose) then begin
	minx = min(ptc(0,*), max=maxx)
	miny = min(ptc(1,*), max=maxy)
	mdis = sqrt(480.*640./nff)*1.5
	fsc_plot, [0,640],[0,480],xstyle=1, ystyle=1,/nodata
	wr = where(ptc(0,*) gt minx+mdis and $
		ptc(0,*) lt maxx-mdis and $
		ptc(1,*) gt miny+mdis and $
		ptc(1,*) lt maxy-mdis)
	for j = 0, n_elements(wr)-1 do fsc_plots, [ptc(0,wr(j)),ptc(0,wr(j))+burgerarray(0,wr(j))], $
			[ptc(1,wr(j)),ptc(1,wr(j))+burgerarray(1,wr(j))], psym=-3, $
			color='tg4'
endif

return, burgerarray

end
