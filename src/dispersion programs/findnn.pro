function Findnn, x, y, index, factor, partn=partn
    if not keyword_set(partn) then partn=0
      
    flag = 0
    np = n_elements(x)
    for i = 0, np-1 do begin
        
        dis = sqrt((x(i)-x(index))^2 + (y(i)-y(index))^2)
        if dis lt 13*factor and dis gt 12*factor then begin
            case partn of
                2:   if x(i)-x(index) gt 0 and (y(i)-y(index)) gt (x(i)-x(index)) then begin 
                          rightindex = i
                          flag = 1
                      endif
                -2:   if x(index)-x(i) gt 0 and (y(index)-y(i)) gt (x(index)-x(i)) then begin 
                          rightindex = i
                          flag = 1
                      endif             
                 3:   if (y(i)-y(index)) gt 0 and (x(i)-x(index)) lt 0 then begin 
                          rightindex = i
                          flag = 1
                      endif
                 -3:   if (y(i)-y(index)) lt 0 and (x(i)-x(index)) gt 0  then begin 
                          rightindex = i
                          flag = 1
                      endif   
                 1:   if (x(i)-x(index)) gt 0 and (y(i)-y(index)) lt (x(i)-x(index)) then begin 
                          rightindex = i
                          flag = 1
                      endif
                 -1:   if (x(index)-x(i)) gt 0 and (y(index)-y(i)) lt (x(index)-x(i)) then begin 
                          rightindex = i
                          flag = 1
                      endif                   
            endcase
            if flag then break
        endif
    endfor
    
    if not flag then rightindex=10000
    return, rightindex    
end