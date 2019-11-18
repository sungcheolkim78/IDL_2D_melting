;+
; Name: d_detect
; Purpose: detect defects and save as pt file
; Inputs: gdefdist, pt, startf, stopf
; History:
; 	copied from gdefdist on 5/30/11 by sungcheol kim
;	modified on 5/30/11 by sungcheol kim 
;-

pro d_detect, pt, startf, stopf, rmax=rmax, $
	hbinsize=hbinsize,bincut=bincut, gr=gr

on_error,2

; check input parameters
maxf = max(pt(5,*), min=minf)
if n_params() eq 1 then begin
	startf = fix(minf)
	stopf = fix(maxf)
endif
if n_params() eq 2 then begin
	stopf = startf
endif
if n_params() eq 3 then begin
	if stopf gt maxf then begin
		print, 'maxf : '+string(maxf) 
		stopf = maxf
	endif
	if startf lt minf then begin
		print, 'minf : '+string(minf)
		startf = minf
	endif
endif

a0 = latticeconstant(pt,0)
rmin = 0.5*a0
if not keyword_set(rmax) then rmax = 3.5*a0
if n_elements(bincut) eq 0 then bincut = 2.5*a0
if not keyword_set(hbinsize) then hbinsize = (rmax-rmin)/80.

totalf = stopf-startf+1
hresult = fltarr((rmax-rmin)/hbinsize+1,totalf)
h2result = fltarr((rmax-rmin)/hbinsize+1,totalf)
x = findgen(n_elements(hresult(*,0)))*hbinsize+rmin
savenumber = intarr(totalf, 11)

