;+
; Name: i_typematch
; Purpose: convert each type to corresponding code number
; Input: i_typematch
; History:
;   created on 8/18/11 by SCK
;-

function i_typematch, input
on_error, 0

s = size(input,/type)
case s[0] of
    2: flag = 1 ; integer - return string code
    4: flag = 1 ; float - return string code
    7: flag = 0 ; string - return integer code
    else: begin
        print, 'either string or integer - '+strtrim(s[0],2)
        return, 0
        end
endcase

typestring = ['SI', 'I2', 'I2d', 'I2a','I3', 'I3d', 'I4', 'I4d', 'I3a', 'I4a', $
              'DI2', 'DI2d','DI2da', 'DI3d', 'DI4d', 'DI2db', 'DI34b', 'DI6', 'DI2a', 'DI3a', $
              'SV', 'V2', 'V2d', 'V3', 'V4', 'V3d', 'V4d', $
              'SDa', 'SDb', 'D2', 'D3','D3d','D2a', 'D4d']
typecode = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, $
            11, 12, 13, 14, 15, 16, 17, 18, 19, 20, $
            21, 22, 23, 24, 25, 26, 27, $
            31, 32, 33, 34, 35, 36, 37]

if flag eq 1 then begin ; to String
    i = where(typecode eq input, ic)
    if ic gt 0 then return, typestring[i]
    return, -1
endif

if flag eq 0 then begin ; to integer
    i = where(typestring eq input, ic)
    if ic gt 0 then return, fix(typecode[i])
    return, -1
endif

end
