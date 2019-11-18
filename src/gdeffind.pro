;+
; Name: gdeffind
; Purpose: find disclinations center for each frame
; Inputs: gdeffind, pt, startf, stopf, ws, index
; History:
;	created on 7/28/11 by sungcheol kim
;	modified on 8/2/11 sy sungcheol kim - add widget controls
;	modified on 8/8/11 sy sungcheol kim - add more functions
;	modified on 8/18/11 sy SCK - add defect configuration
;	modified on 3/15/12 sy SCK - add radius calculation
;-

pro gdeffind_changeframe, event
	widget_control, event.top, get_uvalue=SV, /no_copy
	widget_control, event.id, get_value=frame
	if frame le SV.stopf and frame ge SV.startf then SV.frame = fix(frame)
	ptc = eclip(*(SV.pt),[5,SV.frame,SV.frame])
	if SV.tri eq 1 then i_defdraw, ptc, /tri, field=SV.wsize $
		else i_defdraw, ptc, /wired, field=SV.wsize
    widget_control, SV.tbl1, set_table_view=[SV.frame-SV.startf-17,SV.frame-8-SV.startf]
	widget_control, event.top, set_uvalue=SV, /no_copy
end
	
pro gdeffind_changeRadius, event
	widget_control, event.top, get_uvalue=SV, /no_copy
	widget_control, event.id, get_value=radius
	SV.radius = radius
	widget_control, event.top, set_uvalue=SV, /no_copy
end

pro gdeffind_tbledit, event
;	print,event.type
	if event.type eq 0 then begin
		widget_control, event.top, get_uvalue=SV, /no_copy
		if event.ch ne 10b then SV.input += string(event.ch)
		if event.ch eq 10b then begin
			print,'Change value to '+SV.input
            if event.x eq 1 then SV.savedata[event.y].x = float(SV.input) $
                else SV.savedata[event.y].y = float(SV.input)
			SV.input = ''
		endif
		widget_control, event.top, set_uvalue=SV, /no_copy
	endif
end

pro gdeffind_file, event
	widget_control, event.top, get_uvalue=SV, /no_copy
	widget_control, event.id, get_uvalue=type

	case type of
		'savejpg':
		'saveeps': begin
		  !p.charsize=1.0
			gtriview,*(SV.pt),fix(SV.frame),field=SV.wsize,/ps
			end
		'opendef': begin
			filename = dialog_pickfile(Title='Select pt.def file',filter='pt.def*')
			ptd = read_gdf(filename)
            s = size(ptd,/dimensions)
            if s[0] ne 4 then begin 
                print, 'Old format'
                return
            endif

            mtype = max(ptd[3,*])
            if mtype le 10 then begin
                SV.dtype = 'mi'
                widget_control, SV.tab, set_tab_current=2
                widget_control, SV.bST3, /set_button
            endif
            if mtype gt 10 and mtype le 20 then begin
                SV.dtype = 'di'
                widget_control, SV.tab, set_tab_current=3
                widget_control, SV.bST4, /set_button
            endif
            if mtype gt 20 and mtype le 30 then begin 
                SV.dtype = 'mv'
                widget_control, SV.tab, set_tab_current=0
                widget_control, SV.bST1, /set_button
            endif
            if mtype gt 30 and mtype le 40 then begin
                SV.dtype = 'dv'
                widget_control, SV.tab, set_tab_current=1
                widget_control, SV.bST2, /set_button
            endif

			savesf = min(ptd[2,*],max=saveff)
			startf = savesf-SV.startf
			stopf = saveff-SV.startf
			SV.savedata[startf:stopf].x = transpose(ptd[0,*])
			SV.savedata[startf:stopf].y  = transpose(ptd[1,*])
			SV.savedata[startf:stopf].t  = transpose(ptd[2,*])
            for i=startf,stopf do SV.savedata[i].conf = i_typematch(ptd[3,i-startf])
			SV.frame = saveff
			SV.savesf = savesf
			SV.saveff = saveff
			SV.filename = filename

			; change UI information
			widget_control, SV.tbl1, set_value=SV.savedata
			widget_control, SV.txt1, set_value=strtrim(fix(SV.frame),2)
			widget_control, SV.lblfile, set_value='File: '+SV.filename
			widget_control, SV.lblsave, set_value='Saved'
			widget_control, SV.tbl1, set_table_view=[SV.frame-SV.startf-17,SV.frame-8-SV.startf]
			widget_control, SV.txt11, set_value=strtrim(fix(SV.savesf),2)
			widget_control, SV.txt12, set_value=strtrim(fix(SV.saveff),2)

			; show data
			ptc = eclip(*(SV.pt),[5,SV.frame,SV.frame])
			if SV.tri eq 1 then i_defdraw, ptc, /tri, field=SV.wsize $
				else i_defdraw, ptc, /wired, field=SV.wsize
			end
		else:
	endcase
	widget_control, event.top, set_uvalue=SV, /no_copy
