;+
; Name: go
; Purpose: move directory where proper data is
; Input: go, 1, time
; History: 
; 	Modified on 5/30/11 by sungcheol kim
;	Modified on 7/28/11 by sungcheol kim - windows compatibility
;-

pro show_files,short=short

on_error, 2

print, '+-------------------------------------------'
fn = file_search('fg_*.jpg',count=c)
print, fn[0]+' '+fn[c-1]+' : '+strtrim(string(c),2)+' files'
if n_elements(short) eq 0 then begin
	print, format='(A-20,A-20,A-20,A-20)',file_search('t.*')
	print, format='(A-20,A-20,A-20,A-20)',file_search('tt2.fg*')
	print, format='(A-20,A-20,A-20,A-20)',file_search('f.den*')
	print, format='(A-20,A-20,A-20,A-20)',file_search('f.gr*')
	print, format='(A-20,A-20,A-20,A-20)',file_search('gr6.*')
endif
print, format='(A-20,A-20,A-20,A-20)',file_search('tt.fg*')
print, format='(A-20,A-20,A-20,A-20)',file_search('f.dd*')
print, format='(A-20,A-20,A-20,A-20)',file_search('pt.def*')
print, format='(A-20,A-20,A-20,A-20)',file_search('pt.dis*')
print, format='(A-20,A-20,A-20,A-20)',file_search('pt.fg*')
print, '+-------------------------------------------'
ls, '*.eps *.tex'
print, file_search('im.*')

end

pro go, group, time, quiet=quiet, clean=clean
on_error, 2

	case n_params() of 
		0: begin ; show information
			if n_elements(clean) eq 1 then spawn,'rm *.tex *.eps *.pdf'
			cd, current = cwd
			print, cwd
			show_files, /short
			analdir = str_replace(cwd,'Alexsandros','analysis')
			spawn,'rsync *.eps *.tex *.pdf '+analdir
			return
			end
		1: begin
			time = 1
			end
		2: begin
			end
	endcase

	basedir = '/home/sungcheolkim/Lab/2DCC/'
	datadir = basedir+'Alexsandros/'
	analdir = basedir+'analysis/'
	flag = 1

	if group eq 1 then begin
		finaldir = datadir+'001128/'
		analdir = analdir+'001128/'
	endif
	if group eq 2 then begin
		finaldir = datadir+'010424/'
		analdir = analdir+'010424/'
	endif

	timestamp1 = [0210, 0400, 0530, 0900, 1130, 1530, 2020, 2520, 2620, 2820, $
		2930, 3120, 3230, 3330, 3840, 4332, 5030, 5458]
	dirstamp1 = ['0210-0410', '0400-0530', '0530-0900', '0900-1130', $
		'1130-1530', '1530-2020', '2020-2520', '2520-2620', '2620-2820', $
		'2820-2930', '2930-3120', '3120-3230', '3230-3330', '3330-3715', $
		'3840-4332', '4332-5030', '5030-5458']
	volstamp1 = [20, 20, 20, 20, 15, 15, 20, 20, 20, 10, 7.5, 15, 5, 20, 20, 0, 0]
	voltimestamp1 = [0.1, 0.1, 0.05, 0.05, 0.05, 0.0125, 0.05, 2, $
		0.05, 0.1, 0.1, 0.1, 0.1, 0.0125, 0.0025, 0, 0]
	timestamp2 = [0100, 0400, 0700, 0830, 1140, 1530, 2310, 2850, 3350, $
		3520, 3900, 4300, 4950, 5250, 5820, 10420, 10930, 11450, 12000, 12100]
	dirstamp2 = ['0100-0400', '0400-0700','0700-0830','0830-1130', $
		'1140-1530', '1530-2310', '2310-2850', '2850-3350', $
		'3350-3520', '3520-3900', '3900-4230', '4300-4950', $
		'4950-5250', '5250-5820', '5820-10420', '10420-10930', $
		'10930-11450', '11450-12000', '12000-12100']
	
	; first data set
	if group eq 1 then begin
		if time lt timestamp1[0] or time gt timestamp1[n_elements(timestamp1)-1] then begin
			message, 'Out of time range',/inf
			print, dirstamp1
			return
		endif
		w = where(timestamp1 gt time)
		finaldir = finaldir+dirstamp1(w[0]-1)
		analdir = analdir+dirstamp1(w[0]-1)
		print,'Voltage: '+string(volstamp1(w[0]-1),format='(F5.1)')+'  Freq.: '+$
			string(voltimestamp1(w[0]-1),format='(F5.3)')+'  Hz T/4: '+$
			string(1./voltimestamp1(w[0]-1)*30./2.,format='(F5.1)')+' Frames'
	endif

	; second data set
	if group eq 2 then begin
		if time lt timestamp2[0] or time gt timestamp2[n_elements(timestamp2)-1] then begin
			message, 'Out of time range',/inf
			print, dirstamp2
			return
		endif
		w = where(timestamp2 gt time)
		finaldir = finaldir+dirstamp2(w[0]-1)
		analdir = analdir+dirstamp2(w[0]-1)
	endif

	if flag eq 1 then begin
		cd,finaldir
		print,finaldir
		if not keyword_set(quiet) then show_files,/short
		spawn,'rsync *.eps *.tex *.pdf '+analdir
	endif
end
