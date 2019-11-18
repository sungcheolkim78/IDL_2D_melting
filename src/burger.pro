;+
; Name: burger
; Purpose: Calculate burger vector for one particle
; Input: burger(ith, pt, frame)
; Usage: when frame = -1, then use pt as one frame data
;-

function burger,ith,pt,frame,con=con
	; check frame for quicker excution
	if frame eq -1 then ptc = pt else ptc = eclip(pt,[5,frame,frame])
	; check triangulate info
	if not keyword_set(con) then triangulate, ptc(0,*),ptc(1,*),conn=con

	nearp = con[con[ith]:con[ith+1]-1]
	nnearp = n_elements(nearp)

	if nearp[0] eq ith then return, [0,0] ; boundary

	rx = ptc(0,nearp) - ptc(0,ith)
	ry = ptc(1,nearp) - ptc(1,ith)

	return, [total(rx),total(ry)]
end	