end

pro gdeffind_save, event
	widget_control, event.top, get_uvalue=SV, /no_copy
	widget_control, event.id, get_uvalue=type
	widget_control, event.id, get_value=framen

	case type of
		'startf': SV.savesf = framen
		'stopf': SV.saveff = framen
	endcase

	SV.frame = framen
	ptc = eclip(*(SV.pt),[5,SV.frame,SV.frame])
	if SV.tri eq 1 then i_defdraw, ptc, /tri, field=SV.wsize $
		else i_defdraw, ptc, /wired, field=SV.wsize

	SV.filename = 'pt.def'+strtrim(fix(SV.savesf),2)+'_'+strtrim(fix(SV.saveff),2)+SV.dtype
	ft = file_search(SV.filename,count=fc)
	if fc gt 0 then widget_control, SV.lblsave, set_value='Saved' else $
	  widget_control, SV.lblsave, set_value='Not Saved'
    cd, current=cwd
	widget_control, SV.lblfile, set_value='File: '+cwd+'/'+SV.filename
	widget_control, SV.tbl1, set_table_view=[SV.frame-SV.startf-17,SV.frame-8-SV.startf]
	widget_control, event.top, set_uvalue=SV, /no_copy
end

pro gdeffind_changewindow, event
	widget_control, event.top, get_uvalue=SV, /no_copy
	widget_control, event.id, get_uvalue=code
	widget_control, event.id, get_value=w

	case code of
		'1': if w gt 0 and w lt SV.wsize[1] then SV.wsize[0] = w
		'2': if w gt 0 and w lt SV.wsize[3] then SV.wsize[2] = w
		'3': begin
			if w+SV.wsize[0] lt 640 then SV.wsize[1] = SV.wsize[0]+w $
				else SV.wsize[1] = 640
			end
		'4': begin
			if w+SV.wsize[2] lt 480 then SV.wsize[3] = SV.wsize[2]+w $
				else SV.wsize[3] = 480
			end
	endcase
	ptc = eclip(*(SV.pt),[5,SV.frame,SV.frame])
	if SV.tri eq 1 then i_defdraw, ptc, /tri, field=SV.wsize $
		else i_defdraw, ptc, /wired, field=SV.wsize
	widget_control, SV.txtw1, set_value=strtrim(fix(SV.wsize[0]),2)
	widget_control, SV.txtw2, set_value=strtrim(fix(SV.wsize[2]),2)
	widget_control, SV.txtw3, set_value=strtrim(fix(SV.wsize[1]-SV.wsize[0]),2)
	widget_control, SV.txtw4, set_value=strtrim(fix(SV.wsize[3]-SV.wsize[2]),2)
	widget_control, event.top, set_uvalue=SV, /no_copy
end

pro gdeffind_configuration, event
    widget_control, event.top, get_uvalue=SV, /no_copy
    widget_control, event.id, get_value=val

    SV.savedata[SV.frame].conf = val
    widget_control, SV.tbl1, set_value = SV.savedata
    widget_control, event.top, set_uvalue=SV, /no_copy
