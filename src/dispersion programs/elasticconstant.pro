;Name:    elasticconstant
;Purpose: Draw or write text files the displacement function in K space
;Input:   tt pointer for the file "tt.DS0_100", startframe and stopframe, equip pointer for the equiposition
;         "wavenumber" defines the binsize, "fact" defines the range of K space
;
;Hisotry:
;         Finalized by Lichao Yu, 12:00PM 12/22/2011 


Pro ElasticConstant, tt, equipos, startf, stopf, theta1, space, wavenumber=wavenumber, plot=plot, fact=fact
on_error,2

if not keyword_set(wavenumber) then wavenumber=10
if not keyword_set(fact) then fact=1
if not keyword_set(plot) then plot=0

dia = 0.36
PI = 3.14159
constant = 4.78046


framenumber = stopf-startf+1
dis = fltarr(4,2, wavenumber)   ; 4 situations, 2 column of text files.

for q=1, wavenumber do begin
     print,q
     
     wavex = q*sin(PI/3-theta1)*2*PI/sqrt(3)/space/wavenumber/fact                                             ;M direction
     wavey = q*cos(PI/3-theta1)*2*PI/sqrt(3)/space/wavenumber/fact
     dis(0,0,q-1) =  q*2*PI/sqrt(3)/wavenumber/fact                                     ;wave number column
     dis(1,0,q-1) =  q*2*PI/sqrt(3)/wavenumber/fact
     
     temp = fouriercomp(tt, equipos, wavex, wavey)
     dis(0,1,q-1) = mean(abs(temp(*,0)*wavex + temp(*,1)*wavey));*wav1(q-1)/space       ;displacement column
     dis(1,1,q-1) = mean(abs(-temp(*,0)*wavey + temp(*,1)*wavex));*wav1(q-1)/space
     
endfor

for q=1, wavenumber do begin
     print,q
     
        wavex = q*sin(PI/6-theta1)*4*PI/3/space/wavenumber/fact                                                   ;K direction        
        wavey = q*cos(PI/6-theta1)*4*PI/3/space/wavenumber/fact
        dis(2,0,q-1) =  q*4*PI/3/wavenumber/fact
        dis(3,0,q-1) =  q*4*PI/3/wavenumber/fact
     
     temp = fouriercomp(tt, equipos, wavex, wavey)
     dis(2,1,q-1) = mean(abs(temp(*,0)*wavex + temp(*,1)*wavey));*wav2(q-1)/space
     dis(3,1,q-1) = mean(abs(-temp(*,0)*wavey + temp(*,1)*wavex));*wav2(q-1)/space
     
endfor


for k=0, 3 do begin
    wffilename = 'wf.DISP_'+strtrim(string(fact),2)+'_wavenumber='+strtrim(string(wavenumber),2)+'_'+strtrim(string(k),2)+'.txt'
    a=fltarr(2,wavenumber)
    a(*,*) = dis(k,*,*)
    write_text,a,wffilename
endfor

if(plot) then begin

    filename = 'DisplacementPlot_'+strtrim(string(startf),2)+'_'+strtrim(string(stopf),2)+ $
                                  '_wavenumber='+strtrim(string(wavenumber),2)+'.eps'
    thisDevice = !D.NAME
    set_plot,'ps'
    !p.font=0
    ;!p.thick=1.4
    ;!p.charsize=1.6
    device,file=filename,/encapsulate,/color,bits_per_pixel=8,/helvetica
  
    maxy = max(dis(*,1,*))
    cgplot, dis(0,0,*), dis(0,1,*), xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='red', xtitle='q a', ytitle='D', xran=[0,5/fact], yran=[0,maxy]                          ;parallel, M direction
    cgplot, dis(1,0,*), dis(1,1,*), xstyle=1, ystyle=1, psym=5, symsize=1.3, symcolor='red', /overplot              ;perpendicular, M direction
    cgplot, dis(2,0,*), dis(2,1,*), xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='blue', /overplot
    cgplot, dis(3,0,*), dis(3,1,*), xstyle=1, ystyle=1, psym=5, symsize=1.3, symcolor='blue', /overplot

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