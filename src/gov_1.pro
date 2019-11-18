;+
; Name: gov_1
; Purpose: change directories easily by event type number
; Input: gov, eventtype, eventnumber
; History:
; 	created on 07/28/11 by sungcheol kim
; 	changed to apply to win7 directory on 08/16/2011 by Lichao Yu
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

pro gov_1, eventt, eventn
on_error, 2

eventtype = ['Single_Event','Double_Event','Temp']
eventarray1 = ['event_s_1', 'event_s_2', 'event_s_3', 'event_s_4', 'event_s_5' $
	,'event_s_6', 'event_s_7', 'event_s_8', 'event_s_9', $
	'event_s_10', 'event_s_11', 'event_s_12_interstitial']
eventarray2 = ['event_d1', 'event_d2', 'event_da3', 'event_da4', 'event_da5','event_d6']
eventarray3 = ['1', '2', '3', '4', '5','6']

case n_params() of 
	0: begin
		cd, current = cwd
		print, cwd
		show_files
		return
		end
	1: begin
		if eventt eq 1 then print, eventarray1
		if eventt eq 2 then print, eventarray2
		if eventt eq 3 then print, eventarray3
		return
		end
	else:
endcase

case !version.os of
  'darwin': basedir = '~/Dropbox/Shared/IDL/Data/Vacancy' 
  'Win32': begin
    if strcmp(!version.arch, 'x86') then basedir = 'C:\Users\06\Dropbox\IDL\Data\Vacancy'
    if strcmp(!version.arch, 'x86_64') then    basedir = 'C:\Users\Ling\Dropbox\IDL\Data\Vacancy'
    end
  else: basedir = '~/Dropbox/IDL/Data/Vacancy'
endcase

if eventt eq 1 then finaldir = basedir+'/'+eventtype[eventt-1]+'/'+eventarray1[eventn-1]
if eventt eq 2 then finaldir = basedir+'/'+eventtype[eventt-1]+'/'+eventarray2[eventn-1]
if eventt eq 3 then finaldir = basedir+'/'+eventtype[eventt-1]+'/'+eventarray3[eventn-1]
if eventt gt 3 or eventt lt 1 then print, "Out of range!"

print, finaldir
cd, finaldir
show_files

end
