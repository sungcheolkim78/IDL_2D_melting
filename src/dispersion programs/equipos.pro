;
;
;       add , xmin, xmax, ymin, ymax
;
;

pro Equipos, tt, startf, stopf, xmin, xmax, ymin, ymax
    on_error,2

    PI = 3.14159

    framenumber = stopf-startf+1
    partnumber = max(tt(6,*))+1           
    equipos = fltarr(2, partnumber)
    count = intarr(partnumber)
    filename = 'equip'+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)
    
   
    ntt = n_elements(tt(0,*))
    for i = 0, ntt-1 do begin
        equipos[0,tt[6,i]] += tt[0,i]
        equipos[1,tt[6,i]] += tt[1,i]
        count[tt[6,i]] +=1
    endfor 
    

    coun3=0
    for i=0, partnumber-1 do begin
        equipos[0,i] /=count[i]   ;equilibrium position
        equipos[1,i] /=count[i]
        if  equipos[1,i] lt ymin or equipos[1,i] gt ymax or equipos[0,i] lt xmin or equipos[0,i] gt xmax then begin ;boundary
            equipos[0,i] =10000   ;set boundary to 10000 as a flag
            coun3 +=1 
        endif
    endfor
    
    equi = fltarr(2, partnumber-coun3)
    c = intarr(partnumber-coun3)
      ; eluminate boundary particles
    coun2 =0      ; coun2 == partnumber-coun3
          for i = 0, partnumber-1 do begin
              if equipos[0,i] ne 10000  then begin
                  equi[0, coun2] = equipos[0,i]
                  equi[1, coun2] = equipos[1,i]
                  c(coun2) = count(i)
                  coun2 +=1
              endif
          endfor
    
    coun1 = 0
    for i = 0, coun2-1 do begin    ; eluminate repeated particles
        if equi[0,i] eq 0 then continue
        tempx = equi[0,i]*c(i)      ; Sum
        tempy = equi[1,i]*c(i)
        tempc = c(i)
        for j = i+1, coun2-1 do begin
            if sqrt((equi[0,i]-equi(0,j))^2 + (equi[1,i]-equi(1,j))^2) lt 8 then begin
                 tempx += equi[0,j]*c(j)
                 tempy += equi[1,j]*c(j)
                 tempc += c(j)
                 equi[0,j] = 0      ;flag
                 equi[1,j] = 0
                 coun1 +=1
             endif
        endfor
        equi[0,i] = tempx/tempc
        equi[1,i] = tempy/tempc
    endfor

    equ = fltarr(2, partnumber-coun3-coun1)
    coun4 = 0
    for i = 0, partnumber-coun3-1 do begin
         if equi[0,i] ne 0  then begin
              equ[0, coun4] = equi[0,i]
              equ[1, coun4] = equi[1,i]
              coun4 +=1
         endif
     endfor
        print,partnumber, coun3, coun2, coun1, coun4      
    write_gdf,equ,filename
    
    coun = 0
    tang = 0
    for i=0, partnumber-coun3-coun1-1 do begin    ;find tilt angle
        if equ[1,i] gt ymin and equ[1,i] lt ymax and equ[0,i] gt xmin and equ[0,i] lt xmax then begin
            nn = Findnn(equ[0,*], equ[1,*], i, 1)
            if nn eq 10000 then continue
            tang +=(equ[1,nn]-equ[1,i])/(equ[0,nn]-equ[0,i])
            coun +=1
        endif   
    endfor
    
    theta1 = atan(tang/coun) ;average
    theta2 = theta1 + PI/6
    print, theta1, theta2
    
    sd=plot(equ[0,*],equ[1,*],linestyle=' ',symbol='d',symsize=1)

end