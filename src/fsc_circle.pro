;+
; Name: fsc_Circle
; Purpose: make locations of circle trace
;
;-

function fsc_circle, xcenter, ycenter, radius
	points = (2 * !pi / 99.0) * findgen(100)
	x = xcenter + radius * cos(points)
	y = ycenter + radius * sin(points)
	return, transpose([[x],[y]])
end
