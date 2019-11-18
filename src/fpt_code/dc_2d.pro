;+
; Name: dc_2d
; Purpose: diffusion constant for 2d colloid particles
; Input: dc_2d, pt, win
; History: created by sungcheol kim, 12/1/5
;-

pro dc_2d, pt, ywin=ywin, xwin=xwin, dx = dx, xx=xx, yx=yx, $
    theta=theta, dis=dis, times=times, show=show, color=color, prefix=prefix, binsize=binsize

temp = pt
if keyword_set(theta) then begin
    temp = i_rotate(pt,theta)
    print, string(theta) + ' rotated!'
endif
v = 5
if keyword_set(dis) then v = dis
if not keyword_set(color) then color='red3'

win = [0,512,0,512]
if n_elements(ywin) eq 2 then win = [win(0), win(1), ywin(0), ywin(1)]
if n_elements(xwin) eq 2 then win = [xwin(0), xwin(1),win(2),win(3)]

ptt = eclip(temp,[0,win[0],win[1]],[1,win[2],win[3]])
tt = track(ptt, v, good=10, memory=10)

if not keyword_set(dx) then dx = 2.5
coor = 0
if keyword_set(xx) then coor = 0
if keyword_set(yx) then coor = 1

maxt = max(tt(6,*), min=mint)
for i=mint,maxt do begin
    w = where(tt(6,*) eq i)
    maxx = max(tt(0,w),min=minx)
    maxy = max(tt(1,w),min=miny)
    if (maxx - minx lt dx) and (maxy - miny lt dx) then begin
        print, 'Track '+strtrim(i,2)+' is fixed point'
        dw = where(tt(6,*) ne i)
        tt = tt(*,dw)
    endif
endfor

if not keyword_set(times) then times = [1,2,3,4,5,6,7,8,9,10]
tcoff = fltarr(9,n_elements(times))

for i=0,n_elements(times)-1 do begin
    dx = getdx(tt,times(i),dim=2)
    w = where(dx(2,*) gt 0)

    data = dx(coor,w)
    meandata = mean(data)

    if not keyword_set(binsize) then begin
        nbins = 30
        binsize = (max(data)-min(data))/(nbins-1)
    endif else begin
        binsize = binsize
        nbins = 1 + (max(data)-min(data))/binsize
    endelse

    h = histogram(data, binsize=binsize,locations=t)
    ;t = indgen(nbins)*binsize+min(data)
    Ndx = total(h)*binsize

    fit = mpfitexpr('P[0]*exp(-(X-P[1])^2/(2*P[2]^2))', t+binsize/2., h/Ndx, error, [0.1, meandata, 0.5], /weight,bestnorm=chisq,/quiet,covar=cov)

    if keyword_set(show) then begin
        if show eq times(i) then begin
            cgplot, t/3.75, h/Ndx, psym=10, charsize=1.0, xran=[-10,1.5],yran=[0,0.4], /addcmd,/overplot
            cgplot, t/3.75, fit[0]*exp(-(t-fit[1])^2/(2*fit[2]^2)), /overplot, charsize=1., /addcmd,color=color
        endif
    endif

    cgplot, t/3.75, h/Ndx, psym=10, charsize=1.0
    cgplot, t/3.75, fit[0]*exp(-(t-fit[1])^2/(2*fit[2]^2)), linestyle=3, /overplot, charsize=1.

    tcoff(0,i) = times(i)
    tcoff(1:3,i) = fit
    tcoff(4,i) = chisq

    ; calculate mean value and std error
    tcoff(5,i) = sqrt(cov(0,0))
    tcoff(6,i) = sqrt(cov(1,1))
    tcoff(7,i) = sqrt(cov(2,2))
    tcoff(8,i) = n_elements(data)

    if not keyword_set(show) then s = get_kbrd()
endfor

if not keyword_set(prefix) then prefix = ''
fname = prefix + 'result'
if keyword_set(xx) then fname = fname+'-x.txt'
if keyword_set(yx) then fname = fname+'-y.txt'
print, tcoff
print, fname

openw, 1, fname
printf, 1, tcoff, format='(I3,F11.5,F11.5,F11.5,F11.5,F11.5,F11.5,F11.5,F11.5,I3)'
close, 1

if not keyword_set(show) then begin
    cgplot, /window, tcoff(0,*), tcoff(3,*)^2, charsize=1., psym=14
    fitt = linfit(tcoff(0,*), tcoff(3,*)^2/2., measure_errors=tcoff(7,*)^2, sigma=sigma)
    cgplot, /window, /addcmd, /overplot, tcoff(0,*), 2.*fitt[0]+2.*fitt[1]*tcoff(0,*), $
        color='red6', linestyle=2
    print, fitt, sigma
endif

end
    
