;+
; Name: attview
; Purpose: show averaged displacement, velocity, accelation by time
; Inputs:
; History:
;   created by sungcheol kim
; 	modified 4/20/11 by sungcheol kim
; 		add module to save frame velocity 
;-

pro attview, tt, startf, stopf, tr=tr, nosave=nosave, prefix = prefix

on_error,2

if n_params() eq 1 then begin
	startf = min(tt(5,*), max=stopf)
endif
if n_params() eq 2 then begin
	stopf = max(tt(5,*))
endif
if n_params() eq 3 then begin
	maxf = max(tt(5,*), min=minf)
	if stopf gt maxf then stopf=maxf
	if startf lt minf then startf = minf
endif

	; variables setup
	startf = fix(startf)
	stopf = fix(stopf)
	length = stopf-startf+1
	
	if not keyword_set(tr) then tr=2
	if not keyword_set(prefix) then prefix = 'ttview'

	; clip the section of frame between startf and stopf
	ttc = eclip(tt,[5,startf,stopf])
	dx = getdx(ttc,tr,dim=2)
	dx(0,*) = dx(0,*)/tr    ; divide by gap number
	dx(1,*) = dx(1,*)/tr

	; calculate average velocity over time
	avx = avgbin(ttc(5,*),dx(0,*),binsize=1)
	avy = avgbin(ttc(5,*),dx(1,*),binsize=1)
	vx = mean(avx(1,*))*0.083/(tr/30.)
	vy = mean(avy(1,*))*0.083/(tr/30.)

	; calculate average position over time
	ax = avgbin(ttc(5,*),ttc(0,*),binsize=1)
	ay = avgbin(ttc(5,*),ttc(1,*),binsize=1)
	xx = mean(ax(1,*))*0.083
	yy = mean(ay(1,*))*0.083

	; calculate time
	x = (indgen(length)+startf)/30.

	result = fltarr(length,5)
	result(*,0) = x
	result(*,1) = ax(1,*)*0.083
	result(*,2) = ay(1,*)*0.083
	result(*,3) = avx(1,*)*0.083/(tr/30.)
	result(*,4) = avy(1,*)*0.083/(tr/30.)
	write_gdf,result,'f.ti'+strtrim(startf,2)+'_'+strtrim(stopf,2)

	filename = prefix+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)+'_'+strtrim(string(tr),2)+'.eps'
	set_plot,'ps'
	!p.font = 0
	!p.charsize = 1.
	!p.multi=[0,2,2]
	device,/encapsul,/color,bits_per_pixel=8,/helvetica
	device,xsize=17.8,ysize=17.8*3.5/4.,file=filename

	; plot velocity from 0 - 900 (30seconds)
	cgplot,x,result(*,3),xtitle='Time (sec)',ytitle=ps_symbol('<')+'V!Dx!N'+ps_symbol('>')+' ('+greek('mu')+'m/s)' $
		,color='blu6',xstyle=1
	cgplots,[startf,stopf]/30.,[vx,vx],linestyle=2, color='grn5'
	
	cgplot,x,result(*,4),xtitle='Time (sec)',ytitle=ps_symbol('<')+'V!Dy!N'+ps_symbol('>')+' ('+greek('mu')+'m/s)'$
		,color='blu6',xstyle=1
	cgplots,[startf,stopf]/30.,[vy,vy],linestyle=2, color='grn5'
	
	; plot average coordinate
	cgplot,x,result(*,1),xtitle='Time (sec)',ytitle=ps_symbol('<')+'X'+ps_symbol('>')+' ('+greek('mu')+'m)',color='blu6',/ynozero,xstyle=1
	cgplots,[startf,stopf]/30.,[xx,xx],linestyle=2, color='grn5'
	
	cgplot,x,result(*,2),xtitle='Time (sec)',ytitle=ps_symbol('<')+'Y'+ps_symbol('>')+' ('+greek('mu')+'m)',color='blu6',/ynozero,xstyle=1
	cgplots,[startf,stopf]/30.,[yy,yy],linestyle=2, color='grn5'
	
	device,/close
	set_plot,'x'
	spawn,'gv '+filename
	!p.multi=[0]
	!p.font=0

end
