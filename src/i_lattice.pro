;+
; Name: i_lattice
; Purpose: calculate the angle of lattice
; Input: i_lattice, ptc
; History:
;   created on 8/26/11 by SCK
;-

pro i_lattice, pt, frame

ptc = eclip(pt,[5,frame,frame])

triangulate, ptc(0,*), ptc(1,*), tr, con=con

result = 0
npc = n_elements(ptc(0,*))
nnn = intarr(npc)
nnc = intarr(npc)
for j=0,npc-1 do nnn(j) = n_elements(con[con[j]:con[j+1]-1])

w6 = where(nnn eq 6, w6c)

for i=0,w6c-1 do begin
    nearp = con[con[w6(i)]:con[w6(i)+1]-1]
    nearpn = n_elements(nearp)
    for j=0,nearpn-1 do begin
;        if nnc(nearp(j)) eq 0 then begin
            dy = ptc(1,w6(i))-ptc(1,nearp(j))
            dx = ptc(0,w6(i))-ptc(0,nearp(j))
            theta = atan(dy,dx)
            result = [result, theta]
            nnc(nearp(j)) = 1
;        endif
    endfor
endfor

wtheta = where(result gt 0 and result lt !pi/3.)

print, mean(result(wtheta))*180./!pi
ph = histogram(result(1:*),min=-!pi,max=!pi,nbins=120)
cgplot, /polar, ph, findgen(120)/120.*2*!pi-!pi, charsize=1.0

end
