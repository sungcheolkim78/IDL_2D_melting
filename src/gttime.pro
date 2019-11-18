;+
; Name: attinfo
;
; show averaged displacement, velocity, accelation by time
;
;-

pro gttime, tt,startf=startf, stopf=stopf, tr=tr, nosave=nosave, timefactor=timefactor, prefix = prefix

	; variables setup
	length = fix(max(tt(5,*)))
	
	if not keyword_set(timefactor) then timefactor=1.
	if not keyword_set(startf) then startf=1
	if not keyword_set(stopf) then stopf=length
	if stopf ge length then stopf=length
	if not keyword_set(tr) then tr=2
	if not keyword_set(prefix) then prefix = 'ttime'

	; clip the section of frame between startf and stopf
	ttc = eclip(tt,[5,startf,stopf])
	dx = getdx(ttc,tr,dim=2)
	dx(0,*) = dx(0,*)/tr    ; divide by gap number
	dx(1,*) = dx(0,*)/tr

	w = where(dx(2,*) gt 0)

	; calculate average velocity over time
	avx = avgbin(ttc(5,w),dx(0,w))
	avy = avgbin(ttc(5,w),dx(1,w))

	; calculate average position over time
	ax = avgbin(ttc(5,w),ttc(0,w))
	ay = avgbin(ttc(5,w),ttc(1,w))

	vx = mean(dx(0,*))
	vy = mean(dx(1,*))

	xx = mean(ttc(0,*))
	yy = mean(ttc(1,*))

	filename = prefix+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)+'_'+strtrim(string(tr),2)+'.eps'
	set_plot,'ps'
	device,/encapsul,/color,bits_per_pixel=8
	device,file=filename
	!p.font=1
	!p.multi=[0,2,2]

	; plot velocity
	plot,avx(0,*)*timefactor,avx(1,*),xtitle='Time',ytitle='Average V_x',color=fsc_color('blk7'),/nodata
	oplot,avx(0,*)*timefactor,avx(1,*),color=fsc_color('blu7')
	plots,[startf,stopf]*timefactor,[vx,vx],linestyle=2, color=fsc_color('grn5')
	
	plot,avy(0,*)*timefactor,avy(1,*),xtitle='Time',ytitle='Average V_y',color=fsc_color('blk7'),/nodata
	oplot,avy(0,*)*timefactor,avy(1,*),color=fsc_color('blu7')
	plots,[startf,stopf]*timefactor,[vy,vy],linestyle=2, color=fsc_color('grn5')

	; plot average coordinate
	plot,ax(0,*)*timefactor,ax(1,*),xtitle='Time',ytitle='Average X',/ynozero,color=fsc_color('blk7'),/nodata
	oplot,ax(0,*)*timefactor,ax(1,*),color=fsc_color('blu7')
	plots,[startf,stopf]*timefactor,[xx,xx],linestyle=2, color=fsc_color('grn5')

	plot,ay(0,*)*timefactor,ay(1,*),xtitle='Time',ytitle='Average Y',/ynozero,color=fsc_color('blk7'),/nodata
	oplot,ay(0,*)*timefactor,ay(1,*),color=fsc_color('blu7')
	plots,[startf,stopf]*timefactor,[yy,yy],linestyle=2, color=fsc_color('grn5')

	!p.multi=[0,1,1]
	device,/close
	set_plot,'x'
	spawn,'gv '+filename

end
