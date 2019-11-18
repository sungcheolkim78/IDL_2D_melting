;+
;-

pro s_plotl2

a1 = read_gdf('H62-d2v.avi_3.sav')
a2 = read_gdf('H62-d3v.avi_2.sav')
a3 = read_gdf('H62-d4v2.avi_4.sav')
t = (findgen(20)+0.0)*0.06174
ma1 = mean(a1(3,*))/3.75
ma2 = mean(a2(3,*))/3.75
ma3 = mean(a3(3,*))/3.75
print, ma1, ma2, ma3

cgplot,t,a1(3,*)/3.75, /window, psym=-14, color='red3', xran=[0,20]*0.06174, $
    yran=[0,5], xtitle='Time (sec)', ytitle='Length (um)',xstyle=1, $
    symcolor='black', charsize=1.

cgplot,t,a2(3,*)/3.75, /window, psym=-17, color='blu3', /overplot, $
    symcolor='black'

cgplot,t,a3(3,*)/3.75, /window, psym=-18, color='grn3', /overplot, $
    symcolor='black'

cgplot,[0,20]*0.06174, [ma1,ma1], color='red3',linestyle=2, /window, /overplot
cgplot,[0,20]*0.06174, [ma2,ma2], color='blu3',linestyle=2, /window, /overplot
cgplot,[0,20]*0.06174, [ma3,ma3], color='grn3',linestyle=2, /window, /overplot

cgwindow,'al_legend', ['2v', '3v','4v'], psym=[14,17,18],colors=['red3','blu3','grn3'], /addcmd

end
