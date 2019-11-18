;+
; Name: attinfo
;
; show averaged displacement, velocity, accelation by time
;
;-

pro attinfo, tt, startf, stopf, tr=tr, nosave=nosave, $
	timefactor=timefactor, prefix = prefix, $
	rmax=rmax, stimef=stimef, etimef=etimef, quick=quick

	; variables setup
	length = fix(max(tt(5,*)))
	mumpixel = 0.083
	tiframe = 1/30.
	
	if n_params() eq 1 then begin
		startf = 1
		stopf = length
		if (stopf-startf) ge length then stopf=length+startf-1
	endif
	if not keyword_set(timefactor) then timefactor=1./30.
	if not keyword_set(tr) then tr=1
	if not keyword_set(prefix) then prefix = ''
	if not keyword_set(rmax) then rmax = 50
	if not keyword_set(stimef) then stimef = stopf-30
	if not keyword_set(etimef) then etimef = stopf

	; clip the section of frame between startf and stopf
	ttc = eclip(tt,[5,startf,stopf])
	if n_elements(ttc(*,0)) ne 7 then begin
		print, 'Data is not tt data'
		return
	endif
	nff = n_elements(tt(0,where(tt(5,*) eq startf)))
	density = nff/(640.*480.*0.083*0.083)

	; calculate velocity
	dx = getdx(ttc,tr,dim=2)
	dx(0,*) = dx(0,*)*30.*mumpixel/float(tr)    ; divide by gap number
	dx(1,*) = dx(0,*)*30.*mumpixel/float(tr)
	; calculate electric field direction (by total average dx)
	edx = abs(total(dx(0,*)))
	edy = abs(total(dx(1,*)))
	edr = sqrt(edx^2+edy^2)
	edx = edx/edr & edy = edy/edr
	print,edx,edy
	edvr = dx(0,*)*edx + dx(1,*)*edy

	; calculate average velocity over time
	avx = avgbin(ttc(5,*),dx(0,*))
	avy = avgbin(ttc(5,*),dx(1,*))
	avv = avgbin(ttc(5,*),edvr)

	; calculate average position over time
	ax = avgbin(ttc(5,*),ttc(0,*))
	ay = avgbin(ttc(5,*),ttc(1,*))

	vr = mean(edvr)
	vx = mean(avx(1,*))
	vy = mean(avy(1,*))

	xx = mean(ttc(0,*))
	yy = mean(ttc(1,*))

	filename = prefix+'ttinfo'+strtrim(string(startf),2)+$
		'_'+strtrim(string(stopf),2)+'_'+strtrim(string(tr),2)+'.eps'
	set_plot,'ps'
	!p.font=0
	!p.multi=[0,2,3]
	!p.thick=1.7
	device,/encapsul,/color,bits_per_pixel=8,/helvetica
	device,xsize=16.6,ysize=16.6*1.418,file=filename

	; plot velocity
	fsc_plot,avv(0,*)*timefactor,avv(1,*)*mumpixel,xtitle='Time (sec)',ytitle='<Vx> (um/s)',axiscolor=fsc_color('blk7'),color=fsc_color('blu7'),xran=[startf,stopf]*timefactor,xstyle=1
	plots,[startf,stopf]*timefactor,[vr,vr],linestyle=2, color=fsc_color('grn5')
	fsc_plot,avx(0,*)*timefactor,avx(1,*)*mumpixel,color=fsc_color('red3'),/overplot
	plots,[startf,stopf]*timefactor,[vx,vx],linestyle=2, color=fsc_color('grn5')
	fsc_plot,avy(0,*)*timefactor,avy(1,*)*mumpixel,color=fsc_color('red4'),/overplot
	plots,[startf,stopf]*timefactor,[vy,vy],linestyle=2, color=fsc_color('grn5')

	; find peak
	result = peakfinder(avv(1,*),avv(0,*),/opt)
	wp = where(result(4,*) ge 0.5, wpc)
	for i=0,wpc-1 do fsc_text,result(1,wp(i))*timefactor,result(2,wp(i))*mumpixel,$
		string(result(1,wp(i)),format='(I4)'),/data, charsize=0.7
	resulti = peakfinder(-avv(1,*),avv(0,*),/opt)
	wp = where(resulti(4,*) ge 0.5, wpc)
	for i=0,wpc-1 do fsc_text,resulti(1,wp(i))*timefactor,-resulti(2,wp(i))*mumpixel,$
		string(resulti(1,wp(i)),format='(I4)'),/data, charsize=0.7

	; plot trace of several frames
	ttc = eclip(tt,[5,stimef,etimef])
	fsc_plot,ttc(0,*)*mumpixel,ttc(1,*)*mumpixel,psym=3,axiscolor=fsc_color('blk7'),color=fsc_color('brown'),xstyle=1,ystyle=1,ytitle=strtrim(string(stimef),2)+' to '+strtrim(string(etimef),2)

	; plot average coordinate
	fsc_plot,ax(0,*)*timefactor,ax(1,*)*mumpixel,xtitle='Time (sec)',ytitle='<X> (um)',/ynozero,axiscolor=fsc_color('blk7'),color=fsc_color('blu7'),xran=[startf,stopf]*timefactor,xstyle=1
	plots,[startf,stopf]*timefactor,[xx,xx],linestyle=2, color=fsc_color('grn5')

	fsc_plot,ay(0,*)*timefactor,ay(1,*)*mumpixel,xtitle='Time (sec)',ytitle='<Y> (um)',/ynozero,axiscolor=fsc_color('blk7'),color=fsc_color('blu7'),xran=[startf,stopf]*timefactor,xstyle=1
	plots,[startf,stopf]*timefactor,[yy,yy],linestyle=2, color=fsc_color('grn5')

	if not keyword_set(quick) then begin
		; plot gr
		if density lt 1.0 then gr6 = g6(tt, 0, 7,/quiets)
		if density ge 1.0 then gr6 = g6(tt, 0, 2,/quiets)
		fsc_plot,gr6(0,*)*mumpixel,sqrt(gr6(1,*)^2+gr6(2,*)),axiscolor='blk7',$
			color=fsc_color('blu5'),xtitle='Radius (um)',$
			ytitle='g6(r) for 15 frames',ystyle=2,xstyle=1
		fsc_plot,gr6(0,*)*mumpixel,gr6(3,*),axiscolor='blk7',$
			color=fsc_color('grn5'),xtitle='Radius (um)',$
			ytitle='g(r) for 15 frames',ystyle=2,xstyle=1
	endif

	device,/close
	set_plot,'x'
	!p.multi=[0,1,1]
	!p.font=-1

	spawn,'gv '+filename
end
