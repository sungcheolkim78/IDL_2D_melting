;+
; Name: hoppingrate
; Purpose:
; Input: hoppingrate, ptdef
; History: created by sungcheol kim, 2/16/12
;-

pro hoppingrate, ptdef, maxtime=maxtime, length=length, bs = bs, miperpix=miperpix

n = n_elements(ptdef(0,*))
if not keyword_set(maxtime) then maxtime = n
if not keyword_set(length) then length = 1.
if not keyword_set(bs) then bs = 1.5
if not keyword_set(miperpix) then miperpix = 0.083

dx = ptdef(0,1:maxtime-1)-ptdef(0,0:maxtime-2)
dy = ptdef(1,1:maxtime-1)-ptdef(1,0:maxtime-2)

theta = atan(dy/dx)*180./!pi
dr = sqrt(dx^2+dy^2)
w = where(dr lt length/miperpix, wc)
data = intarr(maxtime-1)
data(w) = 1
t = 1.
result = 0.
state = 0

print, data

for i=0,maxtime-2 do begin
    case data(i) of
    1: begin
        if state eq 1 then t += 1. else t=1.
        state = 1
        end
    0: begin
        if state eq 0 then t = 0.
        if state eq 1 then begin
            result = [result, t]
;            print, 'Detect time: '+strtrim(t,2)
            t = 0.
        endif
        state = 0
        end
    endcase
endfor

result = result[1:*]

h = histogram(result, binsize=1.,locations=hx)
htotal = total(h)
;htotal = 1.
fit = mpfitexpr('P[0]*exp(-P[1]*X)',hx,h/(htotal*1.),err,[50,1],/weight)
tau = 1./fit[1]

hx = [hx, max(hx)+1.]
h = [h, 0]
cgplot, hx, h/(htotal*1.), psym=14, /window, charsize=1., xtitle='Residence Time (1/30 sec.)', $
    xran=[0,8], xstyle=1, yran=[0.001,1.], /ylog, ytitle='Hist.'
cgplots, hx, h/(htotal*1.), psym=14, /addcmd
cgplot, /addcmd, /overplot, hx, fit[0]*exp(-fit[1]*hx), color='red5', linestyle=2
cgtext, 0.7,0.85, 'tau = '+strtrim(tau,2)+' sec', charsize=1., /addcmd, /normal

;plot_hist, result, binsize=1., /window,  $
;    charsize=1.,ytitle='number', xtitle='Time (1/30 sec.)'

print, mean(result)

end
