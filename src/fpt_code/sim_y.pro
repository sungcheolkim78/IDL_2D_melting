;+
; Name: sim_y
; Purpose: simulate y value with random fluctuation
; Input: sim_y, vel, total=total
; History: created by sungcheol kim, 12/13/11
;-

function sim_y, velo, totali=totali, jitter=jitter, totalf=totalf, a=a

if not keyword_set(totali) then totali=100
if not keyword_set(jitter) then jitter=3.5
if not keyword_set(totalf) then totalf=100
if not keyword_set(a) then a=0.

y = fltarr(2,totali,totalf)

for i=0,totalf-1 do begin
;    s = systime(1)
    velocity = velo+randomu(s,totali,/normal)*jitter - velo*a*indgen(totali)
    for j=2,totali-1 do y(1,j,i) = total(velocity(0:j-1))
    y(1,0,i) = totali-1
endfor

plot, y(1,1:*,0)
for i=1,totalf-1 do plots, indgen(99), y(1,1:*,i)

return, y

end
