;+
; Name: defectdensity
; Purpose: calculate defectdensity for one frame
; Input, defectdensity, ptc
;-

function defectdensity, ptc, option=option
on_error, 2

nc = n_elements(ptc(0,*))
maxx = max(ptc(0,*), min=minx)
maxy = max(ptc(1,*), min=miny)
density = float(nc)/(maxx-minx)/(maxy-miny)
mdis = sqrt(1./density)*1.5

wr = where(ptc(0,*) gt minx+mdis and $
	ptc(0,*) lt maxx-mdis and $
	ptc(1,*) gt miny+mdis and $
	ptc(1,*) lt maxy-mdis, wrc)

; calculate nearest neighbor numbers
nnn = intarr(nc)
if n_elements(ptc(*,0)) ne 9 then begin
	triangulate, ptc(0,*), ptc(1,*), tr, conn=con
	for i = 0, nc-1 do nnn(i) = n_elements(con[con[i]:con[i+1]-1])
endif else nnn = ptc(6,*)

hist = histogram(nnn(wr), binsize=1, min=3, max=9)
x = [-3,-2,-1,0,1,2,3]

result = fltarr(4)
result(0) = (total(hist)-hist(3))/((maxx-minx-mdis)*(maxy-miny-mdis)*0.083*0.083) 
if keyword_set(option) then result(0) = (hist(2)+hist(4))$
	/((maxx-minx-mdis)*(maxy-miny-mdis)*0.083*0.083) 
result(1) = total(hist)/((maxx-minx-mdis)*(maxy-miny-mdis)*0.083*0.083) 
result(2) = transpose(x)#hist
result(3) = (total(hist)-hist(3))/total(hist)*100
if keyword_set(option) then result(2) = -hist(2)+hist(4)

return, result

end
