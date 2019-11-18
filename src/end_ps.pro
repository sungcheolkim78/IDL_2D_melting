;+
; Name: end_ps
; Purpose: close device for ps plot
;
;-

pro end_ps, psinfo

	device,/close
	set_plot,'x'

	f = file_search(psinfo.filename,count=nf)
	if nf eq 1 then spawn, 'gv '+psinfo.filename

end
