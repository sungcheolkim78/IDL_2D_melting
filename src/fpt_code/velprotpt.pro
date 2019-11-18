;+
; Name: velprotpt
; Purpose: calcualte the velocity profile on x axis and probability density
; Input: velprotpt, tptfilename
; History: created by sungcheol kim, 2/21/12
;-

pro velprotpt, tptfilename, xbar=xbar, overplot=overplot, ymax=ymax, ymin=ymin, $
    color=color, psym=psym, theta=theta

tpt = read_gdf(tptfilename)
ntracks = n_elements(tpt(0,0,*))

if not keyword_set(xbar) then xbar = 0.55
if not keyword_set(color) then color = 'red6'
if not keyword_set(psym) then psym = 14

tx = 0
tdy = 0

for i=0, ntracks-1 do begin
    tl = tpt(1,0,i)
    x = tpt(0,1:tl,i)
    y = tpt(1,1:tl,i)
    dy = y(1:tl-1)-y(0:tl-2)

    x = x(0:tl-2) - mean(x)
    ;x = x(0:tl-2)
    tx = [tx, x]
    tdy = [tdy, dy]
endfor

tx = tx(1:*)
tdy = tdy(1:*)

av = avgbin(tx, tdy, binsize=0.3)
hx = histogram(tx,binsize=0.1,locations=hxx)

wbar = where(hxx/3.75 gt xbar or hxx/3.75 lt -xbar)
print, total(hx(wbar)), total(hx(wbar))/total(hx)*100

if not keyword_set(ymax) then ymax = 0
if not keyword_set(ymin) then ymin = -35
yran = [ymin, ymax]
xran = [-1.0, 1.0]

if keyword_set(overplot) then $
    cgplot, hxx/3.75, hx/float(total(hx)*0.1), charsize=1., /addcmd, layout=[2,1,1], $
        xtitle='x (um)', ytitle='frequency',xran=xran,xstyle=1 else $
    cgplot, hxx/3.75, hx/float(total(hx)*0.1), charsize=1., /window, layout=[2,1,1], $
        xtitle='x (um)', ytitle='frequency',xran=xran,xstyle=1

cgplots, [xbar,xbar], [0,1], linestyle=2, color='grn5', /addcmd, noclip=0
cgplots, -[xbar,xbar], [0,1], linestyle=2, color='grn5', /addcmd, noclip=0

x = av(0,*)/3.75+0.1
vy = av(1,*)*30./3.75
vy2 = av(2,*)*30./3.75
nx = n_elements(av(0,*))
v0 = av(1,nx/2+1)*30./3.75
a = 0.80
fvy = v0*(1.-x^2/a^2)

pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
pi(2).limited = [1,1]
pi(2).limits = [-0.2,0.2]
pi(1).limited = [1,1]
pi(1).limits = [0.5,1.2]

fit = mpfitexpr('P[0]*(1.-(X-P[2])^2/P[1]^2)', x, vy, vy2, [v0,a,0.1],/weights,parinfo=pi)
fvy = fit[0]*(1.-(x-fit[2])^2/fit[1]^2)

cgplot, x, vy, charsize=1., /addcmd, /window, $
    psym=psym, layout=[2,1,2], xtitle='x (um)', ytitle='v (um/s)', $
    color=color, symcolor='blk7', xran=xran, yran=yran,xstyle=1
cgplot, x, fvy, charsize=1., /addcmd, /overplot, color='red3'
;cgwindow,'oploterror',x,vy,vy2,/addcmd,errcolor='blu5'
cgplots, [xbar,xbar], yran, linestyle=2, color='grn5', /addcmd, noclip=0
cgplots, -[xbar,xbar], yran, linestyle=2, color='grn5', /addcmd, noclip=0

end
