;+
; Name: tiltedangle
; Purpose: find best angle to minimize x deviation
; Input: tiltedangle, pt
; History: created by sungcheol kim, 11/11/11
;-

pro tiltedangle, pt, range, ywin=ywin

if not keyword_set(ywin) then ywin=[0,512]

temp = eclip(pt,[1,ywin[0],ywin[1]])
nn = range[1]-range[0]
theta = (findgen(101)*nn/100.+range[0])*!pi/180.
result = fltarr(101)

for i=0, n_elements(theta)-1 do begin
    ttemp = i_rotate(temp,theta(i))
    result(i) = mean(ttemp(0,*))
    print, theta(i)*180./!pi, result(i)
endfor

cgplot, theta*180./!pi, result, charsize=1.0, /ynozero

end
