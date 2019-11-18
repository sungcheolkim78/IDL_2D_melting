;+
; Name: phi6
; Purpose: Calculate phi6 for one particle
; Input: phi6(ith, pt, frame)
; Usage: when frame = -1, then use pt as one frame data
;-

function phi6,ith,pt,frame,symmetry=symmetry,con=con,normal=normal,angle=angle,id=id,orient=orient
on_error,2

	; check frame for quicker excution
	if frame eq -1 then ptc = pt else ptc = eclip(pt,[5,frame,frame])
	; default is 6-fold symmetry
	if not keyword_set(symmetry) then symmetry = 6
	; check triangulate info
	if not keyword_set(con) then triangulate, ptc(0,*),ptc(1,*),conn=con
	; check track data
	if (n_elements(ptc(*,0)) ge 7) and keyword_set(id) then $
		iith = where(ptc(6,*) eq ith) else iith = ith

	nearp = con[con[iith]:con[iith+1]-1]
	nnearp = n_elements(nearp)

	if not keyword_set(angle) and nearp[0] eq ith then return, complex(0,0) ; boundary
	if keyword_set(angle) and nearp[0] eq ith then return, 0

	rx = fltarr(nnearp)
	ry = fltarr(nnearp)
	for i=0,nnearp-1 do begin
		rx(i) = ptc(0,nearp[i]) - ptc(0,iith)
		ry(i) = ptc(1,nearp[i]) - ptc(1,iith)
	endfor
	rr = sqrt(rx^2 + ry^2)

	c = complex(rx/rr,ry/rr)
	c6 = c^symmetry

	if keyword_set(angle) then begin
		ca = atan(c,/phase)*180./!pi
		return, ca
	endif
	if keyword_set(orient) and nnearp ne 6 then return, 0
	if keyword_set(orient) then begin
		ca = atan(c,/phase)*180./!pi mod 30.
		down = where(ca lt -15.0,downc)
		if downc gt 0 then ca(down) = 30. + ca(down)
		up = where(ca gt 15.0,upc)
		if upc gt 0 then ca(up) = ca(up) - 30.
;		print, atan(c,/phase)*180./!pi
;		print, ca
		return, total(ca)/6
	endif
	
	; normalized version
	if not keyword_set(normal) then return, total(c6)
	if keyword_set(normal) then return, total(c6)/nnearp
end	
