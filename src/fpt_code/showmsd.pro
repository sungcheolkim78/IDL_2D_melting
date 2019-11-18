;+
; Name: showmsd
;
;
;-

function add_zero, x
    return, [[0],[x]]
end

pro showmsd, filename, dis=dis, theta=theta, _extra=_extra, ywin=ywin

pt = read_gdf(filename)
if not keyword_set(dis) then dis = 20
if keyword_set(theta) then temp = i_rotate(pt, theta) else temp = pt
if keyword_set(ywin) then temp = eclip(temp,[1,ywin(0),ywin(1)])

tt = track(temp, dis, good=10, memory=10)
m = msd(tt,/quiet,mydts=[1,2,4,8,16,32,64],micperpix=1/3.75,timestep=0.0333)

fitv1 = linfit(m(0,*),m(1,*), sigma=sigma)
;fitd1 = mpfitexpr('2.*P[0]*X^P[1]',m(0,*),m(3,*),error,[0.5,0.8],covar=cov,/weight,/quiet)
fitd1 = linfit(m(0,*),m(3,*))

fitv2 = linfit(m(0,*),m(2,*), sigma=sigma)
;fitd2 = mpfitexpr('2.*P[0]*X^P[1]',m(0,*),m(4,*),error,[0.5,1.1],covar=cov,/weight,/quiet)
fitd2 = linfit(m(0,*),m(4,*))

t = add_zero(m(0,*))
cgplot, add_zero(m(0,*)), add_zero(m(1,*)), charsize=1., psym=14, ytitle='<x>', $
    _extra=_extra, /window, layout=[2,2,1]
cgplots, t, fitv1[0]+fitv1[1]*t, color='red6', noclip=0, /addcmd
cgplot, add_zero(m(0,*)), add_zero(m(2,*)), charsize=1., psym=14, ytitle='<y>', $
    _extra=_extra, /addcmd,layout=[2,2,2]
cgplots, t, fitv2[0]+fitv2[1]*t, color='red6', noclip=0, /addcmd
cgplot, add_zero(m(0,*)), add_zero(m(3,*)), charsize=1., psym=14, ytitle='<dx^2>',$
    _extra=_extra, /addcmd,layout=[2,2,3]
cgplots, t, fitd1[0]+fitd1[1]*t, color='red6', noclip=0, /addcmd
cgplot, add_zero(m(0,*)), add_zero(m(4,*)), charsize=1., psym=14, ytitle='<dy^2>',$
    _extra=_extra, /addcmd,layout=[2,2,4]
cgplots, t, fitd2[0]+fitd2[1]*t, color='red6', noclip=0, /addcmd

print, fitv1
print, fitd1/2.
print, fitv2
print, fitd2*(3.75*3.75/30)/2.
print, fitd2/2.

end
