;+
; Name: grmmotion
; Purpose: remove drift motion and show the different
; Inputs: grmmotion, filename, smooth=smoo
; History:
;   created by sungcheol kim on 7/27/11
;-

pro grmmotion, filename, smooth=smooth
on_error, 2

thisDevice = !D.name

set_plot,'ps'
gfilename = 'rm_'+filename+'.eps'
device, /color,/encapsul,/helvetica,bits=8
device, xsize=17.8, ysize=17.8*3/4., file=gfilename
!p.font=0
!p.multi=[0,2,2]
!p.charsize=0.8

tt = read_gdf(filename)

mot = motion(tt)
gplottr, tt, good=100

tt2 = rm_motion(tt, mot, smooth=smooth)
gplottr, tt2, good=100

write_gdf, tt2, filename+'_2'

device, /close
set_plot, thisDevice

case !version.os of
	'Windows': begin
		cmd = '"c:\Program Files\Ghostgum\gsview\gsview64.exe "'
		spawn,[cmd,gfilename],/log_output,/noshell
		end
  'Win32': begin
    cmd = '"c:\Program Files\Ghostgum\gsview\gsview64.exe "'
    spawn,[cmd,gfilename],/log_output,/noshell
    end
	'darwin': spawn, 'open '+gfilename
	else: spawn, 'gv '+gfilename
endcase

!p.multi=[0,1,1]
end