end

pro gdeffind_event, event
	widget_control, event.top, get_uvalue=SV, /no_copy
	widget_control, event.id, get_uvalue=uval

	case uval of
	    'done': begin
            widget_control, event.top, /destroy
            return
            end
		'save': begin
			print, 'Save data to '+SV.filename
            savedata = fltarr(4,SV.saveff-SV.savesf+1)
            savedata[0,*] = SV.savedata[SV.savesf-SV.startf:SV.saveff-SV.startf].x
            savedata[1,*] = SV.savedata[SV.savesf-SV.startf:SV.saveff-SV.startf].y
            savedata[2,*] = SV.savedata[SV.savesf-SV.startf:SV.saveff-SV.startf].t
            for i=SV.savesf,SV.saveff do savedata[3,i-SV.savesf] = i_typematch(SV.savedata[i-SV.startf].conf)
            write_gdf, savedata, SV.filename
			widget_control,SV.lblsave,set_value='Saved'
			end
		'next': begin
			if SV.frame lt SV.stopf then SV.frame += 1
			widget_control, SV.txt1, set_value=strtrim(fix(SV.frame),2)
			widget_control, SV.tbl1, set_table_view=[SV.frame-SV.startf-17,SV.frame-SV.startf-8]
			ptc = eclip(*(SV.pt),[5,SV.frame,SV.frame])
			if SV.tri eq 1 then i_defdraw, ptc, /tri, field=SV.wsize $
				else i_defdraw, ptc, /wired, field=SV.wsize
			widget_control, SV.lblsave, set_value='Not Saved'
			end
		'prev': begin
			if SV.frame gt SV.startf then SV.frame -= 1
			widget_control, SV.txt1, set_value=strtrim(fix(SV.frame),2)
			widget_control, SV.tbl1, set_table_view=[SV.frame-SV.startf-17,SV.frame-SV.startf-8]
			ptc = eclip(*(SV.pt),[5,SV.frame,SV.frame])
			if SV.tri eq 1 then i_defdraw, ptc, /tri, field=SV.wsize $
				else i_defdraw, ptc, /wired, field=SV.wsize
			widget_control, SV.lblsave, set_value='Not Saved'
			end
		'tri': begin
			SV.tri = 1
			SV.wired = 0
			end
		'wired': begin
			SV.tri = 0
			SV.wired = 1
			end
        'mv': begin
            SV.dtype = 'mv'
            widget_control, SV.tab, set_tab_current=0
            end
        'dv': begin
            SV.dtype = 'dv'
            widget_control, SV.tab, set_tab_current=1
            end
        'mi': begin
            SV.dtype = 'mi'
            widget_control, SV.tab, set_tab_current=2
            end
        'di': begin
            SV.dtype = 'di'
            widget_control, SV.tab, set_tab_current=3
            end
		'refresh': begin
			ptc = eclip(*(SV.pt),[5,SV.frame,SV.frame])
			if SV.tri eq 1 then i_defdraw, ptc, /tri, field=SV.wsize $
				else i_defdraw, ptc, /wired, field=SV.wsize
			widget_control, SV.txt1, set_value=strtrim(fix(SV.frame),2)
			end
        else:
	endcase

	widget_control, event.top, set_uvalue=SV, /no_copy
end

pro gdeffind_find, event
	widget_control, event.top, get_uvalue=SV, /no_copy
	widget_control, event.id, get_value=drawID
	wset, drawID

	if event.type eq 0 then begin
		ptc = eclip(*(SV.pt),[5,SV.frame,SV.frame])
		datax = (event.X-60)*(SV.wsize[1]-SV.wsize[0])/722.+SV.wsize[0]
		datay = (event.Y-40)*(SV.wsize[3]-SV.wsize[2])/540.+SV.wsize[2]
		find_defect, ptc, [datax, datay], SV
	endif
	widget_control, event.top, set_uvalue=SV, /no_copy
end

