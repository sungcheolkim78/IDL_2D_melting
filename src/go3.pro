;+
; Name: go3
; Purpose: change directory to data set 3
; Input: 
; History: 
;	06/09/11 created by sungcheol kim
;-

pro go3, index

on_error, 2

cd, '/home/sungcheolkim/Lab/2DCC/Alexsandros/010912'

if index eq 1 then cd, '55104-55204'
if index eq 2 then cd, '59950-60050'
if index eq 3 then cd, '60730-60830'

pwd

end
