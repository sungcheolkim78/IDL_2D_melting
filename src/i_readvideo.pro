;+
; Name: i_readvideo
; Purpose: read avi files and save frames in jpg format
; Input: i_readvideo, filename
; Hitory: created by sungcheol kim, 11/10/26
;-

function i_readvideo, filename,maxf=maxf,view=view

if not keyword_set(maxf) then maxf=7200

s = open_videofile(filename)

a = read_videoframe(s)   ; don't use grayscale option
i = 0
str_status = filename+':'

sz = size(a)
temp = intarr(sz[2],sz[3],maxf)
temp(*,*,0) = a(0,*,*)

while available_videoframe(s) do begin
    a = read_videoframe(s)
    i += 1
    temp(*,*,i) = a(0,*,*)
    if (i mod 50) eq 0 then begin
        statusline, str_status
        str_status = str_status+'#'
    endif
    if keyword_set(view) then tvscl,temp(*,*,i)
endwhile

statusline, /clear
print, filename + ' - Total '+strtrim(i+1,2)+' frames'
close_video, s

return, temp(*,*,0:i)

end

