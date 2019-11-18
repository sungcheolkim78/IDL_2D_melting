;+
; Name: i_nearest
; Purpose: calculate nearest distance between two groups of points
; Input: i_nearest,x1,y1,x2,y2
;-

function i_nearest, x1, y1, x2, y2
on_error, 2

if n_params() eq 2 then begin
	n = n_elements(x1)
	near = 1
	x2 = x1
	y2 = y1
	m = n
endif
if n_params() eq 4 then begin
	n = n_elements(x1)
	m = n_elements(x2)
	near = 0
endif

dn = fltarr(n,/nozero)

d = (rebin(transpose(x1),n,m,/sample)-rebin(x2,n,m,/sample))^2 + $
	(rebin(transpose(y1),n,m,/sample)-rebin(y2,n,m,/sample))^2

for i=0,n-1 do dn[i] = sqrt(d[i,(sort(d[i,*]))[near]])

return, dn

end
