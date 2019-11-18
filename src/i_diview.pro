;+
; Name: i_diview
; Purpose: show di interstitial information from defect track
; Input: i_diview, ptd
; History:
;   created on 8/25/11 by SCK
;-

function i_diview, ptd_temp, ps=ps, short=short,polar=polar

ptd = ptd_temp

if n_elements(ptd(*,0)) ne 4 then begin
    print, 'old file'
    return, 0
endif

maxt = max(ptd(3,*), min=mint)
if maxt le 20 and mint gt 10 then begin
    nf = n_elements(ptd(0,*))
    typeArray = indgen(10)+11 
    filename = 'dmatrix_di_'+strtrim(fix(nf),2)+'.sav2'
    print, 'di-interstitial'
endif else begin
    print, 'Not di-intersitital'
    return,0
endelse

if keyword_set(ps) then begin
    psname = str_replace(filename,'sav2','eps')
    if keyword_set(polar) then psname = 'p_'+psname
    thisDevice = !D.name
    set_plot,'ps'
    !p.font=0
    device,/color,/encapsul,/helvetica,bits=8
    device,xsize=17.8,ysize=17.8*4.35/5,file=psname
endif

;print, typeArray
nt = n_elements(typeArray)
result = fltarr(nt,nt)
typeName = make_array(nt,1,/string,value='')
for i=0,nt-1 do typeName[i] = i_typematch(typeArray[i])

;merge some categories
if keyword_set(short) then begin
    for i=0,n_elements(ptd(3,*))-1 do begin
        case fix(ptd(3,i)) of
        ;15: ptd(3,i) = 12  ; DI23b -> DI2d
        16: ptd(3,i) = 13  ; DI34b -> DI3d
        17: ptd(3,i) = 13  ; DI6 -> DI3d
        19: ptd(3,i) = 13  ; DI3a -> DI3d
        20: ptd(3,i) = 14 ; DI4a -> DI4d
        else:
        endcase
    endfor
endif

print, format='(A-5,A-5,A-5,A-5,A-5,A-5,A-5,A-5,A-5,A-5,A-5,A-6,A-5)', $
    ' ',typeName,'Total','%'

if keyword_set(short) then !p.multi=[0,2,2] else !p.multi=[0,3,3]
for i=0,nt-1 do begin
    wsi = where(ptd(3,*) eq typeArray[i], wsic)
    if wsic gt 0 then begin
        result(i,*) = histogram(ptd(3,wsi+1), binsize=1, min=min(typeArray), max=max(typeArray))
        x = (ptd(0,wsi+1)-ptd(0,wsi)) < 100
        y = (ptd(1,wsi+1)-ptd(1,wsi)) < 100
        if i gt 0 and i lt 9 then begin
            if not keyword_set(polar) then begin
                cgplot, x*0.083, y*0.083, psym=16,charsize=1.0,color='blu8',xran=[-30,30]*0.083,yran=[-30,30]*0.083 $
                    ,xtitle = typeName[i],symsize=0.8,xstyle=1,ystyle=1
                cgplots,[0,0]*0.083,[-30,30]*0.083,color='red3',noclip=0
                cgplots,[-30,30]*0.083,[0,0]*0.083,color='red3',noclip=0
            endif
            if keyword_set(polar) then begin
                theta = atan(y,x)
                htheta = histogram(theta,min=-!pi,max=!pi,nbins=60)
                htheta = [htheta,htheta(0)]
                rr = max(htheta/float(wsic))
                cgplot, htheta/float(wsic), indgen(61)*2.*!pi/60.-!pi,/polar,$
                    charsize=1.0, xtitle=typeName[i],psym=-16,symsize=0.5,symcolor='blk7',$
                    xran=[-rr,rr],yran=[-rr,rr],xstyle=1,ystyle=1,color='blk4'
                cgplot,/polar,[0,1.5*rr],[22.0*!pi/180.,22.0*!pi/180.],color='red4',/overplot
            endif
        endif
    endif
    print, format='(A-5,I-5,I-5,I-5,I-5,I-5,I-5,I-5,I-5,I-5,I-5,I-5,F5.2)',$
        i_typematch(typeArray(i)),result(i,*),wsic,float(wsic)/nf*100
endfor

if keyword_set(ps) then i_close,psname,thisDevice

write_gdf, result, filename
return, result
end
