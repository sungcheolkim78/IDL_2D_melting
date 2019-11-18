;+
; Name: attinfo
;
; show averaged displacement, velocity, accelation by time
;
;-

pro attinfo, tt, startf, stopf, tr=tr, nosave=nosave, $
	prefix = prefix, bin=bin, tol=tol, quiet=quiet
on_error,2

	; variables setup
	length = fix(max(tt(5,*)))
	mupixel = 0.083
	timefactor = 1/30.
	
	if n_params() eq 1 then begin
		startf = 0
		stopf = length+1
		if (stopf-startf) ge length then stopf=length+startf
	endif
	if not keyword_set(bin) then bin=3
	if not keyword_set(tr) then tr=1
	if not keyword_set(prefix) then prefix = ''
	if not keyword_set(tol) then tol = 0.5

	; clip the section of frame between startf and stopf
	ttc = eclip(tt,[5,startf,stopf])
	if n_elements(ttc(*,0)) ne 7 then begin
		print, 'Data is not tt data'
		return
	endif

	; calculate velocity
	dx = getdx(ttc,tr,dim=2)
	dx(0,*) = dx(0,*)*mupixel/float(tr)/timefactor
	dx(1,*) = dx(1,*)*mupixel/float(tr)/timefactor
	dx(2,*) = dx(2,*)*mupixel/float(tr)/timefactor
	ex = mean(dx(0,*)) & ey = mean(dx(1,*))
	er = sqrt(ex^2+ey^2)
	ex = ex/er & ey = ey/er
	print, ex, ey
	dv = dx(0,*)*ex + dx(1,*)*ey

	; calculate average velocity over time
	avx = avgbin(ttc(5,*),dx(0,*),binsize=bin)
	avy = avgbin(ttc(5,*),dx(1,*),binsize=bin)
	avv = avgbin(ttc(5,*),dx(2,*),binsize=bin)
	ave = avgbin(ttc(5,*),dv,binsize=bin)
	ax = avgbin(ttc(5,*),ttc(0,*),binsize=bin)
	ay = avgbin(ttc(5,*),ttc(1,*),binsize=bin)

	filename = prefix+'ttinfo'+strtrim(string(startf),2)+$
		'_'+strtrim(string(stopf),2)+'_'+strtrim(string(tr),2)+'.eps'
	set_plot,'ps'
	!p.font=0
	!p.multi=[0,2,3]
	!p.charsize = 1.2
	device,/encapsul,/color,bits_per_pixel=8,/helvetica
	device,xsize=16.6,ysize=16.6*1.418,file=filename

	; plot x-velocity
	fsc_plot,avx(0,*)*timefactor,avx(1,*),xtitle='Time (sec)',$
		ytitle='<V!Dx!N> (um/s)',/ynozero,color=fsc_color('red4'),xstyle=1
	vx = mean(avx(1,*))
	fsc_plots,[startf,stopf]*timefactor,[vx,vx],linestyle=2, color=fsc_color('blk4')

	result = peakfinder(avx(1,*),avx(0,*),/opt)
	wp = where(result(4,*) ge tol, wpc)
	for i=0,wpc-1 do fsc_text,result(1,wp(i))*timefactor,result(2,wp(i)),$
		string(result(1,wp(i)),format='(I4)'),/data, charsize=0.7
	resulti = peakfinder(-avx(1,*),avx(0,*),/opt)
	wp = where(resulti(4,*) ge tol, wpc)
	for i=0,wpc-1 do fsc_text,resulti(1,wp(i))*timefactor,-resulti(2,wp(i)),$
		string(resulti(1,wp(i)),format='(I4)'),/data, charsize=0.7

	; plot y-velocity
	fsc_plot,avy(0,*)*timefactor,avy(1,*),xtitle='Time (sec)',$
		ytitle='<V!Dy!N> (um/s)',/ynozero, color=fsc_color('red4'), xstyle=1
	vy = mean(avy(1,*))
	fsc_plots,[startf,stopf]*timefactor,[vy,vy],linestyle=2, color=fsc_color('blk4')

	result = peakfinder(avy(1,*),avy(0,*),/opt)
	wp = where(result(4,*) ge tol, wpc)
	for i=0,wpc-1 do fsc_text,result(1,wp(i))*timefactor,result(2,wp(i)),$
		string(result(1,wp(i)),format='(I4)'),/data, charsize=0.7
	resulti = peakfinder(-avy(1,*),avy(0,*),/opt)
	wp = where(resulti(4,*) ge tol, wpc)
	for i=0,wpc-1 do fsc_text,resulti(1,wp(i))*timefactor,-resulti(2,wp(i)),$
		string(resulti(1,wp(i)),format='(I4)'),/data, charsize=0.7

	; plot average coordinate
	fsc_plot,ax(0,*)*timefactor,ax(1,*),xtitle='Time (sec)',$
		ytitle='<X> (um)',/ynozero,color=fsc_color('blu7'),xstyle=1
	xx = mean(ax(1,*))
	fsc_plots,[startf,stopf]*timefactor,[xx,xx],linestyle=2, color=fsc_color('grn5')

	fsc_plot,ay(0,*)*timefactor,ay(1,*),xtitle='Time (sec)',$
		ytitle='<Y> (um)',/ynozero,color=fsc_color('blu7'),xstyle=1
	yy = mean(ay(1,*))
	fsc_plots,[startf,stopf]*timefactor,[yy,yy],linestyle=2, color=fsc_color('grn5')

	; plot velocity
	fsc_plot,avv(0,*)*timefactor,avv(1,*),xtitle='Time (sec)',$
		ytitle='<V> (um/s)',color=fsc_color('grn5'), xstyle=1, /ynozero
	vr = mean(avv(1,*))
	fsc_plots,[startf,stopf]*timefactor,[vr,vr],linestyle=2, color=fsc_color('grn5')
	result = peakfinder(avv(1,*),avv(0,*),/opt)
	wp = where(result(4,*) ge tol, wpc)
	for i=0,wpc-1 do fsc_text,result(1,wp(i))*timefactor,result(2,wp(i)),$
		string(result(1,wp(i)),format='(I4)'),/data, charsize=0.7
	resulti = peakfinder(-avv(1,*),avv(0,*),/opt)
	wp = where(resulti(4,*) ge tol, wpc)
	for i=0,wpc-1 do fsc_text,resulti(1,wp(i))*timefactor,-resulti(2,wp(i)),$
		string(resulti(1,wp(i)),format='(I4)'),/data, charsize=0.7

	; plot velocity
	fsc_plot,ave(0,*)*timefactor,ave(1,*),xtitle='Time (sec)',$
		ytitle='<V!Dd!N> (um/s)',color=fsc_color('grn5'), xstyle=1, /ynozero
	vr = mean(ave(1,*))
	fsc_plots,[startf,stopf]*timefactor,[vr,vr],linestyle=2, color=fsc_color('grn5')
	result = peakfinder(ave(1,*),ave(0,*),/opt)
	wp = where(result(4,*) ge tol, wpc)
	for i=0,wpc-1 do fsc_text,result(1,wp(i))*timefactor,result(2,wp(i)),$
		string(result(1,wp(i)),format='(I4)'),/data, charsize=0.7
	resulti = peakfinder(-ave(1,*),ave(0,*),/opt)
	wp = where(resulti(4,*) ge tol, wpc)
	for i=0,wpc-1 do fsc_text,resulti(1,wp(i))*timefactor,-resulti(2,wp(i)),$
		string(resulti(1,wp(i)),format='(I4)'),/data, charsize=0.7

	fsc_text, 0.64, 0.32, '<V!Dd!N> = ('+string(ex,format='(F7.5)')+$
		','+string(ey,format='(F8.5)')+')', charsize=0.8, /normal
	fsc_text, 0.14, 0.32, 'Bin size = '+strtrim(bin,2)+$
		'     Tolerance = '+string(tol,format='(F3.1)'), charsize=0.8, /normal

	device,/close
	set_plot,'x'
	!p.multi=[0,1,1]
	!p.font=-1

	if not keyword_set(quiet) then spawn,'gv '+filename
end
