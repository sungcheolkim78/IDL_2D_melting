;+
; Name: gsvchk
; Purpose: short bpass, feature check
;
;-

pro gsvchk, filen, stopf=stopf, fbplo=bplo, fbphi=bphi, fdia=dia, fmin=min, fmass=mass

	on_error,2

	mstep = 5
	if not keyword_set(bplo) then bplo = 1
	if not keyword_set(bphi) then bphi = 5
	if not keyword_set(dia) then dia = 7
	if not keyword_set(mass) then mass = 10
	if not keyword_set(min) then min = 0
	if not keyword_set(stopf) then stopf=20

	filename = filen
	spretrack,filename,bplo=bplo,bphi=bphi,dia=dia,mass=mass,min=min,/invert,/jmulti,start_frame=0,stop_frame=stopf

	ptfile = 'pt.'+filen+'_'+strtrim(string(stopf),2)
	print,ptfile
	pt = read_gdf(ptfile)

	image = readjpgstack(filen,start_frame=0,stop_frame=stopf)

	set_plot,'x'
	s = size(image)
	window, 0, xsize=s[1], ysize=s[2]

	; plot each frames
	maxframe = stopf-1
	kbinput = ''
	i = 0
	mflag = 0
	while ~strcmp(kbinput,'q') do begin
		ptt = eclip(pt,[5,i,i])
		at = image(*,*,i)
		fo = gfover(at, ptt)
		wshow,0

		print,'(Q)uit, (N)ext, (P)revious, (M)ovie, (C)apture : '+strtrim(string(i),2)
		if (~mflag) then kbinput = get_kbrd(1)

		; movie 
		if strcmp(kbinput,'m') then begin
			mflag = 1
			ms = mstep
			kbinput = ' '
		endif
		if mflag then begin
			ms = ms-1
			if (ms lt 1) then mflag = 0
		;	print,mflag,ms,i,maxframe
		endif

		; previous
		if strcmp(kbinput,'p') then begin
			if (i lt 1) then i = 0 else i-=2
		endif

		; capture
		if strcmp(kbinput,'c') then begin
			filename = 'gvc_capture_'+strtrim(string(i),2)+'png'
			write_png,filename,fo
			spawn,'xv '+filename
		endif

		if (i gt maxframe-1) then kbinput = 'q'
		i++
	endwhile

end
