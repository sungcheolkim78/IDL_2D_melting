;+
; NAME:
;    gplayvideo
;
; PURPOSE:
;    Frame-by-frame renderings of a video file using IDL graphics
;
; CATEGORY:
;    Image analysis, Plotting
;
; CALLING SEQUENCE:
;    playvideo, filename
;
; INPUTS:
;    filename: string containing the name of the video file
;
; KEYWORD PARAMETERS:
;    geometry: two-element array containing the preferred width and
;        height of the images in pixels.
;
; KEYWORD FLAGS:
;    grayscale: if set, present the image in grayscale.
;        Default: plot with 24-bit color.
;
; KEYBOARD COMMANDS:
; 'q': quit (interrupt)
; 'p': pause
;
; PROCEDURE:
;    Uses the IDLVIDEO package to open and read frames from the video
;    file.
;
; MODIFICATION HISTORY:
; 01/23/2010: Written by David G. Grier, New York University
; 05/26/2010: DGG added camera support
; 08/17/2010: DGG updated for IDL 8.0 image graphics.
;    Implemented pause.
; 10/24/2011: Sungcheol modified to use plotimage function
; 11/05/2011: Sungcheol modified to substract background
;
; Copyright (c) 2010 David G. Grier
;-
pro gplayvideo, filename, $
               camera = camera, $
               grayscale = grayscale, $
               geometry = geometry, $
               debug = debug, back=back

if keyword_set(camera) then $
   s = open_videocamera(grayscale = grayscale, $
                        geometry = geometry, $
                        debug = debug) $
else $
   s = open_videofile(filename, $
                      grayscale = grayscale, $
                      geometry = geometry, $
                      debug = debug)

if ~is_videostream(s, /quiet) then begin
   message, 'Could not open requested video stream', /inf
   return
endif

if not keyword_set(back) then back = 0

done = 0
a = read_videoframe(s)

tvscl, a(0,*,*)-back>0 
while available_videoframe(s) and ~done do begin
    a = read_videoframe(s)
   tvscl, a(0,*,*)-back>0
   c = get_kbrd(0)
   if c eq 'p' then begin
      message, 'PAUSED: hit any key to continue', /inf
      c = get_kbrd(1)
   endif
   done = c eq 'q'
endwhile

close_video, s

end
