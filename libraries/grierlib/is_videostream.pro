;+
; NAME:
;    IS_VIDEOSTREAM
;
; PURPOSE:
;    Check whether a variable is a video stream returned by
;    OPEN_VIDEOFILE.
;
; CATEGORY:
;    Image acquisition, Image analysis
;
; CALLING SEQUENCE:
;    ret = is_videostream(s)
;
; INPUTS:
;    s: variable to be checked.
;
; OUTPUTS:
;    ret: TRUE if s is a video stream.  FALSE otherwise.
;
; PROCEDURE:
;    Checks if s is a named VIDEOSTREAM structure.
;
; EXAMPLE:
;    IDL> s = open_videofile("myfile.avi")
;    IDL> print, is_videostream(s)
;
; MODIFICATION HISTORY:
; 01/25/2010: Written by David G. Grier, New York University
; 06/10/2010: DGG. Eliminated QUIET keyword.  Added COMPILE_OPT.
;
; Copyright (c) 2010 David G. Grier
;-

function is_videostream, s, quiet=quiet

COMPILE_OPT IDL2

is_vs = strcmp(size(s, /sname), "videostream", /fold_case)

return, is_vs

end
