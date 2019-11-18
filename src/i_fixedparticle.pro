;+
; Name: i_fixedparticle
; Purpose: return indexs of fixed particles
; Input: i_fixedparticle, tt
; Hitory: created by sungcheol kim at 10/26/11
;-

function i_fixedparticle, tt

imin = min(tt(6,*))
imax = max(tt(6,*))
tlength = max(tt(5,*))-min(tt(5,*))

hi = histogram(tt(6,*))
result = fltarr(2,fix(imax-imin)+1)

!p.multi=[0,2,1]
cgplot,findgen(512),/nodata,xran=[0,512],yran=[0,512],xstyle=1,ystyle=1,charsize=1.0

for i=imin, imax do begin
    x = tt(0,where(tt(6,*) eq i))
    y = tt(1,where(tt(6,*) eq i))
    x_err = x(1:hi(i)-1) - x(0:hi(i)-2)
    y_err = y(1:hi(i)-1) - y(0:hi(i)-2)
    r_err = sqrt(x_err^2+y_err^2)
    err = mean(r_err)

    if err le 0.5 then cgplot,x,y,psym=3,/overplot
    result(0,i)=i
    result(1,i)=err
endfor

cgplot, result(0,*), result(1,*),psym=3,charsize=1.,xstyle=1

w = where(result(1,*) le 0.5)

return, w

end

