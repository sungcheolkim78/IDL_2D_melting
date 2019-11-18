;+
; Name: c_fft
; Purpose: calcuate 2D fourier transformation and show autocorrelation of one point
; Input: c_fft, imagestack, theta, kvector
; History: created by sungcheol kim, 12/1/11
;-

pro c_fft, imagestack, theta=theta, kvector, showfft=showfft, showline=showline, radius=radius

s = size(imagestack)
n_image = s[3]
xsize = s[1]
ysize = s[2]
result = fltarr(n_image)

kx = kvector[0]*cos(kvector[1]*!pi/180.)
ky = kvector[0]*sin(kvector[1]*!pi/180.)
print, kx, ky

for i=0,n_image-1 do begin
    a0 = imagestack(*,*,i)
    temp = 255b-a0
    b = bpassg(temp, 1, 7)
    f = fft(b)

    if keyword_set(showfft) then begin
        tvimage, alog10(abs(f)^2)
    endif

    if keyword_set(showline) then begin
        if kvector[1] gt 45 then begin
            y = indgen((xsize<ysize)/4)
            x = float(y)*kx/ky
        endif else begin
            x = indgen((xsize<ysize)/4)
            y = float(x)*ky/kx
        endelse
        r = sqrt(x^2+y^2)
        cgplot, r, alog(abs(f(x,y))^2)
    endif

    if keyword_set(radius) then begin
        res = 0
        for j=-radius,radius do for k=-radius,radius do res += f(kx+j,ky+k)
        result(i) = res/(2*radius+1)^2
    endif else result(i) = f(kx,ky)*conj(f(kx,ky))
    print, result(i)
endfor

lag = indgen(n_image/10)
ac = a_correlate(result, lag)
fit = mpfitexpr('exp(-P[0]*X)',lag, ac, rerror, [1.0])

cgWindow,'cgplot',lag, ac, psym=15, wmulti=[0,1,2], charsize=1., xtitle='lag (frame)', ytitle='Autocorrelation', xran=[0,n_image/10], xstyle=1
cgWindow,'cgplots', lag, exp(-fit[0]*lag), linestyle=3, /addcmd
cgWindow,'cgtext', 1,0.1, '1/tau = '+strtrim(fit[0],2), charsize=1., /addcmd

cgWindow,'cgplot',indgen(n_image-1),result, /addcmd, charsize=1., xtitle='Time (frame)', ytitle='Intensity', xstyle=1

end
