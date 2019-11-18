;+
; NAME:
;    aziavg
;
; PURPOSE:
;    Average a two dimensional data set over angles about its center.
;
; CATEGORY:
;    Image Processing
;
; CALLING SEQUENCE:
;    result = aziavg( data )
;
; INPUTS:
;    data: two dimensional array of any type except string or complex
;
; KEYWORD PARAMETERS:
;    center: coordinates of center: [xc,yc].  Default is to use data's
;        geometric center.
;
;    rad: maximum radius of average [pixels]
;        Default: half the minimum dimension of the image.
;
;    deinterlace: If set to an even number, average only over even 
;        numbered lines.  Similarly if set to an odd number.
;        This is useful for analyzing interlaced video images.
;
; OUTPUTS:
;    result: data averaged over angles as a function of radius from
;        the center point, measured in pixels.  Result is single precision.
;
; PROCEDURE:
;    data[x,y] sits at radius r = sqrt((x-xc)^2 + (y-yc)^2) 
;        from the center, (xc,yc).  Let R be the integer part
;        of r, and dR the fractional part.  Then this point is
;        averaged into result(R) with a weight 1-dR and into
;        result(R+1) with a weight dR.
;
; RESTRICTIONS:
;    data must be two-dimensional and must not be string type
;
; MODIFICATION HISTORY:
; Written by:	David G. Grier, The University of Chicago, 07/30/1992
; 06/1994 DGG Handles complex type correctly
; 08/1999 DGG Added keyword CENTER and modernized array notation
; 01/27/2009 DGG Added DEINTERLACE keyword.  Cleaned up formatting.
;     Documentation fixes.
; 02/03/2009 DGG Return -1 if no pixels are within range of
;     the center.  Added RAD keyword.
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
function aziavg, _data, $
                 center = center, $
                 rad = rad, $
                 deinterlace = deinterlace

on_error,2			; return to calling routine on error

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
   xc = 0.5D * double(nx - 1)   ; indices start at 0
   yc = 0.5D * double(ny - 1)   ; ... in y also
endelse

if complexdata then $ 		; leave complex type alone
   a = _data $
else $
   a = double(_data)


if n_elements(rad) eq 1 then $  ; maximum radius [pixels]
   rmax = round(rad) $
else $
   rmax = nx/2 < ny/2

if complexdata then $
   sum = complexarr(rmax + 1) $
else $
   sum = dblarr(rmax + 1)
n = dblarr(rmax + 1)

r = ((dindgen(nx) - xc) # replicate(1.D, ny))^2 + $
    (replicate(1.D, nx) # (dindgen(ny) - yc))^2

if n_elements(deinterlace) eq 1 then begin
   n0 = deinterlace mod 2
   a = a[*,n0:*:2]
   r = r[*,n0:*:2]
endif

w = where(r lt rmax^2, ngood)

if ngood lt 0 then return, -1 ;	no pixels in average

r = sqrt(r[w])               ; only consider data in range
dl = a[w]
ri = long(r)                 ; integer index for r
fh = r - ri                  ; fraction in higher bin
fl = 1.D - fh		; fraction in lower bin
dh = dl * fh                 ; apportion fractions
dl = dl * fl

for i = 0L, ngood-1 do begin	; loop through data points in range
   ndx = ri[i]                  ; lower bin
   sum[ndx]   = sum[ndx]   + dl[i]
   n[ndx]     = n[ndx]     + fl[i]
                                ; higher bin
   sum[ndx+1] = sum[ndx+1] + dh[i]
   n[ndx+1]   = n[ndx+1]   + fh[i]
endfor

return, sum/n			; normalize by number in each bin
end
