;+
; Name: i_dft
; Purpose: discrete fourier transformation
; Input: i_dft, x
; History: created by sungcheol kim, 12/5/11
;-

function i_dft, x

nx = n_elements(x)

for i=0,nx-1 do begin
    result[i] = 0
    arg = 2.*!pi*double(i)/double(nx)
    for j=0,nx-1 do begin

