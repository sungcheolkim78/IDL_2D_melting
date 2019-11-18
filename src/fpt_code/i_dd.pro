;+
; Name: i_dd
; Purpose: frome one vector, calculate discrete differential values with error, using forward finite difference method
; Input: i_dd, x
; History: created by sungcheol kim, 1/27/12
;-

function i_dd, x, h=h

length = n_elements(x)
if not keyword_set(h) then h = 1.0
dx = fltarr(2,length-3)

for i=0,length-4 do begin
    dx(0,i) = (-3.*x(i)+4.*x(i+1)-x(i+2))/(2.*h)
    dx(1,i) = (-x(i)+3.*x(i+1)-3.*x(i+2)+x(i+3))/(3.*h)
endfor

;print, dx
return, dx

end
