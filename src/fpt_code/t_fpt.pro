;+
; Name: t_fpt
; Purpose: calculate fpt from one track
; Input: t_fpt, tpt, length
; History: created by sungcheol kim, 1/24/12
;-

function t_fpt, tpt, length, verbose=verbose
    n = n_elements(tpt(0,0,*))
    result = 0
    
    for i=0,n-1 do begin
        tl = tpt(1,0,i)
        y = tpt(1,1:tl,i)
        dy = y(2:tl-1)-y(1:tl-2)

        if mean(dy) lt 0 then y = -y
        if max(abs(y(0)-y(tl-1))) lt length then continue

        ;print, length, tl
        for j=0,tl-2 do begin
            ty = y(j:(tl-1))-y(j)
            ;print, max(ty)
            if max(ty) lt length then break

            for k=1,tl-j-4 do begin
                if (length ge ty(k)) and (length lt ty(k+1)) then begin
                    f = float(k) + (float(length) - ty(k))/float(ty(k+1)-ty(k))
                    result = [result, f]
                    if keyword_set(verbose) then print, 'detect!'
                    break
                endif
            endfor

        endfor
    endfor

    print, strtrim(n_elements(result(1:*)),2)+' data points'
    return, result[1:*]
end
