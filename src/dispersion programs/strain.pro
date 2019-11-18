


Pro Strain, tt, equip, startf, stopf, theta1, space, scale=scale

on_error,2
PI = 3.14159


;if not keyword_set(xmin) then xmin = 40
;if not keyword_set(xmax) then xmax = 260
;if not keyword_set(ymin) then ymin = 40
;if not keyword_set(ymax) then ymax = 160
if not keyword_set(scale) then scale = 1

partnumber = n_elements(equip[0,*])
stra = dblarr(4, stopf-startf+1)

xx = dblarr(3)
yy = dblarr(3)
paramX = dblarr(4,partnumber)
paramY = dblarr(4,partnumber)

equipos = dblarr(4,partnumber)
equipos(0,*) = equip(0,*)
equipos(1,*) = equip(1,*)

for t= startf, stopf do begin
    print,t
    p = tt(*,where(tt(5,*) eq t))
    np = n_elements(p(0,*))

    for j=0, np-1 do begin
                flag=0
                for k=0, partnumber-1 do begin
                if sqrt((equipos[0,k]-p(0,j))^2 + (equipos[1,k]-p(1,j))^2) lt 6 then begin
                    eq1=k
                    flag=1
                    break
                endif
                endfor
                if flag ne 1 then continue
            equipos(2,eq1) = p(0,j)-equipos[0,eq1]          ;instant displacement, x component
            equipos(3,eq1) = p(1,j)-equipos[1,eq1]          ;instant displacement, y component
    endfor

    triangulate, equipos(0,*), equipos(1,*), conn=con

    ;Initializing subcell boundaries
    for m=0, (scale)^2-1 do begin                             ;only applies to "2090" event of window size: 280*200, two key parameters are 120, 200
        height = uint(m/scale)
        ymin=40+height*120/scale
        ymax=40+(height+1)*120/scale
        xmin=40+(m-height*scale)*200/scale
        xmax=40+(m-height*scale+1)*200/scale
        ;print,m,xmin,xmax,ymin,ymax
                  
    for k=0, partnumber-1 do begin
        x0 = equipos(0,k)
        y0 = equipos(1,k)
        if (x0 lt xmin) or (x0 gt xmax) or (y0 lt ymin) or (y0 gt ymax) then continue
        if con[k+1]-con[k] ne 6 then continue
        for i=con[k], con[k+1]-1 do begin
            x = equipos(0,con[i])
            y = equipos(1,con[i])
            if (x-x0) gt 0 and (y-y0) lt (x-x0) then begin
                u1x = equipos(2,con[i])
                u1y = equipos(3,con[i])
                endif
            if (x0-x) gt 0 and (y0-y) lt (x0-x) then begin
                u2x = equipos(2,con[i])
                u2y = equipos(3,con[i])
                endif
            if (x-x0) gt 0 and (y-y0) gt (x-x0) then begin
                u3x = equipos(2,con[i])
                u3y = equipos(3,con[i])
                endif
            if (x0-x) gt 0 and (y0-y) lt (x0-x) then begin
                u4x = equipos(2,con[i])
                u4y = equipos(3,con[i])
                endif
            if (x-x0) lt 0 and (y-y0) gt 0 then begin
                u5x = equipos(2,con[i])
                u5y = equipos(3,con[i])
                endif
            if (x0-x) lt 0 and (y0-y) gt 0  then begin
                u6x = equipos(2,con[i])
                u6y = equipos(3,con[i])
            endif
        endfor
       
        yy(0) = (u1x-u2x)/(2*space*cos(theta1))
        xx(0) = tan(theta1)
        yy(1) = (u3x-u4x)/(2*space*cos(theta1 + PI/3))
        xx(1) = tan(theta1 + PI/3)
        yy(2) = (u5x-u6x)/(2*space*cos(theta1 + 2*PI/3))
        xx(2) = tan(theta1 + 2*PI/3)
        ParamX(*,k) = OSLLR(xx,yy)

        yy(0) = (u1y-u2y)/(2*space*cos(theta1))
        xx(0) = tan(theta1)
        yy(1) = (u3y-u4y)/(2*space*cos(theta1 + PI/3))
        xx(1) = tan(theta1 + PI/3)
        yy(2) = (u5y-u6y)/(2*space*cos(theta1 + 2*PI/3))
        xx(2) = tan(theta1 + 2*PI/3)
        ParamY(*,k) = OSLLR(xx,yy)
  
    endfor

    count1 = 0
    count2 = 0
    for l=0, partnumber-1 do begin
        if paramX(0,l) ne 0 then count1 +=1
        if paramY(0,l) ne 0 then count2 +=1
    endfor

    stra(0,t) += Total(paramX(1,*))/count1         ;xx
    stra(1,t) += Total(paramX(0,*))/count1         ;xy
    stra(2,t) += Total(paramY(1,*))/count2         ;yx
    stra(3,t) += Total(paramY(0,*))/count2         ;yy


    endfor
    
    stra(*,t) /= scale^2
endfor


;write text files
a=dblarr(2, stopf-startf+1)
b=dblarr(2, stopf-startf+1)
a(0,*) = stra(0,*)
a(1,*) = stra(1,*)
b(0,*) = stra(2,*)
b(1,*) = stra(3,*)
filename1 = 'strain_'+strtrim(string(scale),2)+'_(1).txt'
filename2 = 'strain_'+strtrim(string(scale),2)+'_(2).txt'
write_text,a,filename1
write_text,b,filename2


end

