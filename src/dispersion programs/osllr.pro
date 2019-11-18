;Description: Ordinary least squares Linear regression

Function OSLLR, xx, yy
On_error, 2  

 x = double(xx)
 y = double(yy)
 rn = N_elements(x)
 
 xavg = total( x)/rn
 yavg = total( y)/rn
 x = x - xavg
 y = y - yavg
 sxx = total( x^2)
 syy = total( y^2)
 sxy = total( x*y)
 
 slope = sxy / sxx
 inters = yavg - slope*xavg
 
 sum = total( ( x*( y - slope*x ) )^2)/rn
 err_slope = sum / sxx^2
 err_inters = total( ( ( y - slope*x) * (1.D - rn*xavg*x/sxx) )^2 )/rn
 
 results = dblarr(4)
 results(0) = slope
 results(1) = inters
 results(2) = err_slope
 results(3) = err_inters
 
 return, results

end 