;+
; Name: randomwalker
; Purpose: time trace of 1D random walker
; Input: randomwalker, N
;-

function randomwalker, N, length, seed=seed
on_error,2

if n_params() eq 1 then a = 1
if n_params() eq 2 then a = length

result = intarr(N)
if keyword_set(seed) then s = seed else s = systime(1)
p = round(randomu(s,N))*2-1

for i=1, N-1 do result(i) = result(i-1) + a*p(i)

return, result

end
