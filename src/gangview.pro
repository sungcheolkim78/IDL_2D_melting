;+
; Name: gangview
; Purpose: show angle distribution
; Input: gangview, pt, frame, ps=ps
;-

pro gangview, pt, frame
on_error,2

if n_params() eq 1 then begin
	startf = min(pt(5,*))
	stopf = max(pt(5,*))
endif
if n_params() eq 2 then begin
	startf = frame
	stopf = frame

	set_plot,'ps'
	!p.font=0
	!p.charsize=0.8
	device,/color,/encapsul,/helvetica,bits=8
	filename = 'gang_'+strtrim(string(frame),2)+'.eps'
	device,xsize=17.8,ysize=16.0,file=filename
endif
!p.multi=[0,2,2]

for i = startf, stopf do begin
	ptc = pt(*,where(pt(5,*) eq i))

	c4 = angarr(ptc, coor=4)
	c5 = angarr(ptc, coor=5)
	c6 = angarr(ptc, coor=6)
	c7 = angarr(ptc, coor=7)
	c8 = angarr(ptc, coor=8)

	x = findgen(361)-180
	fsc_plot, x, c4, xtitle = 'Angle', ytitle='Frequency', color='blu3', $
		xstyle=1, ystyle=2, psym=-3, xticks=6, symcolor='blu7'
	fsc_text, -160, max(c4)*0.95, '4 N.N.Points', charsize=0.7, color='blu5'
	fsc_plot, x, c8, color='grn3', $
		psym=-3, symcolor='grn7', /overplot
	fsc_text, -160, max(c4)*0.90, '8 N.N.Points', charsize=0.7, color='grn5'
	fsc_plot, x, c5, xtitle = 'Angle', ytitle='Frequency', color='blu3', $
		xstyle=1, ystyle=2, psym=-3, xticks=6, symcolor='blu7'
	fsc_text, -160, max(c5)*0.95, '5 N.N.Points', charsize=0.7, color='blu5'
	fsc_plot, x, c6, xtitle = 'Angle', ytitle='Frequency', color='red3', $
		xstyle=1, ystyle=2, psym=-3, xticks=6, symcolor='red7'
	fsc_text, -160, max(c6)*0.95, '6 N.N.Points', charsize=0.7, color='red5'
	fsc_plot, x, c7, xtitle = 'Angle', ytitle='Frequency', color='blu3', $
		xstyle=1, ystyle=2, psym=-3, xticks=6, symcolor='blu7'
	fsc_text, -160, max(c7)*0.95, '7 N.N.Points', charsize=0.7, color='blu5'

	kbinput = ''
	if n_params() eq 1 then begin
		print, 'Key: Q, N, R, P    Frame: '+strtrim(i,2)
		kbinput = get_kbrd(1)
	endif

	if strcmp(kbinput,'q') then return
	if strcmp(kbinput,'r') then begin
		if i gt startf then i = i-2
	endif
	if strcmp(kbinput,'p') then begin
		set_plot,'x'
		gangview, pt, fix(i)
	endif

endfor

if n_params() eq 2 then begin
	device,/close
	set_plot,'x'
	spawn, 'gv '+filename
endif

end
