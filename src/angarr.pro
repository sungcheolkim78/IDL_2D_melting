;+
; Name: angarr
; Purpose: calculate nearest neighbor angle distribution for one frame
; Input: angarr, ptct
;-

function angarr, ptc, verbose=verbose, coordinate=coordinate
on_error, 2

minf = min(ptc(5,*), max=maxf)
if maxf - minf gt 1 then ptct = eclip(ptc,[5,minf,minf]) else ptct = ptc
if not keyword_set(coordinate) then coordinate = 6

triangulate, ptct(0,*), ptct(1,*), conn=con
nff = n_elements(ptct(0,*))
nnnt = intarr(nff)
mdis = latticeconstant(ptct,-1)*1.5

wr = where(ptct(0,*) gt min(ptct(0,*))+mdis and $
     ptct(0,*) lt max(ptct(0,*))-mdis and $
     ptct(1,*) gt min(ptct(1,*))+mdis and $
     ptct(1,*) lt max(ptct(1,*))-mdis, wrc)

for i=0,nff-1 do nnnt(i) = n_elements(con[con[i]:con[i+1]-1])

wcoordi = where(nnnt(wr) eq coordinate, wcoordic)
if wcoordic eq 0 then return, 0
angarray = fltarr(wcoordic,coordinate)

for i = 0, wcoordic-1 do begin
	iang = phi6(wr(wcoordi(i)), ptct, -1, con=con, /angle)
	angarray(i,*) = iang(sort(iang))
endfor

h = histogram(angarray,min=-180.,max=180,binsize=1)

if keyword_set(verbose) then begin
	x = findgen(361)-180.
	fsc_plot, x, h, xtitle='Angle', ytitle='Frequency', color='blu3', $
		xstyle=1, ystyle=2, psym=-3, xticks=6, symcolor='blu7',$
		symsize=0.8, charsize=1.3
	fsc_text, -160, max(h)*0.95, Strtrim(coordinate,2)+' Nearest Neigbors', charsize=0.6, color='blk7'
endif

return,h

end
