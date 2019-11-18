pro gshowmsd, s1, s2
on_error,2

set_plot,'ps'
!p.font=0
device,/color,/helvetica,/encapsul,bits=8
device,xsize=14,ysize=14*0.8,file='msd.eps'

tlength = n_elements(s1(1,*)) > n_elements(s2(1,*))
t = indgen(tlength)/30.

fsc_plot, t, s1(0,*)*0.083*0.083, xtitle='Time (sec)', ytitle = $
	ps_symbol('<')+'X!U2!N'+ps_symbol('>')+' ('+ps_symbol('mu')+$
	'm!U2!N)',xstyle=1,/nodata
oploterror, t, s1(0,*)*0.083*0.083, s1(1,*)*0.083*0.083, color='red2'
fsc_plot, t, s1(0,*)*0.083*0.083,/overplot, color='red6'
oploterror, t, s2(0,*)*0.083*0.083, s2(1,*)*0.083*0.083, color='grn2'
fsc_plot, t, s2(0,*)*0.083*0.083,/overplot, color='grn6'

colorsn = [fsc_color('red6'),fsc_color('grn6')]
al_legend, ['d=1.5','d=2.0'], psym = [3,3], colors=colorsn,textcolors=colorsn

device,/close
spawn, 'gv msd.eps'
set_plot,'x'

end
