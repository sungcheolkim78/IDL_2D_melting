;+ 
; Name: aptinfo
; Purpose: show time-dependent pt info - <|phi6|>, # of 4,5,6,7,8
; Input: aptinfo, pt, startf=startf, endf=endf, prefix=prefix
;
;-

pro aptinfo, pt, startf=startf, endf=endf, prefix=prefix

	if not keyword_set(startf) then startf = 0
	nf = max(pt(5,*))+1
	if not keyword_set(endf) then endf = nf-1
	if not keyword_set(prefix) then prefix='ptinfo'
	filename = prefix+strtrim(string(startf),2)+'_'+strtrim(string(endf),2)+'.eps'
	if keyword_set(ps) then begin
		set_plot,'ps'
		!p.font=0
		device,/color,/helvetica,/encapsul,bits=8
		device,xsize=16,ysize=22,file=filename
	endif

	nff = endf-startf+1
	avrphi = fltarr(nff)
	nhist = intarr(nff,7)

	for i=0,nff-1 do begin
		ptc = pt(*,where(pt(5,*) eq i+startf))
		particlen = n_elements(ptc(0,*))
		mdis = sqrt(640.*480./particlen)*1.5
		w = where(ptc[0,*] ge min(ptc(0,*))+mdis $
	        and ptc[0,*] le max(ptc(0,*))-mdis $
	        and ptc[1,*] ge min(ptc(1,*))+mdis $
	        and ptc[1,*] le max(ptc(1,*))-mdis, count)
		phiarr = complex(fltarr(count),fltarr(count))
		nnarr = intarr(count)

		triangulate, ptc(0,*),ptc(1,*),conn=con

		for j=0l,count-1 do begin
			phiarr[j] = phi6(w(j),ptc,-1,con=con,/normal)
			nearp = con[con[w(j)]:con[w(j)+1]-1]
			nnarr[j] = n_elements(nearp)
		endfor

		avrphi(i) = mean(abs(phiarr))
		nhist(i,*) = histogram(nnarr,min=3,max=9)

		statusline,string(i)+' of '+string(nff-1),0
	endfor
	print,' '

	timev = indgen(nff)+startf
	!p.multi=[0,2,3]
	fsc_plot,timev,avrphi,xran=[startf,endf],color='blu7',ytitle='<|phi|>',/ynozero
	fsc_plot,timev,nhist(*,1),xran=[startf,endf],color='red3',ytitle='4',psym=-2
	fsc_plot,timev,nhist(*,5),color='blu3',psym=-2,/overplot
	fsc_plot,timev,nhist(*,2),xran=[startf,endf],color='red4',ytitle='5',psym=-2
	fsc_plot,timev,nhist(*,4),color='blu4',psym=-2,/overplot
	fsc_plot,total(nhist(*,*),1)/nff,color='brown',psym=-4

	bal = 3*nhist(*,6)-3*nhist(*,0)+2*nhist(*,5)-2*nhist(*,1)+nhist(*,4)-nhist(*,2)
	fsc_plot,timev,bal,xran=[startf,endf],color='grn6'
	!p.multi=[0,1,1]
end

