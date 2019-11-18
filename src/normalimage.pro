;+
; Name: normalimage
; Purpose: normalize image for removing noise
; Input: normaliamge, imagearray, index, number=number
;-

function normalimage, imagearray, index, number=number

	if index eq 0 then begin
		result = [[[imagearray(*,*,0)]],[[imagearray(*,*,1)]]]
		return, total(result,3)/2
	endif

	nf = n_elements(imagearray(0,0,*))
	if index eq nf-1 then begin
		result = [[[imagearray(*,*,nf-2)]],[[imagearray(*,*,nf-1)]]]
		return, total(result,3)/2
	endif

	result = [[[imagearray(*,*,index-1)]],[[imagearray(*,*,index)]],[[imagearray(*,*,index+1)]]]
	return, total(result,3)/3

end
