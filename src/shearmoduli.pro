;Name:    Shearmoduli
;Purpose: compute shear modulus of every single spring of particle pairs in 2DCC.
;         decompose the positions of the particles into the components along the axes,  using the equi-partition principle
;Input:   tt pointer for the file "tt.DS0_100", startframe and stopframe
;Function:Findnn, used to find the index of the nearest neighbour of a particle (index) in certain direction in equiposition
;
;Hisotry:
;         Created by Lichao Yu, 6:00PM 10/29/2011
;         Modified by Lichao YU 5:30PM 10/31/2011 changed the algorithm
;         
; 



function Findnn, x, y, index, factor, partn=partn
    flag = 0
    np = n_elements(x)
    for i = 0, np-1 do begin
        
        dis = sqrt((x(i)-x(index))^2 + (y(i)-y(index))^2)
        if dis lt 13.5*factor and dis gt 12.5*factor and (x(i)-x(index)) gt 0 then begin
            case partn of
                +1:   if (y(i)-y(index)) gt 1.73*(x(i)-x(index)) then begin 
                          rightindex = i
                          flag = 1
                      endif            
                -1:   if (-y(i)+y(index)) lt 1.73*(x(i)-x(index)) and (-y(i)+y(index)) gt 0.577*(x(i)-x(index)) then begin 
                          rightindex = i
                          flag = 1
                      endif   
                 0:   if 1.73*(y(i)-y(index)) lt (x(i)-x(index)) then begin 
                          rightindex = i
                          flag = 1
                      endif                   
            endcase
            if flag then break
        endif
    endfor
    
    if not flag then rightindex=10000
    return, rightindex    
end


pro Shearmoduli, tt, startf, stopf, wing=wing, partner=partner, lenscale=lenscale, plotoption=plotoption, combine=combine, testmode=testmode, maxhist=maxhist
on_error,2

if not keyword_set(wing) then wing=0           ; default is left wing, pointing upwards; wing=1, pointing downwards
if not keyword_set(partner) then partner=0     ; default is partner=0, x direction partner.
if not keyword_set(lenscale) then lenscale=2     ; default is lenscale=2, this can be integer.
if not keyword_set(plotoption) then plotoption=0     ; default is plotoption=0 plot shear modulus; if plotoption=1, plot u1-u2
if not keyword_set(combine) then combine=0
if not keyword_set(testmode) then testmode=0   ; in test mode, default filename become "testmode", in avoid of naming confliction.
if not keyword_set(maxhist) then maxhist=100
bins = 0.1*maxhist/100

if testmode then filename = 'testmode.eps'
if not testmode then  filename = 'sheartest(wing='+strtrim(string(wing),2)+',lenscale='+strtrim(string(lenscale),2)+',partner='+strtrim(string(partner),2)+').eps'
  thisDevice = !D.NAME
  set_plot,'ps'
  !p.font=0
  ;!p.thick=1.4
  ;!p.charsize=1.6
  device,file=filename,/encapsulate,/color,bits_per_pixel=8,/helvetica

dia = 0.36
spacing = 13           ; lattice constant = 13 pixels.  
PI = 3.14159
constant = 4.78046     ; constant=kb*T*2/sqrt3= 4.78*10E-21 Joule.
                       ; if 1 pixel=0.083um, constant= 6.93927*10E-7 Joule per m2==N per m
                       ; it seems we need to add a radius thickness to modify the unit of shear modulus to N/m2=Pa
                       ; if diameter=0.36um, we get the final result to be: 1.936 Pa


framenumber = stopf-startf+1
partnumber = max(tt(6,*))+1
positionX = fltarr(partnumber)
positionY = fltarr(partnumber)
shear = dblarr(framenumber, partnumber)
count = fltarr(partnumber)

ntt = n_elements(tt(0,*))
for i = 0, ntt-1 do begin
    positionX[tt[6,i]] += tt[0,i]
    positionY[tt[6,i]] += tt[1,i]
    count[tt[6,i]] +=1
endfor 

maxcount = max(count)

for i=0, partnumber-1 do begin
    positionX[i] /=count[i]   ;equi-position
    positionY[i] /=count[i]
    ;xyouts, positionX[i], positionY[i], strtrim(string(uint(p(6,i))),2), color=fsc_color('brown'),/normal,charsize=0.8 
