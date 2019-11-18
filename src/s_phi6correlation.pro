;+
; Name: s_phi6correlation
; Purpose: calculate phi6 correlations for each track
; Input: s_autocorrelation, tt2
;-

function s_phi6correlation, tt, prefix=prefix, length=length
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
resultt = fltarr(length, fulltrackn)
result = fltarr(length/2, fulltrackn)
presult = fltarr(2,length/2)

fsc_plot, [0,length/2],[-180,880],/nodata,xstyle=1
colorname1 = 'grn'+strtrim((indgen(fulltrackn) mod 4)+1,2)
colorname2 = 'blu'+strtrim((indgen(fulltrackn) mod 4)+1,2)
for i=0,fulltrackn-1 do begin
	cc = t_phi6(tt, fulltrackid(i))
	cct = cc*conj(cc(0))

	resultt(*,i) = atan(cct,/phase)*180./!pi
	result(*,i) = s_msd(resultt(*,i))

	fsc_plot, resultt(*,i), /overplot, color=colorname1(i)
	fsc_plot, result(*,i), /overplot, color=colorname2(i)

	statusline, strtrim(i,2) + ' of '+strtrim(fulltrackn), 0
endfor
print,''

presult(0,*) = total(result,2)/fulltrackn
for j=0,length/2-1 do presult(1,j) = stddev(result(j,*))
	
set_plot,'ps'
!p.font = 0
!p.multi = [0,1,1]
!p.charsize = 0.9
device,/color,/encapsul,/helvetica,bits=8
filename = prefix +'phi6ac.eps'
device, xsize=12, ysize=12*0.8, file=filename

time = findgen(length/2)/30.
fsc_plot, time, presult(0,*), xtitle='Time (sec)',$
	ytitle = ps_symbol('<')+ps_symbol('Phi')+'!D6!N(t)*'+ps_symbol('Phi')+$
	'!D6!N(0)'+ps_symbol('>'),$
	ystyle=2, color = 'grn5'
oploterror, time, presult(0,*),presult(1,*), color='red4'

if not keyword_set(test) then write_gdf, presult, prefix+'t.phi6'

device,/close
set_plot,'x'
spawn, 'gv '+filename

return, presult

end
