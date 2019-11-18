;+
; Name: avolinfo
; Purpose: show voltage dependence of average velocity and defect density
; Input: avolinfo, fvol, fdef
;-

pro avolinfo, fvol, fdef, prefix=prefix, bins=bins
on_error, 2

nf = n_elements(fvol(0,*))
nf2 = n_elements(fdef(0,*))
if nf ne nf2 then begin
	message,'elements are not matched!',/info
	return
endif
if not keyword_set(prefix) then prefix=''
if not keyword_set(bins) then bins=1

histersis = fltarr(nf)
histersis(0:nf-2) = fvol(1,1:nf-1)-fvol(1,0:nf-2)
histersis(nf-1) = histersis(nf-2)
wup = where(histersis ge 0)
wdown = where(histersis le 0)

volvel1 = avgbin(fvol(1,wup),fvol(3,wup),binsize=bins)
volvel2 = avgbin(fvol(1,wdown),fvol(3,wdown),binsize=bins)
volvel1(0,*) = volvel1(0,*)+bins/2.
volvel2(0,*) = volvel2(0,*)+bins/2.

volden1 = avgbin(fvol(1,wup),fdef(1,wup),binsize=bins)
volden2 = avgbin(fvol(1,wdown),fdef(1,wdown),binsize=bins)
volden1(0,*) = volden1(0,*)+bins/2.
volden2(0,*) = volden2(0,*)+bins/2.

voldef1 = avgbin(fvol(1,wup),fdef(0,wup),binsize=bins)
voldef2 = avgbin(fvol(1,wdown),fdef(0,wdown),binsize=bins)
voldef1(0,*) = voldef1(0,*)+bins/2.
voldef2(0,*) = voldef2(0,*)+bins/2.

volbal1 = avgbin(fvol(1,wup),fdef(2,wup),binsize=bins)
volbal2 = avgbin(fvol(1,wdown),fdef(2,wdown),binsize=bins)
volbal1(0,*) = volbal1(0,*)+bins/2.
volbal2(0,*) = volbal2(0,*)+bins/2.

set_plot,'ps'
!p.font=0
!p.multi=[0,2,2]
!p.charsize=0.95
filename = prefix+'avolinfo.eps'
device,/color,/encapsul,/helvetica,bits=8
device,xsize=18,ysize=18*0.9,file=filename

; plot velocity vs voltage
fsc_plot,fvol(1,*),fvol(3,*),psym=3,/ynozero,color='grn4',$
	xtitle='Voltage (V)', ytitle='Velocity (um/s)', ystyle=1
fsc_plot,volvel1(0,*),volvel1(1,*),/overplot,color='blu7'
fsc_plot,volvel2(0,*),volvel2(1,*),/overplot,color='red7'
errplot,volvel1(0,*),volvel1(1,*)+volvel1(2,*)/2.,volvel1(1,*)-volvel1(2,*)/2.,$
	color=fsc_color('blu3')
errplot,volvel2(0,*),volvel2(1,*)+volvel2(2,*)/2.,volvel2(1,*)-volvel2(2,*)/2.,$
	color=fsc_color('red3')
fsc_plot,[0,0],[-2,2],color='blk5',linestyle=2,/overplot
al_legend,['up','down'],colors=[fsc_color('blu7'),fsc_color('red7')],psym=[14,14],$
	charsize=0.8,textcolors=[fsc_color('blu7'),fsc_color('red7')]

fsc_plot,fvol(1,*),fdef(1,*),psym=3,/ynozero,color='grn4',$
	xtitle='Voltage (V)', ytitle='Density (um!U-2!N)', ystyle=1
fsc_plot,volden1(0,*),volden1(1,*),/overplot,color='blu7'
fsc_plot,volden2(0,*),volden2(1,*),/overplot,color='red7'
errplot,volden1(0,*),volden1(1,*)+volden1(2,*)/2.,volden1(1,*)-volden1(2,*)/2.,$
	color=fsc_color('blu3')
errplot,volden2(0,*),volden2(1,*)+volden2(2,*)/2.,volden2(1,*)-volden2(2,*)/2.,$
	color=fsc_color('blu3')
fsc_plot,[0,0],[0,2],color='blk5',linestyle=2,/overplot
al_legend,['up','down'],colors=[fsc_color('blu7'),fsc_color('red7')],psym=[14,14],$
	charsize=0.8,textcolors=[fsc_color('blu7'),fsc_color('red7')]

fsc_plot,fvol(1,*),fdef(0,*),psym=3,/ynozero,color='grn4',$
	xtitle='Voltage (V)', ytitle='Defect Density (um!U-2!N)', ystyle=1
fsc_plot,voldef1(0,*),voldef1(1,*),/overplot,color='blu7'
fsc_plot,voldef2(0,*),voldef2(1,*),/overplot,color='red7'
errplot,voldef1(0,*),voldef1(1,*)+voldef1(2,*)/2.,voldef1(1,*)-voldef1(2,*)/2.,$
	color=fsc_color('blu3')
errplot,voldef2(0,*),voldef2(1,*)+voldef2(2,*)/2.,voldef2(1,*)-voldef2(2,*)/2.,$
	color=fsc_color('red3')
fsc_plot,[0,0],[0,1],color='blk5',linestyle=2,/overplot
al_legend,['up','down'],colors=[fsc_color('blu7'),fsc_color('red7')],psym=[14,14],$
	charsize=0.8,textcolors=[fsc_color('blu7'),fsc_color('red7')]

fsc_plot,fvol(1,*),fdef(2,*),psym=3,/ynozero,color='grn4',$
	xtitle='Voltage (V)', ytitle='Balance', ystyle=1
fsc_plot,volbal1(0,*),volbal1(1,*),/overplot,color='blu7'
fsc_plot,volbal2(0,*),volbal2(1,*),/overplot,color='red7'
errplot,volbal1(0,*),volbal1(1,*)+volbal1(2,*)/2.,volbal1(1,*)-volbal1(2,*)/2.,$
	color=fsc_color('blu3')
errplot,volbal2(0,*),volbal2(1,*)+volbal2(2,*)/2.,volbal2(1,*)-volbal2(2,*)/2.,$
	color=fsc_color('red3')
fsc_plot,[0,0],[-20,20],color='blk5',linestyle=2,/overplot
al_legend,['up','down'],colors=[fsc_color('blu7'),fsc_color('red7')],psym=[14,14],$
	charsize=0.8,textcolors=[fsc_color('blu7'),fsc_color('red7')]

device,/close
set_plot,'x'
!p.multi=[0,1,1]
spawn, 'gv '+filename

end