pro gdeffind_cleanup, base
	widget_control, base, get_uvalue=SV, /no_copy
	if n_elements(SV) ne 0 then begin
		ptr_free, SV.pt
	endif
end

function i_box, x, y, width, height
    x0 = x-width/2.
    x1 = x+width/2.
    y0 = y-height/2.
    y1 = y+height/2.
	return, transpose([[x0,x1,x1,x0,x0],[y0,y0,y1,y1,y0]])
end

function i_dis, point1, point2
    return,sqrt((point1(0)-point2(0))^2+(point1(1)-point2(1))^2)
end
    
function i_conf, dplus, dminus, a0, SV
    np = n_elements(dplus(0,*))
    nm = n_elements(dminus(0,*))

    if np eq 1 and nm eq 2 then return, 'SV'
    if np eq 1 and nm eq 3 then return, 'D3'
    if np eq 2 and nm eq 1 then return, 'SI'

    if np eq 2 and nm eq 2 then begin
        dis77 = i_dis(dplus(*,0),dplus(*,1))
        dis55 = i_dis(dminus(*,0),dminus(*,1))

        case SV.dtype of
            'mv': if dis77/a0 lt 2.0 then return, 'V2' else  return, 'V2d'
            'dv': if dis77/a0 lt 1.3 then return, 'SDa' else  return, 'D2'
            'mi': if dis55/a0 gt 0.5 and dis55/a0 lt 1.2 then return, 'I2' else  return, 'I2d'
            'di': if dis55/a0 gt 0.5 and dis55/a0 lt 1.2 then return, 'DI2' else  return, 'DI2d'
        endcase
    endif

    if nm eq 3 and np eq 3 then begin
        case SV.dtype of 
            'mv': return, 'V3'
            'dv': return, 'D3d'
            'mi': begin
                dis77 = max([i_dis(dplus(*,0),dplus(*,1)),i_dis(dplus(*,1),dplus(*,2)),i_dis(dplus(*,2),dplus(*,0))])
                if dis77/a0 gt 2.5 then return, 'I3d' else return, 'I3' 
                end
            'di': return, 'DI3d'
        endcase
    endif

    if SV.dtype eq 'dv' and nm eq 3 and np eq 2 then return, 'D3d'


    if nm eq 4 and np eq 4 then begin
        case SV.dtype of
            'mv': return, 'V4'
            'dv': return, 'SDb'
            'mi': return, 'I4' ; can be 'I4d'
            'di': return, 'DI4d'
        endcase
    endif

    if nm eq 5 and np eq 5 then begin
        case SV.dtype of
            'mv': return, ''
            'dv': return, ''
            'mi': return, ''
            'di': return, 'DI34b'
        endcase
    endif

    if nm eq 6 and np eq 6 then return, 'DI6'
end

