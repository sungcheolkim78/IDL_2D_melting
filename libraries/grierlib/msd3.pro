;+
; NAME:
;       msd3
;
; PURPOSE:
;       Computes time evolution of the mean-square displacement 
;       of a time series, including estimates of the variance.
;
; CATEGORY:
;       Time series analysis, dynamics.
;
; CALLING SEQUENCE:
;       m = msd3(x)
;
; INPUTS:
;       x: [npts] sequence of measured values assumed to be
;          obtained at equal time intervals.
;
; KEYWORD PARAMETERS:
;       nlags: Maximum lag time to compute msd.
;              Default: NPTS/2
;
; OUTPUTS:
;       m: [2,nlags] array
;          m[0,*]: mean-square displacement
;          m[1,*]: statistical error in the msd.
;
; MODIFICATION HISTORY:
; Written by David G. Grier, New York University, 2/16/2008
; 06/10/2010 DGG Initial public release.
;
; Copyright 2008-2010 David G. Grier
;
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

function msd3, p, nlags=nlags

COMPILE_OPT IDL2

if size(p, /n_dimensions) ne 1 then $
   message, "argument must be a one-dimensional time series"

npts = n_elements(p)

if n_elements(nlags) ne 1 then $
   nlags = npts / 2

m = fltarr(2,nlags+1)           ; the answer

for tau = 1., nlags do begin
   d = p[tau:*] - p             ; displacements at lag tau

   ntau = floor((npts - 1)/tau - 1)  ; organize displacements into
   d = d[0:tau*ntau-1]               ; uncorrelated sets, indexed by j
   d = reform(d,tau,ntau)

   nu = total(d, 2)/ntau        ; mean displacement at lag tau in set j

   for j = 0, tau-1 do $        ; squared displacements from the mean
      d[j,*] = (d[j,*] - nu[j])^2
   mu = total(d, 2)/ntau        ; mean-squared displacement in set j
   
   m[0,tau] = total(mu)/tau     ; total mean-squared displacement at lag tau
   
                                ; compute standard deviation of msd in
                                ; set j

   for j = 0, tau-1 do $        ; differences between squared displacements and
      d[j,*] = d[j,*] - mu[j]   ; mean squared displacement in set j

   sigma = fltarr(tau,tau)      ; covariance matrix
   for j = 0, tau-1 do $
      sigma[*,j] = total(d * shift(d,j,0),2)
   sigma /= ntau

   m[1,tau] = sqrt(total(sigma)) / tau ; statistical error in msd
endfor

return, m
end
