;+
; Name: g6
; Purpose: calculate g6 function for one frame
; Input: g6(pt, frame, dr, rmin, rmax)
; Output: r, gr, g6r, gre, g6re
;-

function g6, pt, frame, dr=dr, rmin=rmin, rmax=rmax, option=option
on_error,2

maxf = max(pt(5,*), min=minf)
if frame lt minf or frame gt maxf then begin
	print, 'Frame is out of range: '+strtrim(minf,2)+','+strtrim(maxf,2)
	return, 0
endif

ptc = pt(*,where(pt(5,*) eq frame))
if not keyword_set(option) then option = 1
a0 = latticeconstant(ptc,-1,option=option)
phi6array = phi6arr(ptc)

if not keyword_set(dr) then dr = 0.1
if not keyword_set(rmin) then rmin = 0.5
if not keyword_set(rmax) then rmax = 10.

ptc = ptc*0.083 ; scale to real measure
minx = min(ptc(0,*), max=maxx)
miny = min(ptc(1,*), max=maxy)
wr = where(ptc(0,*) gt minx+a0 and $
	ptc(0,*) lt maxx-a0 and $
	ptc(1,*) gt miny+a0 and $
	ptc(1,*) lt maxy-a0, wrc)

rn = (rmax - rmin)/dr
rvec = (findgen(rn+1)*(rmax - rmin)/rn + rmin)*a0
result = fltarr(5,rn+1)
result(0,*) = rvec
tmpgr = fltarr(wrc,rn+1)
tmpg6r = fltarr(wrc,rn+1,2)

for pi=0, wrc-1 do begin
	for i=0, rn do begin
		; for one particle
		ddr = sqrt((ptc(0,wr)-ptc(0,wr(pi)))^2+(ptc(1,wr)-ptc(1,wr(pi)))^2)
		wrr = where(ddr ge rvec(i) and ddr lt rvec(i)+dr*a0, wrrc)
		
		; check position
		area = circleInRectangle(ptc(0,wr(pi)),ptc(1,wr(pi)),rvec(i),$
			dr*a0,[minx, maxx, miny, maxy],/quiet)

		if wrrc eq 0 or area eq 0 then begin
			tmpgr(pi,i) = 0
			tmpg6r(pi,i) = 0
		endif else begin
			; calculate gr
			tmpgr(pi,i) = wrrc/area*a0^2

			; calculate g6r
			phi0r = conj(phi6array(wr(pi)))*phi6array(wr(wrr))
			tmpg6r(pi,i,0) = real_part(total(phi0r)/area*a0^2)/tmpgr(pi,i)
			tmpg6r(pi,i,1) = imaginary(total(phi0r)/area*a0^2)/tmpgr(pi,i)
		endelse
	endfor
;	plot, result(0,*)/(i+1), result(1,*)/result(0,*)
endfor

result(1,*) = total(tmpgr,1)/wrc
result(2,*) = sqrt((total(tmpg6r(*,*,0),1)/wrc)^2+(total(tmpg6r(*,*,1),1)/wrc)^2)
;result(2,*) = result(2,*)/result(1,*)

for i = 0, rn do begin
	result(3,i) = sqrt(mean(tmpgr(*,i)^2-mean(tmpgr(*,i))^2))
	result(4,i) = sqrt(mean(tmpg6r(*,i,0)^2-mean(tmpg6r(*,i,0))^2))
endfor

!p.multi=[0,2,2]
plot, result(0,*), result(1,*)
plot, result(0,*), result(2,*)
plot, result(0,*), result(3,*)
plot, result(0,*), result(4,*)
!p.multi=[0,1,1]

filename = 'f.gr_'+strtrim(frame,2)+'_'+string(dr,format='(F0.2)')+$
	'_'+string(rmin,format='(I2)')+'_'+string(rmax,format='(I2)')

write_gdf, result, filename
print, 'Write to: '+filename

return, result

end
