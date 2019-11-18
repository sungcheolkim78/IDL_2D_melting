;+
; Name: gtrmsd
; Purpose: show mean square displacement from many tracks
; Input: gtrmsd, ptdef1, ptdef2, tlength=tlength
; History:
; 	created on 8/1/17 by SCK
;-

pro gtrmsd, pd1, pd2, pd3, pd4, ps=ps, tlength=tlength, sfilename=sfilename
	on_error,2

	thisDevice = !d.name
	!p.multi = [0,1,1]
	!p.charsize = 1.0

	if n_elements(ps) then begin
		set_plot,'ps'
		!p.font=0
		filename = 'tmsd'+'.eps'
		device, /color, /helvetica, /encapsul, bits=8
		device, xsize=12.8, ysize=12.8*3./4,file=filename
	endif

    n1 = n_elements(pd1(0,*))
    n2 = n_elements(pd2(0,*))
    n3 = n_elements(pd3(0,*))
    n4 = n_elements(pd4(0,*))

    nmin = min([n1,n2,n3,n4])
    if nmin gt 300 then rn = 150 else rn=nmin-1
    if keyword_set(tlength) then rn = tlength
    if keyword_set(sfilename) then begin
        result2 = read_gdf(sfilename)
        nf2 = n_elements(result2(*,0))
        time2 = findgen(nf2)*0.033
        wmaxy = max(result2(0:rn,0))
    endif

    result = fltarr(rn,2)
    for dt=1,rn-1 do begin
        k1 = n1 - dt - 2
        k2 = n2 - dt - 2
        k3 = n3 - dt - 2
        k4 = n4 - dt - 2

        xd1 = pd1(0,0:k1) - pd1(0,0+dt:k1+dt)
        yd1 = pd1(1,0:k1) - pd1(1,0+dt:k1+dt)
        d1 = xd1*xd1+yd1*yd1

        xd2 = pd2(0,0:k2) - pd2(0,0+dt:k2+dt)
        yd2 = pd2(1,0:k2) - pd2(1,0+dt:k2+dt)
        d2 = xd2*xd2+yd2*yd2

        xd3 = pd3(0,0:k3) - pd3(0,0+dt:k3+dt)
        yd3 = pd3(1,0:k3) - pd3(1,0+dt:k3+dt)
        d3 = xd3*xd3+yd3*yd3

        xd4 = pd4(0,0:k4) - pd4(0,0+dt:k4+dt)
        yd4 = pd4(1,0:k4) - pd4(1,0+dt:k4+dt)
        d4 = xd4*xd4+yd4*yd4

        td = [[d1],[d2],[d3],[d4]]
        result(dt,0) = mean(td)
        result(dt,1) = stddev(td)/sqrt(n_elements(td))
    endfor

    result(0,1) = 0.000001
    result = result*0.083*0.083
    time = findgen(rn)*0.033
	fit = mpfitexpr('P[0]*X', time, result[*,0], result[*,1], [2.,0.], /quiet, bestnorm=chi1)

    wmaxy = wmaxy > max(result(*,0))
    cgplot, time, result(*,0), ystyle=1 $
		, charsize=1.0, ytitle = 'MSD (um^2)' $
		, xstyle=1, xtitle='time (sec)',psym=-14,symsize=1 $
        , yran=[0,wmaxy]
	oploterror, time, result[*,0],result[*,1],psym=3, /nohat,errcolor=fsc_color('red4')

	cgplot, time, fit[0]*time+fit[1], /overplot, color='red6',line=2
	cgtext, 0.30, 0.85, 'D: '+string(fit[0]/2.,format='(F0.3)')+' (um^2/s)' $
		,/normal, charsize=1.0

    if keyword_set(sfilename) then begin

        fit = mpfitexpr('P[0]*X', time2, result2[*,0], result2[*,1], [2.,0.], /quiet, bestnorm=chi1)

        cgplot, time2, result2[*,0],psym=-14,symsize=1,/overplot
        oploterror, time2, result2[*,0],result2[*,1],psym=3, /nohat,errcolor=fsc_color('blu4')

        cgplot, time2, fit[0]*time2, /overplot, color='blu6',line=2
        cgtext, 0.30, 0.80, 'D: '+string(fit[0]/2.,format='(F0.3)')+' (um^2/s)' $
            ,/normal, charsize=1.0

        al_legend,['mono','di'],colors=[fsc_color('blu7'),fsc_color('red7')],psym=[14,14],$
            charsize=0.8,textcolors=[fsc_color('blu7'),fsc_color('red7')]
        
    endif

	!p.multi = [0,1,1]
	if n_elements(ps) then i_close, filename, thisDevice
    write_gdf, result, 'msd.save'

end

