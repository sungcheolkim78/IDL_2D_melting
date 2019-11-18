;+
; Name: t_infos
; Purpose: print out info about one track
; Input: t_infos, tt, id, option
;-

function t_infos, tt, id, verbose=verbose
on_error, 2

wt = where(tt(6,*) eq id, wtc)
if wtc eq 0 then return, 0

tracklength = n_elements(wt)
tmin = min(tt(5,wt), max=tmax)
if tmax-tmin+1 ne tracklength then print,'missing '+strtrim(tmax-tmin+1-tracklength,2)

ttc = tt(*,where(tt(5,*) eq tmin))
firstframeid = where(tt(0,wt(0)) eq ttc(0,*) and tt(1,wt(0)) eq ttc(1,*))
triangulate, ttc(0,*), ttc(1,*), conn=con

nearp = con[con[firstframeid]:con[firstframeid+1]-1]
nearpid = transpose(fix(ttc(6,nearp)))

if keyword_set(verbose) then begin
	print, 'track length: '+strtrim(tracklength,2)
	print, 'start time: '+strtrim(tmin,2)
	print, 'end time: '+strtrim(tmax,2)
	print, 'first frame id: '+strtrim(firstframeid,2)
	print, 'nearest neighbors: '
	print, nearp
	print, nearpid
endif

nnear = n_elements(nearp)
result = intarr(5+2*nnear)
result[0]=tracklength
result[1]=tmin
result[2]=tmax
result[3]=firstframeid
for i=0,nnear-1 do begin
	result[i+4] = nearp[i]
	result[i+4+nnear] = nearpid[i]
endfor
result[5+2*nnear-1]=tmax-tmin+1-tracklength

return,result
end
