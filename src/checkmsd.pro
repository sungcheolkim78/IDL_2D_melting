;+
; Name: checkmsd
; Purpose: check the linearity of dt(i)
; Input: checkmsd, x(2d array)
;-

function checkmsd, x,  option=option
on_error, 2

if not keyword_set(option) then option = 1

n = n_elements(x(0,*))
amounts= n_elements(x(*,0))
rn = fix(n/2)

   
 case option of 
    1: begin
        dn = fltarr(amounts,n,/nozero)
        ll = lindgen(n)
   
        for j = 0, amounts-1 do begin
          d = (rebin(transpose(x(j,*)),n,n,/sample)-rebin(x(j,*),n,n,/sample))^2
          d = rotate(d,1)
          for i = 0, n-1 do  dn(j,i) = total((d(0+ll,i-ll))(0:i<(n-1)))/(i+1.)
        endfor
    
        pn=total(dn,1)/amounts
        temp = reverse(pn)
        
        return, temp
        
        end
  2: begin
    result = fltarr(rn,rn)

    for t=0,rn-1 do begin
      tx = shift(x,-1*t)
      result(*,t) = tx(0:rn-1)
    endfor

    result = result - rebin(transpose(x(0:rn-1)),rn,rn,/sample)

    return, total(result^2,2)/rn

  end

endcase
 


end
