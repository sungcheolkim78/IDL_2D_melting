;+
; Name: gdnadetect
; Purpose: show frames and detect radius of gyration and center of mass
; Input: gdnadetect, filename
; History: created by sungcheol kim, 4/16/12
;-

pro showzoom, co, SV, option=option
    if not keyword_set(option) then option = 0

    widget_control, SV.view, get_value=drawID
    wset, drawID

    zooma = SV.a(co[0]:co[0]+SV.zoomsize[0],co[1]:co[1]+SV.zoomsize[1],SV.index)

    if option eq 1 then begin
        zooma = (zooma > SV.back) - SV.back
        zooma = zooma > SV.rms*SV.threshhold
    endif

    SV.zoomi = bytscl(rebin(zooma,SV.zoomsize[0]*2+2, SV.zoomsize[1]*2+2))
    tv, SV.zoomi
end

pro t_changeparameter, event
    widget_control, event.top, get_uvalue=SV, /no_copy
    widget_control, event.id, get_uvalue=type
    widget_control, event.id, get_value=value

    case type of
        'frame': begin
            if value lt 0 then value = 0
            if value gt SV.s[3]-1 then value = SV.s[3]-1
            SV.index = value

            widget_control, SV.draw, get_value=drawID
            wset, drawID
            tvimage, SV.a(*,*,SV.index)
            widget_control, SV.txt1, set_value=strtrim(SV.endframe,2)
            widget_control, SV.txt2, set_value=strtrim(SV.index,2)
            widget_control, SV.tbl1, set_table_view=[SV.index-16, SV.index-8]

            showzoom, [SV.zx,SV.zy], SV, option=1
            end
        'id': begin
            SV.id = value
            widget_control, SV.txt5, set_value=strtrim(value,2)
            end
        'th': begin
            SV.threshhold = value
            widget_control, SV.txt6, set_value=strtrim(value,2)
            showzoom, [SV.zx, SV.zy], SV, option=1
            end
    endcase

    widget_control, event.top, set_uvalue=SV, /no_copy
end

pro gdnadetect_event, event
    widget_control, event.top, get_uvalue=SV, /no_copy
    widget_control, event.id, get_uvalue=uval, get_value=val
    widget_control, SV.draw, get_value=drawID
    wset, drawID

    case uval of
        'next': begin
            SV.index += 1
            if SV.index gt SV.endframe-1 then SV.index = SV.endframe - 1
            a0 = SV.a(*,*,SV.index)
            tvimage, a0
            widget_control, SV.txt1, set_value=strtrim(SV.endframe,2)
            widget_control, SV.txt2, set_value=strtrim(SV.index,2)
            widget_control, SV.tbl1, set_table_view=[SV.index-16, SV.index-8]

            showzoom, [SV.zx,SV.zy], SV, option=1
            end
        'prev': begin
            SV.index -= 1
            if SV.index lt 0 then SV.index = 0
            a0 = SV.a(*,*,SV.index)
            tvimage, a0
            widget_control, SV.txt1, set_value=strtrim(SV.endframe,2)
            widget_control, SV.txt2, set_value=strtrim(SV.index,2)
            widget_control, SV.tbl1, set_table_view=[SV.index-16, SV.index-8]

            showzoom, [SV.zx,SV.zy], SV, option=1
            end
        'save': begin
            sfilename = SV.filename+'_'+strtrim(SV.id,2)+'.sav'
            w = where(SV.data[1,*] ne 0, wc)
            if wc ne 0 then write_gdf, SV.data[*,w], sfilename
            print, 'Save on '+sfilename
            end
        'quit': begin
            widget_control, event.top, /destroy
            return
            end
        else:
    endcase

    widget_control, event.top, set_uvalue=SV, /no_copy
end

pro dna_zoom, event
    widget_control, event.top, get_uvalue=SV, /no_copy
    widget_control, SV.draw, get_value=drawID
    wset, drawID

    if event.type eq 0 then begin
        x1 = event.X - SV.zoomsize[0]/2
        x2 = event.X + SV.zoomsize[0]/2
        y1 = event.Y - SV.zoomsize[1]/2
        y2 = event.Y + SV.zoomsize[1]/2

        if x1 lt 0 then begin
            x1 = 0
            x2 = 50
        endif
        if x2 gt SV.s[1] then begin
            x1 = SV.s[1]-51
            x2 = SV.s[1]-1
        endif
        if y1 lt 0 then begin
            y1 = 0
            y2 = 100
        endif
        if y2 gt SV.s[2] then begin
            y1 = SV.s[2]-101
            y2 = SV.s[2]-1
        endif

        cgplots, transpose([[x1,x2,x2,x1,x1],[y1,y1,y2,y2,y1]]), color='grn3', /device
        ;cgplots, fsc_circle(event.X, event.Y, 2), color='red3', /device

        SV.back = mean(SV.a(0:x1,y1:y2,SV.index))
        SV.rms = stddev(SV.a(0:x1,y1:y2,SV.index))

        showzoom, [x1,y1], SV, option=1

        SV.zx = x1
        SV.zy = y1
    endif

    widget_control, SV.txt3, set_value=strtrim(SV.zx,2)
    widget_control, SV.txt4, set_value=strtrim(SV.zy,2)
    widget_control, SV.txt5, set_value=strtrim(SV.id,2)

    widget_control, event.top, set_uvalue=SV, /no_copy
end

