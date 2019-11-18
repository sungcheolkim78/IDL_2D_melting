;+
; Name: t_phi6
; Purpose: calculate phi6 on the whole track of particle i
; Input: t_phi6, tt, id, /normal, /symmetry
;-

function t_phi6, tt2, id, option=option
on_error, 2

if not keyword_set(option) then begin
	ttt = eclip(tt2, [6, id, id])
plot, ttt(0,*), ttt(1,*),/ynozero
	return, complex(ttt(8,*),ttt(9,*))
endif

if keyword_set(option) then begin
	tlength = max(tt2(5,*))+1
	result = complex(fltarr(tlength),fltarr(tlength))
	for i=0, tlength-1 do begin
		result(i) = phi6(id, tt2, i, /normal, /id)
		print,result(i)
	endfor
	return, result
endif

end
