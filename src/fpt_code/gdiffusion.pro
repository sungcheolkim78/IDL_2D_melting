;+ 
; Name: gdiffusion
; Purpose: show diffusion coefficient of track by each time
; Input: gdiffusion, x1, y1, t
; History:
;	created on 8/12/11 by SCK
;-

pro gdiffusion, ptd, length=length, sample=sample

	nf = n_elements(ptd(2,*))

	if keyword_set(length) then tf = length else tf = 30
	if keyword_set(sample) then sn = sample else sn = 30

	fitdata = fltarr(sn)
    if 2*nf/3. gt sn then timeSample = fix(findgen(sn)*2.*nf/3./(sn-1)+nf/3.-1) $
        else timeSample = fix(reverse(nf - findgen(sn)-1))
	time = findgen(tf)*0.033
    print, nf
    print, timeSample
	
	for i=0,sn-1 do begin
		msd = i_msd2d(ptd(*,0:timeSample(i))*0.083, length=tf)
		fit = mpfitexpr('P[0]*X', time, msd[*,0], msd[*,1], [2.,0.],/quiet,bestnorm=chi)
		fitdata(i) = fit[0]/2.
	endfor

	cgplot, timeSample*0.033, fitdata, ystyle=1, charsize=1.0 $
		, ytitle='D (um^2/s)', xtitle='Time (sec)' $
		, psym=-16, symsize=0.5, xstyle=1

	print, fitdata

end
