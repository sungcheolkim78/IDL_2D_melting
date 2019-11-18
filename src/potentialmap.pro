;+
; Name: PotentialMap
; Purpose: calculate the 2D histogram of position of points
; Input: potenitalmap, pt
;-

pro potentialmap, pt, prefix=prefix
on_error, 2

if not keyword_set(prefix) then prefix = ''

; size of image - 640x476
result = hist_2d(pt(0,*),pt(1,*),min1=0,max1=639,min2=0,max2=475,bin1=1,bin2=1)
nff = max(pt(5,*))-min(pt(5,*))+1
potential = -alog(result/nff)
as = size(result)
mx = as[1]/2
my = as[2]/2

set_plot, 'ps'
!p.font = 0
!p.charsize = 0.8
device, /color, /encapsul, /helvetica, bits=8
filename = 'pm_g'+prefix+'.eps'
device, xsize=16, ysize=12, file=filename
!p.multi=[0,2,2]

fsc_contour, potential,nlevels=5
fsc_plots,[0,as[1]],[my,my],color='blu3'
fsc_plots,[mx,mx],[0,as[2]],color='blu3'

tvimage, -alog(result), /white, multimargin=[2,3,1,1],$
	/keep_aspect_ratio, /axes

fsc_plot, result(mx-1,*)/nff,xstyle=1,ystyle=2,$
	xtitle='y at '+strtrim(my,2),color='grn6',ytitle='P(r)'
fsc_plot, result(*,my)/nff,xstyle=1,ystyle=2,$
	xtitle='x at '+strtrim(mx,2),color='grn6',ytitle='P(r)'

device, /close
set_plot, 'x'
spawn, 'gv '+filename

end
