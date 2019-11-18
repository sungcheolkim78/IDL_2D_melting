;+
; NAME:
;		write_gdf
; PURPOSE:
;		Writes IDL-style data to disk in a format which can be
;		read back in easily.
;
; CATEGORY:
;		General Purpose Utility
; CALLING SEQUENCE:
;		write_gdf,data,file
; INPUTS:
;		data:	Data structure to be written to disk.
;		file:	Complete pathname of the file to be written.
; KEYWORD:
;		ascii:	Produce an ASCII file rather than the default
;			binary file.
; SIDE EFFECTS:
;		Creates a file.
; RESTRICTIONS:
;		Current version does not support structures or arrays of
;		structures.
; PROCEDURE:
;		Writes a header consisting of a long MAGIC number followed
;		by the long array produced by SIZE(DATA), followed by the
;		data itself.
;		If the file is ASCII, the header tag is an identifying
;		statement, followed by all of the same information in
;		ASCII format.
; MODIFICATION HISTORY:
; Written by David G. Grier, AT&T Bell Laboratories, 09/01/1991
; 03/17/2010 DGG: Code and documentation cleanups.
;
; Copyright (c) 1991-2010 David G. Grier
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
pro write_gdf, data, file, ascii=ascii
on_error,2			; return to caller on error

MAGIC = 082991L
HEADER = 'GDF v. 1.0'
openw, lun, file, /get_lun
sz = size(data)
if keyword_set(ascii) then begin
	printf, lun, HEADER
	printf, lun, sz[0]
	printf, lun, sz[1:*]
	printf, lun, data
	endif $
else begin
	writeu, lun, MAGIC
	writeu, lun, sz
	writeu, lun, data
	endelse
close, lun
free_lun, lun
end
