;+
; Name: veltpt
; Purpose: calculate velocity from tpt file
; Input, veltpt, tptfilename
; History: created by sungcheol, 2/2/12
;          modified by sungcheol kim, 2/22/12 - using cubic term
;-

function dy2, X, P
    return, (2.*P[0]+P[1]^2*P[2])*X-P[1]^2*P[2]^2*(1.-exp(-X/P[2]))
end

pro veltpt, tptfilename, overplot=overplot, color=color, option=option, $
    _extra=_extra, psym=psym, velsub=velsub, ymax=ymax, y2max=y2max, dmax=dmax

if not keyword_set(option) then option = 1

tpt = read_gdf(tptfilename)

tmax = n_elements(tpt(0,0,*))

time = [1,2,3,4,5,6,7,8,9]
ntime = n_elements(time)
time2 = [0,time,max(time)+1]
data = fltarr(5,n_elements(time))
ptarray = ptrarr(n_elements(time),/allocate_heap)
ptarray2 = ptrarr(n_elements(time),/allocate_heap)

for i=0,n_elements(time)-1 do begin
    yt = i_coordinate(tpt,time[i],option=option)
    if keyword_set(velsub) then yt = yt - velsub*time[i]^2

    *ptarray(i) = yt
    data(0,i) = mean(yt)
    data(1,i) = stddev(yt)

    yt2 = (yt-mean(yt))^2
    *ptarray2(i) = yt2

    data(2,i) = mean(yt2)
    data(3,i) = stddev(yt2)
    data(4,i) = n_elements(yt)
endfor

if not keyword_set(color) then color='blk8'
if not keyword_set(psym) then psym=14
if not keyword_set(ymax) then ymax=max(abs(data(0,*))+data(1,*))
if not keyword_set(y2max) then y2max=max(data(2,*))
if not keyword_set(dmax) then dmax=max(data(2,1:ntime-1)-data(2,0:ntime-2))

pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
pi(1).fixed = 0

fitv = linfit(time, data(0,*), measure_errors=data(1,*),prob=prob, sigma=sigma, chisqr=chisq)
fitd = mpfitfun('dy2',time, data(2,*), data(3,*), [0.2,abs(fitv[1]),1.], bestnorm=chisq, covar = cov,PARINFO=pi)
dir = 1.

if mean(data(0,*)) lt 0 then begin
    data(0,*) = -data(0,*)
    dir = -1.
endif

if keyword_set(overplot) then $
    cgplot, time, data(0,*)/3.75, yran=[0,ymax]/3.75, $
        layout=[1,3,1], psym= psym, /addcmd, charsize=1., xran=[0,max(time)+1],xstyle=1 $
        else $
    cgplot, time, data(0,*)/3.75, charsize=1., xtitle='Time (1/30 sec)', ytitle='<y> (um)', $
        /window, layout=[1,3,1], psym= psym, xran=[0, max(time)+1], xstyle=1, _extra=_extra, $
        yran=[0,ymax]/3.75

cgwindow,'oploterror', time, data(0,*)/3.75, data(1,*)/3.75, /addcmd, psym=3, $
    errcolor= fsc_color('blu6')
cgplot, /addcmd, time2, dir*(fitv[0]+fitv[1]*time2)/3.75, /overplot, color='red6',linestyle=2

if keyword_set(overplot) then $
    cgplot, time, data(2,*)/(3.75*3.75), /addcmd, xran=[0,max(time)+1],xstyle=1, $
        psym=psym, layout=[1,3,2], charsize=1.,yran=[0,y2max]/(3.75*3.75) $
        else $
    cgplot, time, data(2,*)/(3.75*3.75), charsize=1., xtitle='Time (1/30 sec)', /addcmd, $
        psym=psym, xran=[0,max(time)+1], xstyle=1, layout=[1,3,2], _extra=_extra, $
        yran=[0,y2max]/(3.75*3.75), ytitle='<dy^2> (um^2)'

cgwindow,'oploterror', time, data(2,*)/(3.75*3.75), data(3,*)/(3.75*3.75), /addcmd, psym=3, $
    errcolor=fsc_color('blu6')
cgplot, /addcmd, /window, time2, $
    dy2(time2,fitd)/(3.75*3.75), $
    /overplot, linestyle=2 , color='red6'

dy2 = (2.*data(2,1:*)-3./2.*data(2,0:ntime-2)-data(2,2:*)/2.)/2.*30./(3.75*3.75)
;dy2 = i_dd(data(2,*))
;dy2 = dy2(0,*)*30./(2.*3.75*3.75)
time3 = time2(1:ntime-2)
if keyword_set(overplot) then $
    cgplot, time3, dy2, charsize=1., $
    layout=[1,3,3],/addcmd, /ynozero, yran=[0,dmax] , psym=psym, color=color, linestyle=2 $
    else $
    cgplot, time3, dy2, charsize=1., $
    layout=[1,3,3],/addcmd, /ynozero, xtitle='Time (1/30 sec)', $
    ytitle='d/dt y2', yran=[0,dmax], psym=psym, color=color, linestyle=2

fitd3 = mpfitexpr('P[0]+P[1]*(1.-exp(-P[2]*X))', time3, dy2, err, /weight, [1.0, 3.0, 5.0])

cgplot, /addcmd, /window, time2, fitd3[0]+fitd3[1]*(1.-exp(-fitd3[2]*time2)), /overplot,$
    linestyle=2, color='red6'

print, 'vel: '+strtrim(fitv[1]*30./3.75,2)+' +- '+strtrim(sigma[1]*30./3.75,2)
print, 'D: '+strtrim(fitd[0]*30./(3.75*3.75),2)+'  vel: '+strtrim(fitd[1]*30./3.75,2)+$
    ' a: '+strtrim(sqrt(fitd[2]*fitd[0]*!pi^2)/3.75,2)
print, 'D0: '+strtrim(fitd3[0],2)+' D*: '+strtrim(fitd3[0]+fitd3[1],2)
print, 'min(D): '+strtrim(min(dy2),2)+' max(D): '+strtrim(max(dy2),2)

savedata = [fitv[1], sigma[1], fitd[0], sqrt(cov[0,0]), fitd[1], sqrt(cov[1,1])]
close, 1
openw, 1, 'veldata.txt', /append
printf, 1, format='(F11.5, F11.5, F11.5, F11.5, F11.5, F11.5)', savedata
close, 1

end
