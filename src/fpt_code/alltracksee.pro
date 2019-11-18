;+
; Name: alltrackview
; Purpose: view every track on time
; Input: alltrackview,tt,theta=theta, ywin=ywin
; History:  created by sungcheol kim, 11/05/11
;           modified by sungcheol kim, 11/16/11 - add more graphs
;-

function delete_track, tt, i
    if i eq 0 then begin
        w = where(tt(6,*) gt 0)
        temp = tt(*,w)
        temp(6,*) -= 1
        return, temp
    endif

    w = where(tt(6,*) ne i, wc)
    temp = tt(*,w)
    ww = where(temp(6,*) gt i)
    temp(6,ww) -= 1
    return, temp
end

pro alltracksee, pt, prefix=prefix, theta=theta, dis=dis, ywin=ywin, remove=remove, select=select, fit=fit, length=length

if not keyword_set(dis) then dis=20 
if not keyword_set(prefix) then prefix=''

; select area of interest in y position
if keyword_set(ywin) then temp = eclip(pt, [1,ywin[0],ywin[1]]) else begin
    temp=pt
    ywin=[0,512]
endelse

; make track from pt file with dis, good=0, memory=20
tt = trackg(temp, dis, good=0, memory=10, dim=2)

; check track and delte fixed point
if keyword_set(length) then begin
    h = histogram(tt(6,*))
    w = where(h lt length,wc)
    for j=0,wc-1 do begin
        tt = delete_track(tt,w[j])
        w -= 1
    endfor
endif

if keyword_set(remove) then begin
    rn = n_elements(remove)
    for i=0,rn-1 do begin
        tt = delete_track(tt,remove[i])
        remove = remove-1
        print, remove[i]
    endfor
endif

if keyword_set(select) then begin
    ws = where(tt(6,*) eq select,wsc)
    if wsc gt 0 then tt = tt(*,ws)
endif
    
dx = getdx(tt,1,dim=2)
imin = min(tt(6,*),max=imax)
ihist = histogram(tt(6,*))
tmax = max(ihist)
data = fltarr(2,tmax+1,imax-imin+1)
frames = fix(max(tt(5,*))-min(tt(5,*))+1)
;print, imin, imax

; rotate all coordinate by angel theta
if keyword_set(theta) then tt = i_rotate(tt, theta) else theta=0

; prepare postscript output
thisDevice = !D.name
!p.multi = [0,2,3]
set_plot, 'ps'
!p.font = 0
device, /color, /encapsul, /helvetica, bits=8
if keyword_set(prefix) then filename = 'ati_'+prefix+'.eps' else filename = 'ati.eps'
device, xsize=16, ysize=22, file=filename

; plot track information - time trace
cgplot, findgen(tmax), /nodata, xran=[0,tmax],yran=[min(tt(1,*)),max(tt(1,*))],xstyle=1,ystyle=1,xtitle='frames', ytitle='y (pixels)'

for i=imin,imax do begin
    w = where(tt(6,*) eq i,wc)
    if wc gt 0 then begin
        y = tt(1,w)
        data(1,0,i-imin) = wc
        data(1,1:wc,i-imin) = y
        cgplots, findgen(wc), y, color='red4'
        cgtext,strtrim(fix(i),2),wc,y(wc-1),charsize=0.8,color='red3'
    endif
endfor
cgtext, strtrim(fix(imax-imin+1),2)+' tracks over '+strtrim(frames,2)+' frames',0.18,0.66,charsize=0.8,/normal

; plot time trace of x coordinate
cgplot, findgen(tmax), /nodata, xran=[0,tmax],yran=[-10,10],xstyle=1,ystyle=1,xtitle='frame', ytitle='x (pixels)'
for i=imin,imax do begin
    w = where(tt(6,*) eq i,wc)
    if wc gt 0 then begin
        x = tt(0,w)
        data(0,0,i-imin) = wc
        data(0,1:wc,i-imin) = x-x(0)
        cgplots, findgen(wc), x-x(0)
    endif
endfor
cgtext, 'mean: '+strtrim(mean(data(0,*,*)),2)+' STD: '+strtrim(stddev(data(0,*,*)),2), 0.64, 0.66, charsize=0.8, /normal
cgtext, 'theta: '+string(theta,format='(F5.2)')+' vel: '+strtrim(dis,2), 0.64, 0.96, charsize=0.8, /normal

; plot histogram of y and x velocity
w = where(dx(2,*) gt 0, wc)
if keyword_set(fit) then plot_hist, dx(1,w),xtitle='y velocity (pixel/frame)', /average, /center, charsize=1., /fit else begin 
    plot_hist, dx(1,w),xtitle='y velocity (pixel/frame)', /average, /center, charsize=1.
    cgtext, 'mean: '+strtrim(mean(dx(1,*)),2), 0.10, 0.63, charsize=0.8, /normal
    cgtext, 'std: '+strtrim(stddev(dx(1,*)),2), 0.10, 0.61, charsize=0.8, /normal
endelse

plot_hist, dx(0,w),xtitle='x velocity (pixel/frame)', /average, /fit, /center, charsize=1.0

; plot velocity distribution along y axis
w = where(dx(2,*) gt 0)
av = avgbin(tt(1,w), dx(1,w))
cgplot, av(0,*), av(1,*), xstyle=1, xtitle='y (pixels)', ytitle='y vel (pixels/frame)', /ynozero
cgtext, 'mean: '+strtrim(mean(av(1,*)),2)+' STD: '+strtrim(stddev(av(1,*)),2), 0.12,0.315,charsize=0.8,/normal
fit = linfit(av(0,*), av(1,*), chisqr=chi, prob=prob, yfit=y)
cgplots, av(0,*), y, linestyle=3
cgtext, 'slope: '+strtrim(fit[1],2), 0.22,0.10,charsize=0.8,/normal
cgtext, 'y0: '+strtrim(fit[0],2), 0.22,0.08,charsize=0.8,/normal
cgtext, 'chi: '+strtrim(chi,2), 0.22,0.06,charsize=0.8,/normal

av = avgbin(tt(1,w), dx(0,w))
cgplot, av(0,*), av(1,*), xstyle=1, xtitle='y', ytitle='x vel (pixels/frame)'
cgtext, 'mean: '+strtrim(mean(av(1,*)),2)+' STD: '+strtrim(stddev(av(1,*)),2), 0.64,0.315,charsize=0.8,/normal

write_gdf,data,'tpt.'+prefix
i_close, filename, thisDevice
!p.multi=[0,1,1]

end
