;+
; Name: i_confview
; Purpose: show information from defect track
; Input: i_confview, ptd
; History:
;   created on 8/22/11 by SCK
;   modified on 8/25/11 by SCK - add print routine
;-

function i_confview, ptd, ps=ps

if n_elements(ptd(*,0)) ne 4 then begin
    print, 'old file'
    return, 0
endif

maxt = max(ptd(3,*), min=mint)
if maxt le 10 and mint gt 0 then begin
    nf = n_elements(ptd(0,*))
    typeArray = indgen(10)+1 
    filename = 'dmatrix_mi_'+strtrim(fix(nf),2)+'.sav'
    print, 'mono-interstitial'
endif
if maxt le 20 and mint gt 10 then begin
    nf = n_elements(ptd(0,*))
    typeArray = indgen(10)+11 
    filename = 'dmatrix_di_'+strtrim(fix(nf),2)+'.sav'
    print, 'di-interstitial'
endif
if maxt le 30 and mint gt 20 then begin
    nf = n_elements(ptd(0,*))
    typeArray = indgen(7)+21 
    filename = 'dmatrix_mv_'+strtrim(fix(nf),2)+'.sav'
    print, 'mono-vacancy'
endif
if maxt le 40 and mint gt 30 then begin
    nf = n_elements(ptd(0,*))
    typeArray = indgen(4)+31 
    filename = 'dmatrix_mv_'+strtrim(fix(nf),2)+'.sav'
    print, 'mono-vacancy'
endif

if keyword_set(ps) then begin
    psname = str_replace(filename,'sav','eps')
    thisDevice = !D.name
    set_plot,'ps'
    !p.font=0
    device,/color,/encapsul,/helvetica,bits=8
    device,xsize=17.8,ysize=17.8*4./5,file=psname
endif

;print, typeArray
nt = n_elements(typeArray)
result = fltarr(nt,nt)
typeName = make_array(nt,1,/string,value='')
for i=0,nt-1 do typeName[i] = i_typematch(typeArray[i])

print, format='(A-5,A-5,A-5,A-5,A-5,A-5,A-5,A-5,A-5,A-5,A-5,A-6,A-5)', $
    ' ',typeName,'Total','%'

!p.multi=[0,3,3]
for i=0,nt-1 do begin
    wsi = where(ptd(3,*) eq typeArray[i], wsic)
    if wsic gt 0 then begin
        result(i,*) = histogram(ptd(3,wsi+1), binsize=1, min=min(typeArray), max=max(typeArray))
        x = ptd(0,wsi+1)-ptd(0,wsi)
        y = ptd(1,wsi+1)-ptd(1,wsi)
        if i lt 9 then begin
            cgplot, x, y, psym=16,charsize=1.0,color='blu8',xran=[-30,30],yran=[-30,30] $
                ,xtitle = typeName[i],symsize=0.8,xstyle=1,ystyle=1
            cgplots,[0,0],[-30,30],color='red3',noclip=0
            cgplots,[-30,30],[0,0],color='red3',noclip=0
        endif
    endif
    print, format='(A-5,I-5,I-5,I-5,I-5,I-5,I-5,I-5,I-5,I-5,I-5,I-5,F5.2)',$
        i_typematch(typeArray(i)),result(i,*),wsic,float(wsic)/nf*100
endfor

if keyword_set(ps) then i_close,psname,thisDevice

write_gdf, result, filename
return, result
end
