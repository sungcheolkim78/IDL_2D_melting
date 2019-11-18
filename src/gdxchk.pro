; +
; Name:		gdxchk
; 
; Purpose:  show each trace and velocity of colloids
;
; Category:	plotting
; 
; Calling Sequence: gtchk, pt, tt
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
; License: 	Sungcheol Kim, 2010/12/3
;-

pro gdxchk, tt, mstep=mstep

on_error,2

; check input varibles 
maxframe = max(tt(5,*))
if not keyword_set(mstep) then mstep = 25

dx = getdx(tt,3,dim=2)

; plot each frames
kbinput = ''
i = 0
mflag = 0

while ~strcmp(kbinput,'q') do begin
	w = where(tt(5,*) eq i)
	plot,tt(0,w),tt(1,w),psym=3,xran=[0,650],yran=[0,490],/isotropic,color=fsc_color('gray')

	if not mflag then begin
		arrow,tt(0,w),tt(1,w),dx(0,w),dx(1,w),color=fsc_color('green')
	endif

	statusline,'(Q)uit, (N)ext, (P)revious, (M)ovie, (C)apture : '+strtrim(string(i),2),0, length=53
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
	;if strcmp(kbinput,'c') then begin
	;	filename = 'gvc_capture_'+strtrim(string(i),2)+'png'
	;	write_png,filename,fo
	;	spawn,'xv '+filename
	;endif

	if (i gt maxframe-2) then kbinput = 'q'
	i+= 1
endwhile

statusline,/close
print,' '

end
