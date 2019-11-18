pro ls, string

; Written by Sungcheol Kim, 7/27/11
; 

case !version.os of
  'Windows': begin
    cmd = 'dir /b'
    spawn, cmd, /hide, /log_output
    end
  'Win32': begin
    cmd = 'dir /b'
    spawn, cmd, /hide, /log_output
    end
  else: begin
    cmd = 'ls'
    if n_elements(string) eq 0 then begin 
      spawn,[cmd,'-FG'],/noshell
    endif else begin    
      spawn,[cmd,string], /noshell
    endelse
    end
endcase

end
