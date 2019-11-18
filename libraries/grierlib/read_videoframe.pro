;+
; NAME:
;    READ_VIDEOFRAME
;
; PURPOSE:
;    Read the next available video frame from a video stream opened
;    with OPEN_VIDEOFILE.
;
; CATEGORY:
;    Image acquisition, Image analysis
;
; CALLING SEQUENCE:
;    a = read_videoframe(s)
;
; INPUTS:
;    s: structure describing the video stream that is obtained
;       by running OPEN_VIDEOFILE.
;
; OUTPUTS:
;    a: video frame
;
; KEYWORD PARAMETERS:
;    geometry: 2-element array specifying the desired width and height
;        of the image.  Setting this keyword overrides both the
;        default size of the video frame and s.geometry set with
;        open_videofile.
;
; KEYWORD FLAGS:
;    grayscale: If set, return gray-scale image.
;        Default: RGB image.  Setting this keyword overrides both the
;        default type of the image and also s.grayscale set with
;        open_videofile.
;
; RESTRICTIONS:
;    Can read any video format that is supported by the underlying
;    OpenCV codec.  On linux systems, this is provided by FFMPEG.
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to access commands from idlvideo.so,
;    which in turn is based on the OpenCV project.
;
; EXAMPLE:
;    IDL> s = open_videofile("myfile.avi")
;    IDL> if available_videoframe(s) then a = read_videoframe(s)
;    IDL> close_video, s
;
; MODIFICATION HISTORY:
; 01/22/2010: Written by David G. Grier, New York University
; 01/27/2010: DGG store current frame number in video stream
;   structure.
; 03/02/2010: DGG OpenCV does not correctly handle frame numbers for
;   all video formats.  Removed frame number references.
;   Debug should be cast long.
; 03/10/2010: DGG added support for s.geometry and s.grayscale.
; 06/10/2010: DGG corrected error handling and added COMPILE_OPT.
;
; Copyright (c) 2010 David G. Grier
;
;-

function read_videoframe, s, $
                          geometry = geometry, $
                          grayscale = grayscale, $
                          debug = debug

COMPILE_OPT IDL2

if ~is_videostream(s) then return, 0

debug = long(keyword_set(debug))
gray = long(keyword_set(grayscale) or s.grayscale)

if n_elements(geometry) eq 2 then begin
   w = long(geometry[0])
   h = long(geometry[1])
endif else if s.geometry[0] gt 0 then begin
   w = s.geometry[0]
   h = s.geometry[1]
endif else begin
   w = s.width
   h = s.height
endelse

if gray then $
   a = bytarr(w, h, /NOZERO) $
else $
   a = bytarr(s.channels, w, h, /NOZERO)

error = call_external('idlvideo.so', 'video_readvideoframe', $
                      s.stream, $
                      a, w, h, $
                      gray, $
                      debug)

if error ne 0 then $
   message, "Failed to read image from " + s.filename, /inf

return, a
end
