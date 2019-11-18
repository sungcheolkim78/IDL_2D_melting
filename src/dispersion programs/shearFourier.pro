;Name:    ShearFourier
;Purpose: compute shear modulus of every single spring of particle pairs in 2DCC.
;         decompose the positions of the particles into the components along the axes,  using the equi-partition principle
;         Fourier transform to k space (mode)
;Input:   tt pointer for the file "tt.DS0_100", startframe and stopframe
;Function:Findnn, used to find the index of the nearest neighbour of a particle (index) in certain direction in equiposition
;
;Hisotry:
;         Created by Lichao Yu, 6:30PM 11/07/2011 Draw Dispersion Relation
;         
;                  
;         
; 



pro ShearFourier, tt, startf, stopf, wavenumber=wavenumber, testmode=testmode, direction=direction
on_error,2

if not keyword_set(direction) then direction=0 ; default is 0, M direction; direction=1, K; direction=2, M->K; 
if not keyword_set(lenscale) then lenscale=2     ; default is lenscale=2, this can be integer.
if not keyword_set(plotoption) then plotoption=0     ; default is plotoption=0 plot shear modulus; if plotoption=1, plot u1-u2
if not keyword_set(testmode) then testmode=0   ; in test mode, default filename become "testmode", in avoid of naming confliction.



 filename = 'testmode.eps'
 if not testmode then filename = 'Dispersion_'+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)+ $
                                  '_wavenumber='+strtrim(string(wavenumber),2)+'.eps'
  thisDevice = !D.NAME
  set_plot,'ps'
  !p.font=0
  ;!p.thick=1.4
  ;!p.charsize=1.6
  device,file=filename,/encapsulate,/color,bits_per_pixel=8,/helvetica

dia = 0.36
spacing = 13           ; lattice constant = 13 pixels.  
PI = 3.14159
constant = 4.78046     ; constant=kb*T*2/sqrt3= 4.78*10E-21 Joule.
                       ; if 1 pixel=0.083um, constant= 6.93927*10E-7 Joule per m2==N per m
                       ; it seems we need to add a radius thickness to modify the unit of shear modulus to N/m2=Pa
                       ; if diameter=0.36um, we get the final result to be: 1.936 Pa
constant2 = 1          ; constant2=Kb*T= 4.14*E-12 Joule


framenumber = stopf-startf+1
partnumber = max(tt(6,*))+1
equipos = fltarr(2, partnumber)
shear = dblarr(framenumber, partnumber)
count = fltarr(partnumber)
spacing = fltarr(3*partnumber)

if not keyword_set(wavenumber) then wavenumber=partnumber

ntt = n_elements(tt(0,*))
for i = 0, ntt-1 do begin
    equipos[0,tt[6,i]] += tt[0,i]
    equipos[1,tt[6,i]] += tt[1,i]
    count[tt[6,i]] +=1
endfor 

maxcount = max(count)

for i=0, partnumber-1 do begin
    if count[i] gt 0.95*maxcount then begin
        equipos[0,i] /=count[i]   ;equilibrium position
        equipos[1,i] /=count[i]
             ;xyouts, positionX[i], positionY[i], strtrim(string(uint(p(6,i))),2), color=fsc_color('brown'),/normal,charsize=0.8 
    endif else begin
        equipos[0,i] =10000   ;set boundary to 10000 as a flag
        equipos[1,i] =10000 
    endelse
endfor 

coun = 0
tang = 0
for i=0, partnumber-1 do begin    ;find tilt angle
    if equipos[0,i] ne 10000 then begin
        nn = Findnn(equipos[0,*], equipos[1,*], i, 1, partn=0)
        if nn eq 10000 then continue
        if count[nn] lt 0.95*maxcount then continue
        tang +=(equipos[1,nn]-equipos[1,i])/(equipos[0,nn]-equipos[0,i])
        coun +=1
    endif   
endfor

theta1 = atan(tang/coun) ;average
theta2 = theta1 + PI/6
;print, theta1, theta2

  

