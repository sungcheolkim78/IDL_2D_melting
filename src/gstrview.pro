;+
; Name: gstrview
; Purpose: show one track with lattice and also msd
; Input: gstrview, ptdef, tt, frame
; History:
; 	created on 8/1/17 by SCK
;-

pro gstrview, ptdef, tt, frame, ps=ps, startf=startf, stopf=stopf, $
	tlength=tlength
	on_error,2

	tmax = max(ptdef(2,*), min=tmin)
	wmin = tmin 
	wmax = tmax 
	if keyword_set(startf) then wmin = startf
	if keyword_set(stopf) then wmax = stopf

	xmax = max(ptdef(0,wmin-tmin:wmax-tmin)*0.083, min=xmin)
	ymax = max(ptdef(1,wmin-tmin:wmax-tmin)*0.083, min=ymin)
	print, wmin, tmin
	print, wmax, tmax
    ratio = (ymax-ymin)/(xmax-xmin+1*0.083)
    if ratio gt 1 then xsize = 17.8/ratio else xsize=17.8

	thisDevice = !d.name
	!p.multi = [0,1,1]
	!p.charsize = 1.0

	if n_elements(ps) then begin
		set_plot,'ps'
		!p.font=0
		filename = 'st_'+strtrim(fix(wmin),2)+'_'+strtrim(fix(wmax),2)+'.eps'
		device, /color, /helvetica, /encapsul, bits=8
		device, xsize=xsize, ysize=xsize*ratio,file=filename
	endif

	cgplot, ptdef(0,wmin-tmin:wmax-tmin)*0.083, ptdef(1,wmin-tmin:wmax-tmin)*0.083, charsize=1.0 $
		, /ynozero, xtitle='x (um)', ytitle = 'y (um)' $
		, symcolor='blk8', color='blu4', psym=-16, symsize=0.3 $
		, xran=[xmin-1,xmax+1], yran=[ymin-1,ymax+1] $
		, xstyle=1, ystyle=1
	cgplots, fsc_circle(ptdef(0,wmin-tmin)*0.083,ptdef(1,wmin-tmin)*0.083,0.4), color='blu4'
    ttc = tt(*,where(tt(5,*) eq frame))
    i_defdraw, ttc*0.083, /overplot, /tri, field=[xmin-1,xmax+1,ymin-1,ymax+1]

	!p.multi = [0,1,1]

	if n_elements(ps) then i_close, filename, thisDevice

end

