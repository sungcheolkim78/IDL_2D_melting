;+
; Name: brownplot
; Purpose
; Input: brownplot, filename
; History: created by sungcheol kim, lichao yu on 3/19/12
;-

pro brownplot, option, range=range

if not keyword_set(range) then range=1.5

a1 = readtext('defcoordinate-5.txt')
a2 = readtext('defcoordinate-7.txt')

a1(1:2,*) = a1(1:2,*)*0.083
a2(1:2,*) = a2(1:2,*)*0.083

case option of
    1: begin   ;mono-interstitial
        w4 = where(a1(3,*) eq 7,w4c)   ; I4
        w3 = where(a1(3,*) eq 3,w3c)   ; I2d
        w2 = where(a1(3,*) eq 5,w2c)   ; I3
        w1 = where(a1(3,*) eq 2,w1c)   ; I2

        p4 = where(a2(3,*) eq 7,w4c)   ; I4
        p3 = where(a2(3,*) eq 3,w3c)   ; I2d
        p2 = where(a2(3,*) eq 5,w2c)   ; I3
        p1 = where(a2(3,*) eq 2,w1c)   ; I2
        lists = ['I2','I3','I2d','I4']
        end
    2: begin   ;mono-vacancy
        w4 = where(a1(3,*) eq 25,w4c)   ; V4
        w3 = where(a1(3,*) eq 24,w3c)   ; V3
        w2 = where(a1(3,*) eq 22,w2c)   ; V2
        w1 = where(a1(3,*) eq 21,w1c)   ; SV

        p4 = where(a2(3,*) eq 25,w4c)   ; V4
        p3 = where(a2(3,*) eq 24,w3c)   ; V3
        p2 = where(a2(3,*) eq 22,w2c)   ; V2
        p1 = where(a2(3,*) eq 21,w1c)   ; SV
        lists = ['SV','V2','V3','V4']
        end
    3: begin   ;di-vacancy
        w1 = where(a1(3,*) eq 31,w1c)   ; SDa
        w2 = where(a1(3,*) eq 32,w2c)   ; SDb
        w3 = where(a1(3,*) eq 33,w3c)   ; D2
        w4 = where(a1(3,*) eq 35,w4c)   ; D3d

        p1 = where(a2(3,*) eq 31,w1c)   ; SDa
        p2 = where(a2(3,*) eq 32,w2c)   ; SDb
        p3 = where(a2(3,*) eq 33,w3c)   ; D2
        p4 = where(a2(3,*) eq 35,w4c)   ; D3d
        lists = ['SDa','SDb','D2','D3d']
        end
    4: begin   ;di-interstitial
        w1 = where(a1(3,*) eq 11,w1c)   ; DI2
        w2 = where(a1(3,*) eq 12,w2c)   ; DI2d
        w3 = where(a1(3,*) eq 14,w3c)   ; DI3d
        w4 = where(a1(3,*) eq 15,w4c)   ; DI4d

        p1 = where(a2(3,*) eq 11,w1c)   ; DI2
        p2 = where(a2(3,*) eq 12,w2c)   ; DI2d
        p3 = where(a2(3,*) eq 14,w3c)   ; DI3d
        p4 = where(a2(3,*) eq 15,w4c)   ; DI4d
        lists = ['DI2','DI2d','DI3d','DI4d']
        end
endcase

cgplot, a1(1,w4), a1(2,w4), psym=18, charsize=1., color='grn6', layout=[2,1,1], $
    /window, /isotropic, xran=[-1,1]*range, yran=[-1,1]*range,xstyle=1,ystyle=1, $
    xtitle='x (um)', ytitle='y (um)'
cgplot, a1(1,w1), a1(2,w1), psym=14, charsize=1., color='blu6', /overplot, /addcmd
cgplot, a1(1,w2), a1(2,w2), psym=15, charsize=1., color='red6', /overplot, /addcmd
cgplot, a1(1,w3), a1(2,w3), psym=17, charsize=1., color='black', /overplot, /addcmd

cgwindow,'al_legend', lists, psym=[14,15,17,18], colors=['blu6','red6','black','grn6'],/addcmd

cgplot, a2(1,p4), a2(2,p4), psym=18, charsize=1., color='grn6', layout=[2,1,2], $
    /window, /isotropic, xran=[-1,1]*range, yran=[-1,1]*range,xstyle=1,ystyle=1, /addcmd, $
    xtitle='x (um)', ytitle='y (um)'
cgplot, a2(1,p1), a2(2,p1), psym=14, charsize=1., color='blu6', /overplot, /addcmd
cgplot, a2(1,p2), a2(2,p2), psym=15, charsize=1., color='red6', /overplot, /addcmd
cgplot, a2(1,p3), a2(2,p3), psym=17, charsize=1., color='black', /overplot, /addcmd

cgwindow,'al_legend', lists, psym=[14,15,17,18], colors=['blu6','red6','black','grn6'],/addcmd

print, w1c, w2c, w3c, w4c

end
