;+
; NAME:
;    OPEN_VIDEOCAMERA
;
; PURPOSE:
;    Opens an OpenCV-compatible video camera for subsequent
;    frame acquisition.
;
; CATEGORY:
;    Image acquisition, Image analysis
;
; CALLING SEQUENCE:
;    s = open_videocamera([number])
;
; OPTIONAL INPUT:
;    number: integer specifying camera number.
;        Default: use first available video camera.
;
; KEYWORDS:
;    geometry: [width,height] to rescale frames
;
; KEYWORD FLAGS:
;    grayscale: if set, convert color images to grayscale
;
; OUTPUTS:
;    s: structure describing the video stream.
;    s.filename: input filename
;    s.stream:   video stream index
;    s.width:    width of image in pixels
;    s.height:   height of image in pixels
;    s.channels: number of color channels
;    s.geometry: geometry to rescale image
;    s.grayscale: flag to convert color images into grayscale
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to access commands from idlvideo.so,
;    which in turn is based on the OpenCV project.
;
; EXAMPLE:
;    IDL> s = open_videocamera(/gray,geometry=[640,480])
;    IDL> if available_videoframe(s) then a = read_videoframe(s)
;    IDL> close_video, s
;
; RESTRICTIONS:
;    Updating frame index does not work because of OpenCV bugs.
;
; MODIFICATION HISTORY:
; 04/26/2010: Written by David G. Grier, New York University
; 06/10/2010: DGG. Corrected error condition handling.  Added COMPILE_OPT.
;
; Copyright (c) 2010 David G. Grier
;-

function open_videocamera, number, $
                         grayscale = grayscale, $
                         geometry = geometry, $
                         debug = debug

COMPILE_OPT IDL2

if n_params() eq 0 then number = -1L
stream = 0L
width = 0L
height = 0L
channels = 0L
debug = long(keyword_set(debug))

error = call_external('idlvideo.so', 'video_queryvideocamera', $
                      number, $
                      stream, width, height, channels, $
                      debug)

if error ne 0 then begin
   if debug then $
      message, "Could not acquire an image", /inf
   return, -1
endif

if n_elements(geometry) ne 2 then geometry = [-1, -1]

grayscale = long(keyword_set(grayscale))

s = {videostream, $
     filename:'Camera: '+strtrim(number, 2), $
     stream:stream, $
     width:width, $
     height:height, $
     channels:channels, $
     geometry:long(geometry), $
     grayscale:grayscale}

return, s

end
