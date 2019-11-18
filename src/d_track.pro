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
	tti = tt(*,where(tt(6,*) eq i))

	if i eq minid then cgplot, tti(0,*), tti(1,*), color='grn6', xran=[0,640], charsize=1. $
		,yran=[0,480], xstyle=1, ystyle=1, position = [0.03,0.03,0.76,0.99]
	if i ne minid then cgplots, tti(0,*), tti(1,*), color='grn6'
;	cgplot, tti(0,*), color='grn5', charsize=1. $
;		,position = [0.8,0.8, 0.99, 0,01], /noerase
;	cgplot, tti(1,*), color='grn5', charsize=1. $
;		,position = [0.8,0.56, 0.99, 0,75],/noerase
;	cgplot, s_msd(tti(0,*)), color='red5', charsize=1. $
;		,position = [0.8,0.25, 0.99, 0.50],/noerase
;	cgplot, s_msd(tti(1,*)), color='red5', charsize=1. $
;		,position = [0.8,0.03, 0.99, 0,25],/noerase

	print, 'Key: Q, N, P	ID: '+strtrim(i,2)+' '+strtrim(n_elements(tti(0,*)),2)
	kbinput = get_kbrd(waittime)

	if strcmp(kbinput,'m') then waittime = ~waittime
	if strcmp(kbinput,'p') then if i gt 0 then i -= 2
	if strcmp(kbinput,'q') then return

endfor

end