ufourierX = make_array(framenumber, wavenumber, /complex)
ufourierY = make_array(framenumber, wavenumber, /complex)
D = make_array(2,2, wavenumber, /complex)
freq = fltarr(2, wavenumber)
f = fltarr(2*wavenumber)
wav = fltarr(2*wavenumber)
dis = fltarr(2, wavenumber)
di = fltarr(2*wavenumber)

if direction eq 0 then begin        ;M direction
    for i= startf, stopf do begin   ;Fourier Transform
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
                 wavex = q*sin(PI/3-theta1)*2*PI/sqrt(3)/12.877/wavenumber
                 wavey = q*cos(PI/3-theta1)*2*PI/sqrt(3)/12.877/wavenumber
                 ux = p(0,j)-equipos[0,eq1]   
                 uy = p(1,j)-equipos[1,eq1]  
                 ufourierXreal =ux*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierXimg  =-ux*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYreal =uy*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYimg  =-uy*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierX(i,q-1) += complex(ufourierXreal,ufourierXimg)       
                 ufouriery(i,q-1) += complex(ufourierYreal,ufourierYimg)
                 
                
            endfor 
                           
        endfor
    endfor
    
    for  q=1, wavenumber do begin    ;dynamical matrix
        D(0,0,q-1) += mean(conj(ufourierX(*,q-1))*ufourierX(*,q-1))
        D(0,1,q-1) += mean(conj(ufourierX(*,q-1))*ufourierY(*,q-1))
        D(1,0,q-1) += mean(conj(ufourierY(*,q-1))*ufourierX(*,q-1))
        D(1,1,q-1) += mean(conj(ufourierY(*,q-1))*ufourierY(*,q-1))
        hes = ELMHES(D(*,*,q-1))
        freq[*,q-1] = sqrt(constant2/HQR(hes))
        
    endfor
    
    
    count = 0
    for  q=1, wavenumber do begin
        wav[2*q-2] = q*2*PI/sqrt(3)/wavenumber
        wav[2*q-1] = q*2*PI/sqrt(3)/wavenumber
        f[count] = freq[0, q-1]
        count +=1
        f[count] = freq[1, q-1]
        count +=1
    endfor

cgplot, wav, f, xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='red', xtitle='q a', ytitle='Frequency' 
endif


if direction eq 1 then begin        ; K direction
    for i= startf, stopf do begin   ;Fourier Transform
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
                 wavex = q*sin(PI/6-theta1)*4*PI/3/12.877/wavenumber
                 wavey = q*cos(PI/6-theta1)*4*PI/3/12.877/wavenumber
                 ux = p(0,j)-equipos[0,eq1]   
                 uy = p(1,j)-equipos[1,eq1]  
                 ufourierXreal =ux*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierXimg  =-ux*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYreal =uy*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYimg  =-uy*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierX(i,q-1) += complex(ufourierXreal,ufourierXimg)       
                 ufouriery(i,q-1) += complex(ufourierYreal,ufourierYimg)
                 
                
            endfor 
                           
        endfor
    endfor
    
    for  q=1, wavenumber do begin    ;dynamical matrix
        D(0,0,q-1) += mean(conj(ufourierX(*,q-1))*ufourierX(*,q-1))
        D(0,1,q-1) += mean(conj(ufourierX(*,q-1))*ufourierY(*,q-1))
        D(1,0,q-1) += mean(conj(ufourierY(*,q-1))*ufourierX(*,q-1))
        D(1,1,q-1) += mean(conj(ufourierY(*,q-1))*ufourierY(*,q-1))
        hes = ELMHES(D(*,*,q-1))
        freq[*,q-1] = sqrt(constant2/HQR(hes))
        
    endfor
    
    
    count = 0
    for  q=1, wavenumber do begin
        wav[2*q-2] = q*4*PI/3/wavenumber
        wav[2*q-1] = q*4*PI/3/wavenumber
        f[count] = freq[0, q-1]
        count +=1
        f[count] = freq[1, q-1]
        count +=1
    endfor

