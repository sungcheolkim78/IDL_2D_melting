;+
; Name: cumulant
; Purpose: calculate cumulant, susceptibility, phi function of one frame
; 		   by domain size L
; Inputs: pt, frame, m
;-

function cumulant, pt, frame, m, verbose=verbose
on_error, 2

	mupixel = 0.083
	ptc = pt(*, where(pt(5,*) eq frame))
	if n_elements(ptc(*,0)) eq 9 then phiarr = complex(ptc(7,*),ptc(8,*))
	if n_elements(ptc(*,0)) ne 9 then phiarr = phi6arr(ptc)

	xmin = min(ptc(0,*), max=xmax)
	ymin = min(ptc(1,*), max=ymax)
	bx = (xmax-xmin)/float(m+1.)
	by = (ymax-ymin)/float(m+1.)
	phi6b = fltarr(m,m)
	if keyword_set(verbose) then begin
		np = n_elements(ptc(0,*))
		area = (xmax-xmin)*(ymax-ymin)*mupixel*mupixel
		density = np/area
		print,'Density: '+string(density,format='(F5.3)')+' um^-2'
		print,'(bx, by): '+string(bx) + string(by)
		print,'(xmin, xmax, ymin, ymax) = '+$
			string(xmin)+string(xmax)+string(ymin)+ string(ymax)
	endif
	ec = 0

	for i = 0, m-1 do begin
		for j = 0, m-1 do begin
			w = where( ptc(0,*) ge xmin+bx*i $
				and ptc(0,*) lt xmin+bx*(i+1) $
				and ptc(1,*) ge ymin+by*j $
				and ptc(1,*) lt ymin+by*(j+1),wc)
			if wc gt 0 then begin
				phi6b(i,j) = abs(total(phiarr(w))/wc)
			endif else begin
				phi6b(i,j) = 1.
				ec++
			endelse
		endfor
	endfor

	if keyword_set(verbose) then begin
		sout = congrid(bytscl(phi6b), fix(xmax-xmin),fix(ymax-ymin),/center)
		tv, sout
;		plot_hist,phi6b
		print,'empty blocks: '+string(ec)
	endif

	if ec gt 0 then return, [0, 0, 0, 0]

	result = fltarr(4)
	m = fix(m)
	phi6b = reform(phi6b,1,m*m)
	phib4 = mean(phi6b^4)
	phib2 = mean(phi6b^2)

	result(0) = 1. - phib4/(3.*phib2^2)
	result(1) = bx*by*(phib2 - mean(phi6b)^2)*mupixel*mupixel
	result(2) = mean(phi6b)
	result(3) = 1./(sqrt(bx*by)*mupixel)

	if keyword_set(verbose) then print,result

	return, result
end
