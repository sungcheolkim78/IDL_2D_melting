;+
; Name: s_autocorrelation
; Purpose: calculate auto correlations for each track
; Input: s_autocorrelation, t
;-

function s_autocorrelation, tt, prefix=prefix, test=test, length=length
on_error, 2

if not keyword_set(prefix) then prefix = ''

particle_number = max(tt(6,*))+1
track_length = max(tt(5,*))+1
print, particle_number, track_length
if not keyword_set(length) then length = track_length
if length gt track_length then length = track_length

ht = histogram(tt(6,*),binsize=1,locations=loc)
fulltrackid = loc(where(ht ge length))
fulltrackn = n_elements(fulltrackid)
result = fltarr(length/2, fulltrackn)
presult = fltarr(2,length/2)

if not keyword_set(test) then begin
	fsc_plot, [0,length/2],[-300,300],/nodata,xstyle=1
	colorname1 = 'grn'+strtrim((indgen(fulltrackn) mod 4)+1,2)
	colorname2 = 'blu'+strtrim((indgen(fulltrackn) mod 4)+1,2)
	for i=0,fulltrackn-1 do begin
		xt = tt(0,where(tt(6,*) eq fulltrackid(i)))
		xt = xt[0:length-1] - xt(0)
		yt = tt(1,where(tt(6,*) eq fulltrackid(i)))
		yt = yt[0:length-1] - yt(0)

		xt2 = s_msd(xt)
		yt2 = s_msd(yt)

		result(*,i) = xt2 + yt2
		statusline, strtrim(i,2) + ' of '+strtrim(fulltrackn), 0
		fsc_plot, xt, /overplot, color=colorname1(i)
		fsc_plot, xt2+yt2, /overplot, color=colorname2(i)
	endfor
	print,''

	presult(0,*) = total(result,2)/fulltrackn
	for j=0,length/2-1 do presult(1,j) = stddev(result(j,*))
endif else begin
	presult = read_gdf('t.ac')
endelse
		
set_plot,'ps'
!p.font = 0
!p.multi = [0,1,1]
!p.charsize = 0.9
device,/color,/encapsul,/helvetica,bits=8
filename = prefix +'ac.eps'
device, xsize=12, ysize=12*0.8, file=filename

time = findgen(length/2)/30.
fsc_plot, time, presult(0,*)*0.083*0.083, xtitle='Time (sec)',$
	ytitle = ps_symbol('<')+'(X!Dt!N - X!D0!N)!U2!N'+ps_symbol('>') +$
	' ('+ps_symbol('mu')+'m!U2!N)',$
	ystyle=2, color = 'blk7',/nodata
oploterror, time, presult(0,*)*0.083*0.083,presult(1,*)*0.083*0.083, color='red3'
fsc_plot, time, presult(0,*)*0.083*0.083, color='blk7',thick=1.5,/overplot

if not keyword_set(test) then write_gdf, presult, prefix+'t.ac'

device,/close
set_plot,'x'
spawn, 'gv '+filename

return, presult

end
