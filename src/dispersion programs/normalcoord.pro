;Name:    NormalCoord
;Purpose: Draw the dispersion relation in first Brillouin Zone in K space
;Input:   tt pointer for the file "tt.DS0_100", startframe and stopframe
;
;Hisotry:
;         Created by Lichao Yu, 12:00PM 11/09/2011 Draw Dispersion Relation with defects
;         Modified by Lichao Yu, 11/14/2011 move three directions together, 6 times faster
;         add option to plot band structure
;         Modified by Lichao Yu, 01/03/2012 divide into two pros, saving normal coordinates in gdf files, eigenvalues in a text file
;                  
;         
; 

pro NormalCoord, tt, equipos, startf, stopf, theta1, space, wavenumber=wavenumber, testmode=testmode, qvalue=qvalue, direction=direction

on_error,2

if stopf gt max(tt(5,*)) then MESSAGE, "Wrong frame number."
if not keyword_set(testmode) then testmode=0   ; in test mode, default filename become "testmode", in avoid of naming confliction.
if not keyword_set(wavenumber) then    wavenumber=10  
if keyword_set(qvalue) then wavenumber=1            ; consider just one q value. Unit: 1 /pixel=12 1/um
if not keyword_set(direction) then direction=1      ; default setting is M direction

dia = 0.36
PI = 3.14159
constant = 4.78046     ; constant=kb*T*2/sqrt3= 4.78*10E-21 Joule.
                       ; if 1 pixel=0.083um, constant= 6.93927*10E-7 Joule per m2==N per m
                       ; it seems we need to add a radius thickness to modify the unit of shear modulus to N/m2=Pa
                       ; if diameter=0.36um, we get the final result to be: 1.936 Pa
constant2 = 1          ; constant2=Kb*T= 4.14*E-12 Joule


framenumber = stopf-startf+1
partnumber = n_elements(equipos[0,*])


if not keyword_set(wavenumber) then wavenumber=partnumber
 

