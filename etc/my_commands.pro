; IDL Version 8.0.1 (linux x86_64 m64)
; Journal File for sungcheolkim@linglabserver2
; Working directory: /home/sungcheolkim
; Date: Tue Mar  1 10:52:19 2011
 
;Executed IDLSTARTUP.pro
print,randomu(1,1)
;     0.415999
print,randomu(3,1)
;     0.897916
.run randomwalker
plot, randomwalker(100)
; % Expression must be a scalar in this context: I.
.run randomwalker
plot, randomwalker(100)
print,randomu(0,1)
;     0.415999
print,randomu(0,1)
;     0.415999
print,randomu(0,1)
;     0.415999
print,randomu(0,2)
;     0.415999    0.0919649
print,randomu(s,2)
;     0.756410     0.529700
print,randomu(s,2)
;     0.930436     0.383502
print,randomu(s,2)
;     0.653919    0.0668422
print,randomu(s,2)
;     0.722660     0.671149
.run randomwalker
plot, randomwalker(100)
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(1000))
plot, s_msd(randomwalker(1000),option=2)
plot,randomwalker(1000)
plot,randomwalker(1000)
plot,randomwalker(1000)
plot,randomwalker(1000)
plot,randomwalker(1000)
plot,randomwalker(1000)
plot,randomwalker(1000)
plot,randomwalker(1000)
plot,randomwalker(1000)
plot,randomwalker(1000)
plot,randomwalker(300)
plot,randomwalker(300,5)
.run randomwalker
plot,randomwalker(300,5)
plot,randomwalker(300,5)
plot,randomwalker(300,5)
plot,randomwalker(300,5)
plot,randomwalker(300,5)
plot, s_msd(randomwalker(1000),option=2)
plot, s_msd(randomwalker(1000),option=1)
plot, s_msd(randomwalker(1000),option=2)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
.run randomwalker
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
print,randomu(s,10)
;     0.383416     0.631635     0.884707     0.519416     0.651519     0.237774
;     0.262453     0.762198     0.753356     0.909208
print,randomu(s,10)
;    0.0726859     0.272710     0.897656     0.274907     0.516292     0.359265
;     0.247039     0.486517     0.846167     0.830965
print,randomu(s,10)
;    0.0345721     0.991037     0.679296     0.766495    0.0605643     0.384142
;     0.477732     0.947764     0.934693     0.904653
.run randomwalker
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1001)
plot, randomwalker(1002)
print,systime()
;Tue Mar  1 11:22:31 2011
print,systime(/utc)
;Tue Mar  1 16:22:36 2011
print,systime(/julian)
;       2455622.0
.run randomwalker
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(100)
plot, randomwalker(1000)
plot, randomwalker(10000)
plot, randomwalker(1000)
print,systime(/julian)
;       2455622.0
print,systime(/seconds)
;   1.2989967e+09
print,systime(/seconds)
;   1.2989967e+09
print,systime(0,/seconds)
;   1.2989967e+09
print,systime(0,/seconds)
;   1.2989967e+09
print,systime()
;Tue Mar  1 11:25:40 2011
print,systime()
;Tue Mar  1 11:25:42 2011
print,systime()
;Tue Mar  1 11:25:43 2011
print,systime(1)
;   1.2989968e+09
print,systime(1)
;   1.2989968e+09
.run randomwalker
plot, randomwalker(10000)
plot, randomwalker(10000)
plot, randomwalker(10000)
plot, randomwalker(10000)
plot, randomwalker(10000)
plot, randomwalker(10000)
plot, randomwalker(10000)
plot, randomwalker(10000)
plot, randomwalker(10000)
plot, randomwalker(10000)
plot, randomwalker(10000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
.run randomwalker
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, randomwalker(1000)
plot, s_msd(randowmwalker(1000))
; % Variable is undefined: RANDOWMWALKER.
plot, s_msd(randowmwalker(1000))
; % Variable is undefined: RANDOWMWALKER.
plot, randomwalker(1000)
plot, s_msd(randowmwalker(1000))
; % Variable is undefined: RANDOWMWALKER.
plot, s_msd(randowmwalker(1000),option=1)
; % Variable is undefined: RANDOWMWALKER.
.run randomwalker
plot, s_msd(randowmwalker(1000),option=1)
; % Variable is undefined: RANDOWMWALKER.
.run s_msd
m = s_msd(randomwalker(100))
plot,m
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
plot, s_msd(randomwalker(100))
.run s_randomwalkertest
s_randomwalkertest, 100, 10
; % Variable is undefined: RANDOM.
.run s_randomwalkertest
s_randomwalkertest, 100, 10
.run s_randomwalkertest
s_randomwalkertest, 100, 10
.run s_randomwalkertest
s_randomwalkertest, 100, 10
.run s_randomwalkertest
s_randomwalkertest, 100, 10
.run randomwalker
.run s_randomwalkertest
s_randomwalkertest, 100, 10
s_randomwalkertest, 100, 100
s_randomwalkertest, 100, 1000
s_randomwalkertest, 1000, 10
s_randomwalkertest, 1000, 100
s_randomwalkertest, 1000, 1000
s_randomwalkertest, 2000, 100
s_randomwalkertest, 2000, 10
.run s_randomwalkertest
; % Syntax error.
; % 1 Compilation error(s) in module S_RANDOMWALKERTEST.
.run s_randomwalkertest
s_randomwalkertest, 2000, 10,option=2
; % Array subscript for RANDOMT must have same size as source expression.
.run s_randomwalkertest
s_randomwalkertest, 2000, 10,option=2
.run s_msd
s_randomwalkertest, 2000, 10,option=2
s_randomwalkertest, 2000, 10
.run s_msd
.run s_randomwalkertest
s_randomwalkertest, 2000, 10
; % Array subscript for RANDOMT2 must have same size as source expression.
.run s_msd
s_randomwalkertest, 2000, 10
s_randomwalkertest, 1000, 10
s_randomwalkertest, 1000, 100
s_randomwalkertest, 100, 100
print, fsc_color(1)
;Traceback Report from FSC_COLOR:
;     % The color name parameter must be a string.
;     % Execution halted at:  FSC_COLOR         518 /home/sungcheolkim/.idl/coyote/fsc_color.pro
;     %                       $MAIN$          
;    16777215
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
s_randomwalkertest, 100, 10
s_randomwalkertest, 100, 1000
.run s_randomwalkertest
s_randomwalkertest, 100, 1000
s_randomwalkertest, 100, 1000,/ps
; % Keyword BITS not allowed in call to: DEVICE
.run s_randomwalkertest
s_randomwalkertest, 100, 1000,/ps
.run s_randomwalkertest
s_randomwalkertest, 100, 1000
;Traceback Report from FSC_PLOT:
;     % Keyword YTIEL not allowed in call to: PLOT
;     % Execution halted at:  FSC_PLOT          465 /home/sungcheolkim/.idl/coyote/fsc_plot.pro
;     %                       S_RANDOMWALKERTEST   24 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
.run s_randomwalkertest
plot,indgen(10)
s_randomwalkertest, 100, 1000
.run s_randomwalkertest
s_randomwalkertest, 100, 1000
; % Variable is undefined: TRANKN.
.run s_randomwalkertest
s_randomwalkertest, 100, 1000
s_randomwalkertest, 100, 1000,/ps
.run s_randomwalkertest
s_randomwalkertest, 100, 100,/ps
.run s_randomwalkertest
s_randomwalkertest, 100, 100,/ps
s_randomwalkertest, 100, 200,/ps
go
;/home/sungcheolkim
;+-------------------------------------------
;  : 0 files
;                    
;                    
;                    
;                    
;                    
;+-------------------------------------------
ls
s_randomwalkertest, 1000, 200,/ps
s_randomwalkertest, 1000, 10,/ps
s_randomwalkertest, 2000, 100,/ps
s_randomwalkertest, 100, 100,/ps
s_randomwalkertest, 100, 1000,/ps
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
; % REBIN: String expression not allowed in this context: <STRING    Array[9]>.
.run s_randomwalkertest
s_randomwalkertest, 100, 100
; % REBIN: String expression not allowed in this context: <STRING    Array[9]>.
print, 'grn'+strtrim(indgen(9),2)
;grn0 grn1 grn2 grn3 grn4 grn5 grn6 grn7 grn8
.run s_randomwalkertest
s_randomwalkertest, 100, 100
; % REBIN: String expression not allowed in this context: COLORNAME.
colorn = 'grn'+strtrim(indgen(9),2)
help
print, rebin(colorn,15,1)
; % REBIN: String expression not allowed in this context: COLORN.
print, 'grn'+strtrim(indgen(30) mod 9,2)
;grn0 grn1 grn2 grn3 grn4 grn5 grn6 grn7 grn8 grn0 grn1 grn2 grn3 grn4 grn5 grn6
;grn7 grn8 grn0 grn1 grn2 grn3 grn4 grn5 grn6 grn7 grn8 grn0 grn1 grn2
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
.run s_randomwalkertest
s_randomwalkertest, 100, 100
s_randomwalkertest, 100, 100,/ps
ls
spawn,'rm *.eps'
ls
go,1
;0210-0410 0400-0530 0530-0900 0900-1130 1130-1530 1530-2020 2020-2520 2520-2620
;2620-2820 2820-2930 2930-3120 3120-3230 3230-3330 3330-3715 3840-4332 4332-5030
;5030-5458
go,1,210
;Voltage:  20.0  Freq.: 0.100  Hz T/4: 150.0 Frames
;/home/sungcheolkim/Lab/2DCC/Alexsandros/001128/0210-0410
;+------------------------------------------
;fg_00000.jpg fg_03268.jpg : 3269 files
;pt.fg0_1799         pt.fg1800_3268      
;pt2.fg_1799         
;tt.fg0_1799         tt.fg1800_3268      
;gr6.info0_14_0.20   gr6.info0_14_0.30   gr6.info0_14_0.40   gr6.info0_14_0.50   
;gr6.info0_15_0.20   gr6.info0_29_0.20   gr6.info0_3_0.20    gr6.info0_4_0.20    
;gr6.info0_4_0.50    gr6.info0_9_0.20    gr6.info1200_1229_0.gr6.info1500_1529_0.
;gr6.info150_179_0.20
;f.gr_0_0.10_ 0_10   f.gr_0_0.10_ 0_20   f.gr_10_0.10_ 0_10  f.gr_10_0.10_ 0_20  
;f.gr_1_0.10_ 0_10   f.gr_1_0.10_ 0_20   f.gr_2_0.10_ 0_10   f.gr_2_0.10_ 0_20   
;f.gr_3_0.10_ 0_10   f.gr_3_0.10_ 0_20   f.gr_4_0.10_ 0_10   f.gr_4_0.10_ 0_20   
;f.gr_5_0.10_ 0_10   f.gr_5_0.10_ 0_20   f.gr_6_0.10_ 0_10   f.gr_6_0.10_ 0_20   
;f.gr_7_0.10_ 0_10   f.gr_7_0.10_ 0_20   f.gr_8_0.10_ 0_10   f.gr_8_0.10_ 0_20   
;f.gr_9_0.10_ 0_10   f.gr_9_0.10_ 0_20   
;+------------------------------------------
cd,'..'
ls
s_randomwalkertest, 100, 100,/ps
s_randomwalkertest, 2000, 100,/ps
ls
printeps,'random*.eps'
x = randomwalker(100)
y = randomwalker(100)
plot,x,y
y = randomwalker(1000)
x = randomwalker(1000)
plot,x,y
x = randomwalker(10000)
y = randomwalker(10000)
plot,x,y
fsc_plot,x,y,color='blu6'
x = randomwalker(10000)
y = randomwalker(10000)
fsc_plot,x,y,color='blu6'
go,1
;0210-0410 0400-0530 0530-0900 0900-1130 1130-1530 1530-2020 2020-2520 2520-2620
;2620-2820 2820-2930 2930-3120 3120-3230 3230-3330 3330-3715 3840-4332 4332-5030
;5030-5458
go,1,4332
;Voltage:   0.0  Freq.: 0.000  Hz T/4:   Inf Frames
;/home/sungcheolkim/Lab/2DCC/Alexsandros/001128/4332-5030
;+------------------------------------------
;fg_00568.jpg fg_12012.jpg : 11445 files
;pt.fg0568_2367      pt.fg2368_4167      pt.fg4168_5967      pt.fg5968_7767      
;pt.fg7768_9567      pt.fg9568_12012     
;                    
;tt.fg0568_2367      
;                    
;f.den_0_0           f.den_0_1799g1      f.den_0_1799g2      f.den_0_1799g3      
;f.den_0_1799g4      f.den_0_1799g5      f.den_0_2444g6      f.gr_00.11.020.0    
;f.gr_0_0.05_ 1_20   f.gr_0_0.10_ 0_10   f.gr_0_0.10_ 0_20   f.gr_0_0.10_ 1_10   
;f.gr_0_0.10_ 1_20   f.gr_0_0.50_ 1_20   f.gr_10_0.10_ 0_10  f.gr_10_0.10_ 0_20  
;f.gr_1_0.10_ 0_10   f.gr_1_0.10_ 0_20   f.gr_2_0.10_ 0_10   f.gr_2_0.10_ 0_20   
;f.gr_3_0.10_ 0_10   f.gr_3_0.10_ 0_20   f.gr_4_0.10_ 0_10   f.gr_4_0.10_ 0_20   
;f.gr_5_0.10_ 0_10   f.gr_5_0.10_ 0_20   f.gr_6_0.10_ 0_10   f.gr_6_0.10_ 0_20   
;f.gr_7_0.10_ 0_10   f.gr_7_0.10_ 0_20   f.gr_8_0.10_ 0_10   f.gr_8_0.10_ 0_20   
;f.gr_9_0.10_ 0_10   f.gr_9_0.10_ 0_20   
;+------------------------------------------
; % Program caused arithmetic error: Floating divide by 0
tt = read_gdf('tt.fg0568_2367')
s = s_autocorrelation(tt)
;      2289.00      1800.00
; % Array subscript for RESULT must have same size as source expression.
.run s_autocorrelation
s = s_autocorrelation(tt)
;      2289.00      1800.00
help
fsc_plot,s
.run s_autocorrelation
s = s_autocorrelation(tt)
;      2289.00      1800.00
.run s_autocorrelation
s = s_autocorrelation(tt)
;      2289.00      1800.00
.run s_autocorrelation
s = s_autocorrelation(tt)
;      2289.00      1800.00
dx = getdx(tt,1)
plot,dx(0,*),psym=3
histoplot,dx(0,*)
histoplot,dx(1,*)
print,mean(dx(0,*))
;   -0.0124631
print,mean(dx(1,*))
;   0.00374263
dx = getdx(tt,2)
histoplot,dx(0,*)
histoplot,dx(1,*)
print,mean(dx(0,*))
;   -0.0249176
print,mean(dx(1,*))
;   0.00724494
dx = getdx(tt,3)
print,mean(dx(0,*))
;   -0.0373678
print,mean(dx(1,*))
;    0.0108689
dx = getdx(tt,4)
print,mean(dx(0,*))
;   -0.0496855
dx = getdx(tt,5)
print,mean(dx(0,*))
;   -0.0618879
dx = getdx(tt,6)
print,mean(dx(0,*))
;   -0.0740690
dx = getdx(tt,8)
print,mean(dx(0,*))
;   -0.0986257
dx = getdx(tt,15)
print,mean(dx(0,*))
;    -0.182828
mot=motion(tt)
trb = rm_motion(tt,mot)
plottr,tt
plottr,trb
s = s_autocorrelation(trb)
;      2289.00      1800.00
go,1
;0210-0410 0400-0530 0530-0900 0900-1130 1130-1530 1530-2020 2020-2520 2520-2620
;2620-2820 2820-2930 2930-3120 3120-3230 3230-3330 3330-3715 3840-4332 4332-5030
;5030-5458
go,1,5030
;Voltage:   0.0  Freq.: 0.000  Hz T/4:   Inf Frames
;/home/sungcheolkim/Lab/2DCC/Alexsandros/001128/5030-5458
;+------------------------------------------
;fg_00020.jpg fg_07987.jpg : 7968 files
;pt.fg0020_1819      pt.fg1820_3619      pt.fg3620_5419      pt.fg5420_7219      
;pt.fg7220_7987      
;                    
;tt.fg0020_1819      tt.fg_1819          tt.fg_3619          tt.fg_5419          
;tt.fg_7219          tt.fg_7987          
;gr6.info0_14_0.20   gr6.info0_4_0.20    gr6.info0_5_0.20    gr6.info0_5_0.40    
;gr6.info0_5_1.00    
;f.den_0_0           f.den_0_1799g1      f.den_0_1799g2      f.den_0_1799g3      
;f.den_0_1799g4      f.den_0_767g5       f.gr_0_0.05_ 1_10   f.gr_0_0.10_ 0_10   
;f.gr_0_0.10_ 0_15   f.gr_0_0.10_ 0_20   f.gr_0_0.10_ 1_10   f.gr_0_0.10_ 1_20   
;f.gr_10_0.10_ 0_10  f.gr_10_0.10_ 0_20  f.gr_1_0.10_ 0_10   f.gr_1_0.10_ 0_15   
;f.gr_1_0.10_ 0_20   f.gr_2_0.10_ 0_10   f.gr_2_0.10_ 0_15   f.gr_2_0.10_ 0_20   
;f.gr_3_0.10_ 0_10   f.gr_3_0.10_ 0_15   f.gr_3_0.10_ 0_20   f.gr_4_0.10_ 0_10   
;f.gr_4_0.10_ 0_15   f.gr_4_0.10_ 0_20   f.gr_5_0.10_ 0_10   f.gr_5_0.10_ 0_15   
;f.gr_5_0.10_ 0_20   f.gr_6_0.10_ 0_10   f.gr_6_0.10_ 0_20   f.gr_7_0.10_ 0_10   
;f.gr_7_0.10_ 0_20   f.gr_8_0.10_ 0_10   f.gr_8_0.10_ 0_20   f.gr_9_0.10_ 0_10   
;f.gr_9_0.10_ 0_20   
;+------------------------------------------
; % Program caused arithmetic error: Floating divide by 0
tt = read_gdf('tt.fg0020_1819')
plottr,tt
mot=motion(tt)
trb = rm_motion(tt,mot)
plottr,trb
ss = s_autocorreltaion(trb)
; % Variable is undefined: S_AUTOCORRELTAION.
ss = s_autocorrelataion(trb)
; % Variable is undefined: S_AUTOCORRELATAION.
ss = s_autocorrelation(trb)
;      5600.00      1800.00
.run s_autocorrelation
ss = s_autocorrelation(trb)
;      5600.00      1800.00
ss = s_autocorrelation(tt)
;      5600.00      1800.00
trb = rm_motion(tt,mot,smooth=50)
trb = rm_motion(tt,mot,smooth=10)
trb = rm_motion(tt,mot,smooth=1)
trb = rm_motion(tt,mot)
trb = rm_motion(tt,mot,smooth=100)
trb = rm_motion(tt,mot,smooth=200)
ss = s_autocorrelation(trb)
;      5600.00      1800.00
.run s_randomwalkertest
; % Syntax error.
; % 1 Compilation error(s) in module S_RANDOMWALKERTEST.
.run s_randomwalkertest
; % Syntax error.
; % 1 Compilation error(s) in module S_RANDOMWALKERTEST.
dd = fltarr(5,5)
print, dd(3,[0:3])
; % Syntax error.
dd = fltarr(100)
print,dd([0:3])
; % Syntax error.
print,dd[0:3]
;      0.00000      0.00000      0.00000      0.00000
.run s_randomwalkertest
s_randomwalkertest,100,100,option=3
; % Array subscript for RANDOMT2 must have same size as source expression.
.run s_randomwalkertest
s_randomwalkertest,100,100,option=3
; % Array subscript for RANDOMT2 must have same size as source expression.
.run s_randomwalkertest
s_randomwalkertest,100,100,option=3
s_randomwalkertest,100,100,option=3
s_randomwalkertest,1000,100,option=3
s_randomwalkertest,1000,1000,option=3
s_randomwalkertest,100,100,option=3
s_randomwalkertest,100,100,option=2
s_randomwalkertest,100,100,option=1
.run s_randomwalkertest
s_randomwalkertest,100,100,option=2,/ps
s_randomwalkertest,100,100,option=3,/ps
.run s_randomwalkertest
s_randomwalkertest,100,100,option=3
; % Attempt to call undefined procedure/function: 'OPLOTERROR'.
.run oploterror
s_randomwalkertest,100,100,option=3
; % Attempt to call undefined procedure/function: 'CGQUERY'.
.run oploterror
s_randomwalkertest,100,100,option=3
; % Attempt to call undefined procedure/function: 'CGQUERY'.
.run cgquery
s_randomwalkertest,100,100,option=3
; % Attempt to call undefined procedure/function: 'CGPLOT'.
.run cgplot
; % Error opening file. File: cgplot
.run cgplot.pro
; % Error opening file. File: cgplot.pro
.run cgplots
.run cgplot
s_randomwalkertest,100,100,option=3
;Traceback Report from CGPLOT:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOT            317 /home/sungcheolkim/.idl/etc/cgplot.pro
;     %                       OPLOTERROR        208 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGSNAPSHOT'.
;     % Execution halted at:  CGPLOTS           182 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
s_randomwalkertest,100,100,option=3
.run cgsnapshot
s_randomwalkertest,100,100,option=3
;Traceback Report from CGPLOT:
;     % Attempt to call undefined procedure/function: 'CGDEFCHARSIZE'.
;     % Execution halted at:  CGPLOT            399 /home/sungcheolkim/.idl/etc/cgplot.pro
;     %                       OPLOTERROR        208 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOT            195 /home/sungcheolkim/.idl/etc/cgplot.pro
;     %                       OPLOTERROR        208 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOTS           133 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
s_randomwalkertest,100,100,option=3
;Traceback Report from CGPLOT:
;     % Attempt to call undefined procedure/function: 'CGDEFCHARSIZE'.
;     % Execution halted at:  CGPLOT            399 /home/sungcheolkim/.idl/etc/cgplot.pro
;     %                       OPLOTERROR        208 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOTS           133 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOT            195 /home/sungcheolkim/.idl/etc/cgplot.pro
;     %                       OPLOTERROR        208 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOTS           133 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGCOLOR'.
;     % Execution halted at:  CGPLOTS           226 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOTS           133 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOT            195 /home/sungcheolkim/.idl/etc/cgplot.pro
;     %                       OPLOTERROR        208 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOTS           133 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGCOLOR'.
;     % Execution halted at:  CGPLOTS           226 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOTS           133 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOT            195 /home/sungcheolkim/.idl/etc/cgplot.pro
;     %                       OPLOTERROR        208 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOTS           133 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
;Traceback Report from CGPLOTS:
;     % Attempt to call undefined procedure/function: 'CGCOLOR'.
;     % Execution halted at:  CGPLOTS           226 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOTS           133 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOT            195 /home/sungcheolkim/.idl/etc/cgplot.pro
;     %                       OPLOTERROR        208 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       ERROR_MESSAGE     254 /home/sungcheolkim/.idl/coyote/error_message.pro
;     %                       CGPLOTS           133 /home/sungcheolkim/.idl/etc/cgplots.pro
;     %                       OPLOTERROR        248 /home/sungcheolkim/.idl/etc/oploterror.pro
;     %                       S_RANDOMWALKERTEST   44 /home/sungcheolkim/.idl/new/s_randomwalkertest.pro
;     %                       $MAIN$          
