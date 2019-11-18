;+
; Name: residencetime
; Purpose:
; Input: residencetime, ptdef, configuration
; History: created by sungcheol kim, 3/15/12
;-

pro residencetime, ptdef, type, maxtime=maxtime, bs = bs, miperpix=miperpix

n = n_elements(ptdef(0,*))
if not keyword_set(maxtime) then maxtime = n
if not keyword_set(bs) then bs = 1.5
if not keyword_set(miperpix) then miperpix = 0.083
if not keyword_set(type) then type = 5  ; I3

;type = float(i_typematch(conf))
;temp = ptdef
;w2 = where(temp(3,*) eq 3 or temp(3,*) eq 4, w2c)
;temp(3,w2) = 2

w = where(ptdef(3,0:maxtime-1) eq type, wc)
print, type, wc

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

if wc le 1 then begin
    print, 'too small numbers'
    return
endif

result = result[1:*]

h = histogram(result, binsize=bs,locations=hx)
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
cgtext, 0.7,0.85, 'tau = '+strtrim(tau/30.,2)+' sec', charsize=1., /addcmd, /normal

;plot_hist, result, binsize=1., /window,  $
;    charsize=1.,ytitle='number', xtitle='Time (1/30 sec.)'

print, mean(result)

end
