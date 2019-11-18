;+
; Name: circleInRectangle
; Purpose: calculate the area overlapped by circle and rectangle
; Input: circleInRectange, x, y, dr, r, rect(minx, maxx, miny, maxy)
; Output: area
;-

function circleinrectangle, x, y, r, dr, rect, quiet=quiet
on_error, 2

; prepare visual presentation
t = findgen(101)*2.*!pi/100
cx = r*cos(t)+x 
cy = r*sin(t)+y
twopoints = fltarr(8,2)
c = 0
flag = 0

if not keyword_set(quiet) then plot, xran=[rect(0), rect(1)], yran=[rect(2),rect(3)], cx, cy, psym=-3

if x lt rect(0)+r and x gt rect(0)-r then begin
	y0 = y-sqrt(r^2-(rect(0)-x)^2)
	y1 = y+sqrt(r^2-(rect(0)-x)^2)
	if y0 gt rect(2) and y0 lt rect(3) then twopoints(c++,*) = [rect(0),y0]
	if y1 gt rect(2) and y1 lt rect(3) then twopoints(c++,*) = [rect(0),y1]
	flag = 1
endif

if x lt rect(1)+r and x gt rect(1)-r then begin
	y0 = y-sqrt(r^2-(rect(1)-x)^2)
	y1 = y+sqrt(r^2-(rect(1)-x)^2)
	if y0 gt rect(2) and y0 lt rect(3) then twopoints(c++,*) = [rect(1),y0]
	if y1 gt rect(2) and y1 lt rect(3) then twopoints(c++,*) = [rect(1),y1]
	flag = -1
endif

if y lt rect(2)+r and y gt rect(2)-r then begin
	x0 = x-sqrt(r^2-(rect(2)-y)^2)
	x1 = x+sqrt(r^2-(rect(2)-y)^2)
	if x0 gt rect(0) and x0 lt rect(1) then twopoints(c++,*) = [x0,rect(2)]
	if x1 gt rect(0) and x1 lt rect(1) then twopoints(c++,*) = [x1,rect(2)]
	if flag eq 1 then flag = 1 else flag = -1
endif

if y lt rect(3)+r and y gt rect(3)-r then begin
	x0 = x-sqrt(r^2-(rect(3)-y)^2)
	x1 = x+sqrt(r^2-(rect(3)-y)^2)
	if x0 gt rect(0) and x0 lt rect(1) then twopoints(c++,*) = [x0,rect(3)]
	if x1 gt rect(0) and x1 lt rect(1) then twopoints(c++,*) = [x1,rect(3)]
	if flag eq 1 then flag = 1 else flag = -1
endif

theta = fltarr(4)
theta = atan(twopoints(0:c-1,1)-y,twopoints(0:c-1,0)-x)
theta = theta(sort(theta))
thetal = 0
;print, theta*180./!pi

if c eq 2 and flag eq 1 then thetal = theta(1)-theta(0)
if c eq 2 and flag eq -1 then thetal = 2.*!pi-theta(1)+theta(0)
;print, flag

if c eq 4 and flag eq 1 then thetal=theta(1)-theta(0)+theta(3)-theta(2)
if c eq 4 and flag eq -1 then thetal=2.*!pi-theta(3)-theta(1)+theta(0)+theta(2)

if c gt 4 then return, 0

if flag eq 0 then thetal = 2.*!pi
;print, thetal*180./!pi

return, thetal*r*dr

end