pro find_defect, ptc, points, SV
	triangulate, ptc(0,*), ptc(1,*), tr, conn=con
	nff = n_elements(ptc(0,*))
	nnn = intarr(nff)
	for j=0,nff-1 do nnn(j) = n_elements(con[con[j]:con[j+1]-1])

	minus = where(nnn le 5, mc)
	plus = where(nnn ge 7, pc)
    wdefp = where(ptc(0,plus) gt points[0]-SV.radius and $
        ptc(0,plus) lt points[0]+SV.radius and $
        ptc(1,plus) gt points[1]-SV.radius and $
        ptc(1,plus) lt points[1]+SV.radius, wdefpc)
    wdefm = where(ptc(0,minus) gt points[0]-SV.radius and $
        ptc(0,minus) lt points[0]+SV.radius and $
        ptc(1,minus) gt points[1]-SV.radius and $
        ptc(1,minus) lt points[1]+SV.radius, wdefmc)

    if wdefpc gt 0 then begin
        dplus = ptc(0:1,plus[wdefp])
		for k=0,wdefpc-1 do cgtext, dplus(0,k), dplus(1,k), ' '+strtrim(k,2), charsize=1.0
        nearp = con[con[plus[wdefp[0]]]:con[plus[wdefp[0]]+1]-1]
        nearminus = where(nnn(nearp) lt 6, nearminusc)
        if nearminusc gt 0 then a0 = i_dis(dplus[*,0],ptc[*,nearp[nearminus[0]]])
    endif
    if wdefmc gt 0 then begin
        dminus = ptc(0:1,minus[wdefm])
		for k=0,wdefmc-1 do cgtext, dminus(0,k), dminus(1,k), ' '+strtrim(k,2), charsize=1.0
        nearp = con[con[minus[wdefm[0]]]:con[minus[wdefm[0]]+1]-1]
        nearplus = where(nnn(nearp) gt 6, nearplusc)
        if nearplusc gt 0 then a0 = i_dis(dminus[*,0],ptc[*,nearp[nearplus[0]]])
    endif

    widget_control, SV.lbldefposition, $
        set_value='(x,y) = ('+ strtrim(points[0],2)+','+strtrim(points[1],2)+')'
    cgplots, i_box(points[0],points[1],2*SV.radius,2*SV.radius), color='grn6', line=5

	; print frame information
    if wdefpc gt 0 or wdefmc gt 0 then begin
        x0 = mean([[dplus(0,*)],[dminus(0,*)]])
        y0 = mean([[dplus(1,*)],[dminus(1,*)]])
        SV.savedata[SV.frame-SV.startf].x = x0
        SV.savedata[SV.frame-SV.startf].y = y0
        SV.savedata[SV.frame-SV.startf].t = SV.frame
        cgplots,fsc_circle(x0,y0,5),color='blk7'

        fname = 'defcoordinate-5.txt'
        openw,1,fname,/append
        for q=0,wdefmc-1 do begin
            t_conf = i_conf(dplus,dminus,a0,SV)
            print, t_conf, i_typematch(t_conf)
            printf, 1, SV.frame, dminus(0,q)-x0, dminus(1,q)-y0, i_typematch(t_conf), $
            format='(I3,1X,F7.3,1X,F7.3,I3)'
        end
        close,1

        fname = 'defcoordinate-7.txt'
        openw,1,fname,/append
        for q=0,wdefpc-1 do begin
            t_conf = i_conf(dplus,dminus,a0,SV)
            print, t_conf, i_typematch(t_conf)
            printf, 1, SV.frame, dplus(0,q)-x0, dplus(1,q)-y0, i_typematch(t_conf), $
            format='(I3,1X,F7.3,1X,F7.3,I3)'
        end
        close,1

        xm0 = mean(dminus(0,*))
        ym0 = mean(dminus(1,*))
        sep = fltarr(wdefmc)
        for q=0,wdefmc-1 do sep[q] = i_dis(dminus[*,q],[xm0,ym0])
        msep = sqrt(total(sep*sep)/wdefmc)
        print, msep*0.083

        SV.savedata[SV.frame-SV.startf].conf = i_conf(dplus, dminus, a0, SV)

        ; update UI information
        widget_control, SV.tbl1, set_value=SV.savedata
        widget_control, SV.tbl1, set_table_view=[SV.frame-SV.startf-17,SV.frame-SV.startf-8]

        if SV.frame lt SV.savesf then savesf = SV.frame-SV.startf $
            else savesf = SV.savesf-SV.startf
        if SV.frame gt SV.saveff then saveff = SV.frame-SV.startf $
            else saveff = SV.saveff-SV.startf

        savedata = fltarr(4,SV.saveff-SV.savesf+1)
        savedata[0,*] = SV.savedata[SV.savesf-SV.startf:SV.saveff-SV.startf].x
        savedata[1,*] = SV.savedata[SV.savesf-SV.startf:SV.saveff-SV.startf].y
        savedata[2,*] = SV.savedata[SV.savesf-SV.startf:SV.saveff-SV.startf].t
        for i=SV.savesf,SV.saveff do savedata[3,i-SV.savesf] = i_typematch(SV.savedata[i-SV.startf].conf)
        write_gdf, savedata, 'pt.def.temp'
        widget_control,SV.lblsave,set_value='Not Saved*'
    endif
