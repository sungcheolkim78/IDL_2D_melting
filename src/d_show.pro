;+
; Name: d_show
; Purpose: show defects with dislocation center
; Input: d_show, ptdef, ptdis
; History: 
; 	created on 5/30/11 by sungcheol kim
;-

pro d_show, ptdef, ptdis
on_error, 2

minf = min(ptdef(5,*), max=maxf)
waittime=1
overflag=0

for i=minf, maxf do begin
	ptc = ptdef(*,where(ptdef(5,*) eq i))
	ptc2 = ptdis(*,where(ptdis(5,*) eq i))

	if overflag eq 0 then begin
		cgplot, ptc(0,*), ptc(1,*), psym=16, color='red5', charsize=1., xstyle=1 $
			, ystyle=1, xran=[0,640], yran=[0,480]
	endif else begin
		cgplots, ptc(0,*), ptc(1,*), psym=16, color='red5'
	endelse
	cgplots, ptc2(0,*), ptc2(1,*), psym=16, color='blk5'

	print, 'Key: q, n, p, m, t 	Frame: '+strtrim(i,2)
	kbinput=get_kbrd(waittime)


	if strcmp(kbinput,'m') then waittime = ~waittime
	if strcmp(kbinput,'q') then return
	if strcmp(kbinput,'o') then overflag = ~overflag
	if strcmp(kbinput,'p') then begin
		if i gt 0 then i -= 2
	endif
	if strcmp(kbinput,'t') then begin
		cgplots, ptdef(0,*), ptdef(1,*), psym=3, color='grn3'
		p = get_kbrd(1)
	endif

endfor

end
