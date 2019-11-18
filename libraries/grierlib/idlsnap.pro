;+
; NAME:
;    IDLSNAP
;
; PURPOSE:
;    Grab one grayscale image from a a video file or from a 
;    frame grabber using the IDLvideo interface
;
; CATEGORY:
;    Image acquisition, Image processing.
;
; CALLING SEQUENCE:
;    a = idlsnap([filename], channel = channel, geometry = geometry)
;
; OPTIONAL INPUTS:
;    filename: Name of a video file
;
; KEYWORD PARAMETERS:
;    channel: camera number.  Default: 0
;
;    geometry: Dimensions of image [xsize, ysize]
;        Default: [640,480] for a framegrabber, 
;                 or the natural dimensions for a video file.
;
; KEYWORD FLAGS:
;    stabilize: keep taking pictures until no pixel varies by more
;        than this value.
;
;    quiet: If set, do not provide diagnostic messages.
;
; OUTPUTS:
;    a: [xsize,ysize] byte array of pixels.
;       Returns -1 if image acquisition failed.
;
; PROCEDURE:
;    Calls routines from the IDLvideo library.
;
; EXAMPLE:
;    IDL> a = idlsnap()
;
; MODIFICATION HISTORY:
; 04/30/2003: David G. Grier, The University of Chicago, created.
; 09/29/2004: DGG New York University:
;                  replaced KEYWORD_SET with N_PARAMS.
;                  implemented STABILIZE keyword.
; Version 1.1 DGG, New York University.
;       Updated for IDL 6.1.
;       Try again if library call fails, rather than returning junk.
;
; Version 2.0 DGG: Updated for OpenCV interface
; 06/04/2010 DGG major overhaul
; 06/10/2010 DGG Return -1 on failure.  Add COMPILE_OPT.
;
; Copyright (c) 2003-2010 David G. Grier
;-

function idlsnap, filename, $
                  channel = channel, $
                  geometry = geometry, $
                  stabilize = stabilize, $
                  quiet = quiet

COMPILE_OPT IDL2

report = ~keyword_set(quiet)

if n_params() eq 1 then $
   s = open_videofile(filename, geometry = geometry, /gray) $
else begin
   if ~arg_present(channel) then $
      channel = 0

   if n_elements(geometry) ne 2 then $
      geometry = [640, 480]

   s = open_videocamera(channel, geometry = geometry, /gray)
endelse

if ~is_videostream(s) then begin
   if report then $
      message, "Could not acquire video frame", /inf
   return, -1
endif

image = read_videoframe(s)

if keyword_set(stabilize) then begin
   npix = 1
   maxpix = 60                  ; more than 2 seconds
   image2 = image
   repeat begin
      image = read_videoframe(s)
      delta = max(abs(fix(image)-fix(image2)))
      image = image2
      npix++
   endrep until (delta lt stabilize) or (npix ge maxpix)
   if npix ge maxpix and report then $
      message, "Image not stabilized", /inf
endif

close_video, s

return, image
end


