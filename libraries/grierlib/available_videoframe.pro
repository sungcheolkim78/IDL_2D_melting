;+
; NAME:
;    AVAILABLE_VIDEOFRAME
;
; PURPOSE:
;    Determine whether a video frame is available on the video stream
;    opened with OPEN_VIDEOFILE.
;
; CATEGORY:
;    Image acquisition, Image analysis
;
; CALLING SEQUENCE:
;    res = available_videoframe(s)
;
; INPUTS:
;    s: structure describing the video stream that is obtained
;       by running OPEN_VIDEOFILE.
;
; OUTPUTS:
;    res: TRUE if a video frame is available.
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
; 03/02/2010: DGG: debug should be long
;
; Copyright (c) 2010 David G. Grier
;
;-

function available_videoframe, s, debug=debug

debug = long(keyword_set(debug))

if ~is_videostream(s) then return, 0

return, call_external('idlvideo.so', 'video_frameready', $
                      s.stream, $
                      debug)
end
