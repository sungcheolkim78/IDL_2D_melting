;+
; Name: gsizeview
; Purpose: show cumulant, susceptibility, bond ori. par. by size
; Input: gsizeview, pt, endm
;-

pro gsizeview, pt1,pt2,pt3, startm, endm
on_error, 2

nm = endm-startm+1
result = fltarr(4,nm,3)
for i=startm,endm do begin
	result(*,i-startm,0) = (cumulant(pt1,0,i) + cumulant(pt1,100,i) + cumulant(pt1,200,i))/3.
	result(*,i-startm,1) = (cumulant(pt2,0,i) + cumulant(pt2,100,i) + cumulant(pt2,200,i))/3.
	result(*,i-startm,2) = (cumulant(pt3,0,i) + cumulant(pt3,100,i) + cumulant(pt3,200,i))/3.
endfor

set_plot,'ps'
!p.font=0
!p.multi=[0,2,2]
device,/color,/encapsul,/helvetica,bits=8
device,xsize=18, ysize=18*.9, file='cumul.eps'

; plot cumulant
colors = rebin([fsc_color('blk1')],nm)
items = 'M = '+strtrim(string(indgen(nm)+startm),2)
for i=0,nm-1 do colors(i) = fsc_color('blu'+strtrim(string((i mod 6)+3),2))

fsc_plot, [1,1.5,2], result(0,0,*), xtitle='d', $
	xstyle=1, yran=[0.37,0.67], ystyle=1, ytitle='U!DL', $
	/nodata,xticks=4
for i=0,nm-1 do fsc_plot, [1, 1.5, 2], result(0,i,*), psym=-11-i, $
	color=colors(i), symcolor = colors(i), /overplot
al_legend,items,psym=11+indgen(nm),$
	textcolors=colors, colors=colors, charsize=0.6

; plot susceptibility
colors3 = [fsc_color('blu5'),fsc_color('grn5'),fsc_color('red5')]
fsc_plot, result(3,*,2), result(1,*,2), xtitle='L!U-1', $
	xstyle=1, yran=[0,max(result(1,*,*))], ytitle=greek('chi')+'!DL',/nodata
for i=0,2 do fsc_plot, result(3,*,i), result(1,*,i), psym=-14-i, $
	color = colors3(i), symcolor = colors3(i), /overplot
al_legend,['d = 1','d = 1.5','d = 2'],psym=[14,15,16], $
	textcolors=colors3, colors=colors3, $
	/right, charsize=0.6

; plot phi_L
fsc_plot, [1,1.5,2], result(2,0,*), xtitle='d', xticks=4, $
	xstyle=1, yran = [0.2,1.0], ystyle=1, ytitle = '<'+greek('psi')+'>!DL',$
	/nodata
for i=0,nm-1 do fsc_plot, [1,1.5,2], result(2,i,*), psym=-11-i, $
	color=colors(i), symcolor = colors(i), /overplot
al_legend,items,psym=11+indgen(nm),$
	textcolors=colors, colors=colors, charsize=0.6

device,/close
set_plot,'x'
!p.multi=[0,1,1]
spawn, 'gv cumul.eps'

end
