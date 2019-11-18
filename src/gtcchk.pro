; +
; Name:		gtchk
; 
; Purpose:  show each track of colloids
;
; Category:	plotting
; 
; Calling Sequence: gtchk, tt
;
; Inputs:	tt		(x,y,b,r,e,i, id) from track
;
; Output:	none	show track by each frame
;
; Side Effects:
; 
; Restrictions:
;
; Procedure:
; 
; Example:
;
; Modification History:
;
; License: 	Sungcheol Kim, 2010/12/1
;-

pro gtchk, tt, mstep=mstep

on_error,2

; check input varibles 
maxparticle = max(tt(6,*))
if not keyword_set(mstep) then mstep = 20

; plot each frames
kbinput = ''
i = 0
mflag = 0
jstep = 255
device,decomposed=0
loadct,30
erase

while ~strcmp(kbinput,'q') do begin
	ptt = eclip(tt,[6,i,i+jstep])
	plot,ptt(0,*),ptt(1,*),psym=3,xran=[0,640],yran=[0,480],/nodata,/isotropic

	for j=i,i+jstep do begin
		index = where(ptt[6,*] eq j)
		oplot,ptt(0,index),ptt(1,index),psym=3,line=1,color=j-i
	endfor

	print,'(Q)uit, (N)ext, (P)revious, (M)ovie, (C)apture : '+strtrim(string(i),2)
	if (~mflag) then kbinput = get_kbrd(0)

	; movie 
	if strcmp(kbinput,'m') then begin
		mflag = 1
		ms = mstep
		kbinput = ' '
	endif
	if mflag then begin
		ms = ms-1
		if (ms lt 1) then mflag = 0
	;	print,mflag,ms,i,maxframe
	endif

	; previous
	if strcmp(kbinput,'p') then begin
		if (i lt 1) then i = 0 else i-=2
	endif

	; capture
	if strcmp(kbinput,'c') then begin
		filename = 'gvc_capture_'+strtrim(string(i),2)+'png'
		write_png,filename,fo
		spawn,'xv '+filename
	endif

	if (i gt maxparticle-2-jstep) then kbinput = 'q'
	i+= jstep
endwhile

end
