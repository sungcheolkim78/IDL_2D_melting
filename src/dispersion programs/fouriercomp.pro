;Function: to calculate fourier components for specific wave vector

Function FourierComp, tt, equipos, wavex, wavey

startf = min(tt(5,*))
stopf = max(tt(5,*))
partnumber = n_elements(equipos[0,*])
ufourier = make_array(stopf-startf+1, 2, /complex)

for i= startf, stopf do begin  
    p = tt(*,where(tt(5,*) eq i))
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
                 
                 ux = p(0,j)-equipos[0,eq1]   
                 uy = p(1,j)-equipos[1,eq1]  
                 ufourierXreal =ux*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])                                      ;M direction  
                 ufourierXimg  =-ux*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYreal =uy*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYimg  =-uy*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourier(i,0) += complex(ufourierXreal,ufourierXimg)       
                 ufourier(i,1) += complex(ufourierYreal,ufourierYimg)
    endfor
    ufourier(i,*) /= sqrt(np)
    
endfor

return,ufourier

end
    
                 
 