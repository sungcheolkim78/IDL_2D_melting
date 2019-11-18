
Pro Autocorr, Q1, Q2, eval, startf, stopf, wavenumber, timenumber, interval=interval
on_error,2

if not keyword_set(interval) then    interval=1  


    autocorrLong = fltarr(wavenumber, timenumber)
    autocorrTran = fltarr(wavenumber, timenumber)

    for q=1, wavenumber do begin                           
        for t=1, timenumber do begin
            intv = interval*t
            count = 0
            tempx = 0
            tempy = 0
            for i= startf, stopf do begin 
                if i+intv gt stopf then continue
                count +=1
                tempx += (conj(Q1(i+intv,q-1))*Q1(i,q-1))                   ;Longitudinal                                               ;M direction 
                tempy += (conj(Q2(i+intv,q-1))*Q2(i,q-1))                   ;transversal
            endfor
            if count eq 0 then continue
            autocorrLong(q-1, t-1) = tempx/count/eval(0,q-1)
            autocorrTran(q-1, t-1) = tempy/count/eval(1,q-1)
        endfor
   endfor

filename1 = 'Auto_Long_wave='+strtrim(string(wavenumber),2)+'_time='+strtrim(string(timenumber),2)+'.txt'
filename2 = 'Auto_Tran_wave='+strtrim(string(wavenumber),2)+'_time='+strtrim(string(timenumber),2)+'.txt'    
   
write_text,autocorrLong,filename1
write_text,autocorrTran,filename2
   
  
end