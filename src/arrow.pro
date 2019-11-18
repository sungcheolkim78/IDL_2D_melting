;+
; Name: arrow
;
;-

pro arrow, x0, y0, dx, dy, color=color

	totaln = min([n_elements(x0),n_elements(dx),n_elements(y0),n_elements(dy)])
	if not keyword_set(color) then color = fsc_color('green')

	for i=0, totaln-1 do begin

		plots, [x0(i),x0(i)+dx(i)], [y0(i),y0(i)+dx(i)], color=color
		statusline,'Processing '+strtrim(string(i),2)+ ' of '+strtrim(string(totaln),2),0,length=30

	endfor

	print,' '
	statusline,/close
end
