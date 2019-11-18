;Name:    Displacement
;Purpose: Draw the displacement relation with q
;Input:   tt pointer for the file "tt.DS0_100", startframe and stopframe, equip pointer from 'equip0_187'
;
;Hisotry:
;         Created by Lichao Yu, 05:00PM 11/17/2011 
;         
;         
;                  
;         
; 



function Findnn, x, y, index, factor, partn=partn
    flag = 0
    np = n_elements(x)
    for i = 0, np-1 do begin
        
        dis = sqrt((x(i)-x(index))^2 + (y(i)-y(index))^2)
        if dis lt 13.5*factor and dis gt 12.5*factor and (x(i)-x(index)) gt 0 then begin
            case partn of
                +1:   if (y(i)-y(index)) gt 1.73*(x(i)-x(index)) then begin 
                          rightindex = i
                          flag = 1
                      endif            
                -1:   if (-y(i)+y(index)) lt 1.73*(x(i)-x(index)) and (-y(i)+y(index)) gt 0.577*(x(i)-x(index)) then begin 
                          rightindex = i
                          flag = 1
                      endif   
                 0:   if (y(i)-y(index)) gt 0 and 1.73*(y(i)-y(index)) lt (x(i)-x(index)) then begin 
                          rightindex = i
                          flag = 1
                      endif                   
            endcase
            if flag then break
        endif
    endfor
    
    if not flag then rightindex=10000
    return, rightindex    
end


pro displacement, tt, equipos, startf, stopf, theta1, space, wavenumber=wavenumber, testmode=testmode
on_error,2




if not keyword_set(testmode) then testmode=0   ; in test mode, default filename become "testmode", in avoid of naming confliction.



 filename = 'testmode.eps'
 wffilename = 'wf.DISP'+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)+'_'+strtrim(string(wavenumber),2)
 if not testmode then filename = 'DisplacementPlot_'+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)+ $
                                  '_wavenumber='+strtrim(string(wavenumber),2)+'.eps'
  thisDevice = !D.NAME
  set_plot,'ps'
  !p.font=0
  ;!p.thick=1.4
  ;!p.charsize=1.6
  device,file=filename,/encapsulate,/color,bits_per_pixel=8,/helvetica

dia = 0.36
PI = 3.14159
constant = 4.78046     ; constant=kb*T*2/sqrt3= 4.78*10E-21 Joule.
                       ; if 1 pixel=0.083um, constant= 6.93927*10E-7 Joule per m2==N per m
                       ; it seems we need to add a radius thickness to modify the unit of shear modulus to N/m2=Pa
                       ; if diameter=0.36um, we get the final result to be: 1.936 Pa
constant2 = 1          ; constant2=Kb*T= 4.14*E-12 Joule


framenumber = stopf-startf+1
partnumber = n_elements(equipos[0,*])
shear = dblarr(framenumber, partnumber)


if not keyword_set(wavenumber) then wavenumber=partnumber
 

ufourierX1 = make_array(framenumber, wavenumber, /complex)
ufourierY1 = make_array(framenumber, wavenumber, /complex)
;ufourierX2 = make_array(framenumber, wavenumber, /complex)
;ufourierY2 = make_array(framenumber, wavenumber, /complex)
ufourierX3 = make_array(framenumber, wavenumber, /complex)
ufourierY3 = make_array(framenumber, wavenumber, /complex)
D1 = make_array(2,2, wavenumber, /complex)
;D2 = make_array(2,2, wavenumber, /complex)
D3 = make_array(2,2, wavenumber, /complex)
;freq1 = fltarr(2, wavenumber)
;freq2 = fltarr(2, wavenumber)
;freq3 = fltarr(2, wavenumber)

;f = fltarr(6*wavenumber)
;wav = fltarr(6*wavenumber)
;wf = fltarr(2, 6*wavenumber)


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
                 wavex1 = q*sin(PI/3-theta1)*2*PI/sqrt(3)/space/wavenumber                                               ;M direction
                 wavey1 = q*cos(PI/3-theta1)*2*PI/sqrt(3)/space/wavenumber                                               ;M direction
                
                 wavex3 = q*sin(PI/6-theta1)*4*PI/3/space/wavenumber                                                     ;K direction        
                 wavey3 = q*cos(PI/6-theta1)*4*PI/3/space/wavenumber                                                     ;K direction
                 
                 ux = p(0,j)-equipos[0,eq1]   
                 uy = p(1,j)-equipos[1,eq1]  
                 ufourierXreal1 =ux*cos(wavex1*equipos[0,eq1]+wavey1*equipos[1,eq1])                                      ;M direction  
                 ufourierXimg1  =-ux*sin(wavex1*equipos[0,eq1]+wavey1*equipos[1,eq1])
                 ufourierYreal1 =uy*cos(wavex1*equipos[0,eq1]+wavey1*equipos[1,eq1])
                 ufourierYimg1  =-uy*sin(wavex1*equipos[0,eq1]+wavey1*equipos[1,eq1])
                 ufourierX1(i,q-1) += complex(ufourierXreal1,ufourierXimg1)       
                 ufourierY1(i,q-1) += complex(ufourierYreal1,ufourierYimg1)
                 
                
                 ufourierXreal3 =ux*cos(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])                                      ;K direction  
                 ufourierXimg3  =-ux*sin(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])
                 ufourierYreal3 =uy*cos(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])
                 ufourierYimg3  =-uy*sin(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])
                 ufourierX3(i,q-1) += complex(ufourierXreal3,ufourierXimg3)       
                 ufourierY3(i,q-1) += complex(ufourierYreal3,ufourierYimg3)
                 
                
            endfor 
                           
        endfor
    endfor

