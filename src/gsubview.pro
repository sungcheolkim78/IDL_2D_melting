;+
; Name: gsubview
; Purpose: show randomness of the particle distribution
; Input: gsubview,pt
; History:
; 	created on 4/17/11 by sungcheol kim
; 	modified on 5/22/11 by sungcheol kim
; 		add scale bar and color bar
;	modified on 7/28/11 by sungcheol kim
;		windows modification
;-

pro gsubview, pt, pt2, ps=ps, cutper=cutper
on_error,2

maxf = n_elements(pt(5,*))
maxf2 = n_elements(pt2(5,*))
if n_elements(cutper) eq 0 then cutper = 0.88

;hist1 = hist_2d(pt(0,*),pt(1,*),bin1=2,bin2=2,max1=636,min1=0,max2=472,min2=0) > 1
hist1 = hist_2d(pt(0,*),pt(1,*),bin1=2,bin2=2,max1=511,min1=0,max2=511,min2=0) > 1
;hist2 = hist_2d(pt2(0,*),pt2(1,*),bin1=2,bin2=2,max1=636,min1=0,max2=472,min2=0) > 1
hist2 = hist_2d(pt2(0,*),pt2(1,*),bin1=2,bin2=2,max1=511,min1=0,max2=511,min2=0) > 1
vu1 = alog10(hist1)
vu2 = alog10(hist2)
vu1max = max(vu1)
vhist1 = histogram(vu1,binsize=0.1,min=0,max=vu1max)
vhist2 = histogram(vu2,binsize=0.1,min=0,max=vu1max)

x = 0.1*findgen((vu1max-0)/0.1+1)+0
print, max(vu1,/nan), min(vu1)
print, max(vu2,/nan), min(vu2)

cutrealx = vu1max*cutper
cutx = where(x ge cutrealx)
fixed1 = total(vhist1(cutx))
fixed2 = total(vhist2(cutx))

!p.multi=[0,2,2]
thisDevice = !D.name

if n_elements(ps) then begin
	set_plot,'ps'
	!p.font=0
	device,/color,/encapsul,/helvetica,bits=8
	filename = 'gsub'+strtrim(maxf,2)+'_'+$
		strtrim(maxf2,2)+'.eps'
	device,xsize=17.8,ysize=17.8*3.5/4.,file=filename
	print, filename
endif

!p.charsize=0.8
loadct,0,ncolors=8
cgcontour, rebin(vu1,512,512), charsize=1.,nlevels=10,/fill $
	,xstyle=1,ystyle=1,xran=[0,511],yran=[0,511]
; scalebar for 5um
cgplots, [550,610.241],[450,450], thick=6, /data,color='blk1'
cgtext, 540,415, '5 um', color='blk1', charsize=0.8,/data
cgcolorbar, ncolors=8,/vertical,maxrange=max(vu1),minrange=min(vu1) $
	, position=[0.51,0.59,0.54,0.95],format='(F3.1)'
cgplot,x, alog10(vhist1), charsize=1.,psym=-14,xtitle='Intensity'$
	,ytitle='log(Number)',xstyle=1
cgplots, [cutrealx,cutrealx],[0,alog10(vhist1(min(cutx)))],line=2
cgtext, cutrealx, 0.3, string(fixed1,format='( I0)'),charsize=0.8,/data

;cgcontour, rebin(vu2,638,474), charsize=1.,levels=clevels,/fill,c_colors=ccolors
cgcontour, rebin(vu2,512,512), charsize=1.,nlevels=8,/fill $
	,xstyle=1,ystyle=1,xran=[0,511],yran=[0,511]
; scalebar for 5um
cgplots, [550,610.241],[450,450], thick=6, /data,color='blk1'
cgtext, 540,415, '5 um', color='blk1', charsize=0.8,/data
cgcolorbar, ncolors=8,/vertical,maxrange=max(vu1),minrange=min(vu1) $
	, position=[0.51,0.09,0.54,0.45],format='(F3.1)'
cgplot,x, alog10(vhist2), charsize=1.,psym=-14,xtitle='Intensity'$
	,ytitle='log(Number)',xstyle=1
cgplots, [cutrealx,cutrealx],[0,alog10(vhist2(min(cutx)))],line=2
cgtext, cutrealx, 0.3, string(fixed2,format='( I0)'),charsize=0.8,/data

if n_elements(ps) then begin
	device,/close
	set_plot, thisDevice

	case !version.os of
		'Win32': begin
			cmd = '"c:\Program Files\Ghostgum\gsview\gsview64.exe "'
			spawn, [cmd,filename], /log_output, /noshell
			end
		'darwin': spawn, 'open '+filename
		else: spawn, 'gv '+filename
	endcase
endif

!p.multi=[0,1,1]

end
