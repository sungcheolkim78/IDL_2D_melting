; IDL Startup Setup v2
; History:
; 	created by sungcheol kim
;	modified by sungcheol kim on 7/27/11 - dropbox sharing

;Device, Retain=2, Decomposed=0, True_Color=24

; all integers at main level are LONG and enforce square brachket array subscripting
;COMPILE_OPT idl2

!PATH = Expand_Path('/home/sungcheolkim/IDL/new') + ':' + $
		Expand_Path('/home/sungcheolkim/IDL/ericlib') + ':' + $
		Expand_Path('/home/sungcheolkim/IDL/coyote') + ':' + $
		Expand_Path('/home/sungcheolkim/IDL/etc') + ':' + $
		Expand_Path('/home/sungcheolkim/IDL/grierlib') + ':' + $
		Expand_Path('/home/sungcheolkim/IDL/markwardtlib') + ':' + $
		Expand_Path('/home/sungcheolkim/IDL/gdllib') + ':' + $
		Expand_Path('/home/sungcheolkim/IDL/gdllib/IDL_Functions') + ':' + $
		Expand_Path('/usr/local/share/gnudatalanguage/lib') + ':' + $
		!PATH

Device, SET_CHARACTER_SIZE=[9,12]
Window, xsize=600, ysize=400, /pixmap
Plot, Findgen(11)
WDelete, !D.Window

journal, 'my_commands.pro'

Print, 'Good to see you again, SungCheol'
Print, 'Executed IDLSTARTUP.pro version2'