pro dna_detect, event
    widget_control, event.top, get_uvalue=SV, /no_copy
    widget_control, SV.view, get_value=drawID
    wset, drawID

    if event.type eq 0 then begin
        SV.startx = event.X
        SV.starty = event.Y

        cgplots, fsc_circle(event.X, event.Y,3), color='red3', /device
    endif

    if event.type eq 1 then begin
        xs = [SV.startx, event.X]
        ys = [SV.starty, event.Y]
        x1 = min(xs, max=x2)
        y1 = min(ys, max=y2)

        print, x1, x2, y1, y2
        totali = float(total(SV.zoomi(x1-1:x2+1,y1-1:y2+1)))
        print, max(SV.zoomi), min(SV.zoomi), mean(SV.zoomi), totali

        xt = 0
        yt = 0
        for k=x1-1,x2+1 do begin
            for l=y1-1,y2+1 do begin
                xt += float(SV.zoomi(k,l))*float(k)/totali
                yt += float(SV.zoomi(k,l))*float(l)/totali
            endfor
        endfor

        cgplots, fsc_circle(event.X,event.Y,3), color='blu3', /device
        cgplots, [SV.startx, event.X],[SV.starty, event.Y], color='grn3', /device

        length = sqrt((x2-x1)^2+(y2-y1)^2)/2.
        xm = xt/2.+SV.zx
        ym = yt/2.+SV.zy
        print, xm,ym,length, xt, yt

        SV.data[1,SV.index] = xm
        SV.data[2,SV.index] = ym
        SV.data[3,SV.index] = length

        widget_control, SV.tbl1, set_value=SV.data
        widget_control, SV.tbl1, set_table_view=[SV.index-16, SV.index-8]
    endif

    widget_control, event.top, set_uvalue=SV, /no_copy
end

pro gdnadetect, filename

a = i_readvideo(filename)
s = size(a)
data = fltarr(4,s[3])

bID = widget_base(/row, title='DNA detect', xpad=0, ypad=0, mbar=mbar)
bScreen = widget_base(bID, /row)
draw = widget_draw(bScreen, xsize=s[1],ysize=s[2],/button_events, event_pro='dna_zoom')

mnu1 = widget_button(mbar, /menu, value='Control')
mnu11 = widget_button(mnu1, value='Next', accel='Right', uvalue='next')
mnu12 = widget_button(mnu1, value='Prev', accel='Left', uvalue='prev')
mnu13 = widget_button(mnu1, value='Quit', accel='Ctrl+q', uvalue='quit')

bCommand = widget_base(bID, /col)

view = widget_draw(bCommand, xsize=102, ysize=202,/button_events, event_pro='dna_detect')

bNext = widget_button(bCommand, value='Next', uvalue='next')
bPrev = widget_button(bCommand, value='Prev', uvalue='prev')
bSave = widget_button(bCommand, value='Save', uvalue='save')
bQuit = widget_button(bCommand, value='Quit', uvalue='quit')

bSt1 = widget_base(bCommand, /row)
lbl1 = widget_label(bSt1, value='T.F.', xsize=45)
txt1 = widget_text(bSt1, xsize=5, value=strtrim(s[3],2), uvalue='tframe')

bSt2 = widget_base(bCommand, /row)
lbl2 = widget_label(bSt2, value='Frame', xsize=45)
txt2 = widget_text(bSt2, xsize=5, value=strtrim(0,2), uvalue='frame', $
    /editable, event_pro='t_changeparameter')

bSt3 = widget_base(bCommand, /row)
lbl3 = widget_label(bSt3, value='zx', xsize=45)
txt3 = widget_text(bSt3, xsize=5, value=strtrim(0,2), uvalue='zx')

bSt4 = widget_base(bCommand, /row)
lbl4 = widget_label(bSt4, value='zy', xsize=45)
txt4 = widget_text(bSt4, xsize=5, value=strtrim(0,2), uvalue='zy')

bSt5 = widget_base(bCommand, /row)
lbl5 = widget_label(bSt5, value='id', xsize=45)
txt5 = widget_text(bSt5, xsize=5, value=strtrim(0,2), uvalue='id', $
    /editable, event_pro='t_changeparameter')

bSt6 = widget_base(bCommand, /row)
lbl6 = widget_label(bSt6, value='T.H.', xsize=45)
txt6 = widget_text(bSt6, xsize=5, value=strtrim(1.5,2), uvalue='th',$
    /editable, event_pro='t_changeparameter')

data(0,*) = indgen(s[3])+1
zoomi = intarr(102,202)

tbl1 = widget_table(bID, value=data, column_labels=['t','x','y','l'], $
    y_scroll_size=10,x_scroll_size=4,/scroll, ysize=s[3], $
    /no_row_headers)

SV = {a:a, s:s, index:0, endframe:s[3],$
    back:0, rms:0, threshhold:1.5, $
    startx:0, starty:0, zx:0, zy:0, $
    txt1:txt1, txt2:txt2, txt6:txt6, $
    txt3:txt3, txt4:txt4, txt5:txt5, $
    tbl1:tbl1, view:view, $
    draw:draw, radius:20., data:data,$
    zoomsize:[50,100], id:0, zoomi:zoomi, $
    filename:filename}

widget_control, bID, set_uvalue=SV, /realize
widget_control, draw, get_value=drawID
wset, drawID

tvimage, a(*,*,SV.index)
showzoom, [SV.zx,SV.zy], SV, option=1

xmanager, 'gdnadetect', bID, /no_block

end
