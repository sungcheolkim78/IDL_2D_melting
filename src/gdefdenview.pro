;+
; Name: gdefdenview
; Purpose: show defect density distribution for each frame
; Input: gdefdenview, f.dd
; History:
; 	created on 4/14/11 by sungcheol kim
; 	modified on 4/20/11 by sungcheol kim
; 		added velocity graph
;-

pro gdefdenview, fdd, fti, verbose=verbose, tzero=tzero, dpsf=dpsf

on_error,2

tr = 2
trackf = 0
if n_params() eq 1 then stopf = max(fdd(*,0), min=startf)
if n_params() eq 2 then begin
	stopf = max(fdd(*,0), min=startf)
	index = fix(fti(*,0)*30.)
	tmaxf = max(index, min=tminf)
	if startf ge tminf then tminf = startf
	if stopf le tmaxf then tmaxf = stopf
	ftic = fti(tminf:tmaxf,*)
	trackf = 1
endif

if n_elements(verbose) eq 0 then verbose=0
if n_elements(dpsf) eq 0 then dpsf=0
if n_elements(tzero) eq 1 then begin
	x = findgen(stopf-startf+1)/30.
endif else begin
	x = fdd(*,0)/30.
endelse

set_plot,'ps'
!p.multi = [0,2,1]
!p.font = 0
!p.charsize = 0.8
!p.thick = 1.5
device, /color, /encapsul, /helvetica, bits=8
filename = 'gdden_'+strtrim(startf,2)+'_'+strtrim(stopf,2)+'.eps'
device, xsize=17.8, ysize=17.8*1.8/4., file=filename

disclinationAbsCharge = float(fdd(*,3)+fdd(*,4))
disclinationNetCharge = float(fdd(*,4)-fdd(*,3))
freeDisclination = disclinationAbsCharge - 2.*fdd(*,2)
freeDislocation = float(fdd(*,5))
boundDislRatio = float(fdd(*,2)-fdd(*,5))/fdd(*,2)
ymax = max(disclinationAbsCharge/fdd(*,1))

cgplot, x, disclinationAbsCharge, xtitle='time (sec)', ytitle='defect density' $
	, xstyle=1, psym=-14, color='blu5', symsize=0.5
if trackf then begin
	cgplot, x, sqrt(ftic(*,3)^2+ftic(*,4)^2)/4, color='blk4',/overplot
	axis, yaxis=1, yran = !y.crange*4,$
		ytitle=ps_symbol('<')+'V'+ps_symbol('>')+' ('+greek('mu')+'m/s)'
endif
cgplots, x, freeDislocation $
	, psym=-16, color='red5', symsize=0.5

if verbose then begin
	cgplot, x, float(fdd(*,3))/fdd(*,1) $
		, psym=-16, color='grn5', symsize=0.5, /overplot
	cgplot, x, float(fdd(*,4))/fdd(*,1) $
		, psym=-16, color='grn3', symsize=0.5, /overplot
endif
al_legend, ['Disclinations','Dislocations'], psym=[14,16], colors=['blu5','red5'] $
	, textcolors=['blu5','red5'], charsize=0.6

cgplot, x, float(fdd(*,2)-fdd(*,5))/fdd(*,2), xtitle='time (sec)', ytitle='bound defects ratio' $
	, xstyle=1, psym=-16, color='red5', symsize=0.5
if trackf then begin
	cgplot, x, sqrt(ftic(*,3)^2+ftic(*,4)^2), color='blk4',/overplot
	axis, yaxis=1, yran = !y.crange,$
		ytitle=ps_symbol('<')+'V'+ps_symbol('>')+' ('+greek('mu')+'m/s)'
endif
cgplot, x, (disclinationAbsCharge-freeDisclination)/disclinationAbsCharge $
	, psym=-14, color='blu5', symsize=0.5, /overplot
if mean(boundDislRatio) gt 0.3 then begin
	al_legend, ['Disclinations','Dislocations'], psym=[14,16], /bottom, colors=['blu5','red5'] $
		, textcolors=['blu5','red5'], charsize=0.6, /left
endif else begin
	al_legend, ['Disclinations','Dislocations'], psym=[14,16], /center, colors=['blu5','red5'] $
		, textcolors=['blu5','red5'], charsize=0.6, /left
endelse

if dpsf then begin
	nf = n_elements(disclinationAbsCharge)
	v = fft(disclinationAbsCharge)
	f = findgen(nf/2+1) / (nf*1.)
	cgplot, f, abs(v(0:nf/2))^2, /ylog, /xlog, xstyle=1, xran=[0.0001,0.1],/noerase, position=[0.75, 0.20, 0.95, 0.55], charsize=0.8
endif


device, /close
set_plot,'x'
spawn, 'gv '+filename

end
