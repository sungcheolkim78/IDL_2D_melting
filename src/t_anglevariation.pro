;+
; Name: t_anglevariation
; Purpose: show angle changes between two particle
; Input: t_anglevariation, tt, id1, id2
;-

pro t_anglevariation, tt, id1, id2
on_error,2

infoarr = intarr(4,17)

info1 = t_infos(tt,id1)
info2 = t_infos(tt,id2)

if n_elements(info1) ne 17 or n_elements(info2) ne 17 then begin
	print, 'either one of them is not 6 n.n. point!'
	return
endif

idnear1 = info1[10]
idnear2 = info2[10]
info3 = t_infos(tt,idnear1)
info4 = t_infos(tt,idnear2)

if n_elements(info3) ne 17 or n_elements(info4) ne 17 then begin
	print, 'either one of them is not 6 n.n. point!'
	return
endif

infoarr[0,*] = info1
infoarr[1,*] = info2
infoarr[2,*] = info3
infoarr[3,*] = info4
if max(infoarr[*,16]) gt 0 then begin
	print, 'there is missing frames'
	print, infoarr[*,16]
	return
endif

tmin = max(infoarr[*,1])
tmax = min(infoarr[*,2])

ttc1 = eclip(tt,[6,id1,id1],[5,tmin,tmax])
ttc2 = eclip(tt,[6,id2,id2],[5,tmin,tmax])
ttc1n = eclip(tt,[6,idnear1,idnear1],[5,tmin,tmax])
ttc2n = eclip(tt,[6,idnear2,idnear2],[5,tmin,tmax])

rx1 = ttc1n(0,*) - ttc1(0,*)
ry1 = ttc1n(1,*) - ttc1(1,*)
rx2 = ttc2n(0,*) - ttc2(0,*)
ry2 = ttc2n(1,*) - ttc2(1,*)

!p.multi=[0,2,2]
rxmax = max([rx1,rx2],min=rxmin)
rymax = max([ry1,ry2],min=rymin)
cgplot, rx1, ry1, xran=[rxmin,rxmax], yran=[rymin,rymax], psym=3,color=fsc_color('red5')
cgplot, rx2, ry2, psym = 3, color=fsc_color('grn5'),/overplot

cgplot, tt(0,where(tt(5,*) eq tmin)), tt(1,where(tt(5,*) eq tmin)), psym=3, xstyle=1,ystyle=1
polyfill, fsc_circle(ttc1(0,0),ttc1(1,0),13), color=fsc_color('blk3')
polyfill, fsc_circle(ttc2(0,0),ttc2(1,0),13), color=fsc_color('blk3')

t = indgen(tmax-tmin+1)+tmin
cgplot, t, rx1, xstyle=1, yran=[min([rxmin,rymin]),max([rxmax,rymax])]
cgplot, t, rx2, color=fsc_color('blu4'),/overplot

cgplot, t, ry1, /overplot
cgplot, t, ry2, color=fsc_color('blu4'),/overplot

rtheta1 = atan(rx1,ry1)*180./!pi
rtheta2 = atan(rx2,ry2)*180./!pi
cgplot, s_msd(rtheta1 - rtheta2), xstyle=1

end
