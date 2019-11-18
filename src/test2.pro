pro test2
	cgplot, (s_msd(randomwalker(10000),length=30,/quiet))[*,0],charsize=1.

	for i=0,100 do begin
		cgplot, (s_msd(randomwalker(10000,seed=i),length=30,/quiet))[*,0],/overplot
	endfor
end
