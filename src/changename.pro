;+
; Name: changename
; Purpose: change name from fg_1.jpg to fg_0001.jpg
;
;-

pro changename,filename,startf,stopf

	for i=startf,stopf do begin
		ofilename = filename+'_'+strtrim(string(i),2)+'.jpg'
		nfilename = ffilename(filename,i)

		;print,'mv '+ofilename+' '+nfilename
		spawn, 'mv '+ofilename+' '+nfilename

	endfor

end
