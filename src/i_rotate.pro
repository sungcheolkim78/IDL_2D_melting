;+
; Name: i_rotate
; Purpose: rotate all coordinates by theta
; Input: i_rotate, pt, radian, degree
; History: created by sungcheol kim, 11/15/11
;-

function i_rotate,pt,theta,radian=radian, degree=degree

ratio = !pi/180.     ; default is degree
if keyword_set(degree) then ratio = !pi/180.
if keyword_set(radian) then ratio = 1

temp = pt
x = temp(0,*)
y = temp(1,*)
n = n_elements(x)
xx = fltarr(n)
yy = fltarr(n)

for i=0,n-1 do begin
    xx(i) = cos(theta*ratio)*x(i)-sin(theta*ratio)*y(i)
    yy(i) = sin(theta*ratio)*x(i)+cos(theta*ratio)*y(i)
endfor

temp(0,*) = xx
temp(1,*) = yy

return, temp

end
