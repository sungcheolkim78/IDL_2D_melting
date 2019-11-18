;+
; Name: randomws
; Purpose: obtain a matrix of certain amount of 1D random walkers
; Input: randomws, amounts, steps, length
; 
; History:
;     created by Lichao Yu  8/04/11 different from original random pro.
;              solved the problem that using the same systime leads to same random chain
;-




function randomws, amounts, steps, length
on_error,2

if n_params() eq 2 then a = 1
if n_params() eq 3 then a = length
s=randomu(systime(1),steps*amounts)
result = intarr(amounts, steps)

for j=0, steps-1 do begin
    for i=0, amounts-1 do begin
        p = round(s(i+j))*2-1
        result(i,j)= result(i,j-1)+a*p
    endfor
endfor

return, result

end