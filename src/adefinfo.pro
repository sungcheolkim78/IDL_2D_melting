;+
; Name: adefinfo
; Purpose: show defect density information by time
; Input: adefinfo, pt, startf, stopf
;-

pro adefinfo, pt, startf, stopf, prefix=prefix, quiet=quiet
on_error, 2

maxf = fix(max(pt(5,*)))
if n_params() eq 1 then begin
	startf = 0
	stopf = maxf
endif
if n_params() eq 3 then begin
	if stopf gt maxf then stopf=maxf
endif

; set postscript print
if not keyword_set(prefix) then prefix=''
set_plot,'ps'
!p.font=0
!p.multi=[0,2,2]
!p.charsize=0.8
device,/color,/helvetica,/encapsul,bits=8
filename = prefix+'adef'+strtrim(startf,2)+'_'+strtrim(stopf,2)+'.eps'
device,xsize=16.6,ysize=16.6*0.9,file=filename

datafilename = 'f.'+prefix+'def_'+strtrim(startf,2)+'_'+strtrim(stopf,2)
fs = file_search(datafilename, count=fc)
if fc gt 0 then begin
	nf = stopf - startf + 1
	dd = read_gdf(datafilename)
endif else begin
	nf = stopf - startf + 1
	dd = fltarr(4, nf)
	for i=startf, stopf do begin
		ptc = pt(*,where(pt(5,*) eq i))
		dd(*,i-startf) = defectdensity(ptc)
		statusline, 'Frame: '+strtrim(i,2), 0
	endfor
	print,''
	write_gdf,dd,datafilename
endelse

; plot datas
timex = (findgen(nf)+startf)*1/30.
fsc_plot,timex,dd(0,*), xtitle='time (sec)', ytitle='defect density ('+$
	greek('mu')+'m!U-2!N)', /ynozero, xstyle=1, color='red4'
add = mean(dd(0,*))
fsc_plots,[startf, stopf]*1/30., [add, add], linestyle=2, color='blk7'

fsc_plot,timex,dd(2,*), xtitle='time (sec)', ytitle='balance',$
	xstyle=1, color='blk4'
add = mean(dd(2,*))
fsc_plots,[startf, stopf]*1/30., [add, add], linestyle=2, color='blk7'

fsc_plot,timex,dd(1,*), xtitle='time (sec)', ytitle='density ('+$
	greek('mu')+'m!U-2!N)', /ynozero, xstyle=1, color='blu4'
add = mean(dd(1,*))
fsc_plots,[startf, stopf]*1/30., [add, add], linestyle=2, color='blk7'

fsc_plot,timex,dd(3,*), xtitle='time (sec)', ytitle='defect percentage (%)',$
	xstyle=1,/ynozero,color='grn4'
add = mean(dd(3,*))
fsc_plots,[startf, stopf]*1/30., [add, add], linestyle=2, color='blk7'

device,/close
set_plot,'x'
!p.multi=[0,1,1]
if not keyword_set(quiet) then spawn,'gv '+filename

end

