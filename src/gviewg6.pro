;+
; Name: gviewg6
; Purpose: show graph of g6 data
; Input: g6 data (0,*) - rvec
;				 (1,*) - g6rr
;				 (2,*) - g6ri
;				 (3,*) - gr
;-

function myfunc1,x,p
	return, p[1]*exp(-1.*x/p[0])*(sin(2.*!pi/p[2]*x+p[3]))
end

function myfunc2,x,p
	return, p[0]+p[1]*exp(-1.*(x-p[2])/p[3])*cos(2.*!pi/p[4]*x)
end

pro gviewg6, g6r, prefix=prefix

	if not keyword_set(prefix) then prefix = 'gr6_'
	disperpix = 0.083
	g6rr = sqrt(g6r(1,*)^2+g6r(2,*)^2)
	g6rr = g6rr > 1e-6
	g6r(4,*) = g6r(4,*) > 1e-6
	g6r(6,*) = g6r(6,*) > 1e-6

	start = [50.,0.1,8.,7.]
	fitresult = mpfitfun('myfunc1',g6r(0,*),g6rr,g6r(4,*),start,/weights)
	start2 = [1.,6.,9.,2.,9.]
	fitresult2 = mpfitfun('myfunc2',g6r(0,*),g6r(3,*),g6r(6,*),start2,/weights)

	set_plot,'ps'
	!p.font=0
	!p.multi=[0,2,2]
	device,/color,/helvetica,/encap,bits=8
	device,xsize=17.6,ysize=15,file = prefix+'view.eps'

	fsc_plot,g6r(0,*)*disperpix,g6rr,ytitle='|g6(r)|',color='blu7',xstyle=1
	;fsc_plot,g6r(0,*)*disperpix,myfunc1(g6r(0,*),fitresult)$
	;	,color='tan7',/overplot
	;xyouts,0.20,0.90,'~exp(-r/r0), r0= '+string(fitresult(1)*disperpix,format='(F6.4)'),/normal,color=fsc_color('brown')

	fsc_plot,g6r(0,*)*disperpix,g6r(1,*),ytitle='g6(r) - Re,Im',color='blu5',xstyle=1
	fsc_plot,g6r(0,*)*disperpix,g6r(2,*),color='red5',/overplot

	fsc_plot,g6r(0,*)*disperpix,g6r(3,*),ytitle='g(r)',color='grn7',xstyle=1
	;fsc_plot,g6r(0,*)*disperpix,myfunc2(g6r(0,*),fitresult2),color='blk7',/overplot
	;xyouts,0.20,0.40,'~exp(-r/r0), r0= '+string(fitresult2(1)*disperpix,format='(F6.4)'),/normal,color=fsc_color('brown')
	
	fsc_plot,g6r(0,*)*disperpix,g6r(6,*),ytitle='err - g(r), Re,Im(g6)',color='grn5',xstyle=1
	fsc_plot,g6r(0,*)*disperpix,g6r(5,*),color='red5',/overplot
	fsc_plot,g6r(0,*)*disperpix,g6r(4,*),color='blu5',/overplot

	device,/close
	set_plot,'x'
	!p.multi=[0,1,1]

	spawn,'gv '+prefix+'view.eps'

end
