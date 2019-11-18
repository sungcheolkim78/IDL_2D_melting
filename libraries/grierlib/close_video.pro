;+
; NAME:
;    CLOSE_VIDEO
;
; PURPOSE:
;    Close a video stream that was opened with OPEN_VIDEOFILE.
;    or OPEN_VIDEOCAMERA
;
; CATEGORY:
;    Image acquisition, Image analysis
;
; CALLING SEQUENCE:
;    close_video, s
;
; INPUTS:
;    s: structure describing the video stream that is obtained
;       by running OPEN_VIDEOFILE or OPEN_VIDEOSOURCE
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
; 03/02/2010: DGG debug should be long
; 05/26/2010: DGG renamed and updated for camera support.
; 06/10/2010: DGG corrected error handling and added COMPILE_OPT.
;
; Copyright (c) 2010 David G. Grier
;-

pro close_video, s, debug=debug

COMPILE_OPT IDL2

debug = long(keyword_set(debug))

if is_videostream(s) then begin
   error = call_external('idlvideo.so', 'video_closevideosource', $
                         s.stream, $
                         debug)
   
   if error ne 0 then $
      message, "Error closing " + s.filename, /inf
endif

end
