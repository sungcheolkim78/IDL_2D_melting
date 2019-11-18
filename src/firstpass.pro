;Purpose: to show the analytical solution for first passage time
;Input: length= channel length
;       velo= drift velocity
;       diff= diffusion constant
;       div= smallest division of plotting
;       default setting is roughly based on our experimental data.
;History: created on 10/06/11

pro firstpass, length=length, velo=velo, diff=diff, div=div

on_error,2

if not keyword_set(length) then length=50
if not keyword_set(velo) then velo=1
if not keyword_set(diff) then diff=1
if not keyword_set(div) then div=50

a=length/(sqrt(4*3.14*diff))
b=float(1/velo)

t= float((indgen(b*div*130)+1)/div)
p= a*exp((-(length-velo*t)^2)/t/4/diff)/(sqrt(t^3))

plot, t, p, xtitle='time', ytitle='probability of first passage'

end
