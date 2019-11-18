;Name Crop_jpeg
;
;Purpose: To crop jpg files to the window interested in
;
;
;
;History:  Created by Lichao Yu 11/10/2011 use Sung's code
;
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


Pro Crop_jpeg, pt 
on_error,2

    NF = n_elements(pt[0,0,*])
    x = n_elements(pt[*,0,0])
    y = n_elements(pt[0,*,0])
    window,0,xsize=x, ysize=y
    
    for i=0, nf-1 do begin
        a0 = pt[*,*,i]
        tvscl, a0
        filename=ffilename1('crop', i)
        image = cgsnapshot(/jpeg, filename=filename, /nodialog)

    endfor
    
end
        