;+
; NAME:
;    OPEN_VIDEOFILE
;
; PURPOSE:
;    Opens a video file for subsequent frame-by-frame reading.
;
; CATEGORY:
;    Image acquisition, Image analysis
;
; CALLING SEQUENCE:
;    s = open_videofile(filename)
;
; INPUTS:
;    filename: string specifying the file name of the video file.
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
; RESTRICTIONS:
;    Can read any video format that is supported by the underlying
;    OpenCV codec.  On linux systems, this is provided by ffmpeg and
;    gstreamer.
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
; RESTRICTIONS:
;    Updating frame index does not work because of OpenCV bugs.
;
; MODIFICATION HISTORY:
; 01/22/2010: Written by David G. Grier, New York University
; 01/27/2010: DGG introduced s.frame
; 03/02/2010: DGG OpenCV gets frame numbers wrong for some formats.
;   Removed hooks for frame numbers.  debug should be long.
; 03/10/2010: DGG Added geometry and grayscale keywords.
; 06/10/2010: DGG Corrected error handling and added COMPILE_OPT.
;
; Copyright (c) 2010 David G. Grier
;-

function open_videofile, filename, $
                         grayscale = grayscale, $
                         geometry = geometry, $
                         debug = debug

COMPILE_OPT IDL2

stream = 0L
width = 0L
height = 0L
channels = 0L
debug = long(keyword_set(debug))

if not file_test(filename, /READ, /REGULAR, /NOEXPAND_PATH) then begin
   message, "Can not open " + filename + " for reading", /inf
   return, -1
endif

error = call_external('idlvideo.so', 'video_queryvideofile', $
                      filename, $
                      stream, width, height, channels, $
                      debug)

if error ne 0 then begin
   message, "Could not query "+filename, /inf
   return, -1
endif

if n_elements(geometry) ne 2 then geometry = [-1, -1]

grayscale = long(keyword_set(grayscale))

s = {videostream, $
     filename:filename, $
     stream:stream, $
     width:width, $
     height:height, $
     channels:channels, $
     geometry:long(geometry), $
     grayscale:grayscale}

return, s

end
