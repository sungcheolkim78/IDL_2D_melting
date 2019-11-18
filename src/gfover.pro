;+
; Name: gfover
; Purpose: overlay point onto a 2d image
; Calling Sequence: newimage = gfover(image,points,options)
; Keywords:
;-

function gfover, image, f

	ccolor = 255b
	dcolor = 250b
	;loadct,40,/silent  ; Rainbow + black

	s = size(image)
	maxx = s[1] & maxy = s[2]
	output = image

	w = where(f(0,*) gt 5 and f(0,*) lt maxx-5)
	w1 = where(f(1,w) gt 5 and f(1,w) lt maxy-5)

	x = reform(f(0,w1))
	y = reform(f(1,w1))

	radius = 4
	circle = bytarr(9,9)
	circle = [[0, 0, 0, 0, 1, 0, 0, 0, 0], $
			  [0, 0, 1, 1, 1, 1, 1, 0, 0], $
			  [0, 1, 1, 0, 0, 0, 1, 1, 0], $
			  [0, 1, 0, 0, 0, 0, 0, 1, 0], $
			  [1, 1, 0, 0, 0, 0, 0, 1, 1], $
			  [0, 1, 0, 0, 0, 0, 0, 1, 0], $
			  [0, 1, 1, 0, 0, 0, 1, 1, 0], $
			  [0, 0, 1, 1, 1, 1, 1, 0, 0], $
			  [0, 0, 0, 0, 1, 0, 0, 0, 0]]
	circle = circle*ccolor

	for i=0L,n_elements(x)-1L do begin

		startx = x(i)-4 & endx = x(i)+4
		starty = y(i)-4 & endy = y(i)+4

		output(startx:endx,starty:endy) = output(startx:endx,starty:endy) > circle
		;output(x(i)-1:x(i)+1,y(i)) = dcolor
		;output(x(i),y(i)-1:y(i)+1) = dcolor

	endfor

	cgImage, output

	;loadct,0,/silent
	return, output
end

