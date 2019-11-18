;+
; NAME:
;		gtinfo
; PURPOSE:
;		Read track file and show basic information about tracks
; CATEGORY:
;		Data Analysis
; CALLING SEQUENCE:
;		gtinfo,file
; INPUTS:
;		file:	track file with (x,y,b,r,e,t,i)
; OUTPUTS:
; RESTRICTIONS:
; PROCEDURE:
; MODIFICATION HISTORY:
; 		Written by Sungcheol Kim, Brown University, 12/1/10
; 		Copyright (c) 2010 Sungcheol Kim
; UPDATES:
; LICENSE:
;-

pro gtinfo, pt, tt
on_error,2			; return to caller on error

; How many tracks
trackNumber = long(max(tt(6,*))+1)
; How long for each tracks
tti = tt(6,*)
; How many frames
frameNumber = uint(max(tt(5,*))+1)
; Track Numbers per each frames

ttf = tt(5,*)
ptf = pt(5,*)

filename = 'trackinfo.eps'
set_plot,'ps'
device,file=filename,/encapsul,/color,bits_per_pixel=8
!p.multi=[0,1,2]

plot, histogram(tti), xtitle='track id', ytitle='length', xstyle=1, ystyle=2, xran=[0,trackNumber], psym=-3, color=fsc_color('blu6') 

plot, histogram(ttf), xtitle='frames', ytitle='tracks',xstyle=1,ystyle=2, color=fsc_color('blu6')
oplot,histogram(ptf), color=fsc_color('grn5')
xyouts, 0.8, 0.2, 'Green : # of pt', color=fsc_color('grn5'),/normal,charsize=0.6
xyouts, 0.8, 0.18, 'Blue : # of tr', color=fsc_color('blu6'),/normal,charsize=0.6

print,'Total Track Number '+string(trackNumber)
print,'Total Frame Number '+string(frameNumber)

device,/close
set_plot,'x'
!p.multi=[0,1,1]
spawn,'gv '+filename

end
