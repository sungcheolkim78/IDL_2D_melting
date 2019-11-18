;+
; Name: contour_ps
; Purpose: contour wrapper for multiple ps print
;
;-

pro contour_ps, z, x, y, psinfo=psinfo, index=index, xstyle=xs, ystyle=ys,  _extra=_extra

	if not keyword_set(index) then index = 0
	if not keyword_set(psinfo) then begin
		print,'Excute psinfo=start_ps(1,1), first'
		return
	endif
	if index gt n_elements(psinfo.pos(*,0))-1 then begin
		print, 'Out of index: '+strtrim(string(index),2)+' of '+strtrim(string(n_elements(psinfo.pos(*,0))-1),2)
	endif
	if not keyword_set(xstyle) then xs = 1
	if not keyword_set(ystyle) then ys = 1

	case n_params() of
		1: begin
			contour, z, position=psinfo.pos(index,*), $
				charsize=0.4, xticklen=psinfo.xticklen, $
				yticklen=psinfo.yticklen, xminor=1, yminor=1, $
				xstyle=xs, ystyle=ys, xtickv=xtickvalues, $
				ytickv=ytickvalues, xticks=nxticks, $
				yticks=nyticks,c_charsize=0.4, _extra=_extra
			endcase
		3: begin
			contour, z, x, y, position=psinfo.pos(index,*), $
				charsize=0.4, xticklen=psinfo.xticklen, $
				yticklen=psinfo.yticklen, xminor=1, yminor=1, $
				xstyle=xs, ystyle=ys, xtickv=xtickvalues, $
				ytickv=ytickvalues, xticks=nxticks, $
				yticks=nyticks,c_charsize=0.4, _extra=_extra
			endcase
	endcase


end
