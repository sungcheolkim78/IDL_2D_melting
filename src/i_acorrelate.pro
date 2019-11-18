;+
; Name: i_acorrelate
; Purpose: calculate auto correlation of variable
; Input: i_acorrelate, y, lag
; History: created by sungcheol kim, 12/05/11
;-

function i_acorrelate, y, lag, static=static

nlag = n_elements(lag)
ny = n_elements(y)
result = fltarr(nlag)

if keyword_set(static) then data = y  - (total(y)/float(ny)) else data = y

for i=0,nlag-1 do $
    result(i) = total(data[0:ny-1-lag(i)]*data[lag(i):*])/float(ny-lag(i))

return,result

end
