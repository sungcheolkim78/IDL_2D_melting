;+
; Name: fpt
; Purpose: calculate first passage time and show histogram
; Input: fpt, tpt, length
; History: created by sungcheol kim at 11/06/11
;          revised to use pptu data (y,track) by sungcheol kim, 11/20/11
;          modified to use multi values from one track, 12/01/18
;          modified to make overplot graph, 02/23/12
;-

pro fpt, filename, length, tmax = tmax, nbins=nbins, velo=velo, option=option,$
    overplot=overplot, color=color, psym=psym, dmax=dmax, ntrial=ntrial

tpt = read_gdf(filename)
if not keyword_set(nbins) then nbins=40

nt = n_elements(tpt(0,*))
temp = tpt

if n_elements(length) ne 2 then begin
    print, 'Usage: fpt, tpt, [1,2]'
    return
endif

if not keyword_set(ntrial) then ntrial = 10
trial = indgen(ntrial)*length[1]+length[0]
if not keyword_set(tmax) then tmax = max(temp(0,*))
if not keyword_set(velo) then velo = 4.0
if not keyword_set(option) then option = 1

tfit = fltarr(4,ntrial)
fit = [0,0,0]

fpt_histplot, t_fpt(temp,trial[0]), fit, nbins=nbins, trial[0], $
    wmulti=[0,3,4], velo=velo, option=option,/window,/quiet
tfit(*,0) = fit

for j=1,ntrial-1 do begin
    fpt_histplot, t_fpt(temp,trial[j]), fit, nbins=nbins, $
        trial[j] ,/addcmd , velo=velo, option=option, /window, /quiet
    tfit(*,j) = fit
endfor

;print, tfit
fname = 'result.txt'
openw, 1, fname
printf, 1, tfit, format='(I3, F11.5, F11.5, F11.5)'
close, 1

if not keyword_set(psym) then psym=14
if not keyword_set(color) then color='red6'
if not keyword_set(dmax) then dmax=4.

lengths = tfit(0,*)/3.75
dvalue = tfit(1,*)*30./(3.75*3.75)
;fitv = linfit
if keyword_set(overplot) then $
    cgplot, tfit(0,*)/3.75, tfit(2,*)*30./3.75, psym=-psym, charsize=1.,$
        /addcmd,layout=[1,2,1], linestyle=2, symcolor='blk7', xran=[0,max(lengths)], $
        yran=[0,32], xtitle ='Length (um)', ytitle='v* (um/s)', color=color  else $
    cgplot, tfit(0,*)/3.75, tfit(2,*)*30./3.75, psym=-psym, charsize=1.,$
        /window,layout=[1,2,1], linestyle=2, symcolor='blk7', xran=[0,max(lengths)], $
        yran=[0,32], xtitle ='Length (um)', ytitle='v* (um/s)',color=color

if keyword_set(overplot) then $
    cgplot, lengths, dvalue, psym=psym, charsize=1.,$
        /addcmd,layout=[1,2,2], linestyle=2, color=color,symcolor='blk7', xran=[0,max(lengths)], $
        yran=[0,dmax], xtitle='Length (um)', ytitle='D* (um2/s)' else $
    cgplot, lengths, dvalue, psym=psym, charsize=1.,$
        /addcmd,layout=[1,2,2],linestyle=2, color=color,symcolor='blk7',   $
        yran=[0,dmax], xtitle='Length (um)', ytitle='D* (um2/s)', xran=[0,max(lengths)]

; calculate velocity and diffusion coefficient
fitd = mpfitexpr('P[0]+P[1]*(1.-exp(-P[2]*X))', lengths, dvalue,err,$
    [1.0, 2.5,4.],/weight)
lengths2 = [0, 1, 2, transpose(lengths)]
cgplot, /addcmd, /window, lengths2, fitd[0]+fitd[1]*(1.-exp(-fitd[2]*lengths2)), /overplot, $
    linestyle=2, color='red6'

print, 'D0: '+strtrim(fitd[0],2)+' D*: '+strtrim(fitd[0]+fitd[1],2)
print, 'v: '+strtrim(mean(tfit(2,*))*30./3.75,2)+' +/- '+strtrim(stddev(tfit(2,*))*30./3.75,2)
print, 'min(D): '+strtrim(min(dvalue),2)+' max(D): '+strtrim(max(dvalue),2)

end
