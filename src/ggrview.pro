;+
; Name: ggrview
; Purpose: to show g(r) and g6(r) with proper scale
; Input: ggrview,pt,0,10
; History:
; 	modified on 4/14/11 by sungcheol kim
; 	1. calculate on one frame
; 	2. show image of last frame and log scale g6(r)
;-

pro ggrview, pt, startf, stopf, dr=dr,rmin=rmin, rmax=rmax, $
	prefix=prefix, verbose=verbose, realf=realf, gmax=gmax

on_error,2

; check parameters
if not keyword_set(dr) then dr = 0.1
if not keyword_set(rmin) then rmin = 0.5
if not keyword_set(rmax) then rmax = 10.
if not keyword_set(prefix) then prefix = ''
if n_params() eq 2 then stopf = startf
if n_params() eq 3 then begin
	maxf = max(pt(5,*), min=minf)
	if stopf gt maxf then stopf=maxf
	if startf lt minf then startf=minf
endif
if n_elements(verbose) eq 1 then verbose = 1 else verbose = 0
if n_elements(gmax) eq 0 then gmax = 1.

nf = stopf - startf + 1
nr = (rmax-rmin)/dr + 1
fgr = fltarr(5,nr,nf)
a0 = fltarr(nf)
for i=startf, stopf do begin
	filename = 'f.gr_'+strtrim(i,2)+'_'+string(dr,format='(F0.2)')+$
		'_'+string(rmin,format='(I2)')+'_'+string(rmax,format='(I2)')
	fresult = file_search(filename, count=fc)
	if fc gt 0 then begin
		fgr(*,*,i-startf) = read_gdf(filename)
	endif else begin
		fgr(*,*,i-startf) = g6(pt, i, dr=dr, rmin=rmin, rmax=rmax)
	endelse
	a0(i-startf) = latticeconstant(pt, i)
endfor

a0t = mean(a0)
if nf eq 1 then fgrt = fgr(*,*,0) else fgrt = total(fgr,3)/nf

set_plot,'ps'
!p.font=0
!p.multi=[0,2,1]
!p.charsize=1.0
!p.thick=1.5
device,/color,/helvetica,/encap,bits=8
filename = prefix + 'gr_'+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)+'.eps'
device,xsize=20,ysize=20*1.9/4.,file=filename

; plot g(r)
if verbose then begin
	imagef1 = readjpgstack('fg',stopf+realf,stopf+realf+2)
	imagef = normalimage(imagef1,1)
	imagef = imagef[100:350,100:350]
endif

cgPlot,fgrt(0,0:nr/2),fgrt(1,0:nr/2),ytitle='g(r)',color='grn7',$
	xstyle=1, xtitle='r (um)',ystyle=2,psym=-14 

if verbose then begin
	;cgImage, imagef, 0.25,0.5,/noerase
	imdisp, imagef, pos=[0.23,0.45,0.48,0.93],/noerase
endif

if verbose then begin
	peakloc = peakfinder(fgrt(1,*), fgrt(0,*)/a0t, /opt)
	wp = where(peakloc(4,*) ge 0.01, wpc)
	cgPlot,peakloc(1,wp),peakloc(2,wp),psym=9,symcolor='red4',/overplot
endif

; plot g6(r) function and find peaks
cgPlot,fgrt(0,*),fgrt(2,*),ytitle='g!D6!N(r)',color='blu7',$
	xstyle=1, xtitle='r (um)',ystyle=2, psym=-14 $
	, yran=[0.01,1], /ylog

if verbose then begin
	peakloc = peakfinder(fgrt(2,*), fgrt(0,*)/a0t, /opt)
	wp = where(peakloc(4,*) ge 0.005, wpc)
	cgPlots,peakloc(1,wp),peakloc(2,wp),psym=9,symcolor='red4'

	; plot exponential fitting
	fit = mpfitexpr('P[0]*exp(-X/P[1])', peakloc(1,wp), $
		peakloc(2,wp), sy, [1.,1.], /weights,/quiet, bestnorm=chi1)
	;fit = mpfitexpr('P[0]*exp(-X/P[1])', fgrt(0,*)/a0t, $
	;	fgrt(2,*), fgrt(4,*), [1.,1.], /weights,/quiet, bestnorm=chi1)
	fit2 = mpfitexpr('P[0]*X^(-P[1])', peakloc(1,wp), $
		peakloc(2,wp), sy, [1.,1.], /weights,/quiet, bestnorm=chi2)

	npoints = 20
	tempx = findgen(npoints)*(peakloc(1,wp(wpc-1))-peakloc(1,wp(0)))/(npoints-1)$
	+peakloc(1,wp(0))

	ypos = 0
	if fit[1] lt 8. then ypos = 0
	; plot fitted function
	cgPlot,tempx, fit[0]*exp(-tempx/fit[1]), $
		psym = -3, /overplot, color='grn4'
	cgPlot,tempx, fit2[0]*tempx^(-fit2[1]), $
		psym = -3, /overplot, color='blu4'
	cgText,0.66,0.75+ypos, greek('xi')+'!D6!N/a!D0!N = '+$
		string(fit[1],format='(F0.3)'), /normal, charsize=1.1
	cgText,0.66,0.72+ypos, greek('eta')+'!D6!N = '+$
	string(fit2[1],format='(F0.3)'), /normal, charsize=1.1
	cgText,0.66,0.69+ypos, greek('chi')+'!U2!Dalg!N/'+$
		greek('chi')+'!U2!Dexp!N = '+$
		string(chi2/chi1,format='(F0.2)'), /normal, charsize=1.1
	cgText,0.66,0.66+ypos, 'a!D0!N = '+string(a0t,format='(F0.2)')+$
		' '+greek('mu')+'m',/normal, charsize=1.1
	cgText,0.66,0.63+ypos, greek('xi')+'!D6!N = '+string(fit[1]*a0t,format='(F0.2)')+$
		' '+greek('mu')+'m',/normal, charsize=1.1
	cgText,0.66,0.60+ypos, greek('beta')+'F!DA!N = '+string(18./!pi/fit2[1],format='(F0.2)')$
		,/normal, charsize=1.1

	cgPlot,fgrt(0,*)/a0t,fgrt(2,*),color='blu7',$
		xstyle=1,ystyle=2, psym=-14, /noerase $
		,pos=[0.75,0.5,0.96,0.90], yran=[0,gmax] $
		,symsize=0.6
endif

device,/close
set_plot,'x'
!p.multi=[0,1,1]

if verbose then print,chi1, chi2

spawn,'gv '+filename
print,a0t

end
