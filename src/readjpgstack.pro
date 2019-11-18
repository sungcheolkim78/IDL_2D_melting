;+
; NAME:	readjpgstack.pro
;
; CREDIT: Sungcheol Kim, 2010/12/1
;         Lichao Yu, 2011/10/29  add option to avoid the case when img by read_jpeg has extra subscript.
;
; PURPOSE: a function to read in jpeg files into a single variable
;
; CATEGORY: Graphics
; 
; CALLING SEQUENCE: a = readjpgstack(filename,start_frame=1,stop_frame=100)
;
;-
;

function readjpgstack,imagefile,startf, stopf, $
	start_frame=start_frame,stop_frame=stop_frame, quiet=quiet, option=option

on_error, 2

; check function arguments
singlef = 0
if n_params() eq 1 then begin
	startf = 0 &  stopf= 0
	if (keyword_set(start_frame)) then startf= start_frame
	if (keyword_set(stop_frame)) then stopf= stop_frame
endif
if n_params() eq 2 then begin
	stopf = startf
endif
if startf eq stopf then singlef = 1

; find file names by index
filename = ffilename(imagefile,startf)
if (not singlef) and (not keyword_set(quiet)) then print,$
	filename +' to '+ffilename(imagefile,stopf)
ok = query_jpeg(filename, info)


imgarr=bytarr(info.dimensions[0],info.dimensions[1],stopf-startf+1)

if (ok) then begin
	for i=startf,stopf do begin
		filename = ffilename(imagefile,i)

		read_jpeg,filename,img

		if singlef then begin
			imgarr = img
			return, imgarr
		endif
    
    if keyword_set(option) then imgarr[*,*,i-startf] = img[0,*,*]	else imgarr[*,*,i-startf] = img
		

		percentage = fix((i-startf)*100./(stopf-startf))
		if not keyword_set(quiet) then statusline,'Process: '+$
			strtrim(percentage,2)+'%',0,length=15
	endfor
endif

if not keyword_set(quiet) then begin 
	statusline,/close
	print,''
endif

return, imgarr
end

