;Name:    VDispersion
;Purpose: Draw the dispersion relation in first Brillouin Zone in K space
;Input:   tt pointer for the file "tt.DS0_100", startframe and stopframe
;
;Hisotry:
;         Created by Lichao Yu, 12:00PM 11/09/2011 Draw Dispersion Relation with defects
;         Modified by Lichao Yu, 11/14/2011 move three directions together, 6 times faster
;         add option to plot band structure
;         
;                  
;         

pro VDispersion, tt, equipos, startf, stopf, theta1, space, wavenumber=wavenumber, option=option, testmode=testmode, plot=plot
on_error,2




if not keyword_set(testmode) then testmode=0   ; in test mode, default filename become "testmode", in avoid of naming confliction.
if not keyword_set(option) then option=0       ;option = 0, plot frequency; option = 1, plot frequency square(band structure)
if not keyword_set(plot) then plot=0

 filename = 'testmode.eps'
dia = 0.36
PI = 3.14159
constant = 4.78046     ; constant=kb*T*2/sqrt3= 4.78*10E-21 Joule.
                       ; if 1 pixel=0.083um, constant= 6.93927*10E-7 Joule per m2==N per m
                       ; it seems we need to add a radius thickness to modify the unit of shear modulus to N/m2=Pa
                       ; if diameter=0.36um, we get the final result to be: 1.936 Pa
constant2 = 1          ; constant2=Kb*T= 4.14*E-21 Joule


framenumber = stopf-startf+1
partnumber = n_elements(equipos[0,*])
shear = dblarr(framenumber, partnumber)


if not keyword_set(wavenumber) then wavenumber=partnumber
 

ufourierX1 = make_array(framenumber, wavenumber, /complex)
ufourierY1 = make_array(framenumber, wavenumber, /complex)
ufourierX2 = make_array(framenumber, wavenumber, /complex)
ufourierY2 = make_array(framenumber, wavenumber, /complex)
ufourierX3 = make_array(framenumber, wavenumber, /complex)
ufourierY3 = make_array(framenumber, wavenumber, /complex)
D1 = make_array(2,2, wavenumber, /complex)
D2 = make_array(2,2, wavenumber, /complex)
D3 = make_array(2,2, wavenumber, /complex)
freq1 = fltarr(2, wavenumber)
freq2 = fltarr(2, wavenumber)
freq3 = fltarr(2, wavenumber)

