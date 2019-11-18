



Pro DrawCorr, pt, q, save=save

if not keyword_set(save) then save=0

ntime = n_elements(pt(q,*,0))
time = fltarr(2*ntime)
cor = fltarr(2*ntime)
count = 0

for i=0, ntime-1 do begin
    if pt(q,i,0) eq 0 then continue
    time(count) = i*0.5                         ;0.5 == 15*0.033
    time(count+1) = i*0.5
    cor(count) = pt(q,i,0)
    cor(count+1) = pt(q,i,1)
    count +=2
endfor
print,count

if (save) eq 0 then  cgplot, time[0:count-1], cor[0:count-1], xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='red', xtitle='t(seconds)', ytitle='AutoCorrelation'



if (save) ne 0 then begin

  filename = 'AutoCorrelation_'+strtrim(string(q),2)+'.eps'
  thisDevice = !D.NAME
  set_plot,'ps'
  !p.font=0
  ;!p.thick=1.4
  ;!p.charsize=1.6
  device,file=filename,/encapsulate,/color,bits_per_pixel=8,/helvetica
  
  cgplot, time, cor, xstyle=1, ystyle=1, psym=1, symsize=1.3, symcolor='red', xtitle='t(seconds)', ytitle='AutoCorrelation'
  
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