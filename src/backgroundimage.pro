;+
; Name: backgroundimage
; Purpose: average certain amount of images to get average
; Input: filename, start, stop
;-

pro backgroundimage,fname, startf, stopf
on_error, 2
	nf = stopf - startf + 1

	if nf lt 200 then begin
		a = readjpgstack(fname, start_frame=startf, stop_frame=stopf)
		b = total(a,3)/nf
		tv,bf
		write_gdf,b,'im.back_'+strtrim(string(nf),2)
		return
	endif

	ni = fix(nf/200)
	nir = nf mod 200
	b = bytarr(640,476,ni)

	for i = 0, ni-1 do begin
		a = readjpgstack(fname, start_frame = startf+i*200, stop_frame = startf+(i+1)*200)
		b(*,*,i) = total(a,3)/200
	endfor

	bf = total(b,3)/ni
	tv,bf
	write_gdf,bf,'im.back_'+strtrim(string(nf),2)
end
