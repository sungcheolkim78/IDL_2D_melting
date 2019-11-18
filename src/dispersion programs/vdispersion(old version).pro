;Name:    Dispersion
;Purpose: Draw the dispersion relation in first Brillouin Zone in K space
;Input:   tt pointer for the file "tt.DS0_100", startframe and stopframe
;
;Hisotry:
;         Created by Lichao Yu, 09:00PM 11/10/2011 Draw Dispersion Relation with vacancy using existed equiposition array
;         
;                  
;         
; 




pro VDispersion1, tt, equipos, startf, stopf, theta1, space, wavenumber=wavenumber, testmode=testmode
on_error,2




if not keyword_set(testmode) then testmode=0   ; in test mode, default filename become "testmode", in avoid of naming confliction.



 filename = 'testmode.eps'
 wffilename = 'wf.DISP'+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)+'_'+strtrim(string(wavenumber),2)
 if not testmode then filename = 'DispersionRelation_'+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)+ $
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
count = fltarr(partnumber)
spacing = fltarr(3*partnumber)

if not keyword_set(wavenumber) then wavenumber=partnumber
 

ufourierX = make_array(framenumber, wavenumber, /complex)
ufourierY = make_array(framenumber, wavenumber, /complex)
D = make_array(2,2, wavenumber, /complex)
freq = fltarr(2, wavenumber)
f = fltarr(6*wavenumber)
wav = fltarr(6*wavenumber)
wf = fltarr(2, 6*wavenumber)


;M direction
print,'M direction'
    for i= startf, stopf do begin   ;Fourier Transform
        print,i 
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
                 wavex = q*sin(PI/3-theta1)*2*PI/sqrt(3)/space/wavenumber
                 wavey = q*cos(PI/3-theta1)*2*PI/sqrt(3)/space/wavenumber
                 ux = p(0,j)-equipos[0,eq1]   
                 uy = p(1,j)-equipos[1,eq1]  
                 ufourierXreal =ux*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierXimg  =-ux*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYreal =uy*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYimg  =-uy*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierX(i,q-1) += complex(ufourierXreal,ufourierXimg)       
                 ufourierY(i,q-1) += complex(ufourierYreal,ufourierYimg)
                 
                
            endfor 
                           
        endfor
    endfor
    
    for  q=1, wavenumber do begin    ;dynamical matrix
        D(0,0,q-1) = mean(conj(ufourierX(*,q-1))*ufourierX(*,q-1))
        D(0,1,q-1) = mean(conj(ufourierX(*,q-1))*ufourierY(*,q-1))
        D(1,0,q-1) = mean(conj(ufourierY(*,q-1))*ufourierX(*,q-1))
        D(1,1,q-1) = mean(conj(ufourierY(*,q-1))*ufourierY(*,q-1))
        hes = ELMHES(D(*,*,q-1))
        freq[*,q-1] = sqrt(constant2/HQR(hes))
        
    endfor
    

    count = 0
    for  q=1, wavenumber do begin
        wav[2*q-2] = q*2*PI/sqrt(3)/wavenumber
        wav[2*q-1] = wav[2*q-2]
        f[count] = freq[0, q-1]
        count +=1
        f[count] = freq[1, q-1]
        count +=1
    endfor
   
   
    ufourierX(*,*) = 0
    ufourierY(*,*) = 0
    