end

pro gdeffind, pt, field=field, index=index
on_error,1

; crop the field size for quicker excution
pt0 = eclip(pt,[5,0,0])
xmax = max(pt0(0,*), min=xmin)
ymax = max(pt0(1,*), min=ymin)
if n_elements(field) ne 4 then begin
	mdis = 2./0.083 ; 2 um
	field = [xmin+mdis,xmax-mdis,ymin+mdis,ymax-mdis]
endif
wsize = float(field)
area = (wsize[1]-wsize[0])*(wsize[3]-wsize[2])
np = n_elements(pt0(0,*))

; setup start and stop frame
maxf = max(pt(5,*), min=minf)
if n_elements(index) eq 0 then index = 0
filename = 'pt.def'+strtrim(fix(minf),2)+'_'+strtrim(fix(maxf),2)
radius = 3./0.083

definfo = {t:0, x:0.0, y:0.0, conf:' '}
savedata = replicate(definfo,maxf-minf+1)
savedata.t = indgen(maxf-minf+1)+minf

; make widget windows
bID = widget_base(/column, title='DEFECT FINDER', xpad=0, ypad=0,mbar=mbar)
bScreen = widget_base(bID, /row)
draw = widget_draw(bScreen, xsize=800, ysize=600,/button_events, event_pro='gdeffind_find')

mnu1 = widget_button(mbar, /menu, value='Control')
mnu11 = widget_button(mnu1, value='Next',uvalue='next',accel='Right')
mnu12 = widget_button(mnu1, value='Previous',uvalue='prev',accel='Left')
mnu13 = widget_button(mnu1, value='Quit',uvalue='done',accel='Ctrl+q')
mnu2 = widget_button(mbar, /menu, value='File')
mnu21 = widget_button(mnu2, value='Save Frame as jpg',uvalue='savejpg',event_pro='gdeffind_file')
mnu22 = widget_button(mnu2, value='Save Frame as eps',uvalue='saveeps',event_pro='gdeffind_file',accel='Ctrl+p')
mnu23 = widget_button(mnu2, value='Open def file',uvalue='opendef',event_pro='gdeffind_file',accel='Ctrl+o')

bID2 = widget_base(bScreen, /column, /align_center)

bButton = widget_base(bID2,/row,/align_center)
btn1 = widget_button(bButton, value='Done',uvalue='done',accel="Ctrl+q",tab_mode=1)
btn2 = widget_button(bButton, value='Next',uvalue='next',accel="Right",tab_mode=1)
btn3 = widget_button(bButton, value='Prev',uvalue='prev',accel="Left",tab_mode=1)
btn6 = widget_button(bButton, value='Refr',uvalue='refresh',accel="Ctrl+r",tab_mode=1)
btn7 = widget_button(bButton, value='Save',uvalue='save',accel="Ctrl+s",tab_mode=1)
btn8 = widget_button(bButton, value='Pri',uvalue='saveeps',accel="Ctrl+p",tab_mode=1,event_pro='gdeffind_file')

bID3 = widget_base(bID2, /row, /frame, /exclusive)
btn4 = widget_button(bID3, value='Triangulation',uvalue='tri',accel="Ctrl+t")
btn5 = widget_button(bID3, value='Wired',uvalue='wired',accel="Ctrl+w")
widget_control, btn5, /set_button

bID5 = widget_base(bID2,/row,/align_left)
lbl1 = widget_label(bID5, value='Frame')
txt1 = widget_text(bID5, xsize=5, value=strtrim(fix(minf),2),/editable,$
	event_pro='gdeffind_changeframe',tab_mode=1)
lblmaxf = widget_label(bID5, xsize=40, value=strtrim(fix(maxf),2),/frame)

bID6 = widget_base(bID2, /row, /align_left)
lbl4 = widget_label(bID6, value='Save Frame')
txt11 = widget_text(bID6, value=strtrim(fix(minf),2), /editable, $
  uvalue='startf', event_pro='gdeffind_save',tab_mod=1,xsize=5)
