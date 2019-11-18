;+ 
; Name: velprofile
; Purpose: show velocity profile on x-axis
; Input: velprofile, pt
; History: created by sungcheol kim on 10/24/11
;          modified by sungcheol kim on 01/13/12 - add window, theta
;-

pro velprofile, filename, fixed=fixed, prefix=prefix, theta=theta, dis=dis, xwin=xwin, option=option, ywin=ywin, overplot=overplot, color=color,xbar=xbar

; constants
velconv = 16./(60.*0.03202)
pixconv = 16./60.
thisDevice = !D.name

pt = read_gdf(filename)
temp = pt
if keyword_set(theta) then begin
    temp = i_rotate(pt, theta)
    print, string(theta) + ' rotated'
endif
if keyword_set(ywin) then temp = eclip(temp, [1,ywin(0),ywin(1)])

v = 5
if keyword_set(dis) then v = dis

tt = track(temp,v,good=5,memory=5)

dx = getdx(tt,1,dim=2)

if not keyword_set(fixed) then fixed = 1.0
w = where(dx(2,*) gt fixed, wc)

if not keyword_set(option) then option = 0
if not keyword_set(color) then color='blk7'

case option of 
    0: av = avgbin(tt(0,w),dx(1,w))
    1: av = avgbin(tt(1,w),dx(1,w))
endcase

meanv = mean(av(1,*)*velconv)
meanx = mean(av(0,*))
av(0,*) -= meanx
xrange = [min(av(0,*)*pixconv), max(av(0,*)*pixconv)]
if keyword_set(xwin) then xrange = [xwin(0),xwin(1)]

if keyword_set(xbar) then begin
    wbar = where((tt(0,w)-meanx) gt xbar,wbarc)
    print, 'over: '+strtrim(wbarc,2)+' total: '+strtrim(wc,2)
endif

if keyword_set(overplot) then begin
    cgplot, av(0,*)*pixconv, av(1,*)*velconv, psym=-14, /addcmd,/overplot,charsize=1.,$
        /window, color=color
endif else begin
    cgplot, av(0,*)*pixconv, av(1,*)*velconv, charsize=1., xtitle='x (um)', ytitle='vel (um/s)', xstyle=1, psym=-14, xran=xrange, /window, color=color
    cgplots, xrange, [meanv, meanv], color='grn6'
endelse

end
