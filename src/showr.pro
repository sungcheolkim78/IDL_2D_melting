pro showr, filename

;a = readtext('mi-sep.txt')
a = readtext(filename)

cgplot, a(0,*)/30., a(1,*), charsize=1., /window, xstyle=1, layout=[2,1,1], $
    ytitle='r(t) (um)', yran=[0,3], xtitle='Time (sec)',psym=-14,color='blk6', $
    symcolor='black', ystyle=1

cghistoplot, a(1,*), charsize=1., /addcmd, layout=[2,1,2], binsize=0.04, /frequency, $
    /fill, /rotate, ytitle='r (um)',yran=[0,3], xtitle='Hist.', xtickformat='(F4.2)'

end


