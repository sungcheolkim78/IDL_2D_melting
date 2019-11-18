;+
; Name: i_msd2d
; Purpose: calculate mean square displacement of 2d track
; Input: s_msd, ptd
; History:
;	created on 8/17/11 by SCK
;-

function i_msd2d, ptd, length=length, show=show
on_error, 2

if keyword_set(show) then begin
	!p.multi = [0,2,2]
	cgplot,ptd(2,*),ptd(0,*),charsize=1.0,/ynozero
	cgplot,ptd(2,*),ptd(1,*),charsize=1.0,/ynozero
endif

n = n_elements(ptd(2,*))
if not n_elements(length) then rn = fix(n/3) else rn = length

result = fltarr(rn,2)
for dt=1,rn-1 do begin
	k = n - dt - 1
	xdiff = ptd(0,0:k) - ptd(0,0+dt:k+dt)
	ydiff = ptd(1,0:k) - ptd(1,0+dt:k+dt)
    diff2 = xdiff*xdiff+ydiff*ydiff
	result(dt,0) = mean(diff2)
	result(dt,1) = stddev(diff2)/sqrt(n_elements(diff2))
endfor

if keyword_set(show) then begin
	cgplot, result(*,0), charsize=1.0
	cgplot, result(*,1), /overplot, color='blu3'
endif

result[0,1] = 0.00001
return, result

end
