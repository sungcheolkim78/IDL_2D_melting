;+
; Name: t_sp
; Purpose: calculate survival probability function
; Input: t_sp, tpt, length
; History: created by sungcheol kim, 12/1/25
;-

function t_sp, tpt, length, tmax=tmax, _extra=_extra

if not keyword_set(tmax) then tmax = 30
ntracks = n_elements(tpt[0,0,*])
t = indgen(tmax)+1
result = fltarr(n_elements(t))
;print, t

for i = 0, n_elements(t)-1 do begin

    x = 0
    for j=0,ntracks-1 do begin
        tl = tpt(1,0,j)
        y = tpt(1,1:*,j)

        for k=0,tl-t(i)-1 do x = [x, y(k+t(i))-y(k)]
    endfor

    x = x(1:*)
    if mean(x) lt 0 then x = -x

    w = where(x le length, wc)
    result(i) = float(wc)/float(n_elements(x))

    ;print, max(x), min(x)
    ;print, wc, n_elements(x), result(i)

endfor

if not keyword_set(color) then color='red6'

cgplot, t/30., result, charsize=1., /window, /addcmd, /overplot, psym=-14, symcolor='blk8', _extra=_extra, linestyle=3

return, result

end
