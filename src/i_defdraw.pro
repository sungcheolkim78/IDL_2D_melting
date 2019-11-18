;+
; Name: i_defdraw
; Purpose: draw delaunay triangulation of one frame with different options
; Input: i_defdraw, ptc, field=field, /triangulation, /wired
; History:
; 	created on 8/2/11 by sungcheol kim
; 	modified on 3/14/12 by sungcheol kim
; 	modified on 10/29/12 by sungcheol kim, adding centering function
;-

pro i_defdraw, ptc, field=field, triangulation=triangulation, wired=wired $
    , symsize=symsize, overplot=overplot, baw=baw, centering=centering, particlesize=particlesize
	on_error,2

	xmax = max(ptc(0,*), min=xmin)
	ymax = max(ptc(1,*), min=ymin)
    np   = n_elements(ptc(0,*))
    area = (xmax-xmin)*(ymax-ymin)
    mdis = sqrt(area/float(np))*2.5

	if n_elements(field) eq 4 then begin
		wxmin = float(field[0])
		wxmax = float(field[1])
		wymin = float(field[2])
		wymax = float(field[3])

		ptcc = eclip(ptc, [0,wxmin-mdis,wxmax+mdis], [1,wymin-mdis,wymax+mdis])
	endif 
	if n_elements(field) eq 0 then begin
		wxmin = xmin+mdis
		wxmax = xmax-mdis
		wymin = ymin+mdis
		wymax = ymax-mdis
		ptcc = ptc
	endif 

	triangulate, ptcc(0,*), ptcc(1,*), tr, conn=con
	npc = n_elements(ptcc(0,*))
	nnn = intarr(npc)
	for j=0,npc-1 do nnn(j) = n_elements(con[con[j]:con[j+1]-1])

    if n_elements(centering) then begin
        ; find center
        wn6 = where(nnn ne 6, wn6c)
        dcs = where(ptcc(0,wn6) gt wxmin and $
            ptcc(0,wn6) lt wxmax and $
            ptcc(1,wn6) gt wymin and $
            ptcc(1,wn6) lt wymax, dcsc)
        ;if dcsc ne 4 then print, 'wrong!'
        print, dcsc

        ; find center coordinate
        defcenterx = total(ptcc(0,wn6[dcs]))/dcsc
        defcentery = total(ptcc(1,wn6[dcs]))/dcsc
        wxsize = wxmax - wxmin
        wysize = wymax - wymin
        wxmin = defcenterx - wxsize/2.
        wxmax = defcenterx + wxsize/2.
        wymin = defcentery - wysize/2.
        wymax = defcentery + wysize/2.

        ptcc = eclip(ptc,[0,wxmin-mdis,wxmax+mdis],[1,wymin-mdis,wymax+mdis])
        triangulate, ptcc(0,*), ptcc(1,*), tr, conn=con
        npc = n_elements(ptcc(0,*))
        nnn = intarr(npc)
        for j=0,npc-1 do nnn(j) = n_elements(con[con[j]:con[j+1]-1])

        ;print, defcenterx, defcentery
        ;print, wxmin, wxmax, wymin, wymax

        cgPlot, ptcc(0,*), ptcc(1,*), xran=[wxmin, wxmax], yran=[wymin,wymax] $
            , xstyle=1, ystyle=1, /nodata, charsize=1.0, /isotropic $
            , xticks=1, yticks=1
    endif

	w4 = where(nnn eq 4, w4c)
	w5 = where(nnn eq 5, w5c)
	w7 = where(nnn eq 7, w7c)
	w8 = where(nnn eq 8, w8c)
	w9 = where(nnn eq 9, w9c)

    !p.font = -1
    if not keyword_set(centering) then $
        cgPlot, ptcc(0,*), ptcc(1,*), xran=[wxmin, wxmax], yran=[wymin,wymax] $
            , xstyle=1, ystyle=1, charsize=1.0, psym=SymCat(16), noclip=0, symsize=particlesize;, /nodata, symsize=1.0
        ;, background='black'

	if n_elements(triangulation) then begin
		for i=0, n_elements(tr)/3-1 do begin
			t = [tr[*,i],tr[0,i]]
			cgPlots, ptcc(0,t), ptcc(1,t), color='tg4', noclip=0, thick=1
		endfor
	endif

	if n_elements(wired) then begin
	   if not keyword_set(particlesize) then particlesize=1.0
		cgPlot, ptcc(0,*), ptcc(1,*), /overplot, psym=SymCat(16), noclip=0, symsize=particlesize     ; Lichao changed psym and symsize
		whigh = [w7, w8, w9]
		for li = 0, n_elements(whigh)-1 do begin
			nearp = con[con[whigh(li)]:con[whigh(li)+1]-1]
			wlow = where(nnn(nearp) le 5, wlowc)
			for lii = 0, wlowc-1 do cgPlots, [ptcc(0,whigh(li)), ptcc(0,nearp(wlow(lii)))], [ptcc(1,whigh(li)), ptcc(1,nearp(wlow(lii)))], color='grn4', noclip=0
		endfor
	endif

    if not keyword_set(symsize) then symsize=0.8
	if w4c gt 0 then cgPlot, ptcc(0,w4), ptcc(1,w4), psym=16, symcolor='red3' $
		, /overplot, symsize=symsize, noclip=0
	if w5c gt 0 then cgPlot, ptcc(0,w5), ptcc(1,w5), psym=16, symcolor='red4' $
		, /overplot, symsize=symsize, noclip=0
	if w7c gt 0 then cgPlot, ptcc(0,w7), ptcc(1,w7), psym=16, symcolor='blu4' $
		, /overplot, symsize=symsize, noclip=0
	if w8c gt 0 then cgPlot, ptcc(0,w8), ptcc(1,w8), psym=16, symcolor='blu3' $
		, /overplot, symsize=symsize, noclip=0
	if w9c gt 0 then cgPlot, ptcc(0,w9), ptcc(1,w9), psym=16, symcolor='blu3' $
		, /overplot, symsize=symsize, noclip=0

	if keyword_set(shadow) then begin
	endif
	
end
