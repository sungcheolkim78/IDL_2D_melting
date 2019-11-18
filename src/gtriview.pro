;+
; Name: gtriview
; Purpose: show delaunay triangular diagram
; Input: pt, frame
; History:
;	created by sungcheol kim
; 	modified on 4/13/11 - using cgplot, noclip on cgplots
; 						- change ps size to 17.8cm
; 	modified on 4/26/11 - change in numbering mode
; 						- add time lapsed position
;	modified on 8/2/11 by sungcheol kim - using i_defdraw routine
;	modified on 10/29/12 by sungcheol kim - adding centering function
;-

pro gtriview, pt, frame, field=field, numbering1=numbering1, $
	numbering2=numbering2, ps=ps, verbose=verbose, centering=centering

	on_error,2
  
	thisDevice = !D.name
	!p.multi=[0,1,1]
	!p.charsize=0.8
    !p.font=-1

	ptc = eclip(pt,[5,frame,frame])
    wrc = n_elements(ptc(0,*))

	if not keyword_set(field) then begin
        ratio = 3./4
        symsize = 1.1
        if not keyword_set(ps) then window,0,xsize=640, ysize=480
    endif
    if keyword_set(field) then begin
        width = field[1]-field[0]+10
        height = field[3]-field[2]
        ratio = float(height)/width
        symsize = 2.5
        print, ratio
        if not keyword_set(ps) then window,0,xsize=640, ysize=640*ratio
    endif
	
	if keyword_set(ps) then begin
		set_plot,'ps'
		!p.font=0
		device,/color,/encapsul,/helvetica,bits=8
		filename = 'gtri_'+strtrim(string(frame),2)+'.eps'
		device,xsize=16.8,ysize=16.8*ratio,file=filename
	endif

    ; plot area
	if keyword_set(field) and keyword_set(centering) then i_defdraw, ptc, /tri, field=field, symsize=symsize, /centering
	if keyword_set(field) and not keyword_set(centering) then i_defdraw, ptc, /tri, field=field, symsize=symsize
	if not keyword_set(field) then i_defdraw, ptc, /tri, symsize=symsize

	if keyword_set(numbering1) then begin 
		for i=0,wrc-1 do cgText, ptc(0,wr[i]),ptc(1,wr[i]) $
			,strtrim(string(wr[i]),2),color=fsc_color('blk7') $
			,/data, charsize=0.90
	endif

	if keyword_set(numbering2) then begin 
		for i=0,wrc-1 do cgText, ptc(0,i),ptc(1,i) $
			,string(ptc(6,i),format='(I4)'),color=fsc_color('blk7') $
			,/data, charsize=0.4, noclip=0
		print, 'numbering as tt(6,*)'
	endif

	if keyword_set(ps) then i_close,filename,thisDevice
end
