;+
;-

pro s_plotl

a1 = read_gdf('H33-d1v.avi_0.sav')
a2 = read_gdf('H33-d2v2.avi_0.sav')
t = findgen(50)*0.06174
ma1 = mean(a1(3,*))/3.75
ma2 = mean(a2(3,*))/3.75
print, ma1, ma2

cgplot,t,a1(3,*)/3.75, /window, psym=-14, color='red3', xran=[0,50]*0.06174, $
    yran=[0,14], xtitle='Time (sec)', ytitle='Length (um)',xstyle=1, $
    symcolor='black', charsize=1.

cgplot,t,a2(3,*)/3.75, /window, psym=-17, color='blu3', /overplot, $
    symcolor='black'

cgplot,[0,50]*0.06174,[ma1,ma1], color='red3', linestyle=2, /window, /overplot
cgplot,[0,50]*0.06174,[ma2,ma2], color='blu3', linestyle=2, /window, /overplot

cgwindow,'al_legend', ['1v', '2v'], psym=[14,17],colors=['red3','blu3'], /addcmd

end
