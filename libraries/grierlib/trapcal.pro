;+
; NAME:
;    trapcal
;
; PURPOSE:
;    Determine the stiffness of an optical trap
;    for a particular probe particle
;    and also the particle's viscous drag coefficient
;    from measurements of the particle's thermally driven
;    trajectory.
;
; CATEGORY:
;    Particle tracking, Optical trapping
;
; CALLING SEQUENCE:
;    res = tracpcal(r, drsq)
;
; INPUTS:
;    r: [ndims,nsteps] floating point array: measured position of probe
;        particle in NDIMS dimensions over NSTEPS time steps.
;        To obtain results in SI units, positions should be measured
;        in meters.
;
; OPTIONAL INPUTS:
;    drsq: squared error in particle position measurements,
;        expressed in the same units as R.
;        Default: 1e-4 (i.e. 1 percent relative error)
;
; OUTPUTS:
;    res: [ndims,4]
;    res[*,0]: stiffnesses [1/length^2] per k_B T
;    res[*,1]: errors in stiffnesses [1/length^2] per k_B T
;    res[*,2]: drag coefficients [1/length^2/time_interval] per k_B T
;    res[*,3]: errors in drag coefficients
;
;    Assuming lengths are measured in meters, SI stiffnesses are
;    obtained by multiplying res[*,0:1] by the thermal energy scale,
;    k_B T, in Joules.  Drag coefficients are obtained by multiplying
;    res[*,2:3] by k_B T and by the time interval between measurements
;    in seconds.
;
; RESTRICTIONS:
;    Reliable results for the drag coefficients are available only if
;    the viscous relaxation time is comparble to the measurement
;    interval, or res[*,2] / res[*,0] \approx 1.
;
; REFERENCE:
;    M. Polin, K. Ladavac, S. Lee, Y. Roichman and D. G. Grier,
;    "Optimized holographic optical traps,"
;    Optics Express 13, 5831-5845 (2005).
;
; MODIFICATION HISTORY:
; 06/09/2010 Written by David G. Grier, New York University.
;    First public release of code written in 2005 by
;    David G. Grier and Marco Polin, and modified in 2009 by Bo Sun.
; 06/10/2010 Make index long.
;
; Copyright (c) 2010 David G. Grier, Marco Polin and Bo Sun
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

function trapcal, r, drsq

; r : [ndims,nsteps] array of particle positions
; drsq : mean-square measurement error

nsteps = n_elements(r[0, *])

if n_params() eq 1 then drsq = 1e-4

; mean (equilibirium) position
rc = total(r,2)/nsteps

for t = 0L, nsteps-1 do $
   r[*,t] -= rc

c0 = total(r^2,2)/nsteps
c1 = total(r * shift(r, 0, 1), 2)/nsteps
c2 = total(r * shift(r, 0, 2), 2)/nsteps

w = where(c0 lt drsq, nsmall)
if nsmall gt 0 then $
   message, "measurement error exceeds displacement in" + $
            string(nsmall) + " trajectories", /inf

k = 1.D/c0 + $
    drsq * $
    (c0^4 - 2.D * c0^2 * c1^2 - 3.D * c1^4 + 2.D * c0 * c1^2 * c2) / $
    (c0^3 - c0 * c1^2)^2

g = -alog(c1/c0)/c0 - $
    drsq * $
    ((c0^2 - c1^2) * (c0^2 - c1^2 + c0 * c2) + $
     (c0^4 - 2.D * c0^2 * c1^2 - 3.D * c1^4 + 2.D * c0 * c1^2 * c2) * $
     alog(c1/c0)) / $
    (c0^3 - c0 * c1^2)^2
    
dk = sqrt(2.D/nsteps) * sqrt((c0^2 + c1^2)/(c0^2 - c1^2)) + $
     2.D * drsq * $
     (c0^6 + c0^4 * c1^2 - 9.D * c0^2 * c1^4 + 7.D * c1^6 + $
      6.D * c0^3 * c1^2 * c2 - 4.D * c0 * c1^4 * c2) / $
     (c0 * (c0^2 - c1^2)^3 * sqrt(nsteps/2.D) * $
      sqrt((c0^2 + c1^2)/(c0^2 - c1^2)))                
dk *= k

dg = sqrt(1.D/nsteps) * $
     sqrt(2.D + $
          (-c0^2 + c1^2 + 2.D * c1^2 * alog(c1/c0))^2 / $
          (c1^2 * (c0^2 - c1^2) * (alog(c1/c0))^2)) + $
     drsq * $
     ((c1^2 - c0^2)^3 * (-c1^2 + c0 * (c0 + c2)) + $
      2.D * c1^2 * alog(c1/c0) * $
      (c0 * (c0^2 - c1^2)^2 * c2 - 2.D * (c0^2 - c1^2) * $
       (c0^4 - 3.D * c0^2 * c1^2 + 2.D * c1^4 + c0^3 * c2) * alog(c1/c0) + $
       2.D*(c0^6 + c0^4 * c1^2 - 9.D * c0^2 * c1^4 + 7.D * c1^6 + $
            6.D * c0^3 * c1^2 * c2 - 4.D * c0 * c1^4 * c2) * $
       (alog(c1/c0))^2)) / $
     (c0 * c1^2 * (c0^2 - c1^2)^3 * sqrt(nsteps) * (alog(c1/c0))^3 * $
      sqrt(2.D + $
           (c1^2 - c0^2 + 2.D * c1^2 * alog(c1/c0))^2 / $
           (c1^2 * (c0^2 - c1^2) * (alog(c1/c0))^2)))
dg *= g
           
return,[[k],[dk],[g],[dg]]
end