ufourierX1 = make_array(framenumber, wavenumber, /complex)
ufourierY1 = make_array(framenumber, wavenumber, /complex)
;ufourierX2 = make_array(framenumber, wavenumber, /complex)
;ufourierY2 = make_array(framenumber, wavenumber, /complex)
;ufourierX3 = make_array(framenumber, wavenumber, /complex)
;ufourierY3 = make_array(framenumber, wavenumber, /complex)
D1 = make_array(2,2, wavenumber, /complex)
;D2 = make_array(2,2, /dcomplex)
;D3 = make_array(2,2, /dcomplex)



    for i= startf, stopf do begin   ;Fourier Transform
        print, i
        p = tt(*,where(tt(5,*) eq i))
        np = n_elements(p(0,*))
        
    
        for q=1, wavenumber do begin    ;choose discrete q array
        
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
                 
                 
                 if direction eq 1 then begin                 
                      wavex1 = q*sin(PI/3-theta1)*2*PI/sqrt(3)/space/wavenumber                                               ;M direction
                      wavey1 = q*cos(PI/3-theta1)*2*PI/sqrt(3)/space/wavenumber
                 endif                                               
                 
                 if direction eq 2 then begin  
                      wavex1 = sin(PI/3-theta1)*2*PI/sqrt(3)/space - q*sin(PI/6+theta1)*2*PI/3/space/wavenumber              ;M->K direction
                      wavey1 = cos(PI/3-theta1)*2*PI/sqrt(3)/space + q*cos(PI/6+theta1)*2*PI/3/space/wavenumber              
                 endif
                 
                 if direction eq 3 then begin  
                      wavex1 = q*sin(PI/6-theta1)*4*PI/3/space/wavenumber                                                     ;K direction        
                      wavey1 = q*cos(PI/6-theta1)*4*PI/3/space/wavenumber                                                     
                 endif
                 
                 ux = p(0,j)-equipos[0,eq1]   
                 uy = p(1,j)-equipos[1,eq1]  
                 ufourierXreal1 =ux*cos(wavex1*equipos[0,eq1]+wavey1*equipos[1,eq1])                                      ;M direction  
                 ufourierXimg1  =-ux*sin(wavex1*equipos[0,eq1]+wavey1*equipos[1,eq1])
                 ufourierYreal1 =uy*cos(wavex1*equipos[0,eq1]+wavey1*equipos[1,eq1])
                 ufourierYimg1  =-uy*sin(wavex1*equipos[0,eq1]+wavey1*equipos[1,eq1])
                 ufourierX1(i,q-1) += complex(ufourierXreal1,ufourierXimg1)       
                 ufourierY1(i,q-1) += complex(ufourierYreal1,ufourierYimg1)
                 
                 ;ufourierXreal2 =ux*cos(wavex2*equipos[0,eq1]+wavey2*equipos[1,eq1])                                      ;M->K direction  
                 ;ufourierXimg2  =-ux*sin(wavex2*equipos[0,eq1]+wavey2*equipos[1,eq1])
                 ;ufourierYreal2 =uy*cos(wavex2*equipos[0,eq1]+wavey2*equipos[1,eq1])
                 ;ufourierYimg2  =-uy*sin(wavex2*equipos[0,eq1]+wavey2*equipos[1,eq1])
                 ;ufourierX2(i,q-1) += complex(ufourierXreal2,ufourierXimg2)       
                 ;ufourierY2(i,q-1) += complex(ufourierYreal2,ufourierYimg2)
                 
                 ;ufourierXreal3 =ux*cos(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])                                      ;K direction  
                 ;ufourierXimg3  =-ux*sin(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])
                 ;ufourierYreal3 =uy*cos(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])
                 ;ufourierYimg3  =-uy*sin(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])
                 ;ufourierX3(i,q-1) += complex(ufourierXreal3,ufourierXimg3)       
                 ;ufourierY3(i,q-1) += complex(ufourierYreal3,ufourierYimg3)
                 
                
            endfor 
                           
        endfor
    endfor

    eval = make_array(2, wavenumber, /dcomplex)
    evec = make_array(2, 2, wavenumber, /dcomplex)
    Q1 = make_array(framenumber, wavenumber, /dcomplex)            ;normal coordinate
    Q2 = make_array(framenumber, wavenumber, /dcomplex)
    
    for  q=1, wavenumber do begin    ;dynamical matrix
        D1(0,0,q-1) = mean(conj(ufourierX1(*,q-1))*ufourierX1(*,q-1))                                                        ;M direction 
        D1(0,1,q-1) = mean(conj(ufourierX1(*,q-1))*ufourierY1(*,q-1))
        D1(1,0,q-1) = mean(conj(ufourierY1(*,q-1))*ufourierX1(*,q-1))
        D1(1,1,q-1) = mean(conj(ufourierY1(*,q-1))*ufourierY1(*,q-1))
        hes = ELMHES(D1(*,*,q-1))
        eval(*,q-1) = HQR(hes, /DOUBLE)                         ;eigenvalue
        evec(*,*,q-1) = eigenfunc(D1(*,*,q-1), eval(*,q-1))     ;unitary matrix

           
            Q1(*,q-1) = ufourierX1(*,q-1)*evec(0,0,q-1) + ufourierY1(*,q-1)*evec(1,0,q-1)   ;Longitudinal
            Q2(*,q-1) = ufourierX1(*,q-1)*evec(0,1,q-1) + ufourierY1(*,q-1)*evec(1,1,q-1)   ;transversal
   endfor

   q1filename = 'NC_Long_'+strtrim(string(wavenumber),2)+'_'+strtrim(string(direction),2)
   q2filename = 'NC_Tran_'+strtrim(string(wavenumber),2)+'_'+strtrim(string(direction),2)
   write_gdf, Q1, q1filename
   write_gdf, Q2, q2filename

   evalfilename = 'eval_'+strtrim(string(wavenumber),2)+'_'+strtrim(string(direction),2)+'.txt' 
   write_text, real_part(eval), evalfilename
    
end