for i = startf, stopf do begin
	ptc = pt(*,where(pt(5,*) eq i))
	nff = n_elements(ptc(0,*))
	density = nff/(640*480.)
	mdis = sqrt(1./density)*1.5
	nnnt = intarr(nff)
	dpair = intarr(nff)
	dcheck = intarr(nff)
	disx = 0
	disy = 0
	nijx = 0
	nijy = 0

	; restrict certain area to discrinate boundary points
	wr = where(ptc(0,*) gt min(ptc(0,*))+mdis and $
		ptc(0,*) lt max(ptc(0,*))-mdis and $
		ptc(1,*) gt min(ptc(1,*))+mdis and $
		ptc(1,*) lt max(ptc(1,*))-mdis, wrc)

	; calculate nearest neighbors and find disclinations
	triangulate, ptc(0,*), ptc(1,*), tr, conn=con
	if n_elements(ptc(*,0)) eq 9 then nnn = ptc(6,wr)
	if n_elements(ptc(*,0)) ne 9 then begin
		for j=0,nff-1 do nnnt(j) = n_elements(con[con[j]:con[j+1]-1])
		nnn = nnnt(wr)
	endif

	; find each disclinations
	w3 = where(nnn eq 3, w3c)
	w4 = where(nnn eq 4, w4c)
	w5 = where(nnn eq 5, w5c)
	w7 = where(nnn eq 7, w7c)
	w8 = where(nnn eq 8, w8c)
	w9 = where(nnn eq 9, w9c)
	minus = [wr(w3),wr(w4),wr(w5)]
	plus = [wr(w9),wr(w8),wr(w7)]
	dpair(wr(w3)) -= 3
	dpair(wr(w4)) -= 2
	dpair(wr(w5)) -= 1
	dpair(wr(w7)) += 1
	dpair(wr(w8)) += 2
	dpair(wr(w9)) += 3

	; save disclinations as pt file
	if n_elements(dpt) eq 0 then begin
		dpt = ptc(*,[minus, plus])
	endif else begin
		dpt = [[dpt],[ptc(*,[minus, plus])]]
	endelse

	; pre check the number of nearest disclinations
	nMinus = n_elements(minus)
	ndicn = intarr(nMinus)
	for li=0,nMinus-1 do begin
		nearp = con[con[minus(li)]:con[minus(li)+1]-1]
		wlow = where(nnnt(nearp) gt 6, wlowc)
		ndicn[li] = wlowc
	endfor

	; find dislocation centers
	for li = 0,n_elements(minus)-1 do begin
		nearp = con[con[minus(li)]:con[minus(li)+1]-1]
		wlow = where(nnnt(nearp) gt 6, wlowc)

		if wlowc gt 0 then begin
			nearlowp = nearp(wlow)
			nearlowp = nearlowp(sort(dcheck(nearlowp)))

			; check connected chain
			if wlowc eq 2 then begin
				nearp1 = con[con[nearlowp[0]]:con[nearlowp[0]+1]-1]
				nearp2 = con[con[nearlowp[1]]:con[nearlowp[1]+1]-1]
				whi1 = where(nnnt(nearp1) lt 6, whic1)
				whi2 = where(nnnt(nearp2) lt 6, whic2)
				order = [whic1, whic2]
				nearlowp = nearlowp(sort(order))
			endif
			
			if wlowc eq 3 then begin
				nearp1 = con[con[nearlowp[0]]:con[nearlowp[0]+1]-1]
				nearp2 = con[con[nearlowp[1]]:con[nearlowp[1]+1]-1]
				nearp3 = con[con[nearlowp[2]]:con[nearlowp[2]+1]-1]
				whi1 = where(nnnt(nearp1) lt 6, whic1)
				whi2 = where(nnnt(nearp2) lt 6, whic2)
				whi3 = where(nnnt(nearp3) lt 6, whic3)
				order = [whic1, whic2, whic3]
				nearlowp = nearlowp(sort(order))
			endif

			for lii = 0, wlowc-1 do begin
				xx = [[ptc(0,minus(li))],[ptc(0,nearlowp(lii))]]
				yy = [[ptc(1,minus(li))],[ptc(1,nearlowp(lii))]]
				if dpair(minus(li)) lt 0 and dpair(nearlowp(lii)) gt 0 then begin
					disx = [disx, mean(xx)]
					disy = [disy, mean(yy)]

					; calculate n_ij
					nijx += ptc(0,nearlowp(lii)) - ptc(0,minus(li))
					nijy += ptc(1,nearlowp(lii)) - ptc(1,minus(li))

					dpair(minus(li)) += 1
					dpair(nearlowp(lii)) -= 1
					dcheck(nearlowp(lii)) += 1
					dcheck(minus(li)) += 1
				endif
			endfor
		endif
	endfor

	; save dislocation centers
	ev = fltarr(n_elements(disx)-1,1)
	if n_elements(dpt2) eq 0 then begin
		dpt2 = transpose([[disx(1:*)],[disy(1:*)],[ev],[ev],[ev],[ev+i]])
	endif else begin
		dpt2t = transpose([[disx(1:*)],[disy(1:*)],[ev],[ev],[ev],[ev+i]])
		dpt2 = [[dpt2],[dpt2t]]
	endelse

	h2result(*,i-startf) = histogram(0.083*i_nearest(disx(1:*),disy(1:*)),$
		min=rmin,max=rmax,binsize=hbinsize)/float(1)

	if n_elements(minus) gt n_elements(plus) then begin 
		hresult(*,i-startf) = histogram(0.083*i_nearest(ptc(0,minus),ptc(1,minus),ptc(0,plus),ptc(1,plus)),$
			min=rmin, max=rmax, binsize=hbinsize)/float(1)
	endif else begin
		hresult(*,i-startf) = histogram(0.083*i_nearest(ptc(0,plus),ptc(1,plus),ptc(0,minus),ptc(1,minus)),$
			min=rmin, max=rmax, binsize=hbinsize)/float(1)
	endelse

	savenumber(i-startf,0) = i
	savenumber(i-startf,1) = nff
	savenumber(i-startf,2) = n_elements(disx)-1
	savenumber(i-startf,3) = w3c*3.+w4c*2.+w5c
	savenumber(i-startf,4) = w9c*3.+w8c*2.+w7c
	savenumber(i-startf,5) = total(h2result((bincut-rmin)/hbinsize+1:*,i-startf))
	savenumber(i-startf,6) = total(hresult((bincut-rmin)/hbinsize+1:*,i-startf))
	savenumber(i-startf,7) = n_elements(minus)
	savenumber(i-startf,8) = n_elements(plus)
	savenumber(i-startf,9) = nijx*0.083/a0
	savenumber(i-startf,10) = nijy*0.083/a0

	statusline, strtrim(i-startf+1,2) + ' of '+strtrim(totalf,2), 0

endfor

write_gdf, savenumber,'f.dd'+strtrim(startf,2)+'_'+strtrim(stopf,2)+'_'+string(bincut,format='(F3.1)')
write_gdf, dpt, 'pt.def'+strtrim(startf,2)+'_'+strtrim(stopf,2)
write_gdf, dpt2, 'pt.dis'+strtrim(startf,2)+'_'+strtrim(stopf,2)
print,''

end
