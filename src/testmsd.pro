;+
; Name: testmsd
; Purpose: 
;       combine both randomws.pro and checkmsd.pro
;       test the linearity of dt(i) from 1D random walk
; Input: testmsd, amounts, steps, length
; 
; History:
;     created by Lichao Yu  8/04/11  Second algorithm of msd still required to modify
;-
function randomws, amounts, steps, length
on_error,1

if n_params() eq 2 then a = 1
if n_params() eq 3 then a = length

s=randomu(systime(1),steps*amounts)
print, amounts, steps
result = intarr(amounts, steps)

for j=0, steps-1 do begin
    for i=0, amounts-1 do begin
        p = round(s(i+j*amounts))*2-1
        result(i,j)= result(i,j-1)+a*p
    endfor
endfor

return, result

end

function checkmsd, x,  option=option
on_error, 1

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

pro testmsd, amounts, steps, length
on_error, 1

if n_params() LT 2 then print,'please input again!'
if n_params() eq 2 then a = 1
if n_params() eq 3 then a = length
plot, checkmsd(randomws(amounts, steps,a)), xtitle='steps', ytitle='dt', psym=1

end
