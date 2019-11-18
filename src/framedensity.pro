;+
; Name: framedensity
; Purpose: calculate the local density and average density
; Input: framedensity, pt, startf, stopf
;-

function framedensity, pt, startf, stopf, prefix=prefix
on_error,2

; check startf and stopf
maxf = max(pt(5,*), min=minf)
if startf lt minf then begin
	print, 'startf is less than minf: '+strtrim(minf,2)
	startf = fix(minf)
endif
if stopf gt maxf then begin
	print, 'stopf is greater than maxf: '+strtrim(maxf,2)
	stopf = fix(maxf)
endif
if not keyword_set(prefix) then prefix=''

; calculate density
nf = stopf-startf+1
result = fltarr(19,nf)
for i = startf, stopf do begin
	ptc = pt(*,where(pt(5,*) eq i))
	nff = n_elements(ptc(0,*))
	density = nff/(640*480.)
	mdis = sqrt(1./density)*1.5

	pdarr = fltarr(nff)
	nnn = indgen(nff)

	triangulate, ptc(0,*), ptc(1,*), tr, conn=con
	for j=0,nff-1 do begin
		pdarr[j] = pointdensity(j,ptc,-1,con=con)
		nearp = con[con[j]:con[j+1]-1]
		nnn[j] = n_elements(nearp)
	endfor

	wr = where(ptc(0,*) gt min(ptc(0,*))+mdis and $
		ptc(0,*) lt max(ptc(0,*))-mdis and $
		ptc(1,*) gt min(ptc(1,*))+mdis and $
		ptc(1,*) lt max(ptc(1,*))-mdis and $
		pdarr ne 0, wrc)

	result[0,i-startf] = i
	result[1,i-startf] = mean(pdarr(wr))
	result[2,i-startf] = wrc
	result[3,i-startf] = stddev(pdarr(wr))

	w4 = where(nnn(wr) eq 4, w4c)
	if w4c gt 0 then begin
		result[4,i-startf] = mean(pdarr(wr(w4)))
		result[5,i-startf] = w4c
		result[6,i-startf] = stddev(pdarr(wr(w4)))
	endif else begin
		result[4,i-startf] = 0
		result[5,i-startf] = 0
		result[6,i-startf] = 0
	endelse

	w5 = where(nnn(wr) eq 5, w5c)
	if w5c gt 0 then begin
		result[7,i-startf] = mean(pdarr(wr(w5)))
		result[8,i-startf] = w5c
		result[9,i-startf] = stddev(pdarr(wr(w5)))
	endif else begin
		result[7,i-startf] = 0
		result[8,i-startf] = 0
		result[9,i-startf] = 0
	endelse

	w6 = where(nnn(wr) eq 6, w6c)
	if w6c gt 0 then begin
		result[10,i-startf] = mean(pdarr(wr(w6)))
		result[11,i-startf] = w6c
		result[12,i-startf] = stddev(pdarr(wr(w6)))
	endif else begin
		result[10,i-startf] = 0
		result[11,i-startf] = 0
		result[12,i-startf] = 0
	endelse

	w7 = where(nnn(wr) eq 7, w7c)
	if w7c gt 0 then begin
		result[13,i-startf] = mean(pdarr(wr(w7)))
		result[14,i-startf] = w7c
		result[15,i-startf] = stddev(pdarr(wr(w7)))
	endif else begin
		result[13,i-startf] = 0
		result[14,i-startf] = 0
		result[15,i-startf] = 0
	endelse

	w8 = where(nnn(wr) eq 8, w8c)
	if w8c gt 0 then begin
		result[16,i-startf] = mean(pdarr(wr(w8)))
		result[17,i-startf] = w8c
		result[18,i-startf] = stddev(pdarr(wr(w8)))
	endif else begin
		result[16,i-startf] = 0
		result[17,i-startf] = 0
		result[18,i-startf] = 0
	endelse

	statusline, strtrim(i,2)+' of '+strtrim(nf,2), 0
endfor
print,''

filename = 'f.den_'+strtrim(startf,2)+'_'+strtrim(stopf,2)+prefix
write_gdf, result, filename
print,'Write to: '+filename

return, result

end