cgplot, wav, f, xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='red', xtitle='q a', ytitle='Frequency' 
endif

if direction eq 2 then begin        ; M->K direction
    for i= startf, stopf do begin   ;Fourier Transform
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
                 wavex = sin(PI/3-theta1)*2*PI/sqrt(3)/12.877 - q*sin(PI/6+theta1)*2*PI/3/12.877/wavenumber
                 wavey = cos(PI/3-theta1)*2*PI/sqrt(3)/12.877 + q*cos(PI/6+theta1)*2*PI/3/12.877/wavenumber
                 ux = p(0,j)-equipos[0,eq1]   
                 uy = p(1,j)-equipos[1,eq1]  
                 ufourierXreal =ux*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierXimg  =-ux*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYreal =uy*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYimg  =-uy*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierX(i,q-1) += complex(ufourierXreal,ufourierXimg)       
                 ufouriery(i,q-1) += complex(ufourierYreal,ufourierYimg)
                 
                
            endfor 
                           
        endfor
    endfor
    
    for  q=1, wavenumber do begin    ;dynamical matrix
        D(0,0,q-1) += mean(conj(ufourierX(*,q-1))*ufourierX(*,q-1))
        D(0,1,q-1) += mean(conj(ufourierX(*,q-1))*ufourierY(*,q-1))
        D(1,0,q-1) += mean(conj(ufourierY(*,q-1))*ufourierX(*,q-1))
        D(1,1,q-1) += mean(conj(ufourierY(*,q-1))*ufourierY(*,q-1))
        hes = ELMHES(D(*,*,q-1))
        freq[*,q-1] = sqrt(constant2/HQR(hes))
        
    endfor
    
    
    count = 0
    for  q=1, wavenumber do begin
        wav[2*q-2] = q*2*PI/3/wavenumber
        wav[2*q-1] = q*2*PI/3/wavenumber
        f[count] = freq[0, q-1]
        count +=1
        f[count] = freq[1, q-1]
        count +=1
    endfor

cgplot, wav, f, xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='red', xtitle='q a', ytitle='Frequency' 
endif


if direction eq 3 then begin        ; calculate displacement vectors, M direction
    for i= startf, stopf do begin   ;Fourier Transform
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
                 wavex = q*sin(PI/6-theta1)*2*PI/sqrt(3)/12.877/wavenumber
                 wavey = q*cos(PI/6-theta1)*2*PI/sqrt(3)/12.877/wavenumber
                 ux = p(0,j)-equipos[0,eq1]   
                 uy = p(1,j)-equipos[1,eq1]  
                 ufourierXreal =ux*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierXimg  =-ux*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYreal =uy*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYimg  =-uy*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierX(i,q-1) += complex(ufourierXreal,ufourierXimg)       
                 ufouriery(i,q-1) += complex(ufourierYreal,ufourierYimg)
                 
                
            endfor 
                           
        endfor
    endfor
    
    for  q=1, wavenumber do begin    ;dynamical matrix
        D(0,0,q-1) = mean(conj(ufourierX(*,q-1))*ufourierX(*,q-1))
        D(0,1,q-1) = mean(conj(ufourierX(*,q-1))*ufourierY(*,q-1))
        D(1,0,q-1) = mean(conj(ufourierY(*,q-1))*ufourierX(*,q-1))
        D(1,1,q-1) = mean(conj(ufourierY(*,q-1))*ufourierY(*,q-1))
        wavex = q*sin(PI/6-theta1)*2*PI/sqrt(3)/12.877/wavenumber
        wavey = q*cos(PI/6-theta1)*2*PI/sqrt(3)/12.877/wavenumber
        dis[0,q-1] = wavex*D(0,0,q-1)*wavex + wavex*D(1,0,q-1)*wavey + wavex*D(0,1,q-1)*wavey + wavey*D(1,1,q-1)*wavey
        tem = wavex
        wavex = -wavey
        wavey = tem
        dis[1,q-1] = wavex*D(0,0,q-1)*wavex + wavex*D(1,0,q-1)*wavey + wavex*D(0,1,q-1)*wavey + wavey*D(1,1,q-1)*wavey
    endfor
    
    
    count = 0
    for  q=1, wavenumber do begin
        wav[2*q-2] = q*2*PI/sqrt(3)/wavenumber
        wav[2*q-1] = q*2*PI/sqrt(3)/wavenumber
        di[count] = dis[0, q-1]
        count +=1
        di[count] = dis[1, q-1]
        count +=1
    endfor

