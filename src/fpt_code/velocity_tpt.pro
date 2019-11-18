;+
; Name: velocity_tpt
; Purpose: show the velocity over time
; Input: velocity_tpt, filename
; History: created by sungcheol kim, 2/6/12
;-

pro velocity_tpt, filename, maxtime=maxtime

tpt = read_gdf(filename)
ntracks = n_elements(tpt(0,0,*))
if not keyword_set(maxtime) then maxtime = min(tpt(1,0,*))

velarr = fltarr(ntracks,maxtime)

for i=0,ntracks-1 do begin
    tmax = tpt(1,0,i)
    if tmax gt maxtime then begin
        dx = tpt(1,2:tmax-1,i)-tpt(1,1:tmax,i)
        velarr(i,*) = dx(0:maxtime-1)
        ;print, max(velarr(i,*)), min(velarr(i,*))
    endif
endfor

t = indgen(maxtime)
cgplot, t, velarr(0,*), charsize=1., yran=[min(velarr),max(velarr)]
for i=1,ntracks-1 do cgplots, t, velarr(i,*)

vy = fltarr(maxtime)
for i=0,maxtime-1 do vy(i) = mean(velarr(*,i))
cgplots, t, vy, color='red6', psym=14

fit = linfit(t, vy, sigma=sigma)
print, fit, sigma

end
