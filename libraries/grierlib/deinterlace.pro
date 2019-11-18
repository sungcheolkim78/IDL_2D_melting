;+
; NAME:
;      deinterlace
;
; PURPOSE:
;      Deinterlaces an (interlaced) image.
;
; CATEGORY:
;      Image analysis
;
; CALLING SEQUENCE:
;      b = deinterlace(a)
;
; INPUTS:
;      a: [nx,ny] grayscale image
;
; KEYWORD FLAG:
;      odd: if set, return image based on odd field.
;           Default: return even field
;
; OUTPUTS:
;      b: [nx,ny] deinterlaced iamge
;
; RESTRICTIONS:
;      Only works on gray-scale images.
;
; PROCEDURE:
;      Use IDL array subscripting to obtain the
;      even, or optionally odd, field from the array.
;
; MODIFICATION HISTORY:
; 10/18/2008 David G. Grier, New York University.  Formalized an
;    informal utility that has been in use since the 1990's.
; 01/24/2009 DGG revised to use indexing rather than congrid,
;    thereby eliminating off-by-one errors when comparing
;    odd and even frames.
;
; Copyright (c) 2008-2010 David G. Grier
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

function deinterlace, image, odd = odd

sz = size(image)
if sz[0] ne 2 then begin
   message, "input should be a two-dimensional array", /inf
   return, image
endif

ny = sz[2]
ny -= 1 + ny mod 2

a = image
if keyword_set(odd) then $
   a[*,0:ny:2] = a[*,1:*:2] $
else $
   a[*,1:*:2] = a[*,0:ny:2]

return, a
end
