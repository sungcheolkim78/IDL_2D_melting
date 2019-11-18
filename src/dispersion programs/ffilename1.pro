;+
; Name: ffilename1
; Purpose: make filename sentence
; Input: ffilename, imagefile, index
; History:
;   created by sungcheol kim on 11/29/10
;   Modified by Sungcheol Kim, 2010/11/27
;       1) do not use query_tiff
;       2) tiff - 100 stacks, 512,512 size

function ffilename1,imagefile,index

if not keyword_set(index) then index=0

if (index eq 0) then return, imagefile+'_00000' else $
if (index lt 10) then interval = '_0000' else $
if (index lt 100) then interval = '_000' else $
if (index lt 1000) then interval = '_00' else $
if (index lt 10000) then interval = '_0' else $
if (index lt 100000) then interval = '_'

filename = imagefile+interval+strtrim(string(index),2)

return, filename
end

