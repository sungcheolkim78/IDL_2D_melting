;+
; NAME:
;    fastfeature
;
; PURPOSE:
;    Find the centroids of disk-like features in an image quickly.
;
; CATEGORY:
;    Image processing; digital video microscopy
;
; CALLING SEQUENCE:
;    f = fastfeature(image,threshold)
;
; INPUTS:
;    image: two-dimensional gray-scale image
;
;    threshold: gray level distinguishing objects from background.
;
; KEYWORD PARAMETERS:
;    dark: if set, then objects are darker than background.
;        Default: objects are assumed to be brighter than
;        background.
;
;    center: if set, return coordinates relative to the center of
;        the field of view.
;        Default: origin is set at the lower left corner.
;
; OUTPUTS:
;    f: [3,nobjects] array of located features.
;        f[0,*]: x coordinates.
;        f[1,*]: y coordinates.
;        f[2,*]: integrated brightness of the object, relative to
;                threshold.
;
; RESTRICTIONS:
;    Images should be two dimensional with real-valued pixels.
;
; PROCEDURE:
;    Threshold the image.  Locate contiguous blobs of
;    above-threshold pixels.  Return the brightness-weighted
;    centroids of those blobs.
;
; EXAMPLE:
;    IDL> a = idlsnap()   ; acquire image
;    IDL> h = histogram(a,min=0,max=255)
;    IDL> plot, h         ; estimate threshold from plot
;    IDL> f = fastfeature(a,threshold)
;    IDL> foverlay, f, a  ; see how it turned out
;
; MODIFICATION HISTORY:
; 12/12/2004 David G. Grier, New York University: created.
; 01/14/2009 DGG: return -1 if no particles are found above threshold.
; 06/10/2010 DGG: Documentation fixes.  Added COMPILE_OPT.
;
; Copyright 2004-2010 David G. Grier
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

function fastfeature, image, threshold, $
                      center = center, dark = dark

COMPILE_OPT IDL2

sz = size(image)
w = sz[1]
h = sz[2]

if keyword_set(dark) then $
  a = label_region(image lt threshold) $
else $
  a = label_region(image gt threshold)

n = histogram(a, reverse_indices = r)
npts = n_elements(n)
if npts le 1 then return, -1
f = fltarr(3, npts-1)
for i = 1, npts-1 do begin
   p = r[r[i]:r[i+1]-1]
   f[0, i-1] = total(p mod w)/n[i]
   f[1, i-1] = total(fix(p/w))/n[i]
   f[2, i-1] = total(abs(image[p]-threshold))
endfor

if keyword_set(center) then begin
   f[0, *] -=  w/2.
   f[1, *] -=  h/2.
endif

return, f
end
