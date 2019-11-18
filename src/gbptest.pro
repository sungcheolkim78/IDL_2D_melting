;+
; Name: gbptest
;
; Purpose: to show bplo, bphi dependence with fixed parameters
; Credit: Sungcheol Kim, 2010/12/4
;-

pro gbptest,filename,fbplo=fbplo,fbphi=fbphi,fdia=fdia,$
	fmass=fmass,fmin=fmin,tests=tests,frame=frame,normal=normal,inver=inver, $
	back=back, fsep=fsep,avi=avi, option=option

  on_error,2
	; prepare variables
    if keyword_set(normal) then normal=1 else normal=0
    if keyword_set(avi) then avi=1 else avi=0
    if not keyword_set(frame) then frame=0

    if normal and frame then a = normalimage(readjpgstack(filename, start_frame=frame-1, stop_frame=frame+1,option=option),1)
    if normal and not frame then a = normalimage(readjpgstack(filename, 0, 1, option=option),0)
    if avi then begin
        s = open_videofile(filename)
        for i=0,frame do a = read_videoframe(s,/grayscale)
        close_video,s
    endif
    if not normal and not avi then a = readjpgstack(filename,start_frame=frame,stop_frame=frame)

	temp = a
	if not keyword_set(inver) then temp = 255b - a
	if keyword_set(back) then temp = bytscl(a - back)

	if not keyword_set(fbplo) then fbplo = 1
	if not keyword_set(fbphi) then fbphi = 7
	if not keyword_set(fdia) then fdia = 9
	if not keyword_set(fmass) then fmass = 100
	if not keyword_set(fmin) then fmin = 4
	if not keyword_set(fsep) then fsep = 13
	if not keyword_set(tests) then tests = 5 
	fn = fltarr(tests)

	; prepare for ps printing
	filename = 'bptest'+strtrim(string(fbplo,format='(f0.1)'),2)+$
		'_'+strtrim(string(fbphi),2)+$
		'_'+strtrim(string(fdia),2)+$
		'_'+strtrim(string(fmass),2)+$
		'_'+strtrim(string(fmin),2)+'.eps'

	thisDevice = !D.NAME
	set_plot,'ps'
	!p.multi=[0,2,3]
	!p.font=0
	!p.thick=1.4
	!p.charsize=1.6
	device,file=filename,/encapsulate,/color,bits_per_pixel=8,/helvetica
	device,xsize=16.7,ysize=16.7*2.75/2.

	; test of bplo and bphi
	if tests/2.*0.1 ge fbplo then bplo = findgen(tests)*0.1+0.1
	if tests/2.*0.1 lt fbplo then bplo = findgen(tests)*0.1+fbplo-0.1*tests/2.

	if fbphi gt 7 then bphi = indgen(tests)*2 + fbphi - 6 $
	else if fbphi gt 5 then bphi = indgen(tests)*2 + fbphi - 4 $
	else if fbphi gt 3 then bphi = indgen(tests)*2 + fbphi - 2 $
	else if fbphi gt 1 then bphi = indegen(tests)*2 + fbphi

	fnc = fltarr(n_elements(bplo),n_elements(bphi))

    tvimage, temp
	for i=0,n_elements(bplo)-1 do begin
		for j=0,n_elements(bphi)-1 do begin
			b = bpass(temp, bplo[i], bphi[j])
			f = feature(b, fdia, fsep, masscut=fmass, min=fmin,/quiet)
			fnc(i,j) = n_elements(f(0,*))
			statusline,'bplo_test: '+strtrim(string(i),2),0,length=25
		endfor
	endfor

	cstep = (max(fnc)-min(fnc))/(tests*2.)
	ulevels = indgen(tests*2) * cstep + min(fnc)
	fsc_contour,fnc,bplo,bphi,xtitle='bplo',ytitle='bphi',/fill,levels=ulevels
	fsc_contour,fnc,bplo,bphi,/overplot,levels=ulevels,/follow,c_color=fsc_color('blu6')
	plots,[fbplo,fbplo],[min(bphi),max(bphi)],color=fsc_color('slate blue'),linestyle=2,/data
	plots,[min(bplo),max(bplo)],[fbphi,fbphi],color=fsc_color('slate blue'),linestyle=2,/data

	; test of dia
	dia = indgen(tests)*2+fbphi
	
	b = bpass(temp, fbplo, fbphi)
	for i=0,n_elements(dia)-1 do begin
		f = feature(b, dia[i], fsep, masscut=fmass, min=fmin,/quiet)
		fn(i) = n_elements(f(0,*))
		statusline,'dia_test: '+strtrim(string(i),2),0,length=25
	endfor

	fsc_plot,dia,fn,xtitle='dia',ytitle='particle number',psym=-4,xstyle=10,ystyle=10,color=fsc_color('brown'),/ynozero
	plots,[fdia,fdia],[min(fn),max(fn)],color=fsc_color('Slate Blue'),linestyle=2,/data

	; test of masscut
	f = feature(b, fdia, fsep, masscut=fmass, min=fmin, /quiet)
	massmax = max(f(2,*), min=massmin)
	mstep = (massmax - massmin)/(tests*5.)
	if fmass - tests/2.*mstep gt 0 then mass = (findgen(tests)-tests/2.)*mstep+fmass
	if fmass - tests/2.*mstep le 0 then mass = findgen(tests)*mstep
	for i=0,n_elements(mass)-1 do begin
		f = feature(b, fdia, fsep, masscut=mass[i], min=fmin,/quiet)
		fn(i) = n_elements(f(0,*))
		statusline,'masscut_test: '+strtrim(string(i),2),0,length=25
	endfor

	fsc_plot,mass,fn,xtitle='mass',ytitle='particle number',psym=-4,xstyle=10,ystyle=10,color=fsc_color('brown'),/ynozero
	plots,[fmass,fmass],[min(fn),max(fn)],color=fsc_color('Slate Blue'),linestyle=2,/data

	; test of min
	fminstep = (massmax - massmin)/(tests*25.)
	if fmin - tests/2.*fminstep gt 0 then ffmin = (findgen(tests)-tests/2.)*fminstep + fmin
	if fmin - tests/2.*fminstep le 0 then ffmin = findgen(tests)*fminstep 
	for i=0,n_elements(ffmin)-1 do begin
		f = feature(b, fdia, fsep, masscut=fmass, min=ffmin[i],/quiet)
		fn(i) = n_elements(f(0,*))
		statusline,'min_test: '+strtrim(string(i),2),0,length=25
	endfor

	fsc_plot,ffmin,fn,xtitle='min',ytitle='particle number',psym=-4,xstyle=10,ystyle=10,color=fsc_color('brown'),/ynozero
	plots,[fmin,fmin],[min(fn),max(fn)],color=fsc_color('Slate Blue'),linestyle=2,/data

	; plot final result
	f = feature(b,fdia,fsep,masscut=fmass,min=fmin)
	cghistoplot,f(0,*) mod 1,xtitle='x mod 1',ytitle='particle number'

	fsc_plot,f(3,*),f(2,*),ytitle='brightness',xtitle='radius',psym=3,xstyle=10,ystyle=10,color=fsc_color('blu7'),xminor=1,xticks=nxticks,xtickv=xtickvalues
	plots,[min(f(3,*)),max(f(3,*))],[fmass,fmass],color=fsc_color('Slate Blue'),linestyle=2,/data

	; text out
	xyouts, 0.14, 0.73, 'bplo: '+strtrim(string(fbplo),2), color=fsc_color('brown'),/normal,charsize=0.8
	xyouts, 0.23, 0.73, 'bphi: '+strtrim(string(fbphi),2), color=fsc_color('brown'),/normal,charsize=0.8
	xyouts, 0.87, 0.73, 'dia: '+strtrim(string(fdia),2),/normal, color=fsc_color('brown'),charsize=0.8
	xyouts, 0.14,0.40, 'mass: '+strtrim(string(fmass),2),/normal, color=fsc_color('brown'),charsize=0.8
	xyouts, 0.87,0.40, 'min: '+strtrim(string(fmin),2),/normal, color=fsc_color('brown'),charsize=0.8
	xyouts, 0.87,0.28, '#: '+strtrim(string(n_elements(f(0,*))),2),/normal, color=fsc_color('brown'),charsize=0.8
	area = (max(f(0,*))-min(f(0,*)))*(max(f(1,*))-min(f(1,*)))*0.083*0.083
	density = n_elements(f(0,*))/area
	xyouts, 0.82,0.30, 'density: '+string(density,format='(F5.3)'),/normal, color=fsc_color('brown'),charsize=0.8

	statusline,/close & print,' '

	device,/close
	set_plot,thisDevice
	erase
	!p.font=-1
	!p.multi=[0,1,1]

	fo = fover2d(a,f)

  case !version.os of
    'Win32': begin
	   cmd = '"c:\Program Files\Ghostgum\gsview\gsview64.exe "'
     spawn,[cmd,filename],/log_output,/noshell
     end
    'darwin':  spawn,'gv '+filename
    else:  spawn,'gv '+filename
	endcase

end
