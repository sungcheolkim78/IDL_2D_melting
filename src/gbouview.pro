;+
; Name: gbouview
; Purpose: show boundary
;
;-

pro gbouview,pt,startf,stopf,ref=ref,ps=ps,options=options,histo=histo
on_error,2

if not keyword_set(options) then options=0
sflag = 0
maxf = max(pt(5,*))
if n_params() eq 1 then begin
	startf=0
	stopf=maxf-1
endif
if n_params() eq 2 then begin
	stopf = startf
	sflag = 1
endif
if n_params() eq 3 then begin
	if stopf gt maxf then begin
		print,'maxf : '+strtrim(maxf,2)
		return
	endif
	if startf gt stopf then return
endif

refc = complex(1,0)
if keyword_set(ref) then begin
	reftheta = 2.*!pi/360.*ref
	refc = complex(cos(reftheta),sin(reftheta))
endif
print,refc
print,startf,stopf

!p.multi=[0,1,1]
if keyword_set(ps) then begin
   set_plot,'ps'
   !p.font=0
   !p.charsize=0.8
   filename = 'gbou_'+strtrim(startf,2)+'_'+strtrim(stopf,2)+$
	   strtrim(options,2)+'.eps'
   device,/color,/encapsul,/helvetica,bits=8
   device,xsize=20,ysize=15,file=filename
endif

defects = 1
waittime = 1

for i = startf, stopf do begin
	; prepare total characteristics
	ptc = pt(*,where(pt(5,*) eq i))
	nff = n_elements(ptc(0,*))
	density = nff/(640*480.)
	mdis = sqrt(1./density)

	phi6arr = complex(fltarr(nff),fltarr(nff))
	phi6theta = fltarr(nff)
	nnn= indgen(nff)
	angarr = fltarr(nff)
	wr = where(ptc(0,*) gt min(ptc(0,*))+mdis and $
		ptc(0,*) lt max(ptc(0,*))-mdis and $
		ptc(1,*) gt min(ptc(1,*))+mdis and $
		ptc(1,*) lt max(ptc(1,*))-mdis, wrc)

	if n_elements(ptc(*,0)) eq 9 then begin
		phi6arr = complex(ptc(7,*),ptc(8,*))*conj(refc)
		nnn = ptc(6,*)
	endif else begin
		triangulate, ptc(0,*), ptc(1,*), tr, conn=con
		for j=0l,nff-1 do begin
			phi6arr[j] = phi6(j,ptc,-1,con=con,/normal)*conj(refc)
			phi6theta[j] = phi6(j,ptc,-1,con=con,/orient)
			nearp = con[con[j]:con[j+1]-1]
			nnn[j] = n_elements(nearp)
		endfor
	endelse

	angarr = (atan(phi6arr,/phase)*30./!pi)

	c_colors=['blk8','grn8','grn7','grn6','grn5','grn4','grn3','grn2','grn1','blk1']
	if options eq 0 then begin
		if keyword_set(histo) then begin
			histoplot, angarr
		endif else begin
			;alevels=[-30,-22.5,-15,-7.5,0,7.5,15,22.5,30]
			alevels=[-15,-12,-9,-6,-3,0,3,6,9,12,15]
			fsc_contour,phi6theta,ptc(0,*),ptc(1,*),/irregular,/fill,$
			levels=alevels,c_colors = c_colors,xran=[0,640],$
			yran=[0,480],xstyle=1,ystyle=1
		endelse
	endif
	if options eq 1 then fsc_contour,abs(phi6arr),ptc(0,*),ptc(1,*),/irregular,/fill,$
		nlevels=8,c_colors = c_colors,xran=[0,640],$
		yran=[0,480],xstyle=1,ystyle=1
	if options eq 2 then fsc_contour,nnn,ptc(0,*),ptc(1,*),/irregular,/fill,$
		nlevels=8,c_colors = c_colors,xran=[0,640],$
		yran=[0,480],xstyle=1,ystyle=1
	if options eq 3 then fsc_contour,phi6theta,ptc(0,*),ptc(1,*),/irregular,/fill,$
		nlevels=8,c_colors = c_colors,xran=[0,640],$
		yran=[0,480],xstyle=1,ystyle=1
	if options eq 4 then fsc_contour,real_part(phi6arr),ptc(0,*),ptc(1,*),/irregular,/fill,$
		nlevels=8,c_colors = c_colors,xran=[0,640],$
		yran=[0,480],xstyle=1,ystyle=1

	if defects eq 1 then begin
		w4 = where(nnn(wr) eq 4, w4c)
		w5 = where(nnn(wr) eq 5, w5c)
		w7 = where(nnn(wr) eq 7, w7c)
		w8 = where(nnn(wr) eq 8, w8c)

		if w4c gt 0 then fsc_plot,ptc(0,wr(w4)),ptc(1,wr(w4)),psym=14, symcolor='red3',/overplot
		if w5c gt 0 then fsc_plot,ptc(0,wr(w5)),ptc(1,wr(w5)),psym=14, symcolor='red4',/overplot
		if w7c gt 0 then fsc_plot,ptc(0,wr(w7)),ptc(1,wr(w7)),psym=14, symcolor='blu4',/overplot
		if w8c gt 0 then fsc_plot,ptc(0,wr(w8)),ptc(1,wr(w8)),psym=14, symcolor='blu3',/overplot
	endif

	print,'Key: Q, N, P, D, M	Frame: '+strtrim(i,2)
	kbinput = ''
	if sflag ne 1 then kbinput = get_kbrd(waittime)

	if strcmp(kbinput,'m') then waittime = ~waittime
	if strcmp(kbinput,'d') then defects = ~defects
	if strcmp(kbinput,'q') then return
	if strcmp(kbinput,'p') then begin
		if i gt 0 then i = i-2
	endif

endfor

if keyword_set(ps) then begin
	device,/close
	set_plot,'x'
	spawn,'gv '+filename
endif

end
