;+
; Name: i_mergetpt
; Purpose: merge two tpt file and return results
; Input: i_mergetpt, tpt1, tpt2
; History: created by sungcheol kim, 11/7/11
;-

function i_mergetpt, tpt1, tpt2

s1 = size(tpt1)
s2 = size(tpt2)

t2 = s1[2] > s2[2]
t3 = s1[3] + s2[3]

result = fltarr(2,t2,t3)

result(*,0:s1[2]-1,0:s1[3]-1) = tpt1
result(*,0:s2[2]-1,s1[3]:*) = tpt2

return, result

end
