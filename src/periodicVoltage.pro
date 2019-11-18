;+
; Name: periodicVoltage
; Purpose: make voltage signal by peak points
; Input: periodicVoltage, startf, stopf, peaks
;-

function periodicVoltage, vol, startf, stopf, peaks, $
	shape=shape, up=up, down=down, verbose=verbose
on_error,2

if not keyword_set(shape) then shape='tri'
initial = -1.
if keyword_set(up) then initial = 1.
if keyword_set(down) then initial = -1.

mn = n_elements(peaks)-1
if mn le 0 then begin
	message, 'need more peaks', /info
	return, 0
endif

marr = fltarr(mn)
for i=0, mn-1 do marr(i) = 2.*vol/(peaks(i+1)-peaks(i))
mavr = mean(marr)

t = indgen(stopf-startf+1)+startf
result = float(t)

; before first peak
result(0:peaks(0)-startf) = initial*mavr*(t(0:peaks(0)-startf)-peaks(0)+startf)+$
	initial*vol
; between peaks
for i=0,mn-1 do begin
	initial *= -1.
	result(peaks(i)-startf+1:peaks(i+1)-startf) = $
		initial*marr(i)*(t(peaks(i)-startf+1:peaks(i+1)-startf)-peaks(i+1)+startf)+$
		initial*vol
endfor
; before last frame
initial*= -1.
result(peaks(mn)-startf+1:stopf) = initial*mavr*(t(peaks(mn)-startf+1:stopf)-$
	peaks(mn)+startf)-initial*vol

if keyword_set(verbose) then fsc_plot,t,result, ystyle=2,psym=-14

return, result

end
