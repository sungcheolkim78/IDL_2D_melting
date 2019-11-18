;+
; Name: plot_ps
; Purpose: plot wrapper for multiple ps print
;
;-

pro histplot_ps, data, psinfo=psinfo, index=index, xstyle=xs, ystyle=ys,  _extra=_extra

	if not keyword_set(index) then index = 0
	if index gt n_elements(psinfo.pos(*,0))-1 then begin
		print, 'Out of index: '+strtrim(string(index),2)+' of '+strtrim(string(n_elements(psinfo.pos(*,0))-1),2)
	endif
	if not keyword_set(xstyle) then xs = 2
	if not keyword_set(ystyle) then ys = 2

	plot_hist, data, position=psinfo.pos(index,*), $
		charsize=0.4, xticklen=psinfo.xticklen, $
		yticklen=psinfo.yticklen, xminor=1, yminor=1, $
		xstyle=xs, ystyle=ys, xtickv=xtickvalues, $
		ytickv=ytickvalues, xticks=nxticks, $
		yticks=nyticks, _extra=_extra

end