dis1 = fltarr(2, wavenumber)
dis3 = fltarr(2, wavenumber)
wav1 = fltarr(wavenumber) 
wav3 = fltarr(wavenumber) 
 
    for  q=1, wavenumber do begin    ;dynamical matrix
    
        wavex1 = q*sin(PI/3-theta1)*2*PI/sqrt(3)/space/wavenumber                                               ;M direction
        wavey1 = q*cos(PI/3-theta1)*2*PI/sqrt(3)/space/wavenumber                                               ;M direction
        wav1(q-1) =  q*2*PI/sqrt(3)/wavenumber
               
        wavex3 = q*sin(PI/6-theta1)*4*PI/3/space/wavenumber                                                     ;K direction        
        wavey3 = q*cos(PI/6-theta1)*4*PI/3/space/wavenumber
        wav3(q-1) =  q*4*PI/3/wavenumber                                                     ;K direction
                 
        D1(0,0,q-1) = mean(conj(ufourierX1(*,q-1))*ufourierX1(*,q-1))                                                        ;M direction 
        D1(0,1,q-1) = mean(conj(ufourierX1(*,q-1))*ufourierY1(*,q-1))
        D1(1,0,q-1) = mean(conj(ufourierY1(*,q-1))*ufourierX1(*,q-1))
        D1(1,1,q-1) = mean(conj(ufourierY1(*,q-1))*ufourierY1(*,q-1))
        dis1[0,q-1] = D1(0,0,q-1)*wavex1*wavex1+D1(0,1,q-1)*wavex1*wavey1+D1(1,0,q-1)*wavex1*wavey1+D1(1,1,q-1)*wavey1*wavey1     ;parallel
        dis1[1,q-1] = D1(0,0,q-1)*wavey1*wavey1-D1(0,1,q-1)*wavex1*wavey1-D1(1,0,q-1)*wavex1*wavey1+D1(1,1,q-1)*wavex1*wavex1     ;perpendicular
       
        D3(0,0,q-1) = mean(conj(ufourierX3(*,q-1))*ufourierX3(*,q-1))                                                           ;K direction 
        D3(0,1,q-1) = mean(conj(ufourierX3(*,q-1))*ufourierY3(*,q-1))
        D3(1,0,q-1) = mean(conj(ufourierY3(*,q-1))*ufourierX3(*,q-1))
        D3(1,1,q-1) = mean(conj(ufourierY3(*,q-1))*ufourierY3(*,q-1))
        dis3[0,q-1] = D3(0,0,q-1)*wavex3*wavex3+D3(0,1,q-1)*wavex3*wavey3+D3(1,0,q-1)*wavex3*wavey3+D3(1,1,q-1)*wavey3*wavey3
        dis3[1,q-1] = D3(0,0,q-1)*wavey3*wavey3-D3(0,1,q-1)*wavex3*wavey3-D3(1,0,q-1)*wavex3*wavey3+D3(1,1,q-1)*wavex3*wavex3
        
    endfor
    


 
   
 
;wf[0,*] = wav
;wf[1,*] = f
;write_gdf,wf,wffilename    

cgplot, wav1, dis1[0,*], xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='red', xtitle='q a', ytitle='D'                          ;parallel, M direction
cgplot, wav1, dis1[1,*], xstyle=1, ystyle=1, psym=5, symsize=1.3, symcolor='blue', xtitle='q a', ytitle='D', /overplot              ;perpendicular, M direction
cgplot, wav3, dis3[0,*], xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='green', xtitle='q a', ytitle='D', /overplot             ;parallel, K direction
cgplot, wav3, dis3[1,*], xstyle=1, ystyle=1, psym=5, symsize=1.3, symcolor='purple', xtitle='q a', ytitle='D', /overplot            ;perpendicular, K direction
;plots,[2*PI/sqrt(3),2*PI/sqrt(3)],[min(f),max(f)],color=fsc_color('Slate Blue'),linestyle=2,/data
;plots,[2*PI/sqrt(3)+ 2*PI/3,2*PI/sqrt(3)+ 2*PI/3],[min(f),max(f)],color=fsc_color('Slate Blue'),linestyle=2,/data 



  device,/close
  set_plot,thisDevice
  erase
  !p.font=-1
  !p.multi=[0,1,1]
  
  case !version.os of
    'Win32': begin
            if !version.arch eq 'x86' then cmd = '"c:\Program Files\Ghostgum\gsview\gsview32.exe "' else  cmd = '"c:\Program Files\Ghostgum\gsview\gsview64.exe "'
     spawn,[cmd,filename],/log_output,/noshell
     end
    'darwin':  spawn,'gv '+filename
    else:  spawn,'gv '+filename
  endcase


  
  
end