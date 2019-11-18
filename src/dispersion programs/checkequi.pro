;
;
;
;
;

pro checkequi, equip, xmin, xmax, ymin, ymax
on_error,2
PI = 3.14159

  filename = 'checkequi.eps'
  thisDevice = !D.NAME
  set_plot,'ps'
  !p.font=0
  ;!p.thick=1.4
  ;!p.charsize=1.6
  device,file=filename,/encapsulate,/color,bits_per_pixel=8,/helvetica
  
    partnumber = n_elements(equip[0,*])
    spacing = fltarr(6*partnumber)
    angle =  fltarr(4*partnumber)
    
    coun1 = 0
    coun2 = 0
    positionX = equip[0,*]
    positionY = equip[1,*]
    triangulate, positionX, positionY, tr
    ntr = n_elements(tr(0,*))
    for i=0, ntr-1 do begin
        if (positionX(tr(0,i)) gt xmin) and (positionX(tr(0,i)) lt xmax) and (positionY(tr(0,i)) gt ymin) and (positionY(tr(0,i)) lt ymax) $
        and (positionX(tr(1,i)) gt xmin) and (positionX(tr(1,i)) lt xmax) and (positionY(tr(1,i)) gt ymin) and (positionY(tr(1,i)) lt ymax) $
        and (positionX(tr(2,i)) gt xmin) and (positionX(tr(2,i)) lt xmax) and (positionY(tr(2,i)) gt ymin) and (positionY(tr(2,i)) lt ymax) $ 
        then begin
        len1 = sqrt((positionX(tr(0,i))-positionX(tr(1,i)))^2 + (positionY(tr(0,i))-positionY(tr(1,i)))^2)
        spacing(coun1) = len1
        coun1 +=1
        len2 = sqrt((positionX(tr(2,i))-positionX(tr(1,i)))^2 + (positionY(tr(2,i))-positionY(tr(1,i)))^2)
        spacing(coun1) = len2
        coun1 +=1
        len3 = sqrt((positionX(tr(0,i))-positionX(tr(2,i)))^2 + (positionY(tr(0,i))-positionY(tr(2,i)))^2)
        spacing(coun1) = len3
        coun1 +=1
        cosine = abs(((positionX(tr(1,i))-positionX(tr(0,i)))*(positionX(tr(2,i))-positionX(tr(0,i))) $
                        +(positionY(tr(1,i))-positionY(tr(0,i)))*(positionY(tr(2,i))-positionY(tr(0,i)))))/len1/len3
        angle(coun2) = acos(cosine)*180/PI
        coun2 +=1
        cosine = abs(((positionX(tr(0,i))-positionX(tr(1,i)))*(positionX(tr(2,i))-positionX(tr(1,i))) $
                        +(positionY(tr(0,i))-positionY(tr(1,i)))*(positionY(tr(2,i))-positionY(tr(1,i)))))/len1/len2
        angle(coun2) = acos(cosine)*180/PI
        coun2 +=1
        endif
     endfor
      space = fltarr(coun1+1) ;eluminate zero term in s vector to plot histogram
      ang = fltarr(coun2+1)  ;eluminate zero term in s vector to plot histogram
      
      tem=0
      for j = 0, coun1 do begin
          if spacing(j) ne 0  then begin
              space(tem) = spacing(j) 
              tem +=1
          endif
      endfor
      
      tem=0
      for j = 0, coun2 do begin
          if angle(j) ne 0  then begin
              ang(tem) = angle(j) 
              tem +=1
          endif
      endfor

     !p.multi=[0,2,2]
     cghistoplot, space, xtitle='Lattice Constant (pixel)',ytitle='Frequency', binsize=0.01, mininput=10, maxinput=15, CHARSIZE=1.1
     cghistoplot, ang, xtitle='Angle (degree)',ytitle='Frequency', binsize=0.1, mininput=0, maxinput=90, CHARSIZE=1.1 
     histogauss, space, A, CHARSIZE=0.8
     histogauss, ang, B, CHARSIZE=0.8

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