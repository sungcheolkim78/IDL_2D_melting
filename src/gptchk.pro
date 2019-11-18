;+
; Name: gptchk
; Purpose: check each frame for correct detection
; Input: gptchk, pt, startf, stopf
; History: created by sungcheol kim on 4/21/11
;-

pro gptchk, pt, startf, stopf
on_error, 2

if n_params() eq 2 then begin
	maxf = max(pt(5,*), min=minf)
	stopf = maxf
endif
if n_params() eq 3 then begin
	maxf = max(pt(5,*), min=minf)
	if startf lt minf then startf = minf
	if stopf gt maxf then stopf = maxf
endif

window, 0, xsize=640, ysize=480
waittime = 1
tf = 1

for i=startf, stopf do begin
	a = readjpgstack('fg',i)
	plotimage, a, /preserve_aspect
	ptc = pt(*,where(pt(5,*) eq i-startf))
	if tf then cgplot, ptc(0,*), ptc(1,*), psym=9, color='grn4', /overplot, symsize=1.0

	print, 'Key: Q, N, T, P, M		Frame: '+strtrim(i,2)
	kbinput = get_kbrd(waittime)

	if strcmp(kbinput,'m') then waittime = ~waittime
	if strcmp(kbinput,'q') then return
	if strcmp(kbinput,'t') then begin
		i--
		tf = ~tf
	endif
	if strcmp(kbinput,'p') then if i gt startf then i=i-2
	
endfor

end


