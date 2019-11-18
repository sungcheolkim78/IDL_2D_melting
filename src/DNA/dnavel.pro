;+
; Name: dnavel
; Purpose: show velocity of dna from sav file
; Input: dnavel, filename
; History: created by sungcheol kim, 4/23/12
;-

pro dnavel, filename, theta=theta

a = read_gdf(filename)

if not keyword_set(theta) then theta=0.
ratio = !pi/180.

x = a(1,*)
y = a(2,*)
l = a(3,*)

n = n_elements(x)
xx = fltarr(n)
yy = fltarr(n)

print, n

for i=0,n-1 do begin
    xx(i) = cos(theta*ratio)*x(i)-sin(theta*ratio)*y(i)
    yy(i) = sin(theta*ratio)*x(i)+cos(theta*ratio)*y(i)
endfor

xx = xx - xx(0)
yy = yy - yy(0)

vx = xx(1:n-1)-xx(0:n-2)
vy = yy(1:n-1)-yy(0:n-2)

cgplot, xx, yy, charsize=1., /window, wmulti=[0,2,3]
cgplot, yy, charsize=1., /window, /addcmd

cgwindow, 'plot_hist', vx, /fit, /average, /center, charsize=1., /addcmd
cgwindow, 'plot_hist', vy, /fit, /average, /center, charsize=1., /addcmd
print, mean(vx), mean(vy)

cgplot, l, charsize=1., /window, /addcmd
cgwindow, 'plot_hist', l, /fit,/average, /center, charsize=1., /addcmd

end