cgplot, wav, di, xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='red', xtitle='q a', ytitle='Displacement vectors' 
endif


if direction eq 4 then begin        ; calculate displacement vectors, K direction
    for i= startf, stopf do begin   ;Fourier Transform
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
                 wavex = q*sin(PI/6-theta1)*4*PI/3/12.877/wavenumber
                 wavey = q*cos(PI/6-theta1)*4*PI/3/12.877/wavenumber
                 ux = p(0,j)-equipos[0,eq1]   
                 uy = p(1,j)-equipos[1,eq1]  
                 ufourierXreal =ux*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierXimg  =-ux*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYreal =uy*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYimg  =-uy*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierX(i,q-1) += complex(ufourierXreal,ufourierXimg)       
                 ufouriery(i,q-1) += complex(ufourierYreal,ufourierYimg)
                 
                
            endfor 
                           
        endfor
    endfor
    
    for  q=1, wavenumber do begin    ;dynamical matrix
        wavex = q*sin(PI/6-theta1)*4*PI/3/12.877/wavenumber
        wavey = q*cos(PI/6-theta1)*4*PI/3/12.877/wavenumber
        D(0,0,q-1) = mean(conj(ufourierX(*,q-1))*ufourierX(*,q-1)*wavex*wavex)
        D(0,1,q-1) = mean(conj(ufourierX(*,q-1))*ufourierY(*,q-1)*wavex*wavey)
        D(1,0,q-1) = mean(conj(ufourierY(*,q-1))*ufourierX(*,q-1)*wavex*wavey)
        D(1,1,q-1) = mean(conj(ufourierY(*,q-1))*ufourierY(*,q-1)*wavey*wavey)
        dis[0,q-1] = D(0,0,q-1)+D(0,1,q-1)+D(1,0,q-1)+D(1,1,q-1)
        dis[1,q-1] = dis[0,q-1]
        ;tem = wavex
        ;wavex = -wavey
        ;wavey = tem
        ;dis[1,q-1] = wavex*D(0,0,q-1)*wavex + wavex*D(1,0,q-1)*wavey + wavex*D(0,1,q-1)*wavey + wavey*D(1,1,q-1)*wavey
    endfor
    
    
    count = 0
    for  q=1, wavenumber do begin
        wav[2*q-2] = q*4*PI/3/wavenumber
        wav[2*q-1] = q*4*PI/3/wavenumber
        di[count] = dis[0, q-1]
        count +=1
        di[count] = dis[1, q-1]
        count +=1
    endfor
print,di
;cgplot, wav, di, xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='red', xtitle='q a', ytitle='Displacement vectors' 
endif

;cgplot, histogram(s, binsize=1E-1, Min=0, Max=100)
;plot_hist, s, xrange=[0,0.01], binsize=1E-5

  device,/close
  set_plot,thisDevice
  erase
  !p.font=-1
  !p.multi=[0,1,1]
  
  case !version.os of
    'Win32': begin
     cmd = '"c:\Program Files\Ghostgum\gsview\gsview64.exe "'
     spawn,[cmd,filename],/log_output,/noshell
     end
    'darwin':  spawn,'gv '+filename
    else:  spawn,'gv '+filename
  endcase


  
  
end