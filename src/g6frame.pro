;+
; Name: g6frame
; Purpose: calculate g6(r) distribution
; Input: result = g6frame(pt,frame,symmetry)
;-

function g6frame, pt, sframe, eframe, symmetry=symmetry, rmin=rmin, rmax=rmax, dr = dr, quiets=quiets
on_error, 2

	mupixel = 0.083
	if not keyword_set(symmetry) then symmetry = 6
	if not keyword_set(rmin) then rmin = 0
	if not keyword_set(rmax) then rmax = 100
	if not keyword_set(dr) then dr = 1.

	; calculate total characteristics
	nr = (float(rmax)-float(rmin))/float(dr)+1
	rvec = findgen(nr)*dr+rmin
	result = fltarr(7,nr)
	result(0,*) = rvec
	nf = eframe - sframe + 1
	mphi = fltarr(nf)

	for q = 0, nf-1 do begin
		ptc = pt(*,where(pt(5,*) eq q))
		nc = n_elements(ptc(0,*))
		density = nc/(640.*480.)
		mdis = sqrt(1./density)*1.5
		if n_elements(ptc(*,0)) eq 9 then phiarr = complex(ptc(7,*),ptc(8,*))
		if n_elements(ptc(*,0)) ne 9 then phiarr = phi6arr(ptc)
			
		mphi[q] = mean(abs(phiarr))

		; show information
		if not keyword_set(quiets) then begin
			message,'frame = '+string(q+sframe),/inf
			message,'mean distance = '+string(mdis*mupixel,format='(F5.2)'),/inf
			message,'total # = '+string(nc),/inf
		endif
		message,'<|phi6(r)|> = '+string(mphi[q],format='(F5.3)')+ ' of '+string(q+sframe),/inf
	
		; select boundary for rmax distance
		w2= where(ptc[0,*] ge min(ptc(0,*))+mdis+rmax $
			and ptc[0,*] le max(ptc(0,*))-mdis-rmax $
			and ptc[1,*] ge min(ptc(1,*))+mdis+rmax $
			and ptc[1,*] le max(ptc(1,*))-mdis-rmax, count2)

		gr = fltarr(count2,nr)
		g6rr = fltarr(count2,nr)
		g6ri = fltarr(count2,nr)
		fgrerr = fltarr(nr)
		fg6rrerr = fltarr(nr)
		fg6rierr = fltarr(nr)

		; calculate bond orientational order
		for i=0l,count2-1 do begin
			rx = ptc(0,*) - ptc(0,w2[i])
			ry = ptc(1,*) - ptc(1,w2[i])
			rr = sqrt(rx^2+ry^2)

			for j=0l,nr-1 do begin
				w3 = where((rr gt rvec[j]) and (rr le rvec[j]+dr),count3)
				if count3 eq 0 then begin
					gr(i,j) = 0
					g6rr(i,j) = 0 
					g6ri(i,j) = 0
				endif else begin
					; calculate gr
					area = 2.*!pi*(rvec[j]+dr)*dr
					gr(i,j) = count3/(area*density)

					; calculate <phi6*(0)*phi6(r)>
					phi0r = conj(phiarr[w2[i]])*phiarr[w3]
					g6rr(i,j) = real_part(total(phi0r/(area*density)))
					g6ri(i,j) = imaginary(total(phi0r/(area*density)))
				endelse
			endfor
			if not keyword_set(quiets) then statusline, ': '+string(i) + ' of'+string(count2-1),0
		endfor
		if not keyword_set(quiets) then print,': '

		fgr = total(gr,1)/count2
		fg6rr = total(g6rr,1)/count2
		fg6ri = total(g6ri,1)/count2

		for tmp = 0,nr-1 do begin
			fgrerr(tmp) = mean(gr(*,tmp)^2)-mean(gr(*,tmp))^2
			fg6rrerr(tmp) = mean(g6rr(*,tmp)^2)-mean(g6rr(*,tmp))^2
			fg6rierr(tmp) = mean(g6ri(*,tmp)^2)-mean(g6ri(*,tmp))^2
		endfor

		result(1,*) += fg6rr
		result(2,*) += fg6ri
		result(3,*) += fgr
		result(4,*) += fg6rrerr
		result(5,*) += fg6rierr
		result(6,*) += fgrerr

		if not keyword_set(quiets) then begin
			!p.multi=[0,2,1]
			absg6r = sqrt(result(1,*)^2+result(2,*)^2)
			plot,result(0,*)*mupixel,absg6r/result(3,*)
			plot,result(0,*)*mupixel,result(3,*)/(q+1)
			xyouts,0.15,0.9,'<|phi|>= '+strtrim(string(mphi[q])),/normal
			!p.multi=[0,1,1]
		endif

	endfor

	result(1,*) = result(1,*)/result(3,*)
	result(2,*) = result(2,*)/result(3,*)
	result(3,*) = result(3,*)/float(nf)
	result(4,*) = result(4,*)/float(nf)
	result(5,*) = result(5,*)/float(nf)
	result(6,*) = result(6,*)/float(nf)

	if not keyword_set(quiets) then begin
		!p.multi=[0,2,1]
		absg6r = sqrt(result(1,*)^2+result(2,*)^2)
		plot,result(0,*),absg6r
		plot,result(0,*),result(3,*)
		xyouts,0.15,0.9,'<|phi|>= '+strtrim(string(mean(mphi))),/normal
		!p.multi=[0,1,1]
	endif

	tmphi = mean(mphi)

	gfilename = 'gr6.info'+strtrim(string(sframe),2)+'_'+ $
		strtrim(string(eframe),2)+'_'+string(dr,format='(F4.2)')
	write_gdf,result,gfilename

	return, result
end
