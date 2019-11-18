;+
; Name: gvelview
; Purpose: show the velocity as a map
; Input: tt
; History:
; 	created on 4/20/11 by sungcheol kim
;-

pro gvelview, tt, tr=tr, histo=histo
on_error,2

if n_elements(tr) eq 0 then tr=2
if n_elements(histo) eq 0 then histo=0 else histo=1

dx = getdx(tt,tr,dim=2)
dx(0,*) = dx(0,*)/tr
dx(1,*) = dx(1,*)/tr
dx(2,*) = dx(2,*)/(tr*tr)

startf = min(tt(5,*), max=stopf)
waittime = 1

for i=startf,stopf do begin
	wf = where(tt(5,*) eq i)
	ttc = tt(*,wf)
	triangulate, ttc(0,*), ttc(1,*), tr, conn=con

	wf2 = where(dx(2,wf) gt 0)
	alevels = [0., 0.1, 0.2, 0.3, 0.4, 0.6, 0.8, 1.0]
	ccolors = ['red8', 'red7', 'red6', 'red5', 'red4', 'red3', 'red2', 'red1']
	if ~histo then begin
		cgcontour, dx(2,wf(wf2)), ttc(0,wf2), ttc(1,wf2), /irregular, /fill $
			, levels=alevels, c_colors=ccolors, xran=[0,640] $
			, yran=[0,480], xstyle=1, ystyle=1, charsize=0.5
	endif else begin
		cghistoplot, dx(2,wf(wf2))
	endelse

	print, max(dx(2,wf(wf2))), min(dx(2,wf(wf2)))

	print, 'Key: Q, N, P, M		Frame: '+strtrim(i,2)
	kbinput = get_kbrd(waittime)

	if strcmp(kbinput, 'm') then waittime = ~waittime
	if strcmp(kbinput, 'q') then return
	if strcmp(kbinput, 'p') then begin
		i = i-2
		if i lt 0 then i=-1
	endif

endfor

end
