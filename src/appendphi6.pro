;+
; Name: appendphi6
; Purpose: read tt information and append phi6 data and save
; Input: appendphi, ttname, suffix = suffix
; Output: tt - (x, y, b, r, e, t, n, phir, phii)
;
;-

pro appendphi6, ttname, suffix = suffix, verbose=verbose
	on_error, 2
	fn = file_search(ttname,count=fc)

	for j=0, fc-1 do begin
		print, 'File: '+fn
		outfname = str_replace(fn[j], 'tt', 'tt2')
		tt = read_gdf(fn[j])

		startf = min(tt(5,*),max=endf)
		noe = n_elements(tt(0,*))
		tt2 = fltarr(3,noe)
		fpos = 0

		; check for each frames
		for i = startf, endf do begin
			ttc = tt(*,where(tt(5,*) eq i))
			nff = n_elements(ttc(0,*))
			triangulate, ttc(0,*), ttc(1,*), conn=con

			for j=0, nff-1 do begin
				cphi6 = phi6(ttc(6,j),ttc,-1,con=con,/normal,/id)
				tt2(1,fpos+j) = real_part(cphi6)
				tt2(2,fpos+j) = imaginary(cphi6)
				tt2(0,fpos+j) = n_elements(con[con[j]:con[j+1]-1])
			endfor

			if keyword_set(verbose) then begin
				fphi = complex(tt2(1,indgen(nff)+fpos),tt2(2,indgen(nff)+fpos))
				statusline,'<|phi6|> = '+string(mean(abs(fphi)),format='(F6.3)'),0
			endif
			fpos += nff
			if (i mod 25) eq 0 then print, string(i)+' of '+string(endf)+' are processed.'
		endfor

		result = [tt,tt2]
		write_gdf, result, outfname
	endfor
end
