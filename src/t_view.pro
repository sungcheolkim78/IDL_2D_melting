;+
; Name: t_view
; Purpose: to see one or group of particles along time and with other particles
; Input: t_view, tt, id
;-

pro t_view, tt, id
on_error, 2

if n_params() eq 1 then begin
	gtriview, tt, 0, /numbering2
	return
endif 
if n_params() eq 2 then begin
	print, id
	print, 'Particles are tracked'
endif

startf = min(tt(5,*), max=endf)
waittime = 1

for i=startf,endf do begin
	ttc = tt(*,where(tt(5,*) eq i))
	fsc_plot, ttc(0,*), ttc(1,*), psym=3, xran=[0,640],yran=[0,480],xstyle=1,ystyle=1

	for j=0,n_elements(id)-1 do begin
		ttt = ttc(*,where(ttc(6,*) eq id(j)))
		fsc_plot, ttt(0,*), ttt(1,*), symcolor='blk6', psym=16,/overplot
	endfor

	print, 'Q,M,N,P: '+string(i,format='(I4)')
	kbinput = get_kbrd(waittime)

	if strcmp(kbinput,'m') then waittime = ~waittime
	if strcmp(kbinput,'p') and i gt 2 then i = i - 2
	if strcmp(kbinput,'q') then return
endfor

end