;M->K direction
print,'M->K direction'
    for i= startf, stopf do begin   ;Fourier Transform
        print,i
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
                 wavex = sin(PI/3-theta1)*2*PI/sqrt(3)/space - q*sin(PI/6+theta1)*2*PI/3/space/wavenumber
                 wavey = cos(PI/3-theta1)*2*PI/sqrt(3)/space + q*cos(PI/6+theta1)*2*PI/3/space/wavenumber
                 ux = p(0,j)-equipos[0,eq1]   
                 uy = p(1,j)-equipos[1,eq1]  
                 ufourierXreal =ux*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierXimg  =-ux*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYreal =uy*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYimg  =-uy*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierX(i,q-1) += complex(ufourierXreal,ufourierXimg)       
                 ufourierY(i,q-1) += complex(ufourierYreal,ufourierYimg)
                 
                
            endfor 
                           
        endfor
    endfor
    
    for  q=1, wavenumber do begin    ;dynamical matrix
        D(0,0,q-1) = mean(conj(ufourierX(*,q-1))*ufourierX(*,q-1))
        D(0,1,q-1) = mean(conj(ufourierX(*,q-1))*ufourierY(*,q-1))
        D(1,0,q-1) = mean(conj(ufourierY(*,q-1))*ufourierX(*,q-1))
        D(1,1,q-1) = mean(conj(ufourierY(*,q-1))*ufourierY(*,q-1))
        hes = ELMHES(D(*,*,q-1))
        freq[*,q-1] = sqrt(constant2/HQR(hes))
        
    endfor
    
    

    for  q=1, wavenumber do begin
        wav[2*wavenumber+2*q-2] = 2*PI/sqrt(3) + q*2*PI/3/wavenumber
        wav[2*wavenumber+2*q-1] = wav[2*wavenumber+2*q-2]
        f[count] = freq[0, q-1]
        count +=1
        f[count] = freq[1, q-1]
        count +=1
    endfor

    ufourierX(*,*) = 0
    ufourierY(*,*) = 0
    
;K direction
print,'K direction'
    for i= startf, stopf do begin   ;Fourier Transform
        print,i
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
                 wavex = q*sin(PI/6-theta1)*4*PI/3/space/wavenumber
                 wavey = q*cos(PI/6-theta1)*4*PI/3/space/wavenumber
                 ux = p(0,j)-equipos[0,eq1]   
                 uy = p(1,j)-equipos[1,eq1]  
                 ufourierXreal =ux*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierXimg  =-ux*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYreal =uy*cos(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierYimg  =-uy*sin(wavex*equipos[0,eq1]+wavey*equipos[1,eq1])
                 ufourierX(i,q-1) += complex(ufourierXreal,ufourierXimg)       
                 ufourierY(i,q-1) += complex(ufourierYreal,ufourierYimg)
                 
                
            endfor 
                           
        endfor
    endfor
    
    for  q=1, wavenumber do begin    ;dynamical matrix
        D(0,0,q-1) = mean(conj(ufourierX(*,q-1))*ufourierX(*,q-1))
        D(0,1,q-1) = mean(conj(ufourierX(*,q-1))*ufourierY(*,q-1))
        D(1,0,q-1) = mean(conj(ufourierY(*,q-1))*ufourierX(*,q-1))
        D(1,1,q-1) = mean(conj(ufourierY(*,q-1))*ufourierY(*,q-1))
        hes = ELMHES(D(*,*,q-1))
        freq[*,q-1] = sqrt(constant2/HQR(hes))
        
    endfor
    
    

    for  q=1, wavenumber do begin
        wav[4*wavenumber+2*q-2] = 2*PI/sqrt(3) + 2*PI/3 + 4*PI/3 - q*4*PI/3/wavenumber
        wav[4*wavenumber+2*q-1] = wav[4*wavenumber+2*q-2]
        f[count] = freq[0, q-1]
        count +=1
        f[count] = freq[1, q-1]
        count +=1
    endfor



wf[0,*] = wav
wf[1,*] = f
write_gdf,wf,wffilename    

cgplot, wav, f, xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='red', xtitle='q a', ytitle='Frequency'
plots,[2*PI/sqrt(3),2*PI/sqrt(3)],[min(f),max(f)],color=fsc_color('Slate Blue'),linestyle=2,/data
plots,[2*PI/sqrt(3)+ 2*PI/3,2*PI/sqrt(3)+ 2*PI/3],[min(f),max(f)],color=fsc_color('Slate Blue'),linestyle=2,/data 





;cgplot, histogram(s, binsize=1E-1, Min=0, Max=100)
;plot_hist, s, xrange=[0,0.01], binsize=1E-5

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