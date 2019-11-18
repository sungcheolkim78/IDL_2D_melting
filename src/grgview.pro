;+
; Name: grgview
; Purpose: show RG histogram of phi6 for each m
; Inputs: pt, frame, marr
;-

pro grgview, pt, frame, marr, ps=ps, prefix=prefix, option=option
on_error, 2

	if not keyword_set(prefix) then prefix = ''
	mupixel = 0.083
	ptc = pt(*, where(pt(5,*) eq frame))
	if n_elements(ptc(*,0)) eq 9 then phiarr = complex(ptc(7,*),ptc(8,*))
	if n_elements(ptc(*,0)) ne 9 then phiarr = phi6arr(ptc)

	xmin = min(ptc(0,*), max=xmax)
	ymin = min(ptc(1,*), max=ymax)
	nm = n_elements(marr)
	marrmax = max(marr)

	hist = fltarr(20,nm)
	; with each m
	for mi = 0, nm-1 do begin
		bx = (xmax-xmin)/float(marr(mi)+1.)
		by = (ymax-ymin)/float(marr(mi)+1.)
		phi6b = fltarr(marr(mi),marr(mi))
		ec = 0

		for i = 0, marr(mi)-1 do begin
			for j = 0, marr(mi)-1 do begin
				w = where( ptc(0,*) ge xmin+bx*i $
					and ptc(0,*) lt xmin+bx*(i+1) $
					and ptc(1,*) ge ymin+by*j $
					and ptc(1,*) lt ymin+by*(j+1),wc)
				if wc gt 0 then begin
					if not keyword_set(option) then phi6b(i,j) = abs(total(phiarr(w))/wc)
					if keyword_set(option) then phi6b(i,j) = total(abs(phiarr(w)))/wc
				endif else begin
					phi6b(i,j) = 1.
					ec++
				endelse
			endfor
		endfor

		if ec gt 0 then message,'M = '+strtrim(marr(mi),2)+' empty blocks: '+strtrim(ec,2), /info
		phi6b = reform(phi6b, marr(mi)*marr(mi))
		hist(*,mi) = histogram(phi6b,nbins=20)/float(marr(mi)^2)
	endfor

	if keyword_set(ps) then begin
		set_plot,'ps'
		!p.font=0
		!p.multi=[0,1,1]
		device,/color,/encapsul,/helvetica,bits=8
		filename = prefix+'grg_'+strtrim(n_elements(marr),2)+'.eps'
		device,xsize=16,ysize=16*0.86,file=filename
	endif

	if keyword_set(option) then xtitles = '<|'+greek('psi')+'!D6!N|>!DM'
	if not keyword_set(option) then xtitles = '|<'+greek('psi')+'!D6!N>!DM!N|'

	nbins = findgen(20)/19.
	ymax = max(hist)
	colors = fsc_color('blu'+strtrim((indgen(nm) mod 6)+3,2))
	items = 'M = '+strtrim(marr,2)
	fsc_plot,[0,1],[0,ymax],xtitle=xtitles,ystyle=2,/nodata
	for i=0,nm-1 do fsc_plot, nbins, hist(*,i), psym=-14-i,$
		color=colors(i), /overplot
	al_legend,items,psym=14+indgen(nm), colors=colors, textcolors=colors

	if keyword_set(ps) then begin
		device,/close
		set_plot,'x'
		spawn, 'gv '+filename
	endif
end
