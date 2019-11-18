;+
; Name: plot_ps
; Purpose: plot wrapper for multiple ps print
;
;-

pro plot_ps, x, y, xstyle=xs, ystyle=ys, axcolor=axcolor, color=color, $
	_extra=_extra

	if not keyword_set(xstyle) then xs = 10
	if not keyword_set(ystyle) then ys = 10

	case n_params() of
		1: begin
			dep = x
			indep = findgen(n_elements(dep))
			endcase
		2: begin
			dep = y
			indep = x
			endcase
	endcase

	if keyword_set(axcolor) then begin
		plot, indep, dep,  $
			xticklen=0.01, $
			yticklen=0.01, xminor=1, yminor=1, $
			xstyle=xs, ystyle=ys, xtickv=xtickvalues, $
			ytickv=ytickvalues, xticks=nxticks, $
			yticks=nyticks,color=axcolor,/nodata, _extra=_extra
		oplot, indep, dep,color=color, _extra=_extra
	endif else begin
		plot, indep, dep, $
			xticklen=0.01, $
			yticklen=0.01, xminor=1, yminor=1, $
			xstyle=xs, ystyle=ys, xtickv=xtickvalues, $
			ytickv=ytickvalues, xticks=nxticks, $
			yticks=nyticks,color=color, _extra=_extra
	endelse

end
