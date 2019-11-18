;+
; plotpos.pro
;
; calculate image postion in plot array
; 
;-

function plotpos,m,n,mar=mar,wall=wall

	pos = fltarr(m*n,4)
	a = (1. - mar - m*wall)/float(m)
	b = (1. - mar - n*wall)/float(n)

	;print,a,b

	for i=0,m-1 do begin
		for j=0,n-1 do begin
			pos[i*n+j,*] = [mar+float(i)*a+float(i)*wall,$
				mar+float(j)*b+float(j)*wall,$
				mar+float(i)*a+float(i)*wall+a,$
				mar+j*b+j*wall+b]
			;print,pos[i*n+j,*]
		endfor
	endfor

	return, pos

end
