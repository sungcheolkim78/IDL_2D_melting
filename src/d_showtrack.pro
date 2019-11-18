;+
; Name: d_track
; Purpose: show trace of each track sequencely
; Input: d_track, tt
; History:
; 	created on 5/30/11 by sungcheol kim
;-

pro d_track, tt

on_error, 2

minid = min(tt(6,*), max=maxid)
waittime = 1

for i=minid, maxid do begin
	tti = tt(*,where(tt(6,*) eq i)

	cgplot, tti(0,*), tti(1,*), color='grn6', xran=[0,640] $
		yran=[0,480], xstyle=1, ystyle=1, position = [0,0,0.8,1.]

	print, 'Key: Q, N, P	ID: '+strtrim(i,2)
	kbinput = get_kbrd(waittime)

	if strcmp(kbinput,'m') then waittime = ~waittime
	if strcmp(kbinput,'p') then if i gt 0 then i -= 2

endfor

end
