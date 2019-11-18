;+
; Name: get_domain
; Purpose: obtain contour information from velocity 
;
;-

function get_domain, tt, m, n, startf=startf, stopf=stopf
	; keyword setup
	if not keyword_set(starf) then startf=0
	if not keyword_set(stopf) then stopf=n_elements(tt(0,*))

	; parameter setup
	z = fltarr(m,n)

	tt = eclip(tt,[5,startf,stopf])  ; clip for wanted frames
	dx = getdx(tt,2,dim=2)
	w = where(dx(2,*) ge 0, c)
	dx = dx(*,w)
	tt = tt(*,w)

	maxx = max(tt(0,*), min=minx)
	maxy = max(tt(1,*), min=miny)

	dsizex = (maxx-minx)/m
	dsizey = (maxy-miny)/n

	; calculate velocity profile
	for i=0,m-1 do begin
		for j=0,n-1 do begin
			; find particles in window (m,n)
			w1 = where(tt(0,*) ge i*dsizex+minx and $
				tt(0,*) lt (i+1)*dsizex+minx, xcount)
			if xcount gt 0 then w2 = where(tt(1,w1) ge j*dsizey+miny $
				and tt(1,w1) lt (j+1)*dsizey+miny, ycount)
			if ycount gt 0 then z(i,j) = total(dx(2,w2)) else z(i,j) = 0
			statusline, strtrim(string(i),2)+' of '+strtrim(string(m),2),0,length=10
			;print, xcount, ycount
		endfor
	endfor
	statusline,/close & print,' '

	x = findgen(m)*dsizex+minx
	y = findgen(n)*dsizey+miny

	domain = {x:x, y:y, z:z}

	return, domain
end

