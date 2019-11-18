;+
; Name: gdenview
; Purpose: show density map
; Input: gdenview, pt
;-

pro gdenview, pt, startf, stopf,  ps=ps, histo=histo
on_error,2

maxf = max(pt(5,*))
if n_params() eq 1 then begin
	startf=0
	stopf=maxf-1
endif
if n_params() eq 3 then begin
	if stopf gt maxf then begin
		print,'maxf : '+strtrim(maxf,2)
		return
	endif
	if startf gt stopf then return
endif

print,startf,stopf

if keyword_set(ps) then begin
   set_plot,'ps'
   !p.font=0
   !p.charsize=0.8
   filename = 'gden_'+strtrim(startf,2)+'_'+strtrim(stopf,2)+'.eps'
   device,/color,/encapsul,/helvetica,bits=8
   device,xsize=16,ysize=12,file=filename
endif

defects = 1
waittime = 1
finfo = framedensity(pt,startf,startf)
flevels = (findgen(11)-5)*0.2*finfo(3)*3.0+finfo(1)
print,flevels

for i = startf, stopf do begin
	; prepare total characteristics
	ptc = pt(*,where(pt(5,*) eq i))
	nff = n_elements(ptc(0,*))
	density = nff/(640*480.)
	mdis = sqrt(1./density)*1.5

	pdarr = fltarr(nff)
	nnn= indgen(nff)

	triangulate, ptc(0,*), ptc(1,*), tr, conn=con
	for j=0l,nff-1 do begin
		pdarr[j] = pointdensity(j,ptc,-1,con=con)
		nearp = con[con[j]:con[j+1]-1]
		nnn[j] = n_elements(nearp)
	endfor

	wr = where(ptc(0,*) gt min(ptc(0,*))+mdis and $
		ptc(0,*) lt max(ptc(0,*))-mdis and $
		ptc(1,*) gt min(ptc(1,*))+mdis and $
		ptc(1,*) lt max(ptc(1,*))-mdis and $
		pdarr ne 0, wrc)
	pdstd = stddev(pdarr) & pdavg = mean(pdarr)
	wn = where(pdarr ne 0 and $
		pdarr gt pdavg-pdstd and $
		pdarr lt pdavg+pdstd)

	if not keyword_set(histo) then begin
		!p.multi=[0,1,1]
		c_colors = ['blk8','grn8','grn7','grn6','grn5','grn4','grn3','grn2','grn1','blk1']
		fsc_contour,pdarr(wn),ptc(0,wn),ptc(1,wn),/irregular,/fill,$
			levels=flevels,c_colors = c_colors,xran=[0,640],$
			yran=[0,480],xstyle=1,ystyle=1
	endif else begin
		!p.multi=[0,2,1]
		histoplot,pdarr(wn)
	endelse

	if defects eq 1 then begin
		w4 = where(nnn(wr) eq 4, w4c)
		w5 = where(nnn(wr) eq 5, w5c)
		w7 = where(nnn(wr) eq 7, w7c)
		w8 = where(nnn(wr) eq 8, w8c)

		if w4c gt 0 then fsc_plot,ptc(0,wr(w4)),ptc(1,wr(w4)),psym=14, symcolor='red3',/overplot
		if w5c gt 0 then fsc_plot,ptc(0,wr(w5)),ptc(1,wr(w5)),psym=14, symcolor='red4',/overplot
		if w7c gt 0 then fsc_plot,ptc(0,wr(w7)),ptc(1,wr(w7)),psym=14, symcolor='blu4',/overplot
		if w8c gt 0 then fsc_plot,ptc(0,wr(w8)),ptc(1,wr(w8)),psym=14, symcolor='blu3',/overplot

		if keyword_set(histo) then begin
			pdx = findgen(11)*2.*pdstd/10+pdavg-pdstd
				
			w5pd = histogram(pdarr(w5),min=pdavg-pdstd, max=pdavg+pdstd, nbins=11)
			w7pd = histogram(pdarr(w7),min=pdavg-pdstd, max=pdavg+pdstd, nbins=11)
			fsc_plot, pdx, [min([w5pd,w7pd]),max([w5pd,w7pd])],/nodata
			fsc_plot, pdx, w5pd, psym=-14, color='blu5',/overplot
			fsc_plot, pdx, w7pd, psym=-14, color='red5',/overplot
			if w4c gt 0 then begin
				w4pd = histogram(pdarr(w4),min=pdavg-pdstd, max=pdavg+pdstd, nbins=11)
				fsc_plot, pdx, w4pd, psym=-14, color='blu3',/overplot
			endif
			if w8c gt 0 then begin
				w8pd = histogram(pdarr(w8),min=pdavg-pdstd, max=pdavg+pdstd, nbins=11)
				fsc_plot, pdx, w8pd, psym=-14, color='red3',/overplot
			endif
			al_legend,['5 cood.','7 cood.','4 cood.','8 cood.'],psym=[14,14,14,14],$
				colors=[fsc_color('blu5'),fsc_color('red5'),$
				fsc_color('blu3'),fsc_color('red3')],$
				textcolors=[fsc_color('blu5'),fsc_color('red5'),$
				fsc_color('blu3'),fsc_color('red3')]
		endif
	endif

	print,'Key: Q, N, P, D, M	Frame: '+strtrim(i,2)+$
		'     '+strtrim(pdavg,2)+' +/- '+strtrim(pdstd,2)
	kbinput = get_kbrd(waittime)

	if strcmp(kbinput,'m') then waittime = ~waittime
	if strcmp(kbinput,'d') then defects = ~defects
	if strcmp(kbinput,'q') then begin
		if keyword_set(ps) then begin
			device,/close
			set_plot,'x'
			spawn,'gv '+filename
		endif
		return
	endif
	if strcmp(kbinput,'p') then begin
		if i gt 0 then i = i-2
	endif

endfor

if keyword_set(ps) then begin
	device,/close
	set_plot,'x'
	spawn,'gv '+filename
endif

end
