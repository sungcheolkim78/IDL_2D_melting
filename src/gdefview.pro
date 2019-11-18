;+
; Name: gdefview
; Purpose: show disclinations for each frame
; Inputs: gdefview, pt, startf, stopf
;-

pro gdefview, pt, startf, stopf
on_error,2

thisDevice=!d.name
maxf = max(pt(5,*), min=minf)
if n_params() eq 1 then begin
	startf = minf
	stopf = maxf 
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

waittime = 1
linef = 1
defects = 1
tri = 0
burgerf = 0
savef = 0
Window,0,xsize=800,ysize=600
!p.charsize = 0.8

for i = startf, stopf do begin
	ptc = pt(*,where(pt(5,*) eq i))
	nff = n_elements(ptc(0,*))
	density = nff/(640*480.)
	mdis = sqrt(1./density)*1.0

	wr = where(ptc(0,*) gt min(ptc(0,*))+mdis and $
		ptc(0,*) lt max(ptc(0,*))-mdis and $
		ptc(1,*) gt min(ptc(1,*))+mdis and $
		ptc(1,*) lt max(ptc(1,*))-mdis, wrc)

	triangulate, ptc(0,*), ptc(1,*), tr, conn=con
	if n_elements(ptc(*,0)) eq 9 then nnn = ptc(6,wr)
	if n_elements(ptc(*,0)) ne 9 then begin
		nnnt = intarr(nff)
		for j=0,nff-1 do nnnt(j) = n_elements(con[con[j]:con[j+1]-1])
		nnn = nnnt(wr)
	endif

	w4 = where(nnn eq 4, w4c)
	w5 = where(nnn eq 5, w5c)
	w7 = where(nnn eq 7, w7c)
	w8 = where(nnn eq 8, w8c)
	w9 = where(nnn eq 9, w9c)

	set_plot,'z',/copy
	erase
	device, set_resolution=[800,600], set_pixel_depth=24,decomposed=1

	cgPlot, ptc(0,*), ptc(1,*),xran=[0,640],yran=[0,480],$
		xstyle=1,ystyle=1,psym=3,charsize=0.8

	if tri eq 1 then begin
		for ji=0, n_elements(tr)/3-1 do begin
			t = [tr[*,ji],tr[0,ji]]
			cgPlots, ptc(0,t), ptc(1,t), color='tg4'
		endfor
	endif

	if burgerf eq 1 then begin
		ba = burgerarr(ptc,con=con)
		wf = wr
		for li = 0, n_elements(wf)-1 do $
			cgPlots, [ptc(0,wf(li)),ptc(0,wf(li))+ba(0,wf(li))],$
				[ptc(1,wf(li)),ptc(1,wf(li))+ba(1,wf(li))],$
				psym=-3, color='blu7'
	endif

	if linef eq 1 then begin
		whigh = [w7, w8, w9]
		for li = 0,n_elements(whigh)-1 do begin
			nearp = con[con[wr(whigh(li))]:con[wr(whigh(li))+1]-1]
			w5l = where(nnnt(nearp) le 5, w5lc)
			if w5lc ge 1 then begin
				xx = [[ptc(0,wr(whigh(li)))],[ptc(0,nearp(w5l(0)))]]
				yy = [[ptc(1,wr(whigh(li)))],[ptc(1,nearp(w5l(0)))]]
				cgPlots, xx, yy, color='grn4'
			endif
			if w5lc ge 2 then begin
				xx = [[ptc(0,wr(whigh(li)))],[ptc(0,nearp(w5l(1)))]]
				yy = [[ptc(1,wr(whigh(li)))],[ptc(1,nearp(w5l(1)))]]
				cgPlots, xx, yy, color='grn4'
			endif
			if w5lc ge 3 then begin
				xx = [[ptc(0,wr(whigh(li)))],[ptc(0,nearp(w5l(2)))]]
				yy = [[ptc(1,wr(whigh(li)))],[ptc(1,nearp(w5l(2)))]]
				cgPlots, xx, yy, color='grn4'
			endif
		endfor

	endif

	if defects eq 1 then begin
		if w4c gt 0 then cgPlot, ptc(0,wr(w4)),ptc(1,wr(w4)),psym=16, symcolor='red3', /overplot,symsize=0.8
		if w5c gt 0 then cgPlot, ptc(0,wr(w5)),ptc(1,wr(w5)),psym=16, symcolor='red4', /overplot,symsize=0.8
		if w7c gt 0 then cgPlot, ptc(0,wr(w7)),ptc(1,wr(w7)),psym=16, symcolor='blu4', /overplot,symsize=0.8
		if w8c gt 0 then cgPlot, ptc(0,wr(w8)),ptc(1,wr(w8)),psym=16, symcolor='blu3', /overplot,symsize=0.8
		if w9c gt 0 then cgPlot, ptc(0,wr(w9)),ptc(1,wr(w9)),psym=16, symcolor='blu2', /overplot,symsize=0.8
	endif

	frame = tvread(true=2)
	set_plot,thisDevice,/copy
	tvimage, frame

	print,'Key: Q, N, P, M, D, L, B, T, S	 Frame: '+strtrim(string(i),2)
	kbinput = get_kbrd(waittime)

	if strcmp(kbinput,'m') then waittime = ~waittime
	if strcmp(kbinput,'q') then return
	if strcmp(kbinput,'l') then begin
		linef = ~linef
		if i gt 0 then i=i-1
	endif
	if strcmp(kbinput,'d') then begin
		defects = ~defects
		if i gt 0 then i=i-1
	endif
	if strcmp(kbinput,'t') then begin
		tri = ~tri
		if i gt 0 then i=i-1
	endif
	if strcmp(kbinput,'b') then begin
		burgerf = ~burgerf
		if i gt 0 then i=i-1
	endif
	if (savef eq 1) and (waittime eq 0) then image = cgSnapshot(filename='movie/sg_'+strtrim(fix(i),2),/jpeg,/nodialog)
	if strcmp(kbinput,'s') then begin
		image = cgSnapshot(filename='movie/sg_'+strtrim(fix(i),2),/jpeg,/nodialog)
		savef = ~savef
	endif
	if strcmp(kbinput,'p') then begin
		if i gt 1 then i = i-2
	endif

endfor

end
