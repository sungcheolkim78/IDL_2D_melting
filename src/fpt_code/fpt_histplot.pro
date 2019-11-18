;+
; Name: fpt_histplot
; Purpose:
; Input:
; History: seperated from fpt.pro function by sungcheol kim, 1/23/12
;-


function fpt_value, X, P
    return, (P[0]+P[2]*X)/sqrt(16.*!pi*P[1]*X^3)*exp(-(P[0]-P[2]*X)^2/(4.*P[1]*X))
end

function fpt_value1, X, P
    return, (P[0])/sqrt(4.*!pi*P[1]*X^3)*exp(-(P[0]-P[2]*X)^2/(4.*P[1]*X))
end

pro fpt_histplot, data, fit, binsize=binsize, length, velo=velo, option=option,$
    _extra=_extra,time=time,color=color, quiet=quiet, nbins=nbins

    if not keyword_set(color) then color = 'red6'
    if not keyword_set(option) then option = 1

    pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)

    if keyword_set(binsize) then begin
        nbins = 1 + (max(data)-min(data))/binsize
    endif
    if keyword_set(nbins) then begin
        binsize = (max(data)-min(data))/(nbins-1)
    endif

    print, mean(data)
    print, stddev(data)^2
    h = histogram(data,binsize=binsize,locations=t)
    Ndx = total(h)*binsize
 
    pi(0).fixed = 1
    ;pi(0).limited = [1,1]
    ;pi(0).limits = [length-0.1,length+0.1]

    if option eq 0 then fit = mpfitfun('fpt_value', t+binsize/2., h/Ndx, error, [length,0.7,velo],/weight, parinfo=pi,bestnorm=chisq,/quiet, covar=cov)
    if option eq 1 then fit = mpfitfun('fpt_value1', t+binsize/2., h/Ndx, error, [length,0.7,velo],/weight,parinfo=pi,bestnorm=chisq,/quiet, covar=cov)

    if keyword_set(time) then multiplier = time else multiplier = 1.
    
    if not keyword_set(quiet) then begin
        cgplot, t*multiplier, h/Ndx, charsize=1., psym=10, _extra=_extra, xstyle=1.
        if option eq 0 then cgplots, t*multiplier, fpt_value(t+binsize/2.,fit), linestyle=2, /addcmd, /window, noclip=0, color=color
        if option eq 1 then cgplots, t*multiplier, fpt_value1(t+binsize/2.,fit), linestyle=2,/addcmd, /window, noclip=0, color=color

        dx = !x.crange(1)-!x.crange(0)
        dy = !y.crange(1)-!y.crange(0)
        xx = !x.crange(0)
        yy = !y.crange(0)
        cgtext, xx+0.65*dx, yy+0.90*dy, 'L: '+strcompress(string(fit[0],format='(g9.4)')),       charsize=0.9, alignment=0.4, /addcmd
        cgtext, xx+0.65*dx, yy+0.82*dy, 'D: '+strcompress(string(fit[1],format='(g9.4)')),       charsize=0.9, alignment=0.4, /addcmd
        cgtext, xx+0.65*dx, yy+0.74*dy, 'v: '+strcompress(string(fit[2],format='(g9.4)')),       charsize=0.9, alignment=0.4, /addcmd
    endif

    fit = [fit, chisq]
    print, fit, sqrt(cov)
end
