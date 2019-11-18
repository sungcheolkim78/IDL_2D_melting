;+
; Name: gtrackview
; Purpose: show one track with msd
; Input: gtrackview, ptdef
; History:
; 	created on 8/1/11 by sungcheol kim
;	modified on 8/9/11 by sungcheol kim - add for single event
;-

pro gtrackview, ptdef, ptdef2, ps=ps, startf=startf, stopf=stopf, $
	tlength=tlength,option=option
	on_error,2

	singlef = 0
	case n_params() of
		'1': begin
			ptdef2 = ptdef
			singlef = 1
			end
		'2': begin
			end
	endcase

	tmax1 = max(ptdef(2,*), min=tmin1)
	tmax2 = max(ptdef2(2,*), min=tmin2)
	wminf = tmin1 > tmin2
	wmaxf = tmax1 < tmax2
	if keyword_set(startf) then wminf = startf
	if keyword_set(stopf) then wmaxf = stopf

	xmax1 = max(ptdef(0,wminf-tmin1:wmaxf-tmin1)*0.083, min=xmin1)
	ymax1 = max(ptdef(1,wminf-tmin1:wmaxf-tmin1)*0.083, min=ymin1)
	xmax2 = max(ptdef2(0,wminf-tmin2:wmaxf-tmin2)*0.083, min=xmin2)
	ymax2 = max(ptdef2(1,wminf-tmin2:wmaxf-tmin2)*0.083, min=ymin2)
	wminx = xmin1 < xmin2
	wmaxx = xmax1 > xmax2
	wminy = ymin1 < ymin2
	wmaxy = ymax1 > ymax2
	print, wminf, tmin1, tmin2
	print, wmaxf, tmax1, tmax2

	if not keyword_set(tlength) then begin
		if (wmaxf-wminf) gt 300 then tlength=150
		if (wmaxf-wminf) le 300 then tlength=30
		if (wmaxf-wminf) lt 60 then tlength=10
	endif

	!p.multi = [0,2,2]
	thisDevice = !d.name
	!p.charsize = 1.0
	time = (indgen(wmaxf-wminf+1)+wminf)*0.033
	time2 = findgen(tlength)*0.033 ; 5 seconds
	distance = sqrt((ptdef(0,wminf-tmin1:wmaxf-tmin1)- $
		ptdef2(0,wminf-tmin2:wmaxf-tmin2))^2+ $
		(ptdef(1,wminf-tmin1:wmaxf-tmin1)-ptdef2(1,wminf-tmin2:wmaxf-tmin2))^2)
	msd = i_msd2d(ptdef(*,wminf-tmin1:wmaxf-tmin1)*0.083,length=tlength)
	msd2 = i_msd2d(ptdef2(*,wminf-tmin2:wmaxf-tmin2)*0.083,length=tlength)

    msd[0,1] = 0.000001
    msd2[0,1] = 0.000001

	fit = mpfitexpr('P[0]*X', time2, msd[*,0], msd[*,1], [2.,0.], /quiet, bestnorm=chi1)
	fit2 = mpfitexpr('P[0]*X', time2, msd2[*,0], msd2[*,1], [2.,0.], /quiet, bestnorm=chi1)
	
	if not keyword_set(option) then option='s'
	if n_elements(ps) then begin
		thisDevice = !d.name
		set_plot,'ps'
		!p.font=0
		if singlef eq 1 then filename = 't_s_'+option+'_'+strtrim(fix(wminf),2)+'_'+strtrim(fix(wmaxf),2)+'.eps'
		if singlef eq 0 then filename = 't_d_'+option+'_'+strtrim(fix(wminf),2)+'_'+strtrim(fix(wmaxf),2)+'.eps'
		device, /color, /helvetica, /encapsul, bits=8
		device, xsize=20, ysize=20*3./4.,file=filename
	endif

	cgplot, ptdef(0,wminf-tmin1:wmaxf-tmin1)*0.083, ptdef(1,wminf-tmin1:wmaxf-tmin1)*0.083, charsize=1.0 $
		, /ynozero, xtitle='x (um)', ytitle = 'y (um)' $
		, symcolor='blk8', color='red4', psym=-16, symsize=0.3 $
		, xran=[wminx-1,wmaxx+1], yran=[wminy-1,wmaxy+1] $
		, xstyle=1, ystyle=1
	cgplots, fsc_circle(ptdef(0,wminf-tmin1)*0.083,ptdef(1,wminf-tmin1)*0.083,0.4), color='red4'
	if singlef eq 0 then begin
		cgplot, ptdef2(0,wminf-tmin2:wmaxf-tmin2)*0.083, ptdef2(1,wminf-tmin2:wmaxf-tmin2)*0.083, /overplot $
			, symcolor='blk8', color='blu4', psym=-16, symsize=0.3
		cgplots, fsc_circle(ptdef2(0,wminf-tmin2)*0.083,ptdef2(1,wminf-tmin2)*0.083,0.4), color='blu4'
	endif

	if singlef eq 0 then cgplot, time, distance*0.083, charsize=1.0 $
		, xtitle='time (sec)', ytitle='Relative Distance (um)' $
		, xstyle=1, xran=[wminf,wmaxf]*0.033,psym=-16,symsize=0.5

	cgplot, time2, msd[*,0], ystyle=1 $
		, charsize=1.0, ytitle = 'MSD (um^2)' $
		, xstyle=1, xtitle='time (sec)',psym=14,symsize=0.5
	oploterror, time2, msd[*,0],msd[*,1],psym=3, /nohat,errcolor=fsc_color('red4')
	cgplot, time2, fit[0]*time2+fit[1], /overplot, color='red6'
	if singlef then cgtext, 0.63, 0.90, 'D: '+string(fit[0]/2.,format='(F0.3)')+' (um^2/s)' $
		,/normal, charsize=1.0
	if singlef eq 0 then begin
		cgtext, 0.13, 0.40, 'D: '+string(fit[0]/2.,format='(F0.3)')+' (um^2/s)' $
		,/normal, charsize=1.0
		cgplot, time2, msd2[*,0]$
			,psym=14,symsize=0.5, /overplot
		oploterror, time2, msd2[*,0],msd2[*,1],psym=3, /nohat,errcolor=fsc_color('blu4')
		cgplot, time2, fit2[0]*time2+fit2[1], /overplot, color='blu6'
		cgtext, 0.13, 0.35, 'D: '+string(fit2[0]/2.,format='(F0.3)')+' (um^2/s)' $
			,/normal, charsize=1.0
		histoplot, distance*0.083, charsize=1.0,xtitle='Distance (um)',binsize=0.5

	endif

	if singlef eq 1 then begin
		x1 = ptdef(0,wminf-tmin1:wmaxf-tmin1)*0.083
		y1 = ptdef(1,wminf-tmin1:wmaxf-tmin1)*0.083
		ymax = max([[x1-x1(0)],[y1-y1(0)]],min=ymin)
		cgplot, time, x1-x1(0), charsize=1.0 $
			, /ynozero, xtitle='t (sec)', ytitle = 'x (um)' $
			, symcolor='blk8', color='red5', psym=-16, symsize=0.3, xstyle=1 $
			, xran=[wminf,wmaxf]*0.033, yran=[ymin,ymax]
		cgplot, time, y1-y1(0), charsize=1.0 $
			, symcolor='blk8', color='blu5', psym=-16, symsize=0.3 $
			,/overplot
	endif

	if singlef eq 1 then begin
		case option of
			'dif': if singlef then gdiffusion, ptdef, length=tlength
			'vel': begin
				if singlef then begin
					dt = 10
					vx = x1(dt-1:*)-x1(0:wmaxf-wminf-dt+1)
					vy = y1(dt-1:*)-y1(0:wmaxf-wminf-dt+1)
					v = sqrt(vx^2+vy^2)/(0.033*5)
					vmax = max(v,min=vmin)
					cgplot, time, v, charsize=1.0, /ynozero, xtitle='t (sec)' $
						, ytitle='velocity (um/s)', xran=[wminf,wmaxf-dt]*0.033, xstyle=1
				endif
				end
			else:
		endcase
	endif

	!p.multi = [0,1,1]

	if n_elements(ps) then begin
		device, /close
		set_plot, thisDevice

		case !version.os of
			'Win32': begin
			  cmd = '"c:\Program Files\Ghostgum\gsview\gsview64.exe"'
				spawn, [cmd, filename], /log_output, /noshell
				end
			'darwin': spawn, 'gv '+filename
			else: spawn, 'gv '+filename
		endcase
	endif

end

