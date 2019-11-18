;+
; Name: dc
; Purpose: calculate diffusion constant from mean square displacement
; Input: dc, 'tpt filename'
; History: created by sungcheol kim, 12/19/11
;-

; ---------------------------------------
function dc_substraction, tpt0, xy
    nt = n_elements(tpt0(0,0,*))

    maxt = max(tpt0(1,0,*))
    plot, indgen(maxt), /nodata
    for i=0, nt-1 do begin
        ww = where(tpt0(xy,*,i) eq 0, wwc)
        if ww[0] gt tpt0(xy,0,i) then print, 'mis-match '+strtrim(ww[0],2)+' '+strtrim(tpt0(xy,0,i),2)
        tlength = tpt0(xy, 0, i)
        x = indgen(tlength)
        y = tpt0(xy,1:tlength,i)
        dy = y(1:*)-y(0:tlength-2)
        
        fit = mpfitexpr('P[0]+P[1]*X+P[2]*X^2',x,y,err,[y[0],mean(dy),0.001],/weight)
        ;fit = poly_fit(x, y, 2, sigma=sigma)
        ;fit = linfit(x, y, sigma=sigma)
        tempy = y - (fit[0]+fit[1]*x+fit[2]*x^2)
        tpt0(xy,1:tlength,i) = tempy
        print, transpose(fit)
        plots, x, tempy
    endfor

    return, tpt0
end

; ----------------------------------------
function dc_getdx, tpt0, d, xy
    nt = n_elements(tpt0(0,0,*))
    result = [0]

    for i=0,nt-1 do begin
        tlength = tpt0(xy,0,i)
        x = indgen(tlength)
        y = tpt0(xy,1:tlength,i)
        dy = y(d:tlength-1)-y(0:tlength-d-1)
        result = [result, dy]
    endfor

    return, result[1:*]
end

pro dc, filename, option=option

tpt = read_gdf(filename)

; parameters
dis = [1, 2, 3, 4, 5]
tcoff = [0,0,0]
coff = fltarr(3,n_elements(dis))

; select x or y axis
if not keyword_set(option) then option = 0

case option of
    0: begin
        xy = 1
        ttpt = dc_substraction(tpt,xy)
        end
    1: begin
        xy = 0
        ttpt = tpt
        end
    2: begin
        xy = 1
        ttpt = tpt
        end
    3: begin
        xy = 0
        ttpt = dc_substraction(tpt,xy)
        end
    else:
endcase

; get displacement
dtpt = dc_getdx(ttpt,dis[0],xy)

; plot displacement and find gaussian fitting parameters
plot_hist, dtpt, data, tcoff, /fit, charsize=1., wmulti=[0,2,3], /center, /window
coff(*,0) = transpose(tcoff)

for i=1,n_elements(dis)-1 do begin

    dtpt = dc_getdx(ttpt,dis[i],xy)
    plot_hist, dtpt, data, tcoff, /fit, charsize=1., /addcmd, /center, /window
    coff(*,i) = transpose(tcoff)

endfor

x = [0, dis]
cgplot, dis, coff(2,*)^2, charsize=1., /addcmd, /window, psym=14, xran=[0,5]
fit = linfit(dis, coff(2,*)^2)
cgplots, x, fit[0]+fit[1]*x, linestyle=3, color='red5', /window, /addcmd
cgtext, dis[1], fit[0]+fit[1]*dis[1], 'y='+strcompress(string(fit[0],format='(g9.4)'))+' '+$
    strcompress(string(fit[1],format='(g9.4)'))+'x', /window, /addcmd, charsize=1.

end
