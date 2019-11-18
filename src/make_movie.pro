pro make_movie, pt

on_error, 2

ptc = eclip(pt, [5,0,0])
cgplot, ptc(0,*), ptc(1,*), psym=3, xstyle=1, ystyle=1, charsize=1.0

for i=1,500 do begin
	ptc = eclip(pt, [5,i,i])
	cgplots, ptc(0,*), ptc(1,*), psym=3
	image = cgSnapShot(filename='movie1/tt_'+strtrim(fix(i),2),/jpeg,/nodialog)
endfor

end
