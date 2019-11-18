;+
; Name: tptviewer
; Purpose: show original data of all tracks in tpt file
; Input: tptviewer, tpt
; History: created by sungcheol kim, 2/7/12
;-

pro tptviewer, tptfilename

tpt = read_gdf(tptfilename)

ntracks = n_elements(tpt(0,0,*))

tmax = max(tpt(0,0,*))
ymax = max(tpt(1,*,*))
ymin = min(tpt(1,*,*))

cgplot, indgen(tmax), /nodata, /window, charsize=1., yran=[ymin,ymax],$
    layout=[1,2,1], /ynozero, xstyle=1

for i=0,ntracks-1 do begin
    tl = tpt(0,0,i)
    cgplots, indgen(tl), tpt(1,1:tl,i) , /addcmd
endfor


cgplot, indgen(tmax), /nodata, /window, charsize=1., yran=[-8,8],$
    layout=[1,2,2], /addcmd, xstyle=1

for i=0,ntracks-1 do begin
    tl = tpt(0,0,i)
    cgplots, indgen(tl), tpt(1,2:tl,i)-tpt(1,1:tl-1,i) , /addcmd
endfor

end
