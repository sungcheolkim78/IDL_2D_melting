;+
; Name: gphiview
; Purpose: show delaunay triangular plot and phi distribution
;
;-

pro gphiview, pt, frame, field=field, symmetry=symmetry, view=view, ref=ref,ps=ps
on_error,2

	; setup input parameters
	if not keyword_set(field) then field = [0,640,0,480]
	if not keyword_set(symmetry) then symmetry = 6
	if not keyword_set(view) then view =0
	refc = complex(1,0)
	if keyword_set(ref) then begin
		reftheta = 2.*!pi/360.*ref
		refc = complex(cos(reftheta),sin(reftheta))
	endif
	print,refc
	if keyword_set(ps) then begin
       set_plot,'ps'
       !p.font=0
       !p.charsize=0.8
       filename = 'gphi_'+strtrim(string(frame),2)+'.eps'
       device,/color,/encapsul,/helvetica,bits=8
       device,xsize=20,ysize=15,file=filename
    endif
	pt2 = 0      ; check appended pt data
	if n_elements(pt(*,0)) eq 9 then pt2 = 1

	; prepare total characteristics
	ptc = eclip(pt,[5,frame,frame],[0,field[0],field[1]],[1,field[2],field[3]])
	nc = n_elements(ptc(0,*))
	field = float(field)
	density = nc/(field[1]-field[0])/(field[3]-field[2])
	mdis = sqrt(1./density)*1.5
	phi6arr = complex(fltarr(nc),fltarr(nc))
	nnarr = indgen(nc)

	triangulate, ptc(0,*), ptc(1,*), tr, conn=con

	; calculate phi6 for each points
	if pt2 eq 0 then begin
		for i=0l,nc-1 do begin
			phi6arr[i] = phi6(i,ptc,-1,symmetry=symmetry,con=con,/normal)*conj(refc)
			nearp = con[con[i]:con[i+1]-1]
			nnarr[i] = n_elements(nearp)
		endfor
	endif else begin
		phi6arr = complex(ptc(7,*),ptc(8,*))
		nnarr = ptc(6,*)
	endelse
    message,'boudary # - '+string(n_elements(where(abs(phi6arr) eq 0))),/inf
										
	;fsc_plot, ptc(0,*), ptc(1,*), xran=[min(ptc(0,*)),max(ptc(0,*))], yran=[min(ptc(1,*)),max(ptc(1,*))],xstyle=1,ystyle=1,/nodata

	if view eq 0 then result = abs(phi6arr) $
		else if view eq 1 then result = real_part(phi6arr) $
		else if view eq 2 then result = imaginary(phi6arr)

	c_colors = ['grn8','grn7','grn6','grn5','grn4','grn3','grn2','grn1']
	fsc_contour,result,ptc(0,*),ptc(1,*),/irregular,/fill,nlevels=8,c_colors = c_colors,xran=field[0:1],yran=field[2:3],xstyle=1,ystyle=1
	fsc_contour,result,ptc(0,*),ptc(1,*),/irregular,/overplot,nlevels=4,color=fsc_color('blk6'),c_charsize=0.5

	wr = where(ptc(0,*) gt min(ptc(0,*))+mdis and $
		ptc(0,*) lt max(ptc(0,*))-mdis and $
		ptc(1,*) gt min(ptc(1,*))+mdis and $
		ptc(1,*) lt max(ptc(1,*))-mdis, wrc)

	w = where(nnarr(wr) eq 4, wc1)
	for i=0,wc1-1 do polyfill,fsc_circle(ptc(0,wr[w[i]]),ptc(1,wr[w[i]]),3),color=fsc_color('red3')
	w = where(nnarr(wr) eq 5, wc2)
	for i=0,wc2-1 do polyfill,fsc_circle(ptc(0,wr[w[i]]),ptc(1,wr[w[i]]),3),color=fsc_color('red4')
	w = where(nnarr(wr) eq 7, wc3)
	for i=0,wc3-1 do polyfill,fsc_circle(ptc(0,wr[w[i]]),ptc(1,wr[w[i]]),3),color=fsc_color('blu4')
	w = where(nnarr(wr) eq 8, wc4)
	for i=0,wc4-1 do polyfill,fsc_circle(ptc(0,wr[w[i]]),ptc(1,wr[w[i]]),3),color=fsc_color('blu3')

	xyouts, 0.35,0.02, 'red3 = 4('+strtrim(string(wc1),2)+')', /normal, color=fsc_color('red3')
	xyouts, 0.53,0.02, 'red4 = 5('+strtrim(string(wc2),2)+')', /normal, color=fsc_color('red4')
	xyouts, 0.71,0.02, 'blu4 = 7('+strtrim(string(wc3),2)+')', /normal, color=fsc_color('blu4')
	xyouts, 0.88,0.02, 'blu3 = 8('+strtrim(string(wc4),2)+')', /normal, color=fsc_color('blu3')

	balance = -2*wc1-wc2+wc3+2*wc4
	xyouts,0.21,0.02,'Bal. = '+strtrim(string(balance),2),/normal,color=fsc_color('blk7')
	xyouts,0.03,0.02,'<|phi6|> = '+string(mean(result(wr)),format='(F5.3)'),/normal,color=fsc_color('blk7')

	if keyword_set(ps) then begin
		device,/close
		set_plot,'x'
		spawn,'gv '+filename
	endif

end
