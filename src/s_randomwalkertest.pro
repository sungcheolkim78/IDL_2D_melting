;+
; Name: s_randomwalkertest
; Purpose: to calculate <x^2> = 2Dt
; Input: s_randomwalkertest, N
;-

pro s_randomwalkertest, N, trackn, option=option, ps = ps
on_error, 1

if not keyword_set(option) then option = 1
randomt = intarr(trackn, N)
randomt2 = intarr(trackn, N/2)

if keyword_set(ps) then begin
	set_plot,'ps'
	!p.font=1
	!p.charsize=1.0
	device, /encapsul, /color, /helvetica, bits=8
	filename = 'randomwalker'+strtrim(N,2)+'_'+strtrim(trackn,2)+'_'+strtrim(option,2)+'.eps'
	device, xsize=20, ysize=9, file=filename
endif

!p.multi=[0,2,1]
fsc_plot, [0,N], [-N/2,N/2], /nodata, xtitle='Steps', ytitle='<x>'
colorname = 'grn'+strtrim((indgen(trackn) mod 4)+1)
for i=0,trackn-1 do begin
	randomt(i,*) = randomwalker(N,seed=i) - indgen(N)
	fsc_plot, randomt(i,*), /overplot, color=colorname(i)
	if option eq 1 then randomt2(i,*) = s_msd(randomt(i,*),length=trackn) 
	if option eq 2 then randomt2(i,*) = s_msd(randomt(i,*),length=trackn,option=2)
	if option eq 3 then begin
		temp = randomt[i,0:N/2-1]
		randomt2(i,*) = temp^2
	endif
endfor
fsc_plot, total(randomt,1)/trackn, color='red6',/overplot, thick=2.0

std = fltarr(N/2)
for i=0,N/2-1 do std(i) = stddev(randomt2(*,i))

fsc_plot, total(randomt2,1)/trackn, xtitle='Steps', ytitle='<x^2>',/nodata
for i=0,trackn-1 do fsc_plot,randomt2(i,*),/overplot, color=colorname(i)
fsc_plot, total(randomt2,1)/trackn, color='red6',/overplot, thick=2.0
;oploterror, total(randomt2,1)/trackn, std,errcolor='blu3',/nohat,psym=3

if keyword_set(ps) then begin
	device,/close
	spawn,'gv '+filename
	set_plot,'x'
endif

!p.multi=[0,1,1]
end
