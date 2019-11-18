; +
; Name:		gvchk
; 
; Purpose:  show each frames of image and featues
;
; Category:	plotting
; 
; Calling Sequence: gvchk, image, pt, startf, stopf
;
; Inputs:	image 	(x,y,i) can be showed by tv
;			pt		(x,y,b,r,e,i, [id]) from spretrack or track
;
; Output:	none	show images by each frame
;
; License: 	Sungcheol Kim, 2010/12/1
;-

pro gvchk, image, pt, startf, stopf

on_error,2

maxf = max(pt(5,*))    ; find max frame
s = size(image)
if maxf gt s[3] then maxf = s[3]

if n_params() eq 2 then begin
	startf = 0
	stopf = maxf-1
endif
if n_params() eq 4 then begin
	if startf ge stopf then return
	if stopf gt maxf-1 then stopf = maxf-1
endif
waittime = 1

; plot each frames
for i = startf, stopf do begin

	ptt = pt(*, where(pt(5,*) eq i))
	at = image(*,*,i)
	fo = gfover(at, ptt)
	;fsc_plot,ptt(0,*),ptt(1,*),psym=9,/overplot

	print,'Key:Q,N,P,M,C Frame: '+strtrim(string(i),2)
	kbinput = get_kbrd(waittime)

	if strcmp(kbinput,'m') then waittime = ~waittime
	if strcmp(kbinput,'q') then return
	if strcmp(kbinput,'p') then begin
		if i gt 0 then i = i-2
	endif

	; capture
	if strcmp(kbinput,'c') then begin
		filename = 'gvc_capture_'+strtrim(string(i),2)+'png'
		write_png,filename,fo
		spawn,'xv '+filename
	endif

endfor

end
