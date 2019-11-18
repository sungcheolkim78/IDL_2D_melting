;+
; Name: gor
; Purpose: change directories easily by event type number of random potential
; Input: gov, eventtype, eventnumber
; History:
; 	created on 08/11/11 by sungcheol kim
;-

; sub program
pro show_files
on_error, 2

print, '+-----------------------------------------'
print, format='(A-20, A-20, A-20)', file_search('pt.*')
print, format='(A-20, A-20)', file_search('tt.*')
print, format='(A-20, A-20, A-20, A-20)', file_search('*.eps')
print, format='(A-20, A-20, A-20, A-20)', file_search('*.jpg')
print, '+-----------------------------------------'

end

pro gor, eventt
on_error, 2

eventtype = ['strongPinning','weakPinning']

case n_params() of 
	0: begin
		cd, current = cwd
		print, cwd
		show_files
		return
		end
	1: 
	else:
endcase

case !version.os of
  'darwin': basedir = '~/Documents/1 Lab/1 Colloidal Crystal/7 Alexandros/2 Random Pinning' 
  'Win32': print, 'only used for sungcheol mac'
  else: print, 'only used for sungcheol mac'
endcase

finaldir = basedir+'/'+eventtype[eventt-1]
if eventt gt 2 or eventt lt 1 then print, "Out of range!"

print, finaldir
cd, finaldir
show_files

end
