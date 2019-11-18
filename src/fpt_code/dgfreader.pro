;+
; Name: dgfreader
; Purpose: show the dependence of gaussian fit over time
; Input: dgfreader, dgf
; History: created by sungcheol kim, 12/07/11
;          modifed by sungcheol kim, 12/13/11 - diffusivegaussian function gives different data set
;-

;----------------------------------------
function dgf_plotD, dgf, velo=velo, start=start, color=color, maxd=maxd

x = [0, 1,3, 5, transpose(dgf[0,*])]

if keyword_set(start) then cgWindow, 'cgplot', dgf[0,*], dgf[1,*], charsize=1., $
    psym=14, xran=[0,max(dgf[0,*])], color=color, yran=[0,maxd], $
    xstyle=1, wmulti=[0,1,2], xtitle='Time (frame)', ytitle='D (pixsels^2/frame)' $
    else cgWindow, 'cgplot', dgf[0,*], dgf[1,*], /over, /addcmd, psym=14, color=color

;fit = mpfitexpr('P[0]+P[1]*X', dgf[0,*], dgf[2,*], error, [0.7, 0.1])
fit = linfit(dgf[0,*],dgf[1,*],chisqr=chi)
cgWindow, 'cgplot', /over, x, fit[0]+fit[1]*x, linestyle=3, /addcmd, color=color

dy = !y.crange(1)-!y.crange(0)
dx = !x.crange(1)-!x.crange(0)
xx = !x.crange(0)
yy = !y.crange(0)

cgWindow, 'cgtext', xx+dx*0.70,fit[0]+fit[1]*(xx+dx*0.70)-dy*0.05, 'Slope: '+strtrim(fit[1],2), /addcmd, charsize=1
cgWindow, 'cgtext', xx+dx*0.70,fit[0]+fit[1]*(xx+dx*0.70)-dy*0.10, 'y0: '+strtrim(fit[0],2), /addcmd, charsize=1

return, fit[0]

end

;----------------------------------------
function dgf_plotV, dgf, velo=velo, start=start, maxv=maxv, color=color

x = [0.5,1,2,3,4,5, transpose(dgf[0,*])]

if keyword_set(start) then cgWindow, 'cgplot', dgf[0,*], dgf[3,*], charsize=1., $
    /addcmd, psym=14, xran=[0,max(dgf[0,*])], yran=[0,maxv], color=color, $
    xstyle=1, /ynozero, xtitle='Time (frame)', ytitle='V (pixels/frame)' $ 
    else cgWindow, 'cgplot', dgf[0,*], dgf[3,*], /over, /addcmd, psym=14, color=color

if not keyword_set(velo) then velo = 4.0
;fit = mpfitexpr('P[0]*exp(-P[1]*X)+P[2]', dgf[0,*], dgf[3,*], error, [velo, 0.1, velo])
fit = linfit(dgf[0,*],dgf[3,*],chisqr=chi)
;cgWindow, 'cgplot', /over, x, fit[0]*exp(-fit[1]*x)+fit[2], linestyle=3, /addcmd, color=color
cgWindow, 'cgplot', /over, x, fit[0]+fit[1]*x, linestyle=3, /addcmd, color=color

dy = !y.crange(1)-!y.crange(0)
dx = !x.crange(1)-!x.crange(0)
xx = !x.crange(0)
yy = !y.crange(0)

cgWindow, 'cgtext', xx+dx*0.70,fit[0]-dy*0.05, 'V0: '+strtrim(fit[0],2), /addcmd, charsize=1
cgWindow, 'cgtext', xx+dx*0.70,fit[0]-dy*0.10, 'a: '+strtrim(fit[1],2), /addcmd, charsize=1
;cgWindow, 'cgtext', xx+dx*0.70,fit[2]-dy*0.15, 'V: '+strtrim(fit[2],2), /addcmd, charsize=1

return, fit[0]

end

; ---------------------------------
pro dgfreader, filename, velo=velo, maxv=maxv, maxd=maxd

;fn = file_search(filename,/fully_qualify_path, count=fc)
fn = file_search(filename, count=fc)

print, fn

cn = indgen(fc)
colorlist = 'red'+strtrim(cn+1,2)
d = fltarr(fc)
v = fltarr(fc)

if not keyword_set(maxd) then maxd = 2.
dgf = read_gdf(fn[0])
d[0] = dgf_plotD( dgf, velo=velo, /start, color=colorlist[0], maxd=maxd)

if fc gt 1 then begin
    for i=1, fc-1 do begin
        dgf = read_gdf(fn[i])
        d[i] = dgf_plotD( dgf, velo=velo, color=colorlist[i], maxd=maxd)
    endfor
endif
cgWindow,'al_legend', fn+' - '+strtrim(d,2), colors=colorlist, /addcmd, psym=intarr(fc)+14

if not keyword_set(maxv) then maxv = 5.

dgf = read_gdf(fn[0])
v[0] = dgf_plotV( dgf, velo=velo, /start, maxv=maxv, color=colorlist[0])

if fc gt 1 then begin
    for i=1, fc-1 do begin
        dgf = read_gdf(fn[i])
        v[i] = dgf_plotV( dgf, velo=velo, color=colorlist[i])
    endfor
endif
cgWindow,'al_legend', fn+' - '+strtrim(v,2), colors=colorlist, /addcmd, /bottom, psym=intarr(fc)+14

end
