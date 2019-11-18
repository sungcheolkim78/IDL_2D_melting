;+
; Name: i_close
; Purpose: routine for close device and show file
; Input: i_close, filename, thisDevice
; History:
;   created 8/17/11 by SCK
;	modified 10/28/12 by SCK - convert eps file to pdf and open with Preview in mac ox system
;-

pro i_close, filename, thisDevice

    device, /close
    set_plot, thisDevice

    case !version.os of
		; for windows system
        'Win32': begin
		      if !version.arch eq 'x86' then begin
		        cmd = '"c:\Program Files\Ghostgum\gsview\gsview64.exe "'
            spawn,[cmd,filename],/log_output,/noshell 
          endif else begin
            cmd = '"c:\Program Files (x86)\gs\gs9.02\lib\ps2pdf.bat "'
            tmpfilename = str_replace(filename,'eps','pdf')
            print, tmpfilename
            spawn, [cmd,filename+' '+tmpfilename], /log_output, /noshell
            cmd = '"c:\Program Files (x86)\Adobe\Reader 10.0\Reader\AcroRd32.exe "'
            print, cmd
            spawn,[cmd,tmpfilename],/log_output,/noshell
          endelse
          
        end
		; for macox system
        'darwin': begin
			spawn, 'epstopdf ' + filename
			tmpfilename = str_replace(filename, 'eps', 'pdf')
			spawn, 'rm ' + filename
            spawn, 'open ' + tmpfilename
            end
		; for unix system
        else: spawn, 'gv '+filename
    endcase
end
