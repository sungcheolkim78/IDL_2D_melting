;+
; Name: latticeconstant
; Purpose: Calculate density for one particle
; Input: latticeconstant(pt, frame)
; Usage: when frame = -1, then use pt as one frame data
;-

function latticeconstant,pt,frame,tr=tr,verbose=verbose, option=option
on_error,2

	; check frame for quicker excution
	if frame eq -1 then ptc = pt else ptc = eclip(pt,[5,frame,frame])
	; check triangulate info
	if not keyword_set(tr) then triangulate, ptc(0,*),ptc(1,*),tr
	if not keyword_set(option) then option = 0

	minx = min(ptc(0,*),max=maxx)
	miny = min(ptc(1,*),max=maxy)
	nc = n_elements(ptc(0,*))
	density = nc/((maxx-minx)*(maxy-miny))
	mdis = sqrt(1./density)

	wr = where(ptc(0,*) gt min(ptc(0,*))+mdis*1.5 and $
		ptc(0,*) lt max(ptc(0,*))-mdis*1.5 and $
		ptc(1,*) gt min(ptc(1,*))+mdis*1.5 and $
		ptc(1,*) lt max(ptc(1,*))-mdis*1.5, wrc)
	distance = fltarr(2,wrc)
	
	for i=0,wrc-1 do begin
		distance(0,i) = sqrt((ptc(0,tr(0,wr(i)))-ptc(0,tr(1,wr(i))))^2+ $
			(ptc(1,tr(0,wr(i)))-ptc(1,tr(1,wr(i))))^2)
		distance(1,i) = sqrt((ptc(0,tr(0,wr(i)))-ptc(0,tr(2,wr(i))))^2+ $
			(ptc(1,tr(0,wr(i)))-ptc(1,tr(2,wr(i))))^2)
		if distance(0,i) gt mdis*1.5 or distance(0,i) lt mdis/2. then begin
			distance(0,i) = 0.
		endif
		if distance(1,i) gt mdis*1.5 or distance(1,i) lt mdis/2. then begin
			distance(1,i) = 0.
		endif
	endfor

	w0 = where(distance(0,*) gt 0)
	w1 = where(distance(1,*) gt 0)
	distarr = [[distance(0,w0)],[distance(1,w1)]]*0.083
	binsize=0.02
	hist = histogram(distarr, locations=loc,binsize=binsize)
	binCenters = loc + (binsize/2.)
	yfit = GaussFit(binCenters, hist, coeff, NTERMS=3)

	if keyword_set(verbose) then begin

		set_plot,'ps'
		!p.font=0
		!p.multi=[0,1,1]
		device,/color,/encap,/helvetica,bits=8
		device,xsize=17.6, ysize=17.6*0.86, file='temp.eps'

		histoplot,distarr,/fill,binsize=binsize,xtitle=$
			'Distance ('+Greek('mu')+'m)'
		oplot, binCenters, yfit, color = fsc_color('blu5')
		centerfit = string(coeff[1],format='(F0.3)')
		sigmafit = string(coeff[2],format='(F0.3)')
		mdisstr = string(mdis*0.083,format='(F0.3)')
		lconstr = string(mean(distarr),format='(F0.3)')
		fsc_text, 0.6, 0.80, 'Gaussian fitted L: '+centerfit+$
			ps_symbol('pm')+sigmafit, color='blu7',/normal
		fsc_text, 0.6, 0.75, ps_symbol('<')+'L'+ps_symbol('>')+' from density: '+mdisstr, color='blu7',/normal
		fsc_text, 0.6, 0.70, ps_symbol('<')+'L'+ps_symbol('>')+$
			' from lattice: '+lconstr+ps_symbol('pm')+$
			string(stddev(distarr),format='(F0.3)'), color='blu7',/normal

		device,/close
		set_plot,'x'
		spawn,'gv temp.eps'
	endif

	if option eq 0 then result = coeff[1] $
		else if option eq 1 then result = mean(distarr) $
		else if option eq 2 then result = mdis*0.083

	return, result
end	
