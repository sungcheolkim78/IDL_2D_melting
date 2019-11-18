;
; Name: gmovie
; Purpose: quick look data movie
;
;-

pro gmovie, fname, startf, stopf, verbose=verbose, normal=normal, back = back
on_error,2

	max = long(stopf-startf+1)
	for i=0,max-4 do begin
		if keyword_set(normal) then begin
			a = readjpgstack(fname,start_frame=i+startf,stop_frame=i+startf+2,/quiet)
			an = normalimage(a,1)
		endif else begin
			filename = ffilename(fname,i+startf)
			read_jpeg,filename,an
		endelse

		if keyword_set(back) then begin
			tv,bytscl(an-back)
		endif else begin
			tv,an
		endelse

		wait,0.01
		if strcmp(get_kbrd(0),'q') then begin
			print,'Frame: '+strtrim(i,2)
			return
		endif

		if keyword_set(verbose) then $
			xyouts,0.1,0.15,strtrim(i,2)+' of '+strtrim(max,2),/normal
	endfor

end
