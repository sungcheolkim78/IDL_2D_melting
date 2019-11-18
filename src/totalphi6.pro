;+
; Name: totalphi6
; Purpose: Calculate average phi6 for whole frame
; Inpput: totalphi6(pt, frame)
; Limitation: to make sure deleting boundary, use density and 
; 			  mean distance
;-

function totalphi6, pt, frame, symmetry=symmetry, view=view, ref=ref
on_error,2

	if not keyword_set(symmetry) then symmetry = 6
	refc = complex(1,0)
	if keyword_set(ref) then begin
		reftheta = 2.*!pi/360.*ref
		refc = complex(cos(reftheta),sin(reftheta))
	endif
	print,refc

	; calculate boundary
	ptc = eclip(pt,[5,frame,frame])
	mdis = sqrt(640.*480./n_elements(ptc(0,*)))/2.
	w = where(ptc[0,*] ge min(ptc(0,*))+mdis $
		and ptc[0,*] le max(ptc(0,*))-mdis $
		and ptc[1,*] ge min(ptc(1,*))+mdis $
		and ptc[1,*] le max(ptc(1,*))-mdis, count)
	c = complex(fltarr(count),fltarr(count))

	triangulate, ptc(0,*),ptc(1,*),conn=con

	for i=0l,count-1 do begin
		c[i] = phi6(w(i),ptc,-1,symmetry=symmetry,con=con,/normal)*conj(refc)
		statusline,'totalphi6: '+string(i)+' of '+string(count-1),0
	endfor
	print,'totalphi6: '
	message,'boudary #: '+string(n_elements(where(abs(c) eq 0))),/inf
	tc = mean(c)
	tcr = real_part(tc)
	tci = imaginary(tc)
	aangle = 180./!pi*atan(tc,/phase)

	if keyword_set(view) then begin
		filename = 'phi_f'+strtrim(string(frame),2)+'_s'+strtrim(string(symmetry),2)+'.eps'
	set_plot,'ps'
		!p.font=0
		!p.multi=[0,2,2]
		device,/encapsul,/color,bits=8,/helvetica
		device,xsize=16,ysize=14,file = filename

		if max(abs(c)) gt 3 then bbound = 6 else bbound = 1
		fsc_plot,real_part(c),imaginary(c),psym=3,color=fsc_color('blu7'),xran=[-bbound,bbound],yran=[-bbound,bbound],xtitle='Real(phi6)',ytitle='Im(phi6)'
		histoplot,abs(c),xtitle='Abs(phi6)'
		histoplot,real_part(c),xtitle='Real(phi6)'
		histoplot,imaginary(c),xtitle='Im(phi6)'
		
		xyouts,0.65,0.96,'<|phi6|> = '+strtrim(string(mean(abs(c))),2),/normal,color=fsc_color('brown')
		xyouts,0.15,0.96,'Angle(<phi6>) = '+strtrim(string(aangle),2),/normal,color=fsc_color('brown')
		xyouts,0.15,0.93,'Total # = '+strtrim(string(count),2),/normal,color=fsc_color('brown')
		xyouts,0.15,0.47,'Re(<phi6>) = '+strtrim(string(tcr),2),/normal,color=fsc_color('brown')
		xyouts,0.65,0.47,'Im(<phi6>) = '+strtrim(string(tci),2),/normal,color=fsc_color('brown')

		device,/close
		set_plot,'x'
		!p.multi=[0,1,1]
		spawn,'gv '+filename
	endif

	return, tc
end
