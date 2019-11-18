;+
; Name: printeps
; Purpose: change eps to pdf and show
; Input: printeps, filename
; History:
;	created by sungcheol kim
;	modified on 8/4/11 by sungcheol kim - add mac, window code
;-

pro printeps, filename, small=small, width=width
on_error,2	
	fn = file_search(filename,/fully_qualify_path,count=fc)
	fnt = fn
	outname = str_replace(fn[0], 'eps','tex')
	for i=0,fc-1 do fnt[i] = str_replace(fn[i],'_','\_',/global)
    print, fnt

	openw, lun, outname, /get_lun
	printf, lun, '\documentclass[10pt,letterpaper]{article}'
	printf, lun, '\usepackage{epsfig}'
	printf, lun, '\usepackage{graphicx}'
	printf, lun, '\usepackage[cm]{fullpage}'
	printf, lun, '\pagestyle{empty}'
	printf, lun, '\begin{document}'
	for i=0, fc-1 do begin
		printf, lun, '\begin{figure}[htbp] \begin{center}'
		if keyword_set(width) then widthstring = ',width='+strtrim(width,2)+'cm}' $
			else widthstring = ',width=16.8cm}'
		if keyword_set(small) then printf, lun, '\epsfig{file='+$
			fn[i]+',width=8.4cm}' else printf, lun, '\epsfig{file='+$
			fn[i]+widthstring
		printf, lun, '\caption{'+fnt[i]+'}'
		printf, lun, '\end{center} \end{figure}'
	endfor
	printf, lun, '\end{document}'
	free_lun, lun

	spawn, 'xelatex '+outname

	case !version.os of
		'Win32': begin
			spawn, 'evince '+str_replace(outname,'tex','pdf')
			spawn, 'rm '+str_replace(outname,'tex','aux')
			spawn, 'rm '+str_replace(outname,'tex','log')
			end
		'darwin': begin
			spawn, 'open '+str_replace(outname,'tex','pdf')
			spawn, 'rm '+str_replace(outname,'tex','aux')
			spawn, 'rm '+str_replace(outname,'tex','log')
			end
		else: begin
			spawn, 'open '+str_replace(outname,'tex','pdf')
			spawn, 'rm '+str_replace(outname,'tex','aux')
			spawn, 'rm '+str_replace(outname,'tex','log')
			end
	endcase

end
