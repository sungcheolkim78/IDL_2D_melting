;+
; Name: s_msd
; Purpose: calculate mean square displacement of track
; Input: s_msd, x
; History:
;	created by sungcheol kim
;	modified by sungcheol kim on 8/1/11 - add length argument
;   updated by sungcheol kim on 11/23/11 - change all graphics to cgwindow
;-

function s_msd, data, length=length, quiet=quiet
on_error, 2

; check data file has tpt format
s = size(data)
if s[0] eq 2 then begin
    n = data(1,0)
    x = data(1,1:*)
endif else begin
    n = n_elements(data)
    x = data
endelse

if mean(x) lt 0 then x = -x
if not n_elements(length) then rn = fix(n/4) else rn = length

result = fltarr(rn,4)
for dt=1,rn-1 do begin
	k = n - dt - 1
	diff = x(0:k) - x(0+dt:k+dt)
	diff2 = diff*diff
	result(dt,0) = mean(diff2)
	result(dt,1) = stddev(diff2)/sqrt(n_elements(diff2))
endfor
result[0,1] = 0.00001

fit = mpfitexpr('2.*P[0]*X+P[1]*X*X',indgen(rn), result(*,0), result(*,1),[1.,1.])

dx = x(1:n-1)-x(0:n-2)
dxx = dx
lag = indgen(20)
ac = a_correlate(dx,lag)

if not keyword_set(quiet) then begin
	cgWindow,'cgplot', indgen(n),x,xstyle=1, charsize=1.0,wmulti=[0,2,2], xtitle='Time (frame)', ytitle='y (pixel)', /ynozero
	cgWindow,'ploterror', result(*,0), result(*,1), /addcmd, charsize=1.0, xstyle=1,nskip=5 , psym=3, xtitle='Time (frame)', ytitle='MSD (pixel^2)'
    cgWindow,'cgplot',indgen(n), 2*fit[0]*indgen(n)+fit[1]*indgen(n)*indgen(n), /overplot, /addcmd, linestyle=3

    dy = !y.crange(1)-!y.crange(0)
    dx = !x.crange(1)-!x.crange(0)
    yy = !y.crange(0)
    xx = !x.crange(0)

    cgWindow,'cgtext',xx+dx*0.15,yy+dy*0.9, 'D = '+strtrim(fit[0],2), alignment=0.0,/addcmd,charsize=1.
    cgWindow,'cgtext',xx+dx*0.15,yy+dy*0.85, 'v = '+strtrim(sqrt(fit[1]),2), alignment=0.0,/addcmd,charsize=1.

	cgWindow,'plot_hist', dxx, charsize=1.0,/addcmd,/fit,/center,/average,xtitle='Velocity (pixel/frame)'
    cgWindow,'cgplot', lag, ac, xstyle=1, charsize=1.0,/addcmd, xtitle='Time (frame)', ytitle='Autocorrelation of velocity'
endif

return, result

end