endfor 

;equipostion = plot(positionX, positionY, linestyle=' ', symbol='d')

;for j = 0, partnumber-1 do begin
;    positionX[j]=0
;    positionY[j]=0
;    for i = startf, stopf do begin
;        p= tt(*,where(tt(5,*) eq i))
;        np = n_elements(p)
;        if j lt np then begin
;           positionX[j] += p(0,j)
;           positionY[j] += p(1,j) 
;        endif  
;    endfor
;    
;    positionX[j] /=framenumber
;   positionY[j] /=framenumber
;endfor

;p = tt(*,where(tt(5,*) eq 0))
;triangulate, p(0,*), p(1,*), conn=con


for i = startf, stopf do begin
    p = tt(*,where(tt(5,*) eq i))
    np = n_elements(p(0,*))

    for j = 0, np-1 do begin      
     
        if (p(0,j) gt 30) and (p(0,j) lt 160) and (p(1,j) gt 30) and (p(1,j) lt 160) then begin

            for k=0, partnumber-1 do begin
                if sqrt((positionX[k]-p(0,j))^2 + (positionY[k]-p(1,j))^2) lt 8 then begin
                    eq1=k
                    break
                endif
            endfor
                  
            eq2 = Findnn(positionX, positionY, eq1, lenscale, partn=partner)
            if eq2 eq 10000 then continue
            if count[eq2] lt 0.95*maxcount then continue  ; eluminate the boundary/partial particles
            ;eq2 = Findnn(positionX, positionY, l, 1, partn=partner) 
            ;if k eq 10000 then continue 

            for m=0, np-1 do begin
                if sqrt((positionX[eq2]-p(0,m))^2 + (positionY[eq2]-p(1,m))^2) lt 8 then begin
                    k = m
                    break
                endif
            endfor
                                    
            a = positionX[eq2]-positionX[eq1]
            b = positionY[eq2]-positionY[eq1]
            len = sqrt(a^2+b^2)
            
            c = p(0,j)-positionX[eq1]
            d = p(1,j)-positionY[eq1]
            e = p(0,k)-positionX[eq2]
            f = p(1,k)-positionY[eq2]
            a1 = 0.5*(a-sqrt(3)*b)
            b1 = 0.5*(b+sqrt(3)*a)
            a2 = 0.5*(a+sqrt(3)*b)
            b2 = 0.5*(b-sqrt(3)*a)
            if wing then begin
                u1 = (c*a2+d*b2)/len
                u2 = (e*a2+f*b2)/len
            endif else begin
                u1 = (c*a1+d*b1)/len
                u2 = (e*a1+f*b1)/len
            endelse 
            if plotoption eq 0 then shear(i,j) = constant/((u1-u2)^2)  else shear(i,j) = u1-u2
        endif  
    endfor
endfor

coun=0
for i = startf, stopf do begin
    for j = 0, partnumber-1 do begin
        if shear(i,j) ne 0 then coun +=1
        
    endfor
endfor

s = fltarr(coun+1)  ;eluminate zero term in s vector to plot histogram
print,coun

cou=0
for i = startf, stopf do begin
    for j = 0, partnumber-1 do begin
        if shear(i,j) ne 0  then begin
            s[cou] = shear(i,j) 
            cou +=1
        endif
    endfor
endfor

case plotoption of
      0: cghistoplot, s, xtitle='Shear Modulus',ytitle='frequency', binsize=bins, mininput=0, maxinput=maxhist 
      1: cghistoplot, s, xtitle='Relative Displacement',ytitle='frequency', binsize=1E-2, mininput=-5, maxinput=5
      2: histogauss, s, A, CHARSIZE=1.2
endcase

;cgplot, histogram(s, binsize=1E-1, Min=0, Max=100)
;plot_hist, s, xrange=[0,0.01], binsize=1E-5

;out put
  device,/close
  set_plot,thisDevice
  erase
  !p.font=-1
  !p.multi=[0,1,1]
  
  case !version.os of
    'Win32': begin
     cmd = '"c:\Program Files\Ghostgum\gsview\gsview64.exe "'
     spawn,[cmd,filename],/log_output,/noshell
     end
    'darwin':  spawn,'gv '+filename
    else:  spawn,'gv '+filename
  endcase
  
end