;+
; Name: gtptselect
; Purpose: show each track in tpt file and delete and choose time window
; Input: gtptselect, tpt
; History: created by sungcheol kim, 12/6/11
;-

pro gtptselect_event, event
    widget_control, event.top, get_uvalue=SV, /no_copy
    widget_control, event.id, get_uvalue=uval, get_value=val
    
    case uval of
        'next': begin
            if SV.index lt SV.imax-1 then SV.index += 1
            plot_track, SV.tpt, SV.index
            widget_control, SV.txt1, set_value=strtrim(SV.tpt(1,0,SV.index),2)
            widget_control, SV.txt2, set_value=strtrim(SV.index,2)
            end
        'prev': begin
            if SV.index gt 0 then SV.index -= 1
            plot_track, SV.tpt, SV.index
            widget_control, SV.txt1, set_value=strtrim(SV.tpt(1,0,SV.index),2)
            widget_control, SV.txt2, set_value=strtrim(SV.index,2)
            end
        'del': begin
            temp = SV.tpt
            temp(*,*,0:SV.index-1) = SV.tpt(*,*,0:SV.index-1)
            if SV.index ne SV.imax-1 then temp(*,*,SV.index:SV.imax-2) = SV.tpt(*,*,SV.index+1:SV.imax-1)
            SV.tpt = temp(*,*,0:SV.imax-2)
            SV.imax -= 1
            if SV.index gt SV.imax then SV.index = SV.imax
            plot_track, SV.tpt, SV.index
            widget_control, SV.txt1, set_value=strtrim(SV.tpt(1,0,SV.index),2)
            widget_control, SV.txt2, set_value=strtrim(SV.index,2)
            widget_control, SV.txt4, set_value=strtrim(SV.imax,2)
            end
        'frame': begin
            if val gt 0 and val lt SV.tpt(1,0,SV.index) then begin
                SV.tpt(1,0,SV.index) = val
                SV.tpt(1,val+1:*,SV.index) = 0
                SV.tpt(0,val+1:*,SV.index) = 0
                plot_track, SV.tpt, SV.index
                widget_control, SV.txt1, set_value=strtrim(SV.tpt(1,0,SV.index),2)
            endif
            end
        'tail': begin
            if SV.tpt(1,0,SV.index) gt 10 then begin
                SV.tpt(1,0,SV.index) -= 5
                SV.tpt(0,0,SV.index) -= 5
                plot_track, SV.tpt, SV.index
                widget_control, SV.txt1, set_value=strtrim(SV.tpt(1,0,SV.index),2)
            endif
            end
        'head': begin
            if SV.tpt(1,0,SV.index) gt 10 then begin
                tl = SV.tpt(1,0,SV.index) - 5
                SV.tpt(1,1:tl,SV.index)=SV.tpt(1,6:tl+5,SV.index)
                SV.tpt(0,1:tl,SV.index)=SV.tpt(0,6:tl+5,SV.index)
                SV.tpt(1,0,SV.index) = tl
                SV.tpt(0,0,SV.index) = tl
                plot_track, SV.tpt, SV.index
                widget_control, SV.txt1, set_value=strtrim(tl,2)
            endif
            end
        'save': begin
            print, SV.filename
            write_gdf, SV.tpt, SV.filename
            end
        'quit': begin
            widget_control, event.top, /destroy
            return
            end
        else:
    endcase

    widget_control, event.top, set_uvalue=SV, /no_copy
end

pro plot_track, tpt, i
    ny = tpt(1,0,i)
    x = indgen(ny)
    y = tpt(1,1:ny,i)
    dy = y(1:*) - y(0:ny-2)
    meandy = mean(dy)
    stddy = stddev(dy)

    fit = mpfitexpr('P[0]+P[1]*X+P[2]*X^2',x, y,error, [y[0],meandy,0.001],/weight)
    ;fit = poly_fit(x,y,2,sigma=sigma)

    !p.multi=[0,1,3]
    cgplot, x, y, charsize=1., /ynozero, xstyle=1
    cgplots, x, fit[0]+fit[1]*x+fit[2]*x^2, linestyle=2, color='grn5'
    cgtext, x[ny/6], fit[0]+fit[1]*x[ny/6]+fit[2]*x[ny/6]^2, 'y = '+strtrim(fit[0],2)+' + '+$
        strtrim(fit[1],2)+'x + '+strtrim(fit[2],2)+'x^2', charsize=1.

    cgplot, dy, color='red3', charsize=1., xstyle=1
    cgplots, [0,ny-1],[meandy,meandy], color='grn5', linestyle=2
    cgplots, [0,ny-1],[meandy-stddy,meandy-stddy], color='grn5', linestyle=2
    cgplots, [0,ny-1],[meandy+stddy,meandy+stddy], color='grn5', linestyle=2

    showonetrack, tpt, i
end

pro gtptselect, filename

tpt = read_gdf(filename)

bID = widget_base(/row, title='Track Selector', xpad=0, ypad=0, mbar=mbar)
bScreen = widget_base(bID, /row)
draw = widget_draw(bScreen, xsize=400, ysize=700)

mnu1 = widget_button(mbar, /menu, value='Control')
mnu11 = widget_button(mnu1, value='Next', accel='Right', uvalue='next')
mnu12 = widget_button(mnu1, value='Prev', accel='Left', uvalue='prev')
mnu13 = widget_button(mnu1, value='Quit', accel='Ctrl+q', uvalue='quit')

bCommand = widget_base(bID, /col)
bNext = widget_button(bCommand, value='Next', uvalue='next')
bPrev = widget_button(bCommand, value='Prev', uvalue='prev')
bDel = widget_button(bCommand, value='Delete', uvalue='del')
bTail = widget_button(bCommand, value='Tail', uvalue='tail')
bHead = widget_button(bCommand, value='Head', uvalue='head')
bSave = widget_button(bCommand, value='Save', uvalue='save')
bQuit = widget_button(bCommand, value='Quit', uvalue='quit')

bStatus = widget_base(bCommand, /col)
txt1 = widget_text(bStatus, xsize=5, value=strtrim(tpt(1,0,0),2), /editable, tab_mode=1,uvalue='frame')
txt2 = widget_text(bStatus, xsize=5, value='0', /editable, tab_mode=1,uvalue='index')
txt3 = widget_text(bStatus, xsize=5, value='0', /editable, tab_mode=1,uvalue='vel')
txt4 = widget_text(bStatus, xsize=5, value=strtrim(n_elements(tpt(1,0,*))-1,2), /editable, tab_mode=1,uvalue='vel')

imax = n_elements(tpt(1,0,*))
tmax = max(tpt(1,*,*))
meanv = 0
SV = { tpt:tpt, index:0, txt1:txt1, txt2:txt2, txt3:txt3, imax:imax, tmax:tmax, $
    meanv:meanv, filename:filename, txt4:txt4}

widget_control, bID, set_uvalue=SV, /realize
widget_control, draw, get_value=drawID
wset, drawID

plot_track, SV.tpt, SV.index

xmanager, 'gtptselect', bID, /no_block

end
