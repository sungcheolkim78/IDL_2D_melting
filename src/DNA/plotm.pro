;+
;-

pro plotm, filename, overplot=overplot, color=color, psym=psym

a = readtext(filename)

e = a(0,*)*3.15
e2 = [0, 1, 2, 3, 4, 5]*3.15
v = a(1,*)/(3.75*0.06174)
std = a(2,*)/(3.75*0.06174)
ste = std/sqrt(a(3,*))

o = 0
if keyword_set(overplot) then o = 1
if not keyword_set(color) then color='grn3'
if not keyword_set(psym) then psym=14

if o eq 0 then cgplot, e, v, psym = psym, charsize=1., /window, xran=[0,5]*3.15, yran=[0,80], $
    xtitle = 'E (kV/m)', ytitle='Vel (um/s)', xstyle=1 $
    else cgplot, e, v, psym=psym, /window, /addcmd, /overplot

pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 2)
pi(0).fixed = 1

fit = mpfitexpr('P[0]+P[1]*X', e, v, std, [0.,3.], bestnorm=chisq, covar=cov, parinfo=pi)
print, sqrt(cov)

cgplot, e2, fit[0]+fit[1]*e2, /addcmd, /overplot, color=color,linestyle=2

cgwindow, 'oploterror', e, v, std, /addcmd, psym=3, errcolor=fsc_color('blu6')

end
