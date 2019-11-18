;+
; Name: pulseview
; Purpose: show time trace of particle by given period of time
; Input: pulseview,tpt,[start,end]
; History: created by sungcheol kim, 11/17/11
;          modified by sungcheol kim, 01/18/12
;          1) process arguments
;          2) save data by each time span
;          3) show data
;-

pro pulseview, tpt, time, track=track, prefix=prefix, viewt=viewt, remove=remove

; 1) process initial arguments
if n_elements(time) ne 2 then begin
    print,'Usage: pulseview, tpt, [0,30]'
    return
endif

if not keyword_set(track) then track=0
if not keyword_set(prefix) then prefix=''
if not keyword_set(viewt) then viewt = 200

trackn = n_elements(tpt(0,0,*))
if track gt trackn-1 then begin
    print, 'Tracks: 0 - '+strcompress(string(trackn-1))
    return
endif

; 2) prepare data
xdata = tpt(0,1:*,track)
ydata = tpt(1,1:*,track)

tmax = n_elements(ydata)             ; total track length
tlength = time[1]-time[0]            ; time span
timem = fix((time[0]+time[1])/2)
tspan = timem-time[0]
ntrack = fix(tmax/tlength)-1         ; number of pulse
x = indgen(tspan+1)                  ; time in one pulse
datau = fltarr(2,tspan+1,ntrack)
datad = fltarr(2,tspan+1,ntrack)
print, time[0], timem, time[1], tlength, tspan, ntrack, tmax

for i=0,ntrack-1 do begin
    starti = i*tlength+time[0]
    stopi = i*tlength+time[1]
    middlei = i*tlength+timem
    if stopi gt tmax then continue

    datau(*,0,i) = tspan
    datad(*,0,i) = tspan

    datau(0,1:*,i)=xdata(starti:middlei-1) - xdata(starti)
    datau(1,1:*,i)=ydata(starti:middlei-1) - ydata(starti)

    datad(0,1:*,i)=xdata(middlei:stopi-1) - xdata(middlei)
    datad(1,1:*,i)=ydata(middlei:stopi-1) - ydata(middlei)
endfor

ymax=max(abs(datau(1,1:*,*)))

avryup = total(datau(1,1:*,*),3)/ntrack
avrydown = total(datad(1,1:*,*),3)/ntrack

if avryup(0) gt 0 then begin
    write_gdf,datau,'tptu.'+prefix
    write_gdf,datad,'tptd.'+prefix
endif else begin
    write_gdf,datad,'tptu.'+prefix
    write_gdf,datau,'tptd.'+prefix
endelse

dyu = datau(1,2:tspan-1,*)-datau(1,1:tspan-2,*)
dyd = datad(1,2:tspan-1,*)-datad(1,1:tspan-2,*)
dyu = reform(dyu, tspan-2, ntrack)
dyd = reform(dyd, tspan-2, ntrack)

dyp = dyu+dyd
dy = ydata(1:tmax-1)-ydata(0:tmax-2)

vp = fltarr(ntrack)
tt = indgen(ntrack)*tlength

for i=0,ntrack-1 do vp(i) = total(dyu(*,i)+dyd(*,i))/(2*tlength)

measure_errors = sqrt(abs(vp))
result = mpfitexpr('P[0]+P[1]*X',tt,vp,measure_errors,[0.,1.])

; plot result
cgWindow,'cgplot', indgen(tspan),avryup-avryup(0), yran=[-ymax,ymax], charsize=1.,psym=14, xstyle=1, wmulti=[0,2,3], xtitle='Time (frame)', ytitle='Avr(y) (pixel)'
cgWindow,'cgplot', indgen(tspan),avrydown-avrydown(0), psym=14, /overplot,/addcmd

cgWindow,'plot_hist', dyp, charsize=1.0, /fit,/center,/average,xtitle='V(up)+V(down)=2*V(p)',/addcmd, binsize=0.5
cgWindow,'plot_hist', dyu,/fit,/center,/average,xtitle='V (pixel/frame)',charsize=1.,/addcmd, binsize=0.5
cgWindow,'plot_hist', dyd,/fit,/center,/average,xtitle='V (pixel/frame)',charsize=1.,/addcmd, binsize=0.5

cgWindow,'cgplot', indgen(viewt+1), dy(0:viewt), /addcmd, charsize=1., xran=[0,viewt],xstyle=1,xtitle='time (frame)', ytitle='velocity (pixel/frame)'

cgWindow,'cgplot', tt, vp, psym=14, xtitle='Time (frame)', ytitle='velocity_pressure', xstyle=1, linestyle=2, /addcmd, charsize=1.
cgWindow,'cgtext', 0.6, 0.05, 'a: '+strtrim(result[0],2)+'  slope: '+strtrim(result[1],2),charsize=0.8,/normal, /addcmd
cgWindow,'cgplot', tt, result[0]+result[1]*tt, linestyle=3, /overplot, /addcmd

end
