;+
; Name: gdisview
; Purpose: show dislocation centers
; Input: gdisview, pt, frame, ps
; History:
; 	modified on 4/16/11
;-

pro gdisview, pt, frame, ps=ps, verbose=verbose
on_error,2

if keyword_set(ps) then begin
	set_plot,'ps'
	!p.font=0
	!p.charsize=0.8
	device,/color,/encapsul,/helvetica,bits=8
	filename = 'gdis_'+strtrim(string(frame),2)+'.eps'
	device,xsize=17.8,ysize=17.8*3/4.,file=filename
endif
if n_elements(verbose) eq 0 then verbose = 0 else verbose = 1

ptc = eclip(pt,[5,frame,frame])
triangulate, ptc(0,*), ptc(1,*), tr, conn=con
nc = n_elements(ptc(0,*))
density = nc/(634.*470.)
mdis = sqrt(1./density)*1.5
nnnt = intarr(nc)
dpair = intarr(nc)
dcheck = intarr(nc)
a0 = latticeconstant(ptc,-1,tr=tr)

; find disclinations and plot
if n_elements(pt(*,0)) ne 9 then begin
	for j=0, nc-1 do nnnt(j) = n_elements(con[con[j]:con[j+1]-1])
endif else begin
	nnnt = ptc(6,*)
endelse

wr = where(ptc(0,*) gt min(ptc(0,*))+mdis and $
	ptc(0,*) lt max(ptc(0,*))-mdis and $
	ptc(1,*) gt min(ptc(1,*))+mdis and $
	ptc(1,*) lt max(ptc(1,*))-mdis, wrc)

w3 = where(nnnt(wr) eq 3, w3c)
w4 = where(nnnt(wr) eq 4, w4c)
w5 = where(nnnt(wr) eq 5, w5c)
w7 = where(nnnt(wr) eq 7, w7c)
w8 = where(nnnt(wr) eq 8, w8c)
w9 = where(nnnt(wr) eq 9, w9c)
minus = wr([w3, w4, w5])
plus = wr([w9, w8, w7])
dpair(wr(w3)) -= 3
dpair(wr(w4)) -= 2
dpair(wr(w5)) -= 1
dpair(wr(w7)) += 1
dpair(wr(w8)) += 2
dpair(wr(w9)) += 3
print, n_elements(plus), n_elements(minus)

!p.multi=[0,1,1]
if verbose then begin
	xranx = [mdis, 640-mdis]
	yranx = [mdis, 480-mdis]
	cgplot, ptc(0,*), ptc(1,*), xran=xranx, yran=yranx,$
		xstyle=1,ystyle=1,psym=3, /nodata
	for i=0,n_elements(tr)/3-1 do begin
		t = [tr[*,i],tr[0,i]]
		cgplots, ptc(0,t), ptc(1,t), color='tg4', noclip=0
	endfor
endif else begin
	xranx = [0, 640]
	yranx = [0, 480]
	cgplot, ptc(0,*), ptc(1,*), xran=xranx, yran=yranx,$
		xstyle=1,ystyle=1,psym=3,charsize=0.75
endelse

nMinus = n_elements(minus)
ndicn = intarr(nMinus)
for li=0,nMinus-1 do begin
	nearp = con[con[minus(li)]:con[minus(li)+1]-1]
	wlow = where(nnnt(nearp) gt 6, wlowc)
	ndicn[li] = wlowc
endfor
minus = minus(sort(ndicn))
nijx = 0
nijy = 0

; calculate dislocation centers
for li = 0,n_elements(minus)-1 do begin
	nearp = con[con[minus(li)]:con[minus(li)+1]-1]
	wlow = where(nnnt(nearp) gt 6, wlowc)

	if wlowc gt 0 then begin
		nearlowp = nearp(wlow)
		nearlowp = nearlowp(sort(dcheck(nearlowp)))
		
		; check connected chain
		if wlowc eq 2 then begin
;			nearlowp = [nearlowp[1],nearlowp[0]]
			nearp1 = con[con[nearlowp[0]]:con[nearlowp[0]+1]-1]
			nearp2 = con[con[nearlowp[1]]:con[nearlowp[1]+1]-1]
			whi1 = where(nnnt(nearp1) lt 6, whic1)
			whi2 = where(nnnt(nearp2) lt 6, whic2)
			order = [whic1, whic2]
			nearlowp = nearlowp(sort(order))
;			print, dcheck(nearlowp)
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
			print, dcheck(nearlowp)
		endif

		; check dislocation center
		for lii=0,wlowc-1 do begin
			xx = [[ptc(0,minus(li))],[ptc(0,nearlowp(lii))]]
			yy = [[ptc(1,minus(li))],[ptc(1,nearlowp(lii))]]
			cgplots, xx, yy, color='grn4'
			if dpair(minus(li)) lt 0 and dpair(nearlowp(lii)) gt 0 then begin
				polyfill, fsc_circle(mean(xx),mean(yy),3),$
					color=fsc_color('blk6') 

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

wzero = where(dpair(wr) ne 0,wzeroc)
if wzeroc gt 0 then begin
	print,dpair(wr(wzero))
endif
print, nijx*0.083/a0, nijy*0.083/a0

if w3c gt 0 then cgplot, ptc(0,wr(w3)), ptc(1,wr(w3)), /overplot, psym=18, symsize=0.9, color='red2'
if w4c gt 0 then cgplot, ptc(0,wr(w4)), ptc(1,wr(w4)), /overplot, psym=18, symsize=0.9, color='red3'
cgplot, ptc(0,wr(w5)), ptc(1,wr(w5)), /overplot, psym=18, symsize=0.9, color='red4'
cgplot, ptc(0,wr(w7)), ptc(1,wr(w7)), /overplot, psym=17, symsize=0.9, color='blu4'
if w8c gt 0 then cgplot, ptc(0,wr(w8)), ptc(1,wr(w8)), /overplot, psym=17, symsize=0.9, color='blu3'
if w9c gt 0 then cgplot, ptc(0,wr(w9)), ptc(1,wr(w9)), /overplot, psym=17, symsize=0.9, color='blu2'

al_legend, ['5 co. disclination', '7 co. disclination', 'dislocation center'], psym=[18,17,16], colors=['red4','blu4','blk7'] $
	, textcolors = ['red4', 'blu4', 'blk7'], /right, /bottom 
	
if keyword_set(ps) then begin
	device,/close
	set_plot,'x'
	spawn, 'gv '+filename
endif

end
