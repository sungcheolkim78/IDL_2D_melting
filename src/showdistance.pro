;+
; Name: showdistance
; Purpose:
; Input: showdistance, ptdef
; History: created by sungcheol kim, 2/11/12
;-

pro showdistance, ptdef, maxtime=maxtime, length=length, bs = bs, miperpix=miperpix

n = n_elements(ptdef(0,*))
if not keyword_set(maxtime) then maxtime = n
if not keyword_set(length) then length = 1.
if not keyword_set(bs) then bs = 1.5
if not keyword_set(miperpix) then miperpix = 0.083

dx = ptdef(0,1:maxtime-1)-ptdef(0,0:maxtime-2)
dy = ptdef(1,1:maxtime-1)-ptdef(1,0:maxtime-2)

dr = sqrt(dx^2+dy^2)

w = where(dr gt length/miperpix, wc)

t = indgen(maxtime-1)/30.
maxr = max(dr) + 0.1*(max(dr)-min(dr))
minr = min(dr) - 0.1*(max(dr)-min(dr))

cgplot, t, dr*miperpix, xtitle='Time (sec)', ytitle='distance (um)', /window, $
    charsize=1., xstyle=1, psym=-14, wmulti=[0,2,1], xran=[t(0),t(maxtime-2)], $
    yran=[minr,maxr]*miperpix, ystyle=1, symcolor='blk7', color='blk4', noclip=0
;cgplots, t(w2), dr(w2)*0.083, /addcmd, symcolor='red6', psym=-14, color='red4', $
    ;linestyle=2

th = histogram(dr,binsize=bs, locations=thx)
th = [0, th, 0]
thx = [0, thx, max(thx)+bs]

;cgplot, thx*0.083, th/(n_elements(th)*bs), charsize=1., /window, /addcmd, xran=[-5,45]*0.083, xstyle=1., psym=10, ytitle= 'Probability Density', xtitle='distance (um)', ystyle=1

cghistoplot, dr*miperpix, binsize=bs*miperpix, /addcmd, yran=[minr,maxr]*miperpix, $
    ystyle=1, charsize=1.,/fill, /rotate, ytitle='distance (um)', $
    /frequency, xticks=4, xtickformat='(F4.2)'

print, mean(dr(w))*miperpix, stddev(dr(w))*miperpix

end
