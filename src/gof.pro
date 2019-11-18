;+
; Name: gof
; Purpose: change directory for First Passage Problem
; Input: gof
; History: created by sungcheol kim - 10/29/11
;-

pro gof

case !version.os of
  'darwin': basedir = '~/Dropbox/Shared/IDL/Data/FPT' 
  'Win32': begin
    if strcmp(!version.arch, 'x86') then basedir = 'C:\Documents and Settings\linglab\My Documents\Dropbox\IDL\Data\FPT'
    if strcmp(!version.arch, 'x86_64') then    basedir = 'C:\Users\Ling\Dropbox\IDL\Data\FPT'
    end
  else: basedir = '~/Dropbox/IDL/Data/FPT'
endcase

end
