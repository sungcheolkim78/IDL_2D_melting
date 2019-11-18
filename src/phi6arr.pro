;+
; Name: phi6arr
; Purpose: calculate phi6 value for one frame
; Input: phi6arr, ptc
;-

function phi6arr, ptc
on_error,2

triangulate, ptc(0,*), ptc(1,*), conn=con
nff = n_elements(ptc(0,*))
cphi6 = complex(fltarr(nff))

for j = 0, nff-1 do cphi6[j] = phi6(j, ptc, -1, con=con, /normal)

return, cphi6

end
