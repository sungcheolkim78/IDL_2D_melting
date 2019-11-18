;+
; Name: i_coordinate
; Purpose: return all coordinate from tpt data at frame
; Input: coordinate, tpt, frame, option=option
; History: created by sungcheol kim, 2/3/12
;-

function i_coordinate, tpt, frame, option=option
    ; y coordinate is default
    if not keyword_set(option) then option = 1

    ntracks = n_elements(tpt(0,0,*))
    result = 0

    for i=0, ntracks-1 do begin
        if tpt(option, 0, i) gt frame then begin
            tl = tpt(1,0,i)
            y = tpt(1, 1:tl, i)
            x = tpt(0,1:tl,i)
            for j=0, tl-frame-2 do begin
                dy = y(frame+j)-y(j)
                dx = x(frame+j)-x(j)
                ;maxdx = min(y(j:j+frame-1)-y(j))
                ;if (dx lt 3.75) and (dx gt 0.5) then result = [result, dy]
                result = [result, dy]
            endfor
        endif
    endfor

    print, n_elements(result(1:*))

    return, result(1:*)
end
