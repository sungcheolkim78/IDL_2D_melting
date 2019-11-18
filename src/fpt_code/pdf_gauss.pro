;+
; Name: pdf_gauss
; Purpose: calculate probability density function and gaussian fitting
; Input: pdf_gauss, tpt, binsize=binsize
; History: created by sungcheol kim, 2/3/12
;-

function dg_value, X, P
    return, exp(-(X-P[0]*P[2])^2/(4.*P[1]*P[2]))/sqrt(4.*!pi*P[1]*P[2])
end

function pdf_gauss, tpt, time, fit, binsize=binsize, nbins=nbins, dg=dg, _extra=_extra, velo=velo, quiet=quiet

x = i_coordinate(tpt, time)

if keyword_set(binsize) then begin
    nbins = 1+(max(x)-min(x))/binsize
endif else begin
    if keyword_set(nbins) then binsize = (max(x)-min(x))/(nbins+1.)
endelse

h = histogram(x, binsize=binsize, locations=hx)
pdf = h/(total(h)*binsize)

;error = fltarr(nbins)
;for j=0,n_elements(hx)-1 do begin
;    w = where((x ge hx(j)) and (x lt hx(j)+binsize), wc)
;    error(j) = stddev(x(w))/sqrt(total(h)*binsize)
;endfor

if keyword_set(dg) then begin
    pi = replicate({fixed:0, limited:[0,0], limits:[0.D, 0.D]},3)
    pi(2).fixed = 1

    ;pi(2).limited = [1,1]
    ;pi(2).limits = [time-0.9,time+0.9]

    coeff = mpfitfun('dg_value',hx+binsize/2.,pdf,error,[velo,1.0,time], covar=cov ,PARINFO=pi,/weight)
    yfit = dg_value(hx+binsize/2.,coeff)
    coeff = [coeff(2), coeff(0), coeff(1)]
    sigma = [sqrt(cov(2,2)), sqrt(cov(0,0)), sqrt(cov(1,1))]
    ;sigma = [0, 0, 0]
endif else begin
    yfit = gaussfit(hx+binsize/2., pdf, coeff, sigma=sigma, nterms=3)
endelse
myfit = max(yfit)

meanx = mean(x)
std = stddev(x)

if not keyword_set(quiet) then begin
    cgplot, hx, pdf, charsize=1.,yran=[0,myfit], _extra=_extra, /window, psym=10, $
        xran=[meanx-3.*std,meanx+3.*std], xstyle=1.
    cgplots, hx, yfit, color='red6', linestyle=2, /addcmd
endif

fit = [coeff(1), sigma(1), coeff(2), sigma(2)]
;print, fit

if not keyword_set(dg) then begin
    cgplots, [coeff(1),coeff(1)],[0,myfit], color='blu5', /addcmd
    cgplots, [coeff(1),coeff(1)]-coeff(2),[0,myfit], color='blu5', /addcmd
    cgplots, [coeff(1),coeff(1)]+coeff(2),[0,myfit], color='blu5', /addcmd
endif
if not keyword_set(quiet) then begin
    cgplots, [mean(x),mean(x)],[0,myfit], color='grn6', linestyle=2, /addcmd
    cgplots, [mean(x),mean(x)]-stddev(x),[0,myfit], color='grn6', linestyle=2, /addcmd
    cgplots, [mean(x),mean(x)]+stddev(x),[0,myfit], color='grn6', linestyle=2, /addcmd
endif

result = fltarr(2,n_elements(hx))
result(0,*) = hx
result(1,*) = h
return, result

end

