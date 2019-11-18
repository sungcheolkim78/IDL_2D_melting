;
;
;Purpose:  draw all the dipsersion relation in one diagram with different colors and symbols
;
;
;history:                 Created by Lichao Yu, 11/15/2011



pro draw, pic1, pic2, pic3=pic3, pic4=pic4, pic5=pic5
 
  PI=3.14159
  filename='dispersion.eps'
  thisDevice = !D.NAME
  set_plot,'ps'
  !p.font=0
  ;!p.thick=1.4
  ;!p.charsize=1.6
  device,file=filename,/encapsulate,/color,bits_per_pixel=8,/helvetica
  
tt1=read_gdf('wf.DISP0_'+strtrim(string(pic1),2)+'_50')
wav1=tt1[0,*]
f1=tt1[1,*]
cgplot, wav1, f1, xstyle=1, ystyle=1, psym=1, symsize=1.1, symcolor='black', xtitle='q a', ytitle='Frequency'
plots,[2*PI/sqrt(3),2*PI/sqrt(3)],[min(f1),max(f1)],color=fsc_color('Slate Blue'),linestyle=2,/data
plots,[2*PI/sqrt(3)+ 2*PI/3,2*PI/sqrt(3)+ 2*PI/3],[min(f1),max(f1)],color=fsc_color('Slate Blue'),linestyle=2,/data 

tt2=read_gdf('wf.DISP0_'+strtrim(string(pic2),2)+'_50')
wav2=tt2[0,*]
f2=tt2[1,*]
cgplot, wav2, f2, xstyle=1, ystyle=1, psym=5, symsize=1.0, symcolor='green', xtitle='q a', ytitle='Frequency',/overplot

if keyword_set(pic3) then begin
tt3=read_gdf('wf.DISP0_'+strtrim(string(pic3),2)+'_50')
wav3=tt3[0,*]
f3=tt3[1,*]
cgplot, wav3, f3, xstyle=1, ystyle=1, psym=6, symsize=1.0, symcolor='blue', xtitle='q a', ytitle='Frequency',/overplot
endif

if keyword_set(pic4) then begin
tt4=read_gdf('wf.DISP0_'+strtrim(string(pic4),2)+'_50')
wav4=tt4[0,*]
f4=tt4[1,*]
cgplot, wav4, f4, xstyle=1, ystyle=1, psym=7, symsize=1.0, symcolor='purple', xtitle='q a', ytitle='Frequency',/overplot
endif

if keyword_set(pic5) then begin
tt5=read_gdf('wf.DISP0_'+strtrim(string(pic5),2)+'_50')
wav5=tt5[0,*]
f5=tt5[1,*]
cgplot, wav5, f5, xstyle=1, ystyle=1, psym=4, symsize=1.0, symcolor='red', xtitle='q a', ytitle='Frequency',/overplot
endif
  
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