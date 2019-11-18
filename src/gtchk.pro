; +
; Name:		gtchk
; 
; Purpose:  show each track of colloids
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
; License: 	Sungcheol Kim, 2010/12/1
;-

pro gtchk, pt, tt, mstep=mstep

on_error,2

; check input varibles 
ptt = pt(5,*)
ptth = histogram(ptt)
maxframe = long(max(ptt))
if not keyword_set(mstep) then mstep = 25
maxx = max(pt(0,*),min=minx)
maxy = max(pt(1,*),min=miny)

; plot each frames
kbinput = ''
i = 0
mflag = 0

while ~strcmp(kbinput,'q') do begin

	pttx = pt(0,where(pt(5,*) eq i))
	ptty = pt(1,where(pt(5,*) eq i))

	plot,pttx,ptty,psym=3,xran=[minx,maxx],yran=[miny,maxy],$
		/isotropic,xstyle=1,ystyle=1,/nodata,color=fsc_color('wt8'), $
		title= 'Frame: '+strtrim(string(i),2)+' of '+strtrim(string(maxframe),2)

	oplot,pttx,ptty,psym=3,color=fsc_color('grn5')

	if not mflag then begin
		tttx = tt(0,where(tt(5,*) eq i))
		ttty = tt(1,where(tt(5,*) eq i))
		oplot,tttx,ttty,psym=5,color=fsc_color('blu4')

		miss = n_elements(pttx) - n_elements(tttx)
		statusline,strtrim(string(miss),2)+' (Q)uit, (N)ext, (P)revious, (M)ovie, (C)apture : '+strtrim(string(i),2),0, length=53
	endif

	;xyouts,500,15,'Frame: '+strtrim(string(i),2)+' of '+strtrim(string(maxframe),2),/data, color=fsc_color('tan5')

	if (~mflag) then kbinput = get_kbrd(1)

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
