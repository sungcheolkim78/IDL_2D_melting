;+
; Name: powerspectrum
; Purpose: show power spectrum of 1D signal
; Input: powerspectrum, y
; History: created by sungcheol kim, 12/5/11
;-

pro powerspectrum, y, _extra=_extra

compile_opt idl2

on_error,2 

N = n_elements(y)
delt = 2.*!pi/float(N)

v = fft(y,-1)
f = findgen(N/2+1)*(delt)
cgplot, f, abs(v[0:N/2])^2, ytitle='Power Spectrum', /ylog, xtitle='Frequency', xstyle=1, _extra=_extra

end