f = fltarr(6*wavenumber)
wav = fltarr(6*wavenumber)
wf = fltarr(2, 6*wavenumber)


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
                 
                 wavex2 = sin(PI/3-theta1)*2*PI/sqrt(3)/space - q*sin(PI/6+theta1)*2*PI/3/space/wavenumber              ;M->K direction
                 wavey2 = cos(PI/3-theta1)*2*PI/sqrt(3)/space + q*cos(PI/6+theta1)*2*PI/3/space/wavenumber              ;M->K direction
                 
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
                 
                 ufourierXreal2 =ux*cos(wavex2*equipos[0,eq1]+wavey2*equipos[1,eq1])                                      ;M->K direction  
                 ufourierXimg2  =-ux*sin(wavex2*equipos[0,eq1]+wavey2*equipos[1,eq1])
                 ufourierYreal2 =uy*cos(wavex2*equipos[0,eq1]+wavey2*equipos[1,eq1])
                 ufourierYimg2  =-uy*sin(wavex2*equipos[0,eq1]+wavey2*equipos[1,eq1])
                 ufourierX2(i,q-1) += complex(ufourierXreal2,ufourierXimg2)       
                 ufourierY2(i,q-1) += complex(ufourierYreal2,ufourierYimg2)
                 
                 ufourierXreal3 =ux*cos(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])                                      ;K direction  
                 ufourierXimg3  =-ux*sin(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])
                 ufourierYreal3 =uy*cos(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])
                 ufourierYimg3  =-uy*sin(wavex3*equipos[0,eq1]+wavey3*equipos[1,eq1])
                 ufourierX3(i,q-1) += complex(ufourierXreal3,ufourierXimg3)       
                 ufourierY3(i,q-1) += complex(ufourierYreal3,ufourierYimg3)
                 
                
            endfor 
                           
        endfor
    endfor
    
    for  q=1, wavenumber do begin    ;dynamical matrix
        D1(0,0,q-1) = mean(conj(ufourierX1(*,q-1))*ufourierX1(*,q-1))                                                        ;M direction 
        D1(0,1,q-1) = mean(conj(ufourierX1(*,q-1))*ufourierY1(*,q-1))
        D1(1,0,q-1) = mean(conj(ufourierY1(*,q-1))*ufourierX1(*,q-1))
        D1(1,1,q-1) = mean(conj(ufourierY1(*,q-1))*ufourierY1(*,q-1))
        print,D1(*,*,q-1)
        hes = ELMHES(D1(*,*,q-1))
        if option eq 0 then freq1[*,q-1] = sqrt(constant2/HQR(hes)) else freq1[*,q-1] = constant2/HQR(hes)
        
        D2(0,0,q-1) = mean(conj(ufourierX2(*,q-1))*ufourierX2(*,q-1))                                                        ;K -> M direction 
        D2(0,1,q-1) = mean(conj(ufourierX2(*,q-1))*ufourierY2(*,q-1))
        D2(1,0,q-1) = mean(conj(ufourierY2(*,q-1))*ufourierX2(*,q-1))
        D2(1,1,q-1) = mean(conj(ufourierY2(*,q-1))*ufourierY2(*,q-1))
        hes = ELMHES(D2(*,*,q-1))
        if option eq 0 then freq2[*,q-1] = sqrt(constant2/HQR(hes)) else freq2[*,q-1] = constant2/HQR(hes)
        
        D3(0,0,q-1) = mean(conj(ufourierX3(*,q-1))*ufourierX3(*,q-1))                                                           ;K direction 
        D3(0,1,q-1) = mean(conj(ufourierX3(*,q-1))*ufourierY3(*,q-1))
        D3(1,0,q-1) = mean(conj(ufourierY3(*,q-1))*ufourierX3(*,q-1))
        D3(1,1,q-1) = mean(conj(ufourierY3(*,q-1))*ufourierY3(*,q-1))
        hes = ELMHES(D3(*,*,q-1))
        if option eq 0 then freq3[*,q-1] = sqrt(constant2/HQR(hes)) else freq3[*,q-1] = constant2/HQR(hes)
        
    endfor
    


    for  q=1, wavenumber do begin
        wav[2*q-2] = q*2*PI/sqrt(3)/wavenumber
        wav[2*q-1] = wav[2*q-2]
        f[2*q-2] = freq1[0, q-1]
        f[2*q-1] = freq1[1, q-1]
        
        wav[2*wavenumber+2*q-2] = 2*PI/sqrt(3) + q*2*PI/3/wavenumber
        wav[2*wavenumber+2*q-1] = wav[2*wavenumber+2*q-2]
        f[2*wavenumber+2*q-2] = freq2[0, q-1]
        f[2*wavenumber+2*q-1] = freq2[1, q-1]
        
        wav[4*wavenumber+2*q-2] = 2*PI/sqrt(3) + 2*PI/3 + 4*PI/3 - q*4*PI/3/wavenumber
        wav[4*wavenumber+2*q-1] = wav[4*wavenumber+2*q-2]
        f[4*wavenumber+2*q-2] = freq3[0, q-1]
        f[4*wavenumber+2*q-1] = freq3[1, q-1]
        
    endfor
   
   
wffilename = 'wf.DISP'+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)+'_'+strtrim(string(wavenumber),2)+'.txt' 
wf[0,*] = wav
wf[1,*] = f
write_text,wf,wffilename    

if(plot) then begin
   if not testmode then filename = 'DispersionRelation_'+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)+ $
                                  '_wavenumber='+strtrim(string(wavenumber),2)+'.eps'
  
  thisDevice = !D.NAME
  set_plot,'ps'
  !p.font=0
  ;!p.thick=1.4
  ;!p.charsize=1.6
  device,file=filename,/encapsulate,/color,bits_per_pixel=8,/helvetica
  
  
  cgplot, wav, f, xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='red', xtitle='q a', ytitle='Frequency'
  plots,[2*PI/sqrt(3),2*PI/sqrt(3)],[min(f),max(f)],color=fsc_color('Slate Blue'),linestyle=2,/data
  plots,[2*PI/sqrt(3)+ 2*PI/3,2*PI/sqrt(3)+ 2*PI/3],[min(f),max(f)],color=fsc_color('Slate Blue'),linestyle=2,/data 



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

endif
  
  
end