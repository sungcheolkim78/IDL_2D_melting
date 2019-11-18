function fedof,a=a,NA=NA,magnification=magnification

epsilon = 0.1
lambda = 500.0
refractiveIndex = 1.333
if not keyword_set(magnification) then magnification = 60.0
if not keyword_set(NA) then NA = 1.2
if not keyword_set(a) then a = 50.0
a = double(a)
NA = double(NA)
magnification = double(magnification)

alpha = (refractiveIndex/NA)^2-1.0
h1 = (1.0-sqrt(epsilon))/sqrt(epsilon)
h2 = a^2*alpha
h3 =1.49*lambda^2*alpha^2
h4 = (magnification+1.0)^2/(4*magnification^2)

print, alpha, h1, h2, h3, h4

return, sqrt(h1*(h2+h3*h4))

end
