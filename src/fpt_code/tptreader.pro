;+
; Name: tptreader
; Purpose: show track, velocity, autocorrelation, powerspectrum of one track
; Input: tptreader, tpt
; History: created by sungcheol kim, 12/5/11
;-

pro tptreader, tpt, track=track, twindow=twindow

if not keyword_set(track) then track=0
if n_elements(twindow) eq 2 then begin
    y = tpt(1,twindow[0]:twindow[1],track) 
    ny = twindow[1]-twindow[0]+1
endif else begin
    y = tpt(1,*,track)
    ny = y(0)
endelse

if ny eq 0 then begin
    print, 'Track length is zero! - '+strtrim(track,2)
    return
endif

t = indgen(ny)
lag = indgen(ny/5)
dy = y(2:*)-y(1:ny-2)
ddy = dy(1:*) - dy(0:ny-3)
ay = i_acorrelate(y, lag,/static)
ady = i_acorrelate(dy, lag,/static)

cgWindow,'cgplot', t, y(1:*), charsize=1., wmulti=[0,2,3], xstyle=1, xtitle='Time (frame)', ytitle='Y (pixels)'
cgWindow,'cgplot', t[0:ny-2], dy, charsize=1., /addcmd , xstyle=1, xtitle='Time (frame)', ytitle='dy/dt (pixels/frame)'
cgWindow,'cgplot', ddy, charsize=1., /addcmd, xstyle=1, xtitle='Time (frame)', ytitle='d^2y/dt^2 (pixels/frame^2)'

cgWindow,'cgplot', ady, charsize=1., /addcmd, xstyle=1, xtitle='Lag (frame)', ytitle='Autocorrelation of velocity'

cgWindow, 'powerspectrum', y(1:*), /addcmd, charsize=1.
cgWindow, 'powerspectrum', dy, /addcmd, charsize=1.

end
