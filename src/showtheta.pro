;+
; Name: showtheta
; Purpose:
; Input: showtheta, ptdef
; History: created by sungcheol kim, 2/11/12
;-

pro showtheta, ptdef, maxtime=maxtime, length=length, bs = bs

n = n_elements(ptdef(0,*))
if not keyword_set(maxtime) then maxtime = n
if not keyword_set(length) then length = 1.
if not keyword_set(bs) then bs = 1.5

dx = ptdef(0,1:maxtime-1)-ptdef(0,0:maxtime-2)
dy = ptdef(1,1:maxtime-1)-ptdef(1,0:maxtime-2)

theta = atan(dy/dx)*180./!pi
w1 = where(sqrt(dx^2+dy^2) gt length/0.083,wc)
w2 = where(sqrt(dx^2+dy^2) le length/0.083,wc)

t = indgen(maxtime-1)/30.

cgplot, t(w1), theta(w1), xtitle='Time (sec)', ytitle=ps_symbol('theta'), /window, $
    charsize=1., xstyle=1, psym=-14, wmulti=[0,1,2], xran=[t(0),t(maxtime-2)], $
    yticks=6, yran=[-90,90], ystyle=1, symcolor='blk7', color='blk5'
cgplots, t(w2), theta(w2), /addcmd, symcolor='red6', psym=-14, color='red4', $
    linestyle=2

th1 = histogram(theta(w1),binsize=bs, locations=th1x)
th2 = histogram(theta(w2),binsize=bs, locations=th2x)

cgplot, th1x, th1/(n_elements(th1)*bs), charsize=1., /window, /addcmd, xran=[-90,90], xstyle=1., psym=10, ytitle= 'Probability', xtitle=ps_symbol('theta'), $
    xticks=6
cgplot, th2x, th2/(n_elements(th2)*bs), /addcmd, color='red6', psym=10, /overplot, $
    linestyle=2

end
