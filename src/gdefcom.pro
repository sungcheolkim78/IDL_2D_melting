;+
; Name: gdefcom
; Purpose: compare two defect density information 
; Input: gdefcom, fdd1, fdd2
; History:
; 	created by sungcheol kim on 5/19/11
; 	modified by sungcheol kim on 5/23/11
; 		1. analysis only two data set
; 		2. add histogram plot
;-

pro gdefcom, fdd1, fdd2
on_error, 2

; compare two data

length1 = n_elements(fdd1(*,0))
length2 = n_elements(fdd2(*,0))

if length1 gt length2 then trackn = length2 else trackn = length1
x = findgen(trackn)/30.

; prepare plot
set_plot,'ps'
!p.multi = [0,2,3]
!p.font = 0
!p.charsize = 1.5
device, /color, /encapsul, /helvetica, bits=8
filename = 'gdcom_'+strtrim(length1,2)+'_'+strtrim(length2,2)+'.eps'
device, xsize=15.8, ysize=15.8*2.8/2., file=filename

disRatio1 = float(fdd1(*,3)+fdd1(*,4))/fdd1(*,1)
disRatio2 = float(fdd2(*,3)+fdd2(*,4))/fdd2(*,1)
freeDis1 = float(fdd1(*,3)+fdd1(*,4)-2*fdd1(*,2))/float(fdd1(*,3)+fdd1(*,4))
freeDis2 = float(fdd2(*,3)+fdd2(*,4)-2*fdd2(*,2))/float(fdd2(*,3)+fdd2(*,4))
freeDislo1 = float(fdd1(*,5))/float(fdd1(*,1))
freeDislo2 = float(fdd2(*,5))/float(fdd2(*,1))

; plot disclination numbers
cgplot, x, disRatio2, color='blu5' $
	, xtitle = 'Time (seconds)', ytitle = 'Defect Density' $
	, yran=[0., 0.25], /ynozero, ystyle=1
cgplots, x, disRatio1, color='red5', noclip=0
h1 = histogram(disRatio1,binsize=0.005,min=0,max=0.25)
h2 = histogram(disRatio2,binsize=0.005,min=0,max=0.25)
hx = findgen(0.25/0.005+1)*0.005+0
cgplot, hx, h1/total(h1), color='red5',psym=-14, ystyle=2 $
	, xtitle='Defect Density', ytitle='Frequency'
cgplots, hx, h2/total(h2), color='blu5',psym=-14

; plot of disclination boundness
cgplot, x, freeDis1, color='red5' $
	, xtitle = 'Time (seconds)', ytitle = 'Free Disclinations Ratio' $
	, yran = [0.,0.25], /ynozero, ystyle=1
cgplots, x, freeDis2 $
	, color='blu5', noclip=0
h1 = histogram(freeDis1,binsize=0.005,min=0,max=0.25)
h2 = histogram(freeDis2,binsize=0.005,min=0,max=0.25)
hx = findgen(0.25/0.005+1)*0.005+0
cgplot, hx, h2/total(h2), color='blu5',psym=-14, ystyle=2 $
	, xtitle='Free Disclination Ratio', ytitle='Frequency'
cgplots, hx, h1/total(h1), color='red5',psym=-14

; plot of free dislocation 
cgplot, x, freeDislo1, color='red5' $
	, xtitle = 'Time (seconds)', ytitle = 'Free Dislocations Density' $
	, yran = [0.,0.030], /ynozero, ystyle=1
cgplots, x, freeDislo2, color='blu5', noclip=0
h1 = histogram(freeDislo1,binsize=0.0005,min=0,max=0.03)
h2 = histogram(freeDislo2,binsize=0.0005,min=0,max=0.03)
hx = findgen(0.03/0.0005+1)*0.0005+0
cgplot, hx, h1/total(h1), color='red5', psym=-14, ystyle=2 $
	, xtitle='Free Disclocation Density', ytitle='Frequency'
cgplots, hx, h2/total(h2), color='blu5', psym=-14

device, /close
set_plot, 'x'
spawn, 'gv '+filename

end
