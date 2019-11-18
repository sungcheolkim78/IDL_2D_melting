;+
; Name: ps_symbol
; Purpose: make string charactor for ps print
; Input: ps_symbol, name
;-

function ps_symbol, name
on_error,2

case name of
'pm': thisletter = "261B
'mu': thisletter = "155B
'<': thisletter = "341B
'>': thisletter = "361B
'sum': thisletter = "345B
'pro': thisletter = "325B
'phi': thisletter = "171B
'Phi': thisletter = "131B
'times': thisletter = "264B
'pi': thisletter = "160B
'theta': thisletter = "161B
else:
endcase

result = '!9'+string(thisletter)+'!X'
return, result
end
