;+
; NAME:
;    azistd
;
; PURPOSE:
;    Calcuate the standard deviation from the mean of a two
;    dimensional data set, averaged over angles, as a function of
;    radius from the center.
;
; CATEGORY:
;    Image Processing
;
; CALLING SEQUENCE:
;    result = azistd( data, [avg], center=center )
;
; INPUTS:
;    data: two dimensional array of any type except string or complex
;
; KEYWORD PARAMETERS:
;    center: coordinates of center: [xc,yc].  Default is to use data's
;        geometric center.
;
;    deinterlace: If set to an even number, compute azimuthal standard
;        deviation only over even number lines.  Similarly for odd
;        values.  Useful for analyzing interlaced video images.
;
; OUTPUTS:
;    result: standard deviation of data averaged over angles as a 
;        function of radius from the center point, measured in pixels.  
;        Result is single precision.
;
; OPTIONAL OUTPUT:
;    avg : azimuthal average of the data
;
; PROCEDURE:
;    data(x,y) sits at radius r = sqrt( (x-xc)^2 + (y-yc)^2 ) 
;    from the center, (xc,yc).  Let R be the integer part
;    of r, and dR the fractional part.  Then this point is
;    averaged into result(R) with a weight 1-dR and into
;    result(R+1) with a weight dR.
;
; RESTRICTIONS:
;	data must be two-dimensional and must not be string type
;
; MODIFICATION HISTORY:
; Written by David G. Grier, The University of Chicago, 07/30/1992
; 06/1994 DGG Handles complex type correctly
; 08/1999 DGG Added keyword CENTER and modernized array notation
; 04/2002 DGG Converted from aziavg
; 01/27/2009 DGG Added deinterlace keyword.  Documentation clean up.
;
; Copyright (c) 1992-2010 David G. Grier
;
; UPDATES:
;    The most recent version of this program may be obtained from
;    http://physics.nyu.edu/grierlab/software.html
; 
; LICENSE:
;    This program is free software; you can redistribute it and/or
;    modify it under the terms of the GNU General Public License as
;    published by the Free Software Foundation; either version 2 of the
;    License, or (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;    General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program; if not, write to the Free Software
;    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
;    02111-1307 USA
;
;    If the Internet and WWW are still functional when you are using
;    this, you should be able to access the GPL here: 
;    http://www.gnu.org/copyleft/gpl.html
;-
function azistd, _data, avg, $
                 center = center, deinterlace = deinterlace

on_error, 2			; return to calling routine on error

sz = size(_data)
if sz[0] ne 2 then message, "Requires 2-dimensional data set"
if (sz[3] lt 1) or (sz[3] gt 6) then message, "Inappropriate data type"
nx = sz[1]			; width
ny = sz[2]			; height 

complexdata = sz[3] eq 6

; center point
if n_elements(center) eq 2 then begin
   xc = double(center[0])
   yc = double(center[1])
endif else begin
   xc = 0.5D * double(nx - 1)	; indices start at 0
   yc = 0.5D * double(ny - 1)	; ... in y also
endelse

if complexdata then $ 		; leave complex type alone
   d = _data $
else $
   d = double(_data)

rmax = nx/2 < ny/2		; maximum radius in average

if complexdata then $
  sum = complexarr( rmax + 1 ) $
else $
  sum = dblarr( rmax + 1 )
n = dblarr( rmax + 1 )

r = ((dindgen(nx) - xc) # replicate(1.D, ny))^2 + $
    (replicate(1.D, nx) # (dindgen(ny) - yc))^2

if n_elements(deinterlace) eq 1 then begin
   n0 = deinterlace mod 2
   d = d[*, n0:*:2]
   r = r[*, n0:*:2]
endif

w = where( r lt rmax^2, ngood )

if ngood gt 0 then begin
   r = sqrt(r[w])               ; only consider data in range
   d = d[w]
   ri = long(r)                 ; integer index for r
   fh = r - ri                  ; fraction in higher bin
   fl = 1.D - fh		; fraction in lower bin
   dh = d * fh                  ; apportion fractions
   dl = d * fl
endif

for i = 0L, ngood-1 do begin	; loop through data points in range
   ndx = ri[i]                  ; lower bin
   sum[ndx]   = sum[ndx]   + dl[i]
   n[ndx]     = n[ndx]     + fl[i]
                                ; higher bin
   sum[ndx+1] = sum[ndx+1] + dh[i]
   n[ndx+1]   = n[ndx+1]   + fh[i]
endfor
avg = sum/n                     ; normalize by number in each bin

sum =  0 * sum                  ; reset sum for standard deviation
for i = 0L, ngood-1 do begin    ; loop through data points in range
   ndx = ri[i]                  ; lower bin
   sum[ndx]   = sum[ndx]   + fl[i] * (d[i] - avg[ndx]  )^2
   sum[ndx+1] = sum[ndx+1] + fh[i] * (d[i] - avg[ndx+1])^2
endfor
std = sqrt(sum/n)               ; standard deviation

return, std
end





