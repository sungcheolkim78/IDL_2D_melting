;+
; Name: i_veldist
; Purpose: calcaulte velocity distribution from tpt file
; Input: i_veldist, tpt
; History: created by sungcheol kim, 2/21/12
;-

function i_veldist, tpt, overplot=overplot, color=color, ymax=ymax, bs=bs

ntracks=n_elements(tpt(0,0,*))
tdy = 0
tdx = 0

if not keyword_set(ymax) then ymax=0.08
if not keyword_set(bs) then bs = 1.

for i=0,ntracks-1 do begin
    tl = tpt(0,0,i)
    x = tpt(0,1:tl,i)
    y = tpt(1,1:tl,i)
    dy = y(1:tl-1)-y(0:tl-2)
    dx = x(1:tl-1)-x(0:tl-2)

    tdy = [tdy, dy]
    tdx = [tdx, dx]
endfor

tdy = tdy(1:*)
tdx = tdx(1:*)
tdr = sqrt(tdy^2+tdx^2)

!p.multi=[0,1,1]

h = histogram(tdy*30./3.75, binsize=bs, locations=hx)

if not keyword_set(color) then color='red6'
if keyword_set(overplot) then begin
    cgplot, hx, h/(total(h)*bs), charsize=1., /addcmd, /overplot, psym=10, color=color
    yfit = gaussfit(hx, h/(total(h)*bs),coeff,nterms=3)
    cgplot, hx, yfit, /overplot, /addcmd, color=color
endif else begin
    cgplot, hx, h/(total(h)*bs), charsize=1., /window, xtitle='vel (um/s)', color=color $
        ,psym=10, yran=[0,ymax], ytitle='P(v)'
    yfit = gaussfit(hx, h/(total(h)*bs),coeff,nterms=3)
    cgplot, hx, yfit, /overplot, /addcmd, color=color
endelse

print, coeff

return, tdy
end
