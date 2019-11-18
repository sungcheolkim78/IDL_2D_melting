;+
; Name: showonetrack
; Purpose: show one track from tpt file
; Input: showonetrack, tptfilename, tracknumber
; History: created by sungcheol kim, 2/2/12
;-

pro showonetrack, tptfilename, tracknumber

if size(tptfilename,/type) eq 7 then tpt = read_gdf(tptfilename) else tpt=tptfilename

maxt = n_elements(tpt(0,0,*))
if tracknumber gt maxt-1 then begin
    print, 'out of range: tracknumber'
    return
endif

tl = tpt(0,0,tracknumber)

if tl ne tpt(1,0,tracknumber) then begin
    print, 'error truncation!'
    tl = tpt(1,0,tracknumber)
endif

x = tpt(0,1:tl,tracknumber)
y = tpt(1,1:tl,tracknumber)
x = x - mean(x)
x = x/3.75
y = y/3.75

cgplot, x, y, charsize=1., yran=[30,512]/3.75, xran=[-1,1], psym=-14, color='blk6' $
    , ystyle=1, xstyle=1, symcolor='blk7'
cgplots, [0.5,0.5], [30,512]/3.75, color='red6',linestyle=2
cgplots, [-0.5,-0.5], [30,512]/3.75, color='red6',linestyle=2

print, mean(x), stddev(x)

wx1 = where(x lt -0.5, wxc1)
wx2 = where(x gt 0.5, wxc2)
nx = n_elements(x)

print, wxc1, wxc2, nx
print, (wxc1+wxc2)/float(nx)*100.

end