txt12 = widget_text(bID6, value=strtrim(fix(maxf),2), /editable, $
  uvalue='stopf', event_pro='gdeffind_save',tab_mod=1,xsize=5)

bRadius = widget_base(bID2, /row, /align_left)
lblR = widget_label(bRadius, value='Selection Radius')
txtR = widget_text(bRadius, xsize=5, value=strtrim(fix(radius),2),/editable,$
	event_pro='gdeffind_changeRadius',tab_mode=1)

fwsize = fix(wsize)
bID4 = widget_base(bID2, /row, /align_left)
lbl2 = widget_label(bID4, value='Window')
txt5 = widget_text(bID4, xsize=3, value=strtrim(fwsize[0],2),/editable,$
	event_pro='gdeffind_changewindow',tab_mode=1,uvalue='1')
txt6 = widget_text(bID4, xsize=3, value=strtrim(fwsize[2],2),/editable,$
	event_pro='gdeffind_changewindow',tab_mode=1,uvalue='2')
txt7 = widget_text(bID4, xsize=3, value=strtrim(fwsize[1]-fwsize[0],2),/editable,$
	event_pro='gdeffind_changewindow',tab_mode=1,uvalue='3')
txt8 = widget_text(bID4, xsize=3, value=strtrim(fwsize[3]-fwsize[2],2),/editable,$
	event_pro='gdeffind_changewindow',tab_mode=1,uvalue='4')

tbl1 = widget_table(bID2, value=savedata, column_labels=['t','x','y','type'],$
	y_scroll_size=10,x_scroll_size=3,/scroll,ysize=maxf-minf+1, $
	/editable,/no_row_headers,event_pro='gdeffind_tbledit',/all_events $
    )
widget_control, tbl1, column_width=[30,70,70,40]

bSelectType = widget_base(bID2,/row,/align_left,/frame, /exclusive)
bST1 = widget_button(bSelectType, value='mono-V', uvalue='mv') 
bST2 = widget_button(bSelectType, value='di-V', uvalue='dv') 
bST3 = widget_button(bSelectType, value='mono-I', uvalue='mi') 
bST4 = widget_button(bSelectType, value='di-I', uvalue='di') 
widget_control, bST1, /set_button

