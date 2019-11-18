;+
; Name: diffusivegaussian
; Purpose: plot diffusive gaussian distribution on time (frame)
; Input: diffusivegaussian, filename, frames
; History: created by sungcheol kim, 11/19/11
;          modifiey by sungcheol kim, 12/01/12 - add save function
;          modifiey by sungcheol kim, 2/3/12 - change to use gaussfit function
;-

pro dg, filename, frames, nbins=nbins, velo=velo, $
    data=data, prefix = prefix, binsize=binsize, overplot=overplot

tpt = read_gdf(filename)
maxf = max(tpt(1,0,*))

s = n_elements(frames)
if s eq 3 then begin
    ntrials = fix((frames[2]-frames[0])/frames[1])
endif else ntrials = 12

f = frames[1]*indgen(ntrials)+frames[0]
result = fltarr(5,n_elements(f))

if not keyword_set(binsize) then binsize = 0.5
if not keyword_set(velo) then velo = 1.5

fit = [0, 0, 0, 0]
if keyword_set(overplot) then $
    yfit = pdf_gauss(tpt, f[0], fit, binsize=binsize, /quiet,/dg, velo=velo) else $
    yfit = pdf_gauss(tpt, f[0], fit, binsize=binsize, wmulti=[0,3,4],/dg, velo=velo)

result(0,0) = f[0]
result(1:4,0) = fit

for i=1,n_elements(f)-1 do begin
    if keyword_set(overplot) then $
    yfit = pdf_gauss(tpt, f[i], fit, binsize=binsize, /quiet,/dg, velo=velo) else $
    yfit = pdf_gauss(tpt, f[i], fit, binsize=binsize, /addcmd,/dg, velo=velo) 

    result(0,i) = f[i]
    result(1:4,i) = fit
endfor

print, result
fname = 'result.txt'
openw, 1, fname
printf, 1, result, format='(I3, F11.5, F11.5, F11.5, F11.5)'
close, 1

; calculate velocity and diffusion coefficient
fitv = linfit(result(0,*),result(1,*),sigma=sigma,measure_errors=result(2,*))
print, 'v: '+strtrim(fitv(0),2)+' m: '+strtrim(fitv(1),2)+' err: '+strtrim(sigma[1],2)

if not keyword_set(overplot) then $
    cgplot, result(0,*), result(1,*)*30./3.75, charsize=1., psym=14, layout=[1,2,1], yran=[-33,-3], /window , xran=[0,max(result(0,*))], xtitle='Time (1/30 sec)', ytitle='V (um/s)' else $
    cgplot, result(0,*), result(1,*)*30./3.75, charsize=1., psym=14, layout=[1,2,1], yran=[-33,-3],/addcmd, xran=[0,max(result(0,*))]
;cgplot, /overplot, result(0,*), (fitv[0]+fitv[1]*result(0,*))*30./3.75, color='red6', /addcmd

dcfit = linfit(result(0,*),result(3,*), sigma=sigma2, measure_errors=result(4,*))
print, 'D: '+strtrim(dcfit(0),2)+' m: '+strtrim(dcfit(1),2)+' err: '+strtrim(sigma2[1],2)

if not keyword_set(overplot) then $
    cgplot, result(0,*), result(3,*)*30./(3.75*3.75), charsize=1, psym=14, /addcmd, layout=[1,2,2], yran=[0,8], xran=[0, max(result(0,*))], xtitle='Time (1/30 sec)', ytitle='D (um^2/s)' else $
    cgplot, result(0,*), result(3,*)*30./(3.75*3.75), charsize=1, psym=14, /addcmd, layout=[1,2,2], yran=[0,8], xran=[0, max(result(0,*))]
;cgplot, /overplot, result(0,*), (dcfit[0]+dcfit[1]*result(0,*))*30./(3.75*3.75), color='red6', /addcmd

end
