pro polarellipsefit_mpfitfun, x, y, param, yfit

; Need to be given x, y values

fit = 'sqrt((p(0)^2*p(1)^2)/((p(0)^2+p(1)^2)/2 - ((p(0)^2-p(1)^2)/2)*cos(2*x-2*p(2))))'

parinfo = replicate({value:0.D,fixed:0,limited:[0,0],limits:[0.D,0]},3)

parinfo(*).value = [2.,4.,10.]

param = mpfitexpr(fit,x,y,y*0.1,parinfo=parinfo,perror=perror,yfit=yfit)


end

