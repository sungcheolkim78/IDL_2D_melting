;+
; Name: gdeninfo
; Purpose: show density information by dislocations
; Input: gdeninfo, fden
;-

pro gdeninfo, fden, startf, stopf, prefix=prefix
on_error, 2

; frame check
maxf = max(fden(0,*), min=minf)
if n_params() eq 1 then begin
	startf = fix(minf)
	stopf = fix(maxf)
endif else begin
	if startf lt minf then startf = fix(minf)
	if stopf gt maxf then stopf = fix(maxf)
endelse

; postscript setup
set_plot,'ps'
!p.font = 0
!p.multi = [0,2,2]
!p.charsize = 0.8
if not keyword_set(prefix) then prefix=''
filename = prefix+'deninfo_'+strtrim(startf,2)+'_'+strtrim(stopf,2)+'.eps'
device, /encapsul, /color, /helvetica, bits=8
device, xsize=17.6, ysize=17.6*0.86, file=filename

; density frame plot
w4 = where(fden(4,*) gt 0, w4c)
w8 = where(fden(16,*) gt 0, w8c)
ymax = max([[fden(4,w4)],[fden(7,*)],[fden(10,*)],[fden(13,*)],[fden(16,w8)]],min=ymin)

fsc_plot, fden(0,*), fden(1,*), color='blk7', xran=[startf, stopf], $
	xstyle=1,yran=[ymin,ymax],ystyle=2, xtitle='Frame',$
	ytitle='Density (um!U-2!N)'
;errplot, fden(0,*), fden(1,*)+fden(3,*)/2., fden(1,*)-fden(3,*)/2., $
;	color=fsc_color('grn3')
fsc_plot, fden(0,w4), fden(4,w4), color='red3',/overplot
fsc_plot, fden(0,*), fden(7,*), color='red4',/overplot
fsc_plot, fden(0,*), fden(10,*), color='blk5',/overplot
fsc_plot, fden(0,*), fden(13,*), color='blu4',/overplot
fsc_plot, fden(0,w8), fden(16,w8), color='blu3',/overplot

items = ['4 co', '5 co', '6 co', '7 co','8 co']
colors = [fsc_color('red3'), fsc_color('red4'), fsc_color('blk5'),$
	fsc_color('blu4'),fsc_color('blu3')]
al_legend,items,psym=14,textcolor=colors,color=colors,charsize=0.8

; histogram plot
w4h = histogram(fden(4,w4),min=ymin, max=ymax, binsize=0.05)
w5h = histogram(fden(7,*),min=ymin, max=ymax, binsize=0.05)
w6h = histogram(fden(10,*),min=ymin, max=ymax, binsize=0.05)
w7h = histogram(fden(13,*),min=ymin, max=ymax, binsize=0.05)
w8h = histogram(fden(16,w8),min=ymin, max=ymax, binsize=0.05)

xh = findgen((ymax-ymin)/0.05+1)*0.05+ymin
hmax = max([[w5h],[w6h],[w7h],[w8h]])

fsc_plot,xh, w6h, psym=-14, color='blk5',xran=[ymin,ymax],$
	xtitle = 'Density (um!U-2!N)',ytitle='Numbers',$
	yran=[0,hmax],xstyle=1
fsc_plot,xh, w5h, psym=-14, color='red4',/overplot
fsc_plot,xh, w4h, psym=-14, color='red3',/overplot
fsc_plot,xh, w7h, psym=-14, color='blu4',/overplot
fsc_plot,xh, w8h, psym=-14, color='blu3',/overplot

al_legend,items,psym=14,textcolor=colors,color=colors,charsize=0.8,/right

; defect number plot
nmax = max([[fden(5,w4)],[fden(8,*)],[fden(11,*)],[fden(14,*)],[fden(17,w8)]],min=nmin)
fsc_plot, fden(0,*), fden(2,*), color='blk7', xran=[startf, stopf], $
	xstyle=1,yran=[nmin,nmax],ystyle=2, xtitle='Frame',$
	ytitle='Numbers'
;errplot, fden(0,*), fden(1,*)+fden(3,*)/2., fden(1,*)-fden(3,*)/2., $
;	color=fsc_color('grn3')
fsc_plot, fden(0,*), fden(5,*), color='red3',/overplot
fsc_plot, fden(0,*), fden(8,*), color='red4',/overplot
fsc_plot, fden(0,*), fden(11,*), color='blk5',/overplot
fsc_plot, fden(0,*), fden(14,*), color='blu4',/overplot
fsc_plot, fden(0,*), fden(17,*), color='blu3',/overplot

al_legend,items,psym=14,textcolor=colors,color=colors,charsize=0.8

dstd = mean(fden(3,*))
davr = mean(fden(1,*))
ymax = davr+dstd*0.4
ymin = davr-dstd*0.4

r4 = avgbin(fden(1,w4),fden(5,w4),minx=ymin,maxx=ymax)
r5 = avgbin(fden(1,*),fden(8,*),minx=ymin,maxx=ymax)
r6 = avgbin(fden(1,*),fden(11,*),minx=ymin,maxx=ymax)
r7 = avgbin(fden(1,*),fden(14,*),minx=ymin,maxx=ymax)
r8 = avgbin(fden(1,w8),fden(17,w8),minx=ymin,maxx=ymax)
fsc_plot, r6(0,*), r6(1,*)/max(r6(1,*)),color='blk5',xtitle='<Density> (um!U-2!N)',$
	ytitle='Ratio (#/max)',xstyle=1,ystyle=2,xran=[ymin,ymax],/ynozero
fsc_plot, r4(0,*), r4(1,*)/max(r4(1,*)),/overplot,color='red3'
fsc_plot, r5(0,*), r5(1,*)/max(r5(1,*)),/overplot,color='red4'
fsc_plot, r7(0,*), r7(1,*)/max(r7(1,*)),/overplot,color='blu4'
fsc_plot, r8(0,*), r8(1,*)/max(r8(1,*)),/overplot,color='blu3'
al_legend,items,psym=14,textcolor=colors,color=colors,charsize=0.8,/bottom

device,/close
set_plot,'x'
!p.multi=[0,1,1]
spawn, 'gv '+filename

end
