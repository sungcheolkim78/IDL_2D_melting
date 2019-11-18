;+
; Name: pointdensity
; Purpose: Calculate density for one particle
; Input: pointdensity(ith, pt, frame)
; Usage: when frame = -1, then use pt as one frame data
;-

function pointdensity,ith,pt,frame,con=con
	; check frame for quicker excution
	if frame eq -1 then ptc = pt else ptc = eclip(pt,[5,frame,frame])
	; check triangulate info
	if not keyword_set(con) then triangulate, ptc(0,*),ptc(1,*),conn=con

	nearp = con[con[ith]:con[ith+1]-1]
	nnearp = n_elements(nearp)

	if nearp[0] eq ith then return, 0. ; boundary

	rx = ptc(0,nearp) - ptc(0,ith)
	ry = ptc(1,nearp) - ptc(1,ith)
	area = 0.

	for i = 0, nnearp-1 do begin
		if i eq nnearp-1 then ii = 0 else ii = i+1
		area += abs(rx(i)*ry(ii)-rx(ii)*ry(i)) 
	endfor

	return, 0.5*nnearp/area/0.083/0.083*2.
end	
