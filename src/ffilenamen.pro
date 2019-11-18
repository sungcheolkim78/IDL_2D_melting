;+
; NAME: ffilenamen
; PURPORSE: find file name by index
;
; sungcheol kim - 11/29/10
;
;-

function ffilenamen,imagefile,index

if not keyword_set(index) then index=1

filename = imagefile+strtrim(string(index),2)+'.jpg'

return, filename
end

