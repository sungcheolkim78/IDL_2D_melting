;+
; NAME: gpsplot
;
; GDL Version 0.9.0 (Linux i686 m32)
; Journal File for sungcheolkim@linglabserver
; Working directory: /home/sungcheolkim/Lab/2DCC/Alexsandros/dp_0001
; Date: Wed Dec 01 14:16:40 2010
;-

pro gpsplot,xdata,ydata,ratio=ratio,$
	fsize=fsize,fname=fname,$
	golden=golden,normal=normal,_extra=_extra

set_plot,'ps'

xrand = max(xdata) - min(xdata)
yrand = max(ydata) - min(ydata)
ratio = yrand/xrand
;print,ratio

if (ratio lt 0.5 || ratio gt 2.) then ratio = 3./4
if keyword_set(normal) then ratio = 4./5
if keyword_set(golden) then ratio = 2d/(1+sqrt(5))

xsize=8.8
if keyword_set(fsize) then xsize=fsize
margin=0.13
wall=0.03
a = 1 - margin - wall
b = a*ratio
ysize=(margin+b+wall)*xsize

x1 = margin
x2 = x1+a

y1 = margin
y2 = y1+b

ticklen=0.01
xticklen = ticklen/b
yticklen = ticklen/a

filename = 'output.eps'
if keyword_set(fname) then filename = fname
spawn, 'rm '+filename
device,file=filename,xsize=xsize,ysize=ysize

!P.THICK = 1
!X.MARGIN = [10,2]
!Y.MARGIN = [3,1]

plot, [min(xdata),max(xdata)],[min(ydata),max(ydata)] $
	,/noerase,/nodata,xticks=nxticks, yticks=nyticks $
	,xstyle=1, ystyle=1, xminor=1, yminor=1 $
	,xtickv=xtickvalues $
	,xthick=1.7, ythick=1.7 $
	,position=[x1,y1,x2,y2],font=0 $
	,xticklen=xticklen, yticklen=yticklen $
	,ytickv=ytickvalues,_extra=_extra
oplot,xdata,ydata,_extra=_extra

device,/close
set_plot,'x'

spawn,'gv '+filename

end
