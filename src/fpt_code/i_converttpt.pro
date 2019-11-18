;+
; Name: i_converttpt
; Purpose: convert tpt file to pt file
; Input: i_converttpt, tpt
; History: created by sungcheol kim, 2/17/12
;-

function i_converttpt, tpt

totalsize = total(tpt(0,0,*))
pt = fltarr(7,totalsize)

ntracks = n_elements(tpt(0,0,*))

for i=0,ntracks-1 do begin
    pt(6,
