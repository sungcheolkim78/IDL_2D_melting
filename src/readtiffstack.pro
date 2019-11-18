;readtiffstack.pro
;Eric Corwin
;Monday, November 20
;a function to read in a tiff stack into a single variable
;
; Modified by Sungcheol Kim, 2010/11/27
; 1) do not use query_tiff
; 2) tiff - 100 stacks, 512,512 size

;imagefile is the file to be read
;rect is the rectangular region of the image to be read. It has the form
;[x,y,width,height] measured in pixels from lower left corner (rh coord sys)

function readtiffstack,imagefile,rect=rect,start_frame=start_frame, $
   stop_frame=stop_frame


ok = query_tiff(imagefile, info)
;info = {num_frames:100, dimensions:[512,512]}

start = 0
stop = info.num_images-1
if (keyword_set(start_frame)) then start = start_frame
if (keyword_set(stop_frame)) then stop = stop_frame


if (keyword_set(rect)) then $
imgarr = bytarr(rect[2]-rect[0],rect[3]-rect[1],stop-start+1) $
else imgarr=bytarr(info.dimensions[0],info.dimensions[1],stop-start+1)

if (1) then begin
	for i=start,stop do begin
		if (keyword_set(rect)) then $
			img=read_tiff(imagefile,image_index=i,sub_rect=rect) $
		else img=read_tiff(imagefile,image_index=i)
		s=size(a)
		if (s[0] eq 3) then begin
			imgarr = img(0,*,*)
			i = stop
		endif else begin
			imgarr[*,*,i-start] = img(0,*,*)
		endelse
	endfor
endif

return, imgarr
end