tab = widget_tab(bID2,uvalue='tab',xsize=200,ysize=70)
bConfMV = widget_base(tab,title='mono-V',/col )
bc1 = widget_base(bConfMV,/row)
bCMV1 = widget_button(bc1, value='SV', event_pro='gdeffind_configuration')
bCMV2 = widget_button(bc1, value='V2', event_pro='gdeffind_configuration')
bCMV3 = widget_button(bc1, value='V2d', event_pro='gdeffind_configuration')
bCMV4 = widget_button(bc1, value='V3', event_pro='gdeffind_configuration')
bCMV5 = widget_button(bc1, value='V3d', event_pro='gdeffind_configuration')
bc2 = widget_base(bConfMV,/row)
bCMV6 = widget_button(bc2, value='V4', event_pro='gdeffind_configuration')
bCMV7 = widget_button(bc2, value='V4d', event_pro='gdeffind_configuration')
bConfDV = widget_base(tab,title='di-V',/col )
bd1 = widget_base(bConfDV,/row)
bCDV1 = widget_button(bd1, value='SDa', event_pro='gdeffind_configuration')
bCDV2 = widget_button(bd1, value='SDb', event_pro='gdeffind_configuration')
bCDV3 = widget_button(bd1, value='D2', event_pro='gdeffind_configuration')
bCDV4 = widget_button(bd1, value='D3', event_pro='gdeffind_configuration')
bCDV5 = widget_button(bd1, value='D3d', event_pro='gdeffind_configuration')
bd2 = widget_base(bConfDV,/row)
bCDV6 = widget_button(bd2, value='D4d', event_pro='gdeffind_configuration')
bCDV7 = widget_button(bd2, value='D2a', event_pro='gdeffind_configuration')
bConfMI = widget_base(tab,title='mono-I',/col)
ba1 = widget_base(bConfMI,/row)
bCMI1 = widget_button(ba1, value='SI', event_pro='gdeffind_configuration')
bCMI2 = widget_button(ba1, value='I2', event_pro='gdeffind_configuration')
bCMI3 = widget_button(ba1, value='I2d', event_pro='gdeffind_configuration')
bCMI4 = widget_button(ba1, value='I2a', event_pro='gdeffind_configuration')
ba2 = widget_base(bConfMI,/row)
bCMI5 = widget_button(ba2, value='I3', event_pro='gdeffind_configuration')
bCMI6 = widget_button(ba2, value='I3d', event_pro='gdeffind_configuration')
bCMI7 = widget_button(ba2, value='I3a', event_pro='gdeffind_configuration')
bCMI8 = widget_button(ba2, value='I4', event_pro='gdeffind_configuration')
bCMI9 = widget_button(ba2, value='I4d', event_pro='gdeffind_configuration')
bCMI10 = widget_button(ba2, value='I4a', event_pro='gdeffind_configuration')
bConfDI = widget_base(tab,title='di-I',/col )
bb1 = widget_base(bConfDI,/row)
bCDI1 = widget_button(bb1, value='DI2', event_pro='gdeffind_configuration')
bCDI2 = widget_button(bb1, value='DI2da', event_pro='gdeffind_configuration')
bCDI3 = widget_button(bb1, value='DI2db', event_pro='gdeffind_configuration')
bCDI4 = widget_button(bb1, value='DI3d', event_pro='gdeffind_configuration')
bCDI5 = widget_button(bb1, value='DI3a', event_pro='gdeffind_configuration')
bb2 = widget_base(bConfDI,/row)
bCDI6 = widget_button(bb2, value='DI4d', event_pro='gdeffind_configuration')
bCDI7 = widget_button(bb2, value='DI4a', event_pro='gdeffind_configuration')
bCDI8 = widget_button(bb2, value='DI2a', event_pro='gdeffind_configuration')
bCDI9 = widget_button(bb2, value='DI34b', event_pro='gdeffind_configuration')
bCDI10 = widget_button(bb2, value='DI6', event_pro='gdeffind_configuration')

bStatus = widget_base(bID,/row,/frame)
cd, current=cwd
lblfile = widget_label(bStatus, xsize=600,value='File: '+cwd+'/'+filename,/align_left)
lbldefposition = widget_label(bStatus, xsize=160, value='(x,y) = (0,0)',/align_center)
lblsave = widget_label(bStatus,value='Not Saved',xsize=100,/align_center)

; save universal variables
SV = { $
	pt:ptr_new(pt), $
	draw:draw, $
	txt1:txt1, $
	txtw1:txt5, $
	txtw2:txt6, $
	txtw3:txt7, $
	txtw4:txt8, $
	txt11:txt11, $
	txt12:txt12, $
    bST1:bST1, bST2:bST2, bST3:bST3, bST4:bST4, $
	tbl1:tbl1, $
	lblfile:lblfile, $
	lbldefposition:lbldefposition, $
	lblsave:lblsave, $
    tab:tab, $
	startf:minf, $
	frame:minf, $
	stopf:maxf, $
	wsize:wsize, $
	savedata: savedata, $
	wired:1, tri:0,$
	radius: radius, $
	filename:filename, $
	savesf:minf, $
	saveff:maxf, $
	input:'',$
    dtype:'mv'}

widget_control, bID, set_uvalue=SV, /realize
widget_control, draw, get_value=drawID
wset, drawID
!p.multi=[0,1,1]

ptc = eclip(pt,[5,SV.frame,SV.frame])

if SV.tri eq 1 then i_defdraw, ptc, field=SV.wsize, /tri $
	else i_defdraw, ptc, field=SV.wsize, /wired

xmanager, 'gdeffind', bID, cleanup='gdeffind_cleanup', /no_block

end
