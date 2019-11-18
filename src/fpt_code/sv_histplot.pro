;+
; Name: sv_histplot
; Purpose: plot histogram of survival probability from tpt file
; Input: sv_histplot, tpt, length, tmax=tmax, color=color
; History: created by sungcheol kim, 2/3/12
;-

pro sv_histplot, tpt, length, tmax=tmax, _extra=_extra

if not keyword_set(tmax) then tmax = 30

t = (findgen(tmax)+1.)/30.

x = t_sp(tpt, length, tmax=tmax)

dx = -i_dd(x)

cgplot, /window, /addcmd, /overplot, t(0:tmax-3), dx(0,*), psym=-15, _extra=_extra
oploterror, t(0:tmax-3), dx(0,*), dx(1,*), /addcmd, /window, psym=3, _extra=_extra

end

