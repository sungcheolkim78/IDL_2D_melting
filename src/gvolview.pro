;+
; Name: gvolview
; Purpose: show relation between voltage and velocity or defect density
; Input: gvolview, tt, startf, stopf, maxvol
;-

pro gvolview, tt, vol, startf, stopf, peaks,up=up,$
	verbose=verbose, down=down,tr=tr, ef = ef, prefix=prefix
on_error, 2

mupixel = 0.083
timefactor = 1./30

; postscipt set
set_plot,'ps'
!p.font=0
!p.multi=[0,1,1]
if not keyword_set(prefix) then prefix=''
filename = prefix+'vol_'+strtrim(startf,2)+'_'+strtrim(stopf,2)+'.eps'
dataname = 'f.'+prefix+'vol_'+strtrim(startf,2)+'_'+strtrim(stopf,2)
device, /encapsul,/color,bits=8,/helvetica
device, xsize=16, ysize=16*0.85, file=filename

if not keyword_set(tr) then tr = 1
maxf = max(tt(5,*),min=minf)
xvol = periodicVoltage(vol,startf,stopf,peaks,/down)
if keyword_set(up) then xvol = periodicVoltage(vol,startf,stopf,peaks,/up)
if keyword_set(down) then xvol = periodicVoltage(vol,startf,stopf,peaks,/down)

ft = file_search(dataname,count=fc)
if fc eq 0 then begin
	ttc = eclip(tt,[5,startf,stopf])

	dx = getdx(ttc, tr, dim=2)
	dx(0,*) = dx(0,*)/float(tr)*mupixel/timefactor
	dx(1,*) = dx(1,*)/float(tr)*mupixel/timefactor
	if not keyword_set(ef) then begin
		ef = fltarr(2)
		ef(0) = mean(dx(0,*))
		ef(1) = mean(dx(1,*))
		er = sqrt(ef(0)^2+ef(1)^2)
		ef(0) = ef(0)/er
		ef(1) = ef(1)/er
	endif
	print,ef

	dv = dx(0,*)*ef(0)+dx(1,*)*ef(1)

	adv = avgbin(ttc(5,*), dv, binsize=1)
	vva = avgbin(xvol, adv(1,*), binsize=0.5)
	t = indgen(stopf-startf+1)+startf
	savedata = [transpose(t),transpose(xvol),adv(0,*),adv(1,*)]
	write_gdf,savedata,dataname
endif else begin
	tmpdata = read_gdf(dataname)
	t = transpose(tmpdata(0,*))
	xvol = transpose(tmpdata(1,*))
	adv = fltarr(2,n_elements(xvol))
	adv(0,*) = tmpdata(2,*)
	adv(1,*) = tmpdata(3,*)
	vva = avgbin(xvol, adv(1,*), binsize=0.5)
endelse

w1 = where(vva(0,*) ge 0,w1c)
w2 = where(vva(0,*) le 0,w2c)
print,w1c,w2c,max(xvol)

; make x coordinate
if keyword_set(verbose) then begin
	maxy = max(adv(1,*), min=miny)
	fsc_plot, xvol, [miny, maxy], xtitle = 'Voltage(V)',$
		ytitle='Velocity ('+greek('mu')+'m/sec)', /nodata
	fsc_plot, xvol, adv(1,*), psym=14, /overplot, color='grn3'
	fsc_plot, vva(0,*)+0.25, vva(1,*), psym=-14, /overplot, color='grn5'

	items = ['each cycle', 'avrage'] 
	colors = [fsc_color('grn3'), fsc_color('grn5')]
	al_legend, items, psym=[14,14], textcolors=colors, colors = colors
endif else begin
	maxy = max([[vva(1,w1)],[-vva(1,w2)]], min=miny)
	fsc_plot, vva(0,w1)+0.25, [miny, maxy], xtitle = 'Voltage(V)',$
		ytitle='Velocity ('+greek('mu')+'m/sec)', /nodata, $
		ystyle=2
	fsc_plot, vva(0,w1)+0.25, vva(1,w1), psym=-14, /overplot, color='grn5'
	fsc_plot, -vva(0,w2)-0.25, -vva(1,w2), psym=-15, /overplot, color='blu5'

	items = ['up', 'down'] 
	colors = [fsc_color('grn5'), fsc_color('blu5')]
	al_legend, items, psym=[14,15], textcolors=colors, colors = colors
endelse

device,/close
set_plot,'x'
!p.multi=[0,1,1]
spawn,'gv '+filename

end
