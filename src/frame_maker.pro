;+
; Name: frame_maker
; Purpose: save each frame from movie or stack of images
; Input: frame_maker, a, frames, field=field
; History: created by sungcheol kim, 4/10/12
;-

pro frame_maker, a, frames, field=field

s = size(a)
if not keyword_set(field) then field = [0,s(1)-1, 0,s(2)-1]

window, xsize=field[1]-field[0], ysize=field[3]-field[2]

for i=frames[0],frames[1] do begin
    tvscl, a(field[0]:field[1],field[2]:field[3],i)
    image = cgSnapShot(filename='movie/tt_'+strtrim(i,2),/png,/nodialog)
endfor

end
