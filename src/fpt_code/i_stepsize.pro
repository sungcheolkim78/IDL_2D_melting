;+
; Name: i_stepsize
; Purpose: calcualte the step size distribution from tpt file
; Inpute, i_stepsize, tpt
; History: created by sungcheol kim, 2/9/12
;-

pro i_stepsize, tpt, option=option, start=start

if not keyword_set(option) then option = 0
if not keyword_set(start) then start=3

ntracks = n_elements(tpt(0,0,*))
result = 0

for i=0,ntracks-1 do begin
    tl = tpt(0,0,i)

    x = tpt(0,1:tl,i)
    y = tpt(1,1:tl,i)

    dx = x(1:tl-1)-x(0:tl-2)
    dy = y(1:tl-1)-y(0:tl-2)
    dr = sqrt(dx^2 + dy^2)

    case option of
        0: result = [result, dr]
        1: result = [result, abs(dy)]
        2: result = [result, abs(dx)]
    endcase
endfor

nbins=30
binsize = (max(result)-min(result))/(1.+nbins)
result = result(1:*)
h = histogram(result, binsize=binsize,locations=hx)
Ndx = total(h)*binsize

fit = mpfitexpr('P[0]*X^(-P[1])', hx(start:*), h(start:*)/Ndx, error, [0.3,3.], /weight)

!p.multi=[0,1,1]
cgplot, hx, h/Ndx, psym=10, charsize=1.,/window
cgplot, hx, fit[0]*hx^(-fit[1]), linestyle=2, color='red6', /overplot, /addcmd
cgplots,[hx(start),hx(start)],[0,h(start)/Ndx],noclip=0, color='grn6',/addcmd
cgplots,[mean(result),mean(result)],[0,1],noclip=0, color='blu6',/addcmd

print, fit

; calculate diffusion constant
r2 = result^2
print, '<l> = '+strtrim(mean(result),2)
print, '<l^2> = '+strtrim(mean(result^2),2)
print, 'D = '+strtrim((mean(r2)-mean(result)^2)/2.,2)

end
